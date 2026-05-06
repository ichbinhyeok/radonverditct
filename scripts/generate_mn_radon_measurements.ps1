param(
    [string]$OutputPath = "data/mn_radon_measurements.json"
)

$ErrorActionPreference = "Stop"

$downloadUrl = "https://mndatamaps.web.health.state.mn.us/interactive/data/zip/RadonData.zip"
$sourceUrl = "https://mndatamaps.web.health.state.mn.us/interactive/radon.html"
$retrievedAt = "2026-05-05"
$sourceName = "Minnesota Department of Health Indoor Air Unit Radon Test Data"
$period = "2010-2020"
$caveat = "Minnesota county summaries are based on reported commercial and residential radon tests, mostly single-family homes, and exclude most continuous-monitor real-estate tests."

$workDir = Join-Path $env:TEMP ("rv_mn_radon_" + [guid]::NewGuid().ToString("N"))
$zipPath = Join-Path $workDir "RadonData.zip"
$extractPath = Join-Path $workDir "unzipped"

New-Item -ItemType Directory -Path $workDir -Force | Out-Null

try {
    Invoke-WebRequest -Uri $downloadUrl -OutFile $zipPath -TimeoutSec 90
    Expand-Archive -LiteralPath $zipPath -DestinationPath $extractPath -Force

    $csvPath = Get-ChildItem -LiteralPath $extractPath -Recurse -Filter "RadonTestData20102020.csv" |
        Select-Object -First 1 -ExpandProperty FullName

    if (-not $csvPath) {
        throw "Could not find RadonTestData20102020.csv in downloaded Minnesota radon data."
    }

    $geo = Get-Content -LiteralPath "src/main/resources/data/geo_counties.json" -Raw | ConvertFrom-Json
    $mnCountiesByFips = @{}
    foreach ($county in $geo) {
        if ($county.state_abbr -eq "MN") {
            $mnCountiesByFips[$county.fips] = $county
        }
    }

    function To-NullableDouble([string]$value) {
        if ([string]::IsNullOrWhiteSpace($value) -or $value -eq "NA" -or $value -eq "UNSTABLE") {
            return $null
        }
        return [double]$value
    }

    function To-UnstableFlag([string]$value) {
        if ([string]::IsNullOrWhiteSpace($value)) {
            return $false
        }
        return $value.Trim().ToUpperInvariant() -eq "UNSTABLE"
    }

    $records = foreach ($row in (Import-Csv -LiteralPath $csvPath)) {
        if ($row.FIPS -eq "27000" -or -not $mnCountiesByFips.ContainsKey($row.FIPS)) {
            continue
        }

        $county = $mnCountiesByFips[$row.FIPS]
        $metrics = [ordered]@{
            average_number_of_tests = To-NullableDouble $row.AverageAnnualNumberOfPropertiesTested
            average_annual_properties_tested_per_10000 = To-NullableDouble $row.AverageAnnualPropertiesTestedPer10000
            number_properties_at_or_above_2_pci_l = To-NullableDouble $row.NumberProperties2pCiL
            percent_tests_at_or_above_2_pci_l = To-NullableDouble $row.PctProperties2pCiL
            number_properties_at_or_above_4_pci_l = To-NullableDouble $row.NumberProperties4pCiL
            percent_tests_at_or_above_4_pci_l = To-NullableDouble $row.PctProperties4pCiL
            radon_95th_percentile_pci_l = To-NullableDouble $row.Radon95thPercentile
            median_radon_value_pci_l = To-NullableDouble $row.MedianRadonValue
            geometric_mean_radon_value_pci_l = To-NullableDouble $row.GeometricMeanRadonValue
            arithmetic_mean_radon_value_pci_l = To-NullableDouble $row.ArithmeticMeanRadonValue
            average_test_result_pci_l = To-NullableDouble $row.ArithmeticMeanRadonValue
            unstable_average_annual_properties_tested = To-UnstableFlag $row.UnstableTotalPropertiesTested
            unstable_percent_at_or_above_2_pci_l = To-UnstableFlag $row.Unstable2pCiL
            unstable_percent_at_or_above_4_pci_l = To-UnstableFlag $row.Unstable4pCiL
        }

        [ordered]@{
            county_fips = $county.fips
            state_abbr = "MN"
            county_name = $county.county_name
            source_id = "mn_health_radon"
            source_name = $sourceName
            source_url = $sourceUrl
            period = $period
            retrieved_at = $retrievedAt
            caveat = $caveat
            metrics = $metrics
        }
    }

    $records = @($records | Sort-Object { $_.county_fips })
    $json = $records | ConvertTo-Json -Depth 8
    Set-Content -LiteralPath $OutputPath -Value $json -Encoding UTF8
    Write-Host "Wrote $($records.Count) MN county radon measurement records for period $period to $OutputPath"
}
finally {
    if (Test-Path -LiteralPath $workDir) {
        Remove-Item -LiteralPath $workDir -Recurse -Force
    }
}
