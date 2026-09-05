package com.radonverdict;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.radonverdict.service.TestProtocolGuideCatalog;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.servlet.MockMvc;

import java.util.List;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;

@SpringBootTest(properties = {
        "app.site.enforce-canonical-host=false",
        "app.product.legacy-surfaces-enabled=false"
})
@AutoConfigureMockMvc
class TestProtocolGuideIntegrationTest {

    private static final Pattern JSON_LD = Pattern.compile(
            "<script type=\"application/ld\\+json\">(.*?)</script>", Pattern.DOTALL);

    @Autowired MockMvc mockMvc;
    @Autowired ObjectMapper objectMapper;
    @Autowired TestProtocolGuideCatalog catalog;

    @Test
    void everyProtocolGuideIsIndexableCanonicalSubstantiveAndSourceLinked() throws Exception {
        Set<String> directAnswers = new java.util.HashSet<>();
        for (String path : protocolPaths()) {
            var response = mockMvc.perform(get(path)).andReturn().getResponse();
            assertThat(response.getStatus()).as(path).isEqualTo(200);
            String html = response.getContentAsString();

            assertThat(html).contains("<link rel=\"canonical\" href=\"https://radonverdict.com" + path + "\">");
            assertThat(html).doesNotContain("<meta name=\"robots\" content=\"noindex");
            assertThat(html).contains("href=\"/radon-test-planner\"");
            assertThat(html).containsAnyOf("U.S. Environmental Protection Agency", "Centers for Disease Control and Prevention", "Michigan Department of Environment")
                    .contains("Built from the official primary guidance")
                    .contains("Reviewed September 5, 2026");
            assertThat(html).contains("<script src=\"/js/seo-decision-tools.js\" defer></script>");
            assertThat(html)
                    .contains("\"@type\":\"Article\"")
                    .contains("id=\"protocol-record-form\"")
                    .contains("data-guide-title=\"" + catalog.find(path.substring("/guides/".length())).title() + "\"")
                    .contains("id=\"protocol-record-progress\"")
                    .contains("Create a copyable summary");
            assertThat(html).doesNotContain("Credentialed external review not yet completed");
            assertThat(stripMarkup(html).split("\\s+").length).as("substantive word count for " + path).isGreaterThan(450);

            Matcher matcher = JSON_LD.matcher(html);
            assertThat(matcher.find()).isTrue();
            boolean foundFaq = false;
            do {
                var jsonLd = objectMapper.readTree(matcher.group(1).trim());
                if ("FAQPage".equals(jsonLd.path("@type").asText())) {
                    assertThat(jsonLd.path("mainEntity").size()).isGreaterThanOrEqualTo(3);
                    foundFaq = true;
                }
            } while (matcher.find());
            assertThat(foundFaq).isTrue();

            Matcher answer = Pattern.compile("Direct answer</p>\\s*<p[^>]*>(.*?)</p>", Pattern.DOTALL).matcher(html);
            assertThat(answer.find()).isTrue();
            assertThat(directAnswers.add(stripMarkup(answer.group(1)))).as("unique direct answer for " + path).isTrue();
        }
    }

