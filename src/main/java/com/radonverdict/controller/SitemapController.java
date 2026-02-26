package com.radonverdict.controller;

import com.radonverdict.model.County;
import com.radonverdict.service.DataLoadService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Collection;
import java.time.LocalDate;

@Controller
@RequiredArgsConstructor
public class SitemapController {

    private final DataLoadService dataLoadService;

    @Value("${app.site.base-url:https://radonverdict.com}")
    private String baseUrl;

    @Value("${app.site.lastmod:}")
    private String configuredLastmod;

    @GetMapping(value = "/sitemap.xml", produces = MediaType.APPLICATION_XML_VALUE)
    @ResponseBody
    public String generateSitemapIndex() {
        StringBuilder xml = new StringBuilder();
        xml.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
        xml.append("<sitemapindex xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">");

        addSitemapUrl(xml, "/sitemap-core.xml");
        addSitemapUrl(xml, "/sitemap-zone-high.xml");
        addSitemapUrl(xml, "/sitemap-zone-low.xml");
        addSitemapUrl(xml, "/sitemap-zone-unknown.xml");

        xml.append("</sitemapindex>");
        return xml.toString();
    }

    private void addSitemapUrl(StringBuilder xml, String path) {
        xml.append("<sitemap>");
        xml.append("<loc>").append(normalizedBaseUrl()).append(path).append("</loc>");
        xml.append("<lastmod>").append(resolveLastmod()).append("</lastmod>");
        xml.append("</sitemap>");
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
        addUrl(xml, "/about", "0.8");
        addUrl(xml, "/contact", "0.8");
        addUrl(xml, "/guides", "0.8");

        // 1.5 Trust Pages (YMYL)
        addUrl(xml, "/privacy", "0.5");
        addUrl(xml, "/terms", "0.5");

        // 2. All 11 Guides
        addUrl(xml, "/guides/diy-vs-professional-radon-mitigation", "0.7");
        addUrl(xml, "/guides/radon-mitigation-timeline-how-long-does-it-take", "0.7");
        addUrl(xml, "/guides/how-to-test-for-radon", "0.7");
        addUrl(xml, "/guides/who-pays-radon-mitigation-buyer-or-seller", "0.7");
        addUrl(xml, "/guides/radon-exposure-symptoms", "0.7");
        addUrl(xml, "/guides/active-vs-passive-radon-system", "0.7");
        addUrl(xml, "/guides/radon-fan-noise-troubleshooting", "0.7");
        addUrl(xml, "/guides/crawl-space-radon-mitigation", "0.7");
        addUrl(xml, "/guides/sump-pump-radon-mitigation", "0.7");
        addUrl(xml, "/guides/radon-system-electricity-cost", "0.7");
        addUrl(xml, "/guides/radon-myths-granite-countertops", "0.7");

        // 3. State Hubs (50 states)
        Collection<County> counties = dataLoadService.getCountyBySlugMap().values();
        counties.stream().map(County::getStateSlug).distinct().forEach(stateSlug -> {
            addUrl(xml, "/radon-mitigation-cost/" + stateSlug, "0.6");
            addUrl(xml, "/radon-levels/" + stateSlug, "0.6");
        });

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
            if (!hasDataMoat(county))
                continue;

            if (county.getEpaZone() == 1 || county.getEpaZone() == 2) {
                // Cost Calculator pSEO
                addUrl(xml, "/radon-mitigation-cost/" + county.getStateSlug() + "/" + county.getCountySlug(), "0.8");
                // Radon Levels pSEO
                addUrl(xml, "/radon-levels/" + county.getStateSlug() + "/" + county.getCountySlug(), "0.8");
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

        // Zone 3 pSEO Pages (Low Priority)
        Collection<County> counties = dataLoadService.getCountyBySlugMap().values();
        for (County county : counties) {
            if (!hasDataMoat(county))
                continue;

            if (county.getEpaZone() == 3) {
                // Cost Calculator pSEO
                addUrl(xml, "/radon-mitigation-cost/" + county.getStateSlug() + "/" + county.getCountySlug(), "0.4");
                // Radon Levels pSEO
                addUrl(xml, "/radon-levels/" + county.getStateSlug() + "/" + county.getCountySlug(), "0.4");
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
            if (!hasDataMoat(county))
                continue;

            if (county.getEpaZone() <= 0) {
                addUrl(xml, "/radon-mitigation-cost/" + county.getStateSlug() + "/" + county.getCountySlug(), "0.3");
                addUrl(xml, "/radon-levels/" + county.getStateSlug() + "/" + county.getCountySlug(), "0.3");
            }
        }

        xml.append("</urlset>");
        return xml.toString();
    }

    private boolean hasDataMoat(County county) {
        return county.getStats() != null
                && county.getStats().getMetrics() != null
                && county.getStats().getMetrics().getTotalHousingUnits() > 0;
    }

    private void addUrl(StringBuilder xml, String path, String priority) {
        xml.append("<url>");
        xml.append("<loc>").append(normalizedBaseUrl()).append(path).append("</loc>");
        xml.append("<lastmod>").append(resolveLastmod()).append("</lastmod>");
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

    @GetMapping(value = "/robots.txt", produces = MediaType.TEXT_PLAIN_VALUE)
    @ResponseBody
    public String robotsTxt() {
        return "User-agent: *\n" +
                "Allow: /\n" +
                "Disallow: /admin/\n" +
                "Sitemap: " + normalizedBaseUrl() + "/sitemap.xml";
    }
}
