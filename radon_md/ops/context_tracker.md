# RadonVerdict Context Tracker

Last updated: 2026-04-13 (Asia/Seoul)

## 1) Current Snapshot

Date range note:
- Latest confirmed Search Console data available through 2026-04-12.
- Current comparison window: 2026-03-16 to 2026-04-12.
- Prior comparison baseline: 2026-02-17 to 2026-03-15.

GSC (Google Search Console):
- Total clicks: 308
- Total impressions: 24,607
- CTR: 1.25%
- Average position: 7.54

Change vs prior 28-day window:
- Clicks: `176 -> 308` (`+132`, `+75.0%`)
- Impressions: `15,882 -> 24,607` (`+8,725`, `+54.9%`)
- CTR: `1.11% -> 1.25%` (`+0.14pp`, `+12.9%`)
- Average position: `11.02 -> 7.54`

Current interpretation:
- visibility is meaningfully better than the March baseline
- rankings improved enough that snippet CTR now matters more than raw indexing/debug work
- CTR is improving overall, but several county `radon-levels` pages still underperform relative to their page-1 / near-page-1 positions

Analytics note:
- GA4 was not fully re-pulled during this 2026-04-13 CTR pass.
- For conversion-path readouts, use the detailed 2026-04-07 and 2026-04-08 sections below.

## 2) What We Identified Today

1. `radon-levels` is the current organic winner.
- 91 clicks / 6,416 impressions / CTR 1.42% / average position 11.15

2. `radon-mitigation-cost` has visibility but weak click capture.
- 8 clicks / 3,440 impressions / CTR 0.23% / average position 13.32

3. Several county pages have high impressions, good positions, and zero clicks.
- `/radon-levels/california/san-francisco-county`: 161 impressions / average position 6.34 / 0 clicks
- `/radon-levels/idaho/fremont-county`: 104 impressions / average position 2.94 / 0 clicks
- `/radon-levels/new-york/albany-county`: 101 impressions / average position 4.72 / 0 clicks

4. Cost pages are still sharing some levels/testing intent.
- Query: `radon levels in basement falls church va`
- `radon-levels/.../falls-church-city`: 16 impressions / average position 3.69 / 0 clicks
- `radon-mitigation-cost/.../falls-church-city`: 13 impressions / average position 12.31 / 0 clicks

5. HTTP residue still exists in GSC, but it was intentionally excluded from the 2026-03-08 implementation pass.
- Operational rule for now: monitor only unless live redirect/canonical behavior regresses.

## 3) What We Changed Today (2026-03-08)

### A. `radon-levels` SERP CTR Tightening

Goal:
- Make state/county pages read more like direct answers for map + levels + testing intent.

Changes:
- Updated:
  - `src/main/jte/radon_levels_state.jte`
  - `src/main/jte/radon_levels_county.jte`

Behavior change:
- State pages now emphasize `Radon Map, Levels & Testing Guide`.
- County pages now mention basement / lowest-level test intent more directly in title, description, and hero copy.

### B. `radon-mitigation-cost` Intent Separation

Goal:
- Make cost pages look like cost/quote pages, not testing-guide pages.

Changes:
- Updated:
  - `src/main/jte/county_hub.jte`
  - `src/main/jte/components/radon_level_advisor.jte`
  - `src/main/java/com/radonverdict/service/ContentGenerationService.java`
  - `src/main/resources/data/content_templates.json`

Behavior change:
- County cost title now follows:
  - `How Much Does Radon Mitigation Cost in {County, ST}? | {Year} Price Range`
- Advisor on cost pages now switches to confirmed-reading / budgeting mode.
- Test kit / monitor CTAs were removed from the cost-page advisor.
- Zone hero summary copy now supports pricing / budgeting context after a confirmed test result.

### C. State Cost Hub Naming Cleanup

Goal:
- Improve state-level cost SERP match where abbreviation-only titles were weak.

Changes:
- Updated:
  - `src/main/jte/state_hub.jte`

Behavior change:
- `CA Radon Mitigation Costs` style was replaced with full-state naming such as:
  - `California Radon Mitigation Cost by County`

## 4) Verification (Today)

Executed:
- `.\gradlew.bat test --tests com.radonverdict.SeoBehaviorIntegrationTest --tests com.radonverdict.PersuasionQualityAuditTest`

Result:
- BUILD SUCCESSFUL

## 5) Interpretation (Current)

Current verdict:
- The 2026-03-05 direction was correct; the later confirmed data is stronger, not weaker.
- This is not mainly a broad content-volume problem right now.
- The near-term issue is snippet clarity on `radon-levels` plus intent separation on `radon-mitigation-cost`.
- Current priority remains incremental compounding, not structural rebuild.

## 6) Next Checkpoints

At next GSC check after Google has had time to recrawl snippets:
- Compare CTR change for:
  - `san-francisco-county`
  - `fremont-county`
  - `albany-county`
  - `falls-church-city`
- Watch whether cost pages lose some levels/testing impression share and gain a cleaner cost-intent query mix.
- Do not reopen HTTP/canonical work unless residue grows or live redirects break.

At D+14 from this pass:
- Identify 3 to 5 additional high-impression / low-CTR `radon-levels` pages.
- Confirm whether cost-page CTR improves after intent separation.
- Refresh GA4 and lead-event quality snapshot if traffic continues rising.

## 7) Monetization Direction (Operational Load First)

Preference captured:
- Keep operations light (platform-like flow preferred over heavy direct sales).

Practical approach:
- Near term: platform / automated affiliate-heavy model.
- Later: selective local B2B partners only after traffic + lead quality stabilize.

---

## 2026-03-17 Tracking Checkpoint

Date range note:
- Search Console check window used today: 2026-03-07 to 2026-03-14.
- GA4 check window used today: 2026-03-10 to 2026-03-16.

### 1) What We Saw

Search Console:
- Total clicks: 64
- Total impressions: 5,724
- CTR: 1.12%
- Average position: 9.90

GA4 (property: 525547689):
- Active users: 133
- Sessions: 144
- Engaged sessions: 95
- Screen/page views: 294
- Bounce rate: 34.0%
- Average session duration: about 90.4s

Channel split in GA4:
- Organic Search: 79 sessions / 69 active users / 60 engaged sessions
- Direct: 58 sessions / 58 active users / 33 engaged sessions
- Unassigned: 15 sessions / 14 active users / 2 engaged sessions

Observed event picture:
- Confirmed in GA4 during the check window:
  - `estimator_start`: 2
  - `estimator_step_complete`: 2
  - `estimator_result_viewed`: 2
  - `affiliate_link_click`: 4
- Lead custom events still looked under-reported in GA4 during the same window.
- GA4 automatic form events were still appearing (`form_start`: 3, `form_submit`: 1), which suggested the custom conversion events needed a more reliable submit flow.

Interpretation:
- Search visibility is still moving in the right direction.
- GA4 is live and usable for traffic reading.
- The main operational issue today was tracking quality, not traffic collapse.

### 2) What We Changed Today

Goal:
- Reduce tracking ambiguity before the next lead-quality review.

Changes:
- Updated:
  - `src/main/jte/layout/main.jte`
  - `src/main/jte/components/lead_form.jte`
  - `src/main/jte/radon_levels_county.jte`

Behavior change:
- Disabled GA4 automatic page-view sending in `gtag('config', ...)` and kept `page_view` under the custom `rvTrack` layer only.
- Added richer `page_view` payload context:
  - `page_path`
  - `page_type`
  - `state`
  - `county`
- Changed lead form submit handling so conversion events fire before navigation:
  - `lead_form_submit`
  - `qualify_lead`
- Used beacon-style delivery plus a guarded delayed submit fallback so the form still completes even if the callback does not fire.

