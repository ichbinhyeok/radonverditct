package com.radonverdict;

import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import static org.assertj.core.api.Assertions.assertThat;

class AcquisitionResearchAssetTest {
    private static final Path REPORT = Path.of(
            "radon_md", "reports", "seo-acquisition-system-2026-09-05");

    @Test
    void queryUniverseContainsTwoHundredUniqueQueriesAcrossTwentyFamilies() throws IOException {
        List<List<String>> rows = csv("query-universe-200.csv");
        assertThat(rows).hasSize(201);

        Set<String> queries = new HashSet<>();
        Set<String> families = new HashSet<>();
        for (List<String> row : rows.subList(1, rows.size())) {
            assertThat(row).hasSize(10);
            queries.add(row.get(1));
            families.add(row.get(2));
            assertThat(row.get(8)).startsWith("/guides/");
        }
        assertThat(queries).hasSize(200);
        assertThat(families).hasSize(20);
    }

    @Test
    void pagePortfolioHasFortyUniquePrioritiesAndNoUnreviewedPublishAction() throws IOException {
        List<List<String>> rows = csv("page-portfolio-40.csv");
        assertThat(rows).hasSize(41);
        Set<String> priorities = new HashSet<>();
        Set<String> allowedActions = Set.of(
                "LIVE_NOW", "LIVE_SUPPORT", "LIVE_TOOL", "LIVE_PILLAR", "REWRITE_PILLAR", "REWRITE_TOOL",
                "KEEP_HUB", "BUILD_AFTER_SIGNAL", "MERGE_QUERY", "HOLD");
        for (List<String> row : rows.subList(1, rows.size())) {
            assertThat(row).hasSize(6);
            priorities.add(row.get(0));
            assertThat(allowedActions).contains(row.get(3));
        }
        assertThat(priorities).hasSize(40);
    }

    @Test
    void migrationManifestIsUniqueAndDefaultsHistoricalGeneratedRoutesToGone() throws IOException {
        List<List<String>> rows = csv("legacy-url-migration-manifest.csv");
        assertThat(rows).hasSize(6583);
        Set<String> sources = new HashSet<>();
        long keep = 0;
        long redirect = 0;
        long gone = 0;
        for (List<String> row : rows.subList(1, rows.size())) {
            assertThat(row).hasSize(4);
            sources.add(row.get(0));
            switch (row.get(1)) {
                case "KEEP_200" -> keep++;
                case "REDIRECT_301" -> redirect++;
                case "GONE_410" -> gone++;
                default -> throw new AssertionError("Unknown disposition: " + row.get(1));
            }
        }
        assertThat(sources).hasSize(6582);
        assertThat(keep).isEqualTo(12);
        assertThat(redirect).isEqualTo(2);
        assertThat(gone).isEqualTo(6568);
    }

    private List<List<String>> csv(String name) throws IOException {
        return Files.readAllLines(REPORT.resolve(name)).stream().map(this::parseCsv).toList();
    }

    private List<String> parseCsv(String line) {
        List<String> cells = new ArrayList<>();
        StringBuilder cell = new StringBuilder();
        boolean quoted = false;
        for (int i = 0; i < line.length(); i++) {
            char ch = line.charAt(i);
            if (ch == '"') {
                if (quoted && i + 1 < line.length() && line.charAt(i + 1) == '"') {
                    cell.append('"');
                    i++;
                } else {
                    quoted = !quoted;
                }
            } else if (ch == ',' && !quoted) {
                cells.add(cell.toString());
                cell.setLength(0);
            } else {
                cell.append(ch);
            }
        }
        cells.add(cell.toString());
        return cells;
    }
}
