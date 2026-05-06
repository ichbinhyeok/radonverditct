param(
    [string]$OutputPath = "data/ut_radon_measurements.json"
)

$ErrorActionPreference = "Stop"

$sourceUrl = "https://ibis.utah.gov/epht-view/query/selection/radon/RadonSelection.html"
$sourceName = "Utah EPHT Radon Test Kit Results"
$period = "2006-2019"
$retrievedAt = "2026-05-06"
$caveat = "Utah EPHT says the Indoor Radon Program receives radon test results from test kits purchased through its subsidized program; home radon tests purchased and conducted outside of this program are not included. These are short-term tests in private homes, below-detect results are halved, and county values are reported test records rather than a statistically designed survey of every home."
$baseUrl = "https://ibis.utah.gov/epht-view"

function Normalize-Name($value) {
    if ($null -eq $value) {
        return ""
    }
    return ("$value".Trim().ToLowerInvariant() -replace "\s+county$", "" -replace "[^a-z0-9]", "")
}

function Escape-Pair([string]$name, [string]$value) {
    return [uri]::EscapeDataString($name) + "=" + [uri]::EscapeDataString($value)
}

function Parse-Number($value) {
    if ($null -eq $value) {
        return $null
    }

    $text = [System.Net.WebUtility]::HtmlDecode("$value")
    $text = $text -replace "<[^>]+>", ""
    $text = $text -replace ",", ""
    $text = $text -replace "\*", ""
    $text = $text -replace "\s+", ""
    if ([string]::IsNullOrWhiteSpace($text)) {
        return $null
    }

    $number = 0.0
    if ([double]::TryParse($text, [System.Globalization.NumberStyles]::Float, [System.Globalization.CultureInfo]::InvariantCulture, [ref]$number)) {
        return $number
    }
    return $null
}

function Round-Nullable($value, [int]$digits = 1) {
    if ($null -eq $value) {
        return $null
    }
    return [math]::Round([double]$value, $digits)
}

function Invoke-IbisQuery($configurationPath, [string[]]$extraPairs) {
    $session = New-Object Microsoft.PowerShell.Commands.WebRequestSession
    $session.Cookies.Add((New-Object System.Net.Cookie("UsageAgreement", "shown", "/epht-view/", "ibis.utah.gov")))

    $pairs = @()
    $pairs += Escape-Pair "Year" "Year"
    foreach ($year in 2006..2019) {
        $pairs += Escape-Pair "Year" "$year"
    }
    $pairs += $extraPairs
    $pairs += Escape-Pair "GeoProxy" "GeoCnty"
    $pairs += Escape-Pair "GeoCnty" ""
    $pairs += Escape-Pair "_CategoryGroupByDimensionName" "GeoProxy"
    $pairs += Escape-Pair "_SeriesGroupByDimensionName" ""
    $pairs += Escape-Pair "_ChartName" "None"

    $body = $pairs -join "&"
    $submitUrl = "$baseUrl/query/submit/radon/$configurationPath.html"
    $resultUrl = "$baseUrl/query/result/radon/$configurationPath.xls?PrinterFriendly=x"

    Invoke-WebRequest -UseBasicParsing -WebSession $session -Method Post -Uri $submitUrl -ContentType "application/x-www-form-urlencoded" -Body $body | Out-Null
    Start-Sleep -Seconds 5
    $response = Invoke-WebRequest -UseBasicParsing -WebSession $session -Uri $resultUrl
    if ($response.Content -is [byte[]]) {
        return [System.Text.Encoding]::GetEncoding("ISO-8859-1").GetString($response.Content)
    }
    return "$($response.Content)"
}

