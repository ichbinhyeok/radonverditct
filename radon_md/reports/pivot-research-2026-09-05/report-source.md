# Internal research ledger — RadonVerdict pivot

Date: 2026-09-05  
Scope: US English search market; no external expert hiring; no manual outreach; reuse current product/data/code where possible.

## Decision question

Which topic can plausibly revive RadonVerdict through search without repeating mass county publishing or making unsupported medical, legal, or field-engineering claims?

## Repository evidence

- `radon_md/spec/13_nextjs_evidence_based_salvage.md`: 2026-04-02–05-01 GSC 261 clicks / 23,290 impressions / average position 7.42; `/radon-levels` 91 / 6,416; mitigation cost 8 / 3,440; 3,126 generated county pages with 84.54% mean Jaccard similarity.
- `radon_md/ops/context_tracker.md`: same query/page-family evidence.
- Current dataset: 3,036 county records, 49 states, 15 named sources.
- `scripts/generate_county_radon_measurements.ps1`: last record wins by county FIPS, so current table substitutes sources rather than preserving parallel observations.
- Current public CSV omits several source-specific measures present in source files.

## Independent workstreams

### Search reverse engineering

- Broad result interpretation, ZIP lookup, cost calculators, maps, and address-level environmental reports are occupied by government, contractors, or established tools.
- A data API/provenance query family has a visible product gap, but no saved GSC demand and no verified search volume.
- Test setup/validity questions recur across official guidance and user discussions. Broad head terms are government-heavy; the product gap is a guided workflow rather than another article.
- Post-mitigation troubleshooting has a genuine domain-fit signal: stale RadonVerdict fan-noise and electricity pages surfaced for exact sample queries. It is constrained by safety and lack of a credentialed practitioner.

### Data defensibility

- CDC centralizes much county measurement data; EPA centralizes zone data. A prettier copy, ZIP map, or zone CSV is not a moat.
- State sources remain heterogeneous (CSV, XLSX, ArcGIS, Tableau, query builders, single-ZIP reports).
- Defensible data product requires raw snapshots, hashes, source coexistence, schema/vintage diffs, provenance/licensing, and a comparability ontology.
- Commercial reuse rights and buyer demand are not yet validated.

### Product/business

- Highest-fit internal product: test selection → placement → closed-house protocol → validity/retest decision → shareable test record → free/discount kit first, disclosed affiliate option second.
- Paid API is a later validation experiment, not the initial rescue bet.
- Inspector SaaS, contractor marketplace, review media, and broad property-risk packets require outreach, proprietary inputs, hands-on testing, or stronger incumbency.

## Primary sources

- CDC radon testing: https://www.cdc.gov/radon/testing/index.html
- CDC tracking data: https://www.cdc.gov/environmental-health-tracking/php/data-research/radon-testing.html
- EPA radon zones: https://www.epa.gov/radon/epa-map-radon-zones
- EPA free/discount kits: https://www.epa.gov/radon/how-do-i-get-radon-test-kit-are-they-free
- EPA mitigation maintenance: https://www.epa.gov/radon/how-do-i-know-if-my-radon-mitigation-system-working-properly
- Minnesota energy-cost example: https://www.health.state.mn.us/communities/environment/air/docs/radon/energycosts.pdf
- NY export: https://www.health.ny.gov/statistics/environmental/public_health_tracking/about_pages/radon/export
- MN download: https://mndata.web.health.state.mn.us/radon/data_download.html
- NC data: https://www.ncdhhs.gov/divisions/health-service-regulation/north-carolina-radon-program/nc-radon-data
- Utah query builder: https://ibis.utah.gov/epht-view/query/builder/radon/Radon/Average.html?Reload=x
- EPA data license: https://edg.epa.gov/EPA_Data_License.html
- CDC materials policy: https://www.cdc.gov/other/agencymaterials.html

## Competitor and analogue sources

- RadonLevels: https://radonlevels.org/
- RadonCost ZIP lookup and method: https://radoncost.com/radon-by-zip/ ; https://radoncost.com/methodology/
- Ecosense map: https://radonmap.ecosense.io/
- RadonConnect tools: https://radonconnect.com/tools/
- EPA MyEnvironment: https://www.epa.gov/enviro/myenvironment-how-use-page
- GroundReport: https://www.groundreport.app/
- Airthings affiliate program: https://www.airthings.com/professionals/affiliate-program
- Spectora pricing: https://www.spectora.com/pricing/
- AARST inspection checklist: https://standards.aarst.org/MAH-2019/33/
- RadonAway selection guide: https://www.hvacquick.com/catalog_files/RadonAway_Fan_Selection_Guide.pdf

