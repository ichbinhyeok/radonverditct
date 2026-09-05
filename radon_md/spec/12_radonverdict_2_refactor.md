# RadonVerdict 2.0 — 전면 제품 리팩터링 계획

상태: Superseded for stack/URL/execution by `13_nextjs_evidence_based_salvage.md`  
작성일: 2026-07-31  
기준 브랜치: `master`  
입력 감사: `.gstack/design-reports/radonverdict-product-seo-audit-2026-07-31.md`

## 1. 한 줄 결정

RadonVerdict를 **county cost pSEO 사이트**에서 **실제 라돈 측정값과 공식 지역 근거를 행동 계획으로 바꾸는 decision product**로 다시 만든다.

제품은 사실상 새로 설계하지만, 기존 URL·검색 신호·데이터 파이프라인은 단계적으로 이주시킨다. 새 저장소나 새 프레임워크로 갈아엎는 빅뱅 재작성은 하지 않는다.

## 2. 왜 전면 리팩터링인가

현재 문제는 국소적인 UI 부채가 아니다.

- 2026-05-02를 경계로 Search Console 클릭 99.23%, 노출 98.32% 감소
- 3,126개 county page가 평균 3,549단어, 샘플 간 어휘 유사도 84.54%
- organic winner는 `radon-levels`, 전략의 중심은 `radon-mitigation-cost`
- 동일 canonical 페이지의 가격이 진입 시나리오에 따라 2배 이상 변화
- 사용자의 대표 ZIP 경로가 대부분 noindex cost page로 연결
- 소비자 검색 제품, cost/credit 도구, inspector B2B가 한 내비게이션에서 경쟁

부분 수정은 이 충돌을 유지한 채 표현만 바꾼다.

## 3. 제품 전제 재설정

### 폐기할 전제

1. 3,000 county URL 자체가 해자다.
2. 긴 페이지는 helpful content다.
3. state multiplier가 붙으면 local price다.
4. 과거 클릭이 없는 cost page는 영구적으로 가치가 없다.
5. 검색, 계산기, inspector 도구를 홈에서 모두 설명해야 한다.

### 새 전제

1. 해자는 `ZIP resolution + official evidence + decision logic + shareable handoff`다.
2. 한 페이지는 한 질문에 한 결론을 준다.
3. 사용자가 제공하지 않은 주택 조건은 추정하지 않는다.
4. 실제 local quote data가 없으면 local market price라고 부르지 않는다.
5. indexable page는 수요와 고유 근거가 함께 있을 때만 발행한다.
6. inspector는 별도 유통 채널이며 SEO와 KPI를 공유하지 않는다.

## 4. 최종 제품 정의

### 주 사용자

- 라돈 결과를 받은 homeowner
- inspection contingency 중인 buyer/seller
- 결과를 설명한 뒤 독립적인 next-step 자료를 보내야 하는 inspector

### 핵심 입력

- radon reading 또는 `not tested`
- ZIP
- 상황: living / buying / selling
- 측정 조건: short-term / long-term / unknown
- 선택 입력: foundation, home size, closing deadline

### 핵심 출력

1. **Verdict:** 숫자가 어느 band인지
2. **Next action:** test / retest / monitor / quote / negotiate
3. **Local evidence:** 이 county의 공식 데이터가 무엇을 말하고 무엇을 말하지 않는지
4. **Planning range:** 필요한 주택 입력이 있을 때만 산출
5. **Reusable handoff:** contractor call script, seller-credit note, inspector share link

### 제품 약속

> Enter the result and ZIP. Leave with the next step for this home.

## 5. 정보 구조

```text
/
├─ /plan                         사용자 decision workspace
│  └─ /plan/share/{token}        PII 없는 읽기 전용 공유 결과
├─ /radon/{state}/{county}       단일 indexable county evidence page
├─ /testing/{state}/{county}     실제 query demand + 고유 protocol이 있을 때만
├─ /guides/{slug}                evergreen editorial support
├─ /for-home-inspectors          B2B landing
│  └─ /for-home-inspectors/demo  실제 client handoff preview
├─ /methodology
├─ /data-sources
└─ /about
```

### URL 통합 원칙

