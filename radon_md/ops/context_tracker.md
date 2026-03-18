# RadonVerdict Context Tracker

Last updated: 2026-03-08 (Asia/Seoul)

## 1) Today's Snapshot

Date range note:
- Latest confirmed Search Console data available through 2026-03-06.
- Main working window for current interpretation: 2026-02-23 to 2026-03-06.
- Prior tracker window (2026-02-23 to 2026-03-02) is retained below as baseline comparison.

GSC (Google Search Console):
- Total clicks: 99
- Total impressions: 9,207
- CTR: 1.08%
- Average position: 11.58

Recent movement:
- 2026-02-23 to 2026-02-27: 3 clicks / 1,576 impressions / CTR 0.19%
- 2026-02-28 to 2026-03-02: 45 clicks / 3,728 impressions / CTR 1.21%
- 2026-03-03 to 2026-03-06: 51 clicks / 3,903 impressions / CTR 1.31% / average position 10.65
- Interpretation: discovery is no longer the only story; CTR and ranking are both improving.

Baseline correction vs the 2026-03-05 note:
- The earlier 7-day snapshot ("about 49 clicks / 5,547 impressions / 0.88% CTR") finalized closer to:
- 2026-02-23 to 2026-03-02: 48 clicks / 5,304 impressions / CTR 0.90% / average position 12.27

GA4 (property: 525547689, last refreshed 2026-03-05; not re-pulled during the 2026-03-08 GSC pass):
- Users: 151
- Sessions: 165
- Engaged sessions: 86
- Engagement rate: 52.1%
- Avg session duration: about 97.9s
- Page views: 424

Lead/event status last seen in GA4 before event-mapping fixes:
- `lead_form_submit`: 2
- `form_submit`: 5
- `qualify_lead`: 0
- `close_convert_lead`: 0

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
