# 09 — Task Breakdown (Execution Order)

This plan is written to be executed top-to-bottom for a **Java / Spring Boot DB-less** environment, integrating the "Super pSEO" and "Itemized Receipt Layer" strategy.

> **Last Updated: 2026-02-21 15:05 KST**

---

## 0) Project Scaffolding — ✅ DONE
- [x] Initialize Spring Boot project (Web, Lombok, JTE)
- [x] Add JTE Gradle plugin (`gg.jte.gradle:3.2.0`) and dependencies
- [x] Configure `application.properties` (`gg.jte.developmentMode=true`)
- [x] Delete legacy `HomeController.java` (conflicting `/` route)
- [x] Verify `./gradlew test` passes clean

## 1) Data Layer (Static Files ETL) — ✅ DONE
- [x] Parse EPA zones → `epa_county_radon_zones.json`
- [x] Parse Census data → `geo_counties.json` (~3,200 counties)
- [x] Process HUD crosswalk → `zip_primary_county.json` (~41,000 ZIPs)
- [x] Create `reference_sources.json`
- [x] Create `pricing_config.json` (itemized components, foundation modifiers, 51 regional multipliers)
- [x] Create `content_templates.json` (Zone 4종 × Intent 3종 × Foundation 4종 서술 텍스트)
- [x] Create `state_regulations.json` (**50개 주 + DC 전체** 공개의무/면허/프로그램URL)
- [x] Create `faq_templates.json` (Zone별 + State Disclosure별 + Universal FAQ 풀)

## 2) In-Memory Data Load — ✅ DONE
- [x] `DataLoadService.java` — `@PostConstruct`로 모든 JSON을 `Map<>` 인메모리 적재
- [x] DTO 클래스: `GeoCountyDto`, `EpaZoneDto`, `County`, `PricingConfig`, `ContentTemplates`, `StateRegulations`, `FaqTemplates`
- [x] GeoCounty + EPA Zone 병합 → `County` 객체 (FIPS 키 + slug 키 이중 맵)
- [x] 시작 시 파일 누락/파싱 실패하면 `RuntimeException`으로 즉시 실패 (Fail-fast)

## 3) Core Estimator Engine — ✅ DONE
- [x] `PricingCalculatorService.java` 구현
- [x] 수식: `Materials + Permits + (Labor_Base + Foundation_Modifier) × Regional_Multiplier`
- [x] Sanity Bounds 적용 (min $600, max $4,500)
- [x] ZIP 기반 계산 (`PricingRequest` → FIPS 역조회 → State → 가중치)
- [x] Fallback: 알 수 없는 ZIP → 전국 평균 리턴
- [x] ~~하드코딩 negotiationAdvice~~ → **삭제** (ContentGenerationService가 담당)
- [x] JUnit 테스트 통과: NY 1.25x 가중치 계산 검증 + No-Zone 동일가격 보장

## 4) Anti-Thin-Content Engine — ✅ DONE
- [x] `ContentGenerationService.java` — 4축 분기로 고유 콘텐츠 자동 조립
  - 축1: **EPA Zone** (1/2/3/Unknown) → 위험도 서술, 바이어 경고, 셀러 조언, 홈오너 가이드
  - 축2: **State 규제** (51개 → 공개의무 유/무, 면허 요건, 프로그램 URL)
  - 축3: **User Intent** (Buying/Selling/Homeowner) → 네고 가이드, 단계별 행동 방침
  - 축4: **Foundation Type** (Basement/Crawl/Slab/Other) → 비용 맥락, 견적 주의사항
- [x] `CountyPageContent.java` DTO — 모든 렌더링 데이터 단일 객체로 조립
- [x] 동적 FAQ 생성 (`buildFaqs`):
  - Zone별 FAQ (2~3개)
  - State Disclosure 여부별 FAQ (2개)  ← **People Also Ask 점령용**
  - Universal FAQ (6개)
  - 총 **10~11개 고유 FAQ** per 카운티
