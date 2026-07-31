package com.radonverdict.service;

import com.radonverdict.model.County;
import com.radonverdict.model.dto.SeoRecoveryReport;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Stream;

/**
 * Turns dated Search Console exports into one defensible action per indexable URL.
 * It deliberately does not modify content: an export is evidence, not permission to churn a page.
 */
@Service
@RequiredArgsConstructor
public class SeoRecoveryEngineService {
    private static final Pattern DATE_IN_FILE_NAME = Pattern.compile("(20\\d{2}-\\d{2}-\\d{2})");
    private static final Set<String> TRAFFIC_PILLARS = Set.of(
            "/radon-test-result-meaning",
            "/radon-levels",
            "/guides/how-to-test-for-radon",
            "/guides/radon-failed-inspection");
    private static final Map<String, ActivationSeed> ACTIVATION_SEEDS = Map.of(
            "/radon-levels/new-york/schenectady-county", new ActivationSeed(
                    "https://radonverdict.com/radon-data-sources#schenectady-county",
                    "New York State Department of Health's 2015–2019 submitted-test summary for Schenectady County reports a 2.4 pCi/L average and 16.0% of submitted tests at or above 4.0 pCi/L.",
                    "This is a submitted-test county summary, not a prediction for an individual basement.",
                    "local public-health resource editors, home-inspection education pages, and housing-information publishers"),
            "/radon-levels/virginia/falls-church-city", new ActivationSeed(
                    "https://radonverdict.com/radon-data-sources#falls-church-city",
                    "Virginia Department of Health's 2016–2024 Falls Church record contains 165 reported tests and a citywide average of 2.6 pCi/L.",
                    "The citywide record is not a basement-only measurement and cannot replace a test in a specific home.",
                    "Virginia home-inspection educators, local housing-information publishers, and public-health resource editors"),
            "/radon-levels/new-york/ulster-county", new ActivationSeed(
                    "https://radonverdict.com/radon-data-sources#ulster-county",
                    "New York State Department of Health's 2015–2019 submitted-test summary for Ulster County reports a 3.8 pCi/L average and 24.4% of submitted tests at or above 4.0 pCi/L.",
                    "This is county context from submitted tests, not a diagnosis or a property-level result.",
                    "Ulster-area home-inspection educators, housing-information publishers, and local public-health resource editors"));

    private final DataLoadService dataLoadService;
    private final SeoIndexingPolicyService seoIndexingPolicyService;

    @Value("${app.storage.search-console-snapshot-dir:data/search-console/snapshots}")
    private String snapshotDirectory;

    @Value("${app.storage.search-console-indexing-csv-path:data/search-console-indexing.csv}")
    private String indexingCsvPath;

    public SeoRecoveryReport buildReport() {
        Map<LocalDate, Map<String, PageMetrics>> snapshots = readSnapshots();
        List<LocalDate> dates = snapshots.keySet().stream().sorted().toList();
        if (dates.isEmpty()) {
            return SeoRecoveryReport.builder()
                    .snapshotsAvailable(false)
                    .snapshotCount(0)
                    .summary("No dated query/page exports are loaded. The recovery engine is intentionally holding content changes until it can compare two windows.")
                    .actions(List.of())
                    .activationBriefs(List.of())
                    .build();
        }

        LocalDate latestDate = dates.getLast();
        LocalDate priorDate = dates.size() > 1 ? dates.get(dates.size() - 2) : null;
        Map<String, String> indexing = readIndexingStatuses();
        Map<String, PageMetrics> latest = snapshots.get(latestDate);
        Map<String, PageMetrics> prior = priorDate == null ? Map.of() : snapshots.get(priorDate);

        Set<String> observedPaths = new LinkedHashSet<>();
        observedPaths.addAll(latest.keySet());
        observedPaths.addAll(prior.keySet());
        // Search performance is absent precisely when an important URL is excluded.
        // Include every inspected path so an indexing failure cannot disappear from the queue.
        observedPaths.addAll(indexing.keySet());
        List<SeoRecoveryReport.RecoveryAction> actions = observedPaths.stream()
                .filter(this::isEligibleIndexablePath)
                .map(path -> actionFor(path, latest.getOrDefault(path, new PageMetrics()), prior.get(path), indexing.get(path), priorDate != null))
                .sorted(Comparator.comparingInt((SeoRecoveryReport.RecoveryAction row) -> urgencyRank(row.getUrgency()))
                        .thenComparing(Comparator.comparingDouble(SeoRecoveryReport.RecoveryAction::getLatestImpressions).reversed()))
                .toList();

        String summary = priorDate == null
                ? "One dated export is loaded. This is a baseline, not a recovery verdict; add the next comparable export before changing page copy."
                : "Comparing " + priorDate + " to " + latestDate + ". Each row has one evidence-based action; no row authorizes a bulk rewrite.";

        return SeoRecoveryReport.builder()
                .snapshotsAvailable(true)
                .snapshotCount(dates.size())
                .latestSnapshotDate(latestDate.toString())
                .priorSnapshotDate(priorDate == null ? null : priorDate.toString())
                .summary(summary)
                .actions(actions)
                .activationBriefs(buildActivationBriefs(actions, priorDate != null))
                .build();
    }

