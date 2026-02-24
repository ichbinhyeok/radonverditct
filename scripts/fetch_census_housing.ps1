# fetch_census_housing.ps1
# Fetches US Census ACS5 2022 Data Profile (DP04 Housing) for all counties.
# Computes "Percentage of homes built before 1980" and "Median Home Value".

$ErrorActionPreference = "Stop"

$apiUrl = "https://api.census.gov/data/2022/acs/acs5/profile?get=NAME,DP04_0001E,DP04_0017E,DP04_0018E,DP04_0019E,DP04_0020E,DP04_0021E,DP04_0089E&for=county:*"

$outputPath = Join-Path $PSScriptRoot "..\src\main\resources\data\county_stats.json"

Write-Host "Fetching Census ACS 2022 Housing Profile data..."
$response = Invoke-RestMethod -Uri $apiUrl -Method Get

# Response is an array of arrays.
# Index 0 is the header: ["NAME","DP04_0001E","DP04_0017E","DP04_0018E","DP04_0019E","DP04_0020E","DP04_0021E","DP04_0089E","state","county"]
$headers = $response[0]
$dataRows = $response | Select-Object -Skip 1

$countiesData = @{}
$currentDate = Get-Date -Format "yyyy-MM-dd"

foreach ($row in $dataRows) {
    # Extract fips: state (index 8) + county (index 9)
    $fips = $row[8] + $row[9]
    $name = $row[0]

    # Convert to numeric, handle nulls/negatives
    # Census uses negative numbers (-666666666) for missing/N/A margins of error or estimates
    $totalUnits = [int]($row[1] -replace '[^\d\.-]', '')
    $b1970 = [int]($row[2] -replace '[^\d\.-]', '')
    $b1960 = [int]($row[3] -replace '[^\d\.-]', '')
    $b1950 = [int]($row[4] -replace '[^\d\.-]', '')
    $b1940 = [int]($row[5] -replace '[^\d\.-]', '')
    $b1939 = [int]($row[6] -replace '[^\d\.-]', '')
    $medianValue = [int]($row[7] -replace '[^\d\.-]', '')

    if ($totalUnits -lt 0) { $totalUnits = 0 }
    if ($b1970 -lt 0) { $b1970 = 0 }
    if ($b1960 -lt 0) { $b1960 = 0 }
    if ($b1950 -lt 0) { $b1950 = 0 }
    if ($b1940 -lt 0) { $b1940 = 0 }
    if ($b1939 -lt 0) { $b1939 = 0 }
    if ($medianValue -lt 0) { $medianValue = 0 }

    $builtBefore1980 = $b1970 + $b1960 + $b1950 + $b1940 + $b1939
    
    $pctBefore1980 = 0.0
    if ($totalUnits -gt 0) {
        $pctBefore1980 = [math]::Round(($builtBefore1980 / $totalUnits) * 100, 1)
    }

    $countiesData[$fips] = @{
        county_fips      = $fips
        county_name_full = $name
        retrieved_at     = $currentDate
        sources          = @(
            @{
                name         = "US Census Bureau, 2018-2022 American Community Survey 5-Year Estimates"
                url          = "https://www.census.gov/programs-surveys/acs"
                retrieved_at = $currentDate
            }
        )
        metrics          = @{
            total_housing_units   = $totalUnits
            built_before_1980_pct = $pctBefore1980
            median_home_value     = $medianValue
        }
    }
}

Write-Host "Processed $($countiesData.Count) counties."

# Convert to JSON and save
$jsonOutput = $countiesData | ConvertTo-Json -Depth 5 -Compress
Set-Content -Path $outputPath -Value $jsonOutput -Encoding UTF8

Write-Host "Successfully saved county stats to $outputPath"
