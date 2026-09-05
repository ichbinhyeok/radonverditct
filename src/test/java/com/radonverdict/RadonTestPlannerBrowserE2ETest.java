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
class RadonTestPlannerBrowserE2ETest {
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
    void mobileUserCanCreateAndResumeAProcedureRecord() {
        try (BrowserContext context = browser.newContext(new Browser.NewContextOptions()
                .setViewportSize(390, 844)); Page page = context.newPage()) {
            page.navigate(baseUrl() + "/radon-test-planner");
            assertTrue(page.getByText("Where are you in the test?").isVisible());

            page.locator("label:has(input[name=stage][value=finished])").click();
            continueStep(page);
            page.locator("label:has(input[name=purpose][value=first])").click();
            continueStep(page);
            page.locator("label:has(input[name=device][value=short])").click();
            continueStep(page);

            page.locator("select[name=level]").selectOption("basement");
            page.locator("select[name=room]").selectOption("living");
            page.locator("input[name=zip]").fill("22030");
            page.locator("label:has(input[name=placementInstructions][value=yes])").click();
            continueStep(page);

            page.locator("input[name=durationHours]").fill("72");
            page.locator("label:has(input[name=closedHouse][value=yes])").click();
            page.locator("label:has(input[name=disturbed][value=no])").click();
            continueStep(page);

            page.locator("input[name=result]").fill("3.8");
            page.getByRole(com.microsoft.playwright.options.AriaRole.BUTTON,
                    new Page.GetByRoleOptions().setName("Create my record")).click();

            assertTrue(page.getByText("The procedure is internally consistent").isVisible());
            assertTrue(page.getByText("3.8 pCi/L").isVisible());
            assertTrue(page.getByRole(com.microsoft.playwright.options.AriaRole.BUTTON,
                    new Page.GetByRoleOptions().setName("Print or save as PDF")).isVisible());
            assertEquals("Saved locally", page.locator("#rv-save-status").textContent());

            page.getByRole(com.microsoft.playwright.options.AriaRole.BUTTON,
                    new Page.GetByRoleOptions().setName("Edit this record")).click();
            page.reload();
            assertEquals("3.8", page.locator("input[name=result]").inputValue());
        }
    }

    @Test
    void datesCalculateDurationAndShortTestBelow48HoursGetsSourceBackedRetestFinding() {
        try (BrowserContext context = browser.newContext(); Page page = context.newPage()) {
            openFreshPlanner(page);
            completeThroughPlacement(page, "first", "short");
            page.locator("input[name=startDate]").fill("2026-09-01T12:00");
            page.locator("input[name=endDate]").fill("2026-09-03T11:00");
            assertEquals("47", page.locator("input[name=durationHours]").inputValue());
            chooseConditionsAndCreate(page, "yes", "no");

            assertTrue(page.getByText("Retest may be needed").isVisible());
            assertTrue(page.getByText("less than 48 hours").isVisible());
            assertTrue(page.getByRole(com.microsoft.playwright.options.AriaRole.LINK,
                    new Page.GetByRoleOptions().setName("Centers for Disease Control and Prevention")).first().isVisible());
        }
    }

    @Test
    void closedHouseRuleIsScopedToRealEstateTransactions() {
        try (BrowserContext context = browser.newContext(); Page page = context.newPage()) {
            openFreshPlanner(page);
            completeThroughPlacement(page, "first", "short");
            page.locator("input[name=durationHours]").fill("72");
            chooseConditionsAndCreate(page, "no", "no");
            assertTrue(page.getByText("The procedure is internally consistent").isVisible());

            openFreshPlanner(page);
            completeThroughPlacement(page, "transaction", "short");
            page.locator("input[name=durationHours]").fill("72");
            chooseConditionsAndCreate(page, "no", "no");
            assertTrue(page.getByText("The procedure may be compromised").isVisible());
            assertTrue(page.getByText("short-term real-estate test").isVisible());
        }
    }

    @Test
    void longTermTestAt90DaysGetsRetestFinding() {
        try (BrowserContext context = browser.newContext(); Page page = context.newPage()) {
            openFreshPlanner(page);
            completeThroughPlacement(page, "first", "long");
            page.locator("input[name=durationHours]").fill("2160");
            chooseConditionsAndCreate(page, "unsure", "no");
            assertTrue(page.getByText("Retest may be needed").isVisible());
            assertTrue(page.getByText("did not run for more than 90 days").isVisible());
        }
    }

    private void openFreshPlanner(Page page) {
        page.navigate(baseUrl() + "/radon-test-planner");
        page.evaluate("localStorage.clear()");
        page.reload();
        page.locator("#rv-next:not([disabled])").waitFor();
    }

    private void completeThroughPlacement(Page page, String purpose, String device) {
        page.locator("label:has(input[name=stage][value=finished])").click();
        continueStep(page);
        page.locator("label:has(input[name=purpose][value=" + purpose + "])").click();
        continueStep(page);
        page.locator("label:has(input[name=device][value=" + device + "])").click();
        continueStep(page);
        page.locator("select[name=level]").selectOption("basement");
        page.locator("select[name=room]").selectOption("living");
        page.locator("label:has(input[name=placementInstructions][value=yes])").click();
        continueStep(page);
    }

    private void chooseConditionsAndCreate(Page page, String closedHouse, String disturbed) {
        page.locator("label:has(input[name=closedHouse][value=" + closedHouse + "])").click();
        page.locator("label:has(input[name=disturbed][value=" + disturbed + "])").click();
        continueStep(page);
        page.getByRole(com.microsoft.playwright.options.AriaRole.BUTTON,
                new Page.GetByRoleOptions().setName("Create my record")).click();
    }

    private void continueStep(Page page) {
        page.getByRole(com.microsoft.playwright.options.AriaRole.BUTTON,
                new Page.GetByRoleOptions().setName("Continue")).click();
    }

    private String baseUrl() {
        return "http://127.0.0.1:" + port;
    }
}
