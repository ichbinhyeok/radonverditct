# Compare EPA official XLS data vs our JSON data
$xlsPath = 'c:\Development\Owner\radonVerdict\src\main\resources\data\radon_zone.xls'
$jsonPath = 'c:\Development\Owner\radonVerdict\src\main\resources\data\epa_county_radon_zones.json'

# --- Parse XLS (tab-separated text) ---
$xlsLines = Get-Content $xlsPath
$officialData = @{}
$officialCount = 0
$stateAbbrs = @{
    'Alabama' = 'AL'; 'Alaska' = 'AK'; 'Arizona' = 'AZ'; 'Arkansas' = 'AR'; 'California' = 'CA';
    'Colorado' = 'CO'; 'Connecticut' = 'CT'; 'Delaware' = 'DE'; 'District of Columbia' = 'DC';
    'Florida' = 'FL'; 'Georgia' = 'GA'; 'Hawaii' = 'HI'; 'Idaho' = 'ID'; 'Illinois' = 'IL';
    'Indiana' = 'IN'; 'Iowa' = 'IA'; 'Kansas' = 'KS'; 'Kentucky' = 'KY'; 'Louisiana' = 'LA';
    'Maine' = 'ME'; 'Maryland' = 'MD'; 'Massachusetts' = 'MA'; 'Michigan' = 'MI'; 'Minnesota' = 'MN';
    'Mississippi' = 'MS'; 'Missouri' = 'MO'; 'Montana' = 'MT'; 'Nebraska' = 'NE'; 'Nevada' = 'NV';
    'New Hampshire' = 'NH'; 'New Jersey' = 'NJ'; 'New Mexico' = 'NM'; 'New York' = 'NY';
    'North Carolina' = 'NC'; 'North Dakota' = 'ND'; 'Ohio' = 'OH'; 'Oklahoma' = 'OK'; 'Oregon' = 'OR';
    'Pennsylvania' = 'PA'; 'Rhode Island' = 'RI'; 'South Carolina' = 'SC'; 'South Dakota' = 'SD';
    'Tennessee' = 'TN'; 'Texas' = 'TX'; 'Utah' = 'UT'; 'Vermont' = 'VT'; 'Virginia' = 'VA';
    'Washington' = 'WA'; 'West Virginia' = 'WV'; 'Wisconsin' = 'WI'; 'Wyoming' = 'WY';
    'VA-CITY' = 'VA'
}

foreach ($line in $xlsLines) {
    if ($line -match '^County,State' -or $line -match '^UNITED STATES' -or $line -eq '.' -or $line -match '^[A-Z ]+\tno data') { continue }
    
    $cols = $line -split "`t"
    if ($cols.Count -lt 5) { continue }
    
    $countyState = $cols[0].Trim()
    $stateFull = $cols[2].Trim()
    $zone = $cols[4].Trim()
    
    if ($zone -eq '.' -or $zone -eq '' -or $zone -eq 'Zone') { continue }
    
    # Extract county name and state abbr from first column "County, ST"
    if ($countyState -match '^(.+),\s*([A-Z]{2})$') {
        $countyName = $Matches[1].Trim()
        $stateAbbr = $Matches[2].Trim()
    }
    else {
        # Some entries like "District of Columbia" don't have comma
        $countyName = $countyState
        if ($stateAbbrs.ContainsKey($stateFull)) {
            $stateAbbr = $stateAbbrs[$stateFull]
        }
        else {
            continue
        }
    }
    
    $zoneInt = [int]$zone
    $key = "$stateAbbr|$countyName"
    $officialData[$key] = @{ County = $countyName; State = $stateAbbr; Zone = $zoneInt }
    $officialCount++
}

Write-Host "=== EPA Official Data (XLS) ==="
Write-Host "Total county entries parsed: $officialCount"

# --- Parse JSON ---
$json = Get-Content $jsonPath -Raw | ConvertFrom-Json
$jsonData = @{}
foreach ($entry in $json) {
    $key = "$($entry.state_abbr)|$($entry.county_name)"
    $jsonData[$key] = @{ County = $entry.county_name; State = $entry.state_abbr; Zone = $entry.epa_zone; Fips = $entry.fips }
}

Write-Host "`n=== Our JSON Data ==="
Write-Host "Total entries: $($json.Count)"

# --- Compare ---
$mismatches = @()
$inJsonNotOfficial = @()
$inOfficialNotJson = @()
$matched = 0

# Check JSON entries against official
foreach ($key in $jsonData.Keys) {
    if ($officialData.ContainsKey($key)) {
        $jZone = $jsonData[$key].Zone
        $oZone = $officialData[$key].Zone
        if ($jZone -ne $oZone) {
            $mismatches += [PSCustomObject]@{
                State        = $jsonData[$key].State
                County       = $jsonData[$key].County
                Fips         = $jsonData[$key].Fips
                JsonZone     = $jZone
                OfficialZone = $oZone
            }
        }
        else {
            $matched++
        }
    }
    else {
        $inJsonNotOfficial += [PSCustomObject]@{
            State  = $jsonData[$key].State
            County = $jsonData[$key].County
            Fips   = $jsonData[$key].Fips
            Zone   = $jsonData[$key].Zone
        }
    }
}

# Check official entries not in JSON
foreach ($key in $officialData.Keys) {
    if (-not $jsonData.ContainsKey($key)) {
        $inOfficialNotJson += [PSCustomObject]@{
            State  = $officialData[$key].State
            County = $officialData[$key].County
            Zone   = $officialData[$key].Zone
        }
    }
}

Write-Host "`n=== COMPARISON RESULTS ==="
Write-Host "Matched (same county, same zone): $matched"
Write-Host "ZONE MISMATCHES: $($mismatches.Count)"
Write-Host "In JSON but NOT in official: $($inJsonNotOfficial.Count)"
Write-Host "In official but NOT in JSON: $($inOfficialNotJson.Count)"

if ($mismatches.Count -gt 0) {
    Write-Host "`n--- ZONE MISMATCHES (JSON vs Official) ---"
    foreach ($m in ($mismatches | Sort-Object State, County)) {
        Write-Host "  $($m.State) | $($m.County) (FIPS:$($m.Fips)) | JSON:Zone$($m.JsonZone) vs Official:Zone$($m.OfficialZone)"
    }
}

if ($inOfficialNotJson.Count -gt 0) {
    Write-Host "`n--- MISSING FROM JSON (in official, not in JSON) ---"
    $byState = $inOfficialNotJson | Group-Object State | Sort-Object Name
    foreach ($g in $byState) {
        Write-Host "  $($g.Name): $($g.Count) missing"
        foreach ($c in ($g.Group | Sort-Object County)) {
            Write-Host "    - $($c.County) (Zone $($c.Zone))"
        }
    }
}

if ($inJsonNotOfficial.Count -gt 0) {
    Write-Host "`n--- IN JSON BUT NOT IN OFFICIAL (possible name mismatches) ---"
    $byState2 = $inJsonNotOfficial | Group-Object State | Sort-Object Name
    foreach ($g in $byState2) {
        Write-Host "  $($g.Name): $($g.Count) extra"
        foreach ($c in ($g.Group | Sort-Object County)) {
            Write-Host "    - $($c.County) (FIPS:$($c.Fips), Zone $($c.Zone))"
        }
    }
}
