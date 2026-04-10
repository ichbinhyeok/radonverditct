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
        "app.storage.telemetry-csv-path=build/tmp/lead-capture-admin/telemetry_events.csv"
})
@AutoConfigureMockMvc
class LeadCaptureAdminIntegrationTest {

    private static final Path LEADS_CSV_PATH = Paths.get("build", "tmp", "lead-capture-admin", "leads.csv");

    @Autowired
    private MockMvc mockMvc;

    @BeforeEach
    void beforeEach() throws Exception {
        Files.createDirectories(LEADS_CSV_PATH.getParent());
        Files.deleteIfExists(LEADS_CSV_PATH);
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
                        .param("selectedIntent", "homeowner")
                        .param("selectedRadonResultBand", "above_4"))
                .andExpect(status().is3xxRedirection())
                .andExpect(flash().attributeExists("leadSuccessMessage"))
                .andExpect(redirectedUrl("/radon-mitigation-cost/virginia/fairfax-city?intent=homeowner&radonResultBand=above_4&zipCode=22030#estimate-form"));

        assertTrue(Files.exists(LEADS_CSV_PATH), "Lead CSV should exist after a successful submission.");
        assertTrue(Files.readString(LEADS_CSV_PATH).contains(email), "Lead CSV should contain the submitted email.");

        mockMvc.perform(get("/admin/leads")
                        .header("Authorization", basicAuth("admin", "tlsgur3108")))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Leads Dashboard")))
                .andExpect(content().string(containsString(email)))
                .andExpect(content().string(containsString("fairfax-city")));
    }

    private String basicAuth(String username, String password) {
        String token = username + ":" + password;
        return "Basic " + Base64.getEncoder().encodeToString(token.getBytes(StandardCharsets.UTF_8));
    }
}
