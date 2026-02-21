$geoFile = "c:\Development\Owner\radonVerdict\src\main\resources\data\geo_counties.json"
$epaFile = "c:\Development\Owner\radonVerdict\src\main\resources\data\epa_county_radon_zones.json"

Write-Host "Loading data..."
$geoData = Get-Content $geoFile -Raw | ConvertFrom-Json
$epaData = Get-Content $epaFile -Raw | ConvertFrom-Json

$geoFips = $geoData | Select-Object -ExpandProperty fips
$epaFips = $epaData | Select-Object -ExpandProperty fips

Write-Host "Total counties in geo_counties.json: $($geoFips.Count)"
Write-Host "Total counties in epa_county_radon_zones.json: $($epaFips.Count)"

Write-Host "Comparing FIPS codes..."
$diff = Compare-Object -ReferenceObject $epaFips -DifferenceObject $geoFips

$inGeoNotInEpa = $diff | Where-Object { $_.SideIndicator -eq "=>" } | Select-Object -ExpandProperty InputObject
$inEpaNotInGeo = $diff | Where-Object { $_.SideIndicator -eq "<=" } | Select-Object -ExpandProperty InputObject

if ($inGeoNotInEpa -and $inGeoNotInEpa.Count -gt 0) {
    Write-Host "`nFIPS in geo_counties.json but NOT in epa_county_radon_zones.json ($($inGeoNotInEpa.Count)):"
    foreach ($f in $inGeoNotInEpa) {
        $county = $geoData | Where-Object { $_.fips -eq $f } | Select-Object -First 1
        $name = if ($county) { $county.county_name } else { "Unknown" }
        $state = if ($county) { $county.state_abbr } else { "Unknown" }
        Write-Host "  - FIPS: $f, Name: $name, State: $state"
    }
}
else {
    Write-Host "`nNo FIPS found exclusively in geo_counties.json."
}

if ($inEpaNotInGeo -and $inEpaNotInGeo.Count -gt 0) {
    Write-Host "`nFIPS in epa_county_radon_zones.json but NOT in geo_counties.json ($($inEpaNotInGeo.Count)):"
    foreach ($f in $inEpaNotInGeo) {
        $county = $epaData | Where-Object { $_.fips -eq $f } | Select-Object -First 1
        $name = if ($county) { $county.county_name } else { "Unknown" }
        $state = if ($county) { $county.state_abbr } else { "Unknown" }
        Write-Host "  - FIPS: $f, Name: $name, State: $state"
    }
}
else {
    Write-Host "`nNo FIPS found exclusively in epa_county_radon_zones.json."
}

Write-Host "`nChecking for duplicate FIPS codes..."
$geoDupes = $geoFips | Group-Object | Where-Object { $_.Count -gt 1 }
$epaDupes = $epaFips | Group-Object | Where-Object { $_.Count -gt 1 }

if ($geoDupes) {
    Write-Host "`nDuplicate FIPS in geo_counties.json:"
    foreach ($d in $geoDupes) {
        Write-Host "  - FIPS: $($d.Name), Count: $($d.Count)"
    }
}
else {
    Write-Host "No duplicates in geo_counties.json"
}

if ($epaDupes) {
    Write-Host "`nDuplicate FIPS in epa_county_radon_zones.json:"
    foreach ($d in $epaDupes) {
        Write-Host "  - FIPS: $($d.Name), Count: $($d.Count)"
    }
}
else {
    Write-Host "No duplicates in epa_county_radon_zones.json"
}
