package com.radonverdict.service;

import com.radonverdict.model.County;
import com.radonverdict.model.dto.SearchDemandProfile;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

/**
 * Converts an optional GSC query/page export into deterministic page opportunities.
 * The service is deliberately read-only: a missing export never hides or changes a page.
 */
@Service
public class SearchDemandService {

    private static final Set<String> COST_TERMS = Set.of("cost", "price", "pricing", "how much", "quote", "quotes", "mitigation");
    private static final Set<String> TESTING_TERMS = Set.of("test", "testing", "tester", "kit", "inspection");
    private static final Set<String> LEVEL_TERMS = Set.of("level", "levels", "zone", "epa", "pci", "4.0", "radon reading", "result");
    private static final Set<String> TRANSACTION_TERMS = Set.of("buyer", "seller", "selling", "buying", "inspection", "credit", "closing");
    private static final Set<String> COMMERCIAL_TERMS = Set.of("commercial", "business", "school", "multifamily");

    private final SeoIndexingPolicyService seoIndexingPolicyService;
    private final DataLoadService dataLoadService;

    @Value("${app.storage.search-console-query-csv-path:data/search-console-query-page.csv}")
    private String queryCsvPath;

    private volatile Cache cache = new Cache("", Map.of());

    public SearchDemandService(SeoIndexingPolicyService seoIndexingPolicyService,
            DataLoadService dataLoadService) {
        this.seoIndexingPolicyService = seoIndexingPolicyService;
        this.dataLoadService = dataLoadService;
    }

    public SearchDemandProfile profileForPath(String path) {
        String normalized = normalizePath(path);
        SearchDemandProfile profile = readProfiles().get(normalized);
        if (profile != null) {
            return profile;
        }
        return fallbackProfile(normalized);
    }

    public List<SearchDemandProfile> topOpportunities(int limit) {
        return readProfiles().values().stream()
                .sorted(Comparator.comparingDouble(SearchDemandProfile::getOpportunityScore).reversed()
                        .thenComparing(SearchDemandProfile::getPath))
                .limit(Math.max(0, limit))
                .toList();
    }

    public boolean exportAvailable() {
        return Files.exists(Paths.get(queryCsvPath));
    }

    private Map<String, SearchDemandProfile> readProfiles() {
        Path path = Paths.get(queryCsvPath);
        String signature = fileSignature(path);
        Cache current = cache;
        if (signature.equals(current.signature())) {
            return current.profiles();
        }

        List<QuerySignal> signals = readSignals(path);
        // Keep the deployed site data-driven even before the next GSC export is uploaded.
        // A real export always wins; the committed seed is a dated recovery snapshot.
        if (signals.isEmpty()) {
            signals = readSeedSignals();
        }

        Map<String, List<QuerySignal>> grouped = signals.stream()
                .filter(signal -> !signal.path().isBlank())
                .collect(java.util.stream.Collectors.groupingBy(QuerySignal::path, LinkedHashMap::new,
                        java.util.stream.Collectors.toList()));

        Map<String, SearchDemandProfile> profiles = new LinkedHashMap<>();
        grouped.forEach((page, pageSignals) -> profiles.put(page, buildProfile(page, pageSignals)));
        Map<String, SearchDemandProfile> immutable = Map.copyOf(profiles);
        cache = new Cache(signature, immutable);
        return immutable;
    }

    private SearchDemandProfile buildProfile(String path, List<QuerySignal> signals) {
        QuerySignal primary = signals.stream()
                .max(Comparator.comparingDouble(QuerySignal::impressions)
                        .thenComparingDouble(QuerySignal::clicks))
                .orElse(signals.get(0));

        double impressions = signals.stream().mapToDouble(QuerySignal::impressions).sum();
        double clicks = signals.stream().mapToDouble(QuerySignal::clicks).sum();
        double weightedPosition = signals.stream()
                .mapToDouble(signal -> signal.position() * Math.max(signal.impressions(), 1.0))
                .sum();
        double averagePosition = impressions > 0 ? weightedPosition / impressions : primary.position();
        double ctr = impressions > 0 ? clicks / impressions : 0.0;
        String intent = classifyIntent(primary.query());
        double striking = strikingDistanceScore(averagePosition, impressions);
        double ctrGap = ctrGapScore(averagePosition, ctr, impressions);
        double demand = demandScore(impressions, clicks);
        double opportunity = Math.min(100.0, demand * 0.35 + striking * 0.35 + ctrGap * 0.20
                + intentSpecificityScore(intent) * 0.10);

        return SearchDemandProfile.builder()
                .path(path)
                .primaryQuery(primary.query())
                .intent(intent)
                .queryCount(signals.size())
                .clicks(clicks)
                .impressions(impressions)
                .averagePosition(averagePosition)
                .ctr(ctr)
                .opportunityScore(opportunity)
                .strikingDistanceScore(striking)
                .ctrGapScore(ctrGap)
                .recommendedAction(recommendedAction(averagePosition, ctrGap, intent))
                .build();
    }

