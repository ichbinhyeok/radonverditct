# RadonVerdict Next.js 전환 — 증거 기반 구조 복구 명세

상태: Superseded by `14_handoff_product_pivot.md`  
작성일: 2026-07-31  
이 문서는 `12_radonverdict_2_refactor.md`의 **스택·URL·실행 순서를 대체**한다.

## 1. 최종 판정

RadonVerdict는 살린다. 그러나 기존 Spring/JTE 화면을 React로 번역하지 않는다.

목표 런타임은 **Next.js + React + strict TypeScript**다. 기존 Spring 애플리케이션은 새 제품의 원형이 아니라, URL을 보존하고 결과 차이를 검증하기 위한 임시 legacy runtime으로만 사용한다.

두 작업을 분리한다.

1. **제품 검증 트랙:** noindex `/plan`과 inspector share를 만들어 실제 사용을 검증한다.
2. **검색 자산 이관 트랙:** 검색 승자 URL은 path와 canonical을 유지한 채 Next.js로 옮긴다.

플랫폼 전환과 URL 개편을 같은 배포에서 하지 않는다.

## 2. 증명된 사실

| 사실 | 증거 | 결정 |
|---|---|---|
| 2026-04-02~05-01 검색 성과는 261 clicks / 23,290 impressions / 평균 7.42였다. | 제품·SEO 감사 | 검색 자산은 실재한다. |
| 2026-05-02~05-31에는 2 / 391 / 32.88로 붕괴했다. | 제품·SEO 감사 | 회복 전 대량 URL 확장은 금지한다. |
| `radon-levels`는 91 clicks / 6,416 impressions였다. | GSC 집계 | levels/testing이 검증된 획득 수요다. |
| `radon-mitigation-cost`는 8 clicks / 3,440 impressions였다. | GSC 집계 | cost를 핵심 제품으로 보지 않는다. |
| 생성 county page는 3,126개, 평균 3,549.83단어, 평균 Jaccard 84.54%였다. | rendered audit | 생성형 장문 구조를 폐기한다. |
| 로컬 telemetry 6,650행은 모두 loopback IP다. | `data/telemetry_events.csv` | 제품 행동 baseline으로 사용하지 않는다. |
| lead 2건, contact 3건, quote 1건은 QA/example.com 데이터다. | `data/*.csv` | 전환·매출·제품 수요 증거는 현재 0이다. |
| inspector outreach 후보는 15명이지만 발송은 0건이다. | outreach data | inspector는 검증된 채널이 아니라 실험이다. |
| 현재 배포는 ARM64 단일 Spring container, memory limit 512MB다. | `.github/workflows/deploy.yml` | 두 runtime 동시 운영 가능성을 확인 전 가정하지 않는다. |
| 배포 image가 immutable SHA가 아니라 `latest`다. | `.github/workflows/deploy.yml` | 먼저 rollback 가능한 배포로 고친다. |

## 3. 자산 원장

### 무조건 살린다

| 자산 | 방식 | 새 위치·용도 |
|---|---|---|
| `radonverdict.com` | KEEP | 동일 브랜드와 canonical host |
| `/radon-levels` 및 검색 생존 county URL | KEEP SAME PATH | Next에서 동일 200/canonical로 재구축 |
| 클릭 이력이 있는 cost URL 5개 | QUARANTINE URL | path는 유지하고 현재 가격 주장은 제거 |
| `geo_counties.json` | PORT | `packages/data/raw/geo-counties.json` |
| `epa_county_radon_zones.json` | PORT | 공식 지역 맥락 |
| `county_radon_measurements.json` | PORT | typed evidence input |
| `county_radon_tiers.json` | PORT | tier evidence; average로 표현 금지 |
| `radon_measurement_sources.json`과 ETL scripts | PORT | source registry + ingest contracts |
| ZIP→FIPS 40,965 mapping | PORT WITH LIMIT | primary county 한계를 명시하고 full crosswalk 확보 전 ambiguous를 추론하지 않음 |
| 지역명·FIPS·slug 예외 규칙 | PORT | pure TypeScript location domain |
| legacy route/canonical 테스트 시나리오 | PORT AS FIXTURE | HTML 문구가 아니라 URL contract 보존 |
| inspector demo의 시각 언어·핵심 문장 | PORT AS DESIGN SOURCE | 실제 제품 shell로 사용 |
| quote coach의 질문·통화 script | PORT AFTER EDIT | 가격 예측이 아닌 action tool |

