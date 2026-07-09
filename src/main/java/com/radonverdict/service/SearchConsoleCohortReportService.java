package com.radonverdict.service;

import com.radonverdict.model.County;
import com.radonverdict.model.dto.SearchConsoleCohortReport;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.net.URI;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

@Service
public class SearchConsoleCohortReportService {

    private final DataLoadService dataLoadService;
    private final SeoIndexingPolicyService seoIndexingPolicyService;

    @Value("${app.storage.search-console-indexing-csv-path:data/search-console-indexing.csv}")
    private String searchConsoleCsvPath;

    @Value("${app.site.base-url:https://radonverdict.com}")
    private String baseUrl;

    public SearchConsoleCohortReportService(DataLoadService dataLoadService,
            SeoIndexingPolicyService seoIndexingPolicyService) {
        this.dataLoadService = dataLoadService;
        this.seoIndexingPolicyService = seoIndexingPolicyService;
    }

    public SearchConsoleCohortReport buildReport() {
        Map<String, Set<String>> expectedByCohort = expectedUrlsByCohort();
        Map<String, SearchConsoleRow> exportedRows = readExportRows();
        boolean exportAvailable = Files.exists(Paths.get(searchConsoleCsvPath));

        List<SearchConsoleCohortReport.CohortRow> cohortRows = expectedByCohort.entrySet().stream()
                .map(entry -> buildCohortRow(entry.getKey(), entry.getValue(), exportedRows))
                .toList();
        List<SearchConsoleCohortReport.RecommendedInspectionRow> recommendations = buildRecommendations(
                expectedByCohort,
                exportedRows,
                exportAvailable);

        return SearchConsoleCohortReport.builder()
                .exportAvailable(exportAvailable)
                .exportPath(searchConsoleCsvPath)
                .exportedUrlCount(exportedRows.size())
                .summary(exportAvailable
                        ? "GSC export loaded. Review cohorts with high discovered/crawled-not-indexed counts before expanding URL volume."
                        : "No GSC export loaded yet. Export Page indexing URLs from Search Console to data/search-console-indexing.csv, then this report will attach statuses to each sitemap cohort.")
                .cohortRows(cohortRows)
                .recommendedInspectionRows(recommendations)
                .build();
    }

    private SearchConsoleCohortReport.CohortRow buildCohortRow(String cohort, Set<String> expectedUrls,
            Map<String, SearchConsoleRow> exportedRows) {
        int seen = 0;
        int indexed = 0;
        int crawledNotIndexed = 0;
        int discoveredNotIndexed = 0;
        int otherNotIndexed = 0;

        for (String url : expectedUrls) {
            SearchConsoleRow row = exportedRows.get(normalizePath(url));
            if (row == null) {
                continue;
            }
            seen++;
            String status = row.status().toLowerCase(Locale.ROOT);
            if (isIndexed(status)) {
                indexed++;
            } else if (status.contains("crawled") && status.contains("not indexed")) {
                crawledNotIndexed++;
            } else if (status.contains("discovered") && status.contains("not indexed")) {
                discoveredNotIndexed++;
            } else {
                otherNotIndexed++;
            }
        }

        return SearchConsoleCohortReport.CohortRow.builder()
                .cohort(cohort)
                .sitemapUrl(normalizedBaseUrl() + "/" + sitemapFileForCohort(cohort))
                .expectedUrlCount(expectedUrls.size())
                .seenInExportCount(seen)
                .indexedCount(indexed)
                .crawledNotIndexedCount(crawledNotIndexed)
                .discoveredNotIndexedCount(discoveredNotIndexed)
                .otherNotIndexedCount(otherNotIndexed)
                .action(cohortAction(expectedUrls.size(), seen, indexed, crawledNotIndexed, discoveredNotIndexed))
                .build();
    }

