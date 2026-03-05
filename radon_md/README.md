# Radon Mitigation Cost Estimator ??Agent-Ready Spec (v3.1 DB-less)

**Date:** 2026-02-21 (Asia/Seoul)  
**Purpose:** This folder is a self-contained specification for building a US-focused **Radon Mitigation System Cost Estimator** website with **lead-generation (CPL/CPA)** monetization.  
It is written so an implementation agent can start coding immediately **without extra verbal context**.

## What you are building (1 sentence)
A county-first, evidence-cited **radon mitigation cost estimator** that explains the EPA action threshold, estimates a realistic cost range based on home structure, and captures **consented, high-quality leads** routed to qualified local professionals.

## What makes this spec different
This spec intentionally avoids common failure modes for this niche:
- **Do NOT** use ?œEPA Zone ??price surcharge??logic.
- **Do NOT** treat ZIP-level zone as authoritative; EPA zone is fundamentally county-level.
- **Do NOT** distribute leads to multiple sellers without explicit, logged consent per seller selection (TCPA risk).
- **Do** make pages deep enough for YMYL trust (sources, methodology, disclaimers).

## File map
- `spec/00_strategy.md` ??**READ FIRST** ??market strategy, competitive rationale, keyword tiers, monetization roadmap
- `spec/01_context_and_rules.md` ??domain primer + hard rules + assumptions
- `spec/02_data_sources_and_etl.md` ??datasets, fields, ETL steps, update cadence
- `spec/03_db_schema.md` ??suggested DB-less (In-memory) data structures + static files
- `spec/04_pricing_engine.md` ??estimation model, inputs/outputs, explanation strings, tests
- `spec/05_pages_seo_templates.md` ??URL structure, templates, schema markup, internal linking
- `spec/06_leads_consent_routing.md` ??lead form spec, consent logging, routing, compliance guardrails
- `spec/07_analytics_kpis.md` ??events, funnels, reporting metrics
- `spec/08_acceptance_criteria.md` ??definition of done, QA checklist
- `spec/09_task_breakdown.md` ??implementation task list in execution order
- `ops/context_tracker.md` ??ongoing context log (daily snapshot, what changed, and verification)

## Recommended default stack (Java DB-less)
- Frontend/SSR: **Java (Spring Boot) + JTE Templates**
- Data Storage: **DB-less (In-memory `Map` + Static JSON/CSV files loading at startup)**
- Audit/Log: Append-only local CSV files or Webhook to external BaaS
- Caching/Dedupe: **In-memory cache (e.g., Caffeine/Guava)**
- Hosting: Any VPS or PaaS compatible with Java

## Legal / medical disclaimer
This project touches a health-adjacent topic (radon). Provide clear disclaimers:
- The site is informational, not medical advice.
- The estimator is educational; real pricing depends on site conditions.
- For compliance (TCPA, state licensing), consult a qualified attorney and follow local rules.

Start here: `spec/01_context_and_rules.md`.
