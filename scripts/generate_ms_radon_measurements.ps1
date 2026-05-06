param(
    [string]$OutputPath = "data/ms_radon_measurements.json"
)

$ErrorActionPreference = "Stop"

$sourceUrl = "https://nepis.epa.gov/Exe/ZyPURL.cgi?Dockey=00000787.TXT"
$sourceName = "EPA/USGS Mississippi Residential Radon Survey"
$period = "1990-1991"
$retrievedAt = "2026-05-06"
$caveat = "EPA/USGS Mississippi supporting documentation includes a 1990-1991 State/EPA Residential Radon Survey county table. RadonVerdict stores Alcorn County as historical county context only; the sample is not a current property prediction, and a home-specific test still controls the decision."

$geo = Get-Content -LiteralPath "src/main/resources/data/geo_counties.json" -Raw | ConvertFrom-Json
$county = $geo | Where-Object { $_.fips -eq "28003" } | Select-Object -First 1
if ($null -eq $county -or $county.state_abbr -ne "MS" -or $county.county_name -ne "Alcorn") {
    throw "Expected Mississippi Alcorn County FIPS 28003 in geo_counties.json."
}

$records = @(
    [ordered]@{
        county_fips = $county.fips
        state_abbr = $county.state_abbr
        county_name = $county.county_name
        source_id = "epa_usgs_ms_residential_radon_survey"
        source_name = $sourceName
        source_url = $sourceUrl
        period = $period
        retrieved_at = $retrievedAt
        caveat = $caveat
        metrics = [ordered]@{
            total_tests = 47.0
            average_test_result_pci_l = 1.0
            arithmetic_mean_radon_value_pci_l = 1.0
            geometric_mean_radon_value_pci_l = 0.8
            median_radon_value_pci_l = 0.5
        }
    }
)

$json = $records | ConvertTo-Json -Depth 10
Set-Content -LiteralPath $OutputPath -Value $json -Encoding UTF8

Write-Host "Wrote $($records.Count) MS county radon measurement record from $sourceUrl to $OutputPath"