    private SearchDemandProfile fallbackProfile(String path) {
        String intent = classifyIntent(path.replace('-', ' '));
        double cohortScore = 0.0;
        County county = countyForPath(path);
        if (county != null) {
            if (seoIndexingPolicyService.isRecoveryTrafficCandidate(county)) {
                cohortScore = 40.0;
            } else if (seoIndexingPolicyService.isGrowthTrafficCandidate(county)) {
                cohortScore = 28.0;
            }
        }
        return SearchDemandProfile.builder()
                .path(path)
                .primaryQuery("")
                .intent(intent)
                .queryCount(0)
                .clicks(0)
                .impressions(0)
                .averagePosition(0)
                .ctr(0)
                .opportunityScore(cohortScore)
                .strikingDistanceScore(0)
                .ctrGapScore(0)
                .recommendedAction(cohortScore > 0 ? "Keep recovery or growth internal links prominent until fresh GSC data arrives." : "Await query data before changing this page's search intent.")
                .build();
    }

    private County countyForPath(String path) {
        String[] segments = path.split("/");
        if (segments.length < 4) {
            return null;
        }
        return dataLoadService.getCountyBySlugMap().get(segments[2] + "/" + segments[3]);
    }

    private String classifyIntent(String raw) {
        String query = raw == null ? "" : raw.toLowerCase(Locale.ROOT);
        if (containsAny(query, COMMERCIAL_TERMS)) {
            return "commercial";
        }
        if (containsAny(query, TRANSACTION_TERMS)) {
            return "transaction";
        }
        if (containsAny(query, TESTING_TERMS)) {
            return "testing";
        }
        if (containsAny(query, LEVEL_TERMS)) {
            return "levels";
        }
        if (containsAny(query, COST_TERMS)) {
            return "cost";
        }
        return "general";
    }

    private boolean containsAny(String value, Set<String> terms) {
        return terms.stream().anyMatch(value::contains);
    }

    private double demandScore(double impressions, double clicks) {
        return Math.min(100.0, Math.log1p(impressions) * 12.0 + Math.log1p(clicks) * 8.0);
    }

    private double strikingDistanceScore(double position, double impressions) {
        if (position >= 8 && position <= 15) {
            return Math.min(100.0, 90.0 + Math.min(10.0, Math.log1p(impressions)));
        }
        if (position > 15 && position <= 30) {
            return Math.min(85.0, 55.0 + (30.0 - position) * 2.0);
        }
        if (position > 30 && position <= 60) {
            return Math.max(0.0, 35.0 - (position - 30.0) * 0.8);
        }
        return 5.0;
    }

    private double ctrGapScore(double position, double ctr, double impressions) {
        double expected = position <= 3 ? 0.15 : position <= 10 ? 0.08 : position <= 20 ? 0.04 : 0.015;
        if (impressions < 3) {
            return 0.0;
        }
        return Math.max(0.0, Math.min(100.0, ((expected - ctr) / Math.max(expected, 0.01)) * 100.0));
    }

    private double intentSpecificityScore(String intent) {
        return "general".equals(intent) ? 25.0 : 100.0;
    }

    private String recommendedAction(double position, double ctrGap, String intent) {
        if (position >= 8 && position <= 20 && ctrGap >= 35) {
            return "Rewrite title, H1, and first answer for the " + intent + " query before adding more URLs.";
        }
        if (position > 20 && position <= 40) {
            return "Strengthen evidence block and internal links from the state and peer hubs.";
        }
        if (position > 40) {
            return "Add a distinct intent answer and one measured peer comparison; do not expand this cluster yet.";
        }
        return "Preserve the winning page and route more relevant internal links to it.";
    }

    private List<QuerySignal> readSignals(Path path) {
        if (!Files.exists(path)) {
            return List.of();
        }
        try {
            List<String> lines = Files.readAllLines(path);
            if (lines.size() < 2) {
                return List.of();
            }
            List<String> headers = parseCsv(lines.get(0));
            int queryIndex = headerIndex(headers, "query", "keyword");
            int pageIndex = headerIndex(headers, "page", "url");
            int clicksIndex = headerIndex(headers, "clicks", "click");
            int impressionsIndex = headerIndex(headers, "impressions", "impression");
            int ctrIndex = headerIndex(headers, "ctr");
            int positionIndex = headerIndex(headers, "position", "avg position");
            if (queryIndex < 0 || pageIndex < 0) {
                return List.of();
            }

            List<QuerySignal> signals = new ArrayList<>();
            for (int i = 1; i < lines.size(); i++) {
                List<String> columns = parseCsv(lines.get(i));
                String page = normalizePath(value(columns, pageIndex));
                String query = value(columns, queryIndex).toLowerCase(Locale.ROOT).trim();
                if (page.isBlank() || query.isBlank()) {
                    continue;
                }
                double impressions = number(columns, impressionsIndex);
                double clicks = number(columns, clicksIndex);
                double ctr = number(columns, ctrIndex);
                if (ctr > 1.0) {
                    ctr /= 100.0;
                }
                if (ctr <= 0 && impressions > 0) {
                    ctr = clicks / impressions;
                }
                signals.add(new QuerySignal(page, query, clicks, impressions, ctr,
                        number(columns, positionIndex)));
            }
            return signals;
        } catch (IOException ignored) {
            return List.of();
        }
    }