    @Test
    void priorityGuidesExposeSerpSpecificDecisionTools() throws Exception {
        String duration = mockMvc.perform(get("/guides/short-term-vs-long-term-radon-test"))
                .andReturn().getResponse().getContentAsString();
        assertThat(duration)
                .contains("How Long Does a Radon Test Take?")
                .contains("Start-to-result timeline")
                .contains("Exposure time is not the full results timeline")
                .contains("id=\"radon-result-timeline-form\"");

        String manometer = mockMvc.perform(get("/guides/radon-manometer-reading"))
                .andReturn().getResponse().getContentAsString();
        assertThat(manometer)
                .contains("Ten-second visual check")
                .contains("Uneven, near the mark")
                .contains("Equal or zero")
                .contains("Changed or damaged")
                .contains("id=\"manometer-baseline-form\"");

        String maintenance = mockMvc.perform(get("/guides/radon-mitigation-system-maintenance"))
                .andReturn().getResponse().getContentAsString();
        assertThat(maintenance)
                .contains("Owner maintenance calendar")
                .contains("At least every 2 years")
                .contains("EPA says to check it regularly");

        String fanNoise = mockMvc.perform(get("/guides/radon-fan-noise"))
                .andReturn().getResponse().getContentAsString();
        assertThat(fanNoise)
                .contains("Two-minute observation record")
                .contains("Describe the change without guessing the repair")
                .contains("System indicator")
                .contains("Identification")
                .contains("id=\"fan-noise-observation-form\"");

        String fanLife = mockMvc.perform(get("/guides/how-long-do-radon-fans-last"))
                .andReturn().getResponse().getContentAsString();
        assertThat(fanLife)
                .contains("Service-life record")
                .contains("Age is one fact")
                .contains("Identify")
                .contains("Verify");
    }

    @Test
    void legacyFanNoiseUrlConsolidatesIntoThePriorityCanonical() throws Exception {
        var response = mockMvc.perform(get("/guides/radon-fan-noise-troubleshooting"))
                .andReturn().getResponse();
        assertThat(response.getStatus()).isEqualTo(301);
        assertThat(response.getHeader("Location")).isEqualTo("/guides/radon-fan-noise");
    }

    @Test
    void coreSitemapAndPillarExposeTheCompleteProtocolCluster() throws Exception {
        String sitemap = mockMvc.perform(get("/sitemap-core.xml")).andReturn().getResponse().getContentAsString();
        String hub = mockMvc.perform(get("/guides")).andReturn().getResponse().getContentAsString();
        String home = mockMvc.perform(get("/")).andReturn().getResponse().getContentAsString();
        assertThat(hub).contains(">20</p>").contains("indexable problem pages");
        for (var guide : catalog.acquisitionPriority()) {
            assertThat(hub).contains("href=\"/guides/" + guide.slug() + "\"");
            assertThat(home).contains("href=\"/guides/" + guide.slug() + "\"");
            assertThat(countOccurrences(sitemap, "<loc>https://radonverdict.com/guides/" + guide.slug() + "</loc>"))
                    .as("one sitemap entry for " + guide.slug()).isEqualTo(1);
        }
        for (String path : protocolPaths()) {
            assertThat(sitemap).contains("<loc>https://radonverdict.com" + path + "</loc>");
            assertThat(hub).contains("href=\"" + path + "\"");
        }
    }

    @Test
    void testingPillarUsesAReviewableWorkflowWithoutUnsupportedCommercialShortcuts() throws Exception {
        String html = mockMvc.perform(get("/guides/how-to-test-for-radon"))
                .andReturn().getResponse().getContentAsString();

        assertThat(html)
                .contains("One test does not serve every context")
                .contains("Run a test someone else can review")
                .contains("Do not reconstruct the test from memory")
                .contains("2 to 90 days; device instructions set the exact window")
                .contains("https://www.cdc.gov/radon/testing/index.html")
                .contains("https://www.epa.gov/sites/default/files/2016-12/documents/2016_a_citizens_guide_to_radon.pdf")
                .doesNotContain("EPA gold standard")
                .doesNotContain("Cost: $")
                .doesNotContain("Best first purchase")
                .doesNotContain("Angi Radon Mitigation Cost Guide");
    }

    private List<String> protocolPaths() {
        return catalog.slugs().stream().map(slug -> "/guides/" + slug).toList();
    }

    private String stripMarkup(String html) {
        return html.replaceAll("(?s)<script.*?</script>", " ")
                .replaceAll("(?s)<style.*?</style>", " ")
                .replaceAll("<[^>]+>", " ")
                .replaceAll("&[a-zA-Z#0-9]+;", " ")
                .replaceAll("\\s+", " ")
                .trim();
    }

    private int countOccurrences(String value, String token) {
        return (value.length() - value.replace(token, "").length()) / token.length();
    }
}
