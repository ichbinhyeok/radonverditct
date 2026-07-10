param(
    [Parameter(Mandatory = $true)]
    [string]$InputPath,
    [string]$OutputPath = "data/search-console-query-page.csv"
)

if (-not (Test-Path -LiteralPath $InputPath)) {
    throw "GSC query/page export not found: $InputPath"
}

function Get-ColumnValue($row, [string[]]$names) {
    foreach ($name in $names) {
        $property = $row.PSObject.Properties | Where-Object {
            ($_.Name -replace '[^A-Za-z0-9]', '').ToLowerInvariant() -eq ($name -replace '[^A-Za-z0-9]', '').ToLowerInvariant()
        } | Select-Object -First 1
        if ($null -ne $property -and $null -ne $property.Value) {
            return [string]$property.Value
        }
    }
    return ''
}

function Get-Number($value) {
    if ([string]::IsNullOrWhiteSpace($value)) { return 0 }
    $normalized = $value.Replace(',', '').Replace('%', '').Trim()
    $parsed = 0.0
    if ([double]::TryParse($normalized, [Globalization.NumberStyles]::Float, [Globalization.CultureInfo]::InvariantCulture, [ref]$parsed)) {
        return $parsed
    }
    return 0
}

$rows = Import-Csv -LiteralPath $InputPath | ForEach-Object {
    $query = Get-ColumnValue $_ @('query', 'keyword', 'search query')
    $page = Get-ColumnValue $_ @('page', 'url', 'landing page')
    if (-not [string]::IsNullOrWhiteSpace($query) -and -not [string]::IsNullOrWhiteSpace($page)) {
        [pscustomobject]@{
            Query = $query.Trim()
            Page = $page.Trim()
            Clicks = Get-Number (Get-ColumnValue $_ @('clicks', 'click'))
            Impressions = Get-Number (Get-ColumnValue $_ @('impressions', 'impression'))
            CTR = Get-Number (Get-ColumnValue $_ @('ctr'))
            Position = Get-Number (Get-ColumnValue $_ @('position', 'average position', 'avg position'))
        }
    }
}

$parent = Split-Path -Parent $OutputPath
if ($parent -and -not (Test-Path -LiteralPath $parent)) {
    New-Item -ItemType Directory -Path $parent -Force | Out-Null
}
$rows | Export-Csv -LiteralPath $OutputPath -NoTypeInformation -Encoding UTF8
Write-Output "Prepared $(@($rows).Count) query/page rows at $OutputPath"
