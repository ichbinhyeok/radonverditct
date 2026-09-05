# RadonVerdict 사업성 심층 검토 — 다섯 페르소나 합의안

**기준일:** 2026-09-05  
**시장:** 미국, 영어 검색  
**제약:** 외부 라돈 전문가 없음, 수동 아웃리치 우선순위 낮음, 기존 코드·데이터 최대 재사용  
**사업 성공의 임시 기준:** 12개월 안에 월 기여이익 $500 이상을 재현할 가능성이 있는가

## 한 문장 결론

**사이트는 작은 수익형 자산으로 살릴 가능성은 있지만, 현재 방식으로는 사업이 아니다.**

살릴 모델은 “라돈 정보 사이트”나 “검사 플래너 SaaS”가 아니다. 검색자는 무료 도구를 쓰고 돈을 내지 않는다. 현실적인 첫 사업 모델은 다음과 같다.

> **검사·결과·유지관리 결정을 끝내주는 무료 워크플로로 고의도 사용자를 모으고, 검증된 고가 모니터 구매에서 직접 제휴수익을 얻는 라돈 의사결정 커머스**

장기적으로는 익명화된 검사·견적 기록과 공식 데이터의 출처·버전 이력을 축적할 수 있다. 그러나 데이터 API와 업체 리드 사업은 지금 먼저 만들 대상이 아니다.

## 먼저 인정해야 할 현재 상태

### 검색은 한 번 살아났지만 다시 죽었다

- 저장된 2026년 봄 체크포인트에는 28일 **300클릭 / 26,264노출 / 평균 순위 7.54**가 있다.
- 그중 `/radon-levels`는 **91클릭 / 6,416노출**, 비용 계열은 **8클릭 / 3,440노출**이었다.
- 저장된 2026-07-29 query-page snapshot은 `site:` 검색을 제외하면 **58노출 / 0클릭**이다.
- 이는 도메인이 라돈 주제로 평가받은 적은 있지만, 그 평가가 현재 유지된다는 뜻은 아니다.

### 제품 사용과 매출은 검증되지 않았다

- 과거 운영 기록상 1,142 page views에서 `affiliate_link_click` 15회로 약 **1.31%**였다.
- 같은 표본에서 estimator start 15회, lead submit 1회뿐이었다.
- 로컬 `product_events.csv`의 76개 이벤트는 2026-08-27과 2026-09-05에만 발생했고, 현재 작업·QA 흐름과 일치한다.
- `leads.csv` 2건과 `quote_ledger.csv` 1건도 QA 데이터다.

따라서 지금 입증된 것은 “기능이 동작한다”까지다. 실제 사용자가 반복적으로 쓰거나 구매했다는 증거는 없다.

## 다섯 페르소나의 독립 판단

| 페르소나 | 처음 밀었던 방향 | 반론을 거친 최종 판단 |
|---|---|---|
| 사업 책임자/CFO | 돈을 내는 사건부터 찾기 | Airthings 같은 고가 모니터의 완료 주문만 현재 가장 가까운 매출 사건이다. 무료 플래너 완료는 매출이 아니다. |
| SEO/SERP 역설계자 | 검사 절차와 유지관리 검색 공략 | 승산은 `검사 준비 → 결과·재검 → 비용 → 유지관리` 여정에 있다. 그러나 20개 글 자체가 아니라 도구와 구매 경로가 필요하다. |
| 라돈/YMYL 감사자 | 공식 데이터와 규칙에 한정 | 개인 주택의 안전 판정, 암 위험, 팬 사이징·배선은 금지한다. 공식 절차 적용과 입력 기록은 가능하다. |
| 전환 설계자 | 무료 워크플로 완성 | 첫 화면에서 사용자의 상태를 나누고 한 개의 다음 행동만 보여줘야 한다. 완료율보다 구매·수익 귀속을 우선 측정한다. |
| 데이터 제품 감사자 | 출처·버전 관측소/API | 장기 해자는 가능하지만 CDC가 무료 API를 제공한다. 구매자와 라이선스가 확인되기 전 개발하면 유지비다. |

### 합의와 불일치

모두가 동의한 것은 다음 세 가지다.

1. county 대량 페이지와 일반 정보글 확장은 다시 하면 안 된다.
2. 전문가 없이 `safe/unsafe`, 개인 암 위험, 시스템 설계 추천을 하면 안 된다.
3. 페이지뷰·도구 완료가 아니라 실제 주문과 기여이익으로 사업을 판단해야 한다.