### 논리만 추출하고 코드는 다시 쓴다

| 자산 | 살릴 것 | 버릴 것 |
|---|---|---|
| `CountyRadonEvidenceService` | source shape, missing/high-end/tier 구분 | 1,046줄 서비스와 문장 생성 결합 |
| EPA reading band | 공식 검증된 decision table | controller/template별 중복 구현 |
| `SearchDemandService` | query/page evidence | runtime 제품 로직 |
| telemetry | event taxonomy 아이디어 | 현재 CSV와 synthetic baseline |
| 100-user E2E | persona와 경계 시나리오 | JTE selector와 문구 assertion |

### 격리한다

- `PricingCalculatorService`
- `pricing_config.json`
- `county_stats.json`의 가격·집 조건 추정 사용
- `QuoteLedgerService`의 가상 누적 신호
- inspector packet/demo의 검증되지 않은 제품 주장
- 기존 guide 문서: 출처·날짜·의학 표현의 사람 검토 전까지 미이식

### 이관 후 폐기한다

- JTE와 기존 CSS/UI
- `ContentGenerationService`
- `content_templates.json`, `faq_templates.json`
- `PageQualityService`, `SimilarityEngineService`
- `InternalLinkService`
- 현재 hard-coded `SeoIndexingPolicyService`
- `wordCount > 1500`, FAQ 수, 느슨한 similarity를 품질로 보는 테스트
- 평문 CSV 기반 lead/contact/quote/telemetry 저장
- 근거 없는 `local average`, `estimated local price` 문구

## 4. 현재 P0 결함

React 화면을 만들기 전에 새 계약에서 아래를 재현 불가 상태로 만든다.

1. invalid 또는 missing reading이 `above_4`로 변환된다.
2. unknown ZIP이 global price로 조용히 fallback한다.
3. county credit 화면이 입력 없는 foundation과 sqft를 추정한다.
4. ZIP 하나당 primary FIPS 하나만 저장해 ambiguity가 소실된다.
5. 기본 관리자 credential이 코드 설정에 남아 있다.
6. CSRF가 전역 비활성화돼 있다.
7. telemetry·lead·quote가 IP, UA와 입력값을 평문 CSV로 저장한다.
8. 배포가 mutable `latest` tag라 확정적 rollback이 어렵다.

## 5. 새 제품 계약

```ts
type LocationResolution =
  | { kind: "resolved"; zip: string; countyFips: string }
  | { kind: "ambiguous"; zip: string; candidates: CountyRef[] }
  | { kind: "not_found"; zip: string };

type PlanningCost =
  | {
      kind: "available";
      range: MoneyRange;
      explicitInputs: ExplicitHomeInput[];
      assumptions: ExplicitAssumption[];
      evidenceType: "observed_quotes" | "published_reference" | "planning_model";
      modelVersion: string;
    }
  | {
      kind: "unavailable";
      reason: "missing_home_inputs" | "no_supported_model" | "invalid_location";
    };

type DecisionResult = {
  schemaVersion: 1;
  decisionVersion: string;
  dataVersion: string;
  verdict: Verdict;
  primaryAction: Action;
  secondaryActions: readonly Action[];
  evidence: EvidenceResult;
  cost: PlanningCost;
};
```

`unknown`, `not_tested`, `invalid`는 절대로 `4.0+`나 임의 가격으로 변환하지 않는다.

Evidence record는 최소한 다음을 가진다.

```text
evidenceType, geography, statistic, unit, period,
sampleSize, suppressionRule, sourceUri,
publishedAt, retrievedAt, datasetVersionHash
```

## 6. 목표 구조

```text
radonVerdict/
├─ apps/
│  ├─ web/
│  │  ├─ app/
│  │  │  ├─ page.tsx
│  │  │  ├─ plan/page.tsx
│  │  │  ├─ plan/share/[token]/page.tsx
│  │  │  ├─ radon-levels/[state]/[county]/page.tsx
│  │  │  ├─ guides/[slug]/page.tsx
│  │  │  ├─ for-home-inspectors/page.tsx
│  │  │  ├─ sitemap.ts
│  │  │  └─ robots.ts
│  │  ├─ components/
│  │  └─ server/
│  └─ legacy-spring/
├─ packages/
│  ├─ contracts/
│  ├─ domain/
│  │  ├─ decision/
│  │  ├─ evidence/
│  │  ├─ location/
│  │  └─ pricing/
│  ├─ data/
│  │  ├─ raw/
│  │  ├─ generated/
│  │  └─ schemas/
│  ├─ publishing/
│  │  ├─ manifest/
│  │  ├─ redirects/
│  │  └─ index-policy/
│  ├─ analytics/
│  └─ test-fixtures/
└─ infra/
   ├─ docker/
   └─ routing/
```

