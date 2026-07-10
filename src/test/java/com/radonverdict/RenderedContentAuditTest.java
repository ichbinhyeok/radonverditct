package com.radonverdict;

import com.radonverdict.model.County;
import com.radonverdict.model.dto.CountyPageContent;
import com.radonverdict.service.ContentGenerationService;
import com.radonverdict.service.DataLoadService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.regex.Pattern;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
class RenderedContentAuditTest {

    private static final Pattern SPACE = Pattern.compile("\\s+");

    @Autowired
    private DataLoadService dataLoadService;

    @Autowired
    private ContentGenerationService contentGenerationService;

    @Test
    void allCountyCostPagesHaveLocalEvidenceAndStructuralVariation() {
        List<County> counties = dataLoadService.getCountyBySlugMap().values().stream()
                .filter(county -> county.getEpaZone() > 0)
                .filter(county -> county.getStats() != null && county.getStats().getMetrics() != null)
                .toList();

        Map<String, Integer> structuralCohorts = new HashMap<>();
        int localEvidencePages = 0;
        int deepPages = 0;
        int totalWords = 0;

        for (County county : counties) {
            CountyPageContent page = contentGenerationService.buildCostLandingPageContent(county);
            String renderedContent = contentText(page);
            structuralCohorts.merge(structuralFingerprint(county, renderedContent), 1, Integer::sum);
            if (page.getLocalInsights() != null && page.getLocalInsights().size() >= 4) {
                localEvidencePages++;
            }
            if (wordCount(renderedContent) >= 180) {
                deepPages++;
            }
            totalWords += wordCount(renderedContent);
        }

        int largestCohort = structuralCohorts.values().stream().mapToInt(Integer::intValue).max().orElse(0);
        double evidenceRate = counties.isEmpty() ? 0.0 : localEvidencePages / (double) counties.size();
        double deepRate = counties.isEmpty() ? 0.0 : deepPages / (double) counties.size();
        double distinctRate = counties.isEmpty() ? 0.0 : structuralCohorts.size() / (double) counties.size();

        System.out.printf(Locale.US,
                "RENDERED_AUDIT pages=%d avgWords=%.1f evidenceRate=%.3f deepRate=%.3f distinctRate=%.3f largestCohort=%d%n",
                counties.size(), counties.isEmpty() ? 0.0 : totalWords / (double) counties.size(),
                evidenceRate, deepRate, distinctRate, largestCohort);

        assertThat(counties).isNotEmpty();
        assertThat(evidenceRate).as("county pages with local evidence blocks").isGreaterThanOrEqualTo(0.90);
        assertThat(deepRate).as("county pages with meaningful content depth").isGreaterThanOrEqualTo(0.90);
        assertThat(distinctRate).as("structurally distinct county page signatures").isGreaterThanOrEqualTo(0.10);
        assertThat(largestCohort).as("largest normalized content cohort").isLessThan(600);
    }

    private String contentText(CountyPageContent page) {
        StringBuilder text = new StringBuilder();
        append(text, page.getHeroSummary());
        append(text, page.getPricingRationale());
        append(text, page.getRiskNarrative());
        append(text, page.getLocalInsights());
        append(text, page.getIntentIntro());
        append(text, page.getIntentSteps());
        append(text, page.getIntentProTip());
        append(text, page.getFoundationCostContext());
        append(text, page.getFoundationNegotiationNote());
        append(text, page.getDisclosureSummary());
        append(text, page.getLicenseNote());
        if (page.getFaqs() != null) {
            page.getFaqs().forEach(faq -> {
                append(text, faq.getQuestion());
                append(text, faq.getAnswer());
            });
        }
        return text.toString();
    }

    private void append(StringBuilder target, String value) {
        if (value != null) {
            target.append(value).append(' ');
        }
    }

    private void append(StringBuilder target, List<String> values) {
        if (values != null) {
            values.forEach(value -> append(target, value));
        }
    }

    private String structuralFingerprint(County county, String content) {
        String normalized = content.toLowerCase(Locale.ROOT)
                .replace(county.getAreaDisplayName().toLowerCase(Locale.ROOT), "local area")
                .replace(county.getCountyName().toLowerCase(Locale.ROOT), "local area")
                .replace(county.getStateAbbr().toLowerCase(Locale.ROOT), "state")
                .replaceAll("https?://\\S+", "source")
                .replaceAll("[0-9][0-9,]*(?:\\.[0-9]+)?%?", "value")
                .replaceAll("[^a-z ]", " ");
        return SPACE.matcher(normalized).replaceAll(" ").trim();
    }

    private int wordCount(String value) {
        return value.isBlank() ? 0 : value.trim().split("\\s+").length;
    }
}
