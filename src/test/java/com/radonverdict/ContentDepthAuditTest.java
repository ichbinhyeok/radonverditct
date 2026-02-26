package com.radonverdict;

import com.radonverdict.model.County;
import com.radonverdict.service.DataLoadService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.servlet.MockMvc;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Random;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
class ContentDepthAuditTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private DataLoadService dataLoadService;

    @Test
    void auditMitigationPageDepthAndUniqueness() throws Exception {
        List<County> candidates = dataLoadService.getCountyBySlugMap().values().stream()
                .filter(c -> c.getEpaZone() > 0)
                .filter(c -> c.getStats() != null && c.getStats().getMetrics() != null)
                .sorted(Comparator.comparing(c -> c.getStateSlug() + "/" + c.getCountySlug()))
                .toList();

        List<County> shuffled = new ArrayList<>(candidates);
        Collections.shuffle(shuffled, new Random(42));
        List<County> sample = shuffled.stream().limit(24).toList();

        List<String> texts = new ArrayList<>();
        int totalWords = 0;
        int municipioCountyHits = 0;
        int localInsightSectionHits = 0;

        for (County county : sample) {
            String path = "/radon-mitigation-cost/" + county.getStateSlug() + "/" + county.getCountySlug();
            String html = mockMvc.perform(get(path))
                    .andExpect(status().isOk())
                    .andReturn()
                    .getResponse()
                    .getContentAsString();

            if (html.contains("Local Insight:")) {
                localInsightSectionHits++;
            }
            if (html.contains("Municipio County")) {
                municipioCountyHits++;
            }

            String text = extractVisibleText(html);
            texts.add(text);
            totalWords += countWords(text);
        }

        double avgWords = totalWords / (double) sample.size();
        double avgJaccard = averagePairwiseJaccard(texts);

        System.out.println("AUDIT_SAMPLE=" + sample.size());
        System.out.println(String.format(Locale.US, "AUDIT_AVG_WORDS=%.2f", avgWords));
        System.out.println(String.format(Locale.US, "AUDIT_AVG_PAIRWISE_JACCARD=%.2f", avgJaccard));
        System.out.println("AUDIT_LOCAL_INSIGHT_HITS=" + localInsightSectionHits);
        System.out.println("AUDIT_MUNICIPIO_COUNTY_HITS=" + municipioCountyHits);

        assertThat(avgWords).isGreaterThan(1500.0);
        assertThat(avgJaccard).isLessThan(90.0);
        assertThat(localInsightSectionHits).isEqualTo(sample.size());
        assertThat(municipioCountyHits).isEqualTo(0);
    }

    private String extractVisibleText(String html) {
        String noScript = html.replaceAll("(?is)<script.*?>.*?</script>", " ");
        String noStyle = noScript.replaceAll("(?is)<style.*?>.*?</style>", " ");
        String noTags = noStyle.replaceAll("(?is)<[^>]+>", " ");
        return noTags.replaceAll("\\s+", " ").trim();
    }

    private int countWords(String text) {
        Matcher matcher = Pattern.compile("[A-Za-z]{2,}").matcher(text);
        int count = 0;
        while (matcher.find()) {
            count++;
        }
        return count;
    }

    private double averagePairwiseJaccard(List<String> texts) {
        List<Set<String>> sets = texts.stream()
                .map(this::wordSet)
                .toList();

        double sum = 0;
        int pairs = 0;
        for (int i = 0; i < sets.size(); i++) {
            for (int j = i + 1; j < sets.size(); j++) {
                sum += jaccard(sets.get(i), sets.get(j));
                pairs++;
            }
        }
        return pairs == 0 ? 0 : sum / pairs;
    }

    private Set<String> wordSet(String text) {
        Matcher matcher = Pattern.compile("[A-Za-z]{3,}").matcher(text.toLowerCase(Locale.ROOT));
        Set<String> set = new HashSet<>();
        while (matcher.find()) {
            set.add(matcher.group());
        }
        return set;
    }

    private double jaccard(Set<String> left, Set<String> right) {
        Set<String> intersection = new HashSet<>(left);
        intersection.retainAll(right);
        Set<String> union = new HashSet<>(left);
        union.addAll(right);
        if (union.isEmpty()) {
            return 0;
        }
        return (intersection.size() * 100.0) / union.size();
    }
}