Why this matters:
- `page_view` is a KPI denominator in the tracking spec; it should not be inflated by mixed auto + custom counting.
- Lead conversion events were implemented in code already, but needed a safer pre-redirect submission pattern to improve capture reliability.

CTR follow-up added the same day:
- Chose to avoid a broad internal-link rewrite for now.
- Instead, narrowed the content pass to 3 county `radon-levels` pages that already showed impressions and page-1 / near-page-1 visibility:
  - `schenectady-county`
  - `clark-county`
  - `franklin-county`
- Added a second same-day micro-batch of 3 county `radon-levels` pages for the same SERP-facing CTR test pattern:
  - `falls-church-city`
  - `howard-county`
  - `miami-dade-county`
- Tightened only the highest-leverage SERP-facing elements for those county pages:
  - title
  - meta description
  - hero headline
  - hero opening answer label

CTR-specific intent:
- Push these pages toward a clearer "EPA zone + basement testing + what 4.0+ means" answer framing.
- Keep the pass small enough that future CTR movement can be attributed to this change rather than a broad site rewrite.

Mobile CTA follow-up added the same day after iPhone SE review:
- Reviewed these templates/pages in Playwright at `375x667`:
  - county `radon-levels`
  - state `radon-levels`
  - county `radon-mitigation-cost`
  - state `radon-mitigation-cost`
  - `/radon-cost-calculator`
  - `/guides/how-to-test-for-radon`
- Main finding:
  - mobile bottleneck was not visual breakage
  - mobile bottleneck was CTA timing on `radon-levels` and directory-style state hubs
- Observed live-state CTA depth before local patch:
  - county `radon-levels` first strong cost CTA was roughly `9.6` viewports down
  - state `radon-levels` first cost CTA was roughly `8.3` viewports down
  - county `radon-mitigation-cost` first strong CTA was roughly `4.4` viewports down
  - `/radon-cost-calculator` first CTA was roughly `0.7` viewports down
- Applied structural mobile-first CTA changes to common templates:
  - `src/main/jte/radon_levels_county.jte`
  - `src/main/jte/radon_levels_state.jte`
  - `src/main/jte/state_hub.jte`
- What changed:
  - county `radon-levels`
    - added an above-the-fold "Already Have a Reading?" card linked to county cost
    - added an early "Need to Test Before You Price?" card linked to the testing guide and short-term kit
  - state `radon-levels`
    - moved decision paths ahead of the county directory
    - added early actions for county browsing, testing guide, and state cost hub
  - state `radon-mitigation-cost`
    - added early actions for ZIP calculator, radon-level validation, and jump-to-county directory
- Why this matters:
  - CTR work and CTA work are separate layers, so both can move in the same cycle without muddying interpretation.
  - These changes target the "inside-page choice" problem, not the SERP problem.

Mobile usability pass added the same day after local iPhone SE review:
- Ran a local `http://localhost:8080` pass at `375x667` with focus on:
  - homepage search + state grid
  - county cost result page
  - header and breadcrumb tap targets
  - sticky mobile action bar
- Confirmed and addressed these issues:
  - sticky footer CTA was visually too heavy on county cost pages
  - mobile header had no direct navigation path beyond the logo
  - breadcrumb tap targets were too small for thumb use
  - some mobile H1s were larger than necessary on compact screens
  - state directory tiles on the calculator page needed a little more breathing room
  - FAQ accordion was emitting Alpine `x-collapse` warnings
- Applied fixes to:
  - `src/main/jte/layout/main.jte`
  - `src/main/jte/fragments/receipt.jte`
  - `src/main/jte/components/faq_accordion.jte`
  - `src/main/jte/calculator.jte`
  - `src/main/jte/components/hero_section.jte`
  - `src/main/jte/county_hub.jte`
  - `src/main/jte/radon_levels_state.jte`
  - `src/main/jte/state_hub.jte`
  - `src/main/resources/static/css/style.css`
- What changed:
  - added a mobile hamburger menu with direct links to calculator, guides, about, and contact
  - expanded touch targets for header links, footer links, FAQ toggles, and breadcrumb links
  - softened the mobile sticky CTA presentation and added extra page bottom space on county cost pages
  - reduced mobile H1 size on compact pages where the title density was too high
  - widened mobile spacing around the homepage state grid tiles
  - replaced `x-collapse` usage with plain Alpine transitions to remove warnings
- Current interpretation:
  - the biggest remaining mobile questions are now behavioral, not structural
  - next review should check whether the easier navigation and calmer CTA bar improve real clicks, not just visual cleanliness

### 3) Verification

Executed:
- `.\gradlew.bat test --tests com.radonverdict.SeoBehaviorIntegrationTest --tests com.radonverdict.DemoApplicationTests`

Result:
- BUILD SUCCESSFUL

### 4) Next Check

At next GA4 review:
- Check whether `lead_form_submit` starts appearing consistently again.
- Check whether `qualify_lead` starts appearing consistently again.
- Check whether successful submissions produce `close_convert_lead`.
- Confirm that `page_view` volume settles closer to session reality after removing the mixed auto/custom page-view setup.

At next GSC review:
- Compare CTR movement for:
  - `https://radonverdict.com/radon-levels/new-york/schenectady-county`
  - `https://radonverdict.com/radon-levels/nevada/clark-county`
  - `https://radonverdict.com/radon-levels/massachusetts/franklin-county`
- Also compare CTR movement for:
  - `https://radonverdict.com/radon-levels/virginia/falls-church-city`
  - `https://radonverdict.com/radon-levels/maryland/howard-county`
  - `https://radonverdict.com/radon-levels/florida/miami-dade-county`
- If one or more of the 3 pages improves meaningfully, repeat the same narrow CTR pass on the next 3 county pages with similar impression / position profiles.

At next CTA / UX review:
- Check whether `levels_quick_short_term_kit` appears in GA4 affiliate click data.
- Compare `affiliate_link_click` label mix before and after the early CTA insertions on county `radon-levels`.
- Check whether county `radon-levels` sends more traffic into county `radon-mitigation-cost`.
- Check whether state hubs reduce directory-only dead scrolling by increasing clicks into:
  - `/radon-mitigation-cost/{state}`
  - `/radon-levels/{state}`
  - `/radon-cost-calculator`

Decision note:
- No broad product or SEO rebuild was justified today.
- Tracking quality was the correct maintenance target for this checkpoint.

---

## 2026-03-18 P0 Snippet / Template Risk Pass

Date note:
- This pass was executed as a narrow P0 cleanup after the 2026-03-17 checkpoint.
- Goal was not a broad architecture rewrite.
- Goal was to reduce snippet pollution, lower template sameness in the first visible copy, and remove the fixed `basement + buying` SSR posture on county cost pages.

### 1) Why This Pass Was Justified

Current operating context:
- `radon-levels` remains the organic leader, so snippet clarity still matters disproportionately.
- `radon-mitigation-cost` still needs cleaner cost-intent capture rather than more page volume.
- Several risk items were now visible at the shared-template layer, which made them good candidates for a controlled template pass rather than a site rebuild.

Decision rule:
- This work fit the tracker playbook because it was:
  - a common-template cleanup
  - directly tied to CTR / snippet quality
  - measurable without changing the whole information architecture

### 2) What Changed Today

P0-1: Removed empty interactive SSR states from indexed advisor markup.
- Updated:
  - `src/main/jte/components/radon_level_advisor.jte`
- Behavior change:
  - the advisor now ships SSR fallback numbers for the displayed pCi/L reading, the danger-state "At X pCi/L" line, the before/after reduction preview, and input defaults
  - the small manual-entry row is now marked with `data-nosnippet`
- Why this matters:
  - avoids SERP snippets picking up blank-state fragments such as `At pCi/L`
  - keeps the interactive widget useful after hydration without exposing empty variables to indexing

