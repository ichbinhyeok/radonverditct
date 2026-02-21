$censusPath = 'c:\Development\Owner\radonVerdict\scripts\national_county.txt'
$outputPath = 'c:\Development\Owner\radonVerdict\src\main\resources\data\geo_counties.json'

Write-Host "Reading Census Data..."
$censusLines = Get-Content $censusPath -Encoding UTF8

$stateMap = @{
    'AL' = 'Alabama'; 'AK' = 'Alaska'; 'AZ' = 'Arizona'; 'AR' = 'Arkansas'; 'CA' = 'California';
    'CO' = 'Colorado'; 'CT' = 'Connecticut'; 'DE' = 'Delaware'; 'DC' = 'District of Columbia';
    'FL' = 'Florida'; 'GA' = 'Georgia'; 'HI' = 'Hawaii'; 'ID' = 'Idaho'; 'IL' = 'Illinois';
    'IN' = 'Indiana'; 'IA' = 'Iowa'; 'KS' = 'Kansas'; 'KY' = 'Kentucky'; 'LA' = 'Louisiana';
    'ME' = 'Maine'; 'MD' = 'Maryland'; 'MA' = 'Massachusetts'; 'MI' = 'Michigan'; 'MN' = 'Minnesota';
    'MS' = 'Mississippi'; 'MO' = 'Missouri'; 'MT' = 'Montana'; 'NE' = 'Nebraska'; 'NV' = 'Nevada';
    'NH' = 'New Hampshire'; 'NJ' = 'New Jersey'; 'NM' = 'New Mexico'; 'NY' = 'New York';
    'NC' = 'North Carolina'; 'ND' = 'North Dakota'; 'OH' = 'Ohio'; 'OK' = 'Oklahoma'; 'OR' = 'Oregon';
    'PA' = 'Pennsylvania'; 'RI' = 'Rhode Island'; 'SC' = 'South Carolina'; 'SD' = 'South Dakota';
    'TN' = 'Tennessee'; 'TX' = 'Texas'; 'UT' = 'Utah'; 'VT' = 'Vermont'; 'VA' = 'Virginia';
    'WA' = 'Washington'; 'WV' = 'West Virginia'; 'WI' = 'Wisconsin'; 'WY' = 'Wyoming';
    'PR' = 'Puerto Rico'; 'VI' = 'Virgin Islands'; 'GU' = 'Guam'; 'MP' = 'Northern Mariana Islands'; 'AS' = 'American Samoa'
}

function ConvertTo-Slug {
    param([string]$Text)
    $slug = $Text.ToLower()
    $slug = $slug -replace '[^a-z0-9\s-]', ''
    $slug = $slug -replace '\s+', '-'
    $slug = $slug -replace '-+', '-'
    $slug = $slug.Trim('-')
    return $slug
}

$counties = [System.Collections.ArrayList]::new()

foreach ($line in $censusLines) {
    $parts = $line -split ','
    if ($parts.Count -lt 4) { continue }
    
    $stAbbr = $parts[0].Trim()
    $stFp = $parts[1].Trim()
    $coFp = $parts[2].Trim()
    $coNameRaw = $parts[3].Trim()
    
    if ($stFp -notmatch '^\d{2}$' -or $coFp -notmatch '^\d{3}$') { continue }
    if (-not $stateMap.ContainsKey($stAbbr)) { continue } # Skip territories if we only want 50 states + DC, PR? We map PR but let's see.
    
    # Exclude territories if needed, but keeping them is fine. EPA handles US states. Let's include PR as it could be useful, or we can filter it out later.
    
    $fips = "$stFp$coFp"
    $stateName = $stateMap[$stAbbr]
    $stateSlug = ConvertTo-Slug $stateName
    
    # Strip some suffixes for a clean county name (Optional, but usually we just keep "Autauga County" in geo_counties?
    # Looking at the previous geo_counties.json, usually it was short "Autauga" or full?
    # Let's keep the short version for county_name to match EPA zone logic better, but the slug might have -county.
    # Previous geo_counties.json example: "county_name": "Autauga", "county_slug": "autauga-county"
    # So we'll parse these carefully.
    
    $cleanName = $coNameRaw -replace '\s+(County|Parish|Borough|Census Area|Municipality|City and Borough)$', ''
    $cleanName = $cleanName.Trim()
    
    # Independent cities in VA (e.g. "Richmond city") 
    $cleanName = $cleanName -replace '(?i)\s+city$', ''
    
    $countySlugBase = $cleanName
    
    # For standard counties, we might want to append "county" to slug if it's not a city/parish/borough
    # Actually, using the raw name's slug is perfectly fine: "Autauga County" -> "autauga-county"
    $countySlug = ConvertTo-Slug $coNameRaw
    
    $null = $counties.Add([PSCustomObject]@{
            fips        = $fips
            state_abbr  = $stAbbr
            state_name  = $stateName
            county_name = $cleanName
            state_slug  = $stateSlug
            county_slug = $countySlug
        })
}

Write-Host "Generated $($counties.Count) counties."

# Generate JSON
$sb = [System.Text.StringBuilder]::new()
$null = $sb.AppendLine('[')
$count = 0
foreach ($c in $counties) {
    $count++
    $comma = if ($count -lt $counties.Count) { ',' } else { '' }
    $cName = $c.county_name -replace '"', '\"' -replace '\\', '\\'
    # Format according to JSON
    $null = $sb.AppendLine("  {")
    $null = $sb.AppendLine("    `"fips`": `"$($c.fips)`",")
    $null = $sb.AppendLine("    `"state_abbr`": `"$($c.state_abbr)`",")
    $null = $sb.AppendLine("    `"state_name`": `"$($c.state_name)`",")
    $null = $sb.AppendLine("    `"county_name`": `"$cName`",")
    $null = $sb.AppendLine("    `"state_slug`": `"$($c.state_slug)`",")
    $null = $sb.AppendLine("    `"county_slug`": `"$($c.county_slug)`"")
    $null = $sb.Append("  }$comma`n")
}
$null = $sb.AppendLine(']')

[System.IO.File]::WriteAllText($outputPath, $sb.ToString(), [System.Text.Encoding]::UTF8)
Write-Host "Successfully wrote geo_counties.json to $outputPath"
