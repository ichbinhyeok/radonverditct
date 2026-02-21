# ETL Script: Generate epa_county_radon_zones.json from EPA official data + Census FIPS
$xlsPath = 'c:\Development\Owner\radonVerdict\src\main\resources\data\radon_zone.xls'
$censusPath = 'c:\Development\Owner\radonVerdict\scripts\national_county.txt'
$outputPath = 'c:\Development\Owner\radonVerdict\src\main\resources\data\epa_county_radon_zones_new.json'

Write-Host "=== Step 1: Building FIPS lookup from Census ==="
$fipsLookup = @{}

$censusLines = Get-Content $censusPath -Encoding UTF8
foreach ($line in $censusLines) {
    $parts = $line -split ','
    if ($parts.Count -lt 4) { continue }
    $stAbbr = $parts[0].Trim()
    $stFp = $parts[1].Trim()
    $coFp = $parts[2].Trim()
    $coName = $parts[3].Trim()
    
    if ($stFp -notmatch '^\d{2}$' -or $coFp -notmatch '^\d{3}$') { continue }
    $fips = "$stFp$coFp"
    
    $normalized = $coName.Trim()
    
    $keyRaw = "$stAbbr|$normalized"
    $fipsLookup[$keyRaw] = $fips
    
    # Also store lowercased exact name
    $fipsLookup["$stAbbr|$( $normalized.ToLower() )"] = $fips
    
    # Strip suffixes
    $noSuffix = $normalized -replace '(?i)\s+(County|Parish|Borough|Census Area|Municipality|City and Borough|city|Municipio)$', ''
    $noSuffix = $noSuffix.Trim()
    
    # Prefer exact matches, so use a separate lookup for fallback
    # Wait, simple way: we just let the later "city" overwrite "county" if we strip? No, we shouldn't overwrite if they share a prefix but are distinct entities, like Baltimore County vs Baltimore City!
    # Let's use an array of FIPS for ambiguous names if needed, or just prioritize exact string.
    
    $keyNoSuffix = "$stAbbr|$( $noSuffix.ToLower() )"
    if (-not $fipsLookup.ContainsKey($keyNoSuffix)) {
        $fipsLookup[$keyNoSuffix] = $fips
    }
    else {
        # Collision (e.g., Baltimore County & Baltimore City). 
        # We replace the value with "AMBIGUOUS" so we are forced to use the exact name.
        $fipsLookup[$keyNoSuffix] = "AMBIGUOUS"
    }
    
    # Store variations
    $noSpace = $noSuffix -replace '^(?i)(De|La|Le|Mc|St)\s+', '$1'
    if ($noSpace -ne $noSuffix) {
        $keyNoSpace = "$stAbbr|$( $noSpace.ToLower() )"
        if (-not $fipsLookup.ContainsKey($keyNoSpace)) { $fipsLookup[$keyNoSpace] = $fips }
    }
    
    if ($noSuffix -match '^(?i)(De|La|Le|Mc|St)(\S)') {
        $withSpace = $noSuffix -replace '^(?i)(De|La|Le|Mc|St)(\S)', '$1 $2'
        $keyWithSpace = "$stAbbr|$( $withSpace.ToLower() )"
        if (-not $fipsLookup.ContainsKey($keyWithSpace)) { $fipsLookup[$keyWithSpace] = $fips }
    }
    
    # Saint -> St.
    $stMatch = $noSuffix -replace '(?i)^Saint\s+', 'St. '
    if ($stMatch -ne $noSuffix) {
        $keySt = "$stAbbr|$( $stMatch.ToLower() )"
        if (-not $fipsLookup.ContainsKey($keySt)) { $fipsLookup[$keySt] = $fips }
    }
}

Write-Host "Census FIPS lookup: $($fipsLookup.Count) entries"

