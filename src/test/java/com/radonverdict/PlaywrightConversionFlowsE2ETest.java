package com.radonverdict;

import com.microsoft.playwright.Browser;
import com.microsoft.playwright.BrowserContext;
import com.microsoft.playwright.BrowserType;
import com.microsoft.playwright.Locator;
import com.microsoft.playwright.Page;
import com.microsoft.playwright.Playwright;
import com.microsoft.playwright.options.LoadState;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestInstance;
import org.springframework.boot.test.context.SpringBootTest;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.Duration;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.function.BooleanSupplier;

import static org.junit.jupiter.api.Assertions.assertTrue;

@SpringBootTest(
        webEnvironment = SpringBootTest.WebEnvironment.DEFINED_PORT,
        properties = {
                "app.site.enforce-canonical-host=false",
                "server.port=50991",
                "app.site.base-url=http://127.0.0.1:50991",
                "app.feature.leads.enabled=true",
                "app.feature.monetization-hooks.enabled=true",
                "app.storage.leads-csv-path=build/tmp/playwright-conversion/leads.csv",
                "app.storage.telemetry-csv-path=build/tmp/playwright-conversion/telemetry_events.csv"
        })
@TestInstance(TestInstance.Lifecycle.PER_CLASS)
class PlaywrightConversionFlowsE2ETest {
    private static final String LOCAL_BASE_URL = "http://127.0.0.1:50991";

    private Playwright playwright;
    private Browser browser;
    private Path artifactDir;

    @BeforeAll
    void beforeAll() throws IOException {
        artifactDir = Paths.get("build", "reports", "playwright-conversion");
        Files.createDirectories(artifactDir);

        playwright = Playwright.create();
        browser = playwright.chromium().launch(new BrowserType.LaunchOptions()
                .setHeadless(true)
                .setArgs(List.of("--disable-dev-shm-usage")));
    }

    @AfterAll
    void afterAll() {
        if (browser != null) {
            browser.close();
        }
        if (playwright != null) {
            playwright.close();
        }
    }

    @Test
    void globalActionPlanCalculatorCarriesScenarioIntoCountyFlow() {
        try (PersonaSession persona = openPersona("global_action_plan_prefill")) {
            persona.visit("/radon-cost-calculator");

            assertTrue(persona.page.locator("h1").first().innerText().contains("Radon Action Plan"));

            persona.page.locator("label[data-track-label='result-above_4']").first().click();
            persona.page.locator("label[data-track-label='intent-buying']").first().click();
            persona.page.locator("input[name='zipCode']").fill("22030");
            persona.page.locator("form[action='/search-zip']")
                    .evaluate("form => form.submit()");
            waitUntil(() -> persona.page.content().contains("4.0+ Action Plan for Buyers"),
                    Duration.ofSeconds(10));
            persona.page.waitForLoadState(LoadState.DOMCONTENTLOADED);

            assertTrue(persona.page.content().contains("Fairfax, VA"));
            assertTrue(persona.page.locator("text=4.0+ Action Plan for Buyers").first().isVisible());
            assertTrue(persona.page.locator("button:has-text('Send My Credit Strategy')").first().isVisible());

            persona.screenshot("county_action_plan_buying_above_4");
            persona.assertNoFirstPartyFailures();
        }
    }

    @Test
    void globalCreditCalculatorZipFlowOpensLocalCreditCalculator() {
        try (PersonaSession persona = openPersona("global_credit_zip_flow")) {
            persona.visit("/radon-credit-calculator");

            assertTrue(persona.page.locator("h1").first().innerText().contains("Radon Seller Credit Calculator"));

            persona.page.locator("label[data-track-label='intent-buying']").first().click();
            persona.page.locator("label[data-track-label='result-above_4']").first().click();
            persona.page.locator("input[name='zipCode']").fill("22030");
            persona.page.locator("form[action='/search-zip-credit']")
                    .evaluate("form => form.submit()");
            waitUntil(() -> persona.page.content().contains("Opening ask"),
                    Duration.ofSeconds(10));
            persona.page.waitForLoadState(LoadState.DOMCONTENTLOADED);

            assertTrue(persona.page.content().contains("Fairfax, VA"));
            assertTrue(persona.page.locator("h1").first().innerText().contains("Buyer Radon Credit Calculator for Fairfax, VA"));
            assertTrue(persona.page.locator("text=Opening ask").first().isVisible());
            assertTrue(persona.page.locator("text=Open Seller Credit Worksheet").first().isVisible());

            persona.screenshot("credit_calculator_fairfax_city");
            persona.assertNoFirstPartyFailures();
        }
    }