function Parse-IbisRows([string]$html) {
    $rowPattern = '<tr><th scope="row" title="GeoCnty: (?<geo>\d+)">(?<county>[^<]+)</th><th[^>]*>.*?</th>(?<cells>.*?)</tr>'
    $cellPattern = '<td class="Value"(?: title="(?<title>[^"]*)")?[^>]*>(?<text>.*?)</td>'
    $rows = @{}

    foreach ($row in [regex]::Matches($html, $rowPattern, [System.Text.RegularExpressions.RegexOptions]::Singleline)) {
        $geoId = $row.Groups["geo"].Value
        $countyName = [System.Net.WebUtility]::HtmlDecode($row.Groups["county"].Value).Trim()
        if ($geoId -eq "99" -or $countyName -eq "Unknown") {
            continue
        }

        $values = @()
        foreach ($cell in [regex]::Matches($row.Groups["cells"].Value, $cellPattern, [System.Text.RegularExpressions.RegexOptions]::Singleline)) {
            $raw = if ($cell.Groups["title"].Success -and -not [string]::IsNullOrWhiteSpace($cell.Groups["title"].Value)) {
                $cell.Groups["title"].Value
            } else {
                $cell.Groups["text"].Value
            }
            $values += Parse-Number $raw
        }

        $rows[(Normalize-Name $countyName)] = [ordered]@{
            geo_id = $geoId
            county_name = $countyName
            values = $values
        }
    }

    return $rows
}

$averageHtml = Invoke-IbisQuery "Radon/Average" @()
$countTotalHtml = Invoke-IbisQuery "RadonNumberTest/Count" @(
    (Escape-Pair "MeasureProxy" "TestCount"),
    (Escape-Pair "TestCount" "1")
)
$countHighHtml = Invoke-IbisQuery "RadonNumberTest/Count" @(
    (Escape-Pair "TestCat3" "3"),
    (Escape-Pair "MeasureProxy" "TestCount"),
    (Escape-Pair "TestCount" "1")
)
$medianMaxHtml = Invoke-IbisQuery "RadonTestResult/Count" @()

$averageByCounty = Parse-IbisRows $averageHtml
$countByCounty = Parse-IbisRows $countTotalHtml
$highCountByCounty = Parse-IbisRows $countHighHtml
$medianMaxByCounty = Parse-IbisRows $medianMaxHtml

$geo = Get-Content -LiteralPath "src/main/resources/data/geo_counties.json" -Raw | ConvertFrom-Json
$utCounties = @($geo | Where-Object { $_.state_abbr -eq "UT" })
$countyByNameKey = @{}
foreach ($county in $utCounties) {
    $countyByNameKey[(Normalize-Name $county.county_name)] = $county
}

$records = foreach ($key in ($countyByNameKey.Keys | Sort-Object)) {
    $county = $countyByNameKey[$key]
    $average = if ($averageByCounty.ContainsKey($key)) { $averageByCounty[$key].values[0] } else { $null }
    $totalTests = if ($countByCounty.ContainsKey($key)) { $countByCounty[$key].values[0] } else { $null }
    $above4Count = if ($highCountByCounty.ContainsKey($key)) { $highCountByCounty[$key].values[0] } else { $null }
    $median = if ($medianMaxByCounty.ContainsKey($key)) { $medianMaxByCounty[$key].values[0] } else { $null }
    $maximum = if ($medianMaxByCounty.ContainsKey($key)) { $medianMaxByCounty[$key].values[1] } else { $null }
    $above4Pct = if ($null -ne $totalTests -and $totalTests -gt 0 -and $null -ne $above4Count) {
        ($above4Count / $totalTests) * 100.0
    } else {
        $null
    }

    [ordered]@{
        county_fips = $county.fips
        state_abbr = "UT"
        county_name = $county.county_name
        source_id = "ut_epht_radon"
        source_name = $sourceName
        source_url = $sourceUrl
        period = $period
        retrieved_at = $retrievedAt
        caveat = $caveat
        metrics = [ordered]@{
            total_tests = Round-Nullable $totalTests 0
            average_test_result_pci_l = Round-Nullable $average 1
            arithmetic_mean_radon_value_pci_l = Round-Nullable $average 1
            median_radon_value_pci_l = Round-Nullable $median 1
            maximum_test_result_pci_l = Round-Nullable $maximum 1
            number_properties_at_or_above_4_pci_l = Round-Nullable $above4Count 0
            percent_tests_at_or_above_4_pci_l = Round-Nullable $above4Pct 1
        }
    }
}

$json = @($records | Sort-Object { $_["state_abbr"] }, { $_["county_name"] }, { $_["county_fips"] }) | ConvertTo-Json -Depth 10
Set-Content -LiteralPath $OutputPath -Value $json -Encoding UTF8

Write-Host "Wrote $($records.Count) UT county radon measurement records from $sourceUrl to $OutputPath"
