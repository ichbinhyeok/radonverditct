# 06 — Leads, Consent, Routing, and Compliance Guardrails

> This is not legal advice. The goal is to design conservatively to reduce risk.

## 1) Lead capture UX: high-quality by design
### Form placement
- Primary CTA after the estimate: “Get a local estimate”
- Optional inline micro-CTA: “Talk to a qualified pro”

### Form fields (recommended)
Required:
- First name
- Phone
- Email
- ZIP (or full address)
- Home foundation type (basement/crawlspace/slab)
Optional but high value:
- Tested? (yes/no)
- Radon level bucket (unknown / <2 / 2–4 / 4+)
- Preferred contact time window
- Home transaction status (Selling/Buying/None) - High value for pros

### Validation rules
- Phone normalization to E.164 (US) if possible.
- Email basic validation.
- ZIP must be 5 digits.
- Rate-limit submissions per IP.

## 2) Consent model: explicit + logged
### Consent UI requirements
- Checkbox must be unchecked by default.
- Consent text must be visible near the CTA.
- User must explicitly agree before submission.

### “Seller selection” requirement (risk control)
If the lead will be sent to specific sellers:
- The user must select the seller(s) they agree to be contacted by.
- Default pattern:
  - “We can connect you with a local radon professional. Select who may contact you: [Seller A] [Seller B] …”

### Consent logging (Must Append to File)
- **DB-less execution**: Append directly to `logs/consent_audit.csv`
- Store: `timestamp, ip_address, user_agent, consent_text, consent_version, selected_seller_ids, lead_id`

## 3) Routing logic
### Step 1: Resolve geography
- If user entered ZIP, resolve to primary county via in-memory mapping `zip_primary_county.json`.
- Attach `state_abbr`, `county_fips` to the active Lead Request payload.

### Step 2: Choose eligible sellers
Filter the loaded `sellers.json` list:
- active == true
- coverage includes `state_abbr`
- if seller has `county_fips` allowlist, ensure match.

### Step 3: Present sellers to user
- Show 1–3 sellers maximum to avoid choice overload.
- User must explicitly accept before submission.

### Step 4: Direct Deliver lead (No DB queue)
- Rather than queuing in a DB, dispatch the lead immediately via:
  - Email (using JavaMailSender directly to the seller)
  - Webhook POST (to a CRM)
- Append the delivery result to `logs/lead_deliveries.csv`.

## 4) Dedupe + fraud prevention
### Dedupe (In-Memory Validation)
- Compute `dedupe_hash`: `sha256(lower(email) + '|' + normalized_phone + '|' + county_fips)`
- Check against an in-memory **JVM cache** (e.g., Caffeine) structured with a 24-hour Time-To-Live (TTL).
- If hash exists -> block/ignore. If not -> proceed and put hash into cache.

### Abuse prevention
- hCaptcha/Turnstile
- In-memory IP rate limit cache

## 5) Required user-facing policies
- Privacy policy (PII handling)
- Terms of use
- Consent language for contact

## 6) Example consent text (template)
> By checking this box, I agree to be contacted by **{Selected Seller Names}** about radon mitigation services at the phone number or email I provided, including via calls or texts. I understand I can revoke consent at any time.