    private List<SeoRecoveryReport.ActivationBrief> buildActivationBriefs(
            List<SeoRecoveryReport.RecoveryAction> actions, boolean comparisonAvailable) {
        return actions.stream()
                .filter(action -> ACTIVATION_SEEDS.containsKey(action.getPath()))
                .map(action -> activationBriefFor(action, ACTIVATION_SEEDS.get(action.getPath()), comparisonAvailable))
                .toList();
    }

    private SeoRecoveryReport.ActivationBrief activationBriefFor(
            SeoRecoveryReport.RecoveryAction action, ActivationSeed seed, boolean comparisonAvailable) {
        boolean indexingBlocked = "FIX_INDEXING".equals(action.getDecision());
        boolean ready = comparisonAvailable && !indexingBlocked && action.getLatestImpressions() >= 20;
        String releaseReason = ready
                ? "Two comparable windows exist, the URL has search visibility, and no indexing blocker is reported. This is eligible for a small, relevant citation outreach batch."
                : indexingBlocked
                ? "Blocked until the indexing issue is resolved. Do not ask others to cite a page Google is excluding."
                : !comparisonAvailable
                ? "Blocked until a second comparable Search Console window is loaded. Do not confuse a one-window snapshot with recovery."
                : "Blocked until the page has at least 20 impressions in the latest comparable window.";
        String query = action.getPrimaryQuery() == null || action.getPrimaryQuery().isBlank()
                ? "the local radon evidence question"
                : action.getPrimaryQuery();
        String subject = "Citable local radon source note for " + shortPlace(action.getPath());
        String body = "Hello,\n\nWe published a short, source-linked local radon evidence note for readers searching '"
                + query + "'.\n\n" + seed.evidenceClaim + " " + seed.claimBoundary
                + "\n\nIf you maintain a local testing, home-inspection, public-health, or housing resource, you may cite the record here: "
                + seed.publicCitationUrl + "\n\nWe are not asking you to repeat a property-level claim; the page states the source period and limitation directly.\n\nThank you.";
        return SeoRecoveryReport.ActivationBrief.builder()
                .path(action.getPath())
                .primaryQuery(query)
                .status(ready ? "READY_TO_PITCH" : "HOLD")
                .releaseReason(releaseReason)
                .publicCitationUrl(seed.publicCitationUrl)
                .evidenceClaim(seed.evidenceClaim)
                .claimBoundary(seed.claimBoundary)
                .targetEditors(seed.targetEditors)
                .outreachSubject(subject)
                .outreachBody(body)
                .build();
    }

    private String shortPlace(String path) {
        if (path.contains("schenectady")) return "Schenectady County, NY";
        if (path.contains("falls-church")) return "Falls Church, VA";
        if (path.contains("ulster")) return "Ulster County, NY";
        return path;
    }

