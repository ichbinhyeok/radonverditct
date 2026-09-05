# Internal research ledger — SEO acquisition system

Date: 2026-09-05  
Audience: owner, product, engineering, and future SEO reviewers  
Decision: determine a defensible organic-acquisition portfolio for RadonVerdict and encode it into the product and routing layer.

## Executive finding

The recoverable wedge is not “radon information.” It is task completion around radon-test setup, validity, retesting, and installed mitigation-system ownership. Broad result, detector, cost, and local-service terms have higher authority or evidence barriers. The launch order therefore favors test duration, maintenance, manometer interpretation, fan noise, and fan life, then uses protocol pages as supporting coverage.

YMYL raises the evidence bar, especially for interpreting results and prescribing action, but it does not explain the site failure by itself. The stronger causal evidence is: thousands of highly similar generated URLs, retired/live-surface mismatch, almost no external authority, weak query-to-page fit, and no ongoing publishing or product iteration after the initial build.

## Inputs and method

### First-party observations

- Latest 28-day GSC snapshot (2026-08-07 through 2026-09-03): 0 clicks, 364 impressions, 0% CTR, average position 42.2.
- Latest seven days: 0 clicks, 48 impressions, average position 56.1.
- Coverage: 122 indexed and 7,026 not indexed; 4,100 crawled-not-indexed and 2,643 noindex exclusions were the largest buckets.
- Manual actions: none. Detected security issues: none.
- GSC Links: one external link.
- `/guides/how-to-test-for-radon`: 106 impressions in the latest 28 days at average position 73.4.
- Earlier saved evidence showed 261 clicks and 23,290 impressions in 2026-04-02 through 2026-05-01, but the generated county corpus had 84.54% mean Jaccard similarity. Historical performance establishes prior eligibility, not a forecast.

### Google Ads directional bands

Keyword Planner was inspected in the browser for US English over the prior 12 months. The observations are family-level bands, not exact per-query forecasts:

- 100K–1M: test kit, mitigation system.
- 10K–100K: detector, radon test.
- 1K–10K: monitor, mitigation cost, test duration, levels.
- 100–1K: digital monitor, results, manometer, maintenance, fan life, fan noise.
- Mostly 0–100: detailed placement, handling, condition, and protocol variants.

The high-volume head terms were not automatically prioritized. Opportunity scoring also considered result authority, ability to satisfy the task, internal product fit, claim risk, and whether RadonVerdict has the required original evidence.

### Query universe

The generator defines 20 user-task families with 10 phrasing variants each. Every row has a journey, directional volume band, observed SERP class, YMYL risk, tier, canonical target, and evidence label. Duplicates and counts are enforced by tests. Variants support content coverage and later GSC classification; they do not justify separate pages.

### SERP reverse engineering

Twenty representative searches were inspected live. The sample spans launch candidates, support queries, future candidates, merge decisions, and hard holds. For each query the ledger records result composition, authority barrier, missing utility, RadonVerdict action, and a relative opportunity score. Scores prioritize what this product can credibly do; they are not Google ranking probabilities.

Observed patterns:

- Maintenance and post-mitigation queries include EPA/AARST plus contractor pages. A practical record or checklist can add utility, but must remain source-bounded.
- Manometer, fan-noise, spike, and disagreement queries contain many contractor/forum results. The gap is structured observation and escalation, not remote diagnosis.
- Result meanings and level charts are government-heavy. They require a fully sourced workflow and should share one canonical URL.
- “Best kit” results include publishers claiming hands-on product testing. RadonVerdict cannot credibly compete without actually testing products.
- Cost calculators need a transparent, defensible input model. Retired modeled local estimates must not return unchanged.
- Shipping and kit-expiry answers depend on the lab or manufacturer. Tools must accept user-entered deadlines rather than invent universal ones.

## Product decisions encoded

Three interactive tools were added to the guide template:

1. A result-timeline calculator separates exposure time, return transit, and lab processing.
2. A manometer record compares a current observation with the system's own baseline and explicitly refuses to infer indoor radon.
3. A fan-noise record captures symptom and system indicators, then escalates alarm/electrical concerns without unsafe repair instructions.

The result-meaning page was subsequently rebuilt as a fourth decision tool. It now requires the reading, test type, procedure status, and decision context; calculates the average of two short-term tests; stops classification when procedure evidence is missing or conflicting; and keeps post-mitigation results on a system-verification path. It no longer sends a bare number into a commercial plan.

