# 01 — Context and Rules (Read First)

## 1) Domain primer (what the agent must know)
- **Radon** is a naturally occurring radioactive gas that can accumulate indoors. You only know your home’s level by testing.
- US guidance frequently references an **“action level”** where mitigation is recommended.
- **EPA radon “zones”** (Zone 1/2/3) are **area risk classifications** intended for planning/awareness and are commonly provided at **county** granularity. They are **not** a way to decide whether an individual home should test; the general guidance is that *all homes should test*, regardless of zone.

> Implementation implication: You can display zone as “local risk context” but **must not** present it as a definitive statement about the user’s home.

## 2) Product intent (what we optimize for)
We are not building a perfect quote engine. We are building a **decision + conversion engine**:
1) Explain what the user should do next (test / interpret / mitigate).
2) Provide a realistic **cost range** with transparent “what changes the cost”.
3) Capture a **high-quality, consented lead** and route it correctly.
4) **(NEW) Monetize Dead Ends:** If a user is not ready for mitigation (e.g., they haven't tested yet) or if we don't have a lead buyer in their area, we monetize via Affiliate Marketing (Radon Test Kits).

## 3) Hard rules (non-negotiable)
### R1 — Zone is NOT a pricing modifier
Do not add +20% just because Zone 1. That is not reliably causal. Zone is “risk context”, not “labor/material complexity”.

### R2 — County-first data model
Your canonical geography unit for radon zone is **county**.  
ZIP is allowed as a UX input, but it is resolved to a county via a crosswalk and must be treated as “best-effort mapping”.

### R3 — YMYL trust requirements
Every page that makes “health/safety” statements must:
- Cite sources (EPA, state health department pages, reputable cost guides).
- Avoid alarmist language.
- Include disclaimers.

### R4 — Lead consent and seller routing must be explicit and logged
- The user must explicitly agree to be contacted.
- If contacting specific “sellers” (local pros), the user must explicitly select them (or explicitly accept a “recommended seller”).
- Store consent logs (Append to static auditable file).

### R5 — “Qualified professional” positioning
The site should encourage users to hire qualified professionals and must not imply the site is itself a certified mitigation provider unless it is.

## 4) Definitions
- **County page**: a landing page for a county in a state.
- **Pillar page**: Highly authoritative informational pages (e.g., "Active vs Passive Systems") that state/county pages link back to.
- **Estimator**: the interactive component that accepts inputs and returns a range.
- **Seller**: a service provider or a lead buyer.
- **Affiliate Fallback**: Amazon/ShareASale link for Radon DIY Test kits.

## 5) Key assumptions (explicit)
- We can reliably fetch county-level zone classifications from EPA sources.
- We will use reputable cost sources to define a **base range** stored in a config file.

## 6) Guardrail copy blocks (must exist on site)
### Health / safety disclaimer (short)
“Information on this site is for educational purposes and is not medical advice. For health concerns, consult qualified professionals.”

### Estimate disclaimer (short)
“Estimates are general ranges based on typical projects. Actual quotes vary by home conditions and local labor.”

### Zone disclaimer (short)
“Radon zone classifications describe regional potential for elevated indoor radon. They do not predict the radon level in a specific home. Testing is recommended for all homes.”

## 7) Source list (for implementation)
Put these in a “Sources & Methodology” block in the UI and keep them updated:
- EPA radon action level / what it means
- EPA radon zones map / definitions
- State radon program links (by state page)
- One or more reputable cost guides (Angi, Home Advisor, etc.)
