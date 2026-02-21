# 09 — Task Breakdown (Execution Order)

This plan is written to be executed top-to-bottom for a **Java / Spring Boot DB-less** environment, integrating the "Super pSEO" and "Itemized Receipt Layer" strategy.

## 0) Project Scaffolding
- [x] Initialize Spring Boot project (Web, Mail, Cache support)
- [x] Add JTE plugin and dependencies
- [x] Configure application.yml (env vars, cache TTLs, log paths)

## 1) Data Layer (Static Files ETL) - [COMPLETED]
- [x] Parse EPA zones to `epa_county_radon_zones.json`.
- [x] Parse Census data to `geo_counties.json`.
- [x] Process HUD crosswalk to `zip_primary_county.json`.
- [x] Create `reference_sources.json`.
- [x] Create `pricing_config.json` with itemized components, foundation modifiers, and regional (State-level) multipliers.

## 2) In-Memory Data Load (Spring Boot `@PostConstruct`)
- [ ] Create DTO classes mapping to the static JSON files.
- [ ] Build `DataLoadService` to parse JSON files into memory (e.g., `Map<String, CountyData>`, `Map<String, Double> regionalMultipliers`) on startup.
- [ ] Implement startup validation (e.g., fail fast if files are missing or malformed).

## 3) Core Estimator Engine
- [ ] Build `PricingCalculatorService`.
- [ ] Implement logic to calculate Itemized Cost: `Materials + Permits + (Labor_Base + Foundation_Modifier) * Regional_Multiplier`.
- [ ] Implement "Contextual Negotiation Advice" generation based on user intent (Buying/Selling/Living).
- [ ] Write JUnit tests verifying pricing bounds ($600-$4500) and regional math variance.

## 4) Routing & SEO/AEO Controllers
- [ ] `/radon-cost-calculator` (Global entry point)
- [ ] `/radon-mitigation-cost/{state}` (State Hub)
- [ ] `/radon-mitigation-cost/{state}/{countySlug}` (Canonical SEO Unit)
- [ ] Inject `PricingCalculatorService` data into models.
- [ ] Verify 404 handling for invalid slugs/FIPS codes.

## 5) Frontend UI (JTE Templates) & Interactive Layer
- [ ] Build the interactive **Multi-dimensional Simulator** (JS/Alpine.js or HTMX depending on stack preference).
- [ ] Build the **"Itemized Receipt Table"** (Static render for AEO/Google Bots).
- [ ] Integrate local context hook and negotiation advice dynamically based on user input.

## 6) Lead Pipeline (Monetization)
- [ ] Build lead form UI triggered heavily by the "Need proof for Negotiation?" CTA.
- [ ] Create `@PostMapping` for lead submission.
- [ ] Implement Dedupe Cache (Caffeine TTL).
- [ ] Append to local `consent_audit.csv` via BufferedWriter (TCPA Compliance).
- [ ] Setup `JavaMailSender` for immediate lead delivery to admins/partners.

## 7) Admin & SEO Plumbing
- [ ] Create `/admin/stats` endpoint reading local logs.
- [ ] Generate dynamic `sitemap.xml` iterating over memory map.
- [ ] Implement `robots.txt` and canonical tags.
- [ ] Inject Schema.org (`FAQPage`, `Dataset`) dynamically via JTE `head` blocks.

## 8) QA & Launch Validation
- [ ] Perform audit against `08_acceptance_criteria.md`.
- [ ] Test Mobile UX for the Receipt/Simulator.
- [ ] Run Lighthouse score (Target: 90+ on Mobile).