- 자동 생성된 `radon-levels/{state}/{county}`와 `radon-mitigation-cost/{state}/{county}`를 장기적으로 `/radon/{state}/{county}` 하나로 통합한다.
- 기존 indexable URL은 intent와 content equivalence를 URL별 검증한 뒤 302 canary를 거쳐 301 여부를 결정한다.
- noindex tool result는 즉시 redirect하지 않고, 새 `/plan` 결과와 기능 parity가 생긴 뒤 종료한다.
- query scenario는 canonical editorial page의 H1과 기본 가격을 바꾸지 않는다.
- 새로운 testing URL은 Ulster처럼 실제 query demand가 확인된 곳만 수동 manifest로 발행한다.

## 6. 페이지 설계

### 홈

첫 viewport는 하나의 입력 흐름만 둔다.

1. 브랜드와 한 문장 약속
2. reading / ZIP / situation
3. `Build my next step`
4. 작은 실제 출력 preview

삭제:

- 별도 Situation Decoder 섹션
- 중복 next-step router
- Pick the job 3-card 반복
- 기능을 다시 설명하는 `Why useful` 표

### Decision workspace

```text
Verdict
  ↓
What to do next (최대 3개)
  ↓
Local evidence and its confidence
  ↓
Optional cost / negotiation planner
  ↓
Copy, print, or share
```

필수 상태:

- no test
- incomplete ZIP
- ZIP maps to multiple counties
- no official county measurement data
- conflicting short-term tests
- under 2.0 / 2.0–3.9 / 4.0+
- stale test
- share link expired or invalid

### County evidence page

목표 길이: 800–1,400단어.

1. 직접 답변
2. 공식 local measurement와 source caveat
3. EPA zone은 property result가 아니라는 설명
4. 내 reading 입력 CTA
5. local protocol 또는 state rule
6. 출처와 업데이트 날짜

금지:

- 사용자 입력 없는 상세 price headline
- 20개 이상의 H3
- 같은 결론의 Quick Answer / Local Answer / Instant Summary 반복
- 내부 indexing cohort를 `100% coverage`로 표현
- high-end outlier를 평균처럼 강조

### Inspector

- 소비자 내비게이션과 분리한 landing shell
- ready note / link 복사
- client open attribution
- inspector identity는 선택적, client PII는 저장하지 않음
- `No contractor recommendation` 독립성 유지

## 7. 도메인 아키텍처

```text
                         ┌──────────────────────┐
Web / JTE / HTMX ───────▶│ DecisionApplication  │
                         └──────────┬───────────┘
                                    │
             ┌──────────────────────┼──────────────────────┐
             ▼                      ▼                      ▼
     DecisionEngine          EvidenceService          CostPlanner
     pure domain rules       official data only       explicit inputs only
             │                      │                      │
             └──────────────┬───────┴──────────────┬───────┘
                            ▼                      ▼
                       PlanResult            SharePlanService
                            │                      │
                            └──────────┬───────────┘
                                       ▼
                                  Telemetry

PublishingManifest ──▶ IndexPolicy ──▶ Sitemap / canonical / redirects
LocationCatalog ─────▶ ZIP / county resolution used by all modules
```

### 새 경계

- `DecisionEngine`: 가격·HTML·SEO를 모르는 순수 규칙
- `EvidenceService`: EPA/state/CDC 데이터와 caveat만 반환
- `CostPlanner`: foundation와 size가 명시된 경우만 계산
- `PublishingManifest`: 발행 URL, primary query, unique evidence, canonical 상태를 데이터로 관리
- `IndexPolicy`: 과거 클릭 hardcode가 아니라 manifest를 읽음
- `SharePlanService`: 민감정보 없는 signed token과 expiry

### 기존 코드 활용 지도

| 기존 자산 | 결정 | 새 위치/역할 |
|---|---|---|
| `DataLoadService` | 유지·분해 | `LocationCatalog`, evidence repositories |
| ZIP→FIPS 40,965 mapping | 유지 | 모든 진입점의 location resolution |
| county measurement/tier JSON | 유지 | `EvidenceService` |
| `PricingCalculatorService` | 계산 kernel만 유지 | `CostPlanner`, 명시 입력 필수 |
| `ContentGenerationService` | 폐기 | editorial view model builder로 대체 |
| `SeoIndexingPolicyService` | 폐기 | manifest-driven `PublishingPolicy` |
| `InternalLinkService` | 재작성 | manifest graph 기반 |
| `QuoteLedgerService` | 유지·격리 | 관측치 충분할 때만 local proof |
| `TelemetryEventService` | 유지 | 새 funnel taxonomy 적용 |
| inspector demo | 유지·제품화 | B2B acquisition surface |
| JTE/Spring Boot | 유지 | 재작성 위험과 SEO migration 최소화 |