P0-2: Reduced crawl visibility of lead / CTA / negotiation copy on county cost pages.
- Updated:
  - `src/main/jte/components/lead_form.jte`
  - `src/main/jte/components/negotiation_box.jte`
  - `src/main/jte/fragments/receipt.jte`
- Behavior change:
  - lead form container now uses `data-nosnippet`
  - negotiation / closing-credit strategy box now uses `data-nosnippet`
  - mobile sticky CTA now uses `data-nosnippet`
- Why this matters:
  - keeps county cost snippets biased toward price answers instead of `Start Free Plan`, `No obligation`, or seller-credit copy

P0-3: Increased county-level differentiation in top-of-page cost copy.
- Updated:
  - `src/main/java/com/radonverdict/service/ContentGenerationService.java`
  - `src/main/java/com/radonverdict/model/dto/CountyPageContent.java`
  - `src/main/jte/components/hero_section.jte`
  - `src/main/jte/county_hub.jte`
- Behavior change:
  - county cost pages now generate a county-specific pricing rationale for the hero opening paragraph
  - county cost meta descriptions now use county-specific average/range plus a differentiating rationale
  - a county-specific pricing FAQ is injected ahead of the template pools so FAQ order starts with local price reasoning rather than generic buyer/seller copy
- Why this matters:
  - pushes differentiation into the first 200 characters, meta description, and FAQ surface instead of leaving it buried in lower-page local insight sections

P0-4: Removed the fixed `basement + buying + under_2000` SSR default from county cost pages.
- Updated:
  - `src/main/java/com/radonverdict/service/ContentGenerationService.java`
  - `src/main/java/com/radonverdict/controller/PageController.java`
  - `src/main/jte/components/simulator_form.jte`
- Behavior change:
  - county cost pages now choose a default scenario by county characteristics instead of hardcoding one foundation / intent combination everywhere
  - the simulator form now initializes from the county page's selected scenario rather than from global literals
- Why this matters:
  - reduces the "same user, same house, same page" feel across county pages
  - keeps the initial SSR state closer to regional housing patterns and less obviously templated

### 3) Verification

Executed:
- `.\gradlew.bat test --tests com.radonverdict.SeoBehaviorIntegrationTest --tests com.radonverdict.PersuasionQualityAuditTest`

Result:
- BUILD SUCCESSFUL

### 4) What To Watch Next

At the next GSC review after recrawl:
- Check whether county `radon-levels` snippets stop surfacing blank interactive phrasing.
- Check whether county `radon-mitigation-cost` snippets shift back toward price/range language instead of lead/credit copy.
- Compare whether cost-page CTR improves without increasing testing-intent bleed.

At the next HTML / snippet spot check:
- Confirm that shared advisor markup renders fallback values before hydration.
- Confirm that `data-nosnippet` sections are the ones most likely to have polluted snippets previously.

### 5) Deferred Structural Work And Triggers

These items were intentionally deferred today because they are architecture changes, not narrow template fixes.

Item 5: Move the evergreen `reading -> next action` cluster out of county pages into standalone guides.
- Trigger:
  - open this when P0 has had at least one recrawl window
  - and county `radon-levels` pages still capture `2.0`, `4.0`, `8.0`, `retest`, or `what should I do next` intent in a way that feels overloaded
- Scope when opened:
  - publish standalone action guides
  - add stronger internal links from county pages into those guides

Item 6: Split state regulation content into state-law hubs.
- Trigger:
  - open this when county cost pages still surface disclosure / licensing language in snippets or FAQ prominence after the P0 cleanup
- Scope when opened:
  - create state-law hub(s) for disclosure, licensing/certification, and real-estate rule summaries
  - downgrade county-level legal copy to short summaries + links

Item 9: Implement a dedicated `Radon Inspection Closing Credit Calculator` landing page.
- Trigger:
  - open this after the cost-page snippet cleanup is stable
  - and buyer/seller / closing-credit intent is still split awkwardly between county pages and the existing real-estate guide
- Scope when opened:
  - build a dedicated non-geo transactional page
  - use it to absorb buyer-credit CTA load currently living on county pages

Item 10: Expand state radon pages from directory-style pages into summary hubs.
- Trigger:
  - open this only after guide/state/county role separation is clearer from items 5 and 6
  - or if state pages continue to look like shallow directories in behavior review
- Scope when opened:
  - add state testing guidance
  - add regulation snapshot
  - add high-risk county cluster summaries
  - add stronger guide routing from the middle layer

Decision note:
- P0 was worth doing immediately because it was high-leverage template work.
- Items 5 / 6 / 9 / 10 should be opened only after a fresh recrawl / review loop, not in the same cycle.

---

## 2026-04-01 Search Console + Snippet Reality Check

Date note:
- This pass focused on two questions:
  - whether the structured-data error is still live
  - whether the recent CTR snippet edits were already recrawled by Google

### 1) What We Verified

Structured data:
- Live validator result on:
  - `https://radonverdict.com/radon-levels/new-york/schenectady-county`
  - `https://radonverdict.com/radon-mitigation-cost/virginia/fairfax-city`
- Result:
  - both pages validated successfully in the live schema check
  - current live JSON-LD is valid

Search Console inspection:
- Google inspection still reported:
  - `Bad escape sequence in string`
  - rich-result `FAIL` on several county `radon-levels` pages
- Interpretation:
  - this currently looks like stale Google crawl state, not a confirmed live rendering bug

CTR-target recrawl status:
- Priority county `radon-levels` pages checked:
  - `schenectady-county`
  - `franklin-county`
  - `falls-church-city`
  - `howard-county`
  - `miami-dade-county`
- Search Console inspection showed last crawl dates between:
  - `2026-02-28`
  - `2026-03-04`
- Interpretation:
  - the 2026-03-17 / 2026-03-18 snippet changes were not yet reflected in Google's latest inspected crawl for these pages
  - current zero-click behavior should not yet be treated as proof that the recent snippet pass failed

Special case:
- `clark-county` was not a valid CTR read because Google currently showed:
  - `Excluded by 'noindex' tag`
- Operational meaning:
  - remove `clark-county` from the live CTR follow-up set until indexing policy changes

### 2) What We Changed Today

Goal:
- make the next recrawl more likely to produce a cleaner, more clickable snippet
- remove awkward location labeling that could suppress click confidence

Changes:
- Updated:
  - `src/main/java/com/radonverdict/model/County.java`
  - `src/main/jte/radon_levels_county.jte`
  - `src/main/jte/county_hub.jte`
  - `src/test/java/com/radonverdict/SeoBehaviorIntegrationTest.java`

Behavior change:
- Added `seoDisplayName` handling so independent city pages do not surface as fake counties in SEO surfaces.
- `falls-church-city` style pages now render SEO labels like:
  - `Falls Church, VA`
  - not `Falls Church County, VA`
- Tightened priority county `radon-levels` title and meta wording toward:
  - EPA zone
  - basement test meaning
  - `2.0 vs 4.0+ pCi/L`
  - retest / compare mitigation quote decision framing
- Removed `clark-county` from the hardcoded priority CTR county set because it is currently blocked by noindex state and was polluting interpretation.

### 3) Verification

Executed:
- `.\gradlew.bat test --tests com.radonverdict.SeoBehaviorIntegrationTest`

Result:
- BUILD SUCCESSFUL

### 4) Current Interpretation

Current verdict:
- Structured-data cleanup is not the highest immediate live-risk item now.
- The bigger reality is recrawl lag.
- For the current priority county pages, the recent snippet edits have not yet earned a fair read from Google.
- We should avoid overreacting to zero-click pages until Google recrawls the March snippet changes.

### 5) Next Check

