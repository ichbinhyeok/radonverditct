# RadonVerdict — Result-to-Handoff Product Pivot

상태: SUPERSEDED — SEO 보조 기능으로 유지, `15_seo_recovery_pivot.md`가 현재 전략  
작성일: 2026-08-27  
기준 브랜치: `master`  
대체 문서: `12_radonverdict_2_refactor.md`, `13_nextjs_evidence_based_salvage.md`

## 1. 한 줄 결정

RadonVerdict를 county SEO·가격 추정 사이트에서 **라돈 결과를 검증 가능한 다음 행동과 개인정보 없는 공유 링크로 바꾸는 handoff product**로 전환한다.

Spring/JTE를 유지한다. 문제는 프레임워크가 아니라 실제 수요, 신뢰 주체, 독점 데이터, 최종 행동의 부재였다.

## 2. 새 증거로 폐기된 전제

초기 30일의 261클릭은 225개 URL에 분산됐고 페이지당 최대 클릭은 3회였다. 193개 URL은 정확히 1클릭이었다. 따라서 검색 성과는 반복 승자의 집합이 아니라 Google의 광범위한 초기 탐색 노출로 해석한다.

폐기한다.

1. 과거 1~3클릭 URL은 검증된 winner다.
2. 대량 county URL은 검색 자산 또는 해자다.
3. 장문과 섹션 수가 품질을 증명한다.
4. local intent 문구를 추가하면 거래형 검색 의도를 해결한다.
5. Next.js 전환이 제품 신뢰나 distribution을 만든다.
6. 모델 가격과 가상 누적 signal이 실제 local evidence를 대신할 수 있다.

## 3. 사용자와 해결할 작업

### Primary user

- 라돈 결과를 받은 homeowner, buyer, seller
- 결과를 설명한 뒤 고객에게 독립적인 다음 단계 자료를 보내는 home inspector

### Job to be done

> “이 숫자가 무엇을 의미하는지, 지금 무엇을 해야 하는지, 다른 사람에게 무엇을 그대로 전달해야 하는지 알고 싶다.”

### 제품 약속

> Enter the result and ZIP. Leave with the next step and a private handoff.

## 4. 시장·정책 근거

- EPA는 4.0 pCi/L를 주요 action threshold로 안내하고, 매매 상황에서는 검사 조건과 최신성을 확인하도록 한다.
- EPA는 qualified professional을 state radon program, NRPP, NRSB를 통해 찾도록 안내한다.
- 기존 inspector 플랫폼은 일정·보고서·결제·고객 커뮤니케이션을 이미 통합한다. RadonVerdict가 범용 inspection software로 경쟁할 이유가 없다.
- 따라서 inspector 제품은 기존 workflow 옆에 붙는 좁은 client handoff여야 한다.
- Google은 YMYL에서 trust와 명확한 저자·전문성·원자료를 더 중요하게 다룬다. 익명 팀과 대량 지역 문서는 authority를 만들지 못한다.

## 5. 구현 대안

### A. 최소 Spring 화면 교체

- 기존 `/plan`을 홈에 전면 배치
- 공유 링크 없이 copy-only
- 장점: 가장 빠름
- 단점: client open과 반복 사용을 측정할 수 없어 제품 가설을 검증하지 못함

### B. Spring handoff product — 선택

- 순수 decision 로직과 기존 evidence loader 재사용
- durable private share snapshot
- inspector handoff 화면
- privacy-safe product events
- 5개 same-path county preservation canary
- immutable image deploy와 rollback
- 장점: 실제 반복 사용 가설을 측정하면서 기존 infra를 재사용
- 단점: legacy 코드 격리가 필요

### C. Next.js 재작성

- TypeScript monorepo와 dual runtime migration
- 장점: 프런트엔드 개발 경험과 장기 모듈화
- 단점: 512MB 단일 OCI, persistence, routing, version skew, 이중 운영 부담을 늘리지만 사용자 가치는 추가하지 않음

결정: B. 제품·데이터·distribution을 먼저 증명한다. 프레임워크 교체는 검증 이후에도 별도 의사결정이다.

## 6. 제품 범위

### 공개 핵심 화면

1. `/` — reading + ZIP + situation 입력
2. `/plan` — verdict, 최대 3개 action, local evidence와 한계
3. `/plan/share/{token}` — 생성 당시 결과의 private read-only snapshot
4. `/for-home-inspectors` — inspector용 creator와 copyable client note
5. `/radon-levels/{state}/{county}` — 5개 preservation canary의 간결한 evidence note

### 명시적으로 제외

- contractor marketplace
- 추천·판매 수수료 기반 업체 순위
- 계정과 dashboard
- 주소, 고객 이름, 이메일, 전화번호, inspection report 저장
- 실제 quote 표본 없는 local cost
- county 대량 재발행
- 범용 home-inspection software
- Next.js 전환

## 7. 시스템 구조

```text
Browser
  │
  ├─ GET /plan ───────────────▶ ActionPlanService
  │                              ├─ RadonDecisionService
  │                              ├─ ZIP primary-county lookup
  │                              └─ CountyRadonEvidenceService
  │
  ├─ POST /plan/share ────────▶ PlanShareService
  │                              ├─ random 256-bit token
  │                              ├─ SHA-256 token hash
  │                              ├─ immutable result snapshot
  │                              └─ H2 file store
  │
  ├─ GET /plan/share/{token} ─▶ hash lookup → expiry/revocation check
  │                              └─ read-only snapshot render
  │
  └─ product event ───────────▶ TelemetryEventService
                                 ├─ direct identifier denylist
                                 ├─ query-string removal
                                 └─ append-only product_events.csv
```

`ActionPlanService`의 결과와 share snapshot은 동일한 `RadonDecisionService` 계약을 사용한다. 공유 링크를 열 때 결과를 재계산하지 않는다.

