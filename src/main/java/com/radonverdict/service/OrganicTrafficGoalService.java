package com.radonverdict.service;

import com.radonverdict.model.dto.OrganicTrafficGoalReport;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.net.URI;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;

/**
 * Measures the narrow organic-click portfolio that can credibly reach 100 daily clicks.
 * It accepts only a daily GSC export with an explicit Date column; aggregate snapshots
 * are intentionally never divided into a made-up daily number.
 */
@Service
public class OrganicTrafficGoalService {
    private static final int DAILY_CLICK_GOAL = 100;
    private static final List<ClusterDefinition> CLUSTERS = List.of(
            new ClusterDefinition("Result interpreter", 50, List.of("/radon-test-result-meaning", "/radon-levels")),
            new ClusterDefinition("Test at home", 30, List.of(
                    "/guides/how-to-test-for-radon",
                    "/guides/where-to-place-radon-test",
                    "/guides/short-term-vs-long-term-radon-test",
                    "/guides/radon-closed-house-conditions",
                    "/guides/is-my-radon-test-valid",
                    "/guides/when-to-retest-for-radon",
                    "/guides/can-you-open-windows-during-radon-test",
                    "/guides/can-you-live-in-house-during-radon-test",
                    "/guides/radon-test-during-rain-or-storm",
                    "/guides/best-time-of-year-to-test-for-radon",
                    "/guides/charcoal-vs-digital-radon-test",
                    "/guides/expired-radon-test-kit",
                    "/guides/radon-test-moved-or-tampered",
                    "/guides/how-to-mail-radon-test-kit",
                    "/guides/radon-testing-in-apartments",
                    "/guides/radon-test-after-renovation",
                    "/guides/radon-test-after-mitigation",
                    "/guides/radon-manometer-reading",
                    "/guides/radon-fan-noise",
                    "/guides/radon-mitigation-system-maintenance",
                    "/guides/how-long-do-radon-fans-last")),
            new ClusterDefinition("Inspection decision", 15, List.of("/guides/radon-failed-inspection")),
            new ClusterDefinition("Local evidence", 5, List.of(
                    "/radon-levels/new-york/schenectady-county",
                    "/radon-levels/virginia/falls-church-city",
                    "/radon-levels/new-york/ulster-county")));

    @Value("${app.storage.search-console-daily-query-csv-path:data/search-console/daily-query-page.csv}")
    private String dailyQueryCsvPath;

    public OrganicTrafficGoalReport buildReport() {
        List<DailyClick> rows = readRows();
        if (rows.isEmpty()) {
            return OrganicTrafficGoalReport.builder()
                    .dailyExportAvailable(false)
                    .dailyClickGoal(DAILY_CLICK_GOAL)
                    .dailyClickShortfall(DAILY_CLICK_GOAL)
                    .summary("No daily GSC query/page export is loaded. Add Date, Query, Page, and Clicks columns; aggregate exports are not treated as daily traffic.")
                    .clusters(emptyClusters())
                    .build();
        }

        LocalDate first = rows.stream().map(DailyClick::date).min(LocalDate::compareTo).orElseThrow();
        LocalDate last = rows.stream().map(DailyClick::date).max(LocalDate::compareTo).orElseThrow();
        int days = (int) java.time.temporal.ChronoUnit.DAYS.between(first, last) + 1;
        Map<String, Double> clicksByCluster = new LinkedHashMap<>();
        for (ClusterDefinition cluster : CLUSTERS) clicksByCluster.put(cluster.name(), 0.0);
        for (DailyClick row : rows) {
            CLUSTERS.stream().filter(cluster -> cluster.paths().contains(row.path())).findFirst()
                    .ifPresent(cluster -> clicksByCluster.compute(cluster.name(), (ignored, current) -> current + row.clicks()));
        }

        List<OrganicTrafficGoalReport.Cluster> clusters = CLUSTERS.stream().map(cluster -> {
            double daily = clicksByCluster.get(cluster.name()) / days;
            return OrganicTrafficGoalReport.Cluster.builder()
                    .name(cluster.name())
                    .dailyClickTarget(cluster.dailyClickTarget())
                    .observedDailyClicks(daily)
                    .dailyClickShortfall(Math.max(0, cluster.dailyClickTarget() - daily))
                    .paths(cluster.paths())
                    .build();
        }).toList();
        double total = clusters.stream().mapToDouble(OrganicTrafficGoalReport.Cluster::getObservedDailyClicks).sum();
        return OrganicTrafficGoalReport.builder()
                .dailyExportAvailable(true)
                .dailyClickGoal(DAILY_CLICK_GOAL)
                .daysObserved(days)
                .firstDate(first.toString())
                .lastDate(last.toString())
                .observedDailyClicks(total)
                .dailyClickShortfall(Math.max(0, DAILY_CLICK_GOAL - total))
                .summary("Daily organic clicks are measured only across the focused four-cluster portfolio. Expand a cluster only after its designated page earns durable clicks.")
                .clusters(clusters)
                .build();
    }

    private List<OrganicTrafficGoalReport.Cluster> emptyClusters() {
        return CLUSTERS.stream().map(cluster -> OrganicTrafficGoalReport.Cluster.builder()
                .name(cluster.name()).dailyClickTarget(cluster.dailyClickTarget()).observedDailyClicks(0)
                .dailyClickShortfall(cluster.dailyClickTarget()).paths(cluster.paths()).build()).toList();
    }

    private List<DailyClick> readRows() {
        Path file = Paths.get(dailyQueryCsvPath);
        if (!Files.exists(file)) return List.of();
        try {
            List<String> lines = Files.readAllLines(file);
            if (lines.size() < 2) return List.of();
            List<String> headers = parseCsv(lines.getFirst());
            int date = headerIndex(headers, "date");
            int page = headerIndex(headers, "page", "url");
            int clicks = headerIndex(headers, "clicks", "click");
            if (date < 0 || page < 0 || clicks < 0) return List.of();
            List<DailyClick> rows = new ArrayList<>();
            for (int i = 1; i < lines.size(); i++) {
                List<String> values = parseCsv(lines.get(i));
                LocalDate day = parseDate(value(values, date));
                String path = normalizePath(value(values, page));
                if (day != null && !path.isBlank()) rows.add(new DailyClick(day, path, number(value(values, clicks))));
            }
            return rows;
        } catch (IOException ignored) {
            return List.of();
        }
    }

    private int headerIndex(List<String> headers, String... names) {
        for (int i = 0; i < headers.size(); i++) for (String name : names)
            if (headers.get(i).toLowerCase(Locale.ROOT).contains(name)) return i;
        return -1;
    }

    private LocalDate parseDate(String value) {
        try { return LocalDate.parse(value); } catch (DateTimeParseException ignored) { return null; }
    }

    private String normalizePath(String raw) {
        if (raw == null || raw.isBlank()) return "";
        try {
            URI uri = URI.create(raw.trim());
            return uri.getPath() == null || uri.getPath().isBlank() ? raw.trim() : uri.getPath();
        } catch (IllegalArgumentException ignored) { return raw.trim().split("\\?", 2)[0]; }
    }

    private double number(String value) {
        try { return Double.parseDouble(value.replace(",", "")); } catch (NumberFormatException ignored) { return 0; }
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

    private record DailyClick(LocalDate date, String path, double clicks) { }
    private record ClusterDefinition(String name, int dailyClickTarget, List<String> paths) { }
}