At the next GSC review:
- Re-check inspection crawl dates for:
  - `schenectady-county`
  - `franklin-county`
  - `falls-church-city`
  - `howard-county`
  - `miami-dade-county`
- Only judge the March snippet pass after those pages show post-2026-03-17 crawl dates.

If rich-result errors remain after fresh recrawl:
- reopen structured-data debugging immediately
- treat the issue as live rather than stale

If post-recrawl CTR is still weak:
- move from generic `map + guide` framing toward tighter query-match framing by county cluster
- especially for pages where the real query mix is `basement radon testing`, `EPA zone`, or `4.0+ meaning`

## 2026-04-01 Cost Flow Repositioning: `Action Plan` First

### What changed

Shifted the cost flow away from a pure `price calculator` posture and toward a `decision + cost` posture.

Files changed:
- `src/main/java/com/radonverdict/model/dto/CountyPageContent.java`
- `src/main/java/com/radonverdict/service/ContentGenerationService.java`
- `src/main/java/com/radonverdict/controller/PageController.java`
- `src/main/jte/components/simulator_form.jte`
- `src/main/jte/components/hero_section.jte`
- `src/main/jte/fragments/receipt.jte`
- `src/main/jte/components/lead_form.jte`
- `src/test/java/com/radonverdict/SeoBehaviorIntegrationTest.java`

Behavior changes:
- Added `radonResultBand` as a first-class calculator input:
  - `not_tested`
  - `under_2`
  - `between_2_and_4`
  - `above_4`
- Reframed the county cost hero from `How much does it cost?` to `What should you do with this result?`
- Made the calculator form read like an `Action Plan` builder instead of a generic estimate refiner.
- Adjusted the decision copy, next-step box, and lead form messaging to respond to the selected result band.
- Enabled deep-link scenario paths from `radon-levels` pages into prefilled cost/action-plan pages for:
  - borderline `2.0-3.9`
  - confirmed `4.0+`
  - buyer/seller negotiation use cases
- Shifted the global calculator landing from pure `cost calculator` language to `action plan + cost` language.

### Why

Observed product mismatch:
- `radon-levels` pages are already proving that users respond to decision-oriented testing intent.
- The cost flow previously asked for foundation and intent, but not the most important variable: the user's actual result state.
- The page promise was split across `calculator`, `estimate`, and `action plan` language, which likely diluted intent and reduced conversion clarity.

New product hypothesis:
- The user wants `what should I do now?` first.
- Cost is the supporting proof, not the top-level promise.

### Verification

Executed:
- `.\gradlew.bat test --tests com.radonverdict.SeoBehaviorIntegrationTest`

Result:
- BUILD SUCCESSFUL

### Next check

At the next review, inspect whether these changes improve:
- `estimator_start / page_view`
- `estimator_result_viewed / estimator_start`
- `lead_form_start / estimator_result_viewed`

If not:
- the next likely step is not more calculator complexity
- it is a sharper split between:
  - `not tested yet`
  - `confirmed 4.0+`
  - `buyer / seller negotiation`

## 2026-04-01 GA4 Connection + Scenario Prefill Gate

### What we verified

GA4 status:
- The project already had GA4 instrumentation live via `G-7C2TPP3S8N`.
- Service-account access to the GA4 property is working.
- Verified property:
  - `properties/525547689`
  - display name: `radon`
- Local MCP account config was updated to include the GA4 property.
- `get_started` now reports both:
  - `google`
  - `ga4`

Current caveat:
- The currently running MCP tool session still returns `No GA4 accounts found` for GA4 read tools.
- This looks like a connector reload/cache issue, not an auth failure.
- Direct GA4 API reads work, so the tracking layer is live even though the current tool session has not fully reloaded the new GA4 account.

### What the GA4 data says

Recent 28-day read from GA4:
- Top event counts included:
  - `page_view: 271`
  - `internal_link_click: 12`
  - `click: 9`
  - `estimator_result_viewed: 8`
- Top landing page by sessions in the action flow:
  - `/radon-cost-calculator`: `59 sessions`, `30 engagedSessions`
- Estimator result events were concentrated on county cost pages, not the global calculator landing.
- Only one `lead_form_start` showed up in the inspected event sample.

Interpretation:
- Tracking is not dead.
- The problem is not `can we measure it?`
- The problem is `can we move people from entry page -> scenario -> estimate -> lead?`
- The global calculator landing had become too much of a directory/search page and not enough of a decision gate.

### What we changed

Files changed:
- `src/main/java/com/radonverdict/controller/PageController.java`
- `src/main/jte/calculator.jte`
- `src/main/jte/pages/guide_seller_credit_worksheet.jte`
- `src/test/java/com/radonverdict/SeoBehaviorIntegrationTest.java`

Behavior changes:
- `POST /search-zip` now accepts optional:
  - `intent`
  - `radonResultBand`
- The global calculator landing now has an `Optional Scenario Prefill` module before ZIP submit.
- Users can choose:
  - result band: `not tested`, `2.0-3.9`, `4.0+`
  - goal: `living here`, `buying`, `selling`
- ZIP submit now carries those selections into the county action-plan URL so the destination page opens prefilled for that scenario.
- The new `Radon Seller Credit Worksheet` guide was cleaned up and kept as the real-estate conversion assist page.

### Why

Product reason:
- We now have evidence that `/radon-cost-calculator` gets attention.
- But the meaningful downstream events are happening deeper in the county pages.
- So the global landing should not act like a passive directory.
- It should act like an intake gate that pushes the user into the right county scenario immediately.

Monetization reason:
- This increases the odds that a visitor reaches a page with:
  - stronger local cost context
  - stronger action framing
  - negotiation worksheet support
  - lead capture fields that preserve intent + result-band context

### Verification

Executed:
- `.\gradlew.bat test --tests com.radonverdict.SeoBehaviorIntegrationTest`

Result:
- BUILD SUCCESSFUL

Added regression coverage for:
- global calculator scenario-prefill module visibility
- ZIP redirect carrying `intent` and `radonResultBand`
- seller-credit worksheet guide load

### Next check

Once the GA4 connector session is reloaded, inspect:
- `estimator_start / page_view` on `/radon-cost-calculator`
- prefill pick events
- whether county pages opened from global ZIP search now show more `estimator_result_viewed`
- whether `lead_form_start` increases on buy/sell and `4.0+` paths

If the next bottleneck remains lead starts:
- raise the prominence of the worksheet CTA on transaction paths
- add a `4.0+ next move` CTA block above the fold on county cost pages
- consider a dedicated `buyer credit calculator` variation rather than a generic lead form

### Follow-up implementation

Implemented immediately after this review:
- added an above-the-fold `Negotiation Snapshot` block on county cost pages
- this now appears for:
  - `buying`
  - `selling`
  - `above_4`
  - `between_2_and_4`
- the block surfaces:
  - starting ask / reserve anchor
  - ceiling anchor
  - direct worksheet CTA
  - direct jump back into the full action-plan flow
- lead-form CTA copy now changes by scenario:
  - `Send My Credit Strategy`
  - `Send My 4.0+ Action Plan`
  - `Send My Test + Action Plan`

Resulting product shift:
- the first screen on high-intent pages is no longer just `local estimate context`
- it now behaves more like a lightweight buyer/seller credit calculator without needing a separate heavy tool yet

### Dedicated local credit calculator

Implemented next:
- added a dedicated county-level route:
  - `/radon-credit-calculator/{stateSlug}/{countySlug}`
- this route is intentionally `noindex`
- purpose:
  - convert existing county traffic into a cleaner transaction-intent result screen
  - avoid creating a new SEO doorway cluster

