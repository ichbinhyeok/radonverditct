param(
    [string]$OutputPath = "data/wi_radon_measurements.json"
)

$ErrorActionPreference = "Stop"

$layerUrl = "https://services1.arcgis.com/ISZ89Z51ft1G16OK/arcgis/rest/services/Wisconsin_Radon_Map_Service/FeatureServer/3"
$sourceUrl = "https://www.dhs.wisconsin.gov/radon/index.htm"
$retrievedAt = "2026-05-05"
$sourceName = "Wisconsin Department of Health Services Indoor Radon Test Results"
$period = "1995-2016"
$caveat = "Wisconsin DHS ZIP-level summaries are based on indoor radon test results from 1995-2016 and are aggregated to county by RadonVerdict using test-count weighting."

function To-NullableDouble($value) {
    if ($null -eq $value) {
        return $null
    }
    $text = "$value".Trim()
    if ($text -eq "" -or $text -eq "NA" -or $text -eq "Suppressed") {
        return $null
    }
    return [double]$text
}

Write-Host "Fetching Wisconsin DHS radon ZIP measures..."
$queryUrl = "${layerUrl}/query?f=json&where=1%3D1&outFields=STATE_CNTY_FIPS,CNTY_NAME_STNDRD,Tests_NUM,Average_NUM,Maximum_NUM,Tests_GTE2_NUM,Tests_GTE4_NUM,Tests_GTE2_Perc_NUM,Tests_GTE4_Perc_NUM&returnGeometry=false&resultRecordCount=2000"
$payload = Invoke-RestMethod -Uri $queryUrl -TimeoutSec 90

if (-not $payload.features) {
    throw "Wisconsin DHS ArcGIS layer returned no radon features."
}

$groups = @{}
foreach ($feature in $payload.features) {
    $row = $feature.attributes
    if ([string]::IsNullOrWhiteSpace($row.STATE_CNTY_FIPS)) {
        continue
    }
    $fips = "$($row.STATE_CNTY_FIPS)".PadLeft(5, "0")
    if (-not $groups.ContainsKey($fips)) {
        $groups[$fips] = [ordered]@{
            county_name = $row.CNTY_NAME_STNDRD
            total_tests = 0.0
            weighted_average_sum = 0.0
            tests_above_2 = 0.0
            tests_above_4 = 0.0
            maximum = $null
        }
    }

    $group = $groups[$fips]
    $tests = To-NullableDouble $row.Tests_NUM
    $average = To-NullableDouble $row.Average_NUM
    $maximum = To-NullableDouble $row.Maximum_NUM
    $above2 = To-NullableDouble $row.Tests_GTE2_NUM
    $above4 = To-NullableDouble $row.Tests_GTE4_NUM

    if ($null -ne $tests) {
        $group.total_tests += $tests
        if ($null -ne $average) {
            $group.weighted_average_sum += ($average * $tests)
        }
    }
    if ($null -ne $above2) {
        $group.tests_above_2 += $above2
    }
    if ($null -ne $above4) {
        $group.tests_above_4 += $above4
    }
    if ($null -ne $maximum -and ($null -eq $group.maximum -or $maximum -gt $group.maximum)) {
        $group.maximum = $maximum
    }
}

$records = foreach ($fips in ($groups.Keys | Sort-Object)) {
    $group = $groups[$fips]
    $totalTests = $group.total_tests
    $average = if ($totalTests -gt 0) { [math]::Round($group.weighted_average_sum / $totalTests, 1) } else { $null }
    $percentAbove2 = if ($totalTests -gt 0) { [math]::Round(($group.tests_above_2 / $totalTests) * 100.0, 1) } else { $null }
    $percentAbove4 = if ($totalTests -gt 0) { [math]::Round(($group.tests_above_4 / $totalTests) * 100.0, 1) } else { $null }
    $averageTests = if ($totalTests -gt 0) { [math]::Round($totalTests / 22.0, 1) } else { $null }

    [ordered]@{
        county_fips = $fips
        state_abbr = "WI"
        county_name = $group.county_name
        source_id = "wi_dhs_radon"
        source_name = $sourceName
        source_url = $sourceUrl
        period = $period
        retrieved_at = $retrievedAt
        caveat = $caveat
        metrics = [ordered]@{
            average_number_of_tests = $averageTests
            average_test_result_pci_l = $average
            arithmetic_mean_radon_value_pci_l = $average
            maximum_test_result_pci_l = $group.maximum
            percent_tests_at_or_above_2_pci_l = $percentAbove2
            percent_tests_at_or_above_4_pci_l = $percentAbove4
            number_properties_at_or_above_2_pci_l = $group.tests_above_2
            number_properties_at_or_above_4_pci_l = $group.tests_above_4
        }
    }
}

$records = @($records | Sort-Object state_abbr, county_name)
$json = $records | ConvertTo-Json -Depth 10
Set-Content -LiteralPath $OutputPath -Value $json -Encoding UTF8

Write-Host "Wrote $($records.Count) WI county radon measurement records for $period to $OutputPath"
