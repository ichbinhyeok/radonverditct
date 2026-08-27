package com.radonverdict;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;

import java.net.URI;
import java.util.LinkedHashSet;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;

@SpringBootTest(properties = {
        "app.site.enforce-canonical-host=false",
        "app.site.retire-non-evidence-county-pages=true",
        "app.product.legacy-surfaces-enabled=false"
})
@AutoConfigureMockMvc
class SeoPublicSurfaceContractTest {
    private static final Pattern LOC = Pattern.compile("<loc>(https://radonverdict\\.com)?([^<]+)</loc>");
    private static final Pattern HREF = Pattern.compile("href=\\\"([^\\\"]+)\\\"");
    private static final Pattern JSON_LD = Pattern.compile(
            "<script type=\\\"application/ld\\+json\\\">(.*?)</script>",
            Pattern.DOTALL);

    @Autowired
    MockMvc mockMvc;

    @Autowired
    ObjectMapper objectMapper;

    @Test
    void everySitemapPageIsHealthyCanonicalAndDoesNotLinkToRetiredSurfaces() throws Exception {
        Set<String> sitemapPaths = pathsFromXml(fetch("/sitemap.xml"));
        assertThat(sitemapPaths).containsExactlyInAnyOrder(
                "/sitemap-core.xml",
                "/sitemap-county-evidence.xml",
                "/sitemap-intent.xml");

        Set<String> pagePaths = new LinkedHashSet<>();
        for (String sitemapPath : sitemapPaths) {
            pagePaths.addAll(pathsFromXml(fetch(sitemapPath)));
        }
        assertThat(pagePaths).isNotEmpty();

        Set<String> linkedPaths = new LinkedHashSet<>();
        for (String pagePath : pagePaths) {
            MvcResult page = mockMvc.perform(get(pagePath)).andReturn();
            assertThat(page.getResponse().getStatus())
                    .as("sitemap page %s", pagePath)
                    .isBetween(200, 299);

            String html = page.getResponse().getContentAsString();
            String canonical = pagePath.equals("/")
                    ? "https://radonverdict.com/"
                    : "https://radonverdict.com" + pagePath;
            assertThat(html)
                    .as("self canonical for %s", pagePath)
                    .contains("<link rel=\"canonical\" href=\"" + canonical + "\">");
            validateJsonLd(pagePath, html);
            linkedPaths.addAll(internalLinks(html));
        }

        for (String linkedPath : linkedPaths) {
            int status = mockMvc.perform(get(linkedPath)).andReturn().getResponse().getStatus();
            assertThat(status)
                    .as("internal link target %s", linkedPath)
                    .isLessThan(400);
        }
    }

    @Test
    void indexableGuidesExposeDatedEditorialOwnership() throws Exception {
        for (String path : Set.of(
                "/guides/how-to-test-for-radon",
                "/guides/radon-failed-inspection",
                "/guides/radon-mitigation-quote-checklist")) {
            String html = fetch(path);
            assertThat(html)
                    .contains("\"datePublished\":")
                    .contains("\"dateModified\": \"2026-08-27\"")
                    .contains("\"url\": \"https://radonverdict.com/about\"")
                    .contains("Independent Review")
                    .contains("Credentialed external review not yet completed");
        }
    }

    @Test
    void cachePolicySeparatesPublicAssetsSeoDocumentsAndPrivatePlans() throws Exception {
        assertThat(mockMvc.perform(get("/css/style.css")).andReturn().getResponse().getHeader("Cache-Control"))
                .isEqualTo("public, max-age=86400, stale-while-revalidate=604800");
        assertThat(mockMvc.perform(get("/sitemap.xml")).andReturn().getResponse().getHeader("Cache-Control"))
                .isEqualTo("public, max-age=3600, must-revalidate");
        assertThat(mockMvc.perform(get("/")).andReturn().getResponse().getHeader("Cache-Control"))
                .isEqualTo("public, max-age=0, must-revalidate");
        assertThat(mockMvc.perform(get("/plan")).andReturn().getResponse().getHeader("Cache-Control"))
                .isEqualTo("private, no-store");
    }

    private String fetch(String path) throws Exception {
        MvcResult result = mockMvc.perform(get(path)).andReturn();
        assertThat(result.getResponse().getStatus()).as(path).isEqualTo(200);
        return result.getResponse().getContentAsString();
    }

    private Set<String> pathsFromXml(String xml) {
        Set<String> paths = new LinkedHashSet<>();
        Matcher matcher = LOC.matcher(xml);
        while (matcher.find()) {
            paths.add(matcher.group(2));
        }
        return paths;
    }

    private Set<String> internalLinks(String html) {
        Set<String> paths = new LinkedHashSet<>();
        Matcher matcher = HREF.matcher(html);
        while (matcher.find()) {
            String href = matcher.group(1);
            if (!href.startsWith("/") || href.startsWith("//")) {
                continue;
            }
            URI uri = URI.create(href.replace("&amp;", "&"));
            if (uri.getPath() != null && !uri.getPath().isBlank()) {
                paths.add(uri.getPath());
            }
        }
        return paths;
    }

    private void validateJsonLd(String path, String html) throws Exception {
        Matcher matcher = JSON_LD.matcher(html);
        while (matcher.find()) {
            objectMapper.readTree(matcher.group(1).trim());
        }
    }
}