Behavior:
- defaults to transaction intent (`buying` unless `selling` is passed)
- reuses county pricing + scenario inputs from the main action-plan engine
- outputs a focused result screen with:
  - opening ask
  - defensible ceiling
  - quick-close target
  - split-cost fallback
- transaction-intent CTAs on county pages now point to this calculator first
- `radon-levels` buyer/seller path now deep-links to the local credit calculator instead of the generic cost flow

Why this matters:
- it turns transaction-intent visitors into a shorter path:
  - search result -> county page -> credit calculator -> worksheet / action plan
- that is better aligned with the actual job-to-be-done than pushing these visitors straight into a generic lead form

### Global credit-calculator landing

Implemented after the county route:
- added a global entry page:
  - `/radon-credit-calculator`
- added ZIP submit path:
  - `POST /search-zip-credit`

Behavior:
- users can choose:
  - buyer asking for credit
  - seller budgeting response
  - result band
- ZIP then redirects directly into the local county credit calculator
- transaction-focused guides now point to the credit calculator before the generic action-plan flow
- top navigation now exposes `Credit Calculator`

Why this matters:
- we no longer require transaction-intent users to discover the county tool indirectly
- the project now has a direct top-level path for:
  - `seller credit`
  - `repair request`
  - `closing credit`
  - `who pays`

This should improve:
- transaction-path session depth
- county credit calculator opens
- worksheet usage
- lead-start quality on buy/sell traffic

## 2026-04-01 Immediate Step Review: `Levels -> Money Path` Check

### What we analyzed

Used today:
- Google Search Console top pages (last 28 days)
- Google Search Console striking-distance queries
- Google Search Console low-CTR opportunities
- direct GA4 Data API reads on property `525547689`

Reason for this pass:
- decide the current step precisely
- separate `what feels urgent` from `what the numbers actually support`
- confirm whether the next move is:
  - more SEO content
  - local contractor outreach
  - or conversion-path tightening

### What we saw

Search Console top-page reality:
- most visible traction is still concentrated in `radon-levels`
- top recent pages included:
  - `prince-georges-county`: `5 clicks / 42 impressions / 11.9% CTR / 7.33 avg pos`
  - `broomfield-county`: `4 / 35 / 11.4% / 8.26`
  - `story-county`: `4 / 26 / 15.38% / 4.08`
  - `monmouth-county`: `3 / 78 / 3.85% / 7.72`
  - `fairfax-city`: `3 / 81 / 3.70% / 7.65`
  - `marion-county`: `2 / 50 / 4.0% / 5.46`

Low-CTR check:
- the low-CTR opportunities tool returned no meaningful immediate target set
- interpretation:
  - broad snippet rewriting is not the highest-leverage move right now
  - current problem is not primarily `many impressions but terrible CTR`

Striking-distance check:
- `cost` and transaction-intent pages are starting to appear, but still at very low volume
- examples:
  - `gooding-county` testing query: `22 impressions / pos 10.41 / 0 clicks`
  - `jefferson-county` cost query: `15 impressions / pos 13.4 / 0 clicks`
  - `iowa-county` cost query: `14 impressions / pos 11.36 / 0 clicks`
  - `passaic-county` cost query: `9 impressions / pos 9.22 / 0 clicks`
  - `fairfax-city` cost query: `6 impressions / pos 8.83 / 0 clicks`
  - guide `who pays for radon mitigation`: `5 impressions / pos 14 / 0 clicks`

GA4 funnel reality, last 28 days:
- `page_view`: `1142`
- `affiliate_link_click`: `15`
- `estimator_start`: `15`
- `estimator_step_complete`: `27`
- `estimator_result_viewed`: `27`
- `lead_form_start`: `1`
- `lead_form_submit`: `1`

GA4 interpretation:
- affiliate clicks are the only monetization path showing repeated signal
- lead generation is not yet strong enough to justify local outreach as the current step
- the main bottleneck is still:
  - `page view -> action path entry`
  - not `partner supply`

Page-level behavior check:
- `/radon-cost-calculator` already gets meaningful attention
- `radon-levels` pages remain the dominant search-entry surface
- transaction / credit intent exists, but is still early

### Current call

This is the important decision from today's review:
- the current step is **not** local contractor outreach
- the current step is **not** broad content expansion
- the current step is:
  - deploy the new conversion stack
  - let existing `radon-levels` traffic hit:
    - action-plan calculator
    - credit calculator
    - worksheet
    - test-kit CTA
  - then measure whether those paths get real repeated usage

Why:
- Search Console says attention is coming in through `levels`
- GA4 says money-path entry is still too weak
- that means the project does not need a new top-of-funnel project right now
- it needs stronger throughput from the traffic that already exists

### Immediate priority stack

1. Deploy the current unshipped conversion work.
- do not evaluate the funnel before the new action-plan / credit flow is live

2. Freeze broad SEO expansion for one short cycle.
- no large county-page push
- no broad FAQ/meta rewrite pass
- use the next 7 days to observe actual path usage

3. Watch only four metrics daily.
- `affiliate_link_click`
- `levels_result_path_click` or equivalent calculator-entry events
- `lead_form_start`
- `lead_form_submit`

4. Keep local outreach for the next step, not this one.
- revisit only if buy/sell and `4.0+` paths begin producing repeated starts

### What this means operationally

If this next observation window works:
- the site becomes less of a pure SEO site
- and more of a radon decision engine with:
  - a test path
  - a cost path
  - a transaction path

If it does not work:
- the next fix is still inside conversion:
  - stronger above-the-fold CTAs
  - clearer action routing
  - less friction before contact
- not more SEO surface area yet

### Next check

Next review window:
- after deployment + 7 days of live data

Questions to answer next:
1. Did `levels -> action plan / credit calculator` clicks materially increase?
2. Did `affiliate_link_click` rise on the pages already getting impressions?
3. Did `lead_form_start` stay near zero, or finally start repeating?
4. Are buy/sell visitors using the credit calculator at all?

Decision rule for the next step:
- if calculator-entry and lead-start numbers rise:
  - begin planning selective local partner outreach on only the best counties
- if not:
  - continue working the conversion layer before adding any B2B overhead

### Playwright QA + codebase viability check

Added and ran a dedicated Playwright conversion smoke suite:
- `src/test/java/com/radonverdict/PlaywrightConversionFlowsE2ETest.java`

Command:
- `./gradlew.bat test --tests com.radonverdict.PlaywrightConversionFlowsE2ETest`

Result:
- passed

What the browser smoke covered:
- global action-plan calculator -> county action-plan flow
- global credit calculator -> county credit calculator flow
- `radon-levels` buyer/seller CTA -> county credit calculator
- `radon-levels` `4.0+` CTA -> county action-plan page

Artifacts saved:
- `build/reports/playwright-conversion/`

Important interpretation:
- today's conversion work is alive in a real browser
- the new money paths are not just template changes; they are navigable end-to-end

Codebase viability call:
- this project can already do the core `SEO -> decision -> monetization` loop
- reasons:
  - `PageController` now owns both global entry points and county redirect logic
  - `RadonLevelsController` still serves as the main search-acquisition surface
  - `InternalLinkService` can steer users between levels, cost, guides, and local credit tools
  - `ContentGenerationService` already supports result-band and intent-aware action-plan copy
  - `TelemetryController` + `TelemetryEventService` capture behavioral events with local persistence
  - `LeadService` stores leads with scenario fields like intent and result band

What this means:
- the site is no longer blocked on core architecture
- it is good enough to iterate on:
  - CTA prominence
  - scenario routing
  - lead quality
  - affiliate click yield
- the next bottleneck is conversion efficiency, not missing platform capability

What is still not mature enough:
- direct partner ops as the primary loop
- robust lead CRM / pipeline management
- automated revenue reporting
- polished analytics access inside the current MCP session