    private List<QuerySignal> readSeedSignals() {
        ClassPathResource resource = new ClassPathResource("data/search_demand_seeds.csv");
        if (!resource.exists()) {
            return List.of();
        }
        try (InputStream input = resource.getInputStream()) {
            List<String> lines = new String(input.readAllBytes(), java.nio.charset.StandardCharsets.UTF_8)
                    .lines().toList();
            return readSignals(lines);
        } catch (IOException ignored) {
            return List.of();
        }
    }

    private List<QuerySignal> readSignals(List<String> lines) {
        if (lines.size() < 2) {
            return List.of();
        }
        List<String> headers = parseCsv(lines.get(0));
        int queryIndex = headerIndex(headers, "query", "keyword");
        int pageIndex = headerIndex(headers, "page", "url");
        int clicksIndex = headerIndex(headers, "clicks", "click");
        int impressionsIndex = headerIndex(headers, "impressions", "impression");
        int ctrIndex = headerIndex(headers, "ctr");
        int positionIndex = headerIndex(headers, "position", "avg position");
        if (queryIndex < 0 || pageIndex < 0) {
            return List.of();
        }

        List<QuerySignal> signals = new ArrayList<>();
        for (int i = 1; i < lines.size(); i++) {
            List<String> columns = parseCsv(lines.get(i));
            String page = normalizePath(value(columns, pageIndex));
            String query = value(columns, queryIndex).toLowerCase(Locale.ROOT).trim();
            if (page.isBlank() || query.isBlank()) {
                continue;
            }
            double impressions = number(columns, impressionsIndex);
            double clicks = number(columns, clicksIndex);
            double ctr = number(columns, ctrIndex);
            if (ctr > 1.0) {
                ctr /= 100.0;
            }
            if (ctr <= 0 && impressions > 0) {
                ctr = clicks / impressions;
            }
            signals.add(new QuerySignal(page, query, clicks, impressions, ctr,
                    number(columns, positionIndex)));
        }
        return signals;
    }

    private int headerIndex(List<String> headers, String... needles) {
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

    private double number(List<String> columns, int index) {
        String value = value(columns, index).replace(",", "").replace("%", "").trim();
        if (value.isBlank()) {
            return 0.0;
        }
        try {
            return Double.parseDouble(value);
        } catch (NumberFormatException ignored) {
            return 0.0;
        }
    }

    private String value(List<String> columns, int index) {
        return index >= 0 && index < columns.size() ? columns.get(index).trim() : "";
    }

    private List<String> parseCsv(String line) {
        List<String> values = new ArrayList<>();
        StringBuilder current = new StringBuilder();
        boolean quoted = false;
        for (int i = 0; i < line.length(); i++) {
            char ch = line.charAt(i);
            if (ch == '"') {
                if (quoted && i + 1 < line.length() && line.charAt(i + 1) == '"') {
                    current.append('"');
                    i++;
                } else {
                    quoted = !quoted;
                }
            } else if (ch == ',' && !quoted) {
                values.add(current.toString());
                current.setLength(0);
            } else {
                current.append(ch);
            }
        }
        values.add(current.toString());
        return values;
    }

    private String normalizePath(String raw) {
        if (raw == null || raw.isBlank()) {
            return "";
        }
        String value = raw.trim();
        if (value.startsWith("http://") || value.startsWith("https://")) {
            try {
                value = URI.create(value).getPath();
            } catch (IllegalArgumentException ignored) {
                return "";
            }
        }
        if (value == null || value.isBlank()) {
            return "/";
        }
        if (!value.startsWith("/")) {
            value = "/" + value;
        }
        return value.length() > 1 && value.endsWith("/") ? value.substring(0, value.length() - 1) : value;
    }

    private String fileSignature(Path path) {
        try {
            return path + ":" + Files.getLastModifiedTime(path).toMillis() + ":" + Files.size(path);
        } catch (IOException e) {
            return path + ":missing";
        }
    }

    private record QuerySignal(String path, String query, double clicks, double impressions, double ctr,
            double position) {
    }

    private record Cache(String signature, Map<String, SearchDemandProfile> profiles) {
    }
}
