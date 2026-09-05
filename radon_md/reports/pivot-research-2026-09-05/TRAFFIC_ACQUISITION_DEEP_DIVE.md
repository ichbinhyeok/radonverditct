# RadonVerdict 유입 회복 심층안

**기준일:** 2026-09-05  
**범위:** 구매전환을 제외한 미국 영어권 자연검색 유입  
**판정 기간:** 배포 후 90일  
**현재 결론:** 유입 회복은 가능하지만, 페이지 수를 늘리는 방식으로는 다시 실패한다.

## 한 문장 판정

RadonVerdict가 먼저 이겨야 할 곳은 `radon test` 같은 대형 키워드도, 서비스 제공자도 아닌 사이트가 `Ulster County radon testing services` 같은 지역 서비스 검색도 아니다.

> **검사 절차의 구체적 문제와 이미 설치된 완화 시스템의 관리 문제를, 공식 규칙을 적용하는 도구형 답변으로 해결하는 중간·롱테일 검색부터 점유한다.**

YMYL은 회복 불가능의 원인이 아니다. 다만 출처 없는 일반론과 과도한 확답은 불리하다. 현재 더 큰 문제는 약한 외부 권위, 과거 대량 URL의 잔재, 검색 의도 불일치, 한 페이지에 너무 많은 의도를 넣은 구조다.

## 1. 현재 유입 상태 — 추정이 아닌 실측

Search Console 실시간 속성 `sc-domain:radonverdict.com`을 2026-09-05에 확인했다.

| 기간 | 클릭 | 노출 | CTR | 평균 게재순위 |
|---|---:|---:|---:|---:|
| 최근 3개월, 2026-06-04~09-03 | 1 | 747 | 0.1% | 43.8 |
| 최근 28일, 2026-08-07~09-03 | 0 | 364 | 0% | 42.2 |
| 최근 7일, 2026-08-28~09-03 | 0 | 48 | 0% | 56.1 |

최근 28일은 사실상 자연검색 유입이 0이다. 하지만 노출이 0은 아니므로 도메인 전체가 제거되거나 수동 제재를 받은 상태는 아니다.

추가 확인 결과:

- 수동 조치: 없음
- 보안 문제: 없음
- 색인됨: 122 URL
- 색인되지 않음: 7,026 URL
  - 크롤링됨, 현재 색인되지 않음: 4,100
  - `noindex`로 제외: 2,643
  - 404: 167
  - 적절한 canonical이 있는 대체 페이지: 105
  - 리디렉션: 4
  - 발견됨, 현재 색인되지 않음: 7

이는 벌점 증거가 아니라 **과거 대량 발행 구조가 남긴 품질·크롤링 잔재**다. 현재 제출 sitemap은 29개 URL뿐인데 Google의 제외 기록은 7천 개가 넘는다. 방향은 축소로 바뀌었지만 Google이 보는 사이트 이력은 아직 정리되지 않았다.

## 2. Google이 이미 알려준 수요

### 실제로 매핑된 검색어

최근 3개월의 대표 검색어는 다음과 같다.

| 검색어 | 노출 | 평균순위 | 해석 |
|---|---:|---:|---|
| `radon gas testing ulster county ny` | 139 | 57.1 | 지역 서비스 의도. 현재 페이지 기능과 불일치 |
| `radon mitigation services ulster county ny` | 66 | 58.5 | 업체를 찾는 의도. 현 제품이 충족하지 못함 |
| `radon test results` | 13 | 97.4 | 결과 해석 수요는 있으나 권위 경쟁이 강함 |
| `where to place radon test kit` | 8 | 88.0 | 정확히 맞는 절차형 의도. 전용 답변 필요 |
| `radon testing instructions` | 7 | 71.4 | 현재 pillar가 관련성은 인정받았으나 경쟁력 부족 |

`site:radonverdict.com`은 실제 시장 수요가 아니므로 성과 계산에서 제외한다.

### 현재 pillar가 실패하는 방식

`/guides/how-to-test-for-radon`은 최근 28일 106노출, 0클릭, 평균 73.4위다. Google은 이 URL을 다음 의도에 이미 연결했다.

- radon test results
- where to place radon test kit
- radon testing instructions
- radon testing
- detect radon
- residential radon testing
- where do you put a radon test

따라서 문제는 발견이나 색인만이 아니다. 한 페이지가 장치 선택, 배치, 기간, 결과, 전문검사까지 모두 잡으려 하므로 각각의 검색에 가장 좋은 답이 되지 못한다. 출처가 약한 수치와 광범위한 단정도 신뢰를 떨어뜨린다.