- [x] `buildContext()` 헬퍼: `{countyName}`, `${totalAvg}` 등 플레이스홀더 일괄 치환
- [x] `addFaqPool()` 헬퍼: FAQ 풀 추가 로직 DRY 원칙 적용

## 5) Routing & SEO/AEO Controllers — ✅ DONE
- [x] `PageController.java` 구현
- [x] `GET /` → redirect `/radon-cost-calculator`
- [x] `GET /radon-cost-calculator` → 글로벌 계산기 (National Average)
- [x] `GET /radon-mitigation-cost/{stateSlug}` → State Hub (유효성 검증 + 404)
- [x] `GET /radon-mitigation-cost/{stateSlug}/{countySlug}` → **카운티 SEO 페이지** (`ContentGenerationService` 연동)
- [x] `POST /htmx/calculate-receipt` → HTMX 동적 영수증 Fragment 리턴

---

## 6) Frontend UI (JTE Templates) & Interactive Layer — 🔲 TODO (다음 단계)
- [ ] `layout.jte` — 레이아웃 뼈대 (SEO 메타태그, JSON-LD, HTMX/Alpine CDN)
- [ ] `county_hub.jte` — **카운티 SEO 랜딩 페이지**
  - [ ] 상단: 정적 영수증 테이블 (AEO용, HTML `<table>`)
  - [ ] 중단: HTMX 시뮬레이터 폼 (Foundation + Intent 선택)
  - [ ] 하단: 동적 FAQ (Schema.org `FAQPage` 마크업)
  - [ ] State 규제 배너 (공개의무 유/무에 따라 다른 UI)
- [ ] `fragments/receipt.jte` — HTMX가 리턴하는 영수증 조각
- [ ] `calculator.jte` — 글로벌 계산기 페이지
- [ ] `state_hub.jte` — State별 카운티 목록 허브
- [ ] CSS/디자인 시스템 (신뢰감 있는 컬러 팔레트)

## 7) Lead Pipeline (Monetization) — 🔲 TODO (트래픽 확보 후)
- [ ] Lead form UI ("Get Free Local Quotes for Negotiation" CTA)
- [ ] `@PostMapping /api/lead` 엔드포인트
- [ ] Dedupe Cache (Caffeine TTL)
- [ ] `consent_audit.csv` 로깅 (TCPA Compliance)
- [ ] `JavaMailSender` 즉시 알림

## 8) Admin & SEO Plumbing — 🔲 TODO
- [ ] Dynamic `sitemap.xml` (3,000+ county URLs)
- [ ] `robots.txt` + canonical tags
- [ ] Schema.org (`FAQPage`, `Dataset`) JSON-LD 주입
- [ ] `/admin/stats` 대시보드

## 9) QA & Launch Validation — 🔲 TODO
- [ ] `08_acceptance_criteria.md` 기준 감사
- [ ] Mobile UX 테스트 (Receipt/Simulator)
- [ ] Lighthouse 90+ (Mobile)
- [ ] Google Search Console 제출

---

### 📊 진행률 요약

| 단계 | 상태 | 비고 |
|---|---|---|
| 0. Scaffolding | ✅ | Gradle + JTE + Lombok |
| 1. Data ETL | ✅ | 8개 JSON, 50개주+DC 커버 |
| 2. In-Memory Load | ✅ | 9개 데이터소스 인메모리 |
| 3. Estimator Engine | ✅ | 수식 + 테스트 통과 |
| 4. Anti-Thin-Content | ✅ | 4축 분기, 하드코딩 0 |
| 5. Routing/Controller | ✅ | HTMX 엔드포인트 포함 |
| 6. Frontend UI | 🔲 | **다음 단계** |
| 7. Lead Pipeline | 🔲 | 트래픽 후 |
| 8. SEO Plumbing | 🔲 | Sitemap, Schema |
| 9. QA & Launch | 🔲 | 최종 검증 |

**백엔드 완성도: 100% → 프론트엔드 진입 준비 완료**