## 8. 가격 신뢰 계약

### 세 가지 숫자만 허용

1. **Observed local quotes:** 표본수와 기간을 표시, 최소 기준 충족 시만
2. **Published national reference range:** 출처·회수일 표시
3. **Your planning range:** 사용자가 입력한 foundation/size/scope 기반

### 금지

- median home value로 사용자의 sqft 추정
- 주 전체를 foundation 하나로 추정해 headline price 생성
- quote 표본이 없는데 `local average` 사용
- query parameter에 따라 같은 canonical의 headline price가 2배 변화

### 출력 예

> Planning range: $1,100–$1,700  
> Based on: basement, under 2,000 sq ft, standard pipe route.  
> This is not an observed Fairfax quote average.

## 9. Publishing manifest

각 indexable URL은 다음을 가져야 한다.

```yaml
path: /radon/north-carolina/iredell-county
primary_query: radon levels in Iredell County NC
page_type: county_evidence
evidence_source: nc_dhhs
unique_takeaway: highest-reported-value dataset; not county average
reviewed_at: 2026-07-31
index: true
legacy_urls:
  - /radon-levels/north-carolina/iredell-county
```

발행 gate:

- 공식 source 있음
- source semantics가 template copy와 일치
- primary query 하나
- 고유 takeaway 하나
- 800–1,400단어
- 다른 페이지와 유사도 65% 미만
- 사람 검토 날짜
- mobile direct answer와 CTA 검증

초기 cohort는 20–40페이지로 제한한다.

## 10. 테스트 전략 교체

삭제하거나 뒤집을 테스트:

- `wordCount > 1500`
- `Jaccard < 90%`
- `costPolicyCandidates == 5`
- 정해진 마케팅 문구 존재 시 점수 가산

새 테스트:

| 영역 | 검증 |
|---|---|
| Decision | 모든 reading band × intent × test status 결정표 |
| Evidence | source type별 값 semantics와 caveat |
| Pricing | 명시 입력 없으면 range 없음, 가정 표시, deterministic output |
| Canonical | query variant가 canonical title/H1을 바꾸지 않음 |
| Publishing | manifest 없는 URL은 sitemap에 못 들어감 |
| Migration | URL별 intent/equivalence, 302 canary, chain/loop 없음 |
| Content | 65% 유사도 ceiling, 중복 section detector |
| UX | 모바일 첫 viewport에 primary action 존재 |
| Safety | outlier, missing data, stale data 표시 |
| Analytics | funnel event가 한 번만 전송되고 attribution 유지 |

기존 108개 SEO·콘텐츠·반응형 테스트는 새 계약에 맞게 보존 또는 교체하며, 기능 parity가 생길 때까지 삭제하지 않는다.

## 11. 실행 순서 — 제품은 전면, 배포는 단계적

### Phase 0 — Freeze & forensic baseline

- 새 county/content 기능 개발 중지
- GSC, sitemap, indexed URL, redirects, 가격 샘플 export
- Manual Actions / Security Issues 확인
- 5월 1–3일 deploy·uptime·DNS 기록 확인
- 기존 194 sitemap URL과 redirect contract snapshot

완료 조건: 무엇을 보존하고 무엇을 잃어도 되는지 URL 단위로 확정.

### Phase 1 — Domain core

- `DecisionEngine`
- `EvidenceService`
- `CostPlanner`
- `PlanResult`
- `PublishingManifest`
- 결정표와 contract test

기존 UI에는 아직 연결하지 않는다.

완료 조건: HTML 없이 ZIP + reading 입력으로 같은 JSON-like result 생성.

### Phase 2 — Visual foundation and core product patterns

- inspector demo의 calm editorial 방향을 전체 브랜드로 확장
- warm neutral + deep green, accent 하나
- cardless layout, two fonts, spacing/token 정의
- header를 consumer / inspector shell로 분리
- loading/error/empty/share states

완료 조건: home, plan, county 3개 화면 desktop/mobile 승인.

### Phase 3 — Consumer flow

- 새 홈
- `/plan` workspace
- copy/print/share
- analytics taxonomy
- legacy calculator와 결과 parity 비교

완료 조건: 100개 시나리오 브라우저 테스트와 수동 모바일 QA 통과.