So the operating conclusion stays the same:
- current step = improve throughput on the flows that now exist
- next step = only after repeated conversion signals, begin selective local partner outreach

---

## 8) How To Append Future Entries

For each new workday, add:
1. Date and data window.
2. "What we saw" (metrics + anomalies).
3. "What we changed" (file list + why).
4. "What passed/failed" (tests, monitoring checks).
5. "Next check date" (D+N action list).

## 9) Senior Advice (Owner Playbook)

1. Do not chase everything at once.
- Keep one primary metric per 2-week cycle.
- Now primary metric: CTR on pages that already get impressions.

2. Use a 70/20/10 execution split.
- 70%: improve existing pages with impressions (title, description, internal links).
- 20%: publish net-new pages only in proven query clusters.
- 10%: experiments (new CTA copy, event naming, monetization test).

3. Protect focus with hard thresholds.
- If impressions are high and CTR < 1%, optimize snippet first.
- If CTR improves but lead events stay flat, optimize form/intent match next.
- If both are flat for 30+ days, revisit page intent and content architecture.

4. Avoid early B2B overhead.
- Early stage priority is repeatable traffic + tracking quality.
- Add direct local partners only after stable lead quality signal.

5. Keep one source of truth.
- This file is the weekly operating log.
- Every change should be recorded with: metric before, change made, result after.

6. Work in short loops.
- Weekly: 3 to 5 page-level changes max.
- Bi-weekly: evaluate, keep winners, discard weak changes.

7. Decision rule for stress moments.
- If data is noisy, do less, not more.
- Small controlled iteration beats broad rewrites.

## 10) 2026-04-01 Structured Data Reality Check (Fairfax)

What triggered this check:
- Search Console still showed `Bad escape sequence in string` for:
  - `https://radonverdict.com/radon-levels/virginia/fairfax-city`
  - `https://radonverdict.com/radon-mitigation-cost/virginia/fairfax-city`
- The reported bad snippets included:
  - `fairfax\-city`
  - `EPA\'s 4.0 pCi\/L`

What we verified:
- Pulled the live production HTML directly and inspected every `application/ld+json` block.
- Current live JSON-LD is valid on both pages.
- `fairfax-city` is now emitted without `\-`.
- `EPA's` is now emitted without `\'`.
- External schema validation also passed on both URLs.

Google-side status as of 2026-04-01:
- `radon-levels/virginia/fairfax-city`
  - last crawl: `2026-04-01T13:01:11Z`
  - rich results verdict: `PASS`
- `radon-mitigation-cost/virginia/fairfax-city`
  - last crawl: `2026-02-28T23:59:21Z`
  - rich results verdict: `FAIL`
  - interpretation: Search Console is still holding an old crawl snapshot for the cost page

Operating conclusion:
- This is no longer a live production JSON-LD bug on the levels page.
- The cost page error is most likely stale Search Console data, not a current rendering failure.
- No emergency template fix was needed after inspecting the live response.

Hardening added:
- Added targeted integration regressions for the Fairfax levels/cost pages so invalid legacy escapes like `\\-` and `\\'` do not silently return.

What to do next:
1. Re-check the cost page inspection after Google recrawls it.
2. Do not treat the old Search Console snippet as proof of a current production bug unless live HTML reproduces it.
3. Keep validating real response HTML first, then compare with Search Console crawl dates.

## 2026-04-07 Affiliate Tracking Taxonomy + GA4 Explore Blueprint

What triggered this checkpoint:
- The affiliate CTA layer was upgraded from vague labels to product-aware CTA IDs.
- We needed GA4 to answer "which CTA, on which page, for which product?" instead of just "affiliate click happened."
- We also needed the ops log to reflect the shift from simple click counting to a proper monetization taxonomy.

### What changed in code today

Frontend tracking layer:
- `src/main/jte/layout/main.jte`

CTA templates updated to the new helper:
- `src/main/jte/pages/guide_radon_testing.jte`
- `src/main/jte/radon_levels_county.jte`
- `src/main/jte/components/radon_level_advisor.jte`
- `src/main/jte/components/lead_form.jte`

What changed:
- Added page-context auto-injection to `rvTrack(...)`:
  - `page_type`
  - `page_path`
  - `title`
  - `state`
  - `county`
  - `result_band`
  - `intent`
  - `article_slug`
- Added `rvTrackAffiliateClick(...)` helper to normalize affiliate CTA payloads before sending.
- Standardized affiliate payload fields:
  - `cta_id`
  - `monetization_channel`
  - `offer_type`
  - `offer_brand`
  - `offer_model`
  - `placement_group`
  - `placement_id`
  - `journey_stage`
  - `merchant`
  - `destination`
  - `destination_host`
  - `href`
  - `cta_text`
- Marked affiliate anchors with `data-rv-affiliate-link="true"` so they do not also fire as generic `outbound_click`.

Why this matters:
- before today, GA4/local telemetry could tell us an affiliate click happened
- after today, we can distinguish:
  - test kit vs monitor
  - first-test CTA vs follow-up CTA
  - guide vs levels vs advisor vs lead-form placement

### GA4 metadata check run today

Property checked:
- `525547689`

Confirmed available standard dimensions:
- `eventName`
- `pagePath`
- `landingPage`
- `pageTitle`

Confirmed available standard metrics:
- `sessions`
- `engagedSessions`
- `engagementRate`

Confirmed key-event session metrics exist:
- `sessionKeyEventRate:qualify_lead`
- `sessionKeyEventRate:close_convert_lead`

Important finding:
- searches for custom dimensions like `cta`, `offer`, and `county` returned nothing
- interpretation:
  - the richer payload is being sent by the site now
  - but GA4 custom definitions still need to be registered before Explore can break down by those fields

### GA4 event reality check run today

Window checked:
- `2026-03-24` to `2026-04-07`

Top business-relevant events seen in GA4:
- `page_view`: `517`
- `affiliate_link_click`: `7`
- `levels_result_path_click`: `6`
- `lead_form_start`: `2`
- `close_convert_lead`: `2`

Supporting event context:
- `form_start`: `21`
- `form_submit`: `9`
- `estimator_result_viewed`: `18`
- `estimator_start`: `11`

Interpretation:
- money-path behavior is visible in GA4 now
- but the volume is still low enough that CTA quality and routing still matter more than scaling dashboards

### Landing-page reality check from GA4

Landing-page report run today (`2026-03-24` to `2026-04-07`):
- `(not set)`: `66 sessions`
- `/guides/radon-myths-granite-countertops`: `33 sessions`
- `/radon-cost-calculator`: `18 sessions`
- `/radon-levels/washington/okanogan-county`: `12 sessions`

Interpretation:
- traffic is still fragmented across informational and calculator surfaces
- the future CTA readout must focus on landing page + monetization event, not page-level totals alone
- `(not set)` volume is still non-trivial and should be watched in future GA4 hygiene checks

### Local telemetry QA completed today

Local CSV checked:
- `data/telemetry_events.csv`

Verified example payloads were recorded locally after Playwright clicks:
- test-kit click example:
  - `cta_id = levels_intro_test_kit`
  - `offer_type = test_kit`
  - `offer_brand = first_alert`
  - `journey_stage = first_test`
- monitor click example:
  - `cta_id = levels_intro_monitor_followup`
  - `offer_type = monitor`
  - `offer_brand = airthings`
  - `journey_stage = followup_monitor`

Important QA result:
- affiliate links now record `affiliate_link_click` cleanly
- they do not double-count as `outbound_click`

### Explore blueprint locked today

The recommended GA4 Explore set is now:
1. Affiliate CTA scorecard
- rows:
  - `cta_id`
  - `offer_type`
  - `placement_group`
- filter:
  - `eventName = affiliate_link_click`

