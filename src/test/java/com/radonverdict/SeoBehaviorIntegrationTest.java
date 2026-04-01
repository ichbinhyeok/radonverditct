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
                .andExpect(header().string("Location", "https://radonverdict.com/radon-cost-calculator"));
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
    void globalCreditCalculatorLandingLoads() throws Exception {
        mockMvc.perform(get("/radon-credit-calculator"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Radon Seller Credit Calculator")))
                .andExpect(content().string(containsString("Get My Local Credit Number")))
                .andExpect(content().string(containsString("Buyer asking for credit")))
                .andExpect(content().string(containsString("Seller budgeting response")));
    }

    @Test
    void searchZipCarriesScenarioPrefillIntoCountyRedirect() throws Exception {
        mockMvc.perform(post("/search-zip")
                        .param("zipCode", "90210")
                        .param("intent", "buying")
                        .param("radonResultBand", "above_4"))
                .andExpect(status().isSeeOther())
                .andExpect(header().string("Location",
                        "https://radonverdict.com/radon-mitigation-cost/california/los-angeles-county?intent=buying&radonResultBand=above_4"));
    }

    @Test
    void searchZipCreditRedirectsIntoCountyCreditCalculator() throws Exception {
        mockMvc.perform(post("/search-zip-credit")
                        .param("zipCode", "90210")
                        .param("intent", "selling")
                        .param("radonResultBand", "above_4"))
                .andExpect(status().isSeeOther())
                .andExpect(header().string("Location",
                        "https://radonverdict.com/radon-credit-calculator/california/los-angeles-county?intent=selling&radonResultBand=above_4"));
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
                .andExpect(header().string("Location", "https://radonverdict.com/radon-levels/puerto-rico/ponce-municipio"));
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
                .andExpect(content().string(containsString("Why this estimate looks like this")))
                .andExpect(content().string(containsString("vs State vs National")));
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
    void radonLevelsCountyUsesTestingGuideSeoAndKeepsTestingAdvisorCtas() throws Exception {
        mockMvc.perform(get("/radon-levels/missouri/st-louis-county"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("St. Louis County, MO Radon Levels, Zone Map")))
                .andExpect(content().string(containsString("Home Testing Guide")))
                .andExpect(content().string(containsString("Direct Answer for basement and lowest-level tests:")))
                .andExpect(content().string(containsString("/radon-credit-calculator/missouri/st-louis-county?radonResultBand=above_4&intent=buying")))
                .andExpect(content().string(not(containsString("At <strong x-text=\"parseFloat(level).toFixed(1)\"></strong> pCi/L"))))
                .andExpect(content().string(containsString("Get a Home Radon Monitor (~$30)")))
                .andExpect(content().string(containsString("Verify with Long-term Monitor (~$150)")));
    }

    @Test
    void independentCitySeoAvoidsCountyLabelInTitleAndBreadcrumbJsonLd() throws Exception {
        mockMvc.perform(get("/radon-levels/virginia/falls-church-city"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Falls Church, VA Radon Levels")))
                .andExpect(content().string(not(containsString("Falls Church County, VA Radon Levels"))))
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
                .andExpect(content().string(containsString("California Radon Map, Levels & Testing Guide")))
                .andExpect(content().string(containsString("Check the California radon map by county")));
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

    private String basicAuth(String username, String password) {
        String token = username + ":" + password;
        return "Basic " + Base64.getEncoder().encodeToString(token.getBytes(StandardCharsets.UTF_8));
    }
}
