param(
    [string]$OutputPath = "src/main/resources/data/radon_measurement_coverage.json"
)

$ErrorActionPreference = "Stop"

$geo = Get-Content -LiteralPath "src/main/resources/data/geo_counties.json" -Raw | ConvertFrom-Json
$stats = Get-Content -LiteralPath "src/main/resources/data/county_stats.json" -Raw | ConvertFrom-Json
$zoneRows = Get-Content -LiteralPath "src/main/resources/data/epa_county_radon_zones.json" -Raw | ConvertFrom-Json
$measurements = Get-Content -LiteralPath "src/main/resources/data/county_radon_measurements.json" -Raw | ConvertFrom-Json
$tierRows = if (Test-Path -LiteralPath "src/main/resources/data/county_radon_tiers.json") {
    Get-Content -LiteralPath "src/main/resources/data/county_radon_tiers.json" -Raw | ConvertFrom-Json
} else {
    @()
}
$sources = Get-Content -LiteralPath "src/main/resources/data/radon_measurement_sources.json" -Raw | ConvertFrom-Json

$zones = @{}
foreach ($zone in $zoneRows) {
    $zones[$zone.fips] = $zone
}

$measurementsByFips = @{}
foreach ($measurement in $measurements) {
    if (-not [string]::IsNullOrWhiteSpace($measurement.county_fips)) {
        $measurementsByFips[$measurement.county_fips] = $measurement
    }
}

$tiersByFips = @{}
foreach ($tier in $tierRows) {
    if (-not [string]::IsNullOrWhiteSpace($tier.county_fips)) {
        $tiersByFips[$tier.county_fips] = $tier
    }
}

$sourcesById = @{}
foreach ($source in $sources) {
    $sourcesById[$source.id] = $source
}

$policySource = Get-Content -LiteralPath "src/main/java/com/radonverdict/service/SeoIndexingPolicyService.java" -Raw
$historicalPriority = @{}
[regex]::Matches($policySource, '"([a-z\-]+/[a-z0-9\-]+)"') | ForEach-Object {
    $historicalPriority[$_.Groups[1].Value] = $true
}

$stateSourceMap = @{
    "NY" = "ny_doh_tracking_radon"
    "MN" = "mn_health_radon"
    "VA" = "va_vdh_radon"
    "PA" = "pa_dep_radon_zip"
    "TN" = "tn_health_radon"
    "WI" = "wi_dhs_radon"
    "CO" = "co_cdphe_radon"
    "IA" = "ia_hhs_radon"
    "NC" = "nc_dhhs_radon"
    "NJ" = "nj_dep_radon_potential"
    "KS" = "ks_kdhe_radon"
    "MS" = "epa_usgs_ms_residential_radon_survey"
    "UT" = "ut_epht_radon"
}

function Get-SourceName([string]$sourceId) {
    if ($sourcesById.ContainsKey($sourceId)) {
        return $sourcesById[$sourceId].name
    }
    return $sourceId
}

$retained = foreach ($county in $geo) {
    $fips = $county.fips
    $stat = $stats.$fips
    $zone = $zones[$fips]

    if (-not $stat -or -not $stat.metrics -or [int]$stat.metrics.total_housing_units -le 0) {
        continue
    }
    if (-not $zone) {
        continue
    }

    $epaZone = [int]$zone.epa_zone
    if ($epaZone -le 0 -or $epaZone -eq 3) {
        continue
    }

    $housing = [int]$stat.metrics.total_housing_units
    $key = "$($county.state_slug)/$($county.county_slug)"
    $isHistorical = $historicalPriority.ContainsKey($key)
    $keep = $isHistorical -or $housing -ge 50000 -or ($epaZone -eq 1 -and $housing -ge 10000)

    if (-not $keep) {
        continue
    }

    $measurement = $measurementsByFips[$fips]
    $tier = $tiersByFips[$fips]
    $sourceId = $null
    $sourceName = $null
    $coverageStatus = $null
    $moatLevel = $null
    $nextSourceId = $null
    $nextSourceName = $null

    if ($measurement) {
        $sourceId = $measurement.source_id
        $sourceName = $measurement.source_name
        $coverageStatus = "measurement_ingested"
        $moatLevel = "county_measurement"
    } elseif ($tier) {
        $sourceId = $tier.source_id
        $sourceName = $tier.source_name
        $coverageStatus = "tier_ingested"
        $moatLevel = "official_tier_source"
    } elseif ($stateSourceMap.ContainsKey($county.state_abbr)) {
        $nextSourceId = $stateSourceMap[$county.state_abbr]
        $nextSourceName = Get-SourceName $nextSourceId
        $coverageStatus = "state_source_identified"
        $moatLevel = "source_plan_ready"
    } else {
        $nextSourceId = "cdc_tracking_radon"
        $nextSourceName = Get-SourceName $nextSourceId
        $coverageStatus = "cdc_source_needed"
        $moatLevel = "national_fallback_needed"
    }

    [pscustomobject][ordered]@{
        fips = $fips
        state_abbr = $county.state_abbr
        state_name = $county.state_name
        county_name = $county.county_name
        slug_key = $key
        epa_zone = $epaZone
        housing_units = $housing
        historical_priority = $isHistorical
        coverage_status = $coverageStatus
        moat_level = $moatLevel
        measurement_source_id = $sourceId
        measurement_source_name = $sourceName
        measurement_period = if ($measurement) { $measurement.period } else { $null }
        next_source_id = $nextSourceId
        next_source_name = $nextSourceName
    }
}

$retained = @($retained | Sort-Object state_abbr, county_name)
$coverageCounts = @{}
$retained | Group-Object coverage_status | ForEach-Object {
    $coverageCounts[$_.Name] = $_.Count
}

$stateCoverage = @($retained | Group-Object state_abbr | Sort-Object Count -Descending | ForEach-Object {
    $group = $_.Group
    [pscustomobject][ordered]@{
        state_abbr = $_.Name
        retained_count = $_.Count
        measurement_ingested = @($group | Where-Object { $_.coverage_status -eq "measurement_ingested" }).Count
        tier_ingested = @($group | Where-Object { $_.coverage_status -eq "tier_ingested" }).Count
        state_source_identified = @($group | Where-Object { $_.coverage_status -eq "state_source_identified" }).Count
        cdc_source_needed = @($group | Where-Object { $_.coverage_status -eq "cdc_source_needed" }).Count
    }
})

$matrix = [ordered]@{
    generated_at = (Get-Date).ToString("yyyy-MM-dd")
    retained_count = $retained.Count
    measurement_ingested_count = @($retained | Where-Object { $_.coverage_status -eq "measurement_ingested" }).Count
    tier_ingested_count = @($retained | Where-Object { $_.coverage_status -eq "tier_ingested" }).Count
    state_source_identified_count = @($retained | Where-Object { $_.coverage_status -eq "state_source_identified" }).Count
    cdc_source_needed_count = @($retained | Where-Object { $_.coverage_status -eq "cdc_source_needed" }).Count
    coverage_counts = $coverageCounts
    state_coverage = $stateCoverage
    counties = $retained
}

$json = $matrix | ConvertTo-Json -Depth 8
Set-Content -LiteralPath $OutputPath -Value $json -Encoding UTF8

Write-Host "Wrote retained county measurement coverage matrix to $OutputPath"
Write-Host "Retained=$($matrix.retained_count), measured=$($matrix.measurement_ingested_count), tier=$($matrix.tier_ingested_count), state-source-identified=$($matrix.state_source_identified_count), cdc-needed=$($matrix.cdc_source_needed_count)"