## 8. Share state machine

```text
VALID PLAN
   │ create
   ▼
ACTIVE ───── revoke ─────▶ REVOKED ──▶ 410
   │
   └──── expires_at ─────▶ EXPIRED ──▶ 410

unknown/tampered token ──────────────▶ 404
invalid plan ────────────────────────▶ no share created
```

## 9. 데이터·프라이버시 계약

Share 저장 허용:

- radon result display와 band
- ZIP과 ZIP에서 해석한 primary county
- living/buying/selling
- verdict, actions
- source name, URI, period, evidence summary
- schema/decision/data version
- created/expires timestamps

저장 금지:

- name, address, email, phone
- inspection report
- share token 원문
- raw IP와 full user agent

Product event는 query string을 버리고 direct identifier key를 제거한다.

## 10. 검색 정책

`winner`라는 표현을 폐기하고 `preservation canary`로 부른다.

초기 5개 same-path URL:

- Florida / Marion County
- New Jersey / Gloucester County
- Pennsylvania / Indiana County
- Vermont / Rutland County
- New York / Ulster County

선택 이유는 성공 확신이 아니라, 기존 path를 유지한 작은 관찰 표본과 현재 query trace를 남기기 위해서다.

정책:

- sitemap index는 core + county canary만 노출
- county page는 한 질문, source semantics, home-test CTA에 집중
- 비-canary county는 기존 410 정책 유지
- cost, intent, broad zone sitemap은 main sitemap에서 제거
- `/plan`과 share URL은 sitemap 제외 및 noindex

## 11. 오류·복구 계약

| Codepath | Failure | 처리 | 사용자 결과 |
|---|---|---|---|
| reading parse | invalid/negative/extreme | invalid decision | 수정 안내, share 차단 |
| ZIP resolve | malformed/not found | no local substitution | national action만 표시 |
| dataset hashing | resource missing | startup failure | 잘못된 data version 배포 차단 |
| share create | DB/JSON failure | transaction rollback | 5xx, 빈 link 생성 금지 |
| share lookup | malformed/unknown | 404 | 존재 여부 최소 공개 |
| share lookup | expired/revoked | 410 | 재생성 안내 가능 |
| telemetry write | disk failure | warning, request 지속 | 핵심 행동은 유지 |
| cross-site mutation | Origin/Sec-Fetch mismatch | 403 | state change 없음 |
| deploy health | new SHA unhealthy | previous image restore | 이전 제품 유지 |

## 12. 배포

```text
test → build ARM64 image → push SHA + latest
                         → deploy exact SHA
                         → poll /
                           ├─ healthy: keep SHA
                           └─ unhealthy: restore previous image and fail job
```

- 실행 image는 commit SHA로 고정한다.
- H2는 `/app/data/radonverdict` file store를 사용한다.
- 빈 admin password는 알려진 default 대신 접근 불가능한 random credential을 생성한다.
- 운영 admin 사용 시 GitHub Actions secret으로만 주입한다.

## 13. 측정

핵심 event:

- `inspector_landing_view`
- `plan_completed`
- `share_created`
- `client_share_opened`
- `share_copy_succeeded`
- `handoff_action_copied`

초기 success gate:

- inspector 10–15명에게 수동 검증
- 최소 5명 share 생성
- 최소 3개 client open
- 최소 2명이 30일 안에 두 번째 share 생성
- 동일 input/version 결과 불일치 0

90일 내 반복 inspector 사용과 실제 plan completion이 없으면 inspector distribution 가설을 폐기한다.

## 14. 테스트

- decision boundary: 1.99, 2.0, 3.99, 4.0, invalid, missing
- share token 원문 미저장
- invalid share 미생성
- share headers와 noindex
- tampered/expired/revoked 상태
- snapshot은 열 때 재계산하지 않음
- telemetry direct identifier 제거
- cross-site POST 403
- sitemap은 core + canary만 참조
- canary 5개 200, 비-canary 410
- mobile 390×844 입력→plan→share→copy

## 15. 남은 외부 검증

코드로 만들 수 없는 것은 제품이 증명됐다고 표현하지 않는다.

- credentialed radon reviewer 확보
- authoritative multi-county ZIP crosswalk
- 실제 inspector 발송과 반복 사용
- Search Console Manual Actions / Security Issues 화면 확인
- 2026-05-02 CDN/server 로그
- 실제 backlink 원장

이 항목은 구현 blocker가 아니지만 authority, ambiguous ZIP, SEO 원인 확정의 blocker다.

## 16. 2026-08-27 구현 결과

- Spring/JTE를 유지하고 홈, `/plan`, inspector landing, private share를 새 계약으로 교체했다.
- 30일 immutable share snapshot, token hash 저장, 404/410 상태, private/no-store/noindex header를 구현했다.
- product event allowlist와 share-token 경로 정규화를 적용했다.
- modeled cost, credit, quote ledger, mass intent, state hub, 비핵심 guide 표면은 production에서 410으로 격리했다.
- main sitemap을 core + 5 county canary로 줄였다.
- known default admin password를 제거하고 same-origin mutation guard를 추가했다.
- deploy image를 commit SHA로 고정하고 health failure 시 previous image rollback을 추가했다.
- 과거 pSEO·cost funnel을 검증하던 테스트는 삭제하지 않고 `@Disabled`로 보존했다. 새 계약은 `PlanShareIntegrationTest`, `ProductPivotPolicyIntegrationTest`, `ProductHandoffBrowserE2ETest`와 기존 decision boundary test가 대체한다.

배포, 실제 inspector 발송, Search Console UI 확인은 외부 상태를 바꾸는 작업이므로 이 구현에는 포함하지 않았다.
