param(
    [string]$OutputPath = "data/ks_radon_measurements.json",
    [string]$Year = "2020"
)

$ErrorActionPreference = "Stop"

$sourceUrl = "https://maps.kdhe.ks.gov/ksepht/?ContentAreaID=31&GeoLayer=2&IndicatorID=141&MeasureID=748&StratFieldName=None&StratLocalId=None&Year=$Year"
$apiUrl = "https://maps.kdhe.ks.gov/kdhe_doh/rest/services/EPHT/Radon/MapServer/4/query"
$retrievedAt = "2026-05-05"
$sourceName = "Kansas Environmental Public Health Tracking Radon Data"
$caveat = "Kansas EPHT county summaries are based on radon tests reported to KDHE; they are public-health surveillance summaries and cannot predict an individual home's result."

$geo = Get-Content -LiteralPath "src/main/resources/data/geo_counties.json" -Raw | ConvertFrom-Json
$ksCountiesByFips = @{}
foreach ($county in $geo) {
    if ($county.state_abbr -eq "KS") {
        $ksCountiesByFips[$county.fips] = $county
    }
}

function Get-NullableDouble($value) {
    if ($null -eq $value) {
        return $null
    }
    $text = "$value".Trim()
    if ($text -eq "" -or $text -eq "NA" -or $text -eq "Suppressed") {
        return $null
    }
    return [double]$text
}

function Get-MetricValue($rows, [int]$measureId) {
    $row = @($rows | Where-Object { $_.MeasureID -eq $measureId -and [string]::IsNullOrWhiteSpace($_.Concentration) } | Select-Object -First 1)
    if ($row.Count -eq 0) {
        return $null
    }
    return Get-NullableDouble $row[0].DisplayValueNumeric
}

function Get-ConcentrationValue($rows, [int]$measureId, [string]$concentration) {
    $row = @($rows | Where-Object { $_.MeasureID -eq $measureId -and $_.Concentration -eq $concentration } | Select-Object -First 1)
    if ($row.Count -eq 0) {
        return $null
    }
    return Get-NullableDouble $row[0].DisplayValueNumeric
}

function Invoke-WithRetry([string]$Url, [int]$TimeoutSec = 120, [int]$MaxAttempts = 3) {
    for ($attempt = 1; $attempt -le $MaxAttempts; $attempt++) {
        try {
            return Invoke-RestMethod -Uri $Url -TimeoutSec $TimeoutSec
        } catch {
            if ($attempt -eq $MaxAttempts) {
                throw
            }
            $delay = 5 * $attempt
            Write-Host "Kansas EPHT request timed out or failed; retrying in $delay seconds ($attempt/$MaxAttempts)..."
            Start-Sleep -Seconds $delay
        }
    }
}

Write-Host "Fetching Kansas EPHT radon county measures for $Year..."
$where = [uri]::EscapeDataString("ContentAreaID=31 AND IndicatorID=141 AND Year='$Year'")
$queryUrl = "${apiUrl}?f=json&where=$where&outFields=MeasureID,Year,GeoID,County,Value,DisplayValueNumeric,Concentration,Version&returnGeometry=false&resultRecordCount=2000&orderByFields=GeoID,MeasureID"
$payload = Invoke-WithRetry $queryUrl 120 3

if (-not $payload.features) {
    throw "Kansas EPHT returned no radon features for $Year."
}

$rowsByFips = @{}
foreach ($feature in $payload.features) {
    $row = $feature.attributes
    if (-not $row.GeoID -or -not $ksCountiesByFips.ContainsKey($row.GeoID)) {
        continue
    }
    if (-not $rowsByFips.ContainsKey($row.GeoID)) {
        $rowsByFips[$row.GeoID] = @()
    }
    $rowsByFips[$row.GeoID] += $row
}

$records = foreach ($fips in ($rowsByFips.Keys | Sort-Object)) {
    $county = $ksCountiesByFips[$fips]
    $rows = $rowsByFips[$fips]
    $below2 = Get-ConcentrationValue $rows 745 "< 2 pCi/L"
    $twoToBelow4 = Get-ConcentrationValue $rows 745 ">= 2 pCi/L to < 4 pCi/L"
    $above4 = Get-ConcentrationValue $rows 745 ">= 4 pCi/L"
    $count2ToBelow4 = Get-ConcentrationValue $rows 743 ">= 2 pCi/L to < 4 pCi/L"
    $countAbove4 = Get-ConcentrationValue $rows 743 ">= 4 pCi/L"
    $countAbove2 = $null
    if ($null -ne $count2ToBelow4 -or $null -ne $countAbove4) {
        $countAbove2 = $(if ($null -ne $count2ToBelow4) { $count2ToBelow4 } else { 0 }) +
                $(if ($null -ne $countAbove4) { $countAbove4 } else { 0 })
    }
    $percentAbove2 = $null
    if ($null -ne $twoToBelow4 -or $null -ne $above4) {
        $percentAbove2 = $(if ($null -ne $twoToBelow4) { $twoToBelow4 } else { 0 }) +
                $(if ($null -ne $above4) { $above4 } else { 0 })
    }

    [ordered]@{
        county_fips = $county.fips
        state_abbr = "KS"
        county_name = $county.county_name
        source_id = "ks_kdhe_radon"
        source_name = $sourceName
        source_url = $sourceUrl
        period = $Year
        retrieved_at = $retrievedAt
        caveat = $caveat
        metrics = [ordered]@{
            average_number_of_tests = Get-MetricValue $rows 742
            average_test_result_pci_l = Get-MetricValue $rows 1132
            arithmetic_mean_radon_value_pci_l = Get-MetricValue $rows 1132
            median_radon_value_pci_l = Get-MetricValue $rows 747
            maximum_test_result_pci_l = Get-MetricValue $rows 748
            percent_tests_below_2_pci_l = $below2
            percent_tests_2_to_below_4_pci_l = $twoToBelow4
            percent_tests_at_or_above_2_pci_l = $percentAbove2
            percent_tests_at_or_above_4_pci_l = $above4
            number_properties_at_or_above_2_pci_l = $countAbove2
            number_properties_at_or_above_4_pci_l = $countAbove4
        }
    }
}

$records = @($records | Sort-Object state_abbr, county_name)
$json = $records | ConvertTo-Json -Depth 10
Set-Content -LiteralPath $OutputPath -Value $json -Encoding UTF8

Write-Host "Wrote $($records.Count) KS county radon measurement records for $Year to $OutputPath"
