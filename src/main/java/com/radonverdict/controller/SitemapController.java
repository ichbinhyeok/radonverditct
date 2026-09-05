package com.radonverdict.controller;

import com.radonverdict.model.County;
import com.radonverdict.model.CountyRadonMeasurement;
import com.radonverdict.model.CountyRadonTier;
import com.radonverdict.service.DataLoadService;
import com.radonverdict.service.SeoIndexingPolicyService;
import com.radonverdict.service.TestProtocolGuideCatalog;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.time.LocalDate;
import java.util.Collection;

@Controller
@RequiredArgsConstructor
public class SitemapController {

    private static final LocalDate SEO_CONTENT_LASTMOD = LocalDate.of(2026, 8, 27);
    private static final String TEST_PROTOCOL_LASTMOD = "2026-09-05";

    private final DataLoadService dataLoadService;
    private final SeoIndexingPolicyService seoIndexingPolicyService;
    private final com.radonverdict.service.IntentPagePolicyService intentPagePolicyService;
    private final TestProtocolGuideCatalog testProtocolGuideCatalog;

    @Value("${app.site.base-url:https://radonverdict.com}")
    private String baseUrl;

    @Value("${app.site.lastmod:}")
    private String configuredLastmod;

    @Value("${app.site.include-unknown-sitemap:false}")
    private boolean includeUnknownSitemap;

    @Value("${app.site.include-broad-zone-sitemap:false}")
    private boolean includeBroadZoneSitemap;

    @Value("${app.site.index-county-cost-pages:true}")
    private boolean indexCountyCostPages;

