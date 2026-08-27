package com.radonverdict;

import com.radonverdict.model.dto.SeoRecoveryReport;
import com.radonverdict.service.SeoRecoveryEngineService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest(properties = {
        "app.storage.search-console-snapshot-dir=build/tmp/seo-recovery/snapshots",
        "app.storage.search-console-indexing-csv-path=build/tmp/seo-recovery/indexing.csv"
})
class SeoRecoveryEngineServiceTest {
    private static final Path SNAPSHOTS = Paths.get("build", "tmp", "seo-recovery", "snapshots");
    private static final Path INDEXING = Paths.get("build", "tmp", "seo-recovery", "indexing.csv");

    @Autowired
    private SeoRecoveryEngineService engine;

    @BeforeEach
    void writeExports() throws Exception {
        Files.createDirectories(SNAPSHOTS);
        Files.writeString(SNAPSHOTS.resolve("query-page-2026-07-01.csv"), String.join(System.lineSeparator(),
                "Query,Page,Clicks,Impressions,Position",
                "what does my radon test result mean,https://radonverdict.com/radon-levels,0,300,14",
                "schenectady county ny epa radon zone,https://radonverdict.com/radon-levels/new-york/schenectady-county,0,100,10",
                "radon testing boulder co,https://radonverdict.com/radon-levels/colorado/boulder-county,0,60,20",
                "dupage county radon levels,https://radonverdict.com/radon-levels/illinois/dupage-county,1,80,8",
                "radon gas testing ulster county ny,https://radonverdict.com/radon-levels/new-york/ulster-county,0,20,58",
                ""));
        Files.writeString(SNAPSHOTS.resolve("query-page-2026-07-29.csv"), String.join(System.lineSeparator(),
                "Query,Page,Clicks,Impressions,Position",
                "what does my radon test result mean,https://radonverdict.com/radon-levels,0,450,14",
                "schenectady county ny epa radon zone,https://radonverdict.com/radon-levels/new-york/schenectady-county,0,120,9",
                "radon testing boulder co,https://radonverdict.com/radon-levels/colorado/boulder-county,0,80,18",
                "radon mitigation boulder co,https://radonverdict.com/radon-mitigation-cost/colorado/boulder-county,0,100,15",
                "radon gas testing ulster county ny,https://radonverdict.com/radon-levels/new-york/ulster-county,0,35,55",
                ""));
        Files.writeString(INDEXING, String.join(System.lineSeparator(),
                "Page,Status",
                "https://radonverdict.com/radon-levels/colorado/boulder-county,Crawled - currently not indexed",
                "https://radonverdict.com/radon-levels/new-york/schenectady-county,Indexed",
                "https://radonverdict.com/guides/how-to-test-for-radon,Crawled - currently not indexed",
                ""));
    }

    @Test
    void engineSeparatesSnippetAndIndexingFailuresAndIgnoresQuarantinedCostUrls() {
        SeoRecoveryReport report = engine.buildReport();

        assertThat(report.isSnapshotsAvailable()).isTrue();
        assertThat(report.getSnapshotCount()).isEqualTo(2);
        assertThat(report.getPriorSnapshotDate()).isEqualTo("2026-07-01");
        assertThat(report.getLatestSnapshotDate()).isEqualTo("2026-07-29");
        assertThat(report.getActions()).extracting(SeoRecoveryReport.RecoveryAction::getPath)
                .containsExactlyInAnyOrder(
                        "/radon-levels",
                        "/radon-levels/new-york/schenectady-county",
                        "/radon-levels/new-york/ulster-county",
                        "/guides/how-to-test-for-radon")
                .doesNotContain(
                        "/radon-mitigation-cost/colorado/boulder-county",
                        "/radon-levels/colorado/boulder-county",
                        "/radon-levels/illinois/dupage-county");
        assertThat(action(report, "/radon-levels").getCohort()).isEqualTo("pillar");
        assertThat(action(report, "/radon-levels").getDecision()).isEqualTo("STRENGTHEN_ANSWER");
        assertThat(action(report, "/radon-levels/new-york/ulster-county").getDecision()).isEqualTo("STRENGTHEN_ANSWER");
        assertThat(action(report, "/guides/how-to-test-for-radon").getDecision()).isEqualTo("FIX_INDEXING");
        assertThat(report.getActivationBriefs()).anyMatch(brief ->
                "/radon-levels/new-york/schenectady-county".equals(brief.getPath()));
    }

    private SeoRecoveryReport.RecoveryAction action(SeoRecoveryReport report, String path) {
        return report.getActions().stream().filter(row -> path.equals(row.getPath())).findFirst().orElseThrow();
    }
}