    private List<SearchConsoleCohortReport.RecommendedInspectionRow> buildRecommendations(
            Map<String, Set<String>> expectedByCohort,
            Map<String, SearchConsoleRow> exportedRows,
            boolean exportAvailable) {
        List<SearchConsoleCohortReport.RecommendedInspectionRow> rows = new ArrayList<>();

        for (Map.Entry<String, Set<String>> entry : expectedByCohort.entrySet()) {
            for (String url : entry.getValue()) {
                SearchConsoleRow exportRow = exportedRows.get(normalizePath(url));
                if (exportAvailable && exportRow != null && isIndexed(exportRow.status().toLowerCase(Locale.ROOT))) {
                    continue;
                }
                rows.add(SearchConsoleCohortReport.RecommendedInspectionRow.builder()
                        .url(normalizedBaseUrl() + normalizePath(url))
                        .cohort(entry.getKey())
                        .status(exportRow != null ? exportRow.status() : "not found in export")
                        .reason(recommendationReason(entry.getKey(), exportRow))
                        .build());
            }
        }

        return rows.stream()
                .sorted(Comparator
                        .comparingInt((SearchConsoleCohortReport.RecommendedInspectionRow row) -> cohortPriority(row.getCohort()))
                        .thenComparing(SearchConsoleCohortReport.RecommendedInspectionRow::getUrl))
                .limit(12)
                .toList();
    }

    private Map<String, Set<String>> expectedUrlsByCohort() {
        Map<String, Set<String>> cohorts = new LinkedHashMap<>();
        cohorts.put("recovery", new LinkedHashSet<>());
        cohorts.put("growth", new LinkedHashSet<>());
        cohorts.put("cost-evidence", new LinkedHashSet<>());
        cohorts.put("levels-evidence", new LinkedHashSet<>());

        List<County> counties = dataLoadService.getCountyBySlugMap().values().stream()
                .filter(seoIndexingPolicyService::isCountyIndexableCandidate)
                .sorted(Comparator.comparing(County::getStateSlug).thenComparing(County::getCountySlug))
                .toList();

        for (County county : counties) {
            String levelsPath = "/radon-levels/" + county.getStateSlug() + "/" + county.getCountySlug();
            String costPath = "/radon-mitigation-cost/" + county.getStateSlug() + "/" + county.getCountySlug();

            if (seoIndexingPolicyService.isRecoveryTrafficCandidate(county)) {
                cohorts.get("recovery").add(levelsPath);
                if (seoIndexingPolicyService.isCostPageIndexableCandidate(county)) {
                    cohorts.get("recovery").add(costPath);
                }
                continue;
            }
            if (seoIndexingPolicyService.isGrowthTrafficCandidate(county)) {
                cohorts.get("growth").add(levelsPath);
                if (seoIndexingPolicyService.isCostPageIndexableCandidate(county)) {
                    cohorts.get("growth").add(costPath);
                }
                continue;
            }
            cohorts.get("levels-evidence").add(levelsPath);
            if (seoIndexingPolicyService.isEvidenceRichCostPageCandidate(county)) {
                cohorts.get("cost-evidence").add(costPath);
            }
        }

        return cohorts;
    }

    private Map<String, SearchConsoleRow> readExportRows() {
        Path path = Paths.get(searchConsoleCsvPath);
        if (!Files.exists(path)) {
            return Map.of();
        }

        try {
            List<String> lines = Files.readAllLines(path);
            if (lines.size() < 2) {
                return Map.of();
            }

            List<String> headers = parseCsvColumns(lines.get(0));
            int urlIndex = findHeader(headers, "url", "page");
            int statusIndex = findHeader(headers, "status", "indexing", "coverage", "reason");
            if (urlIndex < 0) {
                return Map.of();
            }

            Map<String, SearchConsoleRow> rows = new LinkedHashMap<>();
            for (int i = 1; i < lines.size(); i++) {
                List<String> cols = parseCsvColumns(lines.get(i));
                if (cols.size() <= urlIndex) {
                    continue;
                }
                String pathValue = normalizePath(cols.get(urlIndex));
                if (pathValue.isBlank()) {
                    continue;
                }
                String status = statusIndex >= 0 && cols.size() > statusIndex && !cols.get(statusIndex).isBlank()
                        ? cols.get(statusIndex)
                        : "exported";
                rows.put(pathValue, new SearchConsoleRow(pathValue, status));
            }
            return rows;
        } catch (IOException e) {
            return Map.of();
        }
    }