`packages/domain`은 React, Next, DB, telemetry를 import하지 않는다. Server Components를 기본으로 쓰고 실제 입력·복사·공유 상호작용만 client component로 만든다.

## 7. 최소 측정 가능 제품

화면은 네 개다.

```text
Home
 reading + ZIP + living/buying/selling
        ↓
Plan
 verdict → primary action → local evidence
 optional planning assumptions → copy/share
        ↓
Shared plan
 같은 DecisionResult의 read-only snapshot
        ↑
Inspector creator
 input → preview → create/copy link
```

v1에서 제외:

- 계정과 dashboard
- contractor marketplace
- PDF/email 자동화
- 독립 cost/credit product
- 전면 design system
- county 대량 발행

Inspector v1 문구는 사실만 말한다.

> No name, street address, email, or inspection report required. The shared plan contains the reading, ZIP, and situation you choose.

inspector 이름은 verified registry 전에는 임의 표시하지 않는다.

## 8. 측정 계약

기존 telemetry는 baseline에서 제외하고 새로 시작한다.

```text
inspector_landing_view
share_created
share_copy_succeeded
client_share_opened
plan_completed
handoff_action_copied
```

- event allowlist와 schema version
- opaque source/share ID
- idempotency와 bot/internal filtering
- payload limit과 rate limit
- IP 원문 저장 금지
- durable sink

초기 inspector 실험:

- 검증된 inspector 10–15명에게 수동 발송
- 최소 5명 share 생성
- 최소 3개 client open
- 최소 2명이 30일 안에 두 번째 share 생성

반복 사용이 없으면 inspector는 distribution product가 아니다.

## 9. 검색 자산 이관 계약

플랫폼 이관 1단계에서 유지:

- `/radon-levels`
- recovery cohort 13개
- `GSC_SURVIVOR_COUNTIES`의 기존 levels URL
- 클릭 이력이 있는 cost URL 5개
- `search_demand_seeds.csv`의 query/page 조합
- guides 중 실제 traffic/backlink가 확인된 기존 slug

상태 머신:

```text
LEGACY_SERVE
  → NEXT_SHADOW
  → CANARY_302
  → NEXT_SAME_PATH_200

실패 → LEGACY_SERVE
대체 가치 없음 → 별도 검토 후 GONE_410
```

이번 단계에는 `/radon-levels/...`를 `/radon/...`으로 바꾸지 않는다. URL 변경은 검색 회복 후 별도 실험이다.

각 URL 원장은 다음을 기록한다.

```text
path, primary query, historic clicks/impressions,
current indexability, backlinks known/unknown,
content source, evidence version, target runtime,
canonical, migration state, activated_at
```

## 10. Share 보안 계약

- 128-bit 이상 opaque random token
- DB에는 token hash 저장
- expiry, revocation, key rotation
- `Cache-Control: private, no-store`
- `X-Robots-Tag: noindex, noarchive, nofollow`
- `Referrer-Policy: no-referrer`
- client name, address, email, report 저장 금지
- `decisionVersion`, `dataVersion`, 생성 당시 result snapshot 저장
- 오래된 link는 자동 재계산하지 않고 생성 당시 결과와 최신 기준을 구분
- enumeration rate limit과 audit

## 11. 인프라 결정 gate

현재 저장소만으로 확인되지 않은 것:

- OCI 전체 RAM/CPU 여유
- reverse proxy 또는 Cloudflare path routing 권한
- DNS/TLS 종료 지점
- 운영 CSV의 실제 데이터와 보존 의무

확인 결과에 따라 둘 중 하나를 택한다.

### Route strangler 가능

- edge/router에서 path별 Spring/Next 분기
- Next와 legacy 각각 immutable SHA image
- 독립 health check와 routing manifest rollback

### Route strangler 불가능

- Next는 별도 noindex preview origin에서 검증
- legacy/New dual-run fixture 통과
- 같은 public URL contract를 유지한 단일 cutover
- 직전 SHA image로 즉시 rollback

두 runtime을 현재 512MB container 안에 억지로 넣지 않는다.

## 12. 실행 순서

### Phase 0 — 증거와 안전

