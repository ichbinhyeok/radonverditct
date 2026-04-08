# 07 - Analytics and KPIs (Money-First)

## 1) Core objective
Optimize for:
- Accepted leads x CPL (revenue from pros)
- Affiliate click-throughs (revenue from test kits and monitors)

## 2) Event taxonomy
### Base page context
Every frontend event sent through `rvTrack(...)` should include:
- `page_type`
- `page_path`
- `title`
- `state`
- `county`
- `result_band`
- `intent`
- `article_slug`

Notes:
- `state` and `county` are only present on county/state program pages where they exist.
- `result_band` and `intent` come from query params when present.
- `article_slug` is only present on `/guides/*`.

### Page events
- `page_view`
- `scroll_depth`
- `estimator_start`
- `estimator_step_complete`
- `estimator_result_viewed`
- `levels_result_path_click`

### Lead / monetization events
- `lead_form_start`
- `lead_form_submit`
- `qualify_lead`
- `close_convert_lead`
- `consent_checked`
- `affiliate_link_click`

### Delivery events (backend logs)
- `lead_delivery_queued`
- `lead_delivery_sent`
- `lead_delivery_failed`

## 3) Affiliate event contract
`affiliate_link_click` is the key revenue event for the current stage.

Required payload fields:
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

Current vocabulary:
- `offer_type`: `test_kit`, `monitor`
- `monetization_channel`: `affiliate`
- `merchant`: `amazon`
- `journey_stage`: `first_test`, `followup_monitor`

Current placement groups:
- `guide`
- `levels`
- `advisor`
- `lead_form`

Current examples:
- `cta_id = guide_primary_test_kit`
- `cta_id = guide_monitor_followup`
- `cta_id = levels_intro_test_kit`
- `cta_id = levels_intro_monitor_followup`
- `cta_id = levels_sticky_test_kit`
- `cta_id = levels_sticky_monitor_followup`
- `cta_id = advisor_safe_test_kit`
- `cta_id = advisor_caution_monitor_primary`
- `cta_id = lead_form_not_tested_test_kit`

Important implementation rule:
- Affiliate links must carry `data-rv-affiliate-link="true"` so they do not double-fire as both `affiliate_link_click` and generic `outbound_click`.

## 4) Funnel KPIs
- **Wizard Start Rate** = `estimator_start / page_view`
- **Wizard Completion Rate** = `estimator_result_viewed / estimator_start`
- **Lead Start Rate** = `lead_form_start / page_view`
- **Lead Submit Rate** = `lead_form_submit / lead_form_start`
- **Qualified Lead Rate** = `qualify_lead / lead_form_submit`
- **Affiliate Fallback Rate** = `affiliate_link_click / estimator_result_viewed`
- **Kit Share** = `affiliate_link_click where offer_type=test_kit / affiliate_link_click`
- **Monitor Share** = `affiliate_link_click where offer_type=monitor / affiliate_link_click`

Monetization:
- **EPMV (Earnings Per Thousand Visitors)** = `(Lead Rev + Affiliate Rev) / (page_views / 1000)`
- **CPL (Cost Per Lead)** = average payout per successfully delivered lead
- **Affiliate CTR by landing page** = `affiliate_link_click / sessions`

## 5) GA4 setup requirements
GA4 property:
- `525547689`

Key events that should stay enabled in GA4:
- `qualify_lead`
- `close_convert_lead`

Custom event dimensions that should be registered in GA4:
- `page_type`
- `state`
- `county`
- `result_band`
- `intent`
- `article_slug`
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
- `cta_text`

Why this matters:
- standard GA4 dimensions are enough to see `eventName`, `landingPage`, `pagePath`, and sessions
- they are not enough to answer "which CTA sold the kit?" until the custom dimensions above are registered

## 6) GA4 Explore templates
### Explore 1 - Affiliate CTA scorecard
Type:
- Free form

Rows:
- `cta_id`
- `offer_type`
- `placement_group`

Columns:
- optional `journey_stage`

Metrics:
- `eventCount`
- `activeUsers`

Filter:
- `eventName = affiliate_link_click`

Use:
- identify which CTA actually gets clicked
- compare test-kit vs monitor appetite

### Explore 2 - Landing page to monetization map
Type:
- Free form

Rows:
- `landingPage`
- `eventName`

Metrics:
- `sessions`
- `engagedSessions`
- `eventCount`

Filter:
- `eventName` in `affiliate_link_click`, `levels_result_path_click`, `lead_form_start`, `lead_form_submit`, `qualify_lead`

Use:
- find which entry pages generate money-path movement
- avoid optimizing pages that only generate passive traffic

### Explore 3 - County + intent split
Type:
- Free form

Rows:
- `county`
- `intent`
- `result_band`

