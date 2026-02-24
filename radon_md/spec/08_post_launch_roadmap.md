# RadonVerdict - Post Launch 2-Month Roadmap (Deferred High-ROI Items)

This document tracks high-priority, high-ROI items that were intentionally deferred to prevent destabilizing the codebase right before the 2-month unattended deployment period.

## 1. Data Moat Expansion: Region-Specific Authority Links
- **Goal**: Further differentiate programmatic county pages from generic doorway pages by adding localized external authority signals.
- **Action**: Compile a `state_programs.json` file mapping all 50 states to their official Department of Health Radon Program websites and certified contractor directories. Inject these links dynamically into `county_hub.jte` under a "Local State Resources" section.
- **Why Deferred**: Requires significant manual ETL work and JSON schema updates, posing a moderate risk of causing template resolution errors right before launch.

## 2. Infrastructure: Admin Security & CRM Migration
- **Goal**: Move leads from local `leads.csv` to a robust, secure database and fortify the `/admin` portal.
- **Action**: Implement PostgreSQL/MySQL integration for `LeadService`. Enable Spring Security CSRF, add IP whitelisting for `/admin`, and potentially integrate a 3rd party CRM API (like HubSpot or a dedicated lead broker API, e.g., eLocal).
- **Why Deferred**: Major architectural change moving from flat files to an RDBMS. Overkill for zero day-1 traffic, but critical once organic traffic and lead volume scale.

## 3. CRO Optimization: 2-Step Lead Form (HTMX/AlpineJS)
- **Goal**: Increase the lead capture conversion rate.
- **Action**: Refactor `lead_form.jte` into a multi-step component. Step 1: ZIP Code and Intent ("Have you tested?"). Step 2: Name, Phone, and TCPA Consent Checkbox.
- **Why Deferred**: Requires significant AlpineJS/HTMX state management rework. Current single-step form is stable, functional, and already possesses honeypot spam protection.

## 4. TCPA Consent Compliance Hardening
- **Goal**: Ensure ironclad legal compliance for selling leads to broker networks.
- **Action**: Add explicit checkbox constraints and detailed opt-out legal verbiage. Store consent timestamps and exact verbiage shown to the user in the database.
- **Why Deferred**: Requires DB migration (Task 2) and deeper integration with specific broker requirements which are currently unapproved.

## 5. Next-Step Funnel Pages for Intent Mapping
- **Goal**: Increase conversion by providing specific landing pages for different user intents post-county page.
- **Action**: Create sub-routes like `/radon-mitigation-cost/{state}/{county}/next-steps-real-estate` containing negotiation scripts and specific CRM triggers.
- **Why Deferred**: Pushes the system from a pure calculator into a complex multi-touch funnel. Better to validate baseline traffic first.