### 지역 페이지가 보여주는 함정

Ulster County 페이지는 지역 검사·완화 서비스 검색에서 노출되지만, 실제로는 검사 업체 목록이나 예약·견적 기능을 제공하지 않는다. 검색자는 서비스 제공자를 원하고 페이지는 데이터와 일반 안내를 준다. 제목이나 본문을 더 최적화해도 의도 불일치는 해결되지 않는다.

Darke County 페이지의 최근 28일 평균순위 4.5도 성공으로 보면 안 된다. 확인 가능한 검색어는 `site:radonverdict.com`뿐이었고 나머지는 익명 처리됐다. page-level 노출 합계를 전체 속성 노출처럼 더하거나, `site:` 순위를 일반 검색 승리로 계산하지 않는다.

## 3. 수요와 난이도를 같이 본 공격 순서

Google Ads Keyword Planner의 미국·영어·최근 12개월 범위는 정확한 검색량이 아니라 넓은 band다. 따라서 시장 크기 확정치가 아니라 상대적 우선순위 신호로만 쓴다.

| 검색군 | 월 검색 band | SERP 장벽 | 도메인 적합성 | 결정 |
|---|---:|---|---|---|
| `radon test kit` | 100K–1M | 매우 높음, 쇼핑·정부·대형 매체 | 중간 | 직접 공략 보류 |
| `radon mitigation system` | 100K–1M | 높음, 업체·정부 | 낮음 | 직접 공략 제외 |
| `radon detector` / `radon test` | 10K–100K | 매우 높음 | 중간 | 권위 확보 전 보류 |
| `how long does radon test take` | 1K–10K | 중간 | 매우 높음 | 1순위 획득 페이지 |
| `radon levels chart` | 1K–10K | 높음, YMYL·정부 | 높음 | 도구형 결과 페이지로만 공략 |
| `radon mitigation system maintenance` | 100–1K | 낮음~중간 | 매우 높음 | 1순위 획득 페이지 |
| `radon manometer reading` | 100–1K | 낮음~중간 | 매우 높음 | 1순위 획득 페이지 |
| `how long do radon fans last` | 100–1K | 중간 | 높음 | 1순위 획득 페이지 |
| `radon fan noise` | 100–1K | 낮음~중간 | 높음 | 1순위 획득 페이지 |
| placement·windows·rain·mail 등 | 0–100 또는 10–100 | 낮음 | 매우 높음 | 독립 사업 페이지가 아닌 지원 cluster |

핵심은 큰 검색량 하나를 노리는 것이 아니다. **작지만 이길 수 있는 의도 묶음 여러 개에서 첫 클릭을 만들고, 그 신호로 더 큰 검색군에 올라가는 계단**을 만든다.

## 4. SERP 역설계 결과

### 넓은 검사 검색

`how to test for radon at home`, 결과 의미, 일반 검사법은 CDC·EPA·주정부·대형 건강기관이 강하다. 일반 설명문으로 이들을 이길 가능성은 낮다. RadonVerdict가 추가해야 할 가치는 요약이 아니라 다음과 같은 적용 기능이다.

- 사용자의 검사 종류와 기간에 맞는 단계 표시
- 배치 위치와 시작·종료 조건 기록
- 창문 개방, 장치 이동 등 유효성 사건 기록
- 결과를 다음 검사 또는 공식 안내로 연결

### 설치 후 운영 검색

maintenance, manometer, fan noise, fan life 검색 결과에는 EPA 외에도 지역 완화 업체, 얇은 FAQ, 공급업체, 포럼과 영상이 섞여 있다. 이 영역은 강한 전국 정보 브랜드가 완전히 장악하지 않았다. 또한 사용자의 질문이 구체적이라 한 페이지 한 의도로 답하기 쉽다.

RadonVerdict의 과거 `radon-fan-noise-troubleshooting` URL도 표본 SERP에 나타났다. 현재 운영 서버에서는 410이며, 새 `/guides/radon-fan-noise`도 배포 전이라 410이다. 즉 **과거 관련성 신호는 있지만 현재 받을 살아 있는 URL이 없다.** 새 URL 배포 후 이전 URL에서 301할지는 두 페이지의 의도·내용 대응성을 확인해 결정해야 한다. 대응성이 높다면 410을 유지하는 것보다 301로 과거 신호를 모으는 편이 낫다.

### 지역 서비스 검색

