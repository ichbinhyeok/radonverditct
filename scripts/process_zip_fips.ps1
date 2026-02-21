# Script to validate and create zip_primary_county.json
$geoCountiesPath = "c:\Development\Owner\radonVerdict\src\main\resources\data\geo_counties.json"
$zipToFipsRawPath = "c:\Development\Owner\radonVerdict\zip2fips_test.json"
$outputPath = "c:\Development\Owner\radonVerdict\src\main\resources\data\zip_primary_county.json"

Write-Host "Loading geo_counties.json..."
$geoData = Get-Content $geoCountiesPath -Raw | ConvertFrom-Json
$validFips = @{}
foreach ($c in $geoData) {
    $validFips[$c.fips] = $true
}
Write-Host "Loaded $($validFips.Count) valid FIPS codes."

Write-Host "Loading zip2fips raw data..."
$zipData = Get-Content $zipToFipsRawPath -Raw | ConvertFrom-Json

$validZipToFips = @{}
$mappedCount = 0
$droppedCount = 0

foreach ($zip in $zipData.psobject.properties) {
    $zipCode = $zip.Name
    $fips = $zip.Value
    
    if ($validFips.ContainsKey($fips)) {
        $validZipToFips[$zipCode] = $fips
        $mappedCount++
    }
    else {
        $droppedCount++
    }
}

Write-Host "Mapped $mappedCount ZIP codes to valid FIPS."
Write-Host "Dropped $droppedCount ZIP codes (FIPS not in geo_counties)."

Write-Host "Saving to $outputPath..."
# Convert back to JSON
$validZipToFips | ConvertTo-Json -Depth 1 -Compress | Out-File -FilePath $outputPath -Encoding utf8

Write-Host "Validation and save complete!"