유일한 불일치는 데이터 API의 우선순위였다. 데이터 감사자는 방어력이 높다고 봤지만, CFO 관점에서는 무아웃리치 조건에서 구매자를 찾기 어려워 **무료 소스 카탈로그 이상의 개발을 보류**하는 것이 맞다.

## 실제 고객 페르소나

### 1순위 — 기기를 사려는 집주인

- **상황:** 첫 검사, 확인 검사 또는 장기 모니터링을 위해 detector/monitor를 비교 중이다.
- **검색:** `radon detector`, `radon monitor`, `digital radon monitor`, `radon test kit`.
- **원하는 답:** 무엇이 더 “좋다”가 아니라, 내 사용 기간·반복 측정 필요·예산에 어떤 방식이 맞는가.
- **수익 사건:** Airthings 등 판매처에서 귀속된 완료 주문.
- **우리가 제공할 것:** 사양·측정 방식·필요 기간 기반 선택 도구와 설정 워크플로.
- **하지 않을 것:** 직접 시험하지 않은 제품의 성능 순위, `best` 리뷰, 건강효과 보장.

### 2순위 — 결과를 막 받은 집주인·매수인·매도인

- **상황:** 숫자는 있지만 결과가 유효한지, 재검해야 하는지, 비용을 알아봐야 하는지 모른다.
- **검색:** `radon test results`, `radon levels chart`, `radon mitigation cost`.
- **원하는 답:** 검사 종류·기간·조건을 고려한 다음 단계.
- **수익 사건:** 확인검사용 키트/모니터 구매. 장래에는 검증된 업체 연결.
- **주의:** 온라인 입력만으로 해당 집이 안전하다고 판정하지 않는다.

### 3순위 — 완화 시스템을 이미 보유한 집주인

- **상황:** manometer가 달라졌거나, 팬 소음·응축·수명·재검 시점이 궁금하다.
- **검색:** `radon mitigation system maintenance`, `radon manometer reading`, `radon fan noise`, `how long do radon fans last`.
- **원하는 답:** 안전한 육안 점검, 기준 사진/수치 기록, 재검, 제조사 문서 또는 전문가 호출 시점.
- **수익 사건:** 재검 키트·모니터, 정확히 일치하는 모델/공식 교체 정보.
- **주의:** 팬 사이징, 배선, DIY 교체 지시를 하지 않는다.

### 보류 — 데이터 구매자

- **상황:** 연구자·GIS 개발자·공공보건 프로그램이 여러 주의 소스를 정규화해야 한다.
- **가치:** 원본 스냅샷, 출처 버전, CDC/state 병렬 값, metric ontology.
- **문제:** 검색수요·지불의사·상업 재배포 권한이 확인되지 않았다.
- **결정:** 샘플 응답과 대기목록만 허용하고 유료 API는 만들지 않는다.

## 후보 사업모델 점수

점수는 12개월 내 현금화 30%, 무아웃리치 유통 20%, 기존 자산 재사용 15%, YMYL 안전 15%, 방어력 10%, 운영 부담 10%로 평가했다.

| 순위 | 모델 | 점수 | 결론 |
|---:|---|---:|---|
| 1 | 고가 radon monitor 직접 제휴 퍼널 | **76/100** | 유일한 즉시 검증 후보 |
| 2 | 무료 test/result/maintenance 워크플로 | **69/100** | 독립 사업이 아니라 1번의 획득·전환 제품 |
| 3 | $9–$19 test record/export | **49/100** | 결제 가짜문만 실험, 본개발 금지 |
| 4 | 출처·버전 데이터 관측소/API | **46/100** | 장기 옵션, 구매자 증거 전 코딩 금지 |
| 5 | contractor lead marketplace | **35/100** | 계약·공급자·payout 없어서 현재 탈락 |
| 6 | Amazon 저가 제휴 + 디스플레이 광고 | **29/100** | 첫 달러는 가능, 사업 규모는 어려움 |
| 7 | county/ZIP risk map | **18/100** | CDC·EPA·Ecosense·RadonCost와 차별화 부족 |

## 왜 1위도 아직 “조건부”인가