서비스 검색의 승자는 실제 업체, 지도·로컬팩, 디렉터리다. RadonVerdict가 업체 공급이나 예약 결과를 제공하지 않는 한 여기에 콘텐츠만 얹는 것은 잘못된 전장이다. 지역 공식 데이터 페이지는 `county radon levels/data`처럼 데이터 의도에 한정하고, 서비스 키워드를 제목·H1의 주 타깃으로 삼지 않는다.

## 5. 유입 포트폴리오

### Tier A — 배포 즉시 승부할 5개 검색군

1. `how long does radon test take`
2. `radon mitigation system maintenance`
3. `radon manometer reading`
4. `radon fan noise`
5. `how long do radon fans last`

각 페이지의 완료 조건:

- 한 URL에 하나의 주 검색 의도
- 첫 화면에 2~4문장의 직접 답변
- EPA/CDC 등 1차 출처를 주장 바로 옆에 연결
- 사용자가 실제로 할 수 있는 checklist 또는 입력 도구
- 위험한 수리·배선·팬 선정 지시 없음
- 관련 검색어를 억지로 본문에 반복하지 않음
- 기존 URL과 중복 의도 없음

### Tier B — pillar를 받치는 절차 cluster

- placement
- closed-house conditions
- windows open
- rain/storm
- moved device / invalid test
- charcoal vs digital
- mailing a kit
- testing in apartments
- when to retest
- post-mitigation test

이들은 각각의 검색량이 작아도 `how to test`와 `duration`의 주제 완성도를 높이고 실제 롱테일을 받는다. 단, 30~60일 안에 노출이 없는 페이지를 계속 장식하거나 확장하지 않는다. 허브에 합칠 수 있는 얇은 주제는 통합한다.

### Tier C — 신뢰가 쌓인 뒤 공격

- radon test results
- radon levels chart
- radon detector / monitor
- radon test kit

결과 관련 페이지는 단순 표가 아니라 검사 기간·조건을 함께 입력받아 공식 다음 단계를 보여주는 형태여야 한다. 제품 관련 head term은 실제 시험 없는 `best` 리뷰로 공략하지 않는다.

### 축소할 영역

- county service/mitigation intent 페이지
- 대량 county/ZIP 조합
- 같은 문장을 지역명만 바꾼 페이지
- 근거가 빈약한 cost estimate 페이지
- 하나의 검색어 변형마다 별도 URL을 만드는 방식

## 6. 기술적 유입 복구 순서

새로 만든 플래너와 20개 protocol guide는 현재 운영 sitemap에 없고 운영 URL도 410이므로 GSC 성과가 없는 것이 정상이다. 먼저 배포해야 평가 시계가 시작된다.

### 배포 당일

1. 운영 `sitemap.xml`이 현재 canonical  URL만 포함하는지 확인한다.
2. 새 가이드와 `/radon-test-planner`가 200, self-canonical, indexable인지 확인한다.
3. 과거 410 URL 중 새 페이지와 의도가 실질적으로 같은 것만 301 후보로 만든다.
4. `sitemap-cost-evidence.xml`은 빈 sitemap으로 남기지 말고 retired 상태를 명확히 한다. GSC에 남은 과거 직접 제출도 제거한다.
5. query parameter가 붙은 county URL은 현재처럼 기본 경로로 canonical을 고정한다.
6. 홈과 허브에서 Tier A까지 2~3클릭 이내로 연결한다.

### 왜 7천 개 잔재를 먼저 보는가

Google은 sitemap 제출만으로 색인이나 순위를 보장하지 않는다. sitemap에는 원하는 canonical URL만 넣고, 중복은 redirect/canonical로 통합해야 한다. 과거 URL을 robots.txt로 막으면 Google이 410·301·canonical 신호를 읽지 못할 수 있으므로, 현재처럼 응답을 크롤링 가능하게 유지한 채 상태를 명확히 하는 편이 맞다.

단, 7,026개가 0이 될 때까지 새 콘텐츠를 기다릴 필요는 없다. 새 5개 우선 URL의 발견·색인·검색어 매핑을 별도 cohort로 추적한다.

## 7. 30·60·90일 유입 판정표

아래 수치는 예측이 아니라 계속 투자할지 판단하기 위한 운영 기준이다. 기준선은 최근 28일 **364노출, 0클릭, 평균 42.2위**다.

### 0~14일 — 기술 통과

- Tier A 5개 모두 200/self-canonical/indexable
- 새 sitemap 정상 처리
- 5개 중 4개 이상 Google 발견 또는 크롤링
- 같은 주 검색어에 구 URL과 신 URL이 동시에 노출되지 않음

통과하지 못하면 글을 더 쓰지 않고 색인·redirect·내부링크 문제부터 수정한다.

