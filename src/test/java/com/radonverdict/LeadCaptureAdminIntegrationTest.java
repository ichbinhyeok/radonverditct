package com.radonverdict;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.servlet.MockMvc;

import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Base64;

import static org.hamcrest.Matchers.containsString;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.flash;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.redirectedUrl;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest(properties = {
        "app.site.enforce-canonical-host=false",
        "app.storage.leads-csv-path=build/tmp/lead-capture-admin/leads.csv",
        "app.storage.telemetry-csv-path=build/tmp/lead-capture-admin/telemetry_events.csv",
        "app.storage.search-console-indexing-csv-path=build/tmp/lead-capture-admin/search-console-indexing.csv"
})
@AutoConfigureMockMvc
class LeadCaptureAdminIntegrationTest {

    private static final Path LEADS_CSV_PATH = Paths.get("build", "tmp", "lead-capture-admin", "leads.csv");
    private static final Path TELEMETRY_CSV_PATH = Paths.get("build", "tmp", "lead-capture-admin", "telemetry_events.csv");
    private static final Path SEARCH_CONSOLE_CSV_PATH = Paths.get("build", "tmp", "lead-capture-admin", "search-console-indexing.csv");

    @Autowired
    private MockMvc mockMvc;

    @BeforeEach
    void beforeEach() throws Exception {
        Files.createDirectories(LEADS_CSV_PATH.getParent());
        Files.deleteIfExists(LEADS_CSV_PATH);
        Files.deleteIfExists(TELEMETRY_CSV_PATH);
        Files.deleteIfExists(SEARCH_CONSOLE_CSV_PATH);
    }

    @Test
    void successfulLeadSubmissionAppearsOnAdminDashboard() throws Exception {
        String email = "integration+" + System.currentTimeMillis() + "@example.com";

        mockMvc.perform(post("/submit-lead")
                        .param("customerEmail", email)
                        .param("zipCode", "22030")
                        .param("customerPhone", "")
                        .param("customerName", "Integration Test")
                        .param("foundationType", "basement")
                        .param("hasTested", "true")
                        .param("countySlug", "fairfax-city")
                        .param("stateSlug", "virginia")
                        .param("stateAbbr", "VA")
                        .param("consentVersion", "v1.0")
                        .param("consent", "true")
                        .param("preferredContactTime", "urgent_24h")
                        .param("selectedIntent", "homeowner")
                        .param("selectedRadonResultBand", "above_4"))
                .andExpect(status().is3xxRedirection())
                .andExpect(flash().attributeExists("leadSuccessMessage"))
                .andExpect(redirectedUrl("/radon-mitigation-cost/virginia/fairfax-city?intent=homeowner&radonResultBand=above_4&zipCode=22030#estimate-form"));

        assertTrue(Files.exists(LEADS_CSV_PATH), "Lead CSV should exist after a successful submission.");
        assertTrue(Files.readString(LEADS_CSV_PATH).contains(email), "Lead CSV should contain the submitted email.");
        assertTrue(Files.readString(LEADS_CSV_PATH).contains("urgent_24h"), "Lead CSV should contain contact priority.");
        assertTrue(Files.readString(LEADS_CSV_PATH).contains("LeadScore"), "Lead CSV should contain lead score header.");
        assertTrue(Files.readString(LEADS_CSV_PATH).contains("LifecycleStatus"), "Lead CSV should contain lifecycle tracking.");
        assertTrue(Files.readString(LEADS_CSV_PATH).contains("ResponseSlaMinutes"), "Lead CSV should contain speed-to-lead SLA.");
        assertTrue(Files.readString(LEADS_CSV_PATH).contains("RevenueExpected"), "Lead CSV should contain revenue tracking.");
        assertTrue(Files.readString(LEADS_CSV_PATH).contains("HOT"), "High-intent lead should be scored hot.");
        assertTrue(Files.readString(TELEMETRY_CSV_PATH).contains("lead_submit_success"),
                "Server telemetry should record the saved lead, not only the client click.");

        mockMvc.perform(get("/admin/leads")
                        .header("Authorization", basicAuth("admin", "tlsgur3108")))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Leads Dashboard")))
                .andExpect(content().string(containsString("Revenue operations")))
                .andExpect(content().string(containsString("Submitted")))
                .andExpect(content().string(containsString("SLA risk")))
                .andExpect(content().string(containsString("Call first")))
                .andExpect(content().string(containsString("Score")))
                .andExpect(content().string(containsString("Next Action")))
                .andExpect(content().string(containsString("SUBMITTED")))
                .andExpect(content().string(containsString("UNREVIEWED")))
                .andExpect(content().string(containsString("HOT")))
                .andExpect(content().string(containsString("Priority")))
                .andExpect(content().string(containsString("urgent_24h")))
                .andExpect(content().string(containsString(email)))
                .andExpect(content().string(containsString("fairfax-city")));
    }

    @Test
    void searchConsoleCohortDashboardLoadsWithExportedStatuses() throws Exception {
        Files.writeString(SEARCH_CONSOLE_CSV_PATH, String.join(System.lineSeparator(),
                "URL,Page indexing",
                "https://radonverdict.com/radon-levels/virginia/loudoun-county,Submitted and indexed",
                "https://radonverdict.com/radon-mitigation-cost/pennsylvania/montgomery-county,Crawled - currently not indexed",
                "https://radonverdict.com/radon-levels/new-jersey/gloucester-county,Discovered - currently not indexed"));

        mockMvc.perform(get("/admin/search-console")
                        .header("Authorization", basicAuth("admin", "tlsgur3108")))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Search Console Cohorts")))
                .andExpect(content().string(containsString("GSC export loaded")))
                .andExpect(content().string(containsString("sitemap-cost-evidence.xml")))
                .andExpect(content().string(containsString("Submit or refresh in GSC")))
                .andExpect(content().string(containsString("Query watchlist")))
                .andExpect(content().string(containsString("radon gas testing Ulster County NY")))
                .andExpect(content().string(containsString("commercial radon Los Angeles CA")))
                .andExpect(content().string(containsString("Crawled not indexed")))
                .andExpect(content().string(containsString("Manual URL inspection queue")));
    }

    private String basicAuth(String username, String password) {
        String token = username + ":" + password;
        return "Basic " + Base64.getEncoder().encodeToString(token.getBytes(StandardCharsets.UTF_8));
    }
}
