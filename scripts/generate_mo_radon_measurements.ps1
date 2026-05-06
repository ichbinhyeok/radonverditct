param(
    [string]$OutputPath = "data/mo_radon_measurements.json"
)

$ErrorActionPreference = "Stop"

$sourceUrl = "https://ephtn.dhss.mo.gov/EPHTN_Data_Portal/radon/index.php"
$countyLayerUrl = "https://gis.mo.gov/arcgis/rest/services/DHSS/EPHT_radonResidential/MapServer/2"
$pointLayerUrl = "https://gis.mo.gov/arcgis/rest/services/DHSS/EPHT_radonResidential/MapServer/0"
$sourceName = "Missouri DHSS Residential Radon Testing in Missouri"
$period = "2005-2017"
$retrievedAt = "2026-05-06"
$caveat = "Missouri DHSS publishes residential radon testing through a public ArcGIS dashboard. County totals, average final result, and maximum final result come from the county summary layer. RadonVerdict computes the 4.0+ share from non-negative point-level Final_Result records because the point layer also contains -999 privacy/suppression sentinel values. These are reported test records, not a statistically designed survey of every home."

function Normalize-Name($value) {
    if ($null -eq $value) {
        return ""
    }
    $text = "$value".Trim().ToLowerInvariant()
    $text = $text -replace "\s+county$", ""
    $text = $text -replace "\s+city$", " city"
    return $text -replace "[^a-z0-9]", ""
}

function Round-Nullable($value, [int]$digits = 1) {
    if ($null -eq $value) {
        return $null
    }
    return [math]::Round([double]$value, $digits)
}

function Invoke-ArcGisQuery($layerUrl, $params) {
    $pairs = foreach ($key in $params.Keys) {
        [uri]::EscapeDataString([string]$key) + "=" + [uri]::EscapeDataString([string]$params[$key])
    }
    $uri = $layerUrl + "/query?" + ($pairs -join "&")
    return Invoke-RestMethod -Uri $uri
}

function Is-St-Louis-City($record) {
    $county = "$($record.County)"
    $ucase = "$($record.County_Ucase)"
    return (Normalize-Name $county) -eq "stlouiscity" -or (Normalize-Name $ucase) -eq "stlouiscity"
}

$geo = Get-Content -LiteralPath "src/main/resources/data/geo_counties.json" -Raw | ConvertFrom-Json
$moCounties = @($geo | Where-Object { $_.state_abbr -eq "MO" })
$countyByNameKey = @{}
foreach ($county in $moCounties) {
    $key = Normalize-Name $county.county_name
    if (-not $countyByNameKey.ContainsKey($key)) {
        $countyByNameKey[$key] = @()
    }
    $countyByNameKey[$key] += $county
}

$countySummary = Invoke-ArcGisQuery $countyLayerUrl @{
    f = "json"
    where = "1=1"
    outFields = "*"
    returnGeometry = "false"
    resultRecordCount = "2000"
}

$validStats = ConvertTo-Json -InputObject @(
    @{ statisticType = "count"; onStatisticField = "Final_Result"; outStatisticFieldName = "valid_result_count" }
) -Compress
$validSummary = Invoke-ArcGisQuery $pointLayerUrl @{
    f = "json"
    where = "Final_Result >= 0"
    outStatistics = $validStats
    groupByFieldsForStatistics = "County"
    returnGeometry = "false"
}

$above4Stats = ConvertTo-Json -InputObject @(
    @{ statisticType = "count"; onStatisticField = "Final_Result"; outStatisticFieldName = "above4_count" }
) -Compress
$above4Summary = Invoke-ArcGisQuery $pointLayerUrl @{
    f = "json"
    where = "Final_Result >= 4.0"
    outStatistics = $above4Stats
    groupByFieldsForStatistics = "County"
    returnGeometry = "false"
}

$validByCounty = @{}
foreach ($feature in @($validSummary.features)) {
    $key = Normalize-Name $feature.attributes.County
    $validByCounty[$key] = [double]$feature.attributes.valid_result_count
}

$above4ByCounty = @{}
foreach ($feature in @($above4Summary.features)) {
    $key = Normalize-Name $feature.attributes.County
    $above4ByCounty[$key] = [double]$feature.attributes.above4_count
}

$unmatched = @()
$records = foreach ($feature in @($countySummary.features)) {
    $attrs = $feature.attributes
    $key = Normalize-Name $attrs.County
    $lookupKey = if ($key -eq "stlouiscity") { "stlouis" } else { $key }
    $matches = @($countyByNameKey[$lookupKey] | Where-Object { $null -ne $_ })

    if ($matches.Count -gt 1) {
        if (Is-St-Louis-City $attrs) {
            $matches = @($matches | Where-Object { "$($_.county_slug)".EndsWith("-city") })
        } else {
            $matches = @($matches | Where-Object { -not "$($_.county_slug)".EndsWith("-city") })
        }
    }

    if ($matches.Count -ne 1) {
        $unmatched += "$($attrs.County)"
        continue
    }

    $county = $matches[0]
    $validCount = $validByCounty[$key]
    $above4Count = if ($above4ByCounty.ContainsKey($key)) { $above4ByCounty[$key] } else { 0.0 }
    $above4Pct = if ($validCount -gt 0) { ($above4Count / $validCount) * 100.0 } else { $null }

    [ordered]@{
        county_fips = $county.fips
        state_abbr = "MO"
        county_name = $county.county_name
        source_id = "mo_dhss_radon"
        source_name = $sourceName
        source_url = $sourceUrl
        period = $period
        retrieved_at = $retrievedAt
        caveat = $caveat
        metrics = [ordered]@{
            total_tests = Round-Nullable $attrs.Total_Tests 0
            average_test_result_pci_l = Round-Nullable $attrs.Ave_Final_Result 1
            arithmetic_mean_radon_value_pci_l = Round-Nullable $attrs.Ave_Final_Result 1
            maximum_test_result_pci_l = Round-Nullable $attrs.Max_Final_Result 1
            number_properties_at_or_above_4_pci_l = Round-Nullable $above4Count 0
            percent_tests_at_or_above_4_pci_l = Round-Nullable $above4Pct 1
        }
    }
}

if ($unmatched.Count -gt 0) {
    throw "Unmatched Missouri counties from DHSS layer: $($unmatched -join ', ')"
}

$records = @($records | Sort-Object { $_["state_abbr"] }, { $_["county_name"] }, { $_["county_fips"] })
$json = $records | ConvertTo-Json -Depth 10
Set-Content -LiteralPath $OutputPath -Value $json -Encoding UTF8

Write-Host "Wrote $($records.Count) MO county radon measurement records from $countyLayerUrl to $OutputPath"
