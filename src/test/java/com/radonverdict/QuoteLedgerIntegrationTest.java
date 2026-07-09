package com.radonverdict;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.servlet.MockMvc;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import static org.hamcrest.Matchers.containsString;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.flash;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.redirectedUrl;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest(properties = {
        "app.site.enforce-canonical-host=false",
        "app.storage.quote-ledger-csv-path=build/tmp/quote-ledger/quote_ledger.csv",
        "app.storage.leads-csv-path=build/tmp/quote-ledger/leads.csv",
        "app.storage.telemetry-csv-path=build/tmp/quote-ledger/telemetry_events.csv"
})
@AutoConfigureMockMvc
class QuoteLedgerIntegrationTest {

    private static final Path QUOTE_LEDGER_CSV_PATH = Paths.get("build", "tmp", "quote-ledger", "quote_ledger.csv");
    private static final Path LEADS_CSV_PATH = Paths.get("build", "tmp", "quote-ledger", "leads.csv");
    private static final Path TELEMETRY_CSV_PATH = Paths.get("build", "tmp", "quote-ledger", "telemetry_events.csv");

    @Autowired
    private MockMvc mockMvc;

    @BeforeEach
    void beforeEach() throws Exception {
        Files.createDirectories(QUOTE_LEDGER_CSV_PATH.getParent());
        Files.deleteIfExists(QUOTE_LEDGER_CSV_PATH);
        Files.deleteIfExists(LEADS_CSV_PATH);
        Files.deleteIfExists(TELEMETRY_CSV_PATH);
    }

    @Test
    void quoteLedgerSubmissionWritesCountyResolvedCsvRow() throws Exception {
        mockMvc.perform(post("/radon-quote-ledger")
                        .param("zipCode", "22030")
                        .param("role", "buyer")
                        .param("resultBand", "above_4")
                        .param("radonReadingPciL", "5.2")
                        .param("foundationType", "basement")
                        .param("quoteStatus", "quoted")
                        .param("quotedPrice", "2100")
                        .param("finalPrice", "")
                        .param("systemScope", "sub-slab and sump seal")
                        .param("timeline", "inspection deadline")
                        .param("email", "quote-ledger@example.com")
                        .param("notes", "Two bids, one included permit.")
                        .param("consentAccepted", "true"))
                .andExpect(status().isSeeOther())
                .andExpect(flash().attributeExists("quoteLedgerSuccessMessage"))
                .andExpect(redirectedUrl("/radon-quote-ledger"));

        assertTrue(Files.exists(QUOTE_LEDGER_CSV_PATH), "Quote ledger CSV should exist after submission.");
        String csv = Files.readString(QUOTE_LEDGER_CSV_PATH);
        assertTrue(csv.contains("Date,Zip,State,County,Role,ResultBand"), "CSV should contain the quote ledger header.");
        assertTrue(csv.contains("22030"), "CSV should contain the submitted ZIP.");
        assertTrue(csv.contains("VA"), "CSV should contain the resolved state.");
        assertTrue(csv.contains("fairfax-city"), "CSV should contain the resolved county slug.");
        assertTrue(csv.contains("2100"), "CSV should contain the submitted quote.");
        assertTrue(csv.contains("quote-ledger@example.com"), "CSV should contain optional follow-up email.");
        assertTrue(Files.readString(TELEMETRY_CSV_PATH).contains("quote_ledger_submit_success"),
                "Server telemetry should record successful quote ledger submissions.");
    }