Write-Host "`n=== Step 2: Parsing EPA official XLS ==="
$xlsLines = Get-Content $xlsPath -Encoding UTF8
$officialEntries = [System.Collections.ArrayList]::new()
$skipped = [System.Collections.ArrayList]::new()

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
    if ($line -match '^County,State' -or $line -eq '.' -or $line.Trim() -eq '' -or $line -match '^UNITED STATES') { continue }
    if ($line -match '^[A-Z][A-Z ]+\tno data') { continue }
    
    $cols = $line -split "`t"
    if ($cols.Count -lt 5) { continue }
    
    $countyState = $cols[0].Trim()
    $countyLabel = $cols[1].Trim()
    $stateFull = $cols[2].Trim()
    $zone = $cols[4].Trim()
    
    if ($zone -notmatch '^[123]$') { continue }
    $zoneInt = [int]$zone
    
    # State abbr
    $stateAbbr = $null
    if ($countyState -match ',\s*([A-Z]{2})$') {
        $stateAbbr = $Matches[1]
    }
    elseif ($stateAbbrs.ContainsKey($stateFull)) {
        $stateAbbr = $stateAbbrs[$stateFull]
    }
    else { continue }

    # Clean EPA names
    $countyName = $countyState -replace ',\s*[A-Z]{2}$', ''
    $countyName = $countyName.Trim()
    
    $cleanLabel = $countyLabel -replace '^\.', ''
    $cleanLabel = $cleanLabel -replace ',\s*\.$', ''
    $cleanLabel = $cleanLabel.Trim()
    
    $fips = $null
    
    # Formulate trying queries
    $tryQueries = @()
    
    if ($stateFull -eq 'VA-CITY') {
        # VA independent cities often have "city" in Census
        $q1 = $cleanLabel -replace '(?i)\s+CITY$', '' -replace '(?i),\s*VA$', ''
        $tryQueries += "$($q1) city"
        $tryQueries += $q1
    }
    else {
        # Check standard and clean labels
        $tryQueries += $cleanLabel
        $tryQueries += $countyName
    }
    
    # For ambiguous cities inside counties (e.g. Baltimore)
    if ($cleanLabel -match '(?i)City') {
        $tryQueries = @("$($cleanLabel -replace '(?i)\s*City.*$', ' city')") + $tryQueries
    }
    elseif ($cleanLabel -match '(?i)County') {
        $tryQueries = @("$($cleanLabel -replace '(?i)\s*County.*$', ' County')") + $tryQueries
    }
    
    foreach ($q in $tryQueries) {
        if ([string]::IsNullOrWhiteSpace($q)) { continue }
        
        $kLower = "$stateAbbr|$( $q.ToLower() )"
        $kStrip = "$stateAbbr|$( ($q -replace '(?i)\s+(County|Parish|Borough|Census Area|Municipality|City and Borough|city|Municipio)$', '').Trim().ToLower() )"
        
        # 1. Exact match
        if ($fipsLookup.ContainsKey($kLower) -and $fipsLookup[$kLower] -ne "AMBIGUOUS") {
            $fips = $fipsLookup[$kLower]
            break
        }
        
        # 2. Stripped match
        if ($fipsLookup.ContainsKey($kStrip) -and $fipsLookup[$kStrip] -ne "AMBIGUOUS") {
            $fips = $fipsLookup[$kStrip]
            break
        }
        
        # 3. Special St. / Saint handling on stripped
        $stp = $kStrip -replace '(?i)\|st\.?\s+', '|saint '
        if ($fipsLookup.ContainsKey($stp) -and $fipsLookup[$stp] -ne "AMBIGUOUS") {
            $fips = $fipsLookup[$stp]
            break
        }
        $st2 = $kStrip -replace '(?i)\|saint\s+', '|st. '
        if ($fipsLookup.ContainsKey($st2) -and $fipsLookup[$st2] -ne "AMBIGUOUS") {
            $fips = $fipsLookup[$st2]
            break
        }
    }
    
    # If still ambiguous, try to resolve by appending County or city to stripped name
    if (-not $fips -and $fipsLookup[$kStrip] -eq "AMBIGUOUS") {
        if ($stateFull -eq 'VA-CITY' -or $cleanLabel -match '(?i)city') {
            $tryA = "$kStrip city"
            if ($fipsLookup.ContainsKey($tryA)) { $fips = $fipsLookup[$tryA] }
        }
        else {
            $tryA = "$kStrip county"
            if ($fipsLookup.ContainsKey($tryA)) { $fips = $fipsLookup[$tryA] }
        }
    }
    
    $outputName = if ($cleanLabel) { $cleanLabel } else { $countyName }
    $outputName = $outputName -replace '(?i)\s+(County|Parish|Borough|Census Area|Municipality|City and Borough|city)$', ''
    
    if ($fips) {
        # Check if already added (some EPA zones might be weirdly duplicated in source)
        $existing = $officialEntries | Where-Object { $_.fips -eq $fips }
        if (-not $existing) {
            $null = $officialEntries.Add([PSCustomObject]@{
                    fips        = $fips
                    state_abbr  = $stateAbbr
                    county_name = $outputName
                    epa_zone    = $zoneInt
                })
        }
    }
    else {
        $null = $skipped.Add([PSCustomObject]@{
                state_abbr  = $stateAbbr
                county_name = $outputName
                lookup_name = $countyName
                epa_zone    = $zoneInt
            })
    }
}

Write-Host "Parsed entries with FIPS: $($officialEntries.Count)"
Write-Host "Skipped (no FIPS match): $($skipped.Count)"

if ($skipped.Count -gt 0) {
    Write-Host "`n--- Entries without FIPS (skipped) ---"
    foreach ($s in ($skipped | Sort-Object state_abbr, county_name)) {
        Write-Host "  $($s.state_abbr) | $($s.county_name) (lookup: $($s.lookup_name)) Zone $($s.epa_zone)"
    }
}

Write-Host "`n=== Step 3: Generate JSON ==="
$sorted = $officialEntries | Sort-Object fips

$dups = $sorted | Group-Object fips | Where-Object { $_.Count -gt 1 }
if ($dups.Count -gt 0) {
    Write-Host "WARNING: $($dups.Count) duplicate FIPS codes found!"
}

$sb = [System.Text.StringBuilder]::new()
$null = $sb.AppendLine('[')
$count = 0
foreach ($entry in $sorted) {
    $count++
    $comma = if ($count -lt $sorted.Count) { ',' } else { '' }
    $name = $entry.county_name -replace '"', '\"' -replace '\\', '\\'
    $null = $sb.AppendLine("  {`"fips`": `"$($entry.fips)`", `"state_abbr`": `"$($entry.state_abbr)`", `"county_name`": `"$name`", `"epa_zone`": $($entry.epa_zone)}$comma")
}
$null = $sb.AppendLine(']')

[System.IO.File]::WriteAllText($outputPath, $sb.ToString(), [System.Text.Encoding]::UTF8)
Write-Host "Wrote $count entries to: $outputPath"
