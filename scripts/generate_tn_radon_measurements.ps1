param(
    [string]$OutputPath = "data/tn_radon_measurements.json"
)

$ErrorActionPreference = "Stop"

$countyLayerUrl = "https://services3.arcgis.com/6NilKQ6gRj0zOeXh/arcgis/rest/services/Radon2020c/FeatureServer/0"
$above4ZipLayerUrl = "https://services3.arcgis.com/6NilKQ6gRj0zOeXh/arcgis/rest/services/Radon2020c/FeatureServer/2"
$sourceUrl = "https://healthdata.tn.gov/stories/s/mh5a-t3be"
$retrievedAt = "2026-05-05"
$period = "through 2020"
$sourceName = "Tennessee Environmental Public Health Tracking Radon Data"
$caveat = "Tennessee Health Data says county and ZIP values come from radon test kit and mitigation company data; results before about 2015 may not be included, and county or ZIP averages cannot predict an individual home's radon level. RadonVerdict uses the official county average layer and rolls the official ZIP 4.0+ layer up to primary counties."

function Normalize-CountyName($value) {
    if ($null -eq $value) {
        return ""
    }
    $text = "$value".Trim().ToLowerInvariant()
    $text = $text -replace "\s+county$", ""
    return $text -replace "[^a-z0-9]", ""
}

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

function Round-Nullable($value, [int]$digits = 1) {
    if ($null -eq $value) {
        return $null
    }
    return [math]::Round([double]$value, $digits)
}

function Get-ZipFips($zipMap, [string]$zip) {
    $property = $zipMap.PSObject.Properties[$zip]
    if ($null -eq $property) {
        return $null
    }
    return "$($property.Value)"
}

$geo = Get-Content -LiteralPath "src/main/resources/data/geo_counties.json" -Raw | ConvertFrom-Json
$zipMap = Get-Content -LiteralPath "src/main/resources/data/zip_primary_county.json" -Raw | ConvertFrom-Json

$tnCountiesByName = @{}
foreach ($county in $geo) {
    if ($county.state_abbr -eq "TN") {
        $tnCountiesByName[(Normalize-CountyName $county.county_name)] = $county
    }
}

Write-Host "Fetching Tennessee county radon measures..."
$countyQueryUrl = "${countyLayerUrl}/query?f=json&where=1%3D1&outFields=NAME,AVG_,MED,MIN_,MAX_,COUNT_&returnGeometry=false&resultRecordCount=2000&orderByFields=NAME"
$countyPayload = Invoke-RestMethod -Uri $countyQueryUrl -TimeoutSec 90
if ($countyPayload.error) {
    throw "Tennessee county layer error: $($countyPayload.error.message)"
}
if (-not $countyPayload.features) {
    throw "Tennessee county radon layer returned no features."
}

Write-Host "Fetching Tennessee ZIP 4.0+ radon measures..."
$above4QueryUrl = "${above4ZipLayerUrl}/query?f=json&where=1%3D1&outFields=ZIP,ZoneFreq,TotalFreq&returnGeometry=false&resultRecordCount=2000"
$above4Payload = Invoke-RestMethod -Uri $above4QueryUrl -TimeoutSec 90
if ($above4Payload.error) {
    throw "Tennessee ZIP 4.0+ layer error: $($above4Payload.error.message)"
}

$above4ByFips = @{}
foreach ($feature in $above4Payload.features) {
    $row = $feature.attributes
    $zipValue = To-NullableDouble $row.ZIP
    if ($null -eq $zipValue) {
        continue
    }

    $zip = "{0:D5}" -f [int]$zipValue
    $fips = Get-ZipFips $zipMap $zip
    if ([string]::IsNullOrWhiteSpace($fips) -or -not $fips.StartsWith("47")) {
        continue
    }

    if (-not $above4ByFips.ContainsKey($fips)) {
        $above4ByFips[$fips] = [ordered]@{
            tests_at_or_above_4 = 0.0
            total_tests = 0.0
        }
    }

    $zoneFreq = To-NullableDouble $row.ZoneFreq
    $totalFreq = To-NullableDouble $row.TotalFreq
    if ($null -ne $zoneFreq) {
        $above4ByFips[$fips].tests_at_or_above_4 += $zoneFreq
    }
    if ($null -ne $totalFreq) {
        $above4ByFips[$fips].total_tests += $totalFreq
    }
}

$unmatchedNames = @()
$records = foreach ($feature in $countyPayload.features) {
    $row = $feature.attributes
    $nameKey = Normalize-CountyName $row.NAME
    if (-not $tnCountiesByName.ContainsKey($nameKey)) {
        $unmatchedNames += $row.NAME
        continue
    }

    $county = $tnCountiesByName[$nameKey]
    $above4Group = $above4ByFips[$county.fips]
    $above4Percent = $null
    $above4Count = $null
    if ($above4Group -and $above4Group.total_tests -gt 0) {
        $above4Percent = [math]::Round(($above4Group.tests_at_or_above_4 / $above4Group.total_tests) * 100.0, 1)
        $above4Count = [math]::Round($above4Group.tests_at_or_above_4, 0)
    }

    $average = Round-Nullable (To-NullableDouble $row.AVG_) 1
    $median = Round-Nullable (To-NullableDouble $row.MED) 1
    $maximum = Round-Nullable (To-NullableDouble $row.MAX_) 1
    $totalTests = Round-Nullable (To-NullableDouble $row.COUNT_) 0

    [ordered]@{
        county_fips = $county.fips
        state_abbr = "TN"
        county_name = $county.county_name
        source_id = "tn_health_radon"
        source_name = $sourceName
        source_url = $sourceUrl
        period = $period
        retrieved_at = $retrievedAt
        caveat = $caveat
        metrics = [ordered]@{
            total_tests = $totalTests
            average_test_result_pci_l = $average
            arithmetic_mean_radon_value_pci_l = $average
            median_radon_value_pci_l = $median
            maximum_test_result_pci_l = $maximum
            percent_tests_at_or_above_4_pci_l = $above4Percent
            number_properties_at_or_above_4_pci_l = $above4Count
        }
    }
}

if ($unmatchedNames.Count -gt 0) {
    throw "Unmatched Tennessee county names from ArcGIS layer: $($unmatchedNames -join ', ')"
}

$records = @($records | Sort-Object { $_["state_abbr"] }, { $_["county_name"] })
$json = $records | ConvertTo-Json -Depth 10
Set-Content -LiteralPath $OutputPath -Value $json -Encoding UTF8

Write-Host "Wrote $($records.Count) TN county radon measurement records to $OutputPath"