    @GetMapping(value = "/sitemap.xml", produces = MediaType.APPLICATION_XML_VALUE)
    @ResponseBody
    public String generateSitemapIndex() {
        StringBuilder xml = new StringBuilder();
        xml.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
        xml.append("<sitemapindex xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">");

        addSitemapUrl(xml, "/sitemap-core.xml");
        addSitemapUrl(xml, "/sitemap-county-evidence.xml");
        addSitemapUrl(xml, "/sitemap-intent.xml");

        xml.append("</sitemapindex>");
        return xml.toString();
    }

    private void addSitemapUrl(StringBuilder xml, String path) {
        xml.append("<sitemap>");
        xml.append("<loc>").append(normalizedBaseUrl()).append(path).append("</loc>");
        xml.append("<lastmod>").append(resolveLastmod()).append("</lastmod>");
        xml.append("</sitemap>");
    }

    @GetMapping(value = "/sitemap-recovery.xml", produces = MediaType.APPLICATION_XML_VALUE)
    @ResponseBody
    public String generateRecoverySitemap() {
        StringBuilder xml = new StringBuilder();
        xml.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
        xml.append("<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">");

        dataLoadService.getCountyBySlugMap().values().stream()
                .filter(seoIndexingPolicyService::isCountyIndexableCandidate)
                .filter(seoIndexingPolicyService::isRecoveryTrafficCandidate)
                .sorted((left, right) -> Integer.compare(
                        seoIndexingPolicyService.recoveryTrafficRank(left),
                        seoIndexingPolicyService.recoveryTrafficRank(right)))
                .forEach(county -> {
                    addUrl(xml,
                            "/radon-levels/" + county.getStateSlug() + "/" + county.getCountySlug(),
                            "0.9",
                            resolveCountyLastmod(county));
                });

        xml.append("</urlset>");
        return xml.toString();
    }

    @GetMapping(value = "/sitemap-growth.xml", produces = MediaType.APPLICATION_XML_VALUE)
    @ResponseBody
    public String generateGrowthSitemap() {
        StringBuilder xml = new StringBuilder();
        xml.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
        xml.append("<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">");

        dataLoadService.getCountyBySlugMap().values().stream()
                .filter(seoIndexingPolicyService::isCountyIndexableCandidate)
                .filter(seoIndexingPolicyService::isGrowthTrafficCandidate)
                .filter(county -> !seoIndexingPolicyService.isRecoveryTrafficCandidate(county))
                .sorted((left, right) -> Integer.compare(
                        seoIndexingPolicyService.growthTrafficRank(left),
                        seoIndexingPolicyService.growthTrafficRank(right)))
                .forEach(county -> {
                    addUrl(xml,
                            "/radon-levels/" + county.getStateSlug() + "/" + county.getCountySlug(),
                            "0.85",
                            resolveCountyLastmod(county));
                });

        xml.append("</urlset>");
        return xml.toString();
    }

    @GetMapping(value = "/sitemap-cost-evidence.xml", produces = MediaType.APPLICATION_XML_VALUE)
    @ResponseBody
    public String generateCostEvidenceSitemap() {
        StringBuilder xml = new StringBuilder();
        xml.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
        xml.append("<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">");

        if (indexCountyCostPages) {
            dataLoadService.getCountyBySlugMap().values().stream()
                    .filter(seoIndexingPolicyService::isCostPageIndexableCandidate)
                    .sorted((left, right) -> {
                        int scoreCompare = Integer.compare(
                                seoIndexingPolicyService.countyIndexingScore(right),
                                seoIndexingPolicyService.countyIndexingScore(left));
                        if (scoreCompare != 0) {
                            return scoreCompare;
                        }
                        int stateCompare = left.getStateSlug().compareTo(right.getStateSlug());
                        if (stateCompare != 0) {
                            return stateCompare;
                        }
                        return left.getCountySlug().compareTo(right.getCountySlug());
                    })
                    .forEach(county -> addUrl(xml,
                            "/radon-mitigation-cost/" + county.getStateSlug() + "/" + county.getCountySlug(),
                            "0.65",
                            resolveCountyLastmod(county)));
        }

        xml.append("</urlset>");
        return xml.toString();
    }

    @GetMapping(value = "/sitemap-core.xml", produces = MediaType.APPLICATION_XML_VALUE)
    @ResponseBody
    public String generateCoreSitemap() {
        StringBuilder xml = new StringBuilder();
        xml.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
        xml.append("<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">");

        addUrl(xml, "/", "1.0");
        addUrl(xml, "/radon-test-planner", "1.0");
        addUrl(xml, "/radon-test-result-meaning", "0.9");
        addUrl(xml, "/radon-levels", "0.9");
        addUrl(xml, "/about", "0.8");
        addUrl(xml, "/methodology", "0.8");
        addUrl(xml, "/radon-data-sources", "0.8");
        addUrl(xml, "/contact", "0.8");
        addUrl(xml, "/privacy", "0.5");
        addUrl(xml, "/terms", "0.5");
        addUrl(xml, "/guides", "0.9", TEST_PROTOCOL_LASTMOD);
        addUrl(xml, "/guides/how-to-test-for-radon", "0.7");
        testProtocolGuideCatalog.slugs().forEach(slug ->
                addUrl(xml, "/guides/" + slug, "0.8", TEST_PROTOCOL_LASTMOD));
        addUrl(xml, "/guides/radon-failed-inspection", "0.8");
        addUrl(xml, "/guides/radon-mitigation-quote-checklist", "0.8");

        xml.append("</urlset>");
        return xml.toString();
    }

    @GetMapping(value = "/sitemap-intent.xml", produces = MediaType.APPLICATION_XML_VALUE)
    @ResponseBody
    public String generateIntentSitemap() {
        StringBuilder xml = new StringBuilder();
        xml.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
        xml.append("<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">");

        dataLoadService.getCountyBySlugMap().values().stream()
                .filter(intentPagePolicyService::isTestingIntentCandidate)
                .sorted((left, right) -> {
                    int stateCompare = left.getStateSlug().compareTo(right.getStateSlug());
                    return stateCompare != 0 ? stateCompare : left.getCountySlug().compareTo(right.getCountySlug());
                })
                .forEach(county -> addUrl(xml, intentPagePolicyService.testingPath(county), "0.75",
                        resolveCountyLastmod(county)));

        dataLoadService.getCountyBySlugMap().values().stream()
                .filter(intentPagePolicyService::isCommercialIntentCandidate)
                .forEach(county -> addUrl(xml, intentPagePolicyService.commercialPath(county), "0.8",
                        resolveCountyLastmod(county)));

        xml.append("</urlset>");
        return xml.toString();
    }

    @GetMapping(value = {"/sitemap-levels-evidence.xml", "/sitemap-county-canary.xml", "/sitemap-county-evidence.xml"}, produces = MediaType.APPLICATION_XML_VALUE)
    @ResponseBody
    public String generateLevelsEvidenceSitemap() {
        StringBuilder xml = new StringBuilder();
        xml.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
        xml.append("<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">");

        dataLoadService.getCountyBySlugMap().values().stream()
                .filter(seoIndexingPolicyService::isCountyIndexableCandidate)
                .sorted((left, right) -> {
                    int stateCompare = left.getStateSlug().compareTo(right.getStateSlug());
                    if (stateCompare != 0) {
                        return stateCompare;
                    }
                    return left.getCountySlug().compareTo(right.getCountySlug());
                })
                .forEach(county -> addUrl(xml,
                        "/radon-levels/" + county.getStateSlug() + "/" + county.getCountySlug(),
                        "0.7",
                        resolveCountyLastmod(county)));

        xml.append("</urlset>");
        return xml.toString();
    }

    @GetMapping(value = "/sitemap-zone-high.xml", produces = MediaType.APPLICATION_XML_VALUE)
    @ResponseBody
    public String generateZoneHighSitemap() {
        StringBuilder xml = new StringBuilder();
        xml.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
        xml.append("<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">");

        // Zone 1 & 2 pSEO Pages (High Priority)
        Collection<County> counties = dataLoadService.getCountyBySlugMap().values();
        for (County county : counties) {
            if (!seoIndexingPolicyService.isCountyIndexableCandidate(county))
                continue;
            if (seoIndexingPolicyService.isSearchTrafficCandidate(county))
                continue;

            if (county.getEpaZone() == 1 || county.getEpaZone() == 2) {
                // Recovery cohort: submit the official-evidence levels page, not the conversion-only cost page.
                addUrl(xml, "/radon-levels/" + county.getStateSlug() + "/" + county.getCountySlug(), "0.8",
                        resolveCountyLastmod(county));
            }
        }

        xml.append("</urlset>");
        return xml.toString();
    }

    @GetMapping(value = "/sitemap-zone-low.xml", produces = MediaType.APPLICATION_XML_VALUE)
    @ResponseBody
    public String generateZoneLowSitemap() {
        StringBuilder xml = new StringBuilder();
        xml.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
        xml.append("<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">");

        if (!seoIndexingPolicyService.includeZoneLowSitemap()) {
            xml.append("</urlset>");
            return xml.toString();
        }

        // Zone 3 pSEO Pages (Low Priority)
        Collection<County> counties = dataLoadService.getCountyBySlugMap().values();
        for (County county : counties) {
            if (!seoIndexingPolicyService.isCountyIndexableCandidate(county))
                continue;
            if (seoIndexingPolicyService.isSearchTrafficCandidate(county))
                continue;

            if (county.getEpaZone() == 3) {
                // Recovery cohort: submit the official-evidence levels page, not the conversion-only cost page.
                addUrl(xml, "/radon-levels/" + county.getStateSlug() + "/" + county.getCountySlug(), "0.4",
                        resolveCountyLastmod(county));
            }
        }

        xml.append("</urlset>");
        return xml.toString();
    }

    @GetMapping(value = "/sitemap-zone-unknown.xml", produces = MediaType.APPLICATION_XML_VALUE)
    @ResponseBody
    public String generateZoneUnknownSitemap() {
        StringBuilder xml = new StringBuilder();
        xml.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
        xml.append("<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">");

        // Counties with missing zone assignments (data pending / unknown)
        Collection<County> counties = dataLoadService.getCountyBySlugMap().values();
        for (County county : counties) {
            if (!seoIndexingPolicyService.hasDataMoat(county))
                continue;
            if (seoIndexingPolicyService.isSearchTrafficCandidate(county))
                continue;

            if (county.getEpaZone() <= 0) {
                addUrl(xml, "/radon-levels/" + county.getStateSlug() + "/" + county.getCountySlug(), "0.3",
                        resolveCountyLastmod(county));
            }
        }

        xml.append("</urlset>");
        return xml.toString();
    }

    private void addUrl(StringBuilder xml, String path, String priority) {
        addUrl(xml, path, priority, resolveLastmod());
    }

    private void addUrl(StringBuilder xml, String path, String priority, String lastmod) {
        xml.append("<url>");
        xml.append("<loc>").append(normalizedBaseUrl()).append(path).append("</loc>");
        xml.append("<lastmod>").append(lastmod).append("</lastmod>");
        xml.append("<changefreq>monthly</changefreq>");
        xml.append("<priority>").append(priority).append("</priority>");
        xml.append("</url>");
    }

    private String normalizedBaseUrl() {
        if (baseUrl == null || baseUrl.isBlank()) {
            return "https://radonverdict.com";
        }
        return baseUrl.endsWith("/") ? baseUrl.substring(0, baseUrl.length() - 1) : baseUrl;
    }

    private String resolveLastmod() {
        if (configuredLastmod != null && !configuredLastmod.isBlank()) {
            return configuredLastmod;
        }
        return SEO_CONTENT_LASTMOD.toString();
    }

    private String resolveCountyLastmod(County county) {
        if (configuredLastmod != null && !configuredLastmod.isBlank()) {
            return configuredLastmod;
        }

        LocalDate lastmod = SEO_CONTENT_LASTMOD;
        if (county == null || county.getFips() == null) {
            return lastmod.toString();
        }

        CountyRadonMeasurement measurement = dataLoadService.getRadonMeasurementByFipsMap().get(county.getFips());
        CountyRadonTier tier = dataLoadService.getRadonTierByFipsMap().get(county.getFips());
        lastmod = laterOf(lastmod, parseDate(measurement != null ? measurement.getRetrievedAt() : null));
        lastmod = laterOf(lastmod, parseDate(tier != null ? tier.getRetrievedAt() : null));
        lastmod = laterOf(lastmod, parseDate(
                county.getStats() != null ? county.getStats().getRetrievedAt() : null));
        return lastmod.toString();
    }

    private LocalDate laterOf(LocalDate current, LocalDate candidate) {
        return candidate != null && candidate.isAfter(current) ? candidate : current;
    }

    private LocalDate parseDate(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }
        try {
            return LocalDate.parse(value.trim());
        } catch (java.time.format.DateTimeParseException ignored) {
            return null;
        }
    }

    @GetMapping(value = "/robots.txt", produces = MediaType.TEXT_PLAIN_VALUE)
    @ResponseBody
    public String robotsTxt() {
        return "User-agent: *\n" +
                "Allow: /\n" +
                "Disallow: /admin/\n" +
                "Disallow: /htmx/\n" +
                "Sitemap: " + normalizedBaseUrl() + "/sitemap.xml";
    }
}

