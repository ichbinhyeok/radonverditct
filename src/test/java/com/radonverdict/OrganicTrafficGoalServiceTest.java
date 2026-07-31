package com.radonverdict;

import com.radonverdict.model.dto.OrganicTrafficGoalReport;
import com.radonverdict.service.OrganicTrafficGoalService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest(properties = "app.storage.search-console-daily-query-csv-path=build/tmp/organic-click-goal/daily-query-page.csv")
class OrganicTrafficGoalServiceTest {
    private static final Path EXPORT = Paths.get("build", "tmp", "organic-click-goal", "daily-query-page.csv");

    @Autowired
    private OrganicTrafficGoalService service;

    @BeforeEach
    void writeDailyExport() throws Exception {
        Files.createDirectories(EXPORT.getParent());
        Files.writeString(EXPORT, String.join(System.lineSeparator(),
                "Date,Query,Page,Clicks,Impressions,Position",
                "2026-07-01,what does my radon test result mean,https://radonverdict.com/radon-test-result-meaning,30,600,8",
                "2026-07-02,what does my radon test result mean,https://radonverdict.com/radon-test-result-meaning,30,800,7",
                "2026-07-02,radon levels by county,https://radonverdict.com/radon-levels,20,350,8",
                "2026-07-01,how to test for radon,https://radonverdict.com/guides/how-to-test-for-radon,12,400,9",
                "2026-07-02,how to test for radon,https://radonverdict.com/guides/how-to-test-for-radon,18,450,8",
                "2026-07-01,radon failed inspection,https://radonverdict.com/guides/radon-failed-inspection,4,80,11",
                "2026-07-02,radon failed inspection,https://radonverdict.com/guides/radon-failed-inspection,6,100,10",
                "2026-07-01,schenectady county ny epa radon zone,https://radonverdict.com/radon-levels/new-york/schenectady-county,1,40,8",
                "2026-07-02,ulster county radon test,https://radonverdict.com/radon-levels/new-york/ulster-county,3,60,9",
                ""));
    }

    @Test
    void measuresOnlyFocusedPagesAsARealDailyPortfolio() {
        OrganicTrafficGoalReport report = service.buildReport();

        assertThat(report.isDailyExportAvailable()).isTrue();
        assertThat(report.getDaysObserved()).isEqualTo(2);
        assertThat(report.getObservedDailyClicks()).isEqualTo(62.0);
        assertThat(report.getDailyClickShortfall()).isEqualTo(38.0);
        assertThat(report.getClusters()).extracting(OrganicTrafficGoalReport.Cluster::getName)
                .containsExactly("Result interpreter", "Test at home", "Inspection decision", "Local evidence");
        assertThat(report.getClusters().get(0).getObservedDailyClicks()).isEqualTo(40.0);
        assertThat(report.getClusters().get(3).getObservedDailyClicks()).isEqualTo(2.0);
    }
}
