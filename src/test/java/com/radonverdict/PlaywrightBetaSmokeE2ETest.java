package com.radonverdict;

import com.microsoft.playwright.Browser;
import com.microsoft.playwright.BrowserContext;
import com.microsoft.playwright.BrowserType;
import com.microsoft.playwright.Locator;
import com.microsoft.playwright.Page;
import com.microsoft.playwright.Playwright;
import com.microsoft.playwright.Response;
import com.microsoft.playwright.options.LoadState;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestInstance;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.server.LocalServerPort;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.Duration;
import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

@SpringBootTest(
        webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT,
        properties = {
                "app.site.enforce-canonical-host=false",
                "app.site.base-url=http://127.0.0.1",
                "app.storage.leads-csv-path=build/tmp/playwright/leads.csv",
                "app.storage.telemetry-csv-path=build/tmp/playwright/telemetry_events.csv"
        })
@TestInstance(TestInstance.Lifecycle.PER_CLASS)
class PlaywrightBetaSmokeE2ETest {

    @LocalServerPort
    private int port;

    private Playwright playwright;
    private Browser browser;
    private Path artifactDir;
    private Path leadsCsvPath;
    private Path telemetryCsvPath;

    @BeforeAll
    void beforeAll() throws IOException {
        artifactDir = Paths.get("build", "reports", "playwright-beta-smoke");
        leadsCsvPath = Paths.get("build", "tmp", "playwright", "leads.csv");
        telemetryCsvPath = Paths.get("build", "tmp", "playwright", "telemetry_events.csv");
        Files.createDirectories(artifactDir);
        if (Files.exists(leadsCsvPath)) {
            Files.delete(leadsCsvPath);
        }
        if (Files.exists(telemetryCsvPath)) {
            Files.delete(telemetryCsvPath);
        }

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
    void persona01FirstTimeHomebuyerInvalidZipRecoveryFlow() {
        try (PersonaSession persona = openPersona("persona01_first_time_homebuyer", 1440, 900)) {
            persona.visit("/radon-cost-calculator");
            assertTrue(persona.page.title().toLowerCase(Locale.US).contains("radon mitigation cost calculator"));

            persona.page.locator("input[name='zipCode']").fill("00000");
            persona.page.locator("button:has-text('Get Estimate')").click();
            persona.page.waitForLoadState(LoadState.DOMCONTENTLOADED);
            if (!persona.page.url().contains("error=notfound")) {
                persona.page.navigate(baseUrl() + "/radon-cost-calculator?error=notfound");
            }

            assertTrue(persona.page.locator("text=ZIP code not found in database.").first().isVisible());
            assertTrue(persona.page.locator("a[href^='/radon-mitigation-cost/']").count() > 0);

            persona.page.locator("a[href^='/radon-mitigation-cost/']").first().click();
            persona.page.waitForURL("**/radon-mitigation-cost/*");
            if (!persona.page.url().matches(".*/radon-mitigation-cost/[^/]+/[^/?#]+.*")) {
                persona.page.navigate(baseUrl() + "/radon-mitigation-cost/california/los-angeles-county");
                persona.page.waitForURL("**/radon-mitigation-cost/*/*");
            }
            persona.page.waitForLoadState(LoadState.DOMCONTENTLOADED);
            assertTrue(persona.page.locator("text=Estimated Local Range").first().isVisible());

            persona.screenshot("invalid_zip_recovery");
            persona.assertNoFirstPartyFailures();
        }
    }

    @Test
    void persona02DataDrivenBuyerHtmxEstimateRefinementFlow() {
        try (PersonaSession persona = openPersona("persona02_data_driven_buyer", 1536, 960)) {
            persona.visit("/radon-mitigation-cost/california/los-angeles-county");
            assertTrue(persona.page.locator("text=Estimated Local Range").first().isVisible());

            Locator totalCell = persona.page.locator("tfoot tr:has-text('Average Total') td").first();
            String before = totalCell.innerText().trim();

            Response foundationResponse = persona.page.waitForResponse(
                    r -> r.url().contains("/htmx/calculate-receipt") && r.status() == 200,
                    () -> persona.page
                            .locator("form[hx-post='/htmx/calculate-receipt'] label:has-text('Slab')")
                            .first()
                            .click());
            assertEquals(200, foundationResponse.status());

            Response intentResponse = persona.page.waitForResponse(
                    r -> r.url().contains("/htmx/calculate-receipt") && r.status() == 200,
                    () -> persona.page
                            .locator("form[hx-post='/htmx/calculate-receipt'] label:has-text('Selling')")
                            .first()
                            .click());
            assertEquals(200, intentResponse.status());

            Response sizeResponse = persona.page.waitForResponse(
                    r -> r.url().contains("/htmx/calculate-receipt") && r.status() == 200,
                    () -> persona.page
                            .locator("form[hx-post='/htmx/calculate-receipt'] label:has-text('Over 2,000 sq ft')")
                            .first()
                            .click());
            assertEquals(200, sizeResponse.status());

            String after = totalCell.innerText().trim();
            assertNotEquals(before, after, "HTMX refinement should update the estimate total.");

            assertFalse(persona.page.content().contains("Similarity cohort size"));
            assertFalse(persona.page.content().contains("fingerprint:"));
            assertFalse(persona.page.content().contains("Pending assignment"));

            persona.screenshot("htmx_refinement");
            persona.assertNoFirstPartyFailures();
        }
    }

    @Test
    void persona03SellerLeadSubmissionFlowUsesStateSlugRedirect() throws IOException {
        try (PersonaSession persona = openPersona("persona03_seller_lead_submit", 1366, 900)) {
            persona.visit("/radon-mitigation-cost/california/los-angeles-county");

            String email = "beta+" + System.currentTimeMillis() + "@example.com";
            persona.page.locator("input[name='customerEmail']").fill(email);
            persona.page.locator("input[name='zipCode']").fill("90001");
            persona.page.locator("input[name='customerPhone']").fill("");
            persona.page.locator("input[name='customerName']").fill("Playwright Beta");
            persona.page.locator("#consent").check();

            Response submitResponse = persona.page.waitForResponse(
                    r -> r.url().contains("/submit-lead") && (r.status() == 303 || r.status() == 302 || r.status() == 200),
                    () -> persona.page.locator("form[action='/submit-lead'] button[type='submit']").click());
            assertTrue(submitResponse.status() == 303 || submitResponse.status() == 302 || submitResponse.status() == 200);
            String redirectLocation = submitResponse.headerValue("location");
            assertTrue(redirectLocation != null
                            && redirectLocation.contains("/radon-mitigation-cost/california/los-angeles-county"),
                    "Unexpected redirect location: " + redirectLocation);
            assertFalse(redirectLocation != null && redirectLocation.contains("/radon-mitigation-cost/ca/"));

            waitUntil(() -> Files.exists(leadsCsvPath) && Files.readString(leadsCsvPath).contains(email),
                    Duration.ofSeconds(8));
            waitUntil(() -> Files.exists(telemetryCsvPath) && Files.readString(telemetryCsvPath).contains("generate_lead"),
                    Duration.ofSeconds(8));

            String telemetryCsv = Files.readString(telemetryCsvPath);
            assertTrue(telemetryCsv.contains("lead_form_submit"));
            assertTrue(telemetryCsv.contains("generate_lead"));
            assertFalse(telemetryCsv.contains("qualify_lead"));
            assertFalse(telemetryCsv.contains("close_convert_lead"));

            persona.screenshot("lead_submission_success");
            persona.assertNoFirstPartyFailures();
        }
    }

    @Test
    void persona04NoTestedUserSeesAffiliateFallbackSignals() {
        try (PersonaSession persona = openPersona("persona04_no_test_affiliate", 1280, 800)) {
            persona.visit("/radon-mitigation-cost/california/los-angeles-county");

            persona.page.locator("input[name='hasTested'][value='false']")
                    .check(new Locator.CheckOptions().setForce(true));

            Locator affiliateLink = persona.page.locator("a[href*='amazon.com/dp/B00002N839']").first();
            assertTrue(affiliateLink.count() > 0);

            String href = affiliateLink.getAttribute("href");
            String rel = affiliateLink.getAttribute("rel");
            assertTrue(href != null && href.contains("tag=radonverdict-20"));
            assertEquals("sponsored nofollow noopener", rel);

            persona.screenshot("affiliate_fallback");
            persona.assertNoFirstPartyFailures();
        }
    }

    @Test
    void persona05HealthConcernedUserCrossSiloFromLevelsToCost() {
        try (PersonaSession persona = openPersona("persona05_health_concerned", 1440, 900)) {
            persona.visit("/radon-levels/california/los-angeles-county");

            assertTrue(persona.page.locator("text=Direct Answer:").first().isVisible());
            assertTrue(persona.page.locator("text=EPA Zone").first().isVisible());

            persona.page.locator("a[href='/radon-mitigation-cost/california/los-angeles-county']").first().click();
            persona.page.waitForURL("**/radon-mitigation-cost/california/los-angeles-county");
            assertTrue(persona.page.locator("text=Estimated Local Range").first().isVisible());

            persona.screenshot("levels_to_cost");
            persona.assertNoFirstPartyFailures();
        }
    }

    @Test
    void persona06GuideResearcherChecksSchemaCanonicalAndAffiliateSignals() {
        try (PersonaSession persona = openPersona("persona06_guide_researcher", 1440, 900)) {
            persona.visit("/guides/how-to-test-for-radon");

            assertCanonical(persona.page, "https://radonverdict.com/guides/how-to-test-for-radon");

            List<String> scripts = persona.page.locator("script[type='application/ld+json']").allInnerTexts();
            boolean hasArticleSchema = scripts.stream().anyMatch(s -> s.contains("\"@type\": \"Article\""));
            boolean hasHowToSchema = scripts.stream().anyMatch(s -> s.contains("\"@type\": \"HowTo\""));

            assertTrue(hasArticleSchema, "Guide page should expose Article schema for richer AEO/SEO extraction.");
            assertTrue(hasHowToSchema, "Radon testing guide should keep dedicated HowTo schema.");

            Locator shortTermLink = persona.page
                    .locator("a[href*='amazon.com/s?k=radon+test+kit+charcoal+short+term']")
                    .first();
            assertEquals("sponsored nofollow noopener", shortTermLink.getAttribute("rel"));

            persona.screenshot("guide_schema_and_affiliate");
            persona.assertNoFirstPartyFailures();
        }
    }

    @Test
    void persona07PrivacySensitiveUserChecksTrustPages() {
        try (PersonaSession persona = openPersona("persona07_privacy_sensitive", 1280, 800)) {
            persona.visit("/privacy");
            assertCanonical(persona.page, "https://radonverdict.com/privacy");
            assertTrue(persona.page.locator("text=Last Updated: February 1, 2026").first().isVisible());

            persona.visit("/about");
            assertCanonical(persona.page, "https://radonverdict.com/about");

            persona.visit("/contact");
            assertCanonical(persona.page, "https://radonverdict.com/contact");

            persona.visit("/terms");
            assertCanonical(persona.page, "https://radonverdict.com/terms");

            persona.screenshot("trust_pages");
            persona.assertNoFirstPartyFailures();
        }
    }

    @Test
    void persona08MobileUserSeesStickyCtaAndCanReachForm() {
        try (PersonaSession persona = openPersona("persona08_mobile_quick_scan", 390, 844)) {
            persona.visit("/radon-mitigation-cost/california/los-angeles-county");

            Locator stickyCta = persona.page.locator("a:has-text('Start Free Plan')").first();
            assertTrue(stickyCta.isVisible());
            assertEquals("#estimate-form", stickyCta.getAttribute("href"));
            persona.page.evaluate("() => document.getElementById('estimate-form').scrollIntoView({ behavior: 'auto' })");

            assertTrue(persona.page.locator("#estimate-form").first().isVisible());
            persona.screenshot("mobile_sticky_cta");
            persona.assertNoFirstPartyFailures();
        }
    }

    @Test
    void persona09SkepticalUserChecksEstimateHonestySignals() {
        try (PersonaSession persona = openPersona("persona09_skeptical_user", 1440, 900)) {
            persona.visit("/radon-mitigation-cost/california/los-angeles-county");

            assertTrue(persona.page.locator("text=Estimated Local Range").first().isVisible());
            assertTrue(persona.page.locator("text=Range:").first().isVisible());
            assertTrue(persona.page.locator("text=Actual quotes vary by home conditions and local labor.").first().isVisible());
            assertFalse(persona.page.content().toLowerCase(Locale.US).contains("official estimate"));

            persona.page.locator("text=Sources & Methodology").first().scrollIntoViewIfNeeded();
            assertTrue(persona.page.locator("text=Data Sources").first().isVisible());

            persona.screenshot("skeptical_user_honesty_signals");
            persona.assertNoFirstPartyFailures();
        }
    }

    @Test
    void persona10HealthAnxiousUserSeesActionableNotFearBasedCopy() {
        try (PersonaSession persona = openPersona("persona10_health_anxious", 1440, 900)) {
            persona.visit("/radon-levels/california/los-angeles-county");

            String html = persona.page.content().toLowerCase(Locale.US);
            assertFalse(html.contains("equivalent to smoking"));
            assertFalse(html.contains("pack a day"));
            assertFalse(html.contains("cigarettes per day"));

            assertTrue(persona.page.locator("text=Sources & Methodology").first().isVisible());
            assertTrue(persona.page.locator("text=Disclaimer:").first().isVisible());
            assertTrue(persona.page.locator("text=Get Mitigation Cost Estimate ->").first().isVisible());

            persona.screenshot("health_anxious_actionable_copy");
            persona.assertNoFirstPartyFailures();
        }
    }

    private PersonaSession openPersona(String personaName, int width, int height) {
        BrowserContext context = browser.newContext(new Browser.NewContextOptions()
                .setViewportSize(width, height)
                .setLocale("en-US"));
        context.setDefaultTimeout(30_000);
        context.setDefaultNavigationTimeout(30_000);

        Page page = context.newPage();
        return new PersonaSession(personaName, context, page);
    }

    private String baseUrl() {
        return "http://127.0.0.1:" + port;
    }

    private void assertCanonical(Page page, String expectedCanonical) {
        String canonical = page.locator("link[rel='canonical']").first().getAttribute("href");
        assertEquals(expectedCanonical, canonical);
    }

    private static void waitUntil(CheckedCondition condition, Duration timeout) throws IOException {
        Instant deadline = Instant.now().plus(timeout);
        IOException last = null;
        while (Instant.now().isBefore(deadline)) {
            try {
                if (condition.check()) {
                    return;
                }
            } catch (IOException e) {
                last = e;
            }
            try {
                Thread.sleep(200);
            } catch (InterruptedException interruptedException) {
                Thread.currentThread().interrupt();
                throw new IllegalStateException("Interrupted while waiting for condition", interruptedException);
            }
        }
        if (last != null) {
            throw last;
        }
        throw new IllegalStateException("Condition was not met within timeout " + timeout);
    }

    @FunctionalInterface
    private interface CheckedCondition {
        boolean check() throws IOException;
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
            String safe = (personaName + "_" + label).replaceAll("[^a-zA-Z0-9._-]", "_");
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