### Phase 4 — County publishing canary

- manifest 기반 5개 county page
- 기존 page와 정보량/유사도/검색 intent 비교
- 처음에는 noindex preview
- 승인 후 sitemap cohort에 추가

완료 조건: URL Inspection에서 canonical/indexability 정상, direct answer QA 통과.

### Phase 5 — Legacy migration

- levels/cost legacy map 생성
- indexable winner부터 URL ledger에 등록하고 302 canary 후 301 승격
- noindex tool pages는 `/plan` parity 뒤 전환
- sitemap에서 old URL 제거, new URL 추가
- redirect chain 0개 보장

완료 조건: 표본이 아니라 전체 redirect map 자동 검증.

### Phase 6 — Inspector distribution

- `/for-home-inspectors`
- client link generator
- copy→open→plan funnel
- 10–20명 inspector 수동 outreach 실험

완료 조건: 반복 사용과 client open이 관측됨.

### Phase 7 — Controlled expansion

- 20–40개 county cohort
- 4주 단위 index/impression review
- manifest gate 통과 URL만 확장
- 실제 query가 생길 때 testing/editorial page 추가

## 12. 배포와 롤백

- 새 기능은 flag 뒤에 둔다.
- 새 URL은 초기 `noindex`로 preview한다.
- 5-page canary → 20-page cohort → 최대 40-page cohort 순서다.
- 기존 URL redirect는 새 URL이 live, canonical, sitemap, content parity를 모두 만족한 뒤 켠다.
- redirect map과 sitemap은 버전 관리한다.
- rollback은 UI flag, redirect manifest, sitemap manifest를 독립적으로 되돌리되, 이미 캐시된 301은 즉시 복구된다고 가정하지 않는다.

## 13. 성공 지표

### 검색

- 발행 cohort의 70% 이상 `Submitted and indexed`
- 4주 연속 impressions per indexed page 증가
- primary query 평균 위치 20위 이내 진입
- crawled-not-indexed 비율 감소

### 제품

- plan 시작→완료율 50% 이상
- 결과 후 copy/print/share 15% 이상
- cost range 사용자 중 assumption 확인 90% 이상
- 동일 입력 결과 불일치 0건

### Inspector

- copy link→client open 30% 이상
- client open→plan complete 40% 이상
- inspector 4주 반복 사용 20% 이상

## 14. 중단 기준

- 편집한 20–40개 실데이터 페이지도 8주 뒤 대부분 crawled-not-indexed
- inspector 20명 실험에서 반복 사용 0
- planning range가 실제 quote ledger와 지속적으로 크게 어긋남
- 제품 funnel을 측정할 telemetry가 안정화되지 않음

이 경우 SEO 확장을 중단하고 inspector-only 또는 data/API product로 좁힌다.

## 15. 명시적으로 범위 밖

- 3,000 county page 재발행
- contractor marketplace 구축
- 사용자 계정/대시보드
- medical risk diagnosis
- native app
- 프레임워크 교체
- 대규모 DB 마이그레이션
- 실제 quote 데이터 없는 정밀 county price

## 16. Decision Audit Trail

| # | 결정 | 원칙 | 이유 | 거절한 대안 |
|---|---|---|---|---|
| 1 | 제품은 전면 재설계, 배포는 strangler | 검색 신호 보존 | 빅뱅은 기존 URL과 진단 가능성을 동시에 잃음 | 새 저장소 재작성 |
| 2 | Spring/JTE 유지 | 자산 재사용 | 문제는 프레임워크가 아니라 제품 경계와 콘텐츠 정책 | Next.js 전환 |
| 3 | county URL을 장기적으로 하나로 통합 | 집중 | levels/cost cannibalization과 중복 제거 | 두 pSEO 트리 유지 |
| 4 | 가격은 명시 입력 후에만 | 신뢰 | 지역/주택 추정이 결과를 2배 바꿈 | inferred defaults 유지 |
| 5 | 초기 index cohort 20–40 | 증거 기반 확장 | 3,000 URL 재시도 방지 | 전체 county 재오픈 |
| 6 | inspector를 별도 shell/KPI로 | 채널 분리 | SEO와 B2B 유통은 성공 조건이 다름 | 홈에서 동등 노출 |
| 7 | 콘텐츠 유사도 ceiling 65% | 고유 가치 | 기존 84.54%는 실질 중복에 가까움 | 90% threshold 유지 |