## Important uncertainty

- This is opportunity research, not keyword-volume research. Sample SERPs establish composition and product gaps, not traffic forecasts.
- Historic GSC proves the domain once earned search distribution, not that the same rankings can be recovered.
- Affiliate commission availability and product pricing can change.
- No 50-state 2026 license/freshness audit has been completed.

## 2026-09-05 persona re-review

The deeper business review separates product utility from a payment event.

- The free protocol workflow remains the best acquisition/conversion product, but it is not itself a business model.
- The nearest verifiable payment event is a completed direct-affiliate order for a relatively high-ticket radon monitor. Airthings publicly states a 25% commission, but account approval, PPC permission, attribution window, brand-bid rules, and reversals remain unverified.
- Stored spring evidence shows prior topical eligibility. The 2026-07-29 query-page snapshot contains 58 non-`site:` impressions and zero clicks, so current search recovery is not established.
- Local product events, leads, and quote-ledger rows are QA artifacts and cannot be treated as customer validation.
- A data observatory has better theoretical defensibility than a consumer map, but it is deferred until commercial reuse rights and buyer demand are demonstrated.
- The decision is time-boxed to 90 days, five development days for the first commercial experiment, and at most $100 in paid traffic after written affiliate PPC permission.

Primary deliverable: `BUSINESS_VIABILITY_PERSONA_REVIEW.md`.

Additional source checks:

- Airthings affiliate terms summary: https://www.airthings.com/professionals/affiliate-program
- Airthings radon products: https://www.airthings.com/products?category=radon
- FTC affiliate disclosure guidance: https://www.ftc.gov/business-guidance/resources/ftcs-endorsement-guides-what-people-are-asking
- EPA free/discount kit guidance, updated 2026-08-06: https://www.epa.gov/radon/how-do-i-get-radon-test-kit-are-they-free
- EPA mitigation-system maintenance guidance, updated 2026-06-23: https://www.epa.gov/radon/how-do-i-know-if-my-radon-mitigation-system-working-properly

## 2026-09-05 traffic acquisition deep dive

Live Search Console was rechecked with acquisition as the only decision scope.

- Latest 28 days (2026-08-07–09-03): 0 clicks, 364 impressions, 0% CTR, average position 42.2.
- Latest 7 days: 0 clicks, 48 impressions, average position 56.1.
- Coverage: 122 indexed and 7,026 not indexed; 4,100 crawled-not-indexed and 2,643 noindex exclusions dominate.
- No manual action and no detected security issue.
- Current live sitemap index contains 29 discovered URLs. The new protocol guides and planner exist locally but are not live; their production paths currently return 410 and therefore have no GSC performance evidence.
- GSC Links reports one external link. The historical internal-link graph remains heavily concentrated on the retired cost calculator and broad testing guide.
- The broad testing guide received 106 impressions in the latest 28 days at average position 73.4 and was mapped to relevant procedural queries. This is a competitiveness/intent-focus problem, not a discovery-only problem.
- Ulster County exposure is concentrated in local service queries that the current information page cannot fulfill.
- The Darke County page's apparent average position 4.5 is not a verified target-query win; the only visible query in its filtered table was a `site:` search.

Directional Google Ads bands checked for US English in the previous 12 months:

- test kit and mitigation system: 100K–1M
- detector and test: 10K–100K
- monitor, mitigation cost, test duration, levels chart: 1K–10K
- digital monitor, test results, manometer, maintenance, fan life, fan noise: 100–1K
- detailed placement/protocol variants: mostly 10–100 or exact-zero bands

The acquisition portfolio therefore starts with test duration plus installed-system maintenance/manometer/noise/fan-life queries, uses detailed test-protocol pages as support, and defers government-heavy head terms. Operational targets are query-family based and exclude `site:` and branded demand.

Primary deliverable: `TRAFFIC_ACQUISITION_DEEP_DIVE.md`.
