package com.radonverdict;

import com.radonverdict.service.TestProtocolGuideCatalog;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.servlet.MockMvc;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;

@SpringBootTest(properties = {
        "app.site.enforce-canonical-host=false",
        "app.product.legacy-surfaces-enabled=false",
        "app.site.retire-non-evidence-county-pages=true"
})
@AutoConfigureMockMvc
class AcquisitionMetadataContractTest {
    private static final Pattern TITLE = Pattern.compile("<title>(.*?)</title>", Pattern.DOTALL);
    private static final Pattern DESCRIPTION = Pattern.compile("<meta name=\"description\" content=\"(.*?)\">", Pattern.DOTALL);
    private static final Pattern H1 = Pattern.compile("<h1(?:\\s|>)", Pattern.CASE_INSENSITIVE);
    private static final Pattern INTERNAL_LINK = Pattern.compile("href=\"/(?!/)[^\"]+");

    @Autowired MockMvc mockMvc;
    @Autowired TestProtocolGuideCatalog catalog;

    @Test
    void acquisitionPagesHaveUniqueSearchSnippetsOnePrimaryHeadingAndAWorkingCanonical() throws Exception {
        Set<String> titles = new HashSet<>();
        Set<String> descriptions = new HashSet<>();

        for (String path : acquisitionPaths()) {
            var response = mockMvc.perform(get(path)).andReturn().getResponse();
            assertThat(response.getStatus()).as(path).isEqualTo(200);
            String html = response.getContentAsString();

            String title = first(TITLE, html, path);
            String description = first(DESCRIPTION, html, path);
            assertThat(decode(title).length()).as("title length for " + path).isBetween(20, 75);
            assertThat(decode(description).length()).as("description length for " + path).isBetween(80, 180);
            assertThat(titles.add(decode(title))).as("unique title for " + path).isTrue();
            assertThat(descriptions.add(decode(description))).as("unique description for " + path).isTrue();
            assertThat(count(H1, html)).as("one h1 for " + path).isEqualTo(1);
            assertThat(count(INTERNAL_LINK, html)).as("internal paths for " + path).isGreaterThanOrEqualTo(3);

            String canonical = path.equals("/") ? "https://radonverdict.com/" : "https://radonverdict.com" + path;
            assertThat(html).contains("<link rel=\"canonical\" href=\"" + canonical + "\">");
            assertThat(html).doesNotContain("<meta name=\"robots\" content=\"noindex");
        }
    }

    @Test
    void decisionPagesExposePrimarySourcesAndNeverAdvertiseUnsupportedCertainty() throws Exception {
        List<String> decisionPaths = new ArrayList<>(catalog.slugs().stream()
                .map(slug -> "/guides/" + slug).toList());
        decisionPaths.add("/guides/how-to-test-for-radon");
        decisionPaths.add("/radon-test-result-meaning");

        for (String path : decisionPaths) {
            String html = mockMvc.perform(get(path)).andReturn().getResponse().getContentAsString();
            assertThat(html).as("primary source for " + path)
                    .containsAnyOf("https://www.epa.gov/", "https://www.cdc.gov/", "https://archive.epa.gov/", "https://www.michigan.gov/");
            assertThat(html)
                    .doesNotContain("EPA gold standard")
                    .doesNotContain("100% safe")
                    .doesNotContain("guaranteed accurate")
                    .doesNotContain("Credentialed external review not yet completed")
                    .doesNotContain("credentialed external radon review has not yet been completed");
        }
    }

    @Test
    void sharedStylesheetsUseVersionedUrlsSoProductionCdnCannotServeStaleDesigns() throws Exception {
        String html = mockMvc.perform(get("/"))
                .andReturn().getResponse().getContentAsString();

        assertThat(html)
                .contains("href=\"/css/style.css?v=20260906a\"")
                .contains("href=\"/css/mobile-overrides.css?v=20260906a\"");
    }

    private List<String> acquisitionPaths() {
        List<String> paths = new ArrayList<>(List.of(
                "/", "/guides", "/guides/how-to-test-for-radon",
                "/radon-test-planner", "/radon-test-result-meaning"));
        paths.addAll(catalog.slugs().stream().map(slug -> "/guides/" + slug).toList());
        return paths;
    }

    private String first(Pattern pattern, String html, String path) {
        Matcher matcher = pattern.matcher(html);
        assertThat(matcher.find()).as("required metadata for " + path).isTrue();
        return matcher.group(1).replaceAll("\\s+", " ").trim();
    }

    private int count(Pattern pattern, String html) {
        int count = 0;
        Matcher matcher = pattern.matcher(html);
        while (matcher.find()) count++;
        return count;
    }

    private String decode(String value) {
        return value.replace("&amp;", "&").replace("&quot;", "\"").replace("&#39;", "'");
    }
}