## 17. 승인 후 첫 구현 단위

첫 PR은 화면 리뉴얼이 아니다.

1. `DecisionEngine` contract와 결정표
2. `CostPlanner`에서 inferred foundation/sqft 제거
3. `PublishingManifest` schema와 5개 canary entry
4. 새 계약 테스트
5. 기존 동작은 feature flag로 유지

이 PR이 통과한 뒤에만 새 홈과 county UI를 만든다.

## 18. 구현 전 UX 계약

### 홈: 390×844 기준

- 첫 시각 앵커는 reading 입력 또는 `Build my next step`이다.
- H1은 최대 3줄, supporting copy는 최대 2줄이다.
- reading + ZIP은 한 행, situation은 3분할 control 한 행으로 고정한다.
- 첫 viewport CTA는 full-width 한 개뿐이다.
- 좌우 여백 20px, header 최대 56px, input 최소 48px, touch target 최소 44×44px로 한다.
- CTA 아래 `No account · Independent guidance`까지 viewport 안에 보여야 한다.
- 결과 예시는 `Example plan`이라고 표시하고 모바일에서는 첫 viewport 아래에 둔다.
- 가상 키보드가 열린 상태에서도 현재 입력과 제출 경로가 가려지지 않아야 한다.
- 200% text zoom에서 가로 스크롤이 없어야 한다.

### 결과 화면의 감정 순서

1. `Your plan for this home`
2. 측정값과 band
3. 과장 없는 한 문장 해석
4. 단 하나의 primary action
5. 필요한 경우에만 1–2개의 secondary action
6. local evidence와 한계
7. high-result일 때만 cost/negotiation planner
8. copy / print / share

표현 계약:

- `<2.0`: 낮은 측정이지만 zero-risk 판정으로 표현하지 않는다.
- `2.0–3.9`: action level 아래라는 사실과 장기 측정·재측정 선택지를 함께 말한다.
- `4.0+`: 공포를 키우지 않고 확인·완화 절차를 시작하게 한다.
- `not tested`: 가짜 verdict를 만들지 않고 적절한 test 선택으로 전환한다.
- `conflicting tests`: 평균을 내지 않고 충돌 자체를 상태로 보여준다.
- buying/selling: 건강 공포보다 closing deadline과 확인 절차를 먼저 안내한다.

### County evidence 상단 계약

```text
Radon in {County}
직접 답변 2–3문장
County data cannot predict this home
Use your home's result
공식 데이터가 실제로 측정한 것
표본수 / 기간 / 단위 / 업데이트일
이 데이터가 말하지 않는 것
state testing protocol
sources
```

- 값마다 `what this number is` 라벨을 붙인다.
- average, maximum, percentile, positivity를 같은 시각 패턴으로 뭉개지 않는다.
- confidence badge 대신 source / period / sample coverage / caveat를 분리한다.
- local data가 빈약하면 길이를 억지로 채우지 않고 짧게 발행하거나 발행하지 않는다.
- source 유형에 따라 섹션 구성을 달리할 수 있어야 한다.

### Consumer / inspector 모드 계약

- 소비자 홈과 `/plan`: consumer shell
- `/for-home-inspectors`: inspector acquisition shell
- inspector가 보낸 share link: consumer shell + 얇은 attribution strip
- client share 화면에는 inspector 영업 CTA와 B2B navigation을 두지 않는다.
- inspector shell에는 county SEO navigation을 두지 않는다.
- inspector 이름이 없으면 빈 placeholder 대신 RadonVerdict 독립 링크로 fallback한다.

### Visual foundation 범위

Phase 2는 범용 디자인 시스템 구축이 아니다.

- 12–16개의 semantic color/type/spacing token
- 약 8개의 primitive: field, segmented control, button, link, divider, status text, disclosure, dialog
- 6개의 product pattern: verdict block, primary action, evidence block, assumption disclosure, attribution strip, share bar
- 카드는 독립적인 상호작용 또는 공유 객체에만 사용하고, 단순 구분은 여백과 1px hairline을 쓴다.
- 첫 릴리스에서 Storybook, 범용 grid, 아이콘 라이브러리, dashboard component는 만들지 않는다.

## 19. 상태 및 복구 계약

모든 비정상 상태는 `사용자 설명 + 지금 가능한 행동 + 데이터 신뢰 수준`을 제공한다.

