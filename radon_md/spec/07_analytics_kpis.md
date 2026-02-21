# 07 — Analytics and KPIs (Money-First)

## 1) Core objective
Optimize for:
- Accepted leads * CPL (Revenue from Pros)
- Affiliate Click-throughs (Revenue from DIY Test Kits)

## 2) Event taxonomy (minimum)
### Page events
- `page_view` (path, state, county)
- `estimator_start` (Wizard opened)
- `estimator_step_complete` (Foundation, Home Type, etc.)
- `estimator_result_viewed`

### Lead / Monetization events
- `lead_form_start`
- `lead_form_submit`
- `affiliate_link_click` (Amazon Test Kit link clicked)
- `consent_checked`

### Delivery events (Backend Logs)
- `lead_delivery_queued`
- `lead_delivery_sent`
- `lead_delivery_failed`

## 3) Funnel KPIs (definitions)
- **Wizard Start Rate** = estimator_start / page_view
- **Wizard Completion Rate** = estimator_result_viewed / estimator_start
- **Lead Conversion Rate** = lead_form_submit / estimator_result_viewed
- **Affiliate Fallback Rate** = affiliate_link_click / estimator_result_viewed

Monetization:
- **EPMV (Earnings Per Thousand Visitors)** = (Lead Rev + Affiliate Rev) / (page_views / 1000)
- **CPL (Cost Per Lead)** = Average payout per successfully delivered lead.

## 4) Tagging & Tracking (DB-less)
- Use standard lightweight tracking pixels (Google Analytics 4 / Plausible Analytics) via Frontend triggers.
- Do NOT log raw PII into analytics platforms. Use generic flags.

## 5) Reporting
- Check the `lead_deliveries.csv` file periodically to calculate true EPMV and compare against Google Analytics events.
