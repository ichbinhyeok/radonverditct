param(
    [string]$OutputPath = "data/va_radon_measurements.json",
    [string]$RawTablePath = "data/va_vdh_radon_ocr_table.json"
)

$ErrorActionPreference = "Stop"

$sourceUrl = "https://www.vdh.virginia.gov/environmental-public-health-tracking/radon/radon-testing-results/"
$tableauUrl = "https://public.tableau.com/views/VirginiaRadonTestingResults/VirginiaRadonTestResults"
$sourceName = "Virginia Department of Health Radon Testing Results"
$period = "2016-2024"
$retrievedAt = "2026-05-06"
$caveat = "VDH says the map displays indoor air radon results received by its Radon Program from 2016-2024, using voluntary reports from five major radon test-kit vendors and professional testers after removing duplicates, post-mitigation tests, inappropriate locations, upper-floor tests, and incomplete addresses. VDH suppresses locality averages when fewer than 25 tests are available. RadonVerdict normalized the rendered VDH Tableau table because Tableau Public summary data, crosstab, and workbook export are permission-denied."

function Normalize-Name($value) {
    if ($null -eq $value) {
        return ""
    }
    $text = "$value".Trim().ToLowerInvariant()
    $text = $text -replace "\s+county$", ""
    $text = $text -replace "\s+city$", ""
    return $text -replace "[^a-z0-9]", ""
}

function Round-Nullable($value, [int]$digits = 1) {
    if ($null -eq $value) {
        return $null
    }
    return [math]::Round([double]$value, $digits)
}

function Is-City($county) {
    return "$($county.county_slug)".EndsWith("-city")
}

function Resolve-VaLocality($record, $countyByQualifiedKey, $countyByNameKey, $rawNameSet) {
    $name = "$($record.locality)".Trim()
    $nameKey = Normalize-Name $name

    if ($name -eq "Charles City") {
        return @($countyByNameKey["charles"] | Select-Object -First 1)[0]
    }

    if ($name.EndsWith(" County")) {
        $key = (Normalize-Name $name) + "county"
        if ($countyByQualifiedKey.ContainsKey($key)) {
            return $countyByQualifiedKey[$key]
        }
    }

    if ($name.EndsWith(" City")) {
        $key = (Normalize-Name $name) + "city"
        if ($countyByQualifiedKey.ContainsKey($key)) {
            return $countyByQualifiedKey[$key]
        }
    }

    $matches = @($countyByNameKey[$nameKey])
    if ($matches.Count -eq 1) {
        return $matches[0]
    }

    if ($matches.Count -gt 1) {
        $countyVariantKey = Normalize-Name ($name + " County")
        $hasCountyVariant = $rawNameSet.ContainsKey($countyVariantKey)
        if ($hasCountyVariant) {
            $city = @($matches | Where-Object { Is-City $_ } | Select-Object -First 1)
            if ($city.Count -eq 1) {
                return $city[0]
            }
        }
    }

    return $null
}

if (-not (Test-Path -LiteralPath $RawTablePath)) {
    throw "Missing Virginia raw VDH table at $RawTablePath."
}

$geo = Get-Content -LiteralPath "src/main/resources/data/geo_counties.json" -Raw | ConvertFrom-Json
$rawPayload = Get-Content -LiteralPath $RawTablePath -Raw | ConvertFrom-Json
$rawRecords = @($rawPayload.records)

$vaCounties = @($geo | Where-Object { $_.state_abbr -eq "VA" })
$countyByQualifiedKey = @{}
$countyByNameKey = @{}
foreach ($county in $vaCounties) {
    $nameKey = Normalize-Name $county.county_name
    if (-not $countyByNameKey.ContainsKey($nameKey)) {
        $countyByNameKey[$nameKey] = @()
    }
    $countyByNameKey[$nameKey] += $county

    $qualifiedSuffix = if (Is-City $county) { "city" } else { "county" }
    $countyByQualifiedKey[$nameKey + $qualifiedSuffix] = $county
}

$rawNameSet = @{}
foreach ($record in $rawRecords) {
    $rawNameSet[(Normalize-Name $record.locality)] = $true
}

$unmatched = @()
$records = foreach ($record in $rawRecords) {
    $county = Resolve-VaLocality $record $countyByQualifiedKey $countyByNameKey $rawNameSet
    if ($null -eq $county) {
        $unmatched += $record.locality
        continue
    }

    [ordered]@{
        county_fips = $county.fips
        state_abbr = "VA"
        county_name = $county.county_name
        source_id = "va_vdh_radon"
        source_name = $sourceName
        source_url = $sourceUrl
        period = $period
        retrieved_at = $retrievedAt
        caveat = $caveat
        metrics = [ordered]@{
            total_tests = Round-Nullable $record.test_count 0
            average_test_result_pci_l = Round-Nullable $record.average_pci_l 1
            arithmetic_mean_radon_value_pci_l = Round-Nullable $record.average_pci_l 1
            maximum_test_result_pci_l = Round-Nullable $record.max_pci_l 1
            vdh_average_suppressed_below_25_tests = [bool]$record.average_suppressed
        }
    }
}

if ($unmatched.Count -gt 0) {
    throw "Unmatched Virginia localities from VDH table: $($unmatched -join ', ')"
}

$records = @($records | Sort-Object { $_["state_abbr"] }, { $_["county_name"] }, { $_["county_fips"] })
$json = $records | ConvertTo-Json -Depth 10
Set-Content -LiteralPath $OutputPath -Value $json -Encoding UTF8

Write-Host "Wrote $($records.Count) VA locality radon measurement records from $tableauUrl to $OutputPath"
