package com.radonverdict;

import com.radonverdict.model.County;
import com.radonverdict.service.DataLoadService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.servlet.MockMvc;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Locale;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
class PersuasionQualityAuditTest {

    private static final List<String> DISALLOWED_COPY_PATTERNS = List.of(
            "official estimate",
            "equivalent to smoking",
            "pack a day",
            "cigarettes per day",
            "below down");

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private DataLoadService dataLoadService;

    @Test
    void templateCopyGuardrailsBlockOverclaimAndFearPatterns() throws IOException {
        List<Path> targets = List.of(
                Paths.get("src/main/jte/components/receipt_card.jte"),
                Paths.get("src/main/jte/components/radon_level_advisor.jte"),
                Paths.get("src/main/jte/radon_levels_county.jte"),
                Paths.get("src/main/jte/county_hub.jte"));

        List<String> violations = new ArrayList<>();
        for (Path target : targets) {
            String content = Files.readString(target).toLowerCase(Locale.ROOT);
            for (String banned : DISALLOWED_COPY_PATTERNS) {
                if (content.contains(banned)) {
                    violations.add(target + " contains disallowed copy: '" + banned + "'");
                }
            }
        }

        assertThat(violations).isEmpty();
    }

    @Test
    void countyHubPagesMeetPersuasionRubric() throws Exception {
        List<String> failures = new ArrayList<>();
        for (County county : sampleCounties(12)) {
            String path = "/radon-mitigation-cost/" + county.getStateSlug() + "/" + county.getCountySlug();
            String html = mockMvc.perform(get(path))
                    .andExpect(status().isOk())
                    .andReturn()
                    .getResponse()
                    .getContentAsString();

            RubricScore score = scoreCountyHub(html);
            if (score.total() < 82 || !score.criticalFindings().isEmpty()) {
                failures.add(path + " => " + score.breakdown());
            }
        }

        assertThat(failures)
                .as("County hub persuasion rubric regressions")
                .isEmpty();
    }

    @Test
    void radonLevelsPagesMeetNumericClarityRubric() throws Exception {
        List<String> failures = new ArrayList<>();
        for (County county : sampleCounties(12)) {
            String path = "/radon-levels/" + county.getStateSlug() + "/" + county.getCountySlug();
            String html = mockMvc.perform(get(path))
                    .andExpect(status().isOk())
                    .andReturn()
                    .getResponse()
                    .getContentAsString();

            RubricScore score = scoreRadonLevels(html);
            if (score.total() < 80 || !score.criticalFindings().isEmpty()) {
                failures.add(path + " => " + score.breakdown());
            }
        }

        assertThat(failures)
                .as("Radon levels numeric-clarity rubric regressions")
                .isEmpty();
    }

    private List<County> sampleCounties(int max) {
        return dataLoadService.getCountyBySlugMap().values().stream()
                .filter(county -> county.getEpaZone() > 0)
                .filter(county -> county.getStats() != null && county.getStats().getMetrics() != null)
                .sorted(Comparator.comparing(county -> county.getStateSlug() + "/" + county.getCountySlug()))
                .limit(max)
                .toList();
    }

    private RubricScore scoreCountyHub(String html) {
        String normalized = normalize(html);
        List<String> critical = findCriticalPatterns(normalized);

        int claimHonesty = 0;
        if (normalized.contains("estimated local range")) {
            claimHonesty += 12;
        }
        if (normalized.contains("range:")) {
            claimHonesty += 8;
        }
        if (!normalized.contains("official estimate")) {
            claimHonesty += 5;
        }

        int numericContext = 0;
        if (normalized.contains("actual quotes vary by home conditions and local labor")) {
            numericContext += 15;
        }
        if (normalized.contains("prices are dynamically adjusted for local market multipliers")) {
            numericContext += 10;
        }

        int evidence = 0;
        if (normalized.contains("sources & methodology")) {
            evidence += 10;
        }
        if (normalized.contains("important disclaimers")) {
            evidence += 5;
        }
        if (normalized.contains("not medical advice")) {
            evidence += 5;
        }
        if (normalized.contains("https://www.epa.gov/radon")) {
            evidence += 5;
        }

        int actionability = 0;
        if (normalized.contains("send my local action plan")) {
            actionability += 10;
        }
        if (normalized.contains("clear next steps")) {
            actionability += 8;
        }
        if (normalized.contains("no obligation")) {
            actionability += 7;
        }

        return new RubricScore(claimHonesty, numericContext, evidence, actionability, critical);
    }

    private RubricScore scoreRadonLevels(String html) {
        String normalized = normalize(html);
        List<String> critical = findCriticalPatterns(normalized);

        int claimHonesty = 0;
        if (!normalized.contains("equivalent to smoking")) {
            claimHonesty += 10;
        }
        if (!normalized.contains("pack a day")) {
            claimHonesty += 8;
        }
        if (!normalized.contains("cigarettes per day")) {
            claimHonesty += 7;
        }

        int numericContext = 0;
        if (normalized.contains("below 4.0 pci/l")) {
            numericContext += 8;
        }
        if (normalized.contains("above 4.0")) {
            numericContext += 8;
        }
        if (normalized.contains("confirmatory testing") || normalized.contains("confirmatory long-term test")) {
            numericContext += 9;
        }

        int evidence = 0;
        if (normalized.contains("sources & methodology")) {
            evidence += 8;
        }
        if (normalized.contains("https://www.epa.gov/radon/epa-map-radon-zones")) {
            evidence += 6;
        }
        if (normalized.contains("https://www.epa.gov/radon")) {
            evidence += 6;
        }
        if (normalized.contains("who handbook on indoor radon")) {
            evidence += 5;
        }

        int actionability = 0;
        if (normalized.contains("how to test for radon")) {
            actionability += 8;
        }
        if (normalized.contains("get mitigation cost estimate")) {
            actionability += 10;
        }
        if (normalized.contains("testing is the only reliable method")) {
            actionability += 7;
        }

        return new RubricScore(claimHonesty, numericContext, evidence, actionability, critical);
    }

    private List<String> findCriticalPatterns(String normalizedHtml) {
        List<String> findings = new ArrayList<>();
        for (String banned : DISALLOWED_COPY_PATTERNS) {
            if (normalizedHtml.contains(banned)) {
                findings.add("contains banned phrase: " + banned);
            }
        }
        return findings;
    }

    private String normalize(String html) {
        return html.toLowerCase(Locale.ROOT).replaceAll("\\s+", " ");
    }

    private record RubricScore(
            int claimHonesty,
            int numericContext,
            int evidence,
            int actionability,
            List<String> criticalFindings) {

        int total() {
            return claimHonesty + numericContext + evidence + actionability;
        }

        String breakdown() {
            return "total=" + total()
                    + " (claimHonesty=" + claimHonesty
                    + ", numericContext=" + numericContext
                    + ", evidence=" + evidence
                    + ", actionability=" + actionability
                    + ", critical=" + criticalFindings + ")";
        }
    }
}