### 15~30일 — 검색어 매핑

- Tier A 5개 중 3개 이상에 비브랜드 노출 발생
- 의도한 검색어가 의도한 URL에 연결
- 평균순위 50위 밖 검색어 중 적어도 2개가 30위권 진입
- `site:` 검색 노출은 성과에서 제외

### 31~60일 — 경쟁 가능성

- 세 개 이상의 검색군이 30위 이내
- 한 개 이상의 검색군이 10위 이내
- 최근 28일 비브랜드 노출 1,000 이상 또는 기준선 대비 3배
- 자연검색 클릭 최소 10

### 61~90일 — 회복 판정

**최소 생존선**

- 최근 28일 비브랜드 노출 1,000 이상
- 자연검색 클릭 10 이상
- 서로 다른 3개 검색군이 20위 이내

**계속 확장할 성공선**

- 최근 28일 비브랜드 노출 3,000 이상
- 자연검색 클릭 60 이상
- 5개 검색군이 20위 이내, 그중 2개 이상 10위 이내
- 상위 노출이 한 county나 `site:` 검색에 편중되지 않음

90일에도 Tier A 중 어느 검색군도 20위에 들지 못하고 클릭이 10 미만이면, 같은 라돈 주제에서 글 수를 더 늘리는 것은 중단한다. 그때는 외부 권위 확보, 다른 acquisition channel 또는 사이트 피벗 중 하나가 필요하다.

## 8. 매주 볼 대시보드

전체 숫자 하나보다 query family별로 본다.

| 지표 | 계산 규칙 | 목적 |
|---|---|---|
| 비브랜드 노출 | `site:`와 브랜드명 제외 | 실제 시장 발견 여부 |
| 비브랜드 클릭 | 동일 제외 | 유입 발생 여부 |
| Tier별 median position | 검색군별 대표 query | 한두 개 이상치 방지 |
| Top 10 / Top 20 query family 수 | 검색어 수가 아니라 의도 묶음 수 | 의미 있는 승리 측정 |
| intended URL match | 검색군→대표 URL 일치율 | cannibalization 탐지 |
| indexed priority URLs | Tier A/B만 별도 cohort | 7천 개 과거 잔재와 분리 |
| page CTR by position | 순위대별 비교 | 제목 문제와 순위 문제 분리 |

페이지별 노출 합계를 사이트 전체 노출로 더하지 않는다. 익명 query, 여러 URL, Search Console 집계 차이 때문에 과대 계산될 수 있다.

## 9. 지금 하지 않을 것

- 20개를 50개, 100개로 늘리기
- `radon test`와 `radon test kit` head term에 정면 승부
- 실업체 없이 `services near me`·county service 페이지 확대
- 검색량 0~100인 질문을 모두 별도 장문 페이지로 만들기
- 발행일만 갱신해 freshness를 가장하기
- 공식 문서를 재서술한 글을 original research로 포장하기
- 색인되지 않은 이유를 모두 YMYL 탓으로 돌리기

## 최종 권고

우선 5개의 Tier A와 그들을 지지하는 절차 cluster만 배포한다. 배포 전 상태에서는 새 전략의 성패를 판단할 데이터가 없다. 배포 후 90일 동안 query family 단위로 노출·순위·클릭을 측정하고, **글 수가 아니라 이길 수 있는 검색 의도 수**를 늘린다.

현재 데이터가 말하는 가장 중요한 사실은 이것이다.

> Google은 RadonVerdict를 라돈 검색에서 완전히 배제하지 않았다. 다만 지금까지 발견한 페이지를 사용자가 찾는 답으로 충분히 높게 평가하지 않았다. 살아날 수는 있지만, broad information site가 아니라 protocol-and-maintenance decision site로 좁혀야 한다.

## 근거 자료

- Google Search, 사람 우선 콘텐츠: https://developers.google.com/search/docs/fundamentals/creating-helpful-content
- Google Search, spam policies와 scaled content/doorway abuse: https://developers.google.com/search/docs/essentials/spam-policies
- Google Search, sitemap 작성: https://developers.google.com/search/docs/crawling-indexing/sitemaps/build-sitemap
- Google Search, 중복 URL 통합: https://developers.google.com/search/docs/crawling-indexing/consolidate-duplicate-urls
- Google Search, AI 검색 최적화 안내: https://developers.google.com/search/docs/fundamentals/ai-optimization-guide
- CDC, radon testing: https://www.cdc.gov/radon/testing/index.html
- EPA, mitigation system maintenance: https://www.epa.gov/radon/how-do-i-know-if-my-radon-mitigation-system-working-properly

