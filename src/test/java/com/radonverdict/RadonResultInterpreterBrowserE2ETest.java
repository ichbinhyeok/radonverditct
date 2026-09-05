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
class RadonResultInterpreterBrowserE2ETest {
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
    void firstShortTermResultAtActionLevelRequiresFollowUpInsteadOfSellingAMitigationPlan() {
        try (BrowserContext context = browser.newContext(); Page page = context.newPage()) {
            page.navigate(baseUrl());
            page.locator("#result-reading").fill("5.2");
            page.getByRole(com.microsoft.playwright.options.AriaRole.BUTTON,
                    new Page.GetByRoleOptions().setName("Interpret this record")).click();

            assertTrue(page.locator("#result-next-step").isVisible());
            assertTrue(page.locator("#result-interpretation").textContent().contains("first short-term result"));
            assertTrue(page.locator("#result-action").textContent().contains("Take a second short- or long-term test"));
            assertEquals("/guides/when-to-retest-for-radon", page.locator("#result-primary-link").getAttribute("href"));
        }
    }

    @Test
    void twoShortTermResultsUseTheirAverage() {
        try (BrowserContext context = browser.newContext(); Page page = context.newPage()) {
            page.navigate(baseUrl());
            page.locator("input[value='second-short']").check();
            assertTrue(page.locator("#second-reading-field").isVisible());
            page.locator("#result-reading").fill("5.0");
            page.locator("#result-second-reading").fill("3.0");
            page.getByRole(com.microsoft.playwright.options.AriaRole.BUTTON,
                    new Page.GetByRoleOptions().setName("Interpret this record")).click();

            assertTrue(page.locator("#result-value-summary").textContent().contains("4.0 pCi/L average"));
            assertTrue(page.locator("#result-action").textContent().contains("licensed radon-reduction professional"));
        }
    }

    @Test
    void uncertainProcedureStopsCleanClassificationOnMobile() {
        try (BrowserContext context = browser.newContext(new Browser.NewContextOptions()
                .setViewportSize(390, 844)); Page page = context.newPage()) {
            page.navigate(baseUrl());
            page.locator("#result-reading").fill("8.4");
            page.locator("#result-procedure").selectOption("concern");
            page.getByRole(com.microsoft.playwright.options.AriaRole.BUTTON,
                    new Page.GetByRoleOptions().setName("Interpret this record")).click();

            assertTrue(page.locator("#result-interpretation").textContent()
                    .contains("does not support a clean next-step classification"));
            assertEquals("/guides/is-my-radon-test-valid", page.locator("#result-primary-link").getAttribute("href"));
            assertEquals(0, ((Number) page.evaluate(
                    "document.documentElement.scrollWidth - document.documentElement.clientWidth")).intValue());
        }
    }

    private String baseUrl() {
        return "http://127.0.0.1:" + port + "/radon-test-result-meaning";
    }
}
