# 04 — Pricing Engine (Estimator & Negotiation Simulator) Spec & UX

## 1) Goal
Return a realistic, highly engaging **itemized cost breakdown** and **real estate negotiation advice** that is:
- **Defensible & Transparent:** Broken down into materials, labor, and setup rather than just a vague range.
- **Context-Aware:** Tailored to whether the user is buying, selling, or just living in the home.
- **Conversion-Optimized:** Delivers enough "Aha!" value to earn trust, then prompts the user to get a "Verified Local Quote" via the Lead Gen form.

## 2) UX Strategy: The "Interactive Receipt & Negotiation" Flow
We use a "Micro-Commitment" modal or multi-step wizard to build engagement, ending in a massive value reveal.

- **Step 1:** User lands on page. Static text shows regional average (e.g., "$1,100"). Call to action: "Get Itemized Estimate & Negotiation Guide".
- **Step 2 (Foundation):** Ask home setup (Basement, Crawlspace, Slab).
- **Step 3 (Context):** Ask: "What brings you here today?" 
  - [ ] I'm buying a home in escrow
  - [ ] I'm selling my home
  - [ ] I just want to fix my current home
- **Step 4 (Location):** Ask ZIP code.
- **Step 5 (The Reveal - The Receipt & Advice):** 
  - Show the **Itemized Cost Breakdown** (Materials, Labor, Permits).
  - Show the **Real Estate Negotiation Strategy** (if buying/selling).
  - Show the **Lead Gen Form**: "We found 2 certified pros in {county}. Compare exact quotes now."

## 3) Inputs (from UI Wizard)
Required:
- `foundation_type`: basement | crawlspace | slab | other
- `user_intent`: buying | selling | homeowner
Location:
- `zip` -> resolves to `county_fips` and `state_abbr`

## 4) Outputs
- **Cost Formulation:**
  - `materials_cost` (int USD)
  - `labor_cost` (int USD)
  - `permits_setup_cost` (int USD)
  - `total_low`, `total_high`, `total_avg` (Sum of the above with variance)
- **Contextual Outputs:**
  - `negotiation_advice` (String: Actionable advice based on `user_intent` and total cost)

## 5) Dynamic JSON-based Pricing Config
To keep maintenance low, the itemized pricing logic must be loaded from `pricing_config.json`. 

`pricing_config.json` Example:
```json
{
  "base_components": {
    "materials": { "low": 300, "high": 500 },
    "permits_setup": { "low": 100, "high": 250 }
  },
  "labor_base": { "low": 400, "high": 600 },
  "foundation_labor_modifiers": {
    "basement": {"low": 100, "high": 250},
    "crawlspace": {"low": 200, "high": 400},
    "slab": {"low": 50, "high": 150}
  }
}
```
*(Note: Final total is Materials + Setup + (Labor Base + Labor Modifier))*

## 6) Negotiation Logic (The Core Differentiator)
Based on `user_intent`:
- **If `buying`:** "As a buyer, do not ask the seller to do the work, as they will choose the cheapest, lowest-quality contractor. Instead, use this $X estimate to request a **Seller Credit (Closing Credit)** for the exact amount. This lets you hire a quality pro after you move in."
- **If `selling`:** "Buyers will likely demand a credit for radon mitigation. You can proactively install a system to market the home as 'Radon Safe', or offer an upfront credit of $X to prevent the buyer from walking away during inspection."
- **If `homeowner`:** Focus on health benefits and long-term property value increase.

## 7) No-zone pricing guarantee & Bounds
- Testing: Ensure that changing the `county` (Zone 1 vs Zone 3) yields identical pricing given the same house parameters. EPA Zones denote risk frequency, not mitigation cost.
- Bounds: Total estimate should safely fall between $600 and $4000.
