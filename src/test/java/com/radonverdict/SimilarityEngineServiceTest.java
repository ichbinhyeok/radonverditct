package com.radonverdict;

import com.radonverdict.model.County;
import com.radonverdict.model.dto.ItemizedReceipt;
import com.radonverdict.model.dto.SimilarityAssessment;
import com.radonverdict.service.DataLoadService;
import com.radonverdict.service.SimilarityEngineService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.lang.reflect.Method;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
class SimilarityEngineServiceTest {

    @Autowired
    private SimilarityEngineService similarityEngineService;

    @Autowired
    private DataLoadService dataLoadService;

    @Test
    void assessmentHasStableFingerprintAndBoundedScore() {
        County county = dataLoadService.getCountyBySlugMap().values().stream()
                .filter(c -> c.getStats() != null && c.getStats().getMetrics() != null)
                .findFirst()
                .orElseThrow();

        ItemizedReceipt receipt = ItemizedReceipt.builder()
                .totalAvg(1200)
                .countyName(county.getCountyName())
                .stateAbbr(county.getStateAbbr())
                .build();

        SimilarityAssessment assessment = similarityEngineService.assessMitigationPage(county, receipt);
        SimilarityAssessment assessment2 = similarityEngineService.assessMitigationPage(county, receipt);

        assertThat(assessment.getFingerprint()).isNotBlank();
        assertThat(assessment.getCohortSize()).isGreaterThan(0);
        assertThat(assessment.getUniquenessScore()).isBetween(0, 100);
        assertThat(assessment2.getFingerprint()).isEqualTo(assessment.getFingerprint());
        assertThat(assessment2.getCohortSize()).isEqualTo(assessment.getCohortSize());
    }

    @Test
    void differentiationNarrativesExcludeInternalSimilarityDiagnostics() {
        County county = dataLoadService.getCountyBySlugMap().values().stream()
                .filter(c -> c.getStats() != null && c.getStats().getMetrics() != null)
                .findFirst()
                .orElseThrow();

        ItemizedReceipt receipt = ItemizedReceipt.builder()
                .totalAvg(1300)
                .countyName(county.getCountyName())
                .stateAbbr(county.getStateAbbr())
                .build();

        SimilarityAssessment assessment = similarityEngineService.assessMitigationPage(county, receipt);
        List<String> lines = similarityEngineService.buildDifferentiationNarratives(county, receipt, assessment);
        String narrative = String.join(" ", lines);

        assertThat(lines).isNotEmpty();
        assertThat(narrative).contains("percentile");
        assertThat(narrative).doesNotContain("Similarity cohort size");
        assertThat(narrative).doesNotContain("Uniqueness score");
        assertThat(narrative).doesNotContain("fingerprint");
    }

    @Test
    void ordinalPercentilesUseCorrectEnglishSuffixes() throws Exception {
        Method method = SimilarityEngineService.class.getDeclaredMethod("formatPercentile", int.class);
        method.setAccessible(true);

        assertThat(method.invoke(similarityEngineService, 1)).isEqualTo("1st");
        assertThat(method.invoke(similarityEngineService, 2)).isEqualTo("2nd");
        assertThat(method.invoke(similarityEngineService, 3)).isEqualTo("3rd");
        assertThat(method.invoke(similarityEngineService, 4)).isEqualTo("4th");
        assertThat(method.invoke(similarityEngineService, 11)).isEqualTo("11th");
        assertThat(method.invoke(similarityEngineService, 12)).isEqualTo("12th");
        assertThat(method.invoke(similarityEngineService, 13)).isEqualTo("13th");
        assertThat(method.invoke(similarityEngineService, 22)).isEqualTo("22nd");
        assertThat(method.invoke(similarityEngineService, 23)).isEqualTo("23rd");
    }
}
