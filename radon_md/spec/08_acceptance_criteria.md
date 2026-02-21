# 08 — Acceptance Criteria (Definition of Done)

## A) Content and trust
- [ ] Every county page contains:
  - [ ] zone context + zone disclaimer
  - [ ] EPA action box
  - [ ] estimator module
  - [ ] FAQ + sources/methodology module
- [ ] Sources are visible and include EPA + at least 1 cost guide
- [ ] No page claims a specific home’s radon level based on zone

## B) Estimator correctness
- [ ] Given fixed inputs, estimator outputs stable range (no randomness)
- [ ] Zone changes do not change pricing (unit test exists)
- [ ] Output always includes:
  - [ ] range + average
  - [ ] 3+ explanation bullets
  - [ ] disclaimers

## C) Lead capture + routing
- [ ] Lead form cannot submit without explicit consent
- [ ] Consent event is logged with IP, UA, timestamp, text, version, selected seller IDs
- [ ] Lead is delivered ONLY to user-selected seller(s)
- [ ] Dedupe prevents double-send (lead_id + seller_id uniqueness)
- [ ] Basic spam prevention present (rate limit at minimum)

## D) SEO basics
- [ ] Canonicals are correct (county canonical)
- [ ] Breadcrumbs exist
- [ ] Robots/sitemaps configured
- [ ] No index bloat from ZIP duplicates

## E) Observability
- [ ] Key events tracked (page view, estimator submit, lead submit)
- [ ] Admin/report view exists (at least DB queries) for:
  - submitted leads by day
  - delivery status breakdown

## F) Policies
- [ ] Privacy policy page exists
- [ ] Terms page exists
- [ ] Contact page exists
