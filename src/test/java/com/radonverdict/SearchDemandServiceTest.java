package com.radonverdict;

import com.radonverdict.model.dto.SearchDemandProfile;
import com.radonverdict.model.County;
import com.radonverdict.model.dto.CountyPageContent;
import com.radonverdict.service.ContentGenerationService;
import com.radonverdict.service.DataLoadService;
import com.radonverdict.service.SearchDemandService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest(properties = {
        "app.storage.search-console-query-csv-path=build/tmp/search-demand/search-console-query-page.csv"
})
class SearchDemandServiceTest {

    private static final Path EXPORT = Paths.get("build", "tmp", "search-demand", "search-console-query-page.csv");

    @Autowired
    private SearchDemandService searchDemandService;

    @Autowired
    private ContentGenerationService contentGenerationService;

    @Autowired
    private DataLoadService dataLoadService;

    @BeforeEach
    void writeExport() throws Exception {
        Files.createDirectories(EXPORT.getParent());
        Files.writeString(EXPORT, String.join(System.lineSeparator(),
                "Query,Page,Clicks,Impressions,CTR,Position",
                "radon testing boulder co,https://radonverdict.com/radon-mitigation-cost/colorado/boulder-county,4,80,5%,12.0",
                "boulder radon test,https://radonverdict.com/radon-mitigation-cost/colorado/boulder-county,2,40,5%,18.0",
                "radon mitigation cost boulder,https://radonverdict.com/radon-mitigation-cost/colorado/boulder-county,1,20,5%,31.0",
                ""));
    }

    @Test
    void queryExportCreatesTestingIntentOpportunity() {
        SearchDemandProfile profile = searchDemandService.profileForPath(
                "/radon-mitigation-cost/colorado/boulder-county");

        assertThat(profile.getPrimaryQuery()).isEqualTo("radon testing boulder co");
        assertThat(profile.getIntent()).isEqualTo("testing");
        assertThat(profile.getImpressions()).isEqualTo(140.0);
        assertThat(profile.getOpportunityScore()).isBetween(0.0, 100.0);
        assertThat(profile.getRecommendedAction()).isNotBlank();
    }

    @Test
    void topOpportunitiesAreSortedAndMissingPagesUseFallback() {
        List<SearchDemandProfile> profiles = searchDemandService.topOpportunities(5);

        assertThat(profiles).isNotEmpty();
        assertThat(profiles.get(0).getPath()).contains("boulder-county");
        SearchDemandProfile fallback = searchDemandService.profileForPath(
                "/radon-levels/california/butte-county");
        assertThat(fallback.getPath()).isEqualTo("/radon-levels/california/butte-county");
        assertThat(fallback.getRecommendedAction()).isNotBlank();
    }

    @Test
    void queryIntentChangesTheRenderedCountyTitleWithoutChangingItsCanonicalPath() {
        County county = dataLoadService.getCountyBySlugMap().get("colorado/boulder-county");
        CountyPageContent page = contentGenerationService.buildCostLandingPageContent(county);

        assertThat(page.getHeroTitle()).contains("Radon Testing and Mitigation Cost");
        assertThat(page.getSeoDescription()).contains("testing and mitigation");
    }
}