- 현재 운영 image를 immutable SHA로 고정
- default credential 제거·회전
- CSRF/origin 정책 복구
- 운영 CSV 존재·보존 의무 확인
- GSC 전체 page+query export 확보
- Manual Actions / Security Issues 확인
- GA4에서 internal/test traffic 제거한 export 확보
- server/CDN log와 2026-05-01~05-07 deploy 기록 확보
- backlink export 확보
- OCI capacity와 edge routing 확인

### Phase 1 — Characterization contracts

- 기존 URL/canonical/status snapshot
- legacy decision 결과 fixture
- invalid reading, unknown ZIP, inferred input 버그를 regression fixture로 기록
- data file hash와 schema validation
- 새 TypeScript discriminated union 계약

### Phase 2 — Pure TypeScript core

- `location`
- `decision`
- `evidence`
- `pricing`은 기본 `unavailable`
- manifest validator
- domain matrix tests

### Phase 3 — Noindex product slice

- Home
- Plan
- Shared plan
- Inspector creator
- 여섯 개 analytics event
- share security contract

완료 조건: 동일 입력·동일 version 결과가 화면과 share에서 완전히 동일하다.

### Phase 4 — 실제 inspector 검증

- 10–15명에게 수동 outreach
- 생성·복사 성공·client open·완료·반복 사용 관찰
- 반복 사용 없으면 B2B 확장 중단

### Phase 5 — Same-path SEO canary

- `/radon-levels` root
- 검색 이력이 있는 county 5개
- 같은 path/canonical/intent
- source semantics 사람 검토
- 4–8주 GSC와 server log 관찰

### Phase 6 — 선택적 확장

- 실제 지표가 개선된 page type만 cohort 확대
- cost는 실제 quote evidence가 생긴 지역만 재도입
- URL 통합은 이 단계 이후 별도 의사결정

## 13. 테스트 gate

### 수초

- `1.99`, `2.0`, `3.99`, `4.0`
- invalid, missing, negative, extreme, unit conversion
- location resolved/ambiguous/not-found
- explicit input 없으면 `Cost.Unavailable`
- source maximum을 average로 표현하지 않음
- 동일 input/version은 동일 result

### 수십 초

- manifest/route/canonical/sitemap/robots contract
- redirect loop/chain 0
- share expired/revoked/tampered
- 개인정보가 snapshot/event에 없음
- legacy/New 승인되지 않은 diff 0

### 별도 browser CI

- 대표 journey 8–12개
- 390×844 입력→plan→share
- clipboard 성공 event는 API 성공 후에만 전송
- keyboard, 200% zoom, screen reader error focus

## 14. 성공·중단 기준

제품 성공은 traffic이 아니라 다음으로 판단한다.

- 실제 plan completion
- share 생성 후 client open
- handoff action 사용
- inspector 30일 내 반복 share
- 동일 입력 결과 불일치 0

검색 성공은 별도로 판단한다.

- same-path canary의 index 유지
- canonical drift 0
- impressions/clicks 회복
- crawled-not-indexed 감소

90일 동안 실제 plan completion과 반복 inspector 사용이 없으면 B2B 제품 확장을 중단한다. 4–8주 same-path canary에서도 검색 신호가 개선되지 않으면 county cohort 확장을 중단한다.

## 15. 결정에 필요한 외부 사실

다음은 추론하지 않는다.

1. 전체 GSC page+query export
2. Search Console Manual Actions / Security Issues 상태
3. internal/test를 제외한 실제 GA4 export
4. 2026-05-01~05-07 deploy·uptime·CDN/server log
5. backlink/referring-domain export
6. OCI instance 사양과 실제 여유 memory
7. path routing을 제어하는 proxy/Cloudflare 설정
8. 실제 고객·매출·inspector 발송 결과
9. authoritative multi-county ZIP crosswalk

이 정보가 없어도 Phase 1–3의 로컬 구현은 시작할 수 있다. 다만 public routing, URL 삭제, 가격 공개, 제품 수요 주장은 이 정보 없이는 승인하지 않는다.

## 16. 첫 구현 묶음

첫 구현은 React hero가 아니다.

1. immutable deploy와 security blocker 제거
2. `packages/contracts`
3. data schema/hash validation
4. `location`과 `decision` pure TypeScript
5. Java characterization fixture → TS golden matrix
6. noindex `/plan` vertical slice

이 여섯 개가 통과한 다음에만 홈 디자인과 inspector share를 public preview에 올린다.
