param(
    [string]$OutputPath = "src/main/resources/data/county_radon_measurements.json"
)

$ErrorActionPreference = "Stop"

$sourceUrl = "https://apps.health.ny.gov/statistics/environmental/public_health_tracking/tracker/files/radon/NYS_RADON.csv"
$retrievedAt = "2026-05-05"
$sourceName = "New York State Department of Health Residential Radon Test Data"
$caveat = "NY DOH county summaries are based on submitted residential radon tests and are not a statistically designed survey of every home."

$geoPath = "src/main/resources/data/geo_counties.json"
$geo = Get-Content -LiteralPath $geoPath -Raw | ConvertFrom-Json
$nyCounties = @{}
foreach ($county in $geo) {
    if ($county.state_abbr -eq "NY") {
        $nyCounties[$county.county_name.ToUpperInvariant()] = $county
    }
}

$csv = (Invoke-WebRequest -Uri $sourceUrl -UseBasicParsing -TimeoutSec 60).Content | ConvertFrom-Csv
$countyRows = $csv | Where-Object {
    $nyCounties.ContainsKey($_.Region.ToUpperInvariant()) -and $_.Period -match '^\d{4}-\d{4}$'
}

$latestPeriod = ($countyRows | Select-Object -ExpandProperty Period -Unique |
    Sort-Object { [int](($_ -split '-')[1]) } -Descending |
    Select-Object -First 1)

$measureMap = @{
    "Average number of tests" = "average_number_of_tests"
    "Average test result value" = "average_test_result_pci_l"
    "Maximum test result value" = "maximum_test_result_pci_l"
    "Percent Houses Tested" = "percent_houses_tested"
    "Percent tests <2pCi/L" = "percent_tests_below_2_pci_l"
    "Percent tests 2-<4 pCi/L" = "percent_tests_2_to_below_4_pci_l"
    "Percent tests >=4 pCi/L" = "percent_tests_at_or_above_4_pci_l"
    "Percent tests: Basement" = "percent_tests_basement"
    "Percent tests: First Floor" = "percent_tests_first_floor"
    "Percent tests: Other Floors" = "percent_tests_other_floors"
}

$byRegion = $countyRows | Where-Object { $_.Period -eq $latestPeriod } | Group-Object Region
$records = foreach ($group in $byRegion) {
    $county = $nyCounties[$group.Name.ToUpperInvariant()]
    $metrics = [ordered]@{}
    foreach ($row in $group.Group) {
        if ($measureMap.ContainsKey($row.Measure)) {
            $key = $measureMap[$row.Measure]
            $metrics[$key] = [double]$row.Value
        }
    }

    [ordered]@{
        county_fips = $county.fips
        state_abbr = "NY"
        county_name = $county.county_name
        source_id = "ny_doh_tracking_radon"
        source_name = $sourceName
        source_url = $sourceUrl
        period = $latestPeriod
        retrieved_at = $retrievedAt
        caveat = $caveat
        metrics = $metrics
    }
}

$records = $records | Sort-Object { $_.county_fips }
$json = $records | ConvertTo-Json -Depth 8
Set-Content -LiteralPath $OutputPath -Value $json -Encoding UTF8
Write-Host "Wrote $($records.Count) NY county radon measurement records for period $latestPeriod to $OutputPath"
