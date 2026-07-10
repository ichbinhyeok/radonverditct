package com.radonverdict;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.servlet.MockMvc;

import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.util.Base64;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.hamcrest.Matchers.containsString;
import static org.hamcrest.Matchers.not;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.header;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
class SeoBehaviorIntegrationTest {

    private static final Pattern JSON_LD_SCRIPT_PATTERN = Pattern.compile(
            "<script[^>]*type=['\\\"]application/ld\\+json['\\\"][^>]*>(.*?)</script>",
            Pattern.CASE_INSENSITIVE | Pattern.DOTALL);

    private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper();

    @Autowired
    private MockMvc mockMvc;

    @Test
    void homeRendersDecisionWorkspaceAndCanonicalUrl() throws Exception {
        mockMvc.perform(get("/"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("<title>RadonVerdict | Radon Result, Cost, and Next-Step Planner</title>")))
                .andExpect(content().string(containsString("<link rel=\"canonical\" href=\"https://radonverdict.com/\">")))
                .andExpect(content().string(containsString("RadonVerdict")))
                .andExpect(content().string(containsString("Decision console")))
                .andExpect(content().string(containsString("Radon reading")))
                .andExpect(content().string(containsString("Instant verdict")))
                .andExpect(content().string(containsString("Start with ZIP")))
                .andExpect(content().string(containsString("Open local action plan")))
                .andExpect(content().string(containsString("Every path starts from the decision you actually need.")))
                .andExpect(content().string(containsString("Situation decoder")))
                .andExpect(content().string(containsString("Paste the messy inspection sentence.")))
                .andExpect(content().string(containsString("<script src=\"/js/situation-decoder.js\"></script>")))
                .andExpect(content().string(containsString("radonSituationDecoder()")))
                .andExpect(content().string(containsString("Buyer inspection")))
                .andExpect(content().string(containsString(":action=\"targetAction\"")))
                .andExpect(content().string(containsString("name=\"foundationType\"")))
                .andExpect(content().string(containsString("situation_decoder_submit")))
                .andExpect(content().string(containsString("Choose your next step")))
                .andExpect(content().string(containsString("Start from the exact job, not another generic radon article.")))
                .andExpect(content().string(containsString("I need a repair or seller credit number")))
                .andExpect(content().string(containsString("href=\"/guides/radon-failed-inspection\"")))
                .andExpect(content().string(containsString("Foundation fast lanes")))
                .andExpect(content().string(containsString("Not another radon article.")));
    }

    @Test
    void canonicalFilterRedirectsForwardedHttpTraffic() throws Exception {
        mockMvc.perform(get("/radon-cost-calculator")
                        .header("X-Forwarded-Proto", "http")
                        .header("X-Forwarded-Host", "radonverdict.com"))
                .andExpect(status().isMovedPermanently())
                .andExpect(header().string("Location", "https://radonverdict.com/radon-cost-calculator"));
    }

    @Test
    void canonicalFilterUsesCfVisitorSchemeToAvoidHttpsLoop() throws Exception {
        mockMvc.perform(get("/radon-cost-calculator")
                        .header("X-Forwarded-Proto", "http")
                        .header("X-Forwarded-Host", "radonverdict.com")
                        .header("CF-Visitor", "{\"scheme\":\"https\"}"))
                .andExpect(status().isOk());
    }

    @Test
    void canonicalFilterRedirectsCloudflareProxyWithoutCfVisitor() throws Exception {
        mockMvc.perform(get("/radon-cost-calculator")
                        .header("X-Forwarded-Proto", "http")
                        .header("X-Forwarded-Host", "radonverdict.com")
                        .header("CF-Connecting-IP", "198.51.100.9"))
                .andExpect(status().isMovedPermanently())
                .andExpect(header().string("Location", "https://radonverdict.com/radon-cost-calculator"));
    }

    @Test
    void canonicalFilterRedirectsTrailingSlashVariants() throws Exception {
        mockMvc.perform(get("/radon-levels/")
                        .queryParam("utm_source", "manual")
                        .header("X-Forwarded-Proto", "https")
                        .header("X-Forwarded-Host", "radonverdict.com"))
                .andExpect(status().isMovedPermanently())
                .andExpect(header().string("Location", "https://radonverdict.com/radon-levels?utm_source=manual"));
    }

    @Test
    void globalCalculatorShowsScenarioPrefillModule() throws Exception {
        mockMvc.perform(get("/radon-cost-calculator"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Optional Scenario Prefill")))
                .andExpect(content().string(containsString("Not tested yet")))
                .andExpect(content().string(containsString("Buying")))
                .andExpect(content().string(containsString("Pick a scenario to open a county page already tuned for your next step.")));
    }

    @Test
    void mitigationCostRootPillarLoadsAndConnectsCostSilo() throws Exception {
        String html = mockMvc.perform(get("/radon-mitigation-cost"))
                .andExpect(status().isOk())
                .andExpect(content().string(not(containsString("<meta name=\"robots\" content=\"noindex, follow\">"))))
                .andExpect(content().string(containsString("<title>Radon Mitigation Cost by State, Foundation Type, and Result | RadonVerdict</title>")))
                .andExpect(content().string(containsString("Radon Mitigation Cost by State, Foundation Type, and Test Result")))
                .andExpect(content().string(containsString("Popular radon mitigation cost searches")))
                .andExpect(content().string(containsString("How much does radon mitigation cost?")))
                .andExpect(content().string(containsString("Basement vs slab vs crawl-space radon system cost")))
                .andExpect(content().string(containsString("Radon mitigation cost for 4.0+ pCi/L")))
                .andExpect(content().string(containsString("Radon mitigation cost after failed inspection")))
                .andExpect(content().string(containsString("Choose your next step")))
                .andExpect(content().string(containsString("I need a repair or seller credit number")))
                .andExpect(content().string(containsString("href=\"/guides/radon-failed-inspection\"")))
                .andExpect(content().string(containsString("href=\"/radon-cost-calculator?foundation=basement\"")))
                .andExpect(content().string(containsString("Official cost evidence index")))
                .andExpect(content().string(containsString("Evidence-backed radon mitigation cost pages")))
                .andExpect(content().string(containsString("Highest-signal cost pages")))
                .andExpect(content().string(containsString("href=\"/radon-cost-data-report\"")))
                .andExpect(content().string(containsString("Basement, slab, and crawl-space cost ranges")))
                .andExpect(content().string(containsString("When the cost question becomes urgent")))
                .andExpect(content().string(containsString("Browse radon mitigation cost by state")))
                .andExpect(content().string(containsString("href=\"/radon-mitigation-cost/california\"")))
                .andExpect(content().string(containsString("href=\"/radon-cost-calculator\"")))
                .andExpect(content().string(containsString("href=\"/radon-credit-calculator\"")))
                .andExpect(content().string(containsString("href=\"/radon-levels\"")))
                .andReturn()
                .getResponse()
                .getContentAsString();

        assertJsonLdBlocksAreValid(html);
    }

    @Test
    void mitigationCostStateAndCountyPagesLinkBackToRootPillar() throws Exception {
        mockMvc.perform(get("/radon-mitigation-cost/california"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("href=\"/radon-mitigation-cost\"")))
                .andExpect(content().string(containsString("Cost Basics")))
                .andExpect(content().string(containsString("Use the national cost guide")))
                .andExpect(content().string(containsString("California cost range by foundation")))
                .andExpect(content().string(containsString("State rules that can change the quote")))
                .andExpect(content().string(containsString("EPA zone mix in California")))
                .andExpect(content().string(containsString("Local cost guides")))
                .andExpect(content().string(containsString("Best county pages to open first")))
                .andExpect(content().string(containsString("Slab-on-Grade")));

        mockMvc.perform(get("/radon-mitigation-cost/california/los-angeles-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(not(containsString("<meta name=\"robots\" content=\"noindex, follow\">"))))
                .andExpect(content().string(containsString("Los Angeles County Cost Range First")))
                .andExpect(content().string(containsString("Radon Mitigation Cost Guide")))
                .andExpect(content().string(containsString("href=\"/radon-mitigation-cost\"")));
    }