    private SeoRecoveryReport.RecoveryAction actionFor(String path, PageMetrics latest, PageMetrics prior,
            String indexingStatus, boolean comparisonAvailable) {
        String primaryQuery = latest.primaryQuery.isBlank() && prior != null ? prior.primaryQuery : latest.primaryQuery;
        String status = indexingStatus == null || indexingStatus.isBlank() ? "No indexing export match" : indexingStatus;
        double clickChange = change(latest.clicks, prior == null ? 0 : prior.clicks);
        double impressionChange = change(latest.impressions, prior == null ? 0 : prior.impressions);
        String decision;
        String reason;
        String urgency;

        String normalizedStatus = status.toLowerCase(Locale.ROOT);
        if (normalizedStatus.contains("not indexed") || normalizedStatus.contains("excluded")) {
            decision = "FIX_INDEXING";
            reason = "Search Console reports '" + status + "'. Resolve the indexability/canonical/crawl cause before editing the answer.";
            urgency = "critical";
        } else if (!comparisonAvailable) {
            decision = "BASELINE_ONLY";
            reason = "Only one window is available: " + fmt(latest.impressions) + " impressions at position " + fmt(latest.position()) + ". Preserve the recent pivot until a comparable export arrives.";
            urgency = "watch";
        } else if (latest.impressions >= 20 && latest.position() <= 12 && latest.ctr() < expectedCtr(latest.position()) * 0.55) {
            decision = "REWRITE_SNIPPET";
            reason = "Visible near the top (position " + fmt(latest.position()) + ") but CTR is " + percent(latest.ctr()) + ". Change the title/description/first answer for '" + primaryQuery + "', not the URL or page topic.";
            urgency = "high";
        } else if (latest.impressions >= 20 && latest.position() > 12 && latest.position() <= 60) {
            decision = "STRENGTHEN_ANSWER";
            reason = "The query '" + primaryQuery + "' has " + fmt(latest.impressions) + " impressions at position " + fmt(latest.position()) + ". Google is testing the URL but not finding it competitive yet. Add the missing direct answer and source-specific evidence; keep one canonical intent.";
            urgency = "high";
        } else if ((latest.impressions >= 10 || (prior != null && prior.impressions >= 10)) && impressionChange <= -45) {
            decision = "AUDIT_DECLINE";
            reason = "Impressions fell " + percent(Math.abs(impressionChange)) + " vs. the prior window. Check crawl date, canonical, rendered answer, and competing page before changing copy.";
            urgency = "high";
        } else if (latest.position() <= 8 || latest.clicks > 0) {
            decision = "DEFEND_WINNER";
            reason = "The page is already earning visibility or clicks. Preserve its intent; add only relevant internal links and monitor the next window.";
            urgency = "watch";
        } else {
            decision = "HOLD_AND_MEASURE";
            reason = "Insufficient evidence of a specific failure. Keep the page stable and collect another comparable export.";
            urgency = "watch";
        }

        return SeoRecoveryReport.RecoveryAction.builder()
                .path(path)
                .cohort(cohortFor(path))
                .primaryQuery(primaryQuery)
                .indexingStatus(status)
                .decision(decision)
                .reason(reason)
                .urgency(urgency)
                .latestClicks(latest.clicks)
                .latestImpressions(latest.impressions)
                .latestCtr(latest.ctr())
                .latestPosition(latest.position())
                .clickChangePercent(comparisonAvailable ? clickChange : 0)
                .impressionChangePercent(comparisonAvailable ? impressionChange : 0)
                .build();
    }

    private Map<LocalDate, Map<String, PageMetrics>> readSnapshots() {
        Path directory = Paths.get(snapshotDirectory);
        if (!Files.isDirectory(directory)) return Map.of();
        Map<LocalDate, Map<String, PageMetrics>> results = new LinkedHashMap<>();
        try (Stream<Path> files = Files.list(directory)) {
            files.filter(path -> path.getFileName().toString().toLowerCase(Locale.ROOT).endsWith(".csv"))
                    .forEach(file -> mergeSnapshot(file, results));
        } catch (IOException ignored) {
            return Map.of();
        }
        return results;
    }

    private void mergeSnapshot(Path file, Map<LocalDate, Map<String, PageMetrics>> results) {
        LocalDate fallbackDate = dateFromFileName(file.getFileName().toString());
        try {
            List<String> lines = Files.readAllLines(file);
            if (lines.size() < 2) return;
            List<String> headers = parseCsv(lines.getFirst());
            int dateIndex = headerIndex(headers, "date");
            int queryIndex = headerIndex(headers, "query", "keyword");
            int pageIndex = headerIndex(headers, "page", "url");
            int clicksIndex = headerIndex(headers, "clicks", "click");
            int impressionsIndex = headerIndex(headers, "impressions", "impression");
            int positionIndex = headerIndex(headers, "position", "avg position");
            if (queryIndex < 0 || pageIndex < 0 || (dateIndex < 0 && fallbackDate == null)) return;
            for (int i = 1; i < lines.size(); i++) {
                List<String> row = parseCsv(lines.get(i));
                LocalDate date = dateIndex < 0 ? fallbackDate : parseDate(value(row, dateIndex));
                String path = normalizePath(value(row, pageIndex));
                String query = value(row, queryIndex).toLowerCase(Locale.ROOT);
                if (date == null || path.isBlank() || query.isBlank()) continue;
                results.computeIfAbsent(date, unused -> new HashMap<>())
                        .computeIfAbsent(path, unused -> new PageMetrics())
                        .add(query, number(row, clicksIndex), number(row, impressionsIndex), number(row, positionIndex));
            }
        } catch (IOException ignored) {
            // A malformed operator export must not take down the admin recovery console.
        }
    }

    private Map<String, String> readIndexingStatuses() {
        Path file = Paths.get(indexingCsvPath);
        if (!Files.exists(file)) return Map.of();
        try {
            List<String> lines = Files.readAllLines(file);
            if (lines.size() < 2) return Map.of();
            List<String> headers = parseCsv(lines.getFirst());
            int pageIndex = headerIndex(headers, "page", "url");
            int statusIndex = headerIndex(headers, "status", "indexing state", "reason");
            if (pageIndex < 0 || statusIndex < 0) return Map.of();
            Map<String, String> statuses = new HashMap<>();
            for (int i = 1; i < lines.size(); i++) {
                List<String> row = parseCsv(lines.get(i));
                String path = normalizePath(value(row, pageIndex));
                if (!path.isBlank()) statuses.put(path, value(row, statusIndex));
            }
            return statuses;
        } catch (IOException ignored) {
            return Map.of();
        }
    }

