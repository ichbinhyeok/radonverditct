param(
    [string]$OutputPath = "data/cdc_radon_measurements.json",
    [string]$TemporalItem = "2017",
    [string]$ApiToken = $env:TRACKING_API_TOKEN
)

$ErrorActionPreference = "Stop"

$retrievedAt = "2026-05-05"
$sourceName = "CDC Environmental Public Health Tracking Network Radon Tests from Labs"
$sourceUrl = "https://www.cdc.gov/environmental-health-tracking/php/data-research/radon-testing.html"
$apiBase = "https://ephtracking.cdc.gov/apigateway/api/v1/getCoreHolder"
$caveat = "CDC county summaries are based on national radon testing laboratories and participating state feeds; they are not a statistically designed survey of every home."

function New-CdcUrl([int]$measureId, [int]$stratificationLevelId, [hashtable]$query) {
    $url = "$apiBase/$measureId/$stratificationLevelId/0/0"
    $queryParts = @()
    foreach ($key in $query.Keys) {
        if ($null -ne $query[$key] -and "$($query[$key])" -ne "") {
            $queryParts += "$key=$([uri]::EscapeDataString([string]$query[$key]))"
        }
    }
    if (-not [string]::IsNullOrWhiteSpace($ApiToken)) {
        $queryParts += "apiToken=$([uri]::EscapeDataString($ApiToken))"
    }
    if ($queryParts.Count -gt 0) {
        $url += "?" + ($queryParts -join "&")
    }
    return $url
}

function Invoke-CdcCoreHolder([int]$measureId, [int]$stratificationLevelId, [hashtable]$query) {
    $body = @{
        geographicTypeIdFilter = "ALL"
        geographicItemsFilter = "ALL"
        temporalTypeIdFilter = "2"
        temporalItemsFilter = $TemporalItem
    } | ConvertTo-Json

    $url = New-CdcUrl $measureId $stratificationLevelId $query
    for ($attempt = 1; $attempt -le 4; $attempt++) {
        $response = Invoke-WebRequest -Uri $url -Method Post -ContentType "application/json" -Headers @{ Accept = "application/json" } -Body $body -TimeoutSec 180 -UseBasicParsing
        $payload = $response.Content | ConvertFrom-Json

        if ($payload.code -eq 429) {
            if ($attempt -eq 4) {
                throw "CDC API throttled this request after $attempt attempts: $($payload.message)"
            }
            Start-Sleep -Seconds (15 * $attempt)
            continue
        }

        if (-not $payload.tableResult) {
            throw "CDC API returned no tableResult for measure $measureId."
        }

        return @($payload.tableResult)
    }
}

function To-NullableDouble($value) {
    if ($null -eq $value) {
        return $null
    }
    $text = "$value".Trim()
    if ($text -eq "" -or $text -eq "NA" -or $text -eq "Suppressed" -or $text -eq "-9999") {
        return $null
    }
    return [double]$text
}

function Read-MetricRows([int]$measureId, [int]$stratificationLevelId, [hashtable]$query) {
    $rows = Invoke-CdcCoreHolder $measureId $stratificationLevelId $query
    $map = @{}
    foreach ($row in $rows) {
        if ($row.geoId -and "$($row.geoId)".Length -eq 5) {
            $map["$($row.geoId)"] = To-NullableDouble $row.dataValue
        }
    }
    return $map
}

Write-Host "Fetching CDC radon lab measures for temporal item $TemporalItem..."
$buildingsTested = Read-MetricRows 864 2 @{}
$rateTested = Read-MetricRows 865 2 @{}
$median = Read-MetricRows 870 2 @{}
$maximum = Read-MetricRows 871 2 @{}
$mean = Read-MetricRows 971 2 @{}
$percentBelow2 = Read-MetricRows 868 2189 @{ RadonCutpointId = 1 }
$percent2ToBelow4 = Read-MetricRows 868 2189 @{ RadonCutpointId = 2 }
$percentAtOrAbove4 = Read-MetricRows 868 2189 @{ RadonCutpointId = 3 }
$numberAtOrAbove4 = Read-MetricRows 866 2189 @{ RadonCutpointId = 3 }

$geo = Get-Content -LiteralPath "src/main/resources/data/geo_counties.json" -Raw | ConvertFrom-Json
$geoByFips = @{}
foreach ($county in $geo) {
    $geoByFips[$county.fips] = $county
}

$allFips = @(
    $buildingsTested.Keys
    $rateTested.Keys
    $median.Keys
    $maximum.Keys
    $mean.Keys
    $percentAtOrAbove4.Keys
) | ForEach-Object { $_ } | Sort-Object -Unique

$records = foreach ($fips in $allFips) {
    if (-not $geoByFips.ContainsKey($fips)) {
        continue
    }

    $county = $geoByFips[$fips]
    $testCount = $buildingsTested[$fips]
    $periodStart = [int]$TemporalItem - 9
    $averageTestsPerYear = if ($null -ne $testCount) { [math]::Round($testCount / 10.0, 1) } else { $null }

    [ordered]@{
        county_fips = $county.fips
        state_abbr = $county.state_abbr
        county_name = $county.county_name
        source_id = "cdc_tracking_radon"
        source_name = $sourceName
        source_url = $sourceUrl
        period = "$periodStart-$TemporalItem"
        retrieved_at = $retrievedAt
        caveat = $caveat
        metrics = [ordered]@{
            average_number_of_tests = $averageTestsPerYear
            number_buildings_tested_10_year = $testCount
            rate_housing_units_tested_per_10000 = $rateTested[$fips]
            average_test_result_pci_l = $mean[$fips]
            arithmetic_mean_radon_value_pci_l = $mean[$fips]
            median_radon_value_pci_l = $median[$fips]
            maximum_test_result_pci_l = $maximum[$fips]
            percent_tests_below_2_pci_l = $percentBelow2[$fips]
            percent_tests_2_to_below_4_pci_l = $percent2ToBelow4[$fips]
            percent_tests_at_or_above_4_pci_l = $percentAtOrAbove4[$fips]
            number_pre_mitigation_tests_at_or_above_4_pci_l = $numberAtOrAbove4[$fips]
        }
    }
}

$records = @($records | Sort-Object state_abbr, county_name)
$json = $records | ConvertTo-Json -Depth 10
Set-Content -LiteralPath $OutputPath -Value $json -Encoding UTF8

Write-Host "Wrote $($records.Count) CDC county radon measurement records to $OutputPath"
