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
import org.springframework.boot.test.web.server.LocalServerPort;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

@SpringBootTest(
        webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT,
        properties = {
                "app.site.enforce-canonical-host=false",
                "app.site.base-url=http://127.0.0.1"
        })
@TestInstance(TestInstance.Lifecycle.PER_CLASS)
class PlaywrightResponsiveLayoutE2ETest {

    @LocalServerPort
    private int port;

    private Playwright playwright;
    private Browser browser;
    private Path artifactDir;

    @BeforeAll
    void beforeAll() throws IOException {
        artifactDir = Paths.get("build", "reports", "playwright-responsive-layout");
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
    void levelsCountyPageStaysReadableWithoutHorizontalOverflowOnMobile() {
        try (BrowserContext context = browser.newContext(new Browser.NewContextOptions()
                .setViewportSize(390, 844))) {
            Page page = context.newPage();
            page.navigate(baseUrl() + "/radon-levels/california/los-angeles-county");
            page.waitForLoadState(LoadState.DOMCONTENTLOADED);
            page.waitForTimeout(800);

            Map<String, Object> report = viewportReport(page);
            double viewportWidth = ((Number) report.get("viewportWidth")).doubleValue();
            boolean documentOverflow = (Boolean) report.get("documentOverflow");

            Locator heroTitle = page.locator("h1").first();
            Locator situationPicker = page.locator("#situation-picker");
            Locator mobileSticky = page.locator(".mobile-sticky-cta");

            assertTrue(heroTitle.isVisible());
            assertTrue(situationPicker.isVisible());
            assertTrue(mobileSticky.isVisible());

            page.screenshot(new Page.ScreenshotOptions()
                    .setPath(artifactDir.resolve("levels-mobile-top.png")));
            page.evaluate("window.scrollTo(0, 720)");
            page.waitForTimeout(250);
            page.screenshot(new Page.ScreenshotOptions()
                    .setPath(artifactDir.resolve("levels-mobile-scroll-1.png")));
            page.evaluate("window.scrollTo(0, 1440)");
            page.waitForTimeout(250);
            page.screenshot(new Page.ScreenshotOptions()
                    .setPath(artifactDir.resolve("levels-mobile-scroll-2.png")));

            Map<String, Object> titleBox = box(page, "h1");
            assertNotNull(titleBox, "Expected hero title to have a bounding box.");
            double titleLeft = ((Number) titleBox.get("x")).doubleValue();
            double titleWidth = ((Number) titleBox.get("width")).doubleValue();
            double titleRight = titleLeft + titleWidth;

            assertFalse(documentOverflow, "Horizontal overflow detected: " + report);
            assertTrue(titleLeft >= -1, "Hero title starts off-screen: " + titleBox);
            assertTrue(titleRight <= viewportWidth + 1, "Hero title extends past mobile viewport: " + titleBox);
        }
    }

    @Test
    void levelsCountyPageStaysReadableOnNarrowMobileWidths() {
        try (BrowserContext context = browser.newContext(new Browser.NewContextOptions()
                .setViewportSize(320, 760))) {
            Page page = context.newPage();
            page.navigate(baseUrl() + "/radon-levels/california/los-angeles-county");
            page.waitForLoadState(LoadState.DOMCONTENTLOADED);
            page.waitForTimeout(800);

            Map<String, Object> report = viewportReport(page);
            double viewportWidth = ((Number) report.get("viewportWidth")).doubleValue();
            Map<String, Object> titleBox = box(page, "h1");

            page.screenshot(new Page.ScreenshotOptions()
                    .setPath(artifactDir.resolve("levels-mobile-320-top.png")));

            assertNotNull(titleBox, "Expected hero title to have a bounding box on narrow mobile.");
            assertFalse((Boolean) report.get("documentOverflow"), "Narrow mobile horizontal overflow detected: " + report);
            assertTrue(((Number) titleBox.get("x")).doubleValue() >= -1, "Narrow mobile hero title starts off-screen: " + titleBox);
            assertTrue(((Number) titleBox.get("x")).doubleValue() + ((Number) titleBox.get("width")).doubleValue() <= viewportWidth + 1,
                    "Narrow mobile hero title extends past viewport: " + titleBox);
        }
    }

    @Test
    void levelsCountyPageKeepsBalancedHeroAndSituationPickerOnDesktop() {
        try (BrowserContext context = browser.newContext(new Browser.NewContextOptions()
                .setViewportSize(1440, 1200))) {
            Page page = context.newPage();
            page.navigate(baseUrl() + "/radon-levels/california/los-angeles-county");
            page.waitForLoadState(LoadState.DOMCONTENTLOADED);
            page.waitForTimeout(800);

            page.screenshot(new Page.ScreenshotOptions()
                    .setPath(artifactDir.resolve("levels-desktop-top.png")));

            Map<String, Object> report = viewportReport(page);
            assertFalse((Boolean) report.get("documentOverflow"), "Desktop horizontal overflow detected: " + report);
            assertTrue(page.locator("text=Pick the situation that matches you").first().isVisible());
            assertTrue(page.locator("text=Treat the map as a hint, not the answer").first().isVisible());
        }
    }

    @SuppressWarnings("unchecked")
    private Map<String, Object> viewportReport(Page page) {
        return (Map<String, Object>) page.evaluate("""
                () => {
                  const viewportWidth = window.innerWidth;
                  const viewportHeight = window.innerHeight;
                  const root = document.documentElement;
                  const offenders = [];

                  document.querySelectorAll('body *').forEach((element) => {
                    const style = window.getComputedStyle(element);
                    if (style.display === 'none' || style.position === 'fixed') {
                      return;
                    }

                    const rect = element.getBoundingClientRect();
                    if (rect.width <= 0 || rect.height <= 0) {
                      return;
                    }

                    if (rect.left < -1 || rect.right > viewportWidth + 1 || rect.width > viewportWidth + 1) {
                      offenders.push({
                        tag: element.tagName,
                        className: element.className ? String(element.className).slice(0, 120) : '',
                        text: (element.innerText || element.textContent || '').replace(/\\s+/g, ' ').trim().slice(0, 80),
                        left: Math.round(rect.left),
                        right: Math.round(rect.right),
                        width: Math.round(rect.width)
                      });
                    }
                  });

                  return {
                    viewportWidth,
                    viewportHeight,
                    clientWidth: root.clientWidth,
                    scrollWidth: root.scrollWidth,
                    documentOverflow: root.scrollWidth > root.clientWidth + 1,
                    offenders: offenders.slice(0, 12)
                  };
                }
                """);
    }

    @SuppressWarnings("unchecked")
    private Map<String, Object> box(Page page, String selector) {
        return (Map<String, Object>) page.evaluate("""
                (targetSelector) => {
                  const element = document.querySelector(targetSelector);
                  if (!element) {
                    return null;
                  }
                  const rect = element.getBoundingClientRect();
                  return {
                    x: rect.x,
                    y: rect.y,
                    width: rect.width,
                    height: rect.height
                  };
                }
                """, selector);
    }

    private String baseUrl() {
        return "http://127.0.0.1:" + port;
    }
}
