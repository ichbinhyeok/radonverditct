# Design System — RadonVerdict

## Product Context

- **What this is:** A guided web tool that helps US homeowners set up, document, and check the procedural validity of a radon test.
- **Who it is for:** Homeowners, renters, buyers, and sellers who need to run or verify a home radon test without pretending a county average can diagnose the property.
- **Space:** Consumer home testing, public-health guidance, and evidence-backed decision support.
- **Product type:** Guided web app with a restrained editorial landing page and supporting evidence library.

## Visual Thesis

RadonVerdict should feel like a calm field record: warm paper, dark ink, disciplined rules, and one fresh signal color that makes the next action unmistakable.

## Content Plan

1. **Hero:** State the job, show the real testing context, and start the planner.
2. **Support:** Explain that test conditions come before result interpretation.
3. **Detail:** Show the short workflow and the official-source boundary.
4. **Final action:** Start or resume a test record.

## Interaction Thesis

- The landing hero enters as a single composed scene, not a set of floating UI cards.
- The planner advances one question at a time with a short horizontal transition and persistent progress.
- Interactive choices respond through border, fill, and type weight; motion never carries meaning alone and respects reduced-motion settings.

## Aesthetic Direction

- **Direction:** Editorial utility / field notebook.
- **Decoration:** Intentional and restrained: fine rules, record stamps, measured blocks, no decorative gradients.
- **Mood:** Independent, calm, exact, and practical. Never clinical, frightening, or contractor-like.
- **References:** GOV.UK one-question-per-page service patterns; consumer testing records; official CDC/EPA guidance.

## Typography

- **Display:** Fraunces — a human editorial face that distinguishes the product from generic health and contractor sites.
- **Body/UI/Data:** Source Sans 3 — highly legible for instructions, form controls, and tabular numbers.
- **Loading:** Google Fonts with preconnect; system fallbacks remain available.
- **Scale:** 12, 14, 16, 18, 24, 32, 48, and 72px, using fluid `clamp()` at the two largest sizes.

## Color

- **Paper:** `#F2EEE4` — main warm surface.
- **Paper light:** `#FBFAF6` — form and reading surface.
- **Ink:** `#142019` — primary text and dark planes.
- **Pine:** `#245542` — links, focus, evidence, and calm positive states.
- **Signal:** `#DDF56B` — primary action only.
- **Rule:** `#CFC8B8` — separators and neutral borders.
- **Muted:** `#657168` — secondary text.
- **Warning:** `#A85D18`; **error:** `#A43D32`; **info:** `#2E6584`.
- Color does not label a radon result as safe or unsafe. Status always includes text.

## Spacing and Layout

- **Base unit:** 4px with an 8px working rhythm.
- **Density:** Comfortable in the planner; spacious on the landing page.
- **Layout:** Hybrid. Full-bleed editorial landing sections; disciplined single-task planner.
- **Grid:** 4 columns mobile, 8 tablet, 12 desktop.
- **Max width:** 1200px marketing, 760px question surface, 920px record output.
- **Radii:** 4px small, 8px controls, 16px major interactive regions. Avoid uniform bubbly cards.

## Product Rules

- Ask one primary question per step.
- Keep source and scope language adjacent to any procedural assessment.
- Say `procedurally consistent`, `possibly compromised`, or `retest recommended`; never `safe home`.
- State and device instructions override general guidance.
- Offer state or local free/discount kit sources before affiliate products.
- Preserve unfinished records locally without requiring an account.

## Decisions Log

| Date | Decision | Rationale |
|---|---|---|
| 2026-09-05 | Replace the county/result-led experience with a test setup and validity workflow | This is the strongest fit with historic search evidence and the no-expert constraint. |
| 2026-09-05 | Use editorial utility rather than medical blue or contractor visuals | The product organizes evidence; it does not diagnose health or sell mitigation. |
| 2026-09-05 | Use one signal color and two typefaces | Strong hierarchy without generic SaaS decoration or visual noise. |