| 상태 | 탐지 | 사용자 복구 |
|---|---|---|
| 음수·극단값·소수점·단위 혼동 | 입력 경계와 단위 검사 | 입력 예시와 해당 field focus |
| 여러 측정값 | 복수 입력 명시 | 평균 대신 검사별 날짜·종류 확인 |
| test 종류·기간 불명 | metadata 누락 | 보수적 안내와 확인 질문 |
| 오래된 test·closed-house 불명 | 날짜·조건 검사 | retest 절차 제시 |
| mitigation 설치·post-test | system 상태 입력 | post-mitigation 경로로 분기 |
| ZIP invalid·다중 county·dataset 밖 | `LocationCatalog` 결과 | 수정, county 선택, national-only 경로 |
| local evidence 없음·stale·충돌 | evidence metadata 검사 | national guidance와 한계 공개 |
| 부분 서비스 실패 | module별 timeout/error | verdict 유지, 실패한 보조 영역만 재시도 |
| planner 입력 일부 누락 | required-input 검사 | range를 숨기고 빠진 입력 표시 |
| observed quote 없음 | quote count gate | national reference만 명확히 표시 |
| share 만료·변조·철회 | token 검증 | 민감정보 없이 새 plan 시작 |
| clipboard 거절 | browser API 오류 | 선택 가능한 plain text 제공 |
| 뒤로가기·새로고침·중복 submit | idempotency와 state restore | 입력 보존, 중복 event 차단 |
| screen reader validation | 오류 요약 검사 | 첫 invalid field로 focus 이동 |
| 인쇄 | print stylesheet 검사 | attribution·source·날짜 유지 |

## 20. 운영 실패 모드

| 실패 모드 | 조기 신호 | 차단·복구 |
|---|---|---|
| 진입 경로별 verdict 불일치 | golden scenario diff | `DecisionEngine` 단일 호출 경계, 배포 차단 |
| source semantics 오표현 | source contract test 실패 | page 비발행, evidence adapter 수정 |
| inferred 가격 재유입 | 입력 provenance 누락 | range 숨김, pricing contract test 실패 처리 |
| canonical drift | query별 title/H1/canonical snapshot diff | release gate에서 차단 |
| redirect loop·chain | crawl contract 실패 | versioned redirect manifest rollback |
| sitemap/manifest 불일치 | URL set diff | sitemap 배포 중단 |
| 대량 deindex | cohort coverage 급락 | 다음 cohort 중단, 기존 URL 유지 |
| share token 추측·유출 | signature/expiry/audit 이상 | 즉시 철회, key rotation, PII 저장 금지 |
| telemetry 중복·누락 | event id와 funnel 합계 불일치 | idempotency key, schema rollback |
| local evidence 부분 장애 | repository health 실패 | national-only 결과로 degrade |

## 21. 리뷰 합의와 범위 잠금

세 관점의 공통 결론은 다음과 같다.

- 복구 대상은 3,126개 URL이 아니라 `reading → action` 결정 능력이다.
- 첫 릴리스의 허용 범위는 입력 흐름, 판정 엔진, 공식 근거, 공유 결과 네 가지다.
- 첫 PR은 UI가 아니라 domain contract다.
- Phase 2 전에 결과 감정 흐름, missing states, 390×844 계약, county evidence semantics를 테스트 가능한 조건으로 잠근다.
- 새 디자인 시스템, 계정, dashboard, marketplace, CRM, AI chat은 핵심 사용 신호가 생기기 전까지 금지한다.
- 90일 안에 실제 plan completion과 inspector 반복 사용이 없으면 독립 제품 가설을 재평가한다.

## 22. Engineering release contract

### URL migration ledger

두 legacy URL을 하나로 합치는 것은 1:1 redirect가 아니라 2:1 intent 통합이다. 각 URL을 개별 판단한다.

```text
KEEP → SHADOW → 302_CANARY → 301_FINAL → RETIRED
```

원장 필드:

- legacy URL과 intent
- 현재 indexability와 historic traffic
- target과 content equivalence evidence
- 현재 migration state와 activated_at
- rollback target

301은 캐시 때문에 즉시 rollback 가능한 상태가 아니다. 먼저 302 canary로 target의 live/indexability/canonical/content parity를 검증한다. 내용 동등성이 없는 cost URL은 억지로 `/radon`에 보내지 않고 KEEP, tool 이동, 410을 개별 결정한다.

