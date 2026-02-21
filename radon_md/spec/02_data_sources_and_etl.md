# 02 — Data Sources and ETL

## 1) Datasets

### A) EPA radon zones (county-level)
**Purpose:** risk context display (Zone 1/2/3) and county/state metadata.  
**Canonical unit:** county.

**Primary source (EPA):**
- “EPA Map of Radon Zones” and downloadable county table:
  - https://www.epa.gov/radon/epa-map-radon-zones
  - https://www.epa.gov/radon/epa-map-radon-zones-0

**Fields to extract / normalize**
- `state_name`
- `state_abbr` (2-letter)
- `county_name`
- `county_fips` (string, 5-digit preferred)
- `epa_zone` (1, 2, 3)
- `zone_label` (e.g., “Zone 1 (highest potential)”)
- `source_url`
- `source_retrieved_at`
- `source_version` (optional hash)

**Notes**
- EPA provides planning-level guidance; do not use zone to predict an individual home’s radon level.

---

### B) ZIP → County crosswalk (optional but strongly recommended)
**Purpose:** allow ZIP input UX and route users to a county page.  
**Source recommendation (HUD USPS crosswalk):**
- https://www.huduser.gov/portal/datasets/usps_crosswalk.html

**Typical fields in crosswalk**
- `zip` (or ZCTA)
- `county_fips`
- `residential_ratio` (or similar weight)
- sometimes `business_ratio`, `other_ratio`

**Deterministic mapping rule**
- If a ZIP maps to multiple counties, choose the county with the **highest residential_ratio** as the “primary county”.
- Keep the full mapping table to support edge cases and transparency.

---

### C) Cost reference sources (for base range, citations)
**Purpose:** set the base range and show credibility.

Recommended citations (pick at least 2, keep stable):
- Angi radon mitigation cost guide:
  - https://www.angi.com/articles/how-much-does-it-cost-remove-radon-gas.htm
- HomeAdvisor radon mitigation cost guide:
  - https://www.homeadvisor.com/cost/environmental-safety/remove-radon-gas/
- Thumbtack radon mitigation cost overview (optional backup):
  - https://www.thumbtack.com/p/radon-mitigation-cost

**How to use**
- Store these as “reference sources” (URLs + retrieved date).
- Do not scrape aggressively; respect robots/ToS. Manual updates are acceptable.

---

### D) State radon program / qualified pros links
**Purpose:** “Find a qualified professional” module.

Start from EPA hub:
- https://www.epa.gov/radon/find-radon-test-kit-or-measurement-and-mitigation-professional

From there you can link to state programs; for some states there are explicit requirements (example pages):
- California radon services providers page:
  - https://www.cdph.ca.gov/Programs/CEH/DRSEM/Pages/EMB/Radon/Certified-Radon-Services-Providers.aspx
- Florida radon professional regulation page:
  - https://www.floridahealth.gov/licensing-regulations/regulated-professions/radon-professional/

**Implementation rule**
- Do not claim certification; instead, link users to official “find a pro” resources.

---

## 2) ETL design

### ETL-1: Build counties table (mandatory)
**Input:** EPA county zone dataset  
**Output:** `counties` table with normalized columns + slugs.

Steps:
1) Download EPA dataset (manual or scripted).
2) Normalize:
   - standardize county name (“X County”)
   - state_abbr uppercase
   - epa_zone as int
   - county_fips as 5-digit string
3) Generate slugs:
   - state slug: `oh`
   - county slug: `franklin-county`
4) Validate:
   - unique (state_abbr, county_fips)
   - zone in {1,2,3}
5) Export to DB.

### ETL-2: Build ZIP crosswalk (recommended)
**Input:** HUD crosswalk file(s)  
**Output:** `zip_county_xwalk` (full mapping) + `zip_primary_county` (collapsed mapping).

Steps:
1) Load crosswalk.
2) Normalize ZIP to 5-digit string.
3) Group by ZIP:
   - choose primary county_fips by max residential_ratio
4) Store both tables.

### ETL-3: Reference sources registry (mandatory for citations)
**Output:** `reference_sources` table:
- id, name, url, type (epa/cost/state), retrieved_at, notes

### Update cadence
- EPA zones: rarely change; refresh quarterly or semiannually.
- HUD crosswalk: monthly/quarterly updates may occur; refresh quarterly.
- Cost sources: refresh every 3–6 months.

## 3) Data quality checks (automate)
- Missing county_fips? fail build.
- Duplicate slugs? fail build.
- ZIP mapping coverage (percent of ZIPs mapped) report.
- Random sample check: 50 ZIPs resolve to county page (200 OK).

## 4) Data licensing / compliance notes
- EPA/HUD datasets are public/government sources.
- Cost guide sources: do not copy large portions; cite and paraphrase, and keep quotations minimal.
