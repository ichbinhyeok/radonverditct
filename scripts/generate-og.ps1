Add-Type -AssemblyName System.Drawing

Function Generate-Mockup {
    param($OutFile, $ThemeStr)
    $W = 1200
    $H = 630
    $bmp = New-Object System.Drawing.Bitmap($W, $H)
    $gfx = [System.Drawing.Graphics]::FromImage($bmp)
    $gfx.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $gfx.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $gfx.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit

    $slate50 = [System.Drawing.ColorTranslator]::FromHtml("#f8fafc")
    $slate800 = [System.Drawing.ColorTranslator]::FromHtml("#1e293b")
    $slate900 = [System.Drawing.ColorTranslator]::FromHtml("#0f172a")
    $slate400 = [System.Drawing.ColorTranslator]::FromHtml("#94a3b8")
    $indigo600 = [System.Drawing.ColorTranslator]::FromHtml("#4f46e5")

    $fontFamily = New-Object System.Drawing.FontFamily("Segoe UI")
    $fontBrand = New-Object System.Drawing.Font($fontFamily, 80, [System.Drawing.FontStyle]::Bold)
    $fontTitle = New-Object System.Drawing.Font($fontFamily, 46, [System.Drawing.FontStyle]::Bold)
    $fontSubtitle = New-Object System.Drawing.Font($fontFamily, 28, [System.Drawing.FontStyle]::Regular)

    $sf = New-Object System.Drawing.StringFormat
    $sf.Alignment = [System.Drawing.StringAlignment]::Center

    if ($ThemeStr -eq "Dark") {
        $cBg1 = $slate900
        $cBg2 = $slate800
        $cBrand = [System.Drawing.Color]::White
        $cTitle = [System.Drawing.Color]::White
        $cSub = $slate400
        $cLine = $indigo600
    } elseif ($ThemeStr -eq "Light") {
        $cBg1 = $slate50
        $cBg2 = [System.Drawing.ColorTranslator]::FromHtml("#e2e8f0")
        $cBrand = $slate900
        $cTitle = $slate900
        $cSub = $slate800
        $cLine = $indigo600
    } else {
        $cBg1 = [System.Drawing.ColorTranslator]::FromHtml("#312e81") # Indigo 900
        $cBg2 = $indigo600
        $cBrand = [System.Drawing.Color]::White
        $cTitle = [System.Drawing.Color]::White
        $cSub = [System.Drawing.ColorTranslator]::FromHtml("#c7d2fe") # Indigo 200
        $cLine = [System.Drawing.Color]::White
    }

    $rect = New-Object System.Drawing.Rectangle(0, 0, $W, $H)
    $brushBg = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect, $cBg1, $cBg2, [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal)
    $gfx.FillRectangle($brushBg, $rect)

    # Text content
    $txtBrand = "RadonVerdict"
    $txtTitle = "Local Radon Risk + Mitigation`nCost Estimates"
    $txtSub = "EPA Zone • County Pricing • Action Plan"

    $brushBrand = New-Object System.Drawing.SolidBrush($cBrand)
    $brushTitle = New-Object System.Drawing.SolidBrush($cTitle)
    $brushSub = New-Object System.Drawing.SolidBrush($cSub)

    # Measurement & layout (y coordinates)
    $gfx.DrawString($txtBrand, $fontBrand, $brushBrand, ($W/2), 90, $sf)
    $gfx.DrawString($txtTitle, $fontTitle, $brushTitle, ($W/2), 260, $sf)
    $gfx.DrawString($txtSub, $fontSubtitle, $brushSub, ($W/2), 480, $sf)

    # Draw an accent line
    $penLine = New-Object System.Drawing.Pen($cLine, 8)
    $gfx.DrawLine($penLine, ($W/2 - 120), 440, ($W/2 + 120), 440)

    $bmp.Save($OutFile, [System.Drawing.Imaging.ImageFormat]::Png)

    $gfx.Dispose()
    $bmp.Dispose()
    $fontBrand.Dispose()
    $fontTitle.Dispose()
    $fontSubtitle.Dispose()
    $brushBg.Dispose()
    $brushBrand.Dispose()
    $brushTitle.Dispose()
    $brushSub.Dispose()
    $penLine.Dispose()
}

$targetDir = "c:\Users\Administrator\radonverditct\src\main\resources\static\images"
if (-Not (Test-Path $targetDir)) {
    New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
}

$mockup1 = Join-Path $targetDir "mockup1-dark.png"
$mockup2 = Join-Path $targetDir "mockup2-light.png"
$mockup3 = Join-Path $targetDir "mockup3-indigo.png"
$final = Join-Path $targetDir "default-og.png"

Generate-Mockup -OutFile $mockup1 -ThemeStr "Dark"
Generate-Mockup -OutFile $mockup2 -ThemeStr "Light"
Generate-Mockup -OutFile $mockup3 -ThemeStr "Indigo"

# We choose the Dark theme as the most polished and modern for a SaaS application.
Copy-Item -Path $mockup1 -Destination $final -Force

$fileSize = (Get-Item $final).Length / 1KB
Write-Host ("Final Image File Size: {0:N2} KB" -f $fileSize)
Write-Host "Successfully replaced default-og.png"