    @Test
    void quoteLedgerRejectsUnknownZipWithoutWritingCsv() throws Exception {
        mockMvc.perform(post("/radon-quote-ledger")
                        .param("zipCode", "00000")
                        .param("role", "homeowner")
                        .param("resultBand", "above_4")
                        .param("foundationType", "basement")
                        .param("quoteStatus", "quoted")
                        .param("quotedPrice", "1800")
                        .param("consentAccepted", "true"))
                .andExpect(status().isSeeOther())
                .andExpect(flash().attributeExists("quoteLedgerErrorMessage"))
                .andExpect(redirectedUrl("/radon-quote-ledger"));

        assertFalse(Files.exists(QUOTE_LEDGER_CSV_PATH), "Unknown ZIP submissions should not write a CSV row.");

        mockMvc.perform(get("/radon-quote-ledger"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Observed Radon Quote Ledger")));
    }

    @Test
    void quoteLedgerRendersCheckerAndEmptyPublicIndex() throws Exception {
        mockMvc.perform(get("/radon-quote-ledger"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Is this radon quote fair?")))
                .andExpect(content().string(containsString("Enter a quote to compare the scope.")))
                .andExpect(content().string(containsString("Radon Quote Index")))
                .andExpect(content().string(containsString("Public aggregate ranges, not private submissions.")))
                .andExpect(content().string(containsString("No public benchmark yet.")))
                .andExpect(content().string(containsString("href=\"/radon-quote-ledger/benchmark.csv\"")));

        mockMvc.perform(get("/radon-quote-ledger/benchmark.csv"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Market,State,County,Foundation,ResultBand,SignalCount,PricedSignalCount,PriceRange,Median,Confidence")));
    }

    @Test
    void quoteLedgerPrefillsSafeQueryParamsFromCountyBidChecker() throws Exception {
        String html = mockMvc.perform(get("/radon-quote-ledger")
                        .param("zipCode", "22030")
                        .param("role", "buyer")
                        .param("resultBand", "above_8")
                        .param("radonReadingPciL", "8.4")
                        .param("foundationType", "crawlspace")
                        .param("quoteStatus", "quoted")
                        .param("quotedPrice", "2600")
                        .param("finalPrice", "2500")
                        .param("systemScope", "fan warranty retest")
                        .param("timeline", "county cost page quote check")
                        .param("notes", "Bid checker says above target.")
                        .param("consentAccepted", "true"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("value=\"22030\"")))
                .andExpect(content().string(containsString("value=\"8.4\"")))
                .andExpect(content().string(containsString("value=\"buyer\" checked")))
                .andExpect(content().string(containsString("value=\"above_8\" selected")))
                .andExpect(content().string(containsString("value=\"crawlspace\" selected")))
                .andExpect(content().string(containsString("value=\"2600\"")))
                .andExpect(content().string(containsString("fan warranty retest")))
                .andExpect(content().string(containsString("Bid checker says above target.")))
                .andReturn()
                .getResponse()
                .getContentAsString();

        assertFalse(html.contains("name=\"consentAccepted\" value=\"true\" checked"),
                "URL prefill must not pre-check consent.");
    }

    @Test
    void quoteLedgerPublishesAggregateBenchmarksWithoutPrivateColumns() throws Exception {
        Files.writeString(QUOTE_LEDGER_CSV_PATH, String.join(System.lineSeparator(),
                "Date,Zip,State,County,Role,ResultBand,RadonReadingPciL,Foundation,QuoteStatus,QuotedPrice,FinalPrice,SystemScope,Timeline,Email,Notes,IpAddress,UserAgent",
                "\"2026-07-09 10:00:00\",\"22030\",\"VA\",\"fairfax-city\",\"buyer\",\"above_4\",\"5.2\",\"basement\",\"quoted\",\"1900\",\"\",\"sub-slab\",\"inspection\",\"one@example.com\",\"private note\",\"127.0.0.1\",\"JUnit\"",
                "\"2026-07-09 10:05:00\",\"22030\",\"VA\",\"fairfax-city\",\"seller\",\"above_4\",\"4.8\",\"basement\",\"paid\",\"2100\",\"2100\",\"sub-slab\",\"inspection\",\"two@example.com\",\"private note\",\"127.0.0.2\",\"JUnit\"",
                "\"2026-07-09 10:10:00\",\"22030\",\"VA\",\"fairfax-city\",\"homeowner\",\"above_4\",\"6.1\",\"basement\",\"quoted\",\"2300\",\"\",\"sub-slab\",\"planning\",\"three@example.com\",\"private note\",\"127.0.0.3\",\"JUnit\"",
                ""));

        mockMvc.perform(get("/radon-quote-ledger"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Fairfax City, VA")))
                .andExpect(content().string(containsString("$1,900-$2,300")))
                .andExpect(content().string(containsString("$2,100")))
                .andExpect(content().string(containsString("Early benchmark")));

        String publicCsv = mockMvc.perform(get("/radon-quote-ledger/benchmark.csv"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("\"Fairfax City, VA\"")))
                .andExpect(content().string(containsString("\"$1,900-$2,300\"")))
                .andReturn()
                .getResponse()
                .getContentAsString();

        assertFalse(publicCsv.contains("one@example.com"), "Public CSV should not expose submitter emails.");
        assertFalse(publicCsv.contains("127.0.0.1"), "Public CSV should not expose IP addresses.");
        assertFalse(publicCsv.contains("private note"), "Public CSV should not expose freeform notes.");
        assertFalse(publicCsv.contains("JUnit"), "Public CSV should not expose user agents.");

        mockMvc.perform(get("/radon-mitigation-cost/virginia/fairfax-city"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Observed local signals")))
                .andExpect(content().string(containsString("Quote ledger context for Fairfax")))
                .andExpect(content().string(containsString("$1,900-$2,300")))
                .andExpect(content().string(containsString("3 total, 3 priced")));
    }

    @Test
    void quoteLedgerMergesRealLeadPlanningSignalsAndFiltersQaLeads() throws Exception {
        Files.writeString(LEADS_CSV_PATH, String.join(System.lineSeparator(),
                "Date,Name,Phone,Email,Zip,State,County,Foundation,Tested,Intent,ResultBand,ContactPriority,LeadScore,LeadTier,NextAction",
                "\"2026-07-09 09:00:00\",\"QA Radon\",\"5551234567\",\"qa+radon@example.com\",\"22030\",\"VA\",\"fairfax-city\",\"basement\",\"true\",\"buying\",\"above_4\",\"this_week\",\"80\",\"HOT\",\"Call\"",
                "\"2026-07-09 09:05:00\",\"Real Intake\",\"2024440199\",\"owner@radonlead.invalid\",\"22030\",\"VA\",\"fairfax-city\",\"basement\",\"true\",\"buying\",\"above_4\",\"this_week\",\"80\",\"HOT\",\"Call\"",
                ""));

        mockMvc.perform(get("/radon-quote-ledger"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Lead-derived signals")))
                .andExpect(content().string(containsString("Fairfax City, VA")))
                .andExpect(content().string(containsString("1 total, 0 priced")))
                .andExpect(content().string(containsString("Hidden until 3 priced signals")));

        String publicCsv = mockMvc.perform(get("/radon-quote-ledger/benchmark.csv"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("\"Fairfax City, VA\"")))
                .andExpect(content().string(containsString("Need 3 more priced signals")))
                .andReturn()
                .getResponse()
                .getContentAsString();

        assertFalse(publicCsv.contains("Real Intake"), "Public CSV should not expose lead names.");
        assertFalse(publicCsv.contains("2024440199"), "Public CSV should not expose lead phone numbers.");
        assertFalse(publicCsv.contains("owner@radonlead.invalid"), "Public CSV should not expose lead emails.");
        assertFalse(publicCsv.contains("qa+radon@example.com"), "QA leads should not be merged into the public benchmark.");
    }
}
