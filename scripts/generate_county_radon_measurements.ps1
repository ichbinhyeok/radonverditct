param(
    [string]$OutputPath = "src/main/resources/data/county_radon_measurements.json",
    [switch]$SkipCdc
)

$ErrorActionPreference = "Stop"

$tempDir = Join-Path $env:TEMP ("rv_radon_measurements_" + [guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

try {
    $nyPath = Join-Path $tempDir "ny.json"
    $mnPath = Join-Path $tempDir "mn.json"
    $ksPath = Join-Path $tempDir "ks.json"
    $coPath = Join-Path $tempDir "co.json"
    $ilPath = Join-Path $tempDir "il.json"
    $iaPath = Join-Path $tempDir "ia.json"
    $ncPath = Join-Path $tempDir "nc.json"
    $msPath = Join-Path $tempDir "ms.json"
    $wiPath = Join-Path $tempDir "wi.json"
    $tnPath = Join-Path $tempDir "tn.json"
    $paPath = Join-Path $tempDir "pa.json"
    $vaPath = Join-Path $tempDir "va.json"
    $moPath = Join-Path $tempDir "mo.json"
    $utPath = Join-Path $tempDir "ut.json"
    $cdcPath = Join-Path $tempDir "cdc.json"

    if (-not $SkipCdc) {
        & "$PSScriptRoot/generate_cdc_radon_measurements.ps1" -OutputPath $cdcPath
    }
    & "$PSScriptRoot/generate_ny_radon_measurements.ps1" -OutputPath $nyPath
    & "$PSScriptRoot/generate_mn_radon_measurements.ps1" -OutputPath $mnPath
    & "$PSScriptRoot/generate_ks_radon_measurements.ps1" -OutputPath $ksPath
    & "$PSScriptRoot/generate_co_radon_measurements.ps1" -OutputPath $coPath
    & "$PSScriptRoot/generate_il_radon_measurements.ps1" -OutputPath $ilPath
    & "$PSScriptRoot/generate_ia_radon_measurements.ps1" -OutputPath $iaPath
    & "$PSScriptRoot/generate_nc_radon_measurements.ps1" -OutputPath $ncPath
    & "$PSScriptRoot/generate_ms_radon_measurements.ps1" -OutputPath $msPath
    & "$PSScriptRoot/generate_wi_radon_measurements.ps1" -OutputPath $wiPath
    & "$PSScriptRoot/generate_tn_radon_measurements.ps1" -OutputPath $tnPath
    & "$PSScriptRoot/generate_pa_radon_measurements.ps1" -OutputPath $paPath -CountyFips @(
        "42001", "42003", "42005", "42007", "42009", "42011", "42013", "42017", "42019",
        "42021", "42027", "42029", "42031", "42033", "42041", "42043", "42045",
        "42015", "42025", "42035", "42037", "42049", "42051", "42055", "42061", "42063",
        "42067", "42071", "42075", "42077", "42081", "42085", "42097", "42107", "42109",
        "42115", "42117", "42119", "42131", "42069", "42079", "42087", "42089", "42091",
        "42095", "42099", "42121", "42125", "42129", "42133"
    )
    & "$PSScriptRoot/generate_va_radon_measurements.ps1" -OutputPath $vaPath
    & "$PSScriptRoot/generate_mo_radon_measurements.ps1" -OutputPath $moPath
    & "$PSScriptRoot/generate_ut_radon_measurements.ps1" -OutputPath $utPath

    $recordsByFips = @{}
    foreach ($path in @($cdcPath, $nyPath, $mnPath, $ksPath, $coPath, $ilPath, $iaPath, $ncPath, $msPath, $wiPath, $tnPath, $paPath, $vaPath, $moPath, $utPath)) {
        if (Test-Path -LiteralPath $path) {
            $sourceRecords = Get-Content -LiteralPath $path -Raw | ConvertFrom-Json
            foreach ($record in $sourceRecords) {
                if (-not [string]::IsNullOrWhiteSpace($record.county_fips)) {
                    $recordsByFips[$record.county_fips] = $record
                }
            }
        }
    }

    $records = @($recordsByFips.Values | Sort-Object state_abbr, county_name)
    $json = $records | ConvertTo-Json -Depth 10
    Set-Content -LiteralPath $OutputPath -Value $json -Encoding UTF8

    $byState = $records | Group-Object state_abbr | Sort-Object Name |
        ForEach-Object { "$($_.Name)=$($_.Count)" }
    Write-Host "Wrote $($records.Count) county radon measurement records to $OutputPath ($($byState -join ', '))"
}
finally {
    if (Test-Path -LiteralPath $tempDir) {
        Remove-Item -LiteralPath $tempDir -Recurse -Force
    }
}
