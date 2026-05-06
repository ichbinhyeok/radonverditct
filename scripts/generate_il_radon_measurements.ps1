param(
    [string]$OutputPath = "data/il_radon_measurements.json"
)

$ErrorActionPreference = "Stop"

$sourceUrl = "https://iemaohs.illinois.gov/nrs/radon/radonillinois.html"
$layerUrl = "https://services2.arcgis.com/QUAsjBqieHEMNnZW/arcgis/rest/services/Radon_Full/FeatureServer/0"
$sourceName = "Illinois IEMA-OHS Licensed Radon Measurement Dashboard"
$period = "2003-2019"
$retrievedAt = "2026-05-06"
$caveat = "IEMA-OHS says the dashboard is not intended to decide whether a specific home should be tested; all homes should be tested. The measurement data are annual reports submitted by licensed measurement and mitigation professionals for calendar years 2003-2019, using the highest submitted measurement for each address. RadonVerdict stores only county-level aggregates, excludes invalid tests and negative result sentinels, and does not store address-level records."

function Normalize-Name($value) {
    if ($null -eq $value) {
        return ""
    }
    $text = "$value".Trim().ToLowerInvariant()
    $text = $text -replace "\s+county$", ""
    return $text -replace "[^a-z0-9]", ""
}

function Round-Nullable($value, [int]$digits = 1) {
    if ($null -eq $value) {
        return $null
    }
    return [math]::Round([double]$value, $digits)
}

function Invoke-ArcGisQuery($url, $params) {
    $pairs = foreach ($key in $params.Keys) {
        [uri]::EscapeDataString([string]$key) + "=" + [uri]::EscapeDataString([string]$params[$key])
    }
    $uri = $url + "/query?" + ($pairs -join "&")
    $result = Invoke-RestMethod -Uri $uri -TimeoutSec 120
    if ($result.error) {
        throw "ArcGIS query failed: $($result.error.message)"
    }
    return $result
}

$geo = Get-Content -LiteralPath "src/main/resources/data/geo_counties.json" -Raw | ConvertFrom-Json
$ilCounties = @($geo | Where-Object { $_.state_abbr -eq "IL" })
$countyByNameKey = @{}
foreach ($county in $ilCounties) {
    $key = Normalize-Name $county.county_name
    if (-not $countyByNameKey.ContainsKey($key)) {
        $countyByNameKey[$key] = @()
    }
    $countyByNameKey[$key] += $county
}

$outStats = ConvertTo-Json -InputObject @(
    @{ statisticType = "count"; onStatisticField = "Results_DBL"; outStatisticFieldName = "total_tests" },
    @{ statisticType = "avg"; onStatisticField = "Results_DBL"; outStatisticFieldName = "average_result" },
    @{ statisticType = "max"; onStatisticField = "Results_DBL"; outStatisticFieldName = "maximum_result" },
    @{ statisticType = "percentile_cont"; onStatisticField = "Results_DBL"; outStatisticFieldName = "median_result"; statisticParameters = @{ value = 0.5 } },
    @{ statisticType = "percentile_cont"; onStatisticField = "Results_DBL"; outStatisticFieldName = "p95_result"; statisticParameters = @{ value = 0.95 } },
    @{ statisticType = "sum"; onStatisticField = "CASE WHEN Results_DBL >= 4 THEN 1 ELSE 0 END"; outStatisticFieldName = "tests_at_or_above_4" }
) -Compress -Depth 6

$summary = Invoke-ArcGisQuery $layerUrl @{
    f = "json"
    where = "cState = 'IL' AND lValidTest = 1 AND Results_DBL >= 0"
    outStatistics = $outStats
    groupByFieldsForStatistics = "cCntyname"
    returnGeometry = "false"
    resultRecordCount = "2000"
    orderByFields = "cCntyname ASC"
}

$unmatched = @()
$records = foreach ($feature in @($summary.features)) {
    $attrs = $feature.attributes
    $key = Normalize-Name $attrs.cCntyname
    if ([string]::IsNullOrWhiteSpace($key)) {
        continue
    }

    $matches = @($countyByNameKey[$key] | Where-Object { $null -ne $_ })
    if ($matches.Count -ne 1) {
        $unmatched += "$($attrs.cCntyname)"
        continue
    }

    $county = $matches[0]
    $totalTests = [double]$attrs.total_tests
    $above4Count = if ($null -ne $attrs.tests_at_or_above_4) { [double]$attrs.tests_at_or_above_4 } else { 0.0 }
    $above4Pct = if ($totalTests -gt 0) { ($above4Count / $totalTests) * 100.0 } else { $null }

    [ordered]@{
        county_fips = $county.fips
        state_abbr = "IL"
        county_name = $county.county_name
        source_id = "il_iema_radon"
        source_name = $sourceName
        source_url = $sourceUrl
        period = $period
        retrieved_at = $retrievedAt
        caveat = $caveat
        metrics = [ordered]@{
            total_tests = Round-Nullable $totalTests 0
            average_test_result_pci_l = Round-Nullable $attrs.average_result 1
            arithmetic_mean_radon_value_pci_l = Round-Nullable $attrs.average_result 1
            median_radon_value_pci_l = Round-Nullable $attrs.median_result 1
            radon_95th_percentile_pci_l = Round-Nullable $attrs.p95_result 1
            maximum_test_result_pci_l = Round-Nullable $attrs.maximum_result 1
            number_properties_at_or_above_4_pci_l = Round-Nullable $above4Count 0
            percent_tests_at_or_above_4_pci_l = Round-Nullable $above4Pct 1
        }
    }
}

if ($unmatched.Count -gt 0) {
    throw "Unmatched Illinois counties from IEMA-OHS layer: $($unmatched -join ', ')"
}

$records = @($records | Sort-Object { $_["state_abbr"] }, { $_["county_name"] }, { $_["county_fips"] })
$json = $records | ConvertTo-Json -Depth 10
Set-Content -LiteralPath $OutputPath -Value $json -Encoding UTF8

Write-Host "Wrote $($records.Count) IL county radon measurement records from $layerUrl to $OutputPath"
