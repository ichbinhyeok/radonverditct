param(
    [string]$OutputPath = "data/co_radon_measurements.json"
)

$ErrorActionPreference = "Stop"

$downloadUrl = "https://drive.google.com/uc?export=download&id=1ErMJ-eGAPRLyOTbeUCZon-lclxpOaWVF"
$sourceUrl = "https://coepht.colorado.gov/radon-data"
$retrievedAt = "2026-05-05"
$sourceName = "Colorado Environmental Public Health Tracking Pre-Mitigation Radon Test Results"
$period = "2005-2024"
$caveat = "Colorado county summaries are based on pre-mitigation indoor radon tests reported to CDPHE and are not a statistically designed survey of every home."

$python = if ($env:RADONVERDICT_PYTHON) {
    $env:RADONVERDICT_PYTHON
} elseif (Get-Command python -ErrorAction SilentlyContinue) {
    "python"
} elseif (Get-Command py -ErrorAction SilentlyContinue) {
    "py"
} else {
    throw "Python with openpyxl is required to parse the Colorado XLSX source."
}

$workDir = Join-Path $env:TEMP ("rv_co_radon_" + [guid]::NewGuid().ToString("N"))
$xlsxPath = Join-Path $workDir "co_radon.xlsx"
New-Item -ItemType Directory -Path $workDir -Force | Out-Null

try {
    Invoke-WebRequest -Uri $downloadUrl -OutFile $xlsxPath -TimeoutSec 120

    $script = @'
import json
import sys

import openpyxl

xlsx_path, output_path, source_url, source_name, period, retrieved_at, caveat = sys.argv[1:8]
wb = openpyxl.load_workbook(xlsx_path, data_only=True)
ws = wb["CountyResults2005_2024"]

headers = [cell.value for cell in ws[1]]
records = []
for row in ws.iter_rows(min_row=2, values_only=True):
    if not row or row[0] in (None, ""):
        continue
    data = dict(zip(headers, row))
    fips = str(int(data["CountyFIPSCode"])).zfill(5)
    tests = float(data["NTests"]) if data.get("NTests") is not None else None
    tests_over_4 = float(data["NTestsover4"]) if data.get("NTestsover4") is not None else None
    average_tests = round(tests / 20.0, 1) if tests is not None else None
    records.append({
        "county_fips": fips,
        "state_abbr": "CO",
        "county_name": data["CountyName"],
        "source_id": "co_cdphe_radon",
        "source_name": source_name,
        "source_url": source_url,
        "period": period,
        "retrieved_at": retrieved_at,
        "caveat": caveat,
        "metrics": {
            "average_number_of_tests": average_tests,
            "median_radon_value_pci_l": float(data["MedianResult"]) if data.get("MedianResult") is not None else None,
            "maximum_test_result_pci_l": float(data["MaxResult"]) if data.get("MaxResult") is not None else None,
            "percent_tests_at_or_above_4_pci_l": float(data["PctOver4"]) if data.get("PctOver4") is not None else None,
            "number_properties_at_or_above_4_pci_l": tests_over_4
        }
    })

records.sort(key=lambda item: (item["state_abbr"], item["county_name"]))
with open(output_path, "w", encoding="utf-8") as fh:
    json.dump(records, fh, indent=2)
print(f"Wrote {len(records)} CO county radon measurement records for {period} to {output_path}")
'@

    $script | & $python - $xlsxPath $OutputPath $sourceUrl $sourceName $period $retrievedAt $caveat
}
finally {
    if (Test-Path -LiteralPath $workDir) {
        Remove-Item -LiteralPath $workDir -Recurse -Force
    }
}
