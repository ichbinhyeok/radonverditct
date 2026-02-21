$url = 'https://www2.census.gov/geo/docs/reference/codes/files/national_county.txt'
$outFile = 'c:\Development\Owner\radonVerdict\scripts\national_county.txt'
try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $url -OutFile $outFile -UseBasicParsing
    Write-Host "Downloaded OK. Size: $((Get-Item $outFile).Length) bytes"
    Get-Content $outFile -TotalCount 5
}
catch {
    Write-Host "Error: $($_.Exception.Message)"
    # Try alternative URL
    $url2 = 'https://www2.census.gov/geo/docs/reference/codes2020/national_county2020.txt'
    try {
        Invoke-WebRequest -Uri $url2 -OutFile $outFile -UseBasicParsing
        Write-Host "Downloaded (alt) OK. Size: $((Get-Item $outFile).Length) bytes"
        Get-Content $outFile -TotalCount 5
    }
    catch {
        Write-Host "Alt also failed: $($_.Exception.Message)"
    }
}
