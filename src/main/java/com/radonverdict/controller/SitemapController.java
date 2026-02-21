package com.radonverdict.controller;

import com.radonverdict.model.County;
import com.radonverdict.service.DataLoadService;
import lombok.RequiredArgsConstructor;
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
    private final String BASE_URL = "https://radonverdict.com"; // Change once domain is live

    @GetMapping(value = "/sitemap.xml", produces = MediaType.APPLICATION_XML_VALUE)
    @ResponseBody
    public String generateSitemap() {
        StringBuilder xml = new StringBuilder();
        xml.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
        xml.append("<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">");

        // 1. Static Pages
        addUrl(xml, "/", "1.0");
        addUrl(xml, "/radon-cost-calculator", "0.9");
        addUrl(xml, "/about", "0.5");
        addUrl(xml, "/privacy", "0.3");

        // 2. County Pages - The bulk of the SEO
        Collection<County> counties = dataLoadService.getCountyBySlugMap().values();
        for (County county : counties) {
            String path = "/radon-mitigation-cost/" + county.getStateSlug() + "/" + county.getCountySlug();
            addUrl(xml, path, "0.8");
        }

        xml.append("</urlset>");
        return xml.toString();
    }

    private void addUrl(StringBuilder xml, String path, String priority) {
        xml.append("<url>");
        xml.append("<loc>").append(BASE_URL).append(path).append("</loc>");
        xml.append("<lastmod>").append(LocalDate.now().toString()).append("</lastmod>");
        xml.append("<changefreq>monthly</changefreq>");
        xml.append("<priority>").append(priority).append("</priority>");
        xml.append("</url>");
    }

    @GetMapping(value = "/robots.txt", produces = MediaType.TEXT_PLAIN_VALUE)
    @ResponseBody
    public String robotsTxt() {
        return "User-agent: *\n" +
                "Allow: /\n" +
                "Sitemap: " + BASE_URL + "/sitemap.xml";
    }
}
