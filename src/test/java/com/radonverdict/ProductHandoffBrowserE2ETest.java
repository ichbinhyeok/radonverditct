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
import java.util.concurrent.atomic.AtomicReference;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT, properties = {
        "app.site.enforce-canonical-host=false",
        "app.product.legacy-surfaces-enabled=false"
})
@TestInstance(TestInstance.Lifecycle.PER_CLASS)
class ProductHandoffBrowserE2ETest {
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
    void mobileUserCanBuildAndShareAnImmutablePlan() {
        try (BrowserContext context = browser.newContext(new Browser.NewContextOptions()
                .setViewportSize(390, 844)); Page page = context.newPage()) {
            AtomicReference<String> blockedBy = new AtomicReference<>("");
            page.onResponse(response -> {
                if (response.url().endsWith("/plan/share")) {
                    String marker = response.headerValue("x-radonverdict-blocked-by");
                    blockedBy.set(marker == null ? "" : marker);
                }
            });
            page.navigate(baseUrl() + "/");
            page.getByLabel("Radon result").fill("5.8");
            page.getByLabel("ZIP code").fill("22030");
            page.getByRole(com.microsoft.playwright.options.AriaRole.BUTTON,
                    new Page.GetByRoleOptions().setName("Build my next step")).click();
            page.waitForURL(url -> url.contains("/plan"));
            assertTrue(page.getByText("At or above the EPA action level").isVisible());

            page.getByRole(com.microsoft.playwright.options.AriaRole.BUTTON,
                    new Page.GetByRoleOptions().setName("Create private share link")).click();
            assertTrue(page.url().matches(".*/plan/share/[A-Za-z0-9_-]{43}$"),
                    () -> "Expected private share redirect, got " + page.url() + " blockedBy=" + blockedBy.get()
                            + "\n" + page.locator("body").innerText());
            assertTrue(page.getByText("Private read-only handoff").isVisible());
            assertFalse(page.locator("body").innerText().contains("22030"));
            assertTrue(page.getByRole(com.microsoft.playwright.options.AriaRole.BUTTON,
                    new Page.GetByRoleOptions().setName("Copy private link")).isVisible());
        }
    }

    private String baseUrl() {
        return "http://127.0.0.1:" + port;
    }
}