    private int findHeader(List<String> headers, String... needles) {
        for (int i = 0; i < headers.size(); i++) {
            String header = headers.get(i).toLowerCase(Locale.ROOT);
            for (String needle : needles) {
                if (header.contains(needle)) {
                    return i;
                }
            }
        }
        return -1;
    }

    private List<String> parseCsvColumns(String line) {
        List<String> columns = new ArrayList<>();
        if (line == null || line.isBlank()) {
            return columns;
        }
        StringBuilder current = new StringBuilder();
        boolean inQuotes = false;
        for (int i = 0; i < line.length(); i++) {
            char ch = line.charAt(i);
            if (ch == '"') {
                if (inQuotes && i + 1 < line.length() && line.charAt(i + 1) == '"') {
                    current.append('"');
                    i++;
                } else {
                    inQuotes = !inQuotes;
                }
                continue;
            }
            if (ch == ',' && !inQuotes) {
                columns.add(current.toString().trim());
                current.setLength(0);
                continue;
            }
            current.append(ch);
        }
        columns.add(current.toString().trim());
        return columns;
    }

    private boolean isIndexed(String status) {
        return status.contains("indexed") && !status.contains("not indexed")
                || status.contains("submitted and indexed")
                || status.equals("indexed");
    }

    private String normalizePath(String raw) {
        if (raw == null || raw.isBlank()) {
            return "";
        }
        String trimmed = raw.trim();
        if (trimmed.startsWith("http://") || trimmed.startsWith("https://")) {
            try {
                URI uri = URI.create(trimmed);
                String path = uri.getPath();
                return path == null || path.isBlank() ? "/" : stripTrailingSlash(path);
            } catch (IllegalArgumentException ignored) {
                return "";
            }
        }
        if (!trimmed.startsWith("/")) {
            trimmed = "/" + trimmed;
        }
        return stripTrailingSlash(trimmed);
    }

    private String stripTrailingSlash(String value) {
        if (value == null || value.length() <= 1) {
            return value == null ? "" : value;
        }
        return value.endsWith("/") ? value.substring(0, value.length() - 1) : value;
    }

    private String normalizedBaseUrl() {
        if (baseUrl == null || baseUrl.isBlank()) {
            return "https://radonverdict.com";
        }
        return baseUrl.endsWith("/") ? baseUrl.substring(0, baseUrl.length() - 1) : baseUrl;
    }

    private String sitemapFileForCohort(String cohort) {
        return switch (cohort) {
            case "recovery" -> "sitemap-recovery.xml";
            case "growth" -> "sitemap-growth.xml";
            case "cost-evidence" -> "sitemap-cost-evidence.xml";
            default -> "sitemap-levels-evidence.xml";
        };
    }

    private String cohortAction(int expected, int seen, int indexed, int crawled, int discovered) {
        if (expected == 0) {
            return "No URLs in this cohort.";
        }
        if (seen == 0) {
            return "Submit or refresh this sitemap in GSC; no exported URL matched this cohort.";
        }
        if (discovered > indexed && discovered > crawled) {
            return "Discovery is the bottleneck: add stronger HTML links from indexed hubs before expanding volume.";
        }
        if (crawled > indexed) {
            return "Quality or duplication is the bottleneck: inspect rendered pages and internal anchors.";
        }
        if (indexed >= Math.max(1, seen / 2)) {
            return "Keep monitoring; this cohort has index traction.";
        }
        return "Investigate URL inspection samples before adding more pages.";
    }

    private String recommendationReason(String cohort, SearchConsoleRow row) {
        if (row == null) {
            return "Not present in export; inspect after submitting the matching sitemap.";
        }
        String status = row.status().toLowerCase(Locale.ROOT);
        if (status.contains("discovered")) {
            return "Discovered but not indexed usually means stronger internal links are needed.";
        }
        if (status.contains("crawled")) {
            return "Crawled but not indexed usually means quality, duplication, or intent overlap needs inspection.";
        }
        return cohort + " sample needs manual URL inspection before the next scale-up.";
    }

    private int cohortPriority(String cohort) {
        return switch (cohort) {
            case "recovery" -> 0;
            case "growth" -> 1;
            case "cost-evidence" -> 2;
            default -> 3;
        };
    }

    private record SearchConsoleRow(String path, String status) {
    }
}
