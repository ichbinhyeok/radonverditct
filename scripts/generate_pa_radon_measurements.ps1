param(
    [string]$OutputPath = "data/pa_radon_measurements.json",
    [string[]]$CountyFips = @("42003", "42017", "42029", "42045", "42049"),
    [string]$CacheDir = "data/pa_radon_zip_cache",
    [int]$MaxConcurrency = 12,
    [switch]$UseRetainedPriorityCounties,
    [switch]$RefreshCache
)

$ErrorActionPreference = "Stop"

$reportCsvBaseUrl = "http://cedatareporting.pa.gov/Reportserver?/Public/DEP/RP/SSRS/RadonZip&rs:Command=Render&rs:Format=CSV&P_ZIP_CODE="
$sourceUrl = "https://www.pa.gov/agencies/dep/data-and-tools/reports/radiation-protection-reports"
$retrievedAt = "2026-05-05"
$period = "1990-2025"
$sourceName = "Pennsylvania DEP Radon Test Data by ZIP Code"
$caveat = "PA DEP Radon Division ZIP reports are based on short-term closed-house radon tests submitted by certified radon laboratories and testers from January 1990 through December 2025. PA DEP does not report an average when a ZIP has fewer than 30 tests. RadonVerdict rolls ZIP rows up to primary counties and treats the basement average as the primary local signal while preserving first-floor context."

function To-NullableDouble($value) {
    if ($null -eq $value) {
        return $null
    }
    $text = "$value".Trim()
    if ($text -eq "" -or $text -eq "NA" -or $text -eq "Suppressed" -or $text -eq "Insufficient Data") {
        return $null
    }
    return [double]$text
}

function Round-Nullable($value, [int]$digits = 1) {
    if ($null -eq $value) {
        return $null
    }
    return [math]::Round([double]$value, $digits)
}

function Get-ZipFips($zipMap, [string]$zip) {
    $property = $zipMap.PSObject.Properties[$zip]
    if ($null -eq $property) {
        return $null
    }
    return "$($property.Value)"
}

function Add-Max($current, $candidate) {
    if ($null -eq $candidate) {
        return $current
    }
    if ($null -eq $current -or $candidate -gt $current) {
        return $candidate
    }
    return $current
}

function Convert-ZipRows([string]$content) {
    $content = $content.TrimStart([char]0xFEFF)
    if ([string]::IsNullOrWhiteSpace($content)) {
        return @()
    }
    return @($content | ConvertFrom-Csv)
}

function Load-ZipCsvContents($zips) {
    $contents = @{}
    $missingZips = @()

    foreach ($zip in $zips) {
        $cachePath = Join-Path $CacheDir "$zip.csv"
        if ((-not $RefreshCache) -and (Test-Path -LiteralPath $cachePath)) {
            $contents[$zip] = Get-Content -LiteralPath $cachePath -Raw
        } else {
            $missingZips += $zip
        }
    }

    if ($missingZips.Count -eq 0) {
        Write-Host "Using cached PA ZIP CSV exports for all $($zips.Count) ZIP codes."
        return $contents
    }

    Write-Host "Fetching $($missingZips.Count) uncached PA ZIP CSV exports with concurrency $MaxConcurrency..."
    Add-Type -AssemblyName System.Net.Http
    $client = [System.Net.Http.HttpClient]::new()
    $client.Timeout = [TimeSpan]::FromSeconds(75)

    try {
        for ($offset = 0; $offset -lt $missingZips.Count; $offset += $MaxConcurrency) {
            $batch = @($missingZips | Select-Object -Skip $offset -First $MaxConcurrency)
            $requests = @()
            foreach ($zip in $batch) {
                $url = $reportCsvBaseUrl + [uri]::EscapeDataString($zip)
                $requests += [pscustomobject]@{
                    Zip = $zip
                    Task = $client.GetStringAsync($url)
                }
            }

            $tasks = [Threading.Tasks.Task[]]@($requests | ForEach-Object { $_.Task })
            [Threading.Tasks.Task]::WaitAll($tasks)

            foreach ($request in $requests) {
                $content = $request.Task.Result
                $cachePath = Join-Path $CacheDir "$($request.Zip).csv"
                Set-Content -LiteralPath $cachePath -Value $content -Encoding UTF8
                $contents[$request.Zip] = $content
            }

            $processed = [math]::Min($offset + $batch.Count, $missingZips.Count)
            Write-Host "Fetched PA ZIP CSV exports $processed/$($missingZips.Count)"
        }
    }
    finally {
        $client.Dispose()
    }

    return $contents
}

$geo = Get-Content -LiteralPath "src/main/resources/data/geo_counties.json" -Raw | ConvertFrom-Json
$zipMap = Get-Content -LiteralPath "src/main/resources/data/zip_primary_county.json" -Raw | ConvertFrom-Json
New-Item -ItemType Directory -Path $CacheDir -Force | Out-Null

$paCountiesByFips = @{}
foreach ($county in $geo) {
    if ($county.state_abbr -eq "PA") {
        $paCountiesByFips[$county.fips] = $county
    }
}

if ($UseRetainedPriorityCounties) {
    $retainedPath = "data/retained_priority_counties.csv"
    if (Test-Path -LiteralPath $retainedPath) {
        $CountyFips = @(
            Import-Csv -LiteralPath $retainedPath |
                Where-Object { $_.state -eq "PA" } |
                ForEach-Object { $_.fips } |
                Sort-Object -Unique
        )
    } else {
        throw "Cannot use retained PA counties because $retainedPath was not found."
    }
}

$targetFipsSet = @{}
foreach ($fips in $CountyFips) {
    if (-not $paCountiesByFips.ContainsKey($fips)) {
        throw "County FIPS $fips is not a Pennsylvania county in geo_counties.json."
    }
    $targetFipsSet[$fips] = $true
}