2. Landing page to monetization map
- rows:
  - `landingPage`
  - `eventName`
- focus events:
  - `affiliate_link_click`
  - `levels_result_path_click`
  - `lead_form_start`
  - `lead_form_submit`
  - `qualify_lead`

3. County + intent split
- rows:
  - `county`
  - `intent`
  - `result_band`
- compare:
  - `affiliate_link_click`
  - `qualify_lead`

4. Lead quality funnel
- steps:
  - `page_view`
  - `lead_form_start`
  - `lead_form_submit`
  - `qualify_lead`
  - `close_convert_lead`

### Operational conclusion

Today's tracking work moved the project from:
- "we know clicks happened"

to:
- "we can identify which monetization CTA generated the click and at what decision stage"

This is the correct level of instrumentation for the current phase because:
- the site is still proving its first monetization loop
- traffic is not yet high enough to justify looser, aggregate-only reporting
- CTA-level learning is currently more valuable than top-line dashboard polish

### What to do next

1. Register the new GA4 custom dimensions.
- especially:
  - `cta_id`
  - `offer_type`
  - `offer_brand`
  - `placement_group`
  - `placement_id`
  - `journey_stage`
  - `page_type`
  - `county`
  - `result_band`
  - `intent`

2. Keep using local CSV telemetry for payload QA until GA4 custom definitions are visible.

3. On the next 7-day check, answer:
- which CTA ID gets the most clicks?
- are kit clicks still dominating monitor clicks?
- which landing pages generate the most `affiliate_link_click` per session?
- does `lead_form_start` move at all on pages where affiliate clicks rise?

## 2026-04-07 Full Beta Test: Desktop + Mobile

- Ran end-to-end beta testing as a real user on desktop and mobile with Playwright CLI against the local app.
- Tested core flows:
  - `/radon-cost-calculator`
  - ZIP search into county action plans
  - `/radon-mitigation-cost/virginia/falls-church-city`
  - `/radon-levels/virginia/falls-church-city`
  - `/guides` and `/guides/how-to-test-for-radon`
  - `/contact`
- High-impact issues found:
  - ZIP search and lead-submit redirects were hardcoded to the canonical production host, which broke local and preview validation by sending the browser to `radonverdict.com`.
  - Contact page form was fake and only triggered a browser alert instead of storing or routing the message.
  - `not_tested` cost flows opened with a `5.5 pCi/L` red warning state, which felt inconsistent before the user had any measured reading.
- Fixes shipped:
  - Converted controller redirects to host-relative redirects so the current environment stays intact during search, lead-submit, and canonical-path normalization.
  - Added a real contact message submission flow backed by CSV persistence at `data/contact_messages.csv`.
  - Reworked the contact page to show real success and error messaging and preserve entered values on validation failure.
  - Changed `not_tested` cost-mode radon advisor to a sample-reading mode with a neutral `3.0 pCi/L` starting point and clearer copy.
- Verification after fixes:
  - Re-ran desktop and mobile Playwright checks.
  - Confirmed local ZIP search and lead submit stay on `127.0.0.1:8081`.
  - Confirmed contact form submission writes a row to `data/contact_messages.csv`.
  - Confirmed `not_tested` cost pages no longer start in a red `5.5` warning state.
  - Found and fixed a post-submit UX regression where lead success redirects dropped `intent` and `radonResultBand`, causing the user to land back on a mismatched scenario.
  - Updated lead-submit redirects to preserve scenario query params and return to `#estimate-form` so the success state stays anchored to the exact flow the user just completed.
  - Found a low-severity copy-generation bug during mobile QA (`22th percentile`) and fixed percentile suffix formatting in the narrative generator with test coverage.
  - Updated contact-page visible email routes to `shinhyeok22@gmail.com` so general and partnership inquiries both point to the live owner inbox.
  - Cleaned the local beta-test artifacts after verification:
    - reset `data/contact_messages.csv`
    - reset `data/leads.csv`
    - reset `data/telemetry_events.csv`
    - removed `.playwright-cli/`
    - removed `output/playwright/`

## 2026-04-08 Tracking Effect Check

- Looked back at the most relevant recent tracking/conversion change set:
  - `3372944` on `2026-04-01` (`Add radon action plan and credit conversion flows`)
  - this is the change that added richer lead-flow context and the cost/credit conversion paths

- Measured the short before/after windows:
  - GA4 `2026-03-28` to `2026-04-01` vs `2026-04-02` to `2026-04-07`
  - GSC `2026-03-28` to `2026-04-01` vs `2026-04-02` to `2026-04-06`

- GA4 before/after summary:
  - `page_view`: `152` -> `260`
  - `affiliate_link_click`: `4` -> `3`
  - `levels_result_path_click`: `2` -> `8`
  - `lead_form_start`: `0` -> `4`
  - `lead_form_submit`: `0` -> `5`
  - `qualify_lead`: `0` -> `5`
  - `close_convert_lead`: `0` -> `4`

- Practical read:
  - the April 1 work did show an effect on conversion-path usage and visibility
  - the clearest signal is stronger movement into result-path and lead-submit events
  - affiliate performance did not improve in the same short window
  - this should be treated as a `better funnel + better measurement` win, not as proof of better monetization yet

- SEO / demand read:
  - GSC clicks fell `51` -> `42`
  - impressions fell `4,109` -> `2,571`
  - CTR improved `1.24%` -> `1.63%`
  - average position stayed basically flat (`7.48` -> `7.46`)
  - interpretation: no clear search-lift yet; too soon and too small to claim traffic benefit

- Calculator adoption read:
  - `/radon-cost-calculator` page views moved `9` -> `15`
  - `/radon-credit-calculator` picked up `3` GA4 page views after launch and `2` GSC impressions in the measured window
  - interpretation: the new path exists in the wild, but it is still early-stage and low-volume

- One instrumentation caveat remains:
  - `lead_form_submit` exceeded `lead_form_start` in the short post-change window
  - use `submit`, `qualify`, and `close_convert_lead` as the more trustworthy funnel signals until `lead_form_start` is tightened

## 2026-04-08 User-Journey UX Pass for Monetization Flow

- Re-ran the site as a real user on desktop and mobile after the monetization changes, with a specific focus on:
  - where low-intent users would bounce
  - where the flow felt too mitigation-heavy before a real test
  - where context was being re-entered or contradicted

- Main UX problems found:
  - `/radon-cost-calculator` pushed ZIP entry immediately, without an equally clear "I have not tested yet" path.
  - `not_tested` county cost pages still felt too contractor/mitigation-forward for users who only wanted a first step.
  - users who already arrived via ZIP lookup had to enter ZIP again in the lead form.
  - foundation context was inconsistent between page summary, simulator, and lead form.

- Fixes shipped:
  - added a clear test-first split on `/radon-cost-calculator` so first-time users can go straight to `/guides/how-to-test-for-radon`.
  - changed `not_tested` county hero copy from "action plan + mitigation cost" framing to "test plan + cost context" framing.
  - added a `Best First Step` callout above the fold on `not_tested` county pages to slow users down before quote-shopping.
  - changed the cost-mode radon advisor to treat `not_tested` as a sample-reading workflow instead of a confirmed reading workflow.
  - preserved ZIP across search and post-submit redirects, then locked the ZIP inside the lead form when it came from county lookup.
  - aligned defaults so `not_tested` flows start with:
    - `No, not yet` selected
    - `Other / Not Sure` foundation available in the simulator and selected in the form when no better context exists

- Verification:
  - `.\gradlew.bat compileJava`
  - re-tested `http://127.0.0.1:8081/radon-cost-calculator`
  - re-tested `http://127.0.0.1:8081/radon-mitigation-cost/virginia/falls-church-city?intent=homeowner&radonResultBand=not_tested&zipCode=22046#estimate-form`
  - confirmed the updated flow now reads as:
    - test first
    - use cost page as planning context
    - do not re-enter ZIP
    - do not default to a basement/high-urgency mental model