    private boolean isEligibleIndexablePath(String path) {
        if (path.startsWith("/radon-mitigation-cost") || path.startsWith("/radon-credit-calculator") || path.equals("/plan")) return false;
        if (TRAFFIC_PILLARS.contains(path)) return true;
        County county = countyFor(path);
        return county != null && seoIndexingPolicyService.isCountyIndexableCandidate(county);
    }

    private County countyFor(String path) {
        String[] segments = path.split("/");
        if (segments.length < 4) return null;
        return dataLoadService.getCountyBySlugMap().get(segments[2] + "/" + segments[3]);
    }

    private String cohortFor(String path) {
        if (TRAFFIC_PILLARS.contains(path)) return "pillar";
        County county = countyFor(path);
        if (county == null) return "other";
        if (seoIndexingPolicyService.isRecoveryTrafficCandidate(county)) return "recovery";
        if (seoIndexingPolicyService.isGrowthTrafficCandidate(county)) return "growth";
        return "evidence";
    }

    private int urgencyRank(String urgency) {
        return switch (urgency) { case "critical" -> 0; case "high" -> 1; default -> 2; };
    }

    private double expectedCtr(double position) {
        return position <= 3 ? 0.15 : position <= 10 ? 0.08 : 0.04;
    }

    private double change(double latest, double prior) {
        if (prior <= 0) return latest > 0 ? 100 : 0;
        return ((latest - prior) / prior) * 100;
    }

    private String percent(double value) { return String.format(Locale.US, "%.0f%%", value * (Math.abs(value) <= 1 ? 100 : 1)); }
    private String fmt(double value) { return String.format(Locale.US, "%.1f", value); }

    private LocalDate dateFromFileName(String name) {
        Matcher matcher = DATE_IN_FILE_NAME.matcher(name);
        return matcher.find() ? parseDate(matcher.group(1)) : null;
    }

    private LocalDate parseDate(String value) {
        try { return LocalDate.parse(value.trim(), DateTimeFormatter.ISO_LOCAL_DATE); }
        catch (DateTimeParseException ignored) { return null; }
    }

    private String normalizePath(String raw) {
        if (raw == null || raw.isBlank()) return "";
        try {
            java.net.URI uri = java.net.URI.create(raw.trim());
            return uri.getPath() == null || uri.getPath().isBlank() ? raw.trim() : uri.getPath();
        } catch (IllegalArgumentException ignored) {
            return raw.trim().split("\\?", 2)[0];
        }
    }

    private int headerIndex(List<String> headers, String... names) {
        for (int i = 0; i < headers.size(); i++) for (String name : names)
            if (headers.get(i).toLowerCase(Locale.ROOT).contains(name)) return i;
        return -1;
    }

    private double number(List<String> row, int index) {
        try { return Double.parseDouble(value(row, index).replace(",", "").replace("%", "")); }
        catch (NumberFormatException ignored) { return 0; }
    }

    private String value(List<String> row, int index) { return index >= 0 && index < row.size() ? row.get(index).trim() : ""; }

    private List<String> parseCsv(String line) {
        List<String> cells = new ArrayList<>(); StringBuilder cell = new StringBuilder(); boolean quoted = false;
        for (int i = 0; i < line.length(); i++) {
            char ch = line.charAt(i);
            if (ch == '"') { if (quoted && i + 1 < line.length() && line.charAt(i + 1) == '"') { cell.append(ch); i++; } else quoted = !quoted; }
            else if (ch == ',' && !quoted) { cells.add(cell.toString()); cell.setLength(0); }
            else cell.append(ch);
        }
        cells.add(cell.toString()); return cells;
    }

    private static class PageMetrics {
        private double clicks; private double impressions; private double weightedPosition; private String primaryQuery = ""; private double primaryQueryImpressions;
        void add(String query, double addClicks, double addImpressions, double position) {
            clicks += addClicks; impressions += addImpressions; weightedPosition += position * Math.max(addImpressions, 1);
            if (addImpressions >= primaryQueryImpressions) { primaryQuery = query; primaryQueryImpressions = addImpressions; }
        }
        double ctr() { return impressions == 0 ? 0 : clicks / impressions; }
        double position() { return impressions == 0 ? 0 : weightedPosition / impressions; }
    }

    private record ActivationSeed(String publicCitationUrl, String evidenceClaim, String claimBoundary,
                                  String targetEditors) { }
}
