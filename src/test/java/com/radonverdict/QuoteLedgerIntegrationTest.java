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
        "app.storage.quote-ledger-csv-path=build/tmp/quote-ledger/quote_ledger.csv"
})
@AutoConfigureMockMvc
class QuoteLedgerIntegrationTest {

    private static final Path QUOTE_LEDGER_CSV_PATH = Paths.get("build", "tmp", "quote-ledger", "quote_ledger.csv");

    @Autowired
    private MockMvc mockMvc;

    @BeforeEach
    void beforeEach() throws Exception {
        Files.createDirectories(QUOTE_LEDGER_CSV_PATH.getParent());
        Files.deleteIfExists(QUOTE_LEDGER_CSV_PATH);
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
}