Metrics:
- `eventCount`

Filter:
- `eventName = affiliate_link_click` or `eventName = qualify_lead`

Use:
- compare homeowner vs buying/selling traffic
- find counties where info intent starts turning into monetization intent

### Explore 4 - Lead quality funnel
Type:
- Funnel exploration

Steps:
1. `page_view`
2. `lead_form_start`
3. `lead_form_submit`
4. `qualify_lead`
5. `close_convert_lead`

Breakdown:
- `page_type`
- `county`
- `result_band`

Use:
- distinguish "people saw the form" from "people became usable leads"

## 7) Current operational read (2026-04-07)
GA4 standard metadata confirmed:
- dimensions available: `eventName`, `pagePath`, `landingPage`, `pageTitle`
- metrics available: `sessions`, `engagedSessions`, `engagementRate`
- key-event metrics available: `sessionKeyEventRate:qualify_lead`, `sessionKeyEventRate:close_convert_lead`

GA4 custom-dimension status:
- searches for `cta`, `offer`, and `county` custom dimensions returned none
- interpretation: the richer event payload is being sent, but GA4 custom definitions still need to be registered for Explore to use them

Recent event reality check from GA4 (`2026-03-24` to `2026-04-07`):
- `page_view`: `517`
- `affiliate_link_click`: `7`
- `levels_result_path_click`: `6`
- `lead_form_start`: `2`
- `close_convert_lead`: `2`

Interpretation:
- monetization-path traffic exists
- but volume is still low enough that event naming and CTA placement quality matter more than dashboard sophistication

## 8) Tagging and tracking
- Use the custom `rvTrack(...)` layer as the source of truth for frontend business events.
- Keep `send_page_view: false` in GA4 config so `page_view` is controlled by the custom layer only.
- Do not log raw PII into analytics platforms.
- Use local CSV telemetry as the debug backstop when GA4 UI lags or custom dimensions are missing.

## 9) Reporting
- Check `data/telemetry_events.csv` for exact payload debugging.
- Check `lead_deliveries.csv` periodically to calculate true EPMV and compare against GA4 events.
- Use GA4 for trend reading, and local CSV for payload QA.

## 10) Effect check on 2026-04-01 tracking changes (read on 2026-04-08)
Comparison windows used:
- GA4: `2026-03-28` to `2026-04-01` vs `2026-04-02` to `2026-04-07`
- GSC: `2026-03-28` to `2026-04-01` vs `2026-04-02` to `2026-04-06`

Important note:
- GA4 property timezone is `America/Los_Angeles`, so "day" boundaries below follow that property timezone, not Korea time.

GA4 before/after event totals:
- `page_view`: `152` -> `260` (`+71.1%`)
- `affiliate_link_click`: `4` -> `3` (`-25.0%`)
- `levels_result_path_click`: `2` -> `8` (`+300.0%`)
- `lead_form_start`: `0` -> `4`
- `lead_form_submit`: `0` -> `5`
- `qualify_lead`: `0` -> `5`
- `close_convert_lead`: `0` -> `4`

GA4 normalized read:
- affiliate clicks per page view: `2.63%` -> `1.15%`
- result-path clicks per page view: `1.32%` -> `3.08%`

Credit/cost calculator adoption:
- `/radon-cost-calculator` page views: `9` -> `15`
- `/radon-credit-calculator` page views after launch window: `3`

GSC before/after:
- clicks: `51` -> `42` (`-17.6%`)
- impressions: `4,109` -> `2,571` (`-37.4%`)
- CTR: `1.24%` -> `1.63%` (`+31.6%`)
- average position: `7.48` -> `7.46` (flat)

Page-specific GSC snapshot (`2026-03-28` to `2026-04-06`):
- `/radon-cost-calculator`: `1` click, `19` impressions, avg position `26.05`
- `/radon-credit-calculator`: `0` clicks, `2` impressions

Interpretation:
- The `2026-04-01` changes appear to have improved monetization-path usage and measurement depth, especially `levels_result_path_click` and downstream lead events.
- There is not yet evidence that the change improved affiliate CTA performance. Early affiliate click rate is slightly worse after the change window.
- There is not yet evidence of an SEO lift from these changes. Organic clicks and impressions are lower in the short post-change window, while ranking stayed effectively flat.
- The cost calculator is getting some traction, and the credit calculator has started receiving visits, but both are still low-volume.
- `lead_form_submit > lead_form_start` in the post-change window means `lead_form_start` is still undercounting relative to submit. Treat submit/qualify data as more reliable than start-rate math until that event is tightened.

Decision:
- Treat the April 1 work as a conversion-instrumentation improvement, not a traffic-growth win.
- Keep optimizing CTA placement and lead flow clarity before making traffic-level claims.