### Share security and versioning

- 최소 128-bit entropy의 opaque random token 또는 암호화 token
- expiry, revocation, key rotation
- `Cache-Control: private, no-store`
- `X-Robots-Tag: noindex, noarchive`
- `Referrer-Policy: no-referrer`
- client name, address, email 저장 금지
- inspector attribution 길이 제한과 output escaping
- `ruleVersion`, `evidenceVersion`, 생성 시점 결과 snapshot 저장
- 오래된 링크는 자동 재계산하지 않고 `생성 당시 결과`와 `최신 기준 보기`를 분리
- token enumeration rate limit과 audit

Phase 0에서 hard-coded/default 관리자 credential을 제거·회전하고, 전역 CSRF 비활성화를 endpoint별 정책으로 교체한다.

### Typed location resolution

대표 county 하나만 반환하는 `zip_primary_county`는 ambiguous ZIP 상태를 구현할 수 없다. full crosswalk와 residential ratio를 런타임 자산으로 복구한다.

```text
Unique(county)
Ambiguous(candidates, residentialRatios)
NotFound
```

### Typed pricing result

```text
Available(range, explicitInputs, assumptions, modelVersion, evidenceType)
Unavailable(reason)
```

- invalid ZIP, foundation 누락, size 누락은 national fallback이 아니라 `Unavailable`이다.
- regional multiplier는 quote evidence로 검증되기 전까지 제거하거나 모델 가정으로 노출한다.
- 어떤 출력도 local quote와 modeled planning range를 같은 유형으로 표현하지 않는다.

### Typed evidence record

```text
evidenceType, geography, statistic, unit, period,
sampleSize, suppressionRule, sourceUri,
publishedAt, retrievedAt, datasetVersionHash
```

- indexable page가 참조한 evidence 누락·만료·semantic mismatch는 fail-open 하지 않는다.
- startup/build gate에서 해당 page를 비발행 또는 noindex로 전환한다.

### Release manifest state machine

```text
DRAFT
PREVIEW_NOINDEX
CANARY_INDEXABLE
REDIRECT_TEST
MIGRATED
ROLLED_BACK
```

validator는 duplicate path, missing target, redirect loop/chain, target noindex, sitemap/canonical conflict를 배포 전에 막는다. 모든 instance는 config fingerprint를 health endpoint로 공개해 cohort 불일치를 탐지한다.

### Code seams

- 새 `/plan`은 별도 `PlanController`가 소유한다.
- legacy request는 adapter가 typed `DecisionInput`으로 변환한다.
- `domain → application → publishing/web` 의존 방향을 architecture test로 고정한다.
- 기존 controller에는 flag routing만 두고 새 decision rule을 재구현하지 않는다.
- reading, unit, intent, test type은 string이 아니라 enum/value object로 둔다.
- exact 2.0/4.0, pCi/L↔Bq/m³, 음수, NaN, 극단값, 날짜·시간대 규칙을 계약으로 둔다.

### Telemetry minimum contract

- event allowlist와 schema version
- payload 크기 제한과 rate limit
- event ID 기반 idempotency
- IP 최소화 또는 단방향 처리, 보존 기간 명시
- bot·내부 테스트 제외
- 재배포·다중 instance에서 유지되는 durable sink
- sink health가 깨지면 KPI 판정을 중단하고 추정치로 성공을 선언하지 않음

### Test execution budget

- 수초: pure domain parameterized/property tests
- 수십 초: controller/manifest contract tests
- 별도 CI: 대표 Playwright journey 8–12개
- 배포 후: canonical/robots/sitemap/redirect synthetic checks
- 100개 decision scenario는 브라우저 100회가 아니라 domain matrix로 검증
- 800–1,400단어와 65% 유사도는 절대 품질 판정이 아니라 main-content review signal로 사용

## GSTACK REVIEW REPORT

| Review | 상태 | 핵심 질문 |
|---|---|---|
| CEO Review | 완료 — 조건부 승인 | URL 복구가 아닌 decision product로 축소하고 1차 범위를 네 가지로 잠금 |
| Design Review | 완료 — 수정 반영 | 결과 감정 흐름, 상태, 모바일, evidence semantics를 계약으로 추가 |
| Eng Review | 완료 — 조건부 승인 | URL 원장, share 보안, full ZIP crosswalk, 명시적 `Unavailable`을 구현 전 계약으로 추가 |
