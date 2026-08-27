# RadonVerdict — Evidence-First SEO Recovery Pivot

상태: IMPLEMENTED — verification in progress, deployment pending
작성일: 2026-08-27
기준 브랜치: `master`
대체 문서: `14_handoff_product_pivot.md`의 primary-distribution 가설

## 1. 결정

RadonVerdict의 주 제품을 인스펙터 handoff SaaS가 아니라 **라돈 검사 결과 해석 + 공식 기준 + 출처가 보존된 지역 근거**로 재정의한다. `/plan`과 private share는 검색 여정 이후의 보조 기능으로 유지하고, 인스펙터 페이지는 `noindex` 처리한다.

## 2. 왜 이전 피벗이 살아나지 않았는가

- 초기 클릭은 많은 URL에 얕게 분산돼 반복 수요를 증명하지 못했다.
- county/cost 문서는 검색어를 포함했지만 실제 견적 표본, 저자 권위, 독점 local data가 없었다.
- 인스펙터 handoff는 제품 가설은 더 명확했지만 기존 유입 채널도 고객 검증도 없어서 SEO 회복 수단이 아니었다.
- 검색자가 묻는 것은 “내 숫자의 의미”, “EPA zone”, “이 지역에서 어떻게 검사하는가”인데 홈은 도구와 공유 흐름을 먼저 설명했다.
- state hub, modeled cost, 대량 intent URL은 검색 품질보다 URL 수를 늘렸다.

## 3. 근거

로컬 Search Console export에서 확인한 신호:

- Schenectady County EPA radon zone
- Fremont County, Idaho EPA radon zone
- Falls Church, Virginia basement radon level
- Ulster County, New York radon testing
- Powhatan, Broomfield, Bernalillo의 testing intent
- Los Angeles commercial radon testing

이 신호는 URL을 대량 복구할 근거가 아니다. 해당 질문에 source-backed answer를 제공할 **작은 관찰 코호트**의 근거다.

공식 답변 경계:

- EPA는 4.0 pCi/L 이상에서 수리를 권고하고 2.0–4.0 pCi/L에서도 수리를 고려할 수 있다고 안내한다.
- EPA zone은 county의 예측 잠재력이며 개별 주택의 측정값이 아니다.
- county 평균과 제출 검사 비율은 표본·기간·제외 규칙을 함께 표시해야 한다.

## 4. 검색 정보구조

```text
/
├─ /radon-test-result-meaning       결과 해석 pillar
├─ /radon-levels                    controlled county evidence hub
│  └─ /radon-levels/{state}/{county}
├─ /radon-testing/{state}/{county}  observed testing-intent cohort
├─ /commercial-radon-testing/...    observed commercial-intent cohort
├─ /radon-data-sources              dataset + evidence policy
└─ /guides/how-to-test-for-radon    testing method support

/plan, /plan/share/*, /for-home-inspectors
└─ product utility; no sitemap, noindex where appropriate
```

## 5. 공개 코호트

County evidence는 historical click, 현재 GSC query, intent child의 parent evidence 조건 중 하나와 base-quality eligibility를 모두 통과해야 한다. 현재 최대 12개 경로로 제한한다.

- Marion FL, Gloucester NJ, Indiana PA, Rutland VT
- Ulster NY, Schenectady NY, Fremont ID, Falls Church VA
- Powhatan VA, Broomfield CO, Bernalillo NM, Los Angeles CA

Intent pages:

- testing: Ulster, Powhatan, Broomfield, Bernalillo
- commercial testing: Los Angeles

새 지역은 키워드만으로 추가하지 않는다. query trace와 공식 지역 근거를 모두 요구한다.

## 6. 폐기·격리

- modeled county cost, credit, quote/lead surfaces: `410`
- state hub와 비코호트 county page: `410`
- 비코호트 testing/commercial intent: `404`
- inspector landing: 기능 유지, `noindex`, sitemap 제외
- broad zone/cost sitemap: main sitemap에서 제외

## 7. 페이지 품질 계약

각 indexable page는 다음을 충족한다.

1. query와 일치하는 단일 H1/title
2. 첫 화면 또는 첫 문단의 직접 답변
3. official source URL, source name, reporting period
4. aggregate가 개별 주택을 증명하지 못한다는 caveat
5. result meaning → testing → local evidence의 자연스러운 internal link
6. modeled local price와 검증되지 않은 업체 추천 없음
7. FAQ/데이터셋 등 보이는 내용과 일치하는 구조화 데이터만 사용

## 8. 구현 결과

- 홈을 evidence-first editorial landing으로 재작성하고 결과 해석을 primary CTA로 배치했다.
- 공공보건 리서치 데스크 톤의 original hero asset을 추가했다.
- result interpreter에 FAQPage schema, 최신 EPA action-level source, 검토일과 독립 프로젝트 고지를 추가했다.
- data sources에서 폐기된 cost report와 cost/credit 서술을 제거하고 Dataset distribution을 유지했다.
- county evidence 12개와 intent 5개만 main sitemap에서 참조한다.
- county sitemap의 search-traffic page 누락 필터를 제거하고 `sitemap-county-evidence.xml`로 이름을 명확히 했다. 이전 별칭은 호환성을 위해 유지한다.
- inspector landing은 `noindex`이며 core sitemap에서 제외했다.

## 9. 성공/실패 판정

배포 후 8–12주 동안 URL별로 본다.

- result interpreter: non-brand impressions, CTR, top-20 query 수
- evidence cohort: indexed 상태, query-to-page 일치, 평균 위치와 클릭
- intent cohort: 해당 지역 testing/commercial query의 노출과 engagement
- dataset: 다운로드 및 source-page 유입

확장 조건은 동일 패턴에서 반복 impression/click과 source-backed answer가 함께 나타나는 것이다. 8–12주 뒤에도 indexation과 query match가 회복되지 않으면 county 확장이 아니라 브랜드/권위/링크 획득 문제로 판정한다.

## 10. 아직 증명되지 않은 것

- 배포 후 Google 재평가와 순위 회복
- credentialed radon professional의 외부 검토
- Search Console Manual Actions/Security Issues 화면 상태
- backlink와 crawl-log 기반 원인 확정

따라서 이번 작업은 “회복 완료”가 아니라 **검색엔진이 재평가할 수 있는 일관된 제품·콘텐츠·인덱싱 계약을 만든 상태**다.
