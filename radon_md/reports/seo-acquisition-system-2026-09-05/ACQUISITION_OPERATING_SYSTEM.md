# RadonVerdict organic acquisition operating system

Date: 2026-09-05  
Scope: US English organic search. Acquisition first; revenue optimization comes after qualified non-brand traffic exists.

## The direct answer

The site should not return to mass county pages, generic radon articles, or unsupported cost estimates. Its best recoverable search position is a **radon testing and installed-system decision toolkit**: help a homeowner complete one concrete task, record what happened, and know the safe next step without pretending to diagnose radon exposure or equipment remotely.

The first release is not five isolated articles. It is a 40-page decision portfolio backed by a 200-query universe, a 20-query live SERP sample, a deterministic 6,582-route migration manifest, and three interactive task tools. Only five URLs receive primary promotion at launch; 15 supporting pages are already part of the cluster, while weak or evidence-heavy ideas are explicitly merged, gated, or held.

## What is live in the code now

| Launch job | Canonical URL | Product element | Why it leads |
|---|---|---|---|
| Test duration and result timing | `/guides/short-term-vs-long-term-radon-test` | Result-date calculator using the visitor's exposure, transit, and lab times | Largest attainable procedural band; resolves two different meanings of “how long” |
| System maintenance | `/guides/radon-mitigation-system-maintenance` | Source-bounded owner checklist | Commercial-adjacent demand without inventing universal service intervals |
| Manometer reading | `/guides/radon-manometer-reading` | Baseline comparison record | Local contractors/forums dominate; competitors often imply a universal “normal” number |
| Fan noise | `/guides/radon-fan-noise` | Symptom and service-call note | Forum-heavy task where safe observation is more useful than remote diagnosis |
| Fan life | `/guides/how-long-do-radon-fans-last` | Service-life record | Corrects “typical warranty/life” being misread as a hard expiration date |

The guides hub and homepage link to all five launch pages. The older `/guides/radon-fan-noise-troubleshooting` URL permanently redirects to the new canonical page.

## Portfolio rules

The complete page decision table is in `page-portfolio-40.csv`.

- `LIVE_NOW` (5): primary acquisition cohort above.
- `LIVE_SUPPORT` (15): existing protocol pages that complete the test journey and build topical coverage.
- `LIVE_PILLAR` (1): the rebuilt broad testing workflow consolidates the cluster.
- `LIVE_TOOL` (2): the test planner and the rebuilt test-type/procedure-aware result interpreter.
- `KEEP_HUB` (1): retain the controlled county-data hub.
- `BUILD_AFTER_SIGNAL` (5): publish only when adjacent Search Console impressions prove demand.
- `MERGE_QUERY` (7): answer inside an existing canonical page; do not create thin competing URLs.
- `HOLD` (4): best-kit, detector head term, mitigation cost, and local services require evidence or inventory the product does not possess.

## Measurement gates

All reporting excludes branded and `site:` queries. Decisions are made by query family, not by one lucky URL.

1. **Indexing gate — day 14:** launch URLs are submitted, render correctly, have one canonical, and appear in the sitemap. A URL that is not indexed does not graduate to content iteration.
2. **Query-match gate — day 30:** each primary family must earn non-brand impressions for intended or close-variant queries. If it does not, inspect indexing, title/intent alignment, and internal links before adding pages.
3. **Movement gate — day 60:** retain and improve families with impressions plus upward position movement. Merge or stop families that remain invisible after technical checks.
4. **Click gate — day 90:** optimize snippets only where impressions exist. Do not diagnose zero clicks on URLs with no meaningful exposure as a copywriting problem.

The launch cohort is deliberately small enough to measure, while the portfolio is large enough to avoid a five-page ceiling. Supporting pages are promoted only when they strengthen a winning journey; the backlog is not an instruction to publish all 40 at once.

## Legacy URL control

`legacy-url-migration-manifest.csv` provides one disposition for every route reconstructable from the current county catalog:

| Disposition | Count | Meaning |
|---|---:|---|
| `KEEP_200` | 12 | Controlled county evidence cohort |
| `REDIRECT_301` | 2 | A true replacement exists |
| `GONE_410` | 6,568 | Generated level/cost page was retired and has no equivalent replacement |
| **Total** | **6,582** | Deterministic current-catalog route universe |

Search Console reports 7,026 excluded URLs, which is 444 more than the reconstructable manifest. Those 444 are not silently guessed into redirects; they can include older aliases, parameters, and routes absent from the current catalog. Export the exact GSC URL table before mapping that remainder. Redirecting all of them to a hub would be misleading and can create soft-404 behavior.

## What the research does and does not prove

`query-universe-200.csv` is a structured demand map: 20 task families with 10 natural-language variants each. It is **not** a claim that Google Ads measured all 200 phrases individually. Its volume bands are family-level directional bands from Keyword Planner; variants are used for page coverage and Search Console matching.

`serp-sample-20.csv` records the live-result composition, authority barrier, missing utility, recommended action, and opportunity score for 20 representative decisions. This sample is sufficient to choose the first portfolio, but it is not a 200-SERP census or a traffic forecast.

The current 28-day baseline was 0 clicks, 364 impressions, and average position 42.2. Coverage showed 122 indexed and 7,026 not indexed, with no manual action or detected security issue. That means the immediate problem is distribution and intent fit—not conversion optimization, a penalty theory, or “YMYL alone.” Historical rankings show eligibility, not guaranteed recovery.

## Weekly operating loop

Every Monday, export GSC query/page data for 7, 28, and 90 days. Normalize close variants into the 20 families, remove `site:` and branded rows, then update only these fields: indexed state, impressions, clicks, average position, first-seen query, and last meaningful movement. Every four weeks, recheck live SERPs only for families that gained impressions or whose result composition materially changed. New pages require either a portfolio gate or observed query evidence.

## Files

- `query-universe-200.csv` — 200 queries, intent family, risk, tier, target URL, evidence class.
- `serp-sample-20.csv` — representative live-SERP reverse engineering and opportunity score.
- `page-portfolio-40.csv` — the publish/merge/hold decision for 40 opportunities.
- `legacy-url-migration-manifest.csv` — deterministic URL-level status plan.
- `generation-summary.json` — machine-checkable counts.
- `report-source.md` — assumptions, research method, source ledger, and limitations.

## Definition of success

This system succeeds first when non-brand impressions and query match recover across multiple task families. It succeeds commercially only later, when those visitors complete product actions and a separately validated payment event. Publishing more pages is not success by itself.
