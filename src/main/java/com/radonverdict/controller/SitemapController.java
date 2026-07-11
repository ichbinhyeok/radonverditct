package com.radonverdict.controller;

import com.radonverdict.model.County;
import com.radonverdict.service.DataLoadService;
import com.radonverdict.service.SeoIndexingPolicyService;
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

    private final DataLoadService dataLoadService;
    private final SeoIndexingPolicyService seoIndexingPolicyService;
    private final com.radonverdict.service.IntentPagePolicyService intentPagePolicyService;

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

        addSitemapUrl(xml, "/sitemap-recovery.xml");
        addSitemapUrl(xml, "/sitemap-growth.xml");
        addSitemapUrl(xml, "/sitemap-cost-evidence.xml");
        addSitemapUrl(xml, "/sitemap-levels-evidence.xml");
        addSitemapUrl(xml, "/sitemap-intent.xml");
        addSitemapUrl(xml, "/sitemap-core.xml");
        if (includeBroadZoneSitemap) {
            addSitemapUrl(xml, "/sitemap-zone-high.xml");
        }
        if (includeBroadZoneSitemap && seoIndexingPolicyService.includeZoneLowSitemap()) {
            addSitemapUrl(xml, "/sitemap-zone-low.xml");
        }
        if (includeBroadZoneSitemap && includeUnknownSitemap) {
            addSitemapUrl(xml, "/sitemap-zone-unknown.xml");
        }

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
                    if (indexCountyCostPages && seoIndexingPolicyService.isCostPageIndexableCandidate(county)) {
                        addUrl(xml,
                                "/radon-mitigation-cost/" + county.getStateSlug() + "/" + county.getCountySlug(),
                                "0.8",
                                resolveCountyLastmod(county));
                    }
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
                    if (indexCountyCostPages && seoIndexingPolicyService.isCostPageIndexableCandidate(county)) {
                        addUrl(xml,
                                "/radon-mitigation-cost/" + county.getStateSlug() + "/" + county.getCountySlug(),
                                "0.75",
                                resolveCountyLastmod(county));
                    }
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
                    .filter(county -> !seoIndexingPolicyService.isSearchTrafficCandidate(county))
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

        // 1. Static & Hub Pages
        addUrl(xml, "/", "1.0");
        addUrl(xml, "/radon-cost-calculator", "0.9");
        addUrl(xml, "/radon-credit-calculator", "0.9");
        addUrl(xml, "/radon-mitigation-cost", "0.9");
        addUrl(xml, "/radon-levels", "0.9");
        addUrl(xml, "/about", "0.8");
        addUrl(xml, "/methodology", "0.8");
        addUrl(xml, "/radon-data-sources", "0.8");
        addUrl(xml, "/radon-cost-data-report", "0.85");
        addUrl(xml, "/radon-quote-ledger", "0.8");
        addUrl(xml, "/for-home-inspectors", "0.7");
        addUrl(xml, "/contact", "0.8");
        addUrl(xml, "/guides", "0.8");

        // 1.5 Trust Pages (YMYL)
        addUrl(xml, "/privacy", "0.5");
        addUrl(xml, "/terms", "0.5");

        // 2. Core Guides
        addUrl(xml, "/guides/diy-vs-professional-radon-mitigation", "0.7");
        addUrl(xml, "/guides/radon-mitigation-timeline-how-long-does-it-take", "0.7");
        addUrl(xml, "/guides/how-to-test-for-radon", "0.7");
        addUrl(xml, "/guides/who-pays-radon-mitigation-buyer-or-seller", "0.7");
        addUrl(xml, "/guides/radon-failed-inspection", "0.8");
        addUrl(xml, "/guides/radon-inspection-toolkit", "0.8");
        addUrl(xml, "/guides/radon-mitigation-quote-checklist", "0.8");
        addUrl(xml, "/guides/radon-exposure-symptoms", "0.7");
        addUrl(xml, "/guides/active-vs-passive-radon-system", "0.7");
        addUrl(xml, "/guides/radon-fan-noise-troubleshooting", "0.7");
        addUrl(xml, "/guides/crawl-space-radon-mitigation", "0.7");
        addUrl(xml, "/guides/sump-pump-radon-mitigation", "0.7");
        addUrl(xml, "/guides/radon-system-electricity-cost", "0.7");
        addUrl(xml, "/guides/radon-myths-granite-countertops", "0.7");
        addUrl(xml, "/guides/radon-seller-credit-worksheet", "0.7");

        // 3. State Hubs (match each vertical's own indexability policy)
        Collection<County> counties = dataLoadService.getCountyBySlugMap().values();
        counties.stream()
                .filter(seoIndexingPolicyService::isCostPageIndexableCandidate)
                .map(County::getStateSlug)
                .distinct()
                .forEach(stateSlug -> {
            addUrl(xml, "/radon-mitigation-cost/" + stateSlug, "0.6");
        });
        counties.stream()
                .filter(seoIndexingPolicyService::isCountyIndexableCandidate)
                .map(County::getStateSlug)
                .distinct()
                .forEach(stateSlug -> {
            addUrl(xml, "/radon-levels/" + stateSlug, "0.6");
        });

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

        xml.append("</urlset>");
        return xml.toString();
    }

    @GetMapping(value = "/sitemap-levels-evidence.xml", produces = MediaType.APPLICATION_XML_VALUE)
    @ResponseBody
    public String generateLevelsEvidenceSitemap() {
        StringBuilder xml = new StringBuilder();
        xml.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
        xml.append("<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">");

        dataLoadService.getCountyBySlugMap().values().stream()
                .filter(seoIndexingPolicyService::isCountyIndexableCandidate)
                .filter(county -> !seoIndexingPolicyService.isSearchTrafficCandidate(county))
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
        return LocalDate.now().toString();
    }

    private String resolveCountyLastmod(County county) {
        return resolveLastmod();
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

