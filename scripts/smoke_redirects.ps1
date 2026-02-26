param(
    [string]$BaseUrl = "https://radonverdict.com",
    [int]$MaxRedirs = 10
)

$paths = @(
    "/",
    "/radon-cost-calculator",
    "/robots.txt",
    "/sitemap.xml",
    "/radon-mitigation-cost/california",
    "/radon-mitigation-cost/california/los-angeles-county",
    "/radon-levels/california/los-angeles-county"
)

$failures = @()

Write-Host "Redirect smoke check: $BaseUrl"
Write-Host ""

foreach ($path in $paths) {
    $url = "$BaseUrl$path"
    $result = & curl.exe -s -o NUL -w "%{http_code} %{num_redirects} %{url_effective}" -L --max-redirs $MaxRedirs "$url"
    if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($result)) {
        $failures += "FAILED request: $url"
        Write-Host ("[FAIL] {0}" -f $url)
        continue
    }

    $parts = $result.Split(" ", 3, [System.StringSplitOptions]::RemoveEmptyEntries)
    if ($parts.Length -lt 3) {
        $failures += "FAILED parse: $url => $result"
        Write-Host ("[FAIL] {0} => {1}" -f $url, $result)
        continue
    }

    $statusCode = [int]$parts[0]
    $redirectCount = [int]$parts[1]
    $effectiveUrl = $parts[2]

    $line = "[OK] $path => status=$statusCode redirects=$redirectCount final=$effectiveUrl"
    $isFailure = $false

    if ($redirectCount -ge $MaxRedirs) {
        $isFailure = $true
        $line = "[FAIL] $path => likely redirect loop (redirects=$redirectCount)"
        $failures += $line
    }

    if (-not $effectiveUrl.StartsWith("https://radonverdict.com")) {
        $isFailure = $true
        $line = "[FAIL] $path => unexpected final host/scheme: $effectiveUrl"
        $failures += $line
    }

    if ($statusCode -lt 200 -or $statusCode -ge 400) {
        $isFailure = $true
        $line = "[FAIL] $path => unexpected final status: $statusCode"
        $failures += $line
    }

    Write-Host $line
}

Write-Host ""
if ($failures.Count -gt 0) {
    Write-Host "Smoke check failed:"
    $failures | ForEach-Object { Write-Host " - $_" }
    exit 1
}

Write-Host "Smoke check passed."
exit 0