[Airthings의 공개 제휴 페이지](https://www.airthings.com/professionals/affiliate-program)는 구매액의 25% commission과 월별 지급을 명시한다. 공개 제품 가격이 약 $149.99–$329.99라면 주문당 gross commission은 약 **$37.50–$82.50**이다.

그러나 공개 페이지에는 다음이 명확하지 않다.

- RadonVerdict 계정 승인 여부
- paid search 허용 여부
- 브랜드 키워드 입찰 제한
- cookie window와 주문 귀속 방식
- 환불·취소 시 reversal 규칙

이 조건을 확인하지 않고 Google Ads를 집행하면 안 된다.

### 제휴-only 수익 시나리오

아래는 예측이 아니라 필요한 규모를 보기 위한 민감도 계산이다. 세션→제휴 클릭률, 판매처 클릭→구매율, 주문당 commission은 모두 검증 전 가정이다.

| 월 qualified sessions | 제휴 클릭률 | 클릭 후 구매율 | 주문당 commission | 월 gross commission |
|---:|---:|---:|---:|---:|
| 10,000 | 2% | 2% | $40 | $160 |
| 10,000 | 4% | 3% | $50 | $600 |
| 10,000 | 6% | 5% | $60 | $1,800 |

월 $500을 내려면 같은 가정에서 약 3천~3만 qualified sessions가 아니라, **퍼널 품질에 따라 대략 2,800~31,250 sessions**가 필요하다. 현재 1.31% outbound CTR을 그대로 두면 더 많은 트래픽이 필요하다.

결론은 명확하다. **SEO만 살아나도 되는 것이 아니라, 상업 의도 페이지의 클릭률과 판매처 구매율이 동시에 살아나야 한다.**

## SEO가 맡아야 할 역할

Google Ads Keyword Planner의 방향성 표본은 다음과 같다.

- `radon test kit`: 100K–1M, Medium
- `radon mitigation system`: 100K–1M, Low
- `radon detector`: 10K–100K, High
- `radon test`: 10K–100K, High
- `radon monitor`: 1K–10K, High
- `radon mitigation cost`: 1K–10K, Low
- `how long does radon test take`: 1K–10K, Low
- `radon mitigation system maintenance`: 100–1K, Low, 표본 중 높은 bid ceiling

이 범위는 close variants가 묶인 넓은 band이므로 시장 크기나 수익을 확정하지 않는다. SEO의 역할은 다음 여정을 연결하는 것이다.

```text
검사 선택·기간
    ↓
검사 설정·유효성 기록
    ↓
결과 의미·재검
    ↓
완화 비용·견적 질문
    ↓
시스템 유지관리·재검
```

- placement, windows, rain 같은 zero/low-band 글은 독립 사업 페이지가 아니라 워크플로 도움말이다.
- duration, result meaning, maintenance, fan life, manometer는 검색 획득 페이지다.
- detector/monitor 선택과 재검은 구매 브리지다.
- cost/quote는 파트너가 생기기 전에는 계산·체크리스트 기능만 유지한다.

## YMYL 경계

[CDC는 county 데이터를 제공하면서도 모든 집을 직접 검사해야 한다고 안내](https://www.cdc.gov/environmental-health-tracking/php/data-research/radon-testing.html)한다. [EPA도 시스템의 경고장치를 정기적으로 보고 최소 2년마다 재검하도록 안내](https://www.epa.gov/radon/how-do-i-know-if-my-radon-mitigation-system-working-properly)한다.

전문가 없이 가능한 기능:

- 공식 절차와 수치의 출처·기간 표시
- 사용자가 입력한 조건을 공개된 규칙에 기계적으로 매핑
- 검사 위치·기간·문/창문·장치 이동 사건 기록
- manometer의 현재 상태와 설치 당시 baseline 비교 기록
- 유지관리·재검 알림
- 무료/할인 키트 우선 안내

전문가 없이 하지 말아야 할 기능:

- county 수치로 특정 집의 위험 판정
- 개인 암 위험 계산
- 여러 통계를 합친 독자 risk score
- 팬 선택·사이징·배선·DIY 교체 지시
- 전문 검사보고서나 법적 거래문서인 것처럼 보이는 유료 PDF

[EPA는 주·지역 프로그램에서 무료 또는 할인 키트를 제공할 수 있다고 안내](https://www.epa.gov/radon/how-do-i-get-radon-test-kit-are-they-free)한다. 상업 제품은 이 무료 선택지 뒤에 놓는다. 제휴 추천에는 [FTC가 요구하는 명확하고 눈에 띄는 수익관계 고지](https://www.ftc.gov/business-guidance/resources/ftcs-endorsement-guides-what-people-are-asking)를 CTA 가까이에 둔다.

## 데이터 해자의 현실

현재 데이터 자산은 3,036 county measurement rows와 여러 주정부 adapter를 포함하지만 완성된 해자는 아니다.

- CDC가 이미 대부분의 미국 본토 county 데이터를 machine-readable API로 제공한다.
- 현재 생성 스크립트는 같은 FIPS에서 뒤의 source가 앞의 source를 덮어쓴다.
- source별 median, maximum, p95 같은 값이 공개 스키마에서 충분히 보존되지 않는다.
- 수집일은 2026-05-05/06 한 번의 snapshot이며, 원 데이터 기간은 더 오래된 경우가 많다.
- state source별 상업적 재사용 조건이 registry에 없다.

따라서 `nationwide radon map`이나 `CSV download`는 제품이 아니다. 유료 데이터 후보가 되려면 raw immutable snapshot, source coexistence, version diff, metric semantics, license가 먼저 필요하다. 하지만 구매자 검증 전에는 만들지 않는다.

## 30·60·90일 검증안

### 0–30일 — 돈이 흐를 수 있는지 확인

개발 시간 상한: **5 working days**. 광고비 상한: **$100**, 단 제휴사의 paid-search 정책을 서면 확인한 뒤에만 사용한다.

1. Airthings 또는 다른 직접 제휴 계정의 승인·PPC·brand bidding·cookie·reversal 조건 확인.
2. merchant/product/CTA/landing/query 단위 click과 실제 order·commission을 연결.
3. 첫 화면을 `Need to choose a test / Have a result / Own a system` 세 갈래로 단순화.
4. detector/monitor 선택 페이지는 `best`가 아니라 사용기간·반복측정·연결성·가격 사양으로 비교.
5. maintenance hub는 manometer, noise, fan life, post-mitigation retest를 하나의 상태 선택기로 연결.

**중단:** 제휴 승인 또는 PPC 조건을 확인하지 못하면 paid search를 하지 않는다. 상업 의도 방문 100명에서 제휴 클릭 2건 미만이면 페이지를 한 번만 수정한다.

### 31–60일 — 검색 회복과 구매 행동을 분리 측정

- priority 세 묶음: duration/testing, result/retest, maintenance/ownership.
- GSC에서 intended query가 intended URL에 붙는지 확인.
- 같은 query에 두 URL이 경쟁하면 통합한다.
- zero-band 지원 페이지는 meaningful impression이 없으면 추가 투자하지 않는다.
- 최대 paid clicks 300에서 attributed commission/ad spend가 0.8 미만이면 광고를 중단한다.

**계속 조건:** 비브랜드 검색 노출과 행동 진입이 함께 증가하고, 실제 attributed order가 최소 1건 발생한다.

### 61–90일 — 사업 판정

다음 네 가지를 동시에 본다.

1. priority non-brand impressions와 clicks가 launch 전 28일 대비 증가.
2. commercial landing→affiliate click이 과거 1.31%를 유의하게 상회.
3. 누적 500 paid clicks를 사용했다면 환불 반영 ROAS 1.2 이상.
4. organic 또는 paid에서 실제 주문과 commission이 발생.

**사업 중단 기준:** 90일에 주문 0, 월 기여이익 $100 미만, 검색 클릭 회복 없음 중 두 가지 이상이면 추가 콘텐츠·기능 개발을 멈춘다. 유지비만 낮춘 뒤 도메인 처분 또는 다른 업종 피벗을 검토한다.

## 구현 우선순위

### 지금 해야 할 것

1. **수익 귀속 계측:** 클릭이 아니라 order/commission/reversal까지 연결.
2. **홈·가이드 허브 재구성:** 세 고객 상태로 진입점을 통합.
3. **detector/monitor 선택 도구:** 직접 시험 없는 사양·용도 비교.
4. **maintenance ownership hub:** baseline record, calendar, symptom router, retest.
5. **result→retest→cost 연결:** 숫자 설명에서 구매·예산 결정으로 이동.

### 지금 하지 말아야 할 것

- 20개 가이드보다 더 많은 글 발행
- `best radon detector/test kit` 리뷰
- county/ZIP 페이지 재확장
- 업체가 없는 lead form 확대
- 구매자 없는 API 본개발
- Google Ads의 큰 volume band만 믿고 광고 집행

## 최종 판정

- **SEO 회복 가능성:** 중간. 과거 topical eligibility와 약한 SERP의 operational queries가 있다.
- **12개월 내 월 $500 가능성:** 낮음~중간, 직접 제휴 승인과 실제 구매 전환이 확인될 때만.
- **월 $5,000 이상 독립 사업 가능성:** 현재 증거로는 낮음. 제휴만으로는 상당한 고의도 트래픽이 필요하고, lead/data 수익은 외부 계약 없이는 열리지 않는다.
- **권장 결정:** 90일·5일 개발·$100 광고 상한으로 검증하고, 주문이 없으면 SEO를 핑계로 연장하지 않는다.

이 사이트를 살린다는 말은 다시 노출시키는 것이 아니다. **실제 주문이 발생하는 검색 여정을 증명하는 것**이다.