    @Test
    void globalCreditCalculatorLandingLoads() throws Exception {
        mockMvc.perform(get("/radon-credit-calculator"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Radon Failed Inspection")))
                .andExpect(content().string(containsString("Radon Seller Credit Calculator")))
                .andExpect(content().string(containsString("repair request")))
                .andExpect(content().string(containsString("price reduction")))
                .andExpect(content().string(containsString("Get My Local Credit Number")))
                .andExpect(content().string(containsString("Buyer asking for credit")))
                .andExpect(content().string(containsString("Seller budgeting response")))
                .andExpect(content().string(containsString("legal advice")));
    }

    @Test
    void globalCreditCalculatorLandingLinksBackToActionPlanFlow() throws Exception {
        mockMvc.perform(get("/radon-credit-calculator"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("credit_landing_bridge_click")))
                .andExpect(content().string(containsString("Need the broader next step first? Open the full action-plan flow")))
                .andExpect(content().string(containsString("href=\"/radon-cost-calculator\"")));
    }

    @Test
    void searchZipCarriesScenarioPrefillIntoCountyRedirect() throws Exception {
        mockMvc.perform(post("/search-zip")
                        .param("zipCode", "90210")
                        .param("intent", "buying")
                        .param("radonResultBand", "above_4"))
                .andExpect(status().isSeeOther())
                .andExpect(header().string("Location",
                        "/radon-mitigation-cost/california/los-angeles-county?intent=buying&radonResultBand=above_4&zipCode=90210"));
    }

    @Test
    void searchZipDropsUnexpectedScenarioParametersAndKeepsSafeFoundation() throws Exception {
        mockMvc.perform(post("/search-zip")
                        .param("zipCode", "90210")
                        .param("intent", "buying&bad=1")
                        .param("radonResultBand", "above_4&bad=1")
                        .param("foundationType", "crawl space"))
                .andExpect(status().isSeeOther())
                .andExpect(header().string("Location",
                        "/radon-mitigation-cost/california/los-angeles-county?zipCode=90210&foundation=crawlspace"));
    }

    @Test
    void searchZipRecognizesLoudounRecoveryZip() throws Exception {
        mockMvc.perform(post("/search-zip")
                        .param("zipCode", "20147")
                        .param("intent", "homeowner")
                        .param("radonResultBand", "above_4"))
                .andExpect(status().isSeeOther())
                .andExpect(header().string("Location",
                        "/radon-mitigation-cost/virginia/loudoun-county?intent=homeowner&radonResultBand=above_4&zipCode=20147"));
    }

    @Test
    void searchZipCreditRedirectsIntoCountyCreditCalculator() throws Exception {
        mockMvc.perform(post("/search-zip-credit")
                        .param("zipCode", "90210")
                        .param("intent", "selling")
                        .param("radonResultBand", "above_4")
                        .param("foundationType", "basement"))
                .andExpect(status().isSeeOther())
                .andExpect(header().string("Location",
                        "/radon-credit-calculator/california/los-angeles-county?intent=selling&radonResultBand=above_4&zipCode=90210&foundation=basement"));
    }

    @Test
    void searchZipCreditAcceptsRoleFallbackForCreditIntent() throws Exception {
        mockMvc.perform(post("/search-zip-credit")
                        .param("zipCode", "90210")
                        .param("role", "seller")
                        .param("radonResultBand", "above_4"))
                .andExpect(status().isSeeOther())
                .andExpect(header().string("Location",
                        "/radon-credit-calculator/california/los-angeles-county?intent=selling&radonResultBand=above_4&zipCode=90210"));
    }

    @Test
    void countyCreditCalculatorLoadsForBuyerFlow() throws Exception {
        mockMvc.perform(get("/radon-credit-calculator/california/los-angeles-county")
                        .param("intent", "buying")
                        .param("radonResultBand", "above_4"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("<meta name=\"robots\" content=\"noindex, follow\">")))
                .andExpect(content().string(containsString("Buyer Radon Credit Calculator for Los Angeles County, CA")))
                .andExpect(content().string(containsString("Opening ask")))
                .andExpect(content().string(containsString("Defensible ceiling")))
                .andExpect(content().string(containsString("Split-cost fallback")));
    }

    @Test
    void countyCreditCalculatorLoadsForSellerFlow() throws Exception {
        mockMvc.perform(get("/radon-credit-calculator/california/los-angeles-county")
                        .param("intent", "selling")
                        .param("radonResultBand", "above_4"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Seller Radon Credit Calculator for Los Angeles County, CA")))
                .andExpect(content().string(containsString("Reserve target")))
                .andExpect(content().string(containsString("Fast-close credit")));
    }

    @Test
    void mixedCaseCountySlugRedirectsToCanonicalPath() throws Exception {
        mockMvc.perform(get("/radon-levels/PuErTo-RiCo/PONCE-MUNICIPIO"))
                .andExpect(status().isMovedPermanently())
                .andExpect(header().string("Location", "/radon-levels/puerto-rico/ponce-municipio"));
    }

    @Test
    void unknownZonePageUsesNoindexFollowAndNaturalAreaName() throws Exception {
        mockMvc.perform(get("/radon-levels/puerto-rico/ponce-municipio"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("<meta name=\"robots\" content=\"noindex, follow\">")))
                .andExpect(content().string(containsString("Ponce Municipio, PR Radon Levels")))
                .andExpect(content().string(not(containsString("Ponce Municipio County"))));
    }

    @Test
    void sitemapIndexPrioritizesHighIntentAndUsesDeployFreshness() throws Exception {
        String today = LocalDate.now().toString();

        mockMvc.perform(get("/sitemap.xml"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("/sitemap-recovery.xml")))
                .andExpect(content().string(containsString("/sitemap-growth.xml")))
                .andExpect(content().string(containsString("/sitemap-cost-evidence.xml")))
                .andExpect(content().string(containsString("/sitemap-levels-evidence.xml")))
                .andExpect(content().string(not(containsString("/sitemap-zone-high.xml"))))
                .andExpect(content().string(not(containsString("/sitemap-zone-low.xml"))))
                .andExpect(content().string(not(containsString("/sitemap-zone-unknown.xml"))));

        mockMvc.perform(get("/sitemap-recovery.xml"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("/radon-levels/maryland/prince-georges-county")))
                .andExpect(content().string(containsString("/radon-levels/virginia/loudoun-county")))
                .andExpect(content().string(containsString("/radon-levels/new-jersey/monmouth-county")))
                .andExpect(content().string(containsString("/radon-mitigation-cost/virginia/loudoun-county")));

        mockMvc.perform(get("/sitemap-growth.xml"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("/radon-levels/new-jersey/gloucester-county")))
                .andExpect(content().string(containsString("/radon-levels/colorado/broomfield-county")))
                .andExpect(content().string(containsString("/radon-levels/iowa/story-county")))
                .andExpect(content().string(not(containsString("/radon-levels/virginia/loudoun-county"))))
                .andExpect(content().string(containsString("/radon-mitigation-cost/new-jersey/gloucester-county")));

        mockMvc.perform(get("/sitemap-cost-evidence.xml"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("/radon-mitigation-cost/pennsylvania/montgomery-county")))
                .andExpect(content().string(not(containsString("/radon-mitigation-cost/virginia/loudoun-county"))))
                .andExpect(content().string(not(containsString("/radon-levels/pennsylvania/montgomery-county"))));

        mockMvc.perform(get("/sitemap-core.xml"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("<loc>https://radonverdict.com/</loc>")))
                .andExpect(content().string(containsString("/radon-data-sources")))
                .andExpect(content().string(containsString("/radon-cost-data-report")))
                .andExpect(content().string(containsString("/radon-quote-ledger")))
                .andExpect(content().string(containsString("/radon-credit-calculator")))
                .andExpect(content().string(containsString("/guides/radon-failed-inspection")))
                .andExpect(content().string(containsString("/guides/radon-inspection-toolkit")))
                .andExpect(content().string(containsString("/guides/radon-mitigation-quote-checklist")))
                .andExpect(content().string(containsString("/guides/radon-seller-credit-worksheet")));

        mockMvc.perform(get("/sitemap-levels-evidence.xml"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("/radon-levels/california/alameda-county")))
                .andExpect(content().string(not(containsString("/radon-levels/virginia/loudoun-county"))))
                .andExpect(content().string(not(containsString("/radon-levels/colorado/broomfield-county"))))
                .andExpect(content().string(not(containsString("/radon-mitigation-cost/california/alameda-county"))))
                .andExpect(content().string(containsString("<lastmod>" + today + "</lastmod>")));

        mockMvc.perform(get("/sitemap-zone-high.xml"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("/radon-levels/california/alameda-county")))
                .andExpect(content().string(not(containsString("/radon-levels/maryland/prince-georges-county"))))
                .andExpect(content().string(not(containsString("/radon-levels/colorado/broomfield-county"))))
                .andExpect(content().string(not(containsString("/radon-mitigation-cost/california/alameda-county"))))
                .andExpect(content().string(containsString("<lastmod>" + today + "</lastmod>")));
    }

    @Test
    void zone3CountyPagesAreIndexableWhenTheDataMoatExists() throws Exception {
        mockMvc.perform(get("/radon-mitigation-cost/california/butte-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(not(containsString("<meta name=\"robots\" content=\"noindex, follow\">"))));

        mockMvc.perform(get("/radon-levels/california/butte-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(not(containsString("<meta name=\"robots\" content=\"noindex, follow\">"))));
    }

    @Test
    void stateHubsListDataBackedZone3Counties() throws Exception {
        mockMvc.perform(get("/radon-mitigation-cost/california"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("/radon-mitigation-cost/california/butte-county")))
                .andExpect(content().string(containsString("/radon-mitigation-cost/california/los-angeles-county")));

        mockMvc.perform(get("/radon-levels/california"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("/radon-levels/california/butte-county")))
                .andExpect(content().string(containsString("/radon-levels/california/alameda-county")));
    }

