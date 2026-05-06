param(
    [string]$OutputPath = "src/main/resources/data/county_radon_tiers.json"
)

$ErrorActionPreference = "Stop"

$sourceUrl = "https://www.nj.gov/dep/rpp/radon/ctytiera.htm"
$retrievedAt = "2026-05-05"
$sourceName = "New Jersey DEP Radon Potential Municipality Tier Table"
$caveat = "NJ DEP radon tiers are municipal radon potential designations derived from radon testing data; they are not a county mean pCi/L measurement."

$geo = Get-Content -LiteralPath "src/main/resources/data/geo_counties.json" -Raw | ConvertFrom-Json
$njCountiesByName = @{}
foreach ($county in $geo) {
    if ($county.state_abbr -eq "NJ") {
        $njCountiesByName[$county.county_name.ToUpperInvariant()] = $county
    }
}

$html = (Invoke-WebRequest -Uri $sourceUrl -UseBasicParsing -TimeoutSec 90).Content
$headers = [regex]::Matches($html, '<strong>\s*([^<]+ County)\s*</strong>', 'IgnoreCase')

$records = for ($i = 0; $i -lt $headers.Count; $i++) {
    $header = $headers[$i]
    $countyFullName = $header.Groups[1].Value.Trim()
    $countyName = ($countyFullName -replace '\s+County$', '').Trim()
    if (-not $njCountiesByName.ContainsKey($countyName.ToUpperInvariant())) {
        continue
    }

    $start = $header.Index
    $end = if ($i -lt $headers.Count - 1) { $headers[$i + 1].Index } else { $html.Length }
    $segment = $html.Substring($start, $end - $start)
    $rows = [regex]::Matches($segment, '<td>\s*([^<]+?)\s*</td>\s*<td>\s*([123])\s*</td>', 'IgnoreCase')

    $tier1 = 0
    $tier2 = 0
    $tier3 = 0
    foreach ($row in $rows) {
        switch ([int]$row.Groups[2].Value) {
            1 { $tier1++ }
            2 { $tier2++ }
            3 { $tier3++ }
        }
    }

    $total = $tier1 + $tier2 + $tier3
    if ($total -eq 0) {
        continue
    }

    $dominantTier = 1
    $dominantCount = $tier1
    if ($tier2 -gt $dominantCount) {
        $dominantTier = 2
        $dominantCount = $tier2
    }
    if ($tier3 -gt $dominantCount) {
        $dominantTier = 3
    }

    $highestRiskTier = if ($tier1 -gt 0) { 1 } elseif ($tier2 -gt 0) { 2 } else { 3 }
    $county = $njCountiesByName[$countyName.ToUpperInvariant()]

    [ordered]@{
        county_fips = $county.fips
        state_abbr = "NJ"
        county_name = $county.county_name
        source_id = "nj_dep_radon_potential"
        source_name = $sourceName
        source_url = $sourceUrl
        retrieved_at = $retrievedAt
        caveat = $caveat
        municipality_count = $total
        tier_1_count = $tier1
        tier_2_count = $tier2
        tier_3_count = $tier3
        tier_1_pct = [math]::Round(($tier1 * 100.0) / $total, 1)
        tier_1_or_2_pct = [math]::Round((($tier1 + $tier2) * 100.0) / $total, 1)
        dominant_tier = $dominantTier
        highest_risk_tier = $highestRiskTier
    }
}

$records = @($records | Sort-Object county_name)
$json = $records | ConvertTo-Json -Depth 8
Set-Content -LiteralPath $OutputPath -Value $json -Encoding UTF8
Write-Host "Wrote $($records.Count) NJ county radon tier records to $OutputPath"
