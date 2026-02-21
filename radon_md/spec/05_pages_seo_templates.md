# 05 — Pages, SEO, AEO, and Templates

## 1) URL structure (county-first)
- Home / calculator:
  - `/radon-cost-calculator`
- State hub:
  - `/radon-mitigation-cost/{state}`  
  - Example: `/radon-mitigation-cost/oh`
- County hub (canonical SEO unit):
  - `/radon-mitigation-cost/{state}/{countySlug}`
  - Example: `/radon-mitigation-cost/oh/franklin-county`

## 2) SERP & AEO (Answer Engine Optimization) Strategy
To dominate both Google Search (SERP) and AI Overviews/ChatGPT (AEO), the content must be highly structured, factual, and easily extractable.

### AEO Key Tactics
1. **Direct Answer Paragraph (Featured Snippet / AI Hook)**: 
   - Right below the H1, provide a 40-50 word direct answer. 
   - *Example:* "The average cost for radon mitigation in {County}, {State} ranges from **$800 to $1,500**, with a typical average of **$1,100**. This cost primarily depends on your home's foundation type, the complexity of pipe routing, and whether active suction is required."
2. **Itemized Receipt Table (CRITICAL FOR AI CRAWLERS)**: AI models love pulling from HTML tables.
   - We must include a clean `<table class="cost-table">` that breaks down the local estimate into Materials, Labor (using our state multiplier), and Permits.
3. **Information Density**: Do not use "fluff". Write dense, factual bullet points.

### SERP Key Tactics
1. **Title Tags (Constraint: < 60 chars)**: 
   - `Cost of Radon Mitigation in {County}, {State} 2026`
2. **Meta Descriptions (< 155 chars)**:
   - `Find out the exact cost to install a radon mitigation system in {County}, {State}. Compare estimates based on basement, slab, and crawlspace foundations.`
3. **Heading Hierarchy**: STRICT `H1 -> H2 -> H3` structure without skipping levels.

## 3) Page modules (render order)
Every county page must include these modules to satisfy User Intent and SEO:

1) **Hero + Local context (H1)**
   - “Radon Mitigation Cost in {County}, {State}”
   - **[AEO Hook]** The direct answer paragraph summarizing the average default cost.
   - Show EPA zone label as *context only* + zone disclaimer.

2) **Interactive Estimator & Negotiation Tool (The Moat)**
   - Inputs: Intent (Buying/Selling/Living), Foundation, Home type.
   - Outputs: Dynamically generated **Itemized Receipt** and **Negotiation Advice Container**.

3) **Local Cost Breakdown (H2)**
   - **[SERP/AEO Hook]** A static (default) table showing the baseline itemized breakdown for the county. This ensures crawlers see the data even without interacting with the JS calculator.

4) **What to do with High Radon (H2)**
   - Intent targeted content based on the user's situation (Buyer vs Seller).
   - EPA guidance (4.0+ consider mitigation).

5) **Hire a qualified professional (H2)**
   - CTAs linking to Lead Gen form or State EPA lists.

6) **FAQ (H2) - Crucial for "People Also Ask"**
   - 5–10 Q/A (e.g., "Who pays for radon mitigation in {County}?")
   - Must use `FAQPage` Schema.

7) **Sources & Methodology (H2)**
   - list citations: EPA action level, EPA zone map, cost guides.
   - include last-updated date (vital for YMYL freshness).

## 4) Structured data (schema.org)
Implement these via JSON-LD in the `<head>`:
- **`FAQPage`**: For the FAQ section. (Guarantees higher SERP real estate).
- **`Dataset` (Optional but powerful)**: If you list the average costs/ranges for the county, marking it up as a dataset makes it very attractive for AEO.
- **`BreadcrumbList`**: state → county navigation.
- Avoid: `LocalBusiness` schema unless you are actually a business offering services.

## 5) Canonicals and duplicates
- County pages are the canonical entities.
- ZIP codes should merely redirect or resolve to the County page. Do NOT make 30,000 ZIP code pages, as Google will hit you with a "Crawled - currently not indexed" soft penalty for thin/duplicate content.

## 6) Example page outline (markdown-like)
```md
# Radon Mitigation Cost in {County} County, {State}

**Quick Answer:** The average cost to install a radon system in {County} is between **${base_low} and ${base_high}**. Costs vary significantly based on the foundation type and local labor rates.

[Zone context badge] Zone {epa_zone} — {zone_label}

## Calculate Your Exact Cost & Negotiation Strategy
[Interactive React/Vue Component: Asks Intent -> Outputs Itemized Receipt & Buyer/Seller Advice]

## Average Local Cost Breakdown
| Component | Average Range |
|-----------|---------------|
| Materials | $X - $Y |
| Local Labor | $X - $Y |
| Permits/Setup | $X - $Y |
| **Total** | **$X - $Y** |

## Who Pays for Radon Mitigation? (Buyer vs. Seller)
...

## FAQ
Q: Do I need mitigation if I live in Zone 3?
A: ...

Q: Can I ask the seller for a closing credit for radon?
A: ...
```