    @Test
    void levelsBuyerSellerPathOpensLocalCreditCalculator() {
        try (PersonaSession persona = openPersona("levels_to_credit_calculator")) {
            persona.visit("/radon-levels/virginia/fairfax-city");

            assertTrue(persona.page.locator("a[data-track-label='buyer_seller_path']").first().isVisible());

            persona.page.locator("a[data-track-label='buyer_seller_path']").first().click();
            persona.page.waitForURL("**/radon-credit-calculator/virginia/fairfax-city?radonResultBand=above_4&intent=buying");
            persona.page.waitForLoadState(LoadState.DOMCONTENTLOADED);

            assertTrue(persona.page.locator("h1").first().innerText().contains("Buyer Radon Credit Calculator for Fairfax, VA"));
            assertTrue(persona.page.locator("text=Opening ask").first().isVisible());

            persona.screenshot("levels_buyer_seller_path");
            persona.assertNoFirstPartyFailures();
        }
    }

    @Test
    void levelsHighResultPathOpensScenarioSpecificActionPlan() {
        try (PersonaSession persona = openPersona("levels_to_high_result_action_plan")) {
            persona.visit("/radon-levels/virginia/fairfax-city");

            assertTrue(persona.page.locator("a[data-track-label='high_result']").first().isVisible());

            persona.page.locator("a[data-track-label='high_result']").first().click();
            persona.page.waitForURL("**/radon-mitigation-cost/virginia/fairfax-city?radonResultBand=above_4&intent=homeowner#estimate-form");
            persona.page.waitForLoadState(LoadState.DOMCONTENTLOADED);

            assertTrue(persona.page.content().contains("4.0+ Action Plan for Homeowners"));
            assertTrue(persona.page.locator("button:has-text('Send My 4.0+ Action Plan')").first().isVisible());

            persona.screenshot("levels_high_result_action_plan");
            persona.assertNoFirstPartyFailures();
        }
    }

    private PersonaSession openPersona(String personaName) {
        BrowserContext context = browser.newContext(new Browser.NewContextOptions()
                .setViewportSize(1440, 960)
                .setLocale("en-US"));
        context.setDefaultTimeout(30_000);
        context.setDefaultNavigationTimeout(30_000);

        Page page = context.newPage();
        return new PersonaSession(personaName, context, page);
    }

    private String baseUrl() {
        return LOCAL_BASE_URL;
    }

    private static void waitUntil(BooleanSupplier condition, Duration timeout) {
        Instant deadline = Instant.now().plus(timeout);
        while (Instant.now().isBefore(deadline)) {
            if (condition.getAsBoolean()) {
                return;
            }
            try {
                Thread.sleep(200);
            } catch (InterruptedException interruptedException) {
                Thread.currentThread().interrupt();
                throw new IllegalStateException("Interrupted while waiting for condition", interruptedException);
            }
        }
        throw new IllegalStateException("Condition was not met within timeout " + timeout);
    }

    private final class PersonaSession implements AutoCloseable {
        private final String personaName;
        private final BrowserContext context;
        private final Page page;
        private final List<String> firstPartyFailures = new ArrayList<>();
        private final List<String> pageErrors = new ArrayList<>();

        private PersonaSession(String personaName, BrowserContext context, Page page) {
            this.personaName = personaName;
            this.context = context;
            this.page = page;

            this.context.onRequestFailed(request -> {
                if (request.url().startsWith(baseUrl())) {
                    firstPartyFailures.add("REQUEST_FAILED " + request.method() + " " + request.url()
                            + " => " + request.failure());
                }
            });
            this.context.onResponse(response -> {
                if (response.url().startsWith(baseUrl()) && response.status() >= 500) {
                    firstPartyFailures.add("HTTP_" + response.status() + " " + response.url());
                }
            });
            this.page.onPageError(error -> pageErrors.add(error));
        }

        private void visit(String path) {
            page.navigate(baseUrl() + path);
            page.waitForLoadState(LoadState.DOMCONTENTLOADED);
        }

        private void screenshot(String label) {
            String safe = (personaName + "_" + label).replaceAll("[^a-zA-Z0-9._-]", "_").toLowerCase(Locale.US);
            Path out = artifactDir.resolve(safe + ".png");
            page.screenshot(new Page.ScreenshotOptions()
                    .setPath(out)
                    .setFullPage(true));
        }

        private void assertNoFirstPartyFailures() {
            assertTrue(firstPartyFailures.isEmpty(),
                    "First-party network failures found for " + personaName + ": " + firstPartyFailures);
            assertTrue(pageErrors.isEmpty(),
                    "Client-side runtime errors found for " + personaName + ": " + pageErrors);
        }

        @Override
        public void close() {
            context.close();
        }
    }
}