The homepage and guide hub link the five priority guides. The former fan-noise troubleshooting slug permanently redirects to the canonical fan-noise guide. Tests cover the research artifact counts, route dispositions, template contracts, calculations, safety language, and mobile overflow.

## Migration derivation

The current `geo_counties.json` catalog contains 3,234 county entries. Two former generated families—level and mitigation cost—produce 6,468 county routes. State hubs plus two known replacement redirects bring the deterministic manifest to 6,582 routes. Twelve level pages remain as a controlled evidence cohort; 6,568 routes return 410; two exact replacements return 301.

The difference between 6,582 reconstructable routes and 7,026 GSC exclusions is explicitly unresolved. The current repository alone cannot prove the exact identity of 444 historical URLs. They require an exported GSC URL sample or server-log inventory before disposition.

## Claim-to-source ledger

| Claim supported | Source | Publisher | URL | Accessed | Notes |
|---|---|---|---|---|---
| Consumer radon testing basics and test-duration context | Radon Testing | CDC | https://www.cdc.gov/radon/testing/index.html | 2026-09-05 | Primary public-health source |
| Mitigation system/fan should run continuously; warning device and retesting guidance | How do I know if my radon mitigation system is working properly? | US EPA | https://www.epa.gov/radon/how-do-i-know-if-my-radon-mitigation-system-working-properly | 2026-09-05 | Primary federal guidance |
| Consumer mitigation-system guidance | Consumer's Guide to Radon Reduction | US EPA | https://www.epa.gov/sites/default/files/2016-12/documents/2016_consumers_guide_to_radon_reduction.pdf | 2026-09-05 | Primary PDF; preserve source wording |
| pCi/L and working-level unit meaning | Explain working levels and picocuries | US EPA | https://www.epa.gov/radon/explain-working-levels-wl-and-picocuries-liter-air-pcil | 2026-09-05 | Primary federal source |
| Post-mitigation measurement standard | SGM-SF-2017 Section 12 | AARST | https://standards.aarst.org/SGM-SF-2017-1220/39/ | 2026-09-05 | Standards source; do not paraphrase beyond accessible text |
| Mitigation maintenance standard | MAH-2019 | AARST | https://standards.aarst.org/MAH-2019/13/ | 2026-09-05 | Standards source |
| Kit return-shipping procedure is lab-specific | How should I ship my test kit? | Eurofins | https://faqs.aelabs.com/hc/en-us/articles/1500005726161-How-should-I-ship-my-test-kit | 2026-09-05 | Representative lab instruction, not universal rule |
| Kit shelf life is product/lab-specific | What is the shelf life of my kit? | Eurofins | https://faqs.aelabs.com/hc/en-us/articles/1500005727601-What-is-the-shelf-life-of-my-kit | 2026-09-05 | Representative lab instruction |
| State FAQ example for testing/kit handling | Radon FAQ | Michigan EGLE | https://www.michigan.gov/egle/-/media/Project/Websites/egle/Documents/Programs/MMD/Radon/Radon-FAQ.pdf | 2026-09-05 | State source; jurisdiction-specific |
| Existing result-interpretation tool competitor | Result Interpreter | RadonConnect | https://radonconnect.com/tools/result-interpreter/ | 2026-09-05 | Competitor/product observation |
| Hands-on evidence bar for “best kit” query | Best Radon Test Kits | Bob Vila | https://www.bobvila.com/articles/best-radon-test-kit/ | 2026-09-05 | Competitor observation, not health authority |
| Existing cost-calculator product pattern | Radon Mitigation Cost Calculator | Peerless Environmental | https://peerlessenvironmental.com/resources/calculators/radon-mitigation-cost | 2026-09-05 | Competitor observation |
| Fan-life query competitor pattern | How Long Do Radon Mitigation Systems Last? | Peerless Environmental | https://peerlessenvironmental.com/resources/how-long-do-radon-mitigation-systems-last | 2026-09-05 | Contractor observation; not used as universal fact |

## Limitations and falsification

- The 200-query universe includes generated close variants; only 20 representative SERPs were directly inspected in this pass.
- Keyword Planner provides broad directional bands and can group variants. These are not click estimates.
- Rankings and SERP composition are volatile and localized. Recheck any family before a material publishing investment.
- No external practitioner reviewed the content, so pages avoid claims that require practitioner judgment. This is a product boundary, not a trust-banner confession.
- The acquisition thesis is falsified if the launch cohort is indexable and query-aligned but produces no non-brand impressions or position improvement by the documented gates.
- This work is implemented locally and is not production evidence until deployed, crawled, and observed in GSC.
