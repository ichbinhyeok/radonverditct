param(
    [string]$OutputPath = "data/ia_radon_measurements.json"
)

$ErrorActionPreference = "Stop"

$sourceUrl = "https://hhs.iowa.gov/health-prevention/providers-professionals/radiological-health/radon"
$dataUrl = "https://data.idph.state.ia.us/t/IDPH-DataViz/views/RadonDashboard/RadonCountyMetrics.csv"
$sourceName = "Iowa HHS Radon Dashboard County Metrics"
$period = "current dashboard export"
$retrievedAt = "2026-05-06"
$caveat = "Iowa HHS/IDPH publishes county median radon values through a public Tableau CSV export. RadonVerdict stores the median county test result as a county context signal; it is not a prediction for any individual home, and Iowa HHS still recommends testing because high levels can be found in any type of home."

function Normalize-Name($value) {
    if ($null -eq $value) {
        return ""
    }
    $text = "$value".Trim().ToLowerInvariant()
    $text = $text -replace "\s+county$", ""
    return $text -replace "[^a-z0-9]", ""
}

function Round-Nullable($value, [int]$digits = 1) {
    if ($null -eq $value) {
        return $null
    }
    return [math]::Round([double]$value, $digits)
}

function Get-PropertyValue($row, [string]$name) {
    $property = $row.PSObject.Properties | Where-Object { $_.Name.Trim() -eq $name } | Select-Object -First 1
    if ($null -eq $property) {
        return $null
    }
    return $property.Value
}

function Download-Text([string]$url) {
    Add-Type -AssemblyName System.Net.Http
    $client = [System.Net.Http.HttpClient]::new()
    $client.Timeout = [TimeSpan]::FromSeconds(90)
    $client.DefaultRequestHeaders.UserAgent.ParseAdd("Mozilla/5.0 RadonVerdictDataBot/1.0")
    try {
        $response = $client.GetAsync($url).Result
        $response.EnsureSuccessStatusCode() | Out-Null
        return $response.Content.ReadAsStringAsync().Result
    }
    finally {
        $client.Dispose()
    }
}

$geo = Get-Content -LiteralPath "src/main/resources/data/geo_counties.json" -Raw | ConvertFrom-Json
$iaCounties = @($geo | Where-Object { $_.state_abbr -eq "IA" })
$countyByNameKey = @{}
foreach ($county in $iaCounties) {
    $key = Normalize-Name $county.county_name
    if (-not $countyByNameKey.ContainsKey($key)) {
        $countyByNameKey[$key] = @()
    }
    $countyByNameKey[$key] += $county
}

$csv = Download-Text $dataUrl
$rows = @($csv.TrimStart([char]0xFEFF) | ConvertFrom-Csv)
$unmatched = @()
$records = foreach ($row in $rows) {
    $countyName = Get-PropertyValue $row "County Name"
    $medianValue = Get-PropertyValue $row "Median TestWithNumericValues"
    if ([string]::IsNullOrWhiteSpace($countyName) -or [string]::IsNullOrWhiteSpace("$medianValue")) {
        continue
    }

    $key = Normalize-Name $countyName
    $matches = @($countyByNameKey[$key] | Where-Object { $null -ne $_ })
    if ($matches.Count -ne 1) {
        $unmatched += "$countyName"
        continue
    }

    $county = $matches[0]
    [ordered]@{
        county_fips = $county.fips
        state_abbr = "IA"
        county_name = $county.county_name
        source_id = "ia_hhs_radon"
        source_name = $sourceName
        source_url = $sourceUrl
        period = $period
        retrieved_at = $retrievedAt
        caveat = $caveat
        metrics = [ordered]@{
            median_radon_value_pci_l = Round-Nullable $medianValue 1
        }
    }
}

if ($unmatched.Count -gt 0) {
    throw "Unmatched Iowa counties from HHS dashboard export: $($unmatched -join ', ')"
}

$records = @($records | Sort-Object { $_["state_abbr"] }, { $_["county_name"] }, { $_["county_fips"] })
$json = $records | ConvertTo-Json -Depth 10
Set-Content -LiteralPath $OutputPath -Value $json -Encoding UTF8

Write-Host "Wrote $($records.Count) IA county radon measurement records from $dataUrl to $OutputPath"