$targetZips = @($zipMap.PSObject.Properties |
    Where-Object { $targetFipsSet.ContainsKey("$($_.Value)") } |
    ForEach-Object { $_.Name } |
    Sort-Object)

Write-Host "Fetching PA DEP radon ZIP report rows for $($targetFipsSet.Count) county/county group(s), $($targetZips.Count) ZIP codes..."
$zipContents = Load-ZipCsvContents $targetZips

$rollups = @{}
foreach ($fips in $targetFipsSet.Keys) {
    $rollups[$fips] = [ordered]@{
        county = $paCountiesByFips[$fips]
        basement_tests = 0.0
        basement_average_weighted_sum = 0.0
        basement_average_weight = 0.0
        basement_maximum = $null
        first_floor_tests = 0.0
        first_floor_average_weighted_sum = 0.0
        first_floor_average_weight = 0.0
        first_floor_maximum = $null
    }
}

$processed = 0
foreach ($zip in $targetZips) {
    $processed++
    if ($processed -eq 1 -or $processed % 10 -eq 0 -or $processed -eq $targetZips.Count) {
        Write-Host "PA ZIP $processed/$($targetZips.Count): $zip"
    }

    $fips = Get-ZipFips $zipMap $zip
    $rollup = $rollups[$fips]
    $rows = Convert-ZipRows $zipContents[$zip]
    foreach ($row in $rows) {
        if ([string]::IsNullOrWhiteSpace($row.LOCATION_ZIP_CODE5)) {
            continue
        }

        $location = "$($row.TEST_LOCATION_DESC)".Trim().ToUpperInvariant()
        $tests = To-NullableDouble $row.Num_of_Tests
        $maximum = To-NullableDouble $row.Max_Result_pCiL
        $average = To-NullableDouble $row.Avg_Result_pCiL
        if ($null -eq $tests) {
            continue
        }

        if ($location -eq "BASEMENT") {
            $rollup.basement_tests += $tests
            if ($null -ne $average) {
                $rollup.basement_average_weighted_sum += ($average * $tests)
                $rollup.basement_average_weight += $tests
            }
            $rollup.basement_maximum = Add-Max $rollup.basement_maximum $maximum
        } elseif ($location -eq "FIRST FLOOR") {
            $rollup.first_floor_tests += $tests
            if ($null -ne $average) {
                $rollup.first_floor_average_weighted_sum += ($average * $tests)
                $rollup.first_floor_average_weight += $tests
            }
            $rollup.first_floor_maximum = Add-Max $rollup.first_floor_maximum $maximum
        }
    }
}

$records = foreach ($fips in ($rollups.Keys | Sort-Object)) {
    $rollup = $rollups[$fips]
    $county = $rollup.county
    $totalTests = $rollup.basement_tests + $rollup.first_floor_tests
    if ($totalTests -le 0) {
        continue
    }

    $basementAverage = if ($rollup.basement_average_weight -gt 0) {
        [math]::Round($rollup.basement_average_weighted_sum / $rollup.basement_average_weight, 1)
    } else {
        $null
    }
    $firstFloorAverage = if ($rollup.first_floor_average_weight -gt 0) {
        [math]::Round($rollup.first_floor_average_weighted_sum / $rollup.first_floor_average_weight, 1)
    } else {
        $null
    }
    $overallAverageWeight = $rollup.basement_average_weight + $rollup.first_floor_average_weight
    $overallAverage = if ($overallAverageWeight -gt 0) {
        [math]::Round(($rollup.basement_average_weighted_sum + $rollup.first_floor_average_weighted_sum) / $overallAverageWeight, 1)
    } else {
        $null
    }
    $primaryAverage = if ($null -ne $basementAverage) { $basementAverage } else { $overallAverage }
    $maximum = Add-Max $rollup.basement_maximum $rollup.first_floor_maximum
    $basementShare = if ($totalTests -gt 0) { [math]::Round(($rollup.basement_tests / $totalTests) * 100.0, 1) } else { $null }
    $firstFloorShare = if ($totalTests -gt 0) { [math]::Round(($rollup.first_floor_tests / $totalTests) * 100.0, 1) } else { $null }

    [ordered]@{
        county_fips = $county.fips
        state_abbr = "PA"
        county_name = $county.county_name
        source_id = "pa_dep_radon_zip"
        source_name = $sourceName
        source_url = $sourceUrl
        period = $period
        retrieved_at = $retrievedAt
        caveat = $caveat
        metrics = [ordered]@{
            total_tests = Round-Nullable $totalTests 0
            average_test_result_pci_l = $primaryAverage
            arithmetic_mean_radon_value_pci_l = $overallAverage
            maximum_test_result_pci_l = Round-Nullable $maximum 1
            basement_test_count = Round-Nullable $rollup.basement_tests 0
            basement_average_test_result_pci_l = $basementAverage
            basement_maximum_test_result_pci_l = Round-Nullable $rollup.basement_maximum 1
            first_floor_test_count = Round-Nullable $rollup.first_floor_tests 0
            first_floor_average_test_result_pci_l = $firstFloorAverage
            first_floor_maximum_test_result_pci_l = Round-Nullable $rollup.first_floor_maximum 1
            percent_tests_basement = $basementShare
            percent_tests_first_floor = $firstFloorShare
        }
    }
}

$records = @($records | Sort-Object { $_["state_abbr"] }, { $_["county_name"] })
$json = $records | ConvertTo-Json -Depth 10
Set-Content -LiteralPath $OutputPath -Value $json -Encoding UTF8

Write-Host "Wrote $($records.Count) PA county radon measurement records to $OutputPath"
