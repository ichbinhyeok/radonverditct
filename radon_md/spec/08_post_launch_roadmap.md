# Post-Deployment Tech Debt & Growth Roadmap (ETA: 2 Months+)

이 문서는 2달 간의 안정화 배포 이후, 프로젝트 복귀 시 우선적으로 처리해야 할 **고수익/고신뢰도 SEO 아키텍처 개선안**을 기록합니다.
현재 배포판에서 이 작업들을 제외한 이유는 **데이터 파이프라인 전체를 뜯어고쳐야 하므로 발생하는 치명적인 버그(예: 계산기 0달러 출력, 404 라우팅 에러 등) 리스크를 최소화**하기 위함입니다.

---

## 1. 지역별 행정구역 명칭 결함 (Borough, Parish 완벽 지원)

*   **현재 상태:** 모든 JTE 템플릿과 URL 라우팅이 지역명 끝에 무조건 `County`라는 Suffix(예: Anchorage County)를 강제하고 있음.
*   **문제점:**
    *   알래스카는 `Borough` / `Municipality`, 루이지애나는 `Parish`를 사용.
    *   실제 지역 주민들은 절대 "Anchorage County"라고 검색하지 않으므로, **로컬 SEO의 치명적 누수** 발생. 구글 YMYL 퀄리티 평가자가 볼 때 전형적인 "자동 생산(pSEO) 스팸"으로 간주할 핵심 단서임.
*   **복귀 후 Action Items:**
    1.  `scripts/generate_geo_counties.ps1` 또는 `geo_counties.json` 파이프라인 수정:
        *   새로운 필드 `county_type` (Enum: COUNTY, PARISH, BOROUGH, MUNICIPALITY) 또는 완성형 `displayName` 필드 추가.
    2.  `County.java` 모델 업데이트 (해당 필드 겟터/세터 추가).
    3.  `radon_levels_county.jte`, `radon_levels_state.jte`, `lead_form.jte` 등 모든 `{countyName} County` 하드코딩 부분들을 `{county.getDisplayName()}`으로 치환.

## 2. 주 단위 보정치 → 카운티 단위 노동비(Labor Rate) 고도화

*   **현재 상태:** `PricingCalculatorService.java`는 State-level multipliers(주 단위 보정치)만 사용함. 그러나 카피라이팅에서는 "Local/County specific labor rates"로 과대 포장했다가 이번 배포에서 "Regional"로 한발 물러남.
*   **문제점:** "실제 내 동네 데이터"가 없는 두루뭉술한 견적은 경쟁력(전환율)이 떨어짐.
*   **복귀 후 Action Items:**
    1.  BLS (US Bureau of Labor Statistics) 데이터 등에서 카운티 단위(또는 MSA 권역 단위)의 실제 임금 지수 데이터 테이블 확보.
    2.  `pricing_config.json` 구조를 개편하여 기존 `regionalMultipliers` (State 기반)를 `msaMultipliers` 또는 5자리 `zipcodeMultipliers` 체계로 전환.
    3.  `PricingCalculatorService.java`의 계산 로직 뜯어고치기.
    4.  계산 신뢰도가 높아짐을 바탕으로 사이트 전체의 "Regional" 카피를 다시 "Hyper-local, County-specific"으로 롤백.

## 3. SEO 인덱스 방어 (Crawl Budget 최적화)
*   **현재 상태:** `ContentGenerationService.java`에서 `TotalHousingUnits > 0`인 곳만 색인시키게 퀄리티 게이트를 달아둔 상태임.
*   **복귀 후 Action Items:**
    *   서치 콘솔(GSC) 데이터를 분석하여 "의미 없는 유령 카운티 페이지들이 여전히 구글 봇 예산을 좀먹고 있는지" 확인.
    *   주택 수 기준 컷오프를 높이거나 (예: 1,000세대 이하 버림), 인구 데이터 등을 추가 교차 검증하여 pSEO 대상 3,000개 카운티 중 핵심 타겟 카운티만 남기는 다이어트 작업 필요.
