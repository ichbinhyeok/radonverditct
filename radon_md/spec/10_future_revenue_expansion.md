# 10 — Future Revenue Expansion (Traffic > 1,000/mo Milestone)

> These features are intentionally deferred until organic traffic exceeds 1,000 monthly sessions.
> The rationale: implementing these prematurely adds code complexity without meaningful revenue impact.
> Revisit this document when Google Search Console shows consistent 1K+ monthly clicks.

## Phase A: No-Coverage Fallback Routing (Revenue Leakage Fix)

### Problem
When a user submits a lead form from a county where we have no contracted local mitigator,
the lead evaporates. We lose both the user and the potential revenue.

### Solution: 3-Tier Fallback
1. **Tier 1 (Direct):** If a contracted local seller exists → route lead directly (highest revenue per lead).
2. **Tier 2 (Network):** If no local seller → POST lead to a national lead aggregator API (Networx, Modernize, Angi Leads). Revenue: $10–$30/lead.
3. **Tier 3 (Affiliate):** If aggregator also rejects → redirect user to "Thank You" page with Amazon affiliate links for radon test kits / monitors. Revenue: $1–$5/click.

### Implementation Notes
- Add a `sellers.json` config file with coverage maps (state/county level).
- Add fallback routing logic in `LeadController.java` after form submission.
- Track which tier was used in `logs/lead_deliveries.csv` for revenue attribution.

---

## Phase B: Commercial / Multi-Family B2B Lead Channel

### Problem
Current calculator/UI targets only residential homeowners.
Commercial radon mitigation projects (schools, daycares, apartment complexes, warehouses)
are 10x–50x larger in scope ($10K–$50K per job), and these leads command premium prices.

### Solution
- Add a small but visible CTA on county pages: **"Need a commercial or multi-family estimate?"**
- Route to a separate, simpler lead form capturing: property type, approximate sq ft, number of units, contact info.
- Store these leads separately and sell them to commercial-focused mitigation firms at premium rates ($100–$500/lead).

### Implementation Notes
- New JTE page: `pages/commercial_lead.jte`
- New controller endpoint: `GET /commercial-estimate`
- Separate CSV log: `logs/commercial_leads.csv`

---

## Phase C: Fan Replacement / Maintenance Keyword Capture

### Problem
Millions of US homes already have radon mitigation systems installed (2000s–2010s era).
The exhaust fans (RadonAway, Fantech) typically last 8–12 years and are now failing en masse.
Users search: "radon fan replacement cost", "radon manometer reading zero", "radon fan not running".
Our site currently has zero pages targeting these high-intent keywords.

### Solution: Dual Monetization
1. **Programmatic Pages:** `/radon-fan-replacement/[state]/[county]`
   - Estimated replacement cost (fan + labor) using the same pricing engine with a "fan_replacement" config.
   - Lead form → connect with local servicer.
2. **Amazon Affiliate:** For DIY users, link directly to replacement fan models on Amazon ($150–$250 per unit).
   - RadonAway RP145, RP265
   - Fantech Rn2, Rn3

### Implementation Notes
- Reuse existing `PricingCalculatorService` with a new `fan_replacement` pricing config section.
- New JTE template: `fan_replacement_hub.jte`
- New controller: `FanReplacementController.java`
- Sitemap: Add fan replacement pages to `SitemapController.java` in a separate `<sitemap>` index.

---

## Priority Order (When Traffic Hits 1K)
1. **Phase A** first — stop revenue leakage immediately.
2. **Phase C** second — lowest effort, highest passive income potential (affiliate).
3. **Phase B** third — requires sales outreach to commercial firms, but highest per-lead value.

---

*Last reviewed: February 2026*
