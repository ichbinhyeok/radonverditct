# RadonVerdict Context Tracker

Last updated: 2026-03-05 (Asia/Seoul)

## 1) Today's Snapshot

Date range note:
- 7-day views below are based on 2026-02-23 to 2026-03-02.
- "site launched 7 days ago" context was used for interpretation.

GSC (Google Search Console):
- Total clicks: about 49
- Total impressions: about 5,547
- CTR: about 0.88%
- Early pattern: discovery/indexing is active, with impression growth visible.

GA4 (property: 525547689):
- Users: 151
- Sessions: 165
- Engaged sessions: 86
- Engagement rate: 52.1%
- Avg session duration: about 97.9s
- Page views: 424

Lead/event status seen before fixes:
- `lead_form_submit`: 2
- `form_submit`: 5
- `qualify_lead`: 0
- `close_convert_lead`: 0

## 2) What We Identified Today

1. JSON-LD was being escaped in script context (invalid JSON-LD risk in rich results).
2. Some HTTP canonical leakage remained in proxy/header edge cases.
3. GA4 key-event mapping for lead lifecycle was incomplete.
4. Low CTR opportunities existed on `radon-levels` state/county pages, especially where state abbreviation-only titles were weak in SERP snippets.

## 3) What We Improved Today

### A. JSON-LD Safety Fix

Goal:
- Ensure JSON-LD values are serialized as valid JSON strings.

Changes:
- Added serializer utility:
  - `src/main/java/com/radonverdict/util/JsonLdUtils.java`
- Applied to templates:
  - `src/main/jte/layout/main.jte`
  - `src/main/jte/county_hub.jte`
  - `src/main/jte/radon_levels_county.jte`

### B. Canonical Redirect Hardening

Goal:
- Force HTTP -> HTTPS canonical redirect consistently.

Changes:
- Updated:
  - `src/main/java/com/radonverdict/config/CanonicalUrlRedirectFilter.java`
- Result:
  - Cloudflare-proxy traffic without `CF-Visitor` no longer skips scheme redirect.

### C. GA4 Lead Key-Event Mapping

Goal:
- Capture meaningful conversion stages in GA4.

Changes:
- Updated:
  - `src/main/jte/components/lead_form.jte`
- Behavior:
  - On submit: emits `lead_form_submit` + `qualify_lead`
  - On success state: emits `close_convert_lead`

### D. CTR-Oriented Metadata Update (Applied Immediately)

Goal:
- Improve click-through from existing impressions without broad redesign.

Changes:
- Updated state-level `radon-levels` title/description and display naming:
  - `src/main/jte/radon_levels_state.jte`
- Updated county-level `radon-levels` title/description:
  - `src/main/jte/radon_levels_county.jte`

Example direction:
- State title now follows search intent format:
  - `{State Name} Radon Zone Map by County (Year) | EPA 4.0 pCi/L Guide`
- County title now follows:
  - `{County}, {ST} Radon Levels & Zone Map | EPA 4.0 pCi/L Guide`

## 4) Verification (Today)

Executed:
- `.\gradlew.bat test --tests com.radonverdict.SeoBehaviorIntegrationTest`

Result:
- BUILD SUCCESSFUL (after updating one assertion to new title text behavior).

## 5) Interpretation (7-Day Post-Launch)

Current verdict:
- Not "proof of scale yet," but a healthy early-stage signal.
- Better than many new sites that stay near zero discovery after 1-2 months.
- Current priority is incremental compounding, not structural rebuild.

## 6) Next Checkpoints

At D+14:
- Compare CTR delta for updated `radon-levels` state/county pages.
- Confirm GA4 key events (`qualify_lead`, `close_convert_lead`) are appearing reliably.
- Identify top pages with high impressions and CTR < 1% for next title/description pass.

At D+30:
- Evaluate stable query clusters (which intents actually bring clicks).
- Decide whether to expand only winning page patterns.
- Reassess monetization mix based on conversion signal quality.

## 7) Monetization Direction (Operational Load First)

Preference captured:
- Keep operations light (platform-like flow preferred over heavy direct sales).

Practical approach:
- Near term: platform/automated affiliate-heavy model.
- Later: selective local B2B partners only after traffic + lead quality stabilize.

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
