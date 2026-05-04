package com.radonverdict;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.servlet.MockMvc;

import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

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
    void homeRedirectUsesCanonicalHttpsUrl() throws Exception {
        mockMvc.perform(get("/"))
                .andExpect(status().isMovedPermanently())
                .andExpect(header().string("Location", "/radon-cost-calculator"));
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
                .andExpect(content().string(containsString("Use the national cost guide")));

        mockMvc.perform(get("/radon-mitigation-cost/california/los-angeles-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Radon Mitigation Cost Guide")))
                .andExpect(content().string(containsString("href=\"/radon-mitigation-cost\"")));
    }

    @Test
    void globalCreditCalculatorLandingLoads() throws Exception {
        mockMvc.perform(get("/radon-credit-calculator"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Radon Seller Credit Calculator")))
                .andExpect(content().string(containsString("Get My Local Credit Number")))
                .andExpect(content().string(containsString("Buyer asking for credit")))
                .andExpect(content().string(containsString("Seller budgeting response")));
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
    void searchZipCreditRedirectsIntoCountyCreditCalculator() throws Exception {
        mockMvc.perform(post("/search-zip-credit")
                        .param("zipCode", "90210")
                        .param("intent", "selling")
                        .param("radonResultBand", "above_4"))
                .andExpect(status().isSeeOther())
                .andExpect(header().string("Location",
                        "/radon-credit-calculator/california/los-angeles-county?intent=selling&radonResultBand=above_4"));
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
    void sitemapIndexPrioritizesHighIntentAndUsesCountyFreshness() throws Exception {
        mockMvc.perform(get("/sitemap.xml"))
                .andExpect(status().isOk())
                .andExpect(content().string(not(containsString("/sitemap-zone-low.xml"))))
                .andExpect(content().string(not(containsString("/sitemap-zone-unknown.xml"))));

        mockMvc.perform(get("/sitemap-zone-high.xml"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("<lastmod>2026-02-24</lastmod>")));
    }

    @Test
    void zone3CountyPagesAreNoindexByPolicy() throws Exception {
        mockMvc.perform(get("/radon-mitigation-cost/california/butte-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("<meta name=\"robots\" content=\"noindex, follow\">")));

        mockMvc.perform(get("/radon-levels/california/butte-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("<meta name=\"robots\" content=\"noindex, follow\">")));
    }

    @Test
    void stateHubsDoNotListZone3CountiesByDefault() throws Exception {
        mockMvc.perform(get("/radon-mitigation-cost/california"))
                .andExpect(status().isOk())
                .andExpect(content().string(not(containsString("/radon-mitigation-cost/california/butte-county"))))
                .andExpect(content().string(containsString("/radon-mitigation-cost/california/alameda-county")));

        mockMvc.perform(get("/radon-levels/california"))
                .andExpect(status().isOk())
                .andExpect(content().string(not(containsString("/radon-levels/california/butte-county"))))
                .andExpect(content().string(containsString("/radon-levels/california/alameda-county")));
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
                .andExpect(content().string(containsString("We do not automatically label every page as reviewed today")));

        mockMvc.perform(get("/contact"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("We do not maintain a public walk-in office")))
                .andExpect(content().string(not(containsString("100 Innovation Drive"))))
                .andExpect(content().string(not(containsString("Tech Hub, NY 10001"))));
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
                .andExpect(content().string(containsString("Build Your Local Action Plan")))
                .andExpect(content().string(containsString("Current Result")))
                .andExpect(content().string(containsString("Not tested")))
                .andExpect(content().string(containsString("4.0+")))
                .andExpect(content().string(containsString("action plan")))
                .andExpect(content().string(containsString("Get Next Step")));
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
                .andExpect(content().string(containsString("Send My Credit Strategy")));
    }

    @Test
    void countyHubShowsHighReadingFastPathForHomeownerFlow() throws Exception {
        mockMvc.perform(get("/radon-mitigation-cost/california/los-angeles-county")
                        .param("radonResultBand", "above_4")
                        .param("intent", "homeowner"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("High Reading Budget Snapshot")))
                .andExpect(content().string(containsString("Open 4.0+ Worksheet")))
                .andExpect(content().string(containsString("Send My 4.0+ Action Plan")));
    }

    @Test
    void radonLevelsCountyUsesTestingGuideSeoAndFrontloadsSituationPicker() throws Exception {
        mockMvc.perform(get("/radon-levels/california/los-angeles-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Los Angeles County, CA Radon Levels, Zone Map")))
                .andExpect(content().string(containsString("Home Testing Guide")))
                .andExpect(content().string(containsString("data-nosnippet")))
                .andExpect(content().string(containsString("Direct Answer for basement and lowest-level tests:")))
                .andExpect(content().string(containsString("Pick the situation that matches you")))
                .andExpect(content().string(containsString("Pick My Next Step")))
                .andExpect(content().string(containsString("I have not tested yet")))
                .andExpect(content().string(containsString("Start with a Short-Term Test Kit")))
                .andExpect(content().string(containsString("Read the 3-minute testing guide")))
                .andExpect(content().string(containsString("My result is 4.0+")))
                .andExpect(content().string(containsString("/radon-credit-calculator/california/los-angeles-county?radonResultBand=above_4&intent=buying")))
                .andExpect(content().string(not(containsString("At <strong x-text=\"parseFloat(level).toFixed(1)\"></strong> pCi/L"))))
                .andExpect(content().string(containsString("View Airthings Corentium Home")));
    }

    @Test
    void radonLevelsRootPillarLoadsAndLinksTheLevelsSilo() throws Exception {
        String html = mockMvc.perform(get("/radon-levels"))
                .andExpect(status().isOk())
                .andExpect(content().string(not(containsString("<meta name=\"robots\" content=\"noindex, follow\">"))))
                .andExpect(content().string(containsString("<title>Radon Levels: What 2.0, 4.0, and 8.0 pCi/L Mean | EPA Guide</title>")))
                .andExpect(content().string(containsString("Radon Levels: What 2.0, 4.0, and 8.0 pCi/L Mean")))
                .andExpect(content().string(containsString("What radon level should homeowners act on?")))
                .andExpect(content().string(containsString("4.0+ pCi/L")))
                .andExpect(content().string(containsString("Browse radon levels by state")))
                .andExpect(content().string(containsString("/radon-levels/california")))
                .andExpect(content().string(containsString("/radon-cost-calculator")))
                .andExpect(content().string(containsString("/radon-credit-calculator")))
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
    void radonLevelsCountyPlacesSituationPickerAheadOfInteractiveAdvisorForMobileFlow() throws Exception {
        String html = mockMvc.perform(get("/radon-levels/california/los-angeles-county"))
                .andExpect(status().isOk())
                .andReturn()
                .getResponse()
                .getContentAsString();

        assertTrue(html.contains("data-track-event=\"levels_mobile_jump_click\""));
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
        assertLevelsCountyCtrCopy("/radon-levels/mississippi/alcorn-county", "Alcorn County, MS");
        assertLevelsCountyCtrCopy("/radon-levels/ohio/licking-county", "Licking County, OH");
        assertLevelsCountyCtrCopy("/radon-levels/iowa/polk-county", "Polk County, IA");
    }

    @Test
    void secondWaveTopCtrCountyPagesUseBasementFirstSerpCopy() throws Exception {
        assertLevelsCountyCtrCopy("/radon-levels/missouri/st-louis-county", "St. Louis County, MO");
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
                .andExpect(content().string(containsString("See what a Falls Church basement result means for pricing")))
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
                .andExpect(content().string(containsString("See what a Fremont County borderline result means for pricing")))
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
                .andExpect(content().string(containsString("Check county-by-county EPA radon zones across Montana")));
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
