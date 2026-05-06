param(
    [string]$OutputPath = "data/nc_radon_measurements.json"
)

$ErrorActionPreference = "Stop"

$sourceUrl = "https://www.ncdhhs.gov/divisions/health-service-regulation/north-carolina-radon-program/nc-radon-data"
$dataUrl = "https://www.ncdhhs.gov/tablefield/export/paragraph/3328/field_map_data/en/0"
$sourceName = "North Carolina DHHS Radon Data Map"
$period = "updated 2025-08-06"
$retrievedAt = "2026-05-06"
$caveat = "NCDHHS says the public map shows the highest measured radon level in each county from two test kit companies and one continuous-monitor leasing company. RadonVerdict stores that value only as a high-end county signal, not as a county average or a prediction for a particular building."

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
$ncCounties = @($geo | Where-Object { $_.state_abbr -eq "NC" })
$countyByNameKey = @{}
foreach ($county in $ncCounties) {
    $key = Normalize-Name $county.county_name
    if (-not $countyByNameKey.ContainsKey($key)) {
        $countyByNameKey[$key] = @()
    }
    $countyByNameKey[$key] += $county
}

$csv = Download-Text $dataUrl
$rows = @($csv.TrimStart([char]0xFEFF) | ConvertFrom-Csv)
$unmatched = @()
$unparsed = @()
$records = foreach ($row in $rows) {
    if ([string]::IsNullOrWhiteSpace($row.county)) {
        continue
    }

    $match = [regex]::Match("$($row.title)", "([0-9]+(?:\.[0-9]+)?)")
    if (-not $match.Success) {
        $unparsed += "$($row.county): $($row.title)"
        continue
    }

    $key = Normalize-Name $row.county
    $matches = @($countyByNameKey[$key] | Where-Object { $null -ne $_ })
    if ($matches.Count -ne 1) {
        $unmatched += "$($row.county)"
        continue
    }

    $county = $matches[0]
    [ordered]@{
        county_fips = $county.fips
        state_abbr = "NC"
        county_name = $county.county_name
        source_id = "nc_dhhs_radon"
        source_name = $sourceName
        source_url = $sourceUrl
        period = $period
        retrieved_at = $retrievedAt
        caveat = $caveat
        metrics = [ordered]@{
            maximum_test_result_pci_l = Round-Nullable $match.Groups[1].Value 1
        }
    }
}

if ($unmatched.Count -gt 0) {
    throw "Unmatched North Carolina counties from DHHS map export: $($unmatched -join ', ')"
}
if ($unparsed.Count -gt 0) {
    throw "Unparsed North Carolina radon values: $($unparsed -join '; ')"
}

$records = @($records | Sort-Object { $_["state_abbr"] }, { $_["county_name"] }, { $_["county_fips"] })
$json = $records | ConvertTo-Json -Depth 10
Set-Content -LiteralPath $OutputPath -Value $json -Encoding UTF8

Write-Host "Wrote $($records.Count) NC county radon measurement records from $dataUrl to $OutputPath"