- Residual note:
  - visible journey copy is now much better aligned for `not_tested`, but some SEO/browser-title surfaces still remain cost-forward because they intentionally serve search positioning.

## 2026-04-13 Product Packaging + Conversion Hierarchy Pass

What triggered this pass:
- a product review found the experience still read like multiple disconnected calculators instead of one decision flow with a clear next step

What changed:
- relabeled top navigation around the main product:
  - `Action Plan` replaces the old top-level cost-calculator framing
  - `Testing Guide` is now a first-class navigation route
  - the top-level `Credit Calculator` nav item was removed so transaction math reads as a branch, not the whole product
- split the homepage into two explicit entry paths:
  - result-first for users who already have a radon reading
  - test-first for users who still need to confirm a result
- added new tracking on the homepage path split:
  - event: `home_path_pick`
  - affiliate CTA id: `home_test_first_short_term_kit`
- reordered county cost pages so the scenario tool and live receipt come before proof/support blocks
- simplified the county lead form:
  - removed duplicate visible foundation/test-status inputs
  - preserved scenario state with hidden fields
  - tightened the promise into local plan / local credit-range language based on the active scenario
- added a bridge back from the credit-calculator landing page to the full action-plan flow

Why this matters:
- the product now reads closer to `one product, one next step`
- that should lower decision fatigue on entry pages
- it also creates a clearer handoff from information intent into the right conversion path

Verification:
- executed:
  - `npm run build:css`
  - `.\gradlew.bat compileJava`
  - `.\gradlew.bat test --tests com.radonverdict.SeoBehaviorIntegrationTest.globalCalculatorShowsScenarioPrefillModule --tests com.radonverdict.SeoBehaviorIntegrationTest.globalCreditCalculatorLandingLoads --tests com.radonverdict.SeoBehaviorIntegrationTest.globalCreditCalculatorLandingLinksBackToActionPlanFlow --tests com.radonverdict.SeoBehaviorIntegrationTest.countyPageShowsTrustSummaryAndCostBenchmarks --tests com.radonverdict.SeoBehaviorIntegrationTest.countyHubUsesActionPlanInputsInsteadOfCostOnlyFraming --tests com.radonverdict.SeoBehaviorIntegrationTest.countyHubLeadFormUsesScenarioContextInsteadOfDuplicateInputs --tests com.radonverdict.SeoBehaviorIntegrationTest.countyHubKeepsLeadFormAheadOfTrustSummaryBlocks --tests com.radonverdict.SeoBehaviorIntegrationTest.countyHubShowsNegotiationSnapshotForBuyingFlow --tests com.radonverdict.SeoBehaviorIntegrationTest.countyHubShowsHighReadingFastPathForHomeownerFlow --tests com.radonverdict.PlaywrightBetaSmokeE2ETest.persona04NoTestedUserSeesAffiliateFallbackSignals`
- result:
  - BUILD SUCCESSFUL
- screenshots captured:
  - `output/product-review-after/home-desktop.png`
  - `output/product-review-after/county-desktop.png`
  - `output/product-review-after/county-mobile-top.png`
  - `output/product-review-after/credit-landing-desktop.png`

Next check:
- review GA4 and local telemetry for:
  - `home_path_pick`
  - `home_test_first_short_term_kit`
  - `lead_form_start`
  - `lead_form_submit`
- compare county-page scroll depth and CTA click behavior after the hierarchy reorder

## 2026-04-13 Search Console CTR Target Refresh

What triggered this pass:
- Search Console overall performance is up, but the remaining bottleneck has shifted toward snippet click capture on a narrow set of county `radon-levels` pages.
- The earlier Montana review also exposed a protection gap: the regression test covered on-page copy but not the `<title>` and meta description that actually changed.

Search Console comparison used today:
- current window: `2026-03-16` to `2026-04-12`
- baseline window: `2026-02-17` to `2026-03-15`
- result:
  - clicks: `308`
  - impressions: `24,607`
  - CTR: `1.25%`
  - average position: `7.54`
- baseline:
  - clicks: `176`
  - impressions: `15,882`
  - CTR: `1.11%`
  - average position: `11.02`
- interpretation:
  - discovery and ranking are both healthier now
  - snippet work should stay selective and page-specific, not broad and template-wide

Automated low-CTR signal:
- `seo_low_ctr_opportunities` only surfaced one clearly urgent query/page pair:
  - query: `radon levels in basement falls church va`
  - page: `https://radonverdict.com/radon-levels/virginia/falls-church-city`
  - impressions: `85`
  - clicks: `0`
  - CTR: `0%`
  - average position: `4.72`

Manual page-level review used to extend the batch:
- `falls-church-city`
  - `162 impressions / 2 clicks / 1.23% CTR / 10.72 avg pos`
- `alcorn-county`
  - `235 impressions / 1 click / 0.43% CTR / 4.74 avg pos`
- `westchester-county`
  - `95 impressions / 1 click / 1.05% CTR / 5.22 avg pos`
- `licking-county`
  - `88 impressions / 1 click / 1.14% CTR / 4.28 avg pos`
- `polk-county`
  - `57 impressions / 1 click / 1.75% CTR / 3.95 avg pos`

Why these 5 pages were selected:
- each page already has real impressions
- each page is close enough to page 1 that snippet phrasing can plausibly move CTR
- this is a narrow enough batch to attribute any lift after recrawl

What changed:
- added a `topCtrPriorityCounty` branch in `src/main/jte/radon_levels_county.jte` for:
  - `falls-church-city`
  - `alcorn-county`
  - `westchester-county`
  - `licking-county`
  - `polk-county`
- tightened these pages toward a clearer basement-first SERP frame:
  - title: `Basement Radon Levels | EPA Zone & 4.0 Guide`
  - meta description: basement level + EPA zone + `2.0 vs 4.0+` meaning + retest / quote comparison
  - H1 / direct-answer lead aligned to the same basement-testing intent

Test protection updated the same day:
- Montana state `radon-levels` regression now asserts both:
  - `<title>`
  - meta description
- added a helper-backed test for all 5 top CTR county pages so title/meta/H1/direct-answer copy stay locked
- updated the independent-city test so Falls Church continues to render:
  - `Falls Church, VA`
  - not `Falls Church County, VA`
- refreshed the St. Louis county product test to protect the current testing-first CTA set instead of obsolete monitor copy

Verification:
- executed:
  - `.\gradlew.bat test --tests com.radonverdict.SeoBehaviorIntegrationTest.topCtrCountyPagesUseBasementFirstSerpCopy --tests com.radonverdict.SeoBehaviorIntegrationTest.montanaLevelsStatePageUsesMapFocusedCopy --tests com.radonverdict.SeoBehaviorIntegrationTest.independentCitySeoAvoidsCountyLabelInTitleAndBreadcrumbJsonLd --tests com.radonverdict.SeoBehaviorIntegrationTest.radonLevelsCountyUsesTestingGuideSeoAndKeepsCurrentTestingFirstCtas`

Next GSC read after recrawl:
- compare CTR movement for:
  - `https://radonverdict.com/radon-levels/virginia/falls-church-city`
  - `https://radonverdict.com/radon-levels/mississippi/alcorn-county`
  - `https://radonverdict.com/radon-levels/new-york/westchester-county`
  - `https://radonverdict.com/radon-levels/ohio/licking-county`
  - `https://radonverdict.com/radon-levels/iowa/polk-county`
- hold Montana as a regression-protection target, not an urgent CTR rewrite target, unless impressions rise materially above the current ~`64-71` range
