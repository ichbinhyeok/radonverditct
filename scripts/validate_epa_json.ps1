$json = Get-Content 'c:\Development\Owner\radonVerdict\src\main\resources\data\epa_county_radon_zones.json' -Raw | ConvertFrom-Json

Write-Host "=== EPA County Radon Zones JSON Validation ==="
Write-Host "Total entries: $($json.Count)"

$states = $json | Select-Object -ExpandProperty state_abbr -Unique | Sort-Object
Write-Host "Unique states: $($states.Count)"
Write-Host "States: $($states -join ', ')"

$zones = $json | Group-Object epa_zone | Sort-Object Name
foreach ($z in $zones) {
    Write-Host "Zone $($z.Name): $($z.Count) counties"
}

$badFips = @($json | Where-Object { $_.fips.Length -ne 5 })
Write-Host "Invalid FIPS (not 5 chars): $($badFips.Count)"

$dupFips = @($json | Group-Object fips | Where-Object { $_.Count -gt 1 })
Write-Host "Duplicate FIPS: $($dupFips.Count)"
if ($dupFips.Count -gt 0) {
    foreach ($d in $dupFips) {
        Write-Host "  DUP: $($d.Name)"
    }
}

$missingStates = @('AL','AK','AZ','AR','CA','CO','CT','DE','FL','GA','HI','ID','IL','IN','IA','KS','KY','LA','ME','MD','MA','MI','MN','MS','MO','MT','NE','NV','NH','NJ','NM','NY','NC','ND','OH','OK','OR','PA','RI','SC','SD','TN','TX','UT','VT','VA','WA','WV','WI','WY','DC') | Where-Object { $_ -notin $states }
Write-Host "Missing states: $($missingStates.Count)"
if ($missingStates.Count -gt 0) {
    Write-Host "  MISSING: $($missingStates -join ', ')"
}

# Count per state
Write-Host "`n=== County count per state ==="
$perState = $json | Group-Object state_abbr | Sort-Object Name
foreach ($s in $perState) {
    Write-Host "$($s.Name): $($s.Count)"
}