    @Test
    void dataBackedCountyIndexingDoesNotHideSmallZoneOneAndTwoPages() throws Exception {
        mockMvc.perform(get("/radon-levels/alabama/bullock-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(not(containsString("<meta name=\"robots\" content=\"noindex, follow\">"))))
                .andExpect(content().string(containsString("County reference page")));

        mockMvc.perform(get("/radon-levels/alabama"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("/radon-levels/alabama/bullock-county")))
                .andExpect(content().string(containsString("/radon-levels/alabama/madison-county")));

        mockMvc.perform(get("/sitemap-zone-high.xml"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("/radon-levels/alabama/bullock-county")))
                .andExpect(content().string(not(containsString("/radon-levels/alabama/madison-county"))));

        mockMvc.perform(get("/sitemap-growth.xml"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("/radon-levels/alabama/madison-county")));
    }

    @Test
    void countyPageShowsTrustSummaryAndCostBenchmarks() throws Exception {
        mockMvc.perform(get("/radon-mitigation-cost/california/los-angeles-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Your 30-second local estimate snapshot")))
                .andExpect(content().string(containsString("Source dates shown below")))
                .andExpect(content().string(containsString("Why this estimate looks like this")))
                .andExpect(content().string(containsString("vs State vs National")));
    }

    @Test
    void countyPagesUseSourceDatesAndOfficialStateResourcesForTrust() throws Exception {
        String today = java.time.LocalDate.now().toString();

        mockMvc.perform(get("/radon-mitigation-cost/california/los-angeles-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Official State Resource")))
                .andExpect(content().string(containsString("California radon program and rules")))
                .andExpect(content().string(containsString("https://www.cdph.ca.gov/Programs/CEH/DRSEM/Pages/EMB/Radon.aspx")))
                .andExpect(content().string(containsString("Content review: Source-level retrieval dates")))
                .andExpect(content().string(not(containsString("Content review: " + today))));

        mockMvc.perform(get("/radon-levels/california/los-angeles-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Official State Resource")))
                .andExpect(content().string(containsString("California radon program and rules")))
                .andExpect(content().string(containsString("https://www.cdph.ca.gov/Programs/CEH/DRSEM/Pages/EMB/Radon.aspx")))
                .andExpect(content().string(containsString("Content review:")))
                .andExpect(content().string(not(containsString("Content review: " + today))));
    }

    @Test
    void aboutAndMethodologyAvoidUnsupportedReviewerClaims() throws Exception {
        mockMvc.perform(get("/about"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("A public-data tool for radon decisions")))
                .andExpect(content().string(containsString("What We Do Not Do")))
                .andExpect(content().string(containsString("Read the methodology")))
                .andExpect(content().string(not(containsString("Reviewed &amp; Calibrated"))))
                .andExpect(content().string(not(containsString("reviewed quarterly"))))
                .andExpect(content().string(not(containsString("10-15%"))));

        mockMvc.perform(get("/methodology"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("How RadonVerdict turns public radon data into local action guidance")))
                .andExpect(content().string(containsString("Evidence Hierarchy")))
                .andExpect(content().string(containsString("Search Inclusion Policy")))
                .andExpect(content().string(containsString("href=\"/radon-data-sources\"")))
                .andExpect(content().string(containsString("We do not automatically label every page as reviewed today")));

        mockMvc.perform(get("/contact"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("We do not maintain a public walk-in office")))
                .andExpect(content().string(not(containsString("100 Innovation Drive"))))
                .andExpect(content().string(not(containsString("Tech Hub, NY 10001"))));
    }

    @Test
    void radonDataSourcesPageLoadsAsAuthorityHub() throws Exception {
        String html = mockMvc.perform(get("/radon-data-sources"))
                .andExpect(status().isOk())
                .andExpect(content().string(not(containsString("<meta name=\"robots\" content=\"noindex, follow\">"))))
                .andExpect(content().string(containsString("<title>Radon Data Sources &amp; Evidence Policy | RadonVerdict</title>")))
                .andExpect(content().string(containsString("Radon data sources, evidence hierarchy, and indexing policy")))
                .andExpect(content().string(containsString("Official county evidence")))
                .andExpect(content().string(containsString("Measurement summaries")))
                .andExpect(content().string(containsString("ZIP mappings")))
                .andExpect(content().string(containsString("Evidence hierarchy")))
                .andExpect(content().string(containsString("Why some pages stay out of search")))
                .andExpect(content().string(containsString("Virginia Department of Health Radon Testing Results")))
                .andExpect(content().string(containsString("Colorado Environmental Public Health Tracking Pre-Mitigation Radon Test Results")))
                .andExpect(content().string(containsString("href=\"/methodology\"")))
                .andExpect(content().string(containsString("href=\"/radon-cost-data-report\"")))
                .andExpect(content().string(containsString("href=\"/radon-levels\"")))
                .andReturn()
                .getResponse()
                .getContentAsString(StandardCharsets.UTF_8);

        assertJsonLdBlocksAreValid(html);
        String lowerHtml = html.toLowerCase();
        assertFalse(lowerHtml.contains("moat"), "Data sources page should not expose internal strategy language.");
        assertFalse(lowerHtml.contains("internal links"), "Data sources page should use user-facing language.");
        assertFalse(lowerHtml.contains("indexation"), "Data sources page should avoid internal SEO jargon.");
    }

    @Test
    void radonCostDataReportLoadsAsLinkableCostAuthorityAsset() throws Exception {
        String html = mockMvc.perform(get("/radon-cost-data-report"))
                .andExpect(status().isOk())
                .andExpect(content().string(not(containsString("<meta name=\"robots\" content=\"noindex, follow\">"))))
                .andExpect(content().string(containsString("<title>Radon Mitigation Cost Data Report | RadonVerdict</title>")))
                .andExpect(content().string(containsString("Radon mitigation cost data report")))
                .andExpect(content().string(containsString("source-backed cost index")))
                .andExpect(content().string(containsString("Current search-demand routes")))
                .andExpect(content().string(containsString("Do not send every query to the same page")))
                .andExpect(content().string(containsString("Ulster County, NY")))
                .andExpect(content().string(containsString("commercial radon searches need testing protocol")))
                .andExpect(content().string(containsString("Twenty county cost pages to inspect first")))
                .andExpect(content().string(containsString("What the report proves")))
                .andExpect(content().string(containsString("Best state hubs for discovery")))
                .andExpect(content().string(containsString("Official evidence feeds behind the index")))
                .andExpect(content().string(containsString("href=\"/radon-mitigation-cost\"")))
                .andExpect(content().string(containsString("href=\"/radon-quote-ledger\"")))
                .andReturn()
                .getResponse()
                .getContentAsString(StandardCharsets.UTF_8);

        assertJsonLdBlocksAreValid(html);
    }

    @Test
    void searchDemandCostPagesBridgeTestingQueriesToCostAndQuotePaths() throws Exception {
        mockMvc.perform(get("/radon-mitigation-cost/new-york/ulster-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("A useful next step")))
                .andExpect(content().string(containsString("Looking for a local cost answer?")))
                .andExpect(content().string(containsString("Check the county testing and levels page first")))
                .andExpect(content().string(containsString("href=\"/radon-levels/new-york/ulster-county\"")))
                .andExpect(content().string(containsString("href=\"/radon-quote-ledger#quote-checker\"")));

        mockMvc.perform(get("/radon-mitigation-cost/california/los-angeles-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Looking for a local cost answer?")))
                .andExpect(content().string(containsString("Commercial and multifamily searches should not jump straight to a residential average.")));
    }

    @Test
    void countyPageHidesInternalSimilarityAndReviewerDebugSignals() throws Exception {
        mockMvc.perform(get("/radon-mitigation-cost/california/los-angeles-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(not(containsString("Similarity cohort size"))))
                .andExpect(content().string(not(containsString("Uniqueness score"))))
                .andExpect(content().string(not(containsString("fingerprint:"))))
                .andExpect(content().string(not(containsString("Pending assignment"))));
    }

    @Test
    void countyHubUsesCostIntentSeoAndRemovesTestingCtasFromAdvisor() throws Exception {
        mockMvc.perform(get("/radon-mitigation-cost/california/los-angeles-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("How Much Does Radon Mitigation Cost in Los Angeles County, CA?")))
                .andExpect(content().string(containsString("Use Your Confirmed Radon Reading")))
                .andExpect(content().string(containsString("Enter confirmed reading:")))
                .andExpect(content().string(containsString("data-nosnippet")))
                .andExpect(content().string(not(containsString("At <strong x-text=\"parseFloat(level).toFixed(1)\"></strong> pCi/L"))))
                .andExpect(content().string(not(containsString("Get a Home Radon Monitor (~$30)"))))
                .andExpect(content().string(not(containsString("Verify with Long-term Monitor (~$150)"))));
    }

    @Test
    void countyHubDefaultOrganicEntryLeadsWithCostRangeAndZipIntent() throws Exception {
        mockMvc.perform(get("/radon-mitigation-cost/virginia/loudoun-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(not(containsString("<meta name=\"robots\" content=\"noindex, follow\">"))))
                .andExpect(content().string(containsString("Radon Mitigation Cost in Loudoun County, VA:")))
                .andExpect(content().string(containsString("Estimate view")))
                .andExpect(content().string(containsString("Cost overview")))
                .andExpect(content().string(containsString("Loudoun County Cost Range First")))
                .andExpect(content().string(containsString("20147 radon mitigation cost")))
                .andExpect(content().string(containsString("ZIP 20147 maps to Loudoun County, VA")));
    }

    @Test
    void countyHubTurnsCostPageIntoPracticalQuoteCoach() throws Exception {
        mockMvc.perform(get("/radon-mitigation-cost/virginia/loudoun-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Use this page like a quote coach, not just a calculator.")))
                .andExpect(content().string(containsString("No test yet")))
                .andExpect(content().string(containsString("2.0-3.9 pCi/L")))
                .andExpect(content().string(containsString("4.0+ pCi/L")))
                .andExpect(content().string(containsString("Copy this call script")))
                .andExpect(content().string(containsString("My lowest-level radon test was ___ pCi/L in Loudoun County, VA.")))
                .andExpect(content().string(containsString("Ask these six questions")))
                .andExpect(content().string(containsString("Red flags")))
                .andExpect(content().string(containsString("Copy script")))
                .andExpect(content().string(containsString("Print worksheet")))
                .andExpect(content().string(containsString("Bid checker")))
                .andExpect(content().string(containsString("Contractor quote")))
                .andExpect(content().string(containsString("Is this quote fair enough to trust?")))
                .andExpect(content().string(containsString("Written quote includes")))
                .andExpect(content().string(containsString("data-rv-quote-ledger-link")))
                .andExpect(content().string(containsString("Add to quote ledger")))
                .andExpect(content().string(containsString("Copy verdict")))
                .andExpect(content().string(containsString("The ledger handoff will carry ZIP, price, scope, foundation, and result band.")))
                .andExpect(content().string(containsString("Above $3640")))
                .andExpect(content().string(containsString("above the hard ceiling")));
    }

    @Test
    void countyHubUsesCountySpecificDefaultScenarioInsteadOfFixedBasementBuying() throws Exception {
        mockMvc.perform(get("/radon-mitigation-cost/california/los-angeles-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("foundation: 'slab'")))
                .andExpect(content().string(not(containsString("foundation: 'basement'"))));
    }

    @Test
    void countyHubUsesActionPlanInputsInsteadOfCostOnlyFraming() throws Exception {
        mockMvc.perform(get("/radon-mitigation-cost/california/los-angeles-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Enter the result. Pick the deal side. Get the route.")))
                .andExpect(content().string(containsString("Decision side")))
                .andExpect(content().string(containsString("Foundation clue")))
                .andExpect(content().string(containsString("data-base-credit-url=\"/radon-credit-calculator/california/los-angeles-county\"")))
                .andExpect(content().string(containsString("Choose your next step")))
                .andExpect(content().string(containsString("Pick the situation that matches Los Angeles County, CA")))
                .andExpect(content().string(containsString("href=\"/radon-credit-calculator/california/los-angeles-county?intent=buying&amp;radonResultBand=above_4&amp;foundation=basement\"")))
                .andExpect(content().string(containsString("href=\"/radon-mitigation-cost/california/los-angeles-county?foundation=crawlspace&amp;radonResultBand=above_4&amp;intent=homeowner#estimate-form\"")))
                .andExpect(content().string(containsString("Build Your Local Action Plan")))
                .andExpect(content().string(containsString("Current Result")))
                .andExpect(content().string(containsString("Not tested")))
                .andExpect(content().string(containsString("4.0+")))
                .andExpect(content().string(containsString("Saved snapshot of this county, result band, and selected foundation")))
                .andExpect(content().string(containsString("Save Plan")));
    }

    @Test
    void countyHubLeadFormUsesScenarioContextInsteadOfDuplicateInputs() throws Exception {
        mockMvc.perform(get("/radon-mitigation-cost/california/los-angeles-county")
                        .param("radonResultBand", "not_tested")
                        .param("intent", "homeowner"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Current scenario")))
                .andExpect(content().string(containsString("type=\"hidden\" name=\"foundationType\"")))
                .andExpect(content().string(containsString("type=\"hidden\" name=\"hasTested\" value=\"false\"")))
                .andExpect(content().string(containsString("lead_form_not_tested_test_kit")))
                .andExpect(content().string(not(containsString("label for=\"foundationType\""))))
                .andExpect(content().string(not(containsString("Have you tested your home for radon yet?"))));
    }

    @Test
    void countyHubKeepsLeadFormAheadOfTrustSummaryBlocks() throws Exception {
        String html = mockMvc.perform(get("/radon-mitigation-cost/california/los-angeles-county"))
                .andExpect(status().isOk())
                .andReturn()
                .getResponse()
                .getContentAsString();

        assertTrue(html.indexOf("id=\"result-translator\"") < html.indexOf("id=\"estimate-form\""));
        assertTrue(html.indexOf("id=\"result-translator\"") < html.indexOf("id=\"search-intent-router\""));
        assertTrue(html.indexOf("id=\"search-intent-router\"") < html.indexOf("id=\"estimate-form\""));
        assertTrue(html.indexOf("id=\"estimate-form\"") < html.indexOf("Your 30-second local estimate snapshot"));
    }

    @Test
    void countyHubAcceptsResultBandAndIntentDeepLinks() throws Exception {
        mockMvc.perform(get("/radon-mitigation-cost/california/los-angeles-county")
                        .param("radonResultBand", "above_4")
                        .param("intent", "buying"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("4.0+ Action Plan for Buyers")))
                .andExpect(content().string(containsString("Scenario")))
                .andExpect(content().string(containsString("4.0+ pCi/L")));
    }

    @Test
    void countyHubShowsNegotiationSnapshotForBuyingFlow() throws Exception {
        mockMvc.perform(get("/radon-mitigation-cost/california/los-angeles-county")
                        .param("radonResultBand", "above_4")
                        .param("intent", "buying"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Seller Credit Starting Point")))
                .andExpect(content().string(containsString("Open Credit Calculator")))
                .andExpect(content().string(containsString("/radon-credit-calculator/california/los-angeles-county?intent=buying&amp;radonResultBand=above_4")))
                .andExpect(content().string(containsString("Request Credit Follow-Up")))
                .andExpect(content().string(containsString("Follow-up priority")));
    }

    @Test
    void countyHubShowsHighReadingFastPathForHomeownerFlow() throws Exception {
        mockMvc.perform(get("/radon-mitigation-cost/california/los-angeles-county")
                        .param("radonResultBand", "above_4")
                        .param("intent", "homeowner"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("4.0+ Radon Result in Los Angeles County, CA: Cost and Next Step")))
                .andExpect(content().string(containsString("High Reading Budget Snapshot")))
                .andExpect(content().string(containsString("Open 4.0+ Worksheet")))
                .andExpect(content().string(containsString("Request Quote Follow-Up")))
                .andExpect(content().string(containsString("Inspection deadline or quote needed in 24 hours")));
    }

    @Test
    void radonLevelsCountyUsesTestingGuideSeoAndFrontloadsSituationPicker() throws Exception {
        mockMvc.perform(get("/radon-levels/california/los-angeles-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Los Angeles County, CA Commercial Radon, Testing &amp; Levels")))
                .andExpect(content().string(containsString("data-nosnippet")))
                .andExpect(content().string(containsString("Local service search answer:")))
                .andExpect(content().string(containsString("Home result translator")))
                .andExpect(content().string(containsString("Enter the result. Pick the deal side. Get the route.")))
                .andExpect(content().string(containsString("Check my result")))
                .andExpect(content().string(containsString("Copy next-step note")))
                .andExpect(content().string(containsString("Open local cost plan")))
                .andExpect(content().string(containsString("Pick the situation that matches you")))
                .andExpect(content().string(containsString("Pick My Next Step")))
                .andExpect(content().string(containsString("I have not tested yet")))
                .andExpect(content().string(containsString("Read the testing guide first")))
                .andExpect(content().string(containsString("Check your state radon program")))
                .andExpect(content().string(containsString("My result is 4.0+")))
                .andExpect(content().string(containsString("/radon-credit-calculator/california/los-angeles-county?radonResultBand=above_4&intent=buying")))
                .andExpect(content().string(not(containsString("At <strong x-text=\"parseFloat(level).toFixed(1)\"></strong> pCi/L"))))
                .andExpect(content().string(containsString("Review retesting steps")))
                .andExpect(content().string(containsString("Local service next step")))
                .andExpect(content().string(containsString("Looking for a service or cost answer?")))
                .andExpect(content().string(containsString("Commercial provider search pack")))
                .andExpect(content().string(containsString("EPA provider guidance")))
                .andExpect(content().string(containsString("Local call script")))
                .andExpect(content().string(containsString("href=\"/guides/radon-mitigation-quote-checklist\"")))
                .andExpect(content().string(containsString("href=\"/radon-quote-ledger\"")))
                .andExpect(content().string(not(containsString("Start with a Short-Term Test Kit"))))
                .andExpect(content().string(not(containsString("data-rv-affiliate-link=\"true\""))));
    }

    @Test
    void gscServiceIntentCountyPagesBridgeServiceQueriesToDecisionPaths() throws Exception {
        mockMvc.perform(get("/radon-levels/new-york/ulster-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("<title>Ulster County, NY Radon Gas Testing &amp; Mitigation Services</title>")))
                .andExpect(content().string(containsString("Local service search answer:")))
                .andExpect(content().string(not(containsString("radon gas testing Ulster County NY; radon mitigation services Ulster County NY"))))
                .andExpect(content().string(containsString("Local service next step")))
                .andExpect(content().string(containsString("Local provider search pack")))
                .andExpect(content().string(containsString("Use the official state radon program and EPA provider guidance")))
                .andExpect(content().string(containsString("I have a radon result of ___ pCi/L in Ulster County, NY.")))
                .andExpect(content().string(containsString("Use the contractor quote checklist before the call")))
                .andExpect(content().string(containsString("Open the local cost path before calling contractors")))
                .andExpect(content().string(containsString("href=\"/radon-quote-ledger\"")));

        mockMvc.perform(get("/radon-levels/colorado/boulder-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("<title>Boulder County, CO Radon Testing &amp; Mitigation Guide</title>")))
                .andExpect(content().string(not(containsString("radon testing Boulder CO; Boulder radon mitigation"))))
                .andExpect(content().string(containsString("Service intent detected: testing, mitigation, or commercial radon searches need a result-to-cost path.")))
                .andExpect(content().string(containsString("Test result -&gt; county cost path -&gt; quote ledger if a contractor gives a number.")));
    }

    @Test
    void gscSurvivorCountyPagesKeepNearMissDecisionPathVisible() throws Exception {
        mockMvc.perform(get("/radon-levels/new-york/monroe-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("<title>Monroe County, NY Radon Levels | Test, Retest, or Cost Path</title>")))
                .andExpect(content().string(containsString("Fast county answer:")))
                .andExpect(content().string(containsString("Near-Miss County Playbook")))
                .andExpect(content().string(containsString("This county gets the short route first.")))
                .andExpect(content().string(containsString("href=\"/radon-quote-ledger\"")));

        mockMvc.perform(get("/radon-levels/tennessee/sevier-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Sevier County, TN radon levels: test-to-decision path")))
                .andExpect(content().string(containsString("Near-miss search signal: keep the page focused on the next practical decision.")))
                .andExpect(content().string(containsString("Pick one route now: test, retest, local cost, or seller-credit math.")));
    }

    @Test
    void radonLevelsCountyShowsCountyEvidenceAndLevelsSpecificSources() throws Exception {
        mockMvc.perform(get("/radon-levels/california/los-angeles-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("County Evidence Snapshot")))
                .andExpect(content().string(containsString("Housing base")))
                .andExpect(content().string(containsString("Older housing share")))
                .andExpect(content().string(containsString("Source-backed county page")))
                .andExpect(content().string(containsString("EPA Map of Radon Zones")))
                .andExpect(content().string(containsString("CDC Environmental Public Health Tracking - Radon Testing")))
                .andExpect(content().string(containsString("US Census Bureau")))
                .andExpect(content().string(not(containsString("Why this page is being kept or reduced"))))
                .andExpect(content().string(not(containsString("kept because"))));
    }

    @Test
    void newYorkLevelsCountyShowsOfficialMeasurementData() throws Exception {
        mockMvc.perform(get("/radon-levels/new-york/schenectady-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Measured Radon Data")))
                .andExpect(content().string(containsString("New York State Department of Health Residential Radon Test Data")))
                .andExpect(content().string(containsString("2015-2019")))
                .andExpect(content().string(containsString("2.4 pCi/L")))
                .andExpect(content().string(containsString("16.0%")))
                .andExpect(content().string(containsString("17.7 pCi/L")))
                .andExpect(content().string(containsString("County evidence interpretation")))
                .andExpect(content().string(containsString("Official evidence dossier")))
                .andExpect(content().string(containsString("Source record for Schenectady County, NY")))
                .andExpect(content().string(containsString("Primary public source")))
                .andExpect(content().string(containsString("Retrieved / checked")))
                .andExpect(content().string(containsString("County FIPS")))
                .andExpect(content().string(containsString("Evidence stack")))
                .andExpect(content().string(containsString("EPA Map of Radon Zones")))
                .andExpect(content().string(containsString("US Census ACS housing context")))
                .andExpect(content().string(containsString("State radon program")))
                .andExpect(content().string(containsString("Open source dataset")))
                .andExpect(content().string(containsString("Not a property-level diagnosis")))
                .andExpect(content().string(containsString("How to use this county data")))
                .andExpect(content().string(containsString("Fuller county picture")))
                .andExpect(content().string(containsString("Primary result rank")))
                .andExpect(content().string(containsString("What to do with it")))
                .andExpect(content().string(containsString("NY DOH county summaries are based on submitted residential radon tests")));
    }

    @Test
    void minnesotaLevelsCountyShowsOfficialMeasurementData() throws Exception {
        mockMvc.perform(get("/radon-levels/minnesota/carver-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Measured Radon Data")))
                .andExpect(content().string(containsString("Minnesota Department of Health Indoor Air Unit Radon Test Data")))
                .andExpect(content().string(containsString("2010-2020")))
                .andExpect(content().string(containsString("3.9 pCi/L")))
                .andExpect(content().string(containsString("39.1%")))
                .andExpect(content().string(containsString("95th percentile")))
                .andExpect(content().string(containsString("10.8 pCi/L")))
                .andExpect(content().string(containsString("Median result:")))
                .andExpect(content().string(containsString("70.2%")))
                .andExpect(content().string(containsString("County evidence interpretation")))
                .andExpect(content().string(containsString("Primary result rank")))
                .andExpect(content().string(containsString("What the data says")))
                .andExpect(content().string(containsString("Minnesota county summaries are based on reported commercial and residential radon tests")));
    }

    @Test
    void kansasLevelsCountyShowsOfficialMeasurementData() throws Exception {
        mockMvc.perform(get("/radon-levels/kansas/johnson-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Measured Radon Data")))
                .andExpect(content().string(containsString("Kansas Environmental Public Health Tracking Radon Data")))
                .andExpect(content().string(containsString("2020")))
                .andExpect(content().string(containsString("4.6 pCi/L")))
                .andExpect(content().string(containsString("39.7%")))
                .andExpect(content().string(containsString("92.5 pCi/L")))
                .andExpect(content().string(containsString("County evidence interpretation")))
                .andExpect(content().string(containsString("Kansas Department of Health and Environment")));
    }

    @Test
    void coloradoLevelsCountyShowsOfficialStateMeasurementData() throws Exception {
        mockMvc.perform(get("/radon-levels/colorado/boulder-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Measured Radon Data")))
                .andExpect(content().string(containsString("Colorado Environmental Public Health Tracking Pre-Mitigation Radon Test Results")))
                .andExpect(content().string(containsString("2005-2024")))
                .andExpect(content().string(containsString("Median result")))
                .andExpect(content().string(containsString("3.3 pCi/L")))
                .andExpect(content().string(containsString("43.8%")))
                .andExpect(content().string(containsString("384.6 pCi/L")))
                .andExpect(content().string(containsString("Colorado Department of Public Health and Environment")))
                .andExpect(content().string(containsString("High-risk intent answer")))
                .andExpect(content().string(containsString("Is radon bad in Boulder County?")))
                .andExpect(content().string(containsString("Nearby comparison:")));
    }

    @Test
    void highSignalRecoveryCountiesDoNotLeadWithWeakZoneCopy() throws Exception {
        mockMvc.perform(get("/radon-levels/virginia/loudoun-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("<title>Loudoun County, VA Radon Levels: 4.1 pCi/L Official Data</title>")))
                .andExpect(content().string(containsString("Official Signal 4.1 pCi/L")))
                .andExpect(content().string(containsString("EPA Zone 2 context")))
                .andExpect(content().string(containsString("Is radon bad in Loudoun County?")))
                .andExpect(content().string(containsString("the official source signal is stronger than the EPA zone label suggests")))
                .andExpect(content().string(containsString("Official county data shows 4.1 pCi/L as the primary measured signal.")))
                .andExpect(content().string(containsString("Loudoun County should be treated as a testing-priority county because the official source signal is stronger than the EPA zone label suggests.")))
                .andExpect(content().string(containsString("a Testing Priority")))
                .andExpect(content().string(not(containsString("Loudoun County sits in the gray zone."))))
                .andExpect(content().string(not(containsString("Loudoun County is a gray-zone county"))))
                .andExpect(content().string(not(containsString("Loudoun County is currently categorized as EPA Zone 2"))))
                .andExpect(content().string(not(containsString("Loudoun County falls in EPA Zone 2"))));

        mockMvc.perform(get("/radon-levels/florida/marion-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("<title>Marion County, FL Radon Levels: 6.4 pCi/L &amp; 42.9% 4.0+</title>")))
                .andExpect(content().string(containsString("Official Signal 6.4 pCi/L")))
                .andExpect(content().string(containsString("EPA Zone 2 context")))
                .andExpect(content().string(containsString("Is radon bad in Marion County?")))
                .andExpect(content().string(containsString("Marion County is stronger than the EPA zone label suggests.")))
                .andExpect(content().string(containsString("Official county data shows 6.4 pCi/L and 42.9% at or above 4.0.")))
                .andExpect(content().string(containsString("Marion County should be treated as a testing-priority county because the official source signal is stronger than the EPA zone label suggests.")))
                .andExpect(content().string(containsString("a Testing Priority")))
                .andExpect(content().string(not(containsString("Marion County sits in the gray zone."))))
                .andExpect(content().string(not(containsString("Marion County is a gray-zone county"))))
                .andExpect(content().string(not(containsString("Marion County is currently categorized as EPA Zone 2"))))
                .andExpect(content().string(not(containsString("Marion County falls in EPA Zone 2"))));

        mockMvc.perform(get("/radon-levels/new-jersey/gloucester-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("<title>Gloucester County, NJ Radon Levels: NJ DEP Tier Signal</title>")))
                .andExpect(content().string(containsString("NJ DEP Tier Signal")))
                .andExpect(content().string(containsString("EPA Zone 2 context")))
                .andExpect(content().string(containsString("NJ DEP tier table makes this a testing-priority county")))
                .andExpect(content().string(containsString("Gloucester County has enough official radon signal that the answer should not stop at the EPA map.")))
                .andExpect(content().string(containsString("a Testing Priority")))
                .andExpect(content().string(not(containsString("Gloucester County sits in the gray zone."))))
                .andExpect(content().string(not(containsString("Gloucester County is a gray-zone county"))))
                .andExpect(content().string(not(containsString("Gloucester County is currently categorized as EPA Zone 2"))))
                .andExpect(content().string(not(containsString("Gloucester County falls in EPA Zone 2"))));
    }

    @Test
    void wisconsinLevelsCountyShowsOfficialStateMeasurementData() throws Exception {
        mockMvc.perform(get("/radon-levels/wisconsin/dane-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Measured Radon Data")))
                .andExpect(content().string(containsString("Wisconsin Department of Health Services Indoor Radon Test Results")))
                .andExpect(content().string(containsString("1995-2016")))
                .andExpect(content().string(containsString("5.6 pCi/L")))
                .andExpect(content().string(containsString("50.9%")))
                .andExpect(content().string(containsString("229.5 pCi/L")))
                .andExpect(content().string(containsString("Wisconsin Department of Health Services")));
    }

    @Test
    void newlyConvertedPennsylvaniaRetainedCountiesShowPaDepMeasurementData() throws Exception {
        mockMvc.perform(get("/radon-levels/pennsylvania/lycoming-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Measured Radon Data")))
                .andExpect(content().string(containsString("Pennsylvania DEP Radon Test Data by ZIP Code")))
                .andExpect(content().string(containsString("1990-2025")))
                .andExpect(content().string(containsString("11.5 pCi/L")))
                .andExpect(content().string(containsString("1003.0 pCi/L")))
                .andExpect(content().string(containsString("PA DEP floor rollup:")))
                .andExpect(content().string(containsString("Basement and first-floor test data")))
                .andExpect(content().string(containsString("Basement-focused results")))
                .andExpect(content().string(containsString("basement-level test planning")))
                .andExpect(content().string(containsString("basement average 11.5 pCi/L from 12,470 tests")))
                .andExpect(content().string(containsString("first-floor average 4.3 pCi/L from 2,015 tests")))
                .andExpect(content().string(containsString("Pennsylvania values are RadonVerdict county rollups from PA DEP ZIP reports")))
                .andExpect(content().string(containsString("PA DEP Radon Division")));

        mockMvc.perform(get("/radon-levels/pennsylvania/schuylkill-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Pennsylvania DEP Radon Test Data by ZIP Code")))
                .andExpect(content().string(containsString("13.9 pCi/L")))
                .andExpect(content().string(containsString("839.0 pCi/L")))
                .andExpect(content().string(containsString("basement average 13.9 pCi/L from 13,107 tests")))
                .andExpect(content().string(containsString("first-floor average 7.0 pCi/L from 1,563 tests")));
    }

    @Test
    void illinoisLevelsUseIemaArcgisMeasurementData() throws Exception {
        mockMvc.perform(get("/radon-levels/illinois"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Official Evidence in Illinois")))
                .andExpect(content().string(containsString("102 of 102 listed counties have official evidence")))
                .andExpect(content().string(containsString("Illinois IEMA-OHS Licensed Radon Measurement Dashboard: 100")))
                .andExpect(content().string(containsString("Measured Risk Leaders in Illinois")));

        mockMvc.perform(get("/radon-levels/illinois/dupage-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Measured Radon Data")))
                .andExpect(content().string(containsString("Illinois IEMA-OHS Licensed Radon Measurement Dashboard")))
                .andExpect(content().string(containsString("2003-2019")))
                .andExpect(content().string(containsString("95th percentile")))
                .andExpect(content().string(containsString("Illinois values come from the IEMA-OHS licensed-measurement dashboard")))
                .andExpect(content().string(containsString("Illinois IEMA-OHS")));
    }

    @Test
    void iowaLevelsUseHhsCountyMedianDashboardData() throws Exception {
        mockMvc.perform(get("/radon-levels/iowa"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Official Evidence in Iowa")))
                .andExpect(content().string(containsString("99 of 99 listed counties have official evidence")))
                .andExpect(content().string(containsString("Iowa HHS Radon Dashboard County Metrics: 99")))
                .andExpect(content().string(containsString("Measured Risk Leaders in Iowa")));

        mockMvc.perform(get("/radon-levels/iowa/polk-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Iowa HHS Radon Dashboard County Metrics")))
                .andExpect(content().string(containsString("current dashboard export")))
                .andExpect(content().string(containsString("Median result")))
                .andExpect(content().string(containsString("3.4 pCi/L")))
                .andExpect(content().string(containsString("Iowa values come from the HHS/IDPH county metrics dashboard export")))
                .andExpect(content().string(containsString("Iowa HHS")));
    }

    @Test
    void northCarolinaLevelsUseDhhsHighEndMapWithoutTreatingItAsAverage() throws Exception {
        mockMvc.perform(get("/radon-levels/north-carolina"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Official Evidence in North Carolina")))
                .andExpect(content().string(containsString("100 of 100 listed counties have official evidence")))
                .andExpect(content().string(containsString("North Carolina DHHS Radon Data Map: 100")))
                .andExpect(content().string(containsString("Highest high-end reading")));

        mockMvc.perform(get("/radon-levels/north-carolina/wake-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("North Carolina DHHS Radon Data Map")))
                .andExpect(content().string(containsString("updated 2025-08-06")))
                .andExpect(content().string(containsString("Highest measured")))
                .andExpect(content().string(containsString("257.0 pCi/L")))
                .andExpect(content().string(containsString("Highest reported county reading")))
                .andExpect(content().string(containsString("High readings have occurred")))
                .andExpect(content().string(containsString("high readings have happened locally")))
                .andExpect(content().string(containsString("high-end county measurement context")))
                .andExpect(content().string(containsString("North Carolina values come from the DHHS county radon map export")));
    }

    @Test
    void mississippiAlcornUsesHistoricalEpaUsgsSurveyWithoutOverstatingFreshness() throws Exception {
        mockMvc.perform(get("/radon-levels/mississippi"))
                .andExpect(status().isOk())
                .andExpect(content().string(not(containsString("<meta name=\"robots\" content=\"noindex, follow\">"))))
                .andExpect(content().string(containsString("/radon-levels/mississippi/alcorn-county")))
                .andExpect(content().string(containsString("EPA/USGS Mississippi Residential Radon Survey: 1")));

        mockMvc.perform(get("/radon-levels/mississippi/alcorn-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(not(containsString("<meta name=\"robots\" content=\"noindex, follow\">"))))
                .andExpect(content().string(containsString("Measured Radon Data")))
                .andExpect(content().string(containsString("EPA/USGS Mississippi Residential Radon Survey")))
                .andExpect(content().string(containsString("1990-1991")))
                .andExpect(content().string(containsString("Historical survey average")))
                .andExpect(content().string(containsString("1.0 pCi/L")))
                .andExpect(content().string(containsString("Median result:")))
                .andExpect(content().string(containsString("0.5 pCi/L")))
                .andExpect(content().string(containsString("47")))
                .andExpect(content().string(containsString("Older official survey")))
                .andExpect(content().string(containsString("older official context for a first-test decision")))
                .andExpect(content().string(containsString("historical State/EPA Residential Radon Survey")))
                .andExpect(content().string(containsString("older official context, not a current prediction")))
                .andExpect(content().string(containsString("EPA/USGS Mississippi survey")))
                .andExpect(content().string(containsString("What does the historical radon survey show in Alcorn County, MS?")))
                .andExpect(content().string(not(containsString("What is the average radon level in Alcorn County, MS?"))))
                .andExpect(content().string(not(containsString("use the Alcorn County average"))));
    }

    @Test
    void newJerseyLevelsCountyUsesOfficialTierEvidenceWhenMeasurementsAreMissing() throws Exception {
        mockMvc.perform(get("/radon-levels/new-jersey/morris-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("County evidence interpretation")))
                .andExpect(content().string(containsString("Elevated radon-potential area")))
                .andExpect(content().string(containsString("Source-backed context")))
                .andExpect(content().string(containsString("Official evidence dossier")))
                .andExpect(content().string(containsString("Open official state source")))
                .andExpect(content().string(containsString("Evidence stack")))
                .andExpect(content().string(containsString("NJ municipal radon-potential table")))
                .andExpect(content().string(containsString("Town-level radon potential")))
                .andExpect(content().string(containsString("Nearby comparison: compare NJ counties")))
                .andExpect(content().string(containsString("19 Tier 1 municipalities")))
                .andExpect(content().string(containsString("20 Tier 2 municipalities")))
                .andExpect(content().string(containsString("48.7% of municipalities are Tier 1")))
                .andExpect(content().string(containsString("NJ DEP radon potential tiers are used for this county")));
    }

    @Test
    void sourceSpecificCountyPagesDoNotContradictTheirEvidenceType() throws Exception {
        mockMvc.perform(get("/radon-levels/north-carolina/wake-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("What does the highest reported radon reading in Wake County, NC mean?")))
                .andExpect(content().string(containsString("That is not a county average")))
                .andExpect(content().string(containsString("the slider does not start from a county average")))
                .andExpect(content().string(not(containsString("What is the average radon level in Wake County, NC?"))))
                .andExpect(content().string(not(containsString("use the Wake County average"))));

        mockMvc.perform(get("/radon-levels/new-jersey/morris-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("What do the radon potential tiers mean in Morris County, NJ?")))
                .andExpect(content().string(containsString("not a county pCi/L average")))
                .andExpect(content().string(containsString("The county evidence is a radon-potential tier, not a pCi/L reading.")))
                .andExpect(content().string(not(containsString("What is the average radon level in Morris County, NJ?"))))
                .andExpect(content().string(not(containsString("use the Morris County average"))));
    }

    @Test
    void stateHubsDescribeTheFullDataBackedCountySet() throws Exception {
        mockMvc.perform(get("/radon-levels/north-carolina"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Browse the 100 listed county pages surfaced for North Carolina")));

        mockMvc.perform(get("/radon-levels/new-jersey"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Browse the 21 listed county pages surfaced for New Jersey")));

        mockMvc.perform(get("/radon-levels/mississippi"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Browse the 82 listed county pages surfaced for Mississippi")));
    }

    @Test
    void radonLevelsRootPillarLoadsAndLinksTheLevelsSilo() throws Exception {
        String html = mockMvc.perform(get("/radon-levels"))
                .andExpect(status().isOk())
                .andExpect(content().string(not(containsString("<meta name=\"robots\" content=\"noindex, follow\">"))))
                .andExpect(content().string(containsString("<title>Radon Levels: What 2.0, 4.0, and 8.0 pCi/L Mean | EPA Guide</title>")))
                .andExpect(content().string(containsString("Radon Levels: What 2.0, 4.0, and 8.0 pCi/L Mean")))
                .andExpect(content().string(containsString("Popular radon level searches")))
                .andExpect(content().string(containsString("Choose your next step")))
                .andExpect(content().string(containsString("I need to know if this number is bad")))
                .andExpect(content().string(containsString("href=\"/radon-levels#level-meaning\"")))
                .andExpect(content().string(containsString("What does 4.0 pCi/L radon mean?")))
                .andExpect(content().string(containsString("Is 2.5 pCi/L radon bad?")))
                .andExpect(content().string(containsString("What does 8.0 pCi/L radon mean?")))
                .andExpect(content().string(containsString("Radon levels by county")))
                .andExpect(content().string(containsString("What radon level should homeowners act on?")))
                .andExpect(content().string(containsString("4.0+ pCi/L")))
                .andExpect(content().string(containsString("Browse radon levels by state")))
                .andExpect(content().string(containsString("/radon-levels/california")))
                .andExpect(content().string(containsString("/radon-cost-calculator")))
                .andExpect(content().string(containsString("/radon-credit-calculator")))
                .andExpect(content().string(containsString("Official County Data")))
                .andExpect(content().string(containsString("Every listed county page is tied to an official radon source")))
                .andExpect(content().string(containsString("Coverage currently spans 3126 listed county pages")))
                .andExpect(content().string(containsString("National Data Guide")))
                .andExpect(content().string(containsString("Open these state hubs first")))
                .andExpect(content().string(containsString("States with the strongest county evidence")))
                .andExpect(content().string(containsString("Official source base")))
                .andExpect(content().string(containsString("How to use it")))
                .andExpect(content().string(containsString("Colorado Environmental Public Health Tracking Pre-Mitigation Radon Test Results")))
                .andExpect(content().string(containsString("Wisconsin Department of Health Services Indoor Radon Test Results")))
                .andReturn()
                .getResponse()
                .getContentAsString();

        assertJsonLdBlocksAreValid(html);
    }

    @Test
    void radonLevelsStateAndCountyPagesLinkBackToRootPillar() throws Exception {
        mockMvc.perform(get("/radon-levels/california"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("href=\"/radon-levels\"")))
                .andExpect(content().string(containsString("2.0 vs 4.0 vs 8.0 pCi/L")));

        mockMvc.perform(get("/radon-levels/california/los-angeles-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Radon Levels: 2.0 vs 4.0 vs 8.0")))
                .andExpect(content().string(containsString("href=\"/radon-levels\"")));
    }

    @Test
    void radonLevelsStateHubShowsOfficialEvidenceCoverage() throws Exception {
        mockMvc.perform(get("/radon-levels/colorado"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Official Evidence in Colorado")))
                .andExpect(content().string(containsString("64 of 64 listed counties have official evidence")))
                .andExpect(content().string(containsString("Colorado Environmental Public Health Tracking Pre-Mitigation Radon Test Results: 64")))
                .andExpect(content().string(containsString("Open a county page to see the official source context")))
                .andExpect(content().string(containsString("Measured Risk Leaders in Colorado")))
                .andExpect(content().string(containsString("Highest 4.0+ share")))
                .andExpect(content().string(containsString("Highest high-end reading")))
                .andExpect(content().string(containsString("Most reported tests")))
                .andExpect(content().string(containsString("County rankings from actual reported radon tests")))
                .andExpect(content().string(containsString("State-level evidence read")))
                .andExpect(content().string(containsString("First-click counties")))
                .andExpect(content().string(containsString("Buyer/seller lane")))
                .andExpect(content().string(containsString("Retest lane")))
                .andExpect(content().string(containsString("Best county pages to open first")))
                .andExpect(content().string(containsString("Start with these local evidence pages")))
                .andExpect(content().string(containsString("Measured pattern")))
                .andExpect(content().string(containsString("Map vs measurements")))
                .andExpect(content().string(containsString("Source strategy")));
    }

    @Test
    void tennesseeLevelsUseStateOfficialMeasurementMoat() throws Exception {
        mockMvc.perform(get("/radon-levels/tennessee"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Official Evidence in Tennessee")))
                .andExpect(content().string(containsString("95 of 95 listed counties have official evidence")))
                .andExpect(content().string(containsString("Tennessee Environmental Public Health Tracking Radon Data: 95")))
                .andExpect(content().string(containsString("Measured Risk Leaders in Tennessee")));

        mockMvc.perform(get("/radon-levels/tennessee/williamson-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Tennessee Environmental Public Health Tracking Radon Data")))
                .andExpect(content().string(containsString("Reported tests")))
                .andExpect(content().string(containsString("739")))
                .andExpect(content().string(containsString("21.4%")))
                .andExpect(content().string(containsString("Tennessee Health Data says county and ZIP values come from radon test kit")))
                .andExpect(content().string(containsString("Tennessee values combine the state county-average layer with a RadonVerdict ZIP-to-county rollup")));
    }

    @Test
    void pennsylvaniaPriorityLevelsUseDepZipCountyRollups() throws Exception {
        mockMvc.perform(get("/radon-levels/pennsylvania"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Official Evidence in Pennsylvania")))
                .andExpect(content().string(containsString("Pennsylvania DEP Radon Test Data by ZIP Code: 50")));

        mockMvc.perform(get("/radon-levels/pennsylvania/chester-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Pennsylvania DEP Radon Test Data by ZIP Code")))
                .andExpect(content().string(containsString("Basement average")))
                .andExpect(content().string(containsString("171,039")))
                .andExpect(content().string(containsString("PA DEP floor rollup")))
                .andExpect(content().string(containsString("basement average 5.9 pCi/L from 148,154 tests")))
                .andExpect(content().string(containsString("first-floor average 3.6 pCi/L from 22,885 tests")))
                .andExpect(content().string(containsString("PA DEP Radon Division ZIP reports are based on short-term closed-house radon tests")))
                .andExpect(content().string(containsString("Pennsylvania values are RadonVerdict county rollups from PA DEP ZIP reports")));

        mockMvc.perform(get("/radon-levels/pennsylvania/allegheny-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Pennsylvania DEP Radon Test Data by ZIP Code")))
                .andExpect(content().string(containsString("224,538")))
                .andExpect(content().string(containsString("basement average 5.2 pCi/L from 210,004 tests")));

        mockMvc.perform(get("/radon-levels/pennsylvania/bucks-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Pennsylvania DEP Radon Test Data by ZIP Code")))
                .andExpect(content().string(containsString("168,622")))
                .andExpect(content().string(containsString("basement average 4.8 pCi/L from 132,588 tests")));

        mockMvc.perform(get("/radon-levels/pennsylvania/delaware-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Pennsylvania DEP Radon Test Data by ZIP Code")))
                .andExpect(content().string(containsString("88,541")))
                .andExpect(content().string(containsString("basement average 2.9 pCi/L from 75,586 tests")));

        mockMvc.perform(get("/radon-levels/pennsylvania/erie-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Pennsylvania DEP Radon Test Data by ZIP Code")))
                .andExpect(content().string(containsString("31,851")))
                .andExpect(content().string(containsString("basement average 4.6 pCi/L from 28,481 tests")));

        mockMvc.perform(get("/radon-levels/pennsylvania/york-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Pennsylvania DEP Radon Test Data by ZIP Code")))
                .andExpect(content().string(containsString("62,195")))
                .andExpect(content().string(containsString("basement average 11.8 pCi/L from 55,503 tests")));

        mockMvc.perform(get("/radon-levels/pennsylvania/montgomery-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Pennsylvania DEP Radon Test Data by ZIP Code")))
                .andExpect(content().string(containsString("218,713")))
                .andExpect(content().string(containsString("basement average 4.0 pCi/L from 180,075 tests")));

        mockMvc.perform(get("/radon-levels/pennsylvania/lancaster-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Pennsylvania DEP Radon Test Data by ZIP Code")))
                .andExpect(content().string(containsString("89,978")))
                .andExpect(content().string(containsString("basement average 10.4 pCi/L from 80,717 tests")));

        mockMvc.perform(get("/radon-levels/pennsylvania/berks-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Pennsylvania DEP Radon Test Data by ZIP Code")))
                .andExpect(content().string(containsString("56,243")))
                .andExpect(content().string(containsString("basement average 11.0 pCi/L from 51,096 tests")));

        mockMvc.perform(get("/radon-levels/pennsylvania/lehigh-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Pennsylvania DEP Radon Test Data by ZIP Code")))
                .andExpect(content().string(containsString("65,259")))
                .andExpect(content().string(containsString("basement average 10.5 pCi/L from 58,717 tests")));

        mockMvc.perform(get("/radon-levels/pennsylvania/northampton-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Pennsylvania DEP Radon Test Data by ZIP Code")))
                .andExpect(content().string(containsString("51,869")))
                .andExpect(content().string(containsString("basement average 9.5 pCi/L from 46,027 tests")));
    }

    @Test
    void virginiaLevelsUseVdhRenderedTableMeasurementMoat() throws Exception {
        mockMvc.perform(get("/radon-levels/virginia"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Official Evidence in Virginia")))
                .andExpect(content().string(containsString("133 of 133 listed counties have official evidence")))
                .andExpect(content().string(containsString("Virginia Department of Health Radon Testing Results: 133")))
                .andExpect(content().string(containsString("Measured Risk Leaders in Virginia")));

        mockMvc.perform(get("/radon-levels/virginia/fairfax-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Virginia Department of Health Radon Testing Results")))
                .andExpect(content().string(containsString("2016-2024")))
                .andExpect(content().string(containsString("Reported tests")))
                .andExpect(content().string(containsString("9,242")))
                .andExpect(content().string(containsString("2.9 pCi/L")))
                .andExpect(content().string(containsString("94.4 pCi/L")))
                .andExpect(content().string(containsString("VDH says the map displays indoor air radon results received by its Radon Program from 2016-2024")))
                .andExpect(content().string(containsString("VDH suppresses locality averages when fewer than 25 tests are available")))
                .andExpect(content().string(containsString("Virginia values come from VDH-received 2016-2024 indoor air radon results by locality")));

        mockMvc.perform(get("/radon-levels/virginia/falls-church-city"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Virginia Department of Health Radon Testing Results")))
                .andExpect(content().string(containsString("165")))
                .andExpect(content().string(containsString("2.6 pCi/L")))
                .andExpect(content().string(containsString("24.4 pCi/L")));

        mockMvc.perform(get("/radon-levels/virginia/loudoun-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Virginia Department of Health Radon Testing Results")))
                .andExpect(content().string(containsString("3,847")))
                .andExpect(content().string(containsString("4.1 pCi/L")))
                .andExpect(content().string(containsString("142.4 pCi/L")));
    }

    @Test
    void missouriLevelsUseDhssArcgisMeasurementMoat() throws Exception {
        mockMvc.perform(get("/radon-levels/missouri"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Official Evidence in Missouri")))
                .andExpect(content().string(containsString("115 of 115 listed counties have official evidence")))
                .andExpect(content().string(containsString("Missouri DHSS Residential Radon Testing in Missouri: 115")))
                .andExpect(content().string(containsString("Measured Risk Leaders in Missouri")));

        mockMvc.perform(get("/radon-levels/missouri/st-louis-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Missouri DHSS Residential Radon Testing in Missouri")))
                .andExpect(content().string(containsString("2005-2017")))
                .andExpect(content().string(containsString("Reported tests")))
                .andExpect(content().string(containsString("7,814")))
                .andExpect(content().string(containsString("3.7 pCi/L")))
                .andExpect(content().string(containsString("28.0%")))
                .andExpect(content().string(containsString("133.1 pCi/L")))
                .andExpect(content().string(containsString("RadonVerdict computes the 4.0+ share from non-negative point-level Final_Result records")))
                .andExpect(content().string(containsString("Missouri values come from the DHSS residential radon dashboard")));

        mockMvc.perform(get("/radon-levels/missouri/jackson-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Missouri DHSS Residential Radon Testing in Missouri")))
                .andExpect(content().string(containsString("4,980")))
                .andExpect(content().string(containsString("5.6 pCi/L")))
                .andExpect(content().string(containsString("45.2%")))
                .andExpect(content().string(containsString("100.7 pCi/L")));
    }

    @Test
    void utahLevelsUseEphtIbisMeasurementMoat() throws Exception {
        mockMvc.perform(get("/radon-levels/utah"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Official Evidence in Utah")))
                .andExpect(content().string(containsString("29 of 29 listed counties have official evidence")))
                .andExpect(content().string(containsString("Utah EPHT Radon Test Kit Results: 29")))
                .andExpect(content().string(containsString("Measured Risk Leaders in Utah")))
                .andExpect(content().string(containsString("Best county pages to open first")))
                .andExpect(content().string(containsString("First-click counties")));

        mockMvc.perform(get("/radon-levels/utah/salt-lake-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Utah EPHT Radon Test Kit Results")))
                .andExpect(content().string(containsString("2006-2019")))
                .andExpect(content().string(containsString("Reported tests")))
                .andExpect(content().string(containsString("25,214")))
                .andExpect(content().string(containsString("4.6 pCi/L")))
                .andExpect(content().string(containsString("37.0%")))
                .andExpect(content().string(containsString("172.9 pCi/L")))
                .andExpect(content().string(containsString("has more than the EPA map")))
                .andExpect(content().string(containsString("County-specific interpretation")))
                .andExpect(content().string(containsString("Salt Lake County is a test-now case")))
                .andExpect(content().string(containsString("Closest counties by county average")))
                .andExpect(content().string(containsString("Davis County")))
                .andExpect(content().string(containsString("Buyer or seller use")))
                .andExpect(content().string(containsString("Retest trigger")))
                .andExpect(content().string(containsString("Utah EPHT says the Indoor Radon Program receives radon test results from test kits purchased through its subsidized program")))
                .andExpect(content().string(containsString("Utah values come from DHHS EPHT/IBIS radon test kit result queries")));

        mockMvc.perform(get("/radon-levels/utah/utah-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Utah EPHT Radon Test Kit Results")))
                .andExpect(content().string(containsString("10,001")))
                .andExpect(content().string(containsString("5.8 pCi/L")))
                .andExpect(content().string(containsString("43.1%")))
                .andExpect(content().string(containsString("481.4 pCi/L")));
    }

    @Test
    void radonLevelsRootHubRoutesToOfficialDataStatesWithoutInternalTerms() throws Exception {
        String html = mockMvc.perform(get("/radon-levels"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Open Official-Data States First")))
                .andExpect(content().string(containsString("Route from the national threshold to state-specific radon data")))
                .andExpect(content().string(containsString("href=\"/radon-levels/iowa\"")))
                .andExpect(content().string(containsString("href=\"/radon-levels/north-carolina\"")))
                .andExpect(content().string(containsString("href=\"/radon-levels/pennsylvania\"")))
                .andExpect(content().string(containsString("href=\"/radon-levels/illinois\"")))
                .andExpect(content().string(containsString("href=\"/radon-levels/colorado\"")))
                .andExpect(content().string(containsString("href=\"/radon-levels/utah\"")))
                .andExpect(content().string(containsString("Osceola County, IA shows an 11.4 pCi/L median")))
                .andExpect(content().string(containsString("Rutherford County, NC shows 681 pCi/L as a high-end county signal")))
                .andExpect(content().string(containsString("Measured counties use official state tables or CDC Tracking summaries")))
                .andExpect(content().string(containsString("map-classified counties use official radon-potential categories")))
                .andReturn()
                .getResponse()
                .getContentAsString(StandardCharsets.UTF_8);

        String lowerHtml = html.toLowerCase();
        assertFalse(lowerHtml.contains("moat"), "Root hub should not expose internal moat language.");
        assertFalse(lowerHtml.contains("indexation"), "Root hub should not expose internal indexation language.");
        assertFalse(lowerHtml.contains("source-pending"), "Root hub should not expose source-pending language.");
        assertFalse(lowerHtml.contains("source pending"), "Root hub should not expose source pending language.");
    }

    @Test
    void publicPagesAvoidInternalOperationsLanguage() throws Exception {
        String[] routes = {
                "/radon-levels",
                "/radon-levels/colorado",
                "/radon-levels/utah/salt-lake-county",
                "/radon-mitigation-cost/california/los-angeles-county",
                "/radon-data-sources",
                "/radon-credit-calculator"
        };
        String[] bannedTerms = {
                "moat",
                "Deploy readiness",
                "Next data sprint",
                "retained index",
                "priority index",
                "indexation",
                "source-pending rows",
                "internal links",
                "not a map-only",
                "쨌",
                "�"
        };

        for (String route : routes) {
            String html = mockMvc.perform(get(route))
                    .andExpect(status().isOk())
                    .andReturn()
                    .getResponse()
                    .getContentAsString(StandardCharsets.UTF_8);

            for (String term : bannedTerms) {
                assertFalse(html.toLowerCase().contains(term.toLowerCase()),
                        "Public page " + route + " leaked internal/corrupt term: " + term);
            }
        }
    }

    @Test
    void radonLevelsCountyPlacesSituationPickerAheadOfInteractiveAdvisorForMobileFlow() throws Exception {
        String html = mockMvc.perform(get("/radon-levels/california/los-angeles-county"))
                .andExpect(status().isOk())
                .andReturn()
                .getResponse()
                .getContentAsString();

        assertTrue(html.contains("data-track-event=\"levels_mobile_jump_click\""));
        assertTrue(html.contains("Decision side"));
        assertTrue(html.contains("Foundation clue"));
        assertTrue(html.contains("data-rv-intent=\"buying\""));
        assertTrue(html.contains("data-rv-foundation=\"crawlspace\""));
        assertTrue(html.contains("href=\"/radon-credit-calculator/california/los-angeles-county?intent=buying&amp;radonResultBand=above_4&amp;foundation=basement\""));
        assertTrue(html.indexOf("id=\"county-evidence-first\"") < html.indexOf("id=\"situation-picker\""));
        assertTrue(html.indexOf("id=\"county-evidence-first\"") < html.indexOf("id=\"result-translator\""));
        assertTrue(html.indexOf("id=\"result-translator\"") < html.indexOf("id=\"situation-picker\""));
        assertTrue(html.indexOf("id=\"result-translator\"") < html.indexOf("id=\"search-intent-router\""));
        assertTrue(html.indexOf("id=\"search-intent-router\"") < html.indexOf("id=\"situation-picker\""));
        assertFalse(html.contains("data-rv-affiliate-link=\"true\""));
        assertTrue(html.indexOf("Measured Radon Data") < html.indexOf("Check your state radon program"));
        assertTrue(html.indexOf("id=\"situation-picker\"") < html.indexOf("Your Radon Reading"));
    }

    @Test
    void independentCitySeoAvoidsCountyLabelInTitleAndBreadcrumbJsonLd() throws Exception {
        mockMvc.perform(get("/radon-levels/virginia/falls-church-city"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("<title>Falls Church, VA Basement Radon Levels | EPA Zone &amp; 4.0 Guide</title>")))
                .andExpect(content().string(not(containsString("<title>Falls Church County, VA Basement Radon Levels | EPA Zone &amp; 4.0 Guide</title>"))))
                .andExpect(content().string(containsString("\"name\": \"Falls Church\"")))
                .andExpect(content().string(not(containsString("\"name\": \"Falls Church County\""))));
    }

    @Test
    void stateHubsUseHumanReadableStateNamesForLevelsAndCost() throws Exception {
        mockMvc.perform(get("/radon-mitigation-cost/california"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("California Radon Mitigation Cost by County")))
                .andExpect(content().string(containsString("Why Does Cost Vary in California?")));

        mockMvc.perform(get("/radon-levels/california"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("California Radon Map, Levels")))
                .andExpect(content().string(containsString("Testing Guide by County")))
                .andExpect(content().string(containsString("Check the California radon map by county")));
    }

    @Test
    void countyHubLeadSuccessUsesTrackedQualificationEvents() throws Exception {
        mockMvc.perform(get("/radon-mitigation-cost/california/los-angeles-county")
                        .param("intent", "homeowner")
                        .param("radonResultBand", "above_4")
                        .flashAttr("leadSuccessMessage", "Saved"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("qualify_lead")))
                .andExpect(content().string(containsString("close_convert_lead")))
                .andExpect(content().string(not(containsString("generate_lead"))));
    }

    @Test
    void layoutTrackingScriptExposesVersionedContextPayload() throws Exception {
        mockMvc.perform(get("/radon-mitigation-cost/california/los-angeles-county")
                        .param("intent", "homeowner")
                        .param("radonResultBand", "above_4"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("rv-tracking-version")))
                .andExpect(content().string(containsString("tracking_version")))
                .andExpect(content().string(containsString("window.__rvTrackingVersion")))
                .andExpect(content().string(containsString("page_type")))
                .andExpect(content().string(containsString("lead_source")));
    }

    @Test
    void htmxReceiptEndpointSendsNoindexRobotsHeader() throws Exception {
        mockMvc.perform(post("/htmx/calculate-receipt")
                        .param("stateSlug", "california")
                        .param("countySlug", "los-angeles-county")
                        .param("foundation", "basement")
                        .param("intent", "buying")
                        .param("sqftCategory", "under_2000"))
                .andExpect(status().isOk())
                .andExpect(header().string("X-Robots-Tag", "noindex"));
    }

    @Test
    void countyHubJsonLdScriptsAreValidJson() throws Exception {
        String html = mockMvc.perform(get("/radon-mitigation-cost/new-jersey/passaic-county"))
                .andExpect(status().isOk())
                .andReturn()
                .getResponse()
                .getContentAsString();

        assertJsonLdBlocksAreValid(html);
    }

    @Test
    void radonLevelsCountyJsonLdScriptsAreValidJson() throws Exception {
        String html = mockMvc.perform(get("/radon-levels/missouri/st-louis-county"))
                .andExpect(status().isOk())
                .andReturn()
                .getResponse()
                .getContentAsString();

        assertJsonLdBlocksAreValid(html);
    }

    @Test
    void fairfaxLevelsJsonLdDoesNotContainLegacyEscapeSequences() throws Exception {
        String html = mockMvc.perform(get("/radon-levels/virginia/fairfax-city"))
                .andExpect(status().isOk())
                .andReturn()
                .getResponse()
                .getContentAsString();

        assertJsonLdBlocksAreValid(html);
        assertTrue(!html.contains("fairfax\\-city"), "Breadcrumb JSON-LD should not escape the slug hyphen.");
    }

    @Test
    void fairfaxLevelsPageUsesCtrTunedCopy() throws Exception {
        mockMvc.perform(get("/radon-levels/virginia/fairfax-city"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Basement Test Guide")))
                .andExpect(content().string(containsString("what a basement test means at 2.0 vs 4.0+ pCi/L")));
    }

    @Test
    void topCtrCountyPagesUseBasementFirstSerpCopy() throws Exception {
        assertLevelsCountyCtrCopy("/radon-levels/ohio/licking-county", "Licking County, OH");
        assertLevelsCountyCtrCopy("/radon-levels/iowa/polk-county", "Polk County, IA");
    }

    @Test
    void secondWaveTopCtrCountyPagesUseBasementFirstSerpCopy() throws Exception {
        mockMvc.perform(get("/radon-levels/missouri/st-louis-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("<title>St. Louis County, MO Radon Levels, Testing &amp; Mitigation</title>")))
                .andExpect(content().string(not(containsString("Searching for St Louis radon?"))))
                .andExpect(content().string(containsString("Local service next step")))
                .andExpect(content().string(containsString("St. Louis searches need the official Missouri test signal and the local contractor path in one place")));
        assertLevelsCountyCtrCopy("/radon-levels/pennsylvania/allegheny-county", "Allegheny County, PA");
        assertLevelsCountyCtrCopy("/radon-levels/florida/hillsborough-county", "Hillsborough, FL");
    }

    @Test
    void phaseOneCtrLiftCountyPagesUseNextStepFirstSerpCopy() throws Exception {
        assertLevelsCountyNextStepCopy("/radon-levels/california/santa-clara-county");
        assertLevelsCountyNextStepCopy("/radon-levels/tennessee/williamson-county");
        assertLevelsCountyNextStepCopy("/radon-levels/georgia/cherokee-county");
    }

    @Test
    void phaseTwoCtrLiftCountyPagesUseNextStepFirstSerpCopy() throws Exception {
        assertLevelsCountyNextStepCopy("/radon-levels/new-york/westchester-county");
        assertLevelsCountyNextStepCopy("/radon-levels/florida/polk-county");
        assertLevelsCountyNextStepCopy("/radon-levels/idaho/ada-county");
    }

    @Test
    void phaseThreeCtrLiftCountyPagesUseNextStepFirstSerpCopy() throws Exception {
        assertLevelsCountyNextStepCopy("/radon-levels/pennsylvania/chester-county");
        assertLevelsCountyNextStepCopy("/radon-levels/illinois/kane-county");
        assertLevelsCountyNextStepCopy("/radon-levels/alabama/madison-county");
    }

    @Test
    void fallsChurchLevelsPageUsesLocationSpecificDecisionCopy() throws Exception {
        mockMvc.perform(get("/radon-levels/virginia/falls-church-city"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("<title>Falls Church, VA Basement Radon Levels | EPA Zone &amp; 4.0 Guide</title>")))
                .andExpect(content().string(containsString("Basement Radon Levels, EPA Zone &amp; Test Meaning in Falls Church, VA")))
                .andExpect(content().string(containsString("Basement test answer:")))
                .andExpect(content().string(containsString("If you are checking radon levels in a Falls Church basement")))
                .andExpect(content().string(containsString("Open the Falls Church action plan from the basement result you already have")))
                .andExpect(content().string(containsString("Plan a confirmatory basement test")))
                .andExpect(content().string(containsString("See Falls Church mitigation cost before calling contractors")))
                .andExpect(content().string(containsString("Turn a Falls Church result into seller-credit numbers")));
    }

    @Test
    void schenectadyLevelsPageUsesEpaZoneFirstSerpCopy() throws Exception {
        mockMvc.perform(get("/radon-levels/new-york/schenectady-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("<title>Schenectady County, NY EPA Radon Zone | Basement Levels &amp; 4.0 Guide</title>")))
                .andExpect(content().string(containsString("<meta name=\"description\" content=\"Check the EPA radon zone for Schenectady County, NY, see what that zone means for basement radon levels, and know when 2.0-3.9 versus 4.0+ changes the next step.\">")))
                .andExpect(content().string(containsString("EPA Radon Zone &amp; Basement Testing in Schenectady County, NY")))
                .andExpect(content().string(containsString("EPA zone answer first:")))
                .andExpect(content().string(containsString("If you are trying to confirm the EPA radon zone for Schenectady County")))
                .andExpect(content().string(containsString("Schenectady County is EPA Zone 2")));
    }

    @Test
    void dupageLevelsPageUsesBasementFirstSerpCopy() throws Exception {
        assertLevelsCountyCtrCopy("/radon-levels/illinois/dupage-county", "DuPage County, IL");
    }

    @Test
    void fremontLevelsPageUsesEpaZoneFirstSerpCopy() throws Exception {
        mockMvc.perform(get("/radon-levels/idaho/fremont-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("<title>Fremont County, ID EPA Radon Zone | Basement Levels &amp; 4.0 Guide</title>")))
                .andExpect(content().string(containsString("<meta name=\"description\" content=\"Check the EPA radon zone for Fremont County, ID, see what that zone means for basement radon levels, and know when 2.0-3.9 versus 4.0+ changes the next step.\">")))
                .andExpect(content().string(containsString("EPA Radon Zone &amp; Basement Testing in Fremont County, ID")))
                .andExpect(content().string(containsString("EPA zone answer first:")))
                .andExpect(content().string(containsString("If you are trying to confirm the EPA radon zone for Fremont County")))
                .andExpect(content().string(containsString("Open the Fremont County action plan from the EPA zone or reading you already have")))
                .andExpect(content().string(containsString("Plan a confirmatory zone test")))
                .andExpect(content().string(containsString("Open the Fremont County 4.0+ mitigation plan")))
                .andExpect(content().string(containsString("Turn a Fremont County result into seller-credit numbers")));
    }

    @Test
    void montanaLevelsStatePageUsesMapFocusedCopy() throws Exception {
        mockMvc.perform(get("/radon-levels/montana"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("<title>Montana Radon Map by County | EPA Zones, Levels &amp; Basement Testing</title>")))
                .andExpect(content().string(containsString("<meta name=\"description\" content=\"Use the Montana radon map by county to check EPA zones, see what 2.0 vs 4.0+ pCi/L basement test results mean, and decide when mitigation pricing is worth checking.\">")))
                .andExpect(content().string(containsString("Montana Radon Map by County")))
                .andExpect(content().string(containsString("Check the listed EPA radon zone pages across Montana")));
    }

    @Test
    void fairfaxCostJsonLdDoesNotEscapeApostrophes() throws Exception {
        String html = mockMvc.perform(get("/radon-mitigation-cost/virginia/fairfax-city"))
                .andExpect(status().isOk())
                .andReturn()
                .getResponse()
                .getContentAsString();

        assertJsonLdBlocksAreValid(html);
        assertTrue(!html.contains("EPA\\'s"), "FAQ JSON-LD should not escape apostrophes with backslashes.");
    }

    @Test
    void guidePageJsonLdScriptsAreValidJson() throws Exception {
        String html = mockMvc.perform(get("/guides/radon-exposure-symptoms"))
                .andExpect(status().isOk())
                .andReturn()
                .getResponse()
                .getContentAsString();

        assertJsonLdBlocksAreValid(html);
    }

    @Test
    void failedInspectionGuideLoadsAsHighIntentDecisionHub() throws Exception {
        String html = mockMvc.perform(get("/guides/radon-failed-inspection"))
                .andExpect(status().isOk())
                .andExpect(content().string(not(containsString("<meta name=\"robots\" content=\"noindex, follow\">"))))
                .andExpect(content().string(containsString("<title>Radon Failed Inspection: Seller Credit, Cost, and Retest Plan | RadonVerdict</title>")))
                .andExpect(content().string(containsString("<link rel=\"canonical\" href=\"https://radonverdict.com/guides/radon-failed-inspection\">")))
                .andExpect(content().string(containsString("Radon failed inspection: credit, repair, or retest?")))
                .andExpect(content().string(containsString("Calculate seller credit")))
                .andExpect(content().string(containsString("Open local cost path")))
                .andExpect(content().string(containsString("Do these in the right order.")))
                .andExpect(content().string(containsString("Who pays after a failed radon inspection?")))
                .andExpect(content().string(containsString("href=\"/guides/radon-mitigation-quote-checklist\"")))
                .andReturn()
                .getResponse()
                .getContentAsString();

        assertJsonLdBlocksAreValid(html);

        mockMvc.perform(get("/guides"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("High-intent guide")))
                .andExpect(content().string(containsString("href=\"/guides/radon-failed-inspection\"")))
                .andExpect(content().string(containsString("href=\"/guides/radon-inspection-toolkit\"")))
                .andExpect(content().string(containsString("href=\"/radon-quote-ledger\"")));
    }

    @Test
    void quoteChecklistGuideLoadsAsContractorCallAsset() throws Exception {
        String html = mockMvc.perform(get("/guides/radon-mitigation-quote-checklist"))
                .andExpect(status().isOk())
                .andExpect(content().string(not(containsString("<meta name=\"robots\" content=\"noindex, follow\">"))))
                .andExpect(content().string(containsString("<title>Radon Mitigation Quote Checklist: Questions Before You Hire | RadonVerdict</title>")))
                .andExpect(content().string(containsString("<link rel=\"canonical\" href=\"https://radonverdict.com/guides/radon-mitigation-quote-checklist\">")))
                .andExpect(content().string(containsString("Ask better radon quote questions before you hire.")))
                .andExpect(content().string(containsString("How to compare radon mitigation quotes")))
                .andExpect(content().string(containsString("Phone script")))
                .andExpect(content().string(containsString("Result and test type")))
                .andExpect(content().string(containsString("Do not compare quotes that describe different jobs.")))
                .andExpect(content().string(containsString("href=\"/radon-quote-ledger\"")))
                .andExpect(content().string(containsString("href=\"/guides/radon-inspection-toolkit\"")))
                .andReturn()
                .getResponse()
                .getContentAsString();

        assertJsonLdBlocksAreValid(html);

        mockMvc.perform(get("/guides"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("href=\"/guides/radon-mitigation-quote-checklist\"")))
                .andExpect(content().string(containsString("Radon mitigation quote checklist")));
    }

    @Test
    void quoteLedgerAndInspectionToolkitLoadAsDataMoatAssets() throws Exception {
        String ledgerHtml = mockMvc.perform(get("/radon-quote-ledger"))
                .andExpect(status().isOk())
                .andExpect(content().string(not(containsString("<meta name=\"robots\" content=\"noindex, follow\">"))))
                .andExpect(content().string(containsString("<title>Observed Radon Quote Ledger | RadonVerdict</title>")))
                .andExpect(content().string(containsString("<link rel=\"canonical\" href=\"https://radonverdict.com/radon-quote-ledger\">")))
                .andExpect(content().string(containsString("Real radon quotes beat generic averages.")))
                .andExpect(content().string(containsString("RadonVerdict observed radon quote ledger")))
                .andExpect(content().string(containsString("Priority collection gaps")))
                .andExpect(content().string(containsString("The next useful quote is local, not generic.")))
                .andExpect(content().string(containsString("Ulster County, NY")))
                .andExpect(content().string(containsString("Commercial, multifamily, or testing-scope quote signal.")))
                .andExpect(content().string(containsString("Is this radon quote fair?")))
                .andExpect(content().string(containsString("Radon Quote Index")))
                .andExpect(content().string(containsString("href=\"/radon-quote-ledger/benchmark.csv\"")))
                .andExpect(content().string(containsString("Shareable benchmark packet")))
                .andExpect(content().string(containsString("Commercial or multifamily quote")))
                .andExpect(content().string(containsString("Copy/paste request")))
                .andExpect(content().string(containsString("href=\"/guides/radon-mitigation-quote-checklist\"")))
                .andExpect(content().string(containsString("name=\"zipCode\"")))
                .andExpect(content().string(containsString("name=\"quotedPrice\"")))
                .andExpect(content().string(containsString("name=\"consentAccepted\"")))
                .andExpect(content().string(containsString("data-track-impression=\"quote_ledger_form_view\"")))
                .andExpect(content().string(containsString("data-track-impression=\"quote_checker_view\"")))
                .andReturn()
                .getResponse()
                .getContentAsString();

        assertJsonLdBlocksAreValid(ledgerHtml);

        String toolkitHtml = mockMvc.perform(get("/guides/radon-inspection-toolkit"))
                .andExpect(status().isOk())
                .andExpect(content().string(not(containsString("<meta name=\"robots\" content=\"noindex, follow\">"))))
                .andExpect(content().string(containsString("<title>Radon Failed Inspection Toolkit for Agents and Home Inspectors | RadonVerdict</title>")))
                .andExpect(content().string(containsString("<link rel=\"canonical\" href=\"https://radonverdict.com/guides/radon-inspection-toolkit\">")))
                .andExpect(content().string(containsString("A radon failed inspection needs a decision path, not panic.")))
                .andExpect(content().string(containsString("Radon failed inspection decision path")))
                .andExpect(content().string(containsString("Copy/paste packet")))
                .andExpect(content().string(containsString("Client-ready language")))
                .andExpect(content().string(containsString("Add one quote signal after the contractor call")))
                .andExpect(content().string(containsString("href=\"/guides/radon-mitigation-quote-checklist\"")))
                .andExpect(content().string(containsString("href=\"/radon-quote-ledger\"")))
                .andExpect(content().string(containsString("href=\"/radon-credit-calculator\"")))
                .andReturn()
                .getResponse()
                .getContentAsString();

        assertJsonLdBlocksAreValid(toolkitHtml);
    }

    @Test
    void sellerCreditWorksheetGuideLoads() throws Exception {
        mockMvc.perform(get("/guides/radon-seller-credit-worksheet"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Radon Seller Credit Worksheet")))
                .andExpect(content().string(containsString("repair or credit ask")));
    }

    @Test
    void energyCostGuideFrontloadsMonthlyAndAnnualAnswer() throws Exception {
        mockMvc.perform(get("/guides/radon-system-electricity-cost"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("<title>Radon System Electricity Cost: $5-$15/Month to Run the Fan | RadonVerdict</title>")))
                .andExpect(content().string(containsString("<meta name=\"description\" content=\"Most radon mitigation fans add about $5 to $15 per month ($60 to $180 per year) to the power bill. See the wattage math for typical 40 to 150 watt systems.\">")))
                .andExpect(content().string(containsString("Radon System Electricity Cost: Usually $5-$15 Per Month")))
                .andExpect(content().string(containsString("Most radon mitigation fans add about $5 to $15 per month to the power bill, or roughly $60 to $180 per year.")));
    }

    @Test
    void adminRootRedirectsToLeadsWhenAuthenticated() throws Exception {
        mockMvc.perform(get("/admin")
                        .header("Authorization", basicAuth("admin", "tlsgur3108")))
                .andExpect(status().is3xxRedirection())
                .andExpect(header().string("Location", "/admin/leads"));
    }

    @Test
    void adminLeadsPageLoadsWhenAuthenticated() throws Exception {
        mockMvc.perform(get("/admin/leads")
                        .header("Authorization", basicAuth("admin", "tlsgur3108")))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Leads Dashboard")));
    }

    private void assertJsonLdBlocksAreValid(String html) throws Exception {
        Matcher matcher = JSON_LD_SCRIPT_PATTERN.matcher(html);
        int scriptCount = 0;
        while (matcher.find()) {
            scriptCount++;
            String jsonLd = matcher.group(1).trim();
            OBJECT_MAPPER.readTree(jsonLd);
        }
        assertTrue(scriptCount > 0, "Expected at least one JSON-LD script block.");
    }

    private void assertLevelsCountyCtrCopy(String path, String placeLabel) throws Exception {
        mockMvc.perform(get(path))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("<title>" + placeLabel + " Basement Radon Levels | EPA Zone &amp; 4.0 Guide</title>")))
                .andExpect(content().string(containsString("<meta name=\"description\" content=\"Check basement radon levels in " + placeLabel + ", see the EPA zone, and understand what 2.0 vs 4.0+ pCi/L means before you retest or compare mitigation quotes.\">")))
                .andExpect(content().string(containsString("Basement Radon Levels, EPA Zone &amp; Test Meaning in " + placeLabel)))
                .andExpect(content().string(containsString("Basement test answer:")));
    }

    private void assertLevelsCountyNextStepCopy(String path) throws Exception {
        mockMvc.perform(get(path))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Radon Levels | EPA Zone, 4.0+, and Next Step</title>")))
                .andExpect(content().string(containsString("see the EPA zone, and know whether to test, retest, or budget mitigation after a 4.0+ result.")))
                .andExpect(content().string(containsString("Radon Levels, EPA Zone &amp; Next Step")))
                .andExpect(content().string(containsString("Fast local answer:")))
                .andExpect(content().string(containsString("County map context helps, but your own result is what changes the decision.")))
                .andExpect(content().string(containsString("No reading yet means test first. 2.0-3.9 usually means retest or track. 4.0+ means local budget planning starts.")))
                .andExpect(content().string(containsString("No reading: test first. 2.0-3.9: retest or track. 4.0+: budget local mitigation.")));
    }

    private String basicAuth(String username, String password) {
        String token = username + ":" + password;
        return "Basic " + Base64.getEncoder().encodeToString(token.getBytes(StandardCharsets.UTF_8));
    }
}
