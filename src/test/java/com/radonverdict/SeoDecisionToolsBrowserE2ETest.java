package com.radonverdict;

import com.microsoft.playwright.Browser;
import com.microsoft.playwright.BrowserContext;
import com.microsoft.playwright.BrowserType;
import com.microsoft.playwright.Page;
import com.microsoft.playwright.Playwright;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestInstance;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.server.LocalServerPort;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT, properties = {
        "app.site.enforce-canonical-host=false",
        "app.product.legacy-surfaces-enabled=false"
})
@TestInstance(TestInstance.Lifecycle.PER_CLASS)
class SeoDecisionToolsBrowserE2ETest {
    @LocalServerPort int port;
    private Playwright playwright;
    private Browser browser;

    @BeforeAll
    void startBrowser() {
        playwright = Playwright.create();
        browser = playwright.chromium().launch(new BrowserType.LaunchOptions()
                .setHeadless(true)
                .setArgs(List.of("--disable-dev-shm-usage")));
    }

    @AfterAll
    void stopBrowser() {
        if (browser != null) browser.close();
        if (playwright != null) playwright.close();
    }

    @Test
    void durationToolCalculatesExposureAndReportDates() {
        try (BrowserContext context = browser.newContext(); Page page = context.newPage()) {
            page.navigate(baseUrl() + "/guides/short-term-vs-long-term-radon-test");
            page.locator("#timeline-start").fill("2026-09-05T09:00");
            page.locator("#timeline-exposure-hours").fill("48");
            page.locator("#timeline-transit-days").fill("2");
            page.locator("#timeline-lab-days").fill("3");
            page.getByRole(com.microsoft.playwright.options.AriaRole.BUTTON,
                    new Page.GetByRoleOptions().setName("Calculate the timeline")).click();

            assertTrue(page.locator("#radon-result-timeline-output").isVisible());
            assertEquals("7 calendar days from start", page.locator("#timeline-total-result").textContent());
        }
    }

    @Test
    void manometerToolRefusesToTurnGaugeStatusIntoARadonLevel() {
        try (BrowserContext context = browser.newContext(); Page page = context.newPage()) {
            page.navigate(baseUrl() + "/guides/radon-manometer-reading");
            page.locator("#manometer-baseline").selectOption("known");
            page.locator("#manometer-current").selectOption("level");
            page.getByRole(com.microsoft.playwright.options.AriaRole.BUTTON,
                    new Page.GetByRoleOptions().setName("Create the observation record")).click();

            assertTrue(page.locator("#manometer-baseline-output").isVisible());
            assertTrue(page.locator("#manometer-record-result").textContent()
                    .contains("Do not infer the indoor radon level"));
        }
    }

    @Test
    void fanNoiseToolEscalatesSafetyFlagsOnMobile() {
        try (BrowserContext context = browser.newContext(new Browser.NewContextOptions()
                .setViewportSize(390, 844)); Page page = context.newPage()) {
            page.navigate(baseUrl() + "/guides/radon-fan-noise");
            page.locator("#fan-noise-indicator").selectOption("alarm");
            page.locator("input[value='electrical concern']").check();
            page.getByRole(com.microsoft.playwright.options.AriaRole.BUTTON,
                    new Page.GetByRoleOptions().setName("Create the service note")).click();

            assertTrue(page.locator("#fan-noise-observation-output").isVisible());
            assertTrue(page.locator("#fan-noise-next-step").textContent()
                    .contains("contact the installer or an appropriately qualified professional"));
            assertEquals(0, ((Number) page.evaluate("document.documentElement.scrollWidth - document.documentElement.clientWidth")).intValue());
        }
    }

    @Test
    void everySupportGuideTurnsItsUniqueChecklistIntoAReviewableRecord() {
        try (BrowserContext context = browser.newContext(new Browser.NewContextOptions()
                .setViewportSize(390, 844)); Page page = context.newPage()) {
            page.navigate(baseUrl() + "/guides/radon-test-moved-or-tampered");
            var checks = page.locator(".protocol-record-check");
            assertTrue(checks.count() >= 5);
            checks.nth(0).check();
            checks.nth(1).check();
            page.locator("#protocol-record-notes").fill("Monitor was moved from the original room at 14:30.");
            page.getByRole(com.microsoft.playwright.options.AriaRole.BUTTON,
                    new Page.GetByRoleOptions().setName("Create a copyable summary")).click();

            assertEquals("2 of " + checks.count() + " confirmed", page.locator("#protocol-record-progress").textContent());
            assertTrue(page.locator("#protocol-record-output").isVisible());
            String recordSummary = page.locator("#protocol-record-summary").textContent();
            assertTrue(recordSummary.contains("What If a Radon Test Was Moved or Tampered With?"));
            assertTrue(recordSummary.contains("[confirmed]"));
            assertTrue(recordSummary.contains("[verify]"));
            assertTrue(recordSummary.contains("Monitor was moved from the original room at 14:30."));
            assertEquals(0, ((Number) page.evaluate("document.documentElement.scrollWidth - document.documentElement.clientWidth")).intValue());
        }
    }

    private String baseUrl() {
        return "http://127.0.0.1:" + port;
    }
}
