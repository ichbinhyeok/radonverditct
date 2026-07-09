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
import java.util.ArrayList;
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

    private record LayoutRoute(String label, String path) {
    }

    private record ViewportCase(String label, int width, int height, boolean mobile) {
    }

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
            assertTrue(page.locator("text=Do not hire from a blind reading").first().isVisible());
        }
    }

    @Test
    void criticalEntryAndSeoPagesAvoidOverflowAndMobileZipCtaOverlap() {
        List<LayoutRoute> routes = List.of(
                new LayoutRoute("cost-calculator", "/radon-cost-calculator"),
                new LayoutRoute("credit-calculator", "/radon-credit-calculator"),
                new LayoutRoute("levels-root", "/radon-levels"),
                new LayoutRoute("levels-state", "/radon-levels/california"),
                new LayoutRoute("levels-county", "/radon-levels/california/los-angeles-county"),
                new LayoutRoute("levels-colorado", "/radon-levels/colorado"),
                new LayoutRoute("levels-colorado-county", "/radon-levels/colorado/boulder-county"),
                new LayoutRoute("levels-illinois", "/radon-levels/illinois"),
                new LayoutRoute("levels-illinois-county", "/radon-levels/illinois/dupage-county"),
                new LayoutRoute("levels-iowa-county", "/radon-levels/iowa/polk-county"),
                new LayoutRoute("levels-north-carolina-county", "/radon-levels/north-carolina/wake-county"),
                new LayoutRoute("levels-pennsylvania", "/radon-levels/pennsylvania"),
                new LayoutRoute("levels-pennsylvania-county", "/radon-levels/pennsylvania/northampton-county"),
                new LayoutRoute("levels-utah-county", "/radon-levels/utah/salt-lake-county"),
                new LayoutRoute("levels-virginia-county", "/radon-levels/virginia/fairfax-county"),
                new LayoutRoute("cost-root", "/radon-mitigation-cost"),
                new LayoutRoute("cost-state", "/radon-mitigation-cost/california"),
                new LayoutRoute("cost-county", "/radon-mitigation-cost/california/los-angeles-county"),
                new LayoutRoute("credit-county", "/radon-credit-calculator/california/los-angeles-county?intent=buying&radonResultBand=above_4"),
                new LayoutRoute("testing-guide", "/guides/how-to-test-for-radon"),
                new LayoutRoute("quote-checklist-guide", "/guides/radon-mitigation-quote-checklist"),
                new LayoutRoute("seller-credit-guide", "/guides/radon-seller-credit-worksheet"));

        List<ViewportCase> viewports = List.of(
                new ViewportCase("mobile-390", 390, 844, true),
                new ViewportCase("narrow-320", 320, 760, true),
                new ViewportCase("desktop-1440", 1440, 1200, false));

        List<String> failures = new ArrayList<>();

        for (ViewportCase viewport : viewports) {
            try (BrowserContext context = browser.newContext(new Browser.NewContextOptions()
                    .setViewportSize(viewport.width(), viewport.height()))) {
                context.setDefaultTimeout(30_000);
                context.setDefaultNavigationTimeout(30_000);
                Page page = context.newPage();
                List<String> firstPartyFailures = new ArrayList<>();
                List<String> pageErrors = new ArrayList<>();

                context.onRequestFailed(request -> {
                    if (request.url().startsWith(baseUrl())) {
                        firstPartyFailures.add("REQUEST_FAILED " + request.method() + " " + request.url()
                                + " => " + request.failure());
                    }
                });
                context.onResponse(response -> {
                    if (response.url().startsWith(baseUrl()) && response.status() >= 500) {
                        firstPartyFailures.add("HTTP_" + response.status() + " " + response.url());
                    }
                });
                page.onPageError(pageErrors::add);

                for (LayoutRoute route : routes) {
                    Response response = page.navigate(baseUrl() + route.path());
                    page.waitForLoadState(LoadState.DOMCONTENTLOADED);
                    page.waitForTimeout(700);

                    if (response == null || response.status() >= 400) {
                        failures.add(viewport.label() + " " + route.path() + " returned "
                                + (response == null ? "no response" : response.status()));
                        continue;
                    }

                    Map<String, Object> viewportReport = viewportReport(page);
                    if ((Boolean) viewportReport.get("documentOverflow")) {
                        failures.add(viewport.label() + " " + route.path()
                                + " has horizontal overflow: " + viewportReport);
                    }

                    List<Map<String, Object>> clippedInteractiveElements = clippedInteractiveReport(page);
                    if (!clippedInteractiveElements.isEmpty()) {
                        failures.add(viewport.label() + " " + route.path()
                                + " has clipped interactive elements: " + clippedInteractiveElements);
                    }

                    if (viewport.mobile()) {
                        List<Map<String, Object>> zipOverlaps = mobileZipCtaOverlapReport(page);
                        if (!zipOverlaps.isEmpty()) {
                            failures.add(viewport.label() + " " + route.path()
                                    + " has ZIP input/button overlap: " + zipOverlaps);
                        }

                        List<Map<String, Object>> clippedZipPlaceholders = mobileZipPlaceholderFitReport(page);
                        if (!clippedZipPlaceholders.isEmpty()) {
                            failures.add(viewport.label() + " " + route.path()
                                    + " has clipped ZIP placeholder text: " + clippedZipPlaceholders);
                        }

                        List<Map<String, Object>> oversizedStickyCtas = oversizedMobileStickyCtaReport(page);
                        if (!oversizedStickyCtas.isEmpty()) {
                            failures.add(viewport.label() + " " + route.path()
                                    + " has oversized mobile sticky CTA: " + oversizedStickyCtas);
                        }

                        List<Map<String, Object>> quickReadStickyOverlaps = levelsQuickReadStickyOverlapReport(page);
                        if (!quickReadStickyOverlaps.isEmpty()) {
                            failures.add(viewport.label() + " " + route.path()
                                    + " has levels quick read/sticky CTA overlap: " + quickReadStickyOverlaps);
                        }
                    }

                    page.screenshot(new Page.ScreenshotOptions()
                            .setPath(artifactDir.resolve("critical-" + viewport.label() + "-" + route.label() + ".png"))
                            .setFullPage(false));
                }

                failures.addAll(firstPartyFailures);
                failures.addAll(pageErrors);
            }
        }

        assertTrue(failures.isEmpty(), String.join(System.lineSeparator(), failures));
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
    private List<Map<String, Object>> clippedInteractiveReport(Page page) {
        return (List<Map<String, Object>>) page.evaluate("""
                () => {
                  const viewportWidth = window.innerWidth;
                  const viewportHeight = window.innerHeight;
                  const interactiveSelector = [
                    'a[href]',
                    'button',
                    'input',
                    'select',
                    'textarea',
                    'label'
                  ].join(',');

                  return Array.from(document.querySelectorAll(interactiveSelector))
                    .filter((element) => {
                      const style = window.getComputedStyle(element);
                      if (style.display === 'none' || style.visibility === 'hidden' || style.opacity === '0') {
                        return false;
                      }
                      const rect = element.getBoundingClientRect();
                      return rect.width > 0 && rect.height > 0
                        && rect.bottom > 0
                        && rect.top < viewportHeight;
                    })
                    .filter((element) => {
                      const rect = element.getBoundingClientRect();
                      return rect.left < -1 || rect.right > viewportWidth + 1 || rect.width > viewportWidth + 1;
                    })
                    .slice(0, 12)
                    .map((element) => {
                      const rect = element.getBoundingClientRect();
                      return {
                        tag: element.tagName,
                        className: element.className ? String(element.className).slice(0, 120) : '',
                        text: (element.innerText || element.value || element.getAttribute('aria-label') || '')
                          .replace(/\\s+/g, ' ')
                          .trim()
                          .slice(0, 80),
                        left: Math.round(rect.left),
                        right: Math.round(rect.right),
                        width: Math.round(rect.width)
                      };
                    });
                }
                """);
    }

    @SuppressWarnings("unchecked")
    private List<Map<String, Object>> mobileZipCtaOverlapReport(Page page) {
        return (List<Map<String, Object>>) page.evaluate("""
                () => {
                  function visible(element) {
                    if (!element) {
                      return false;
                    }
                    const style = window.getComputedStyle(element);
                    const rect = element.getBoundingClientRect();
                    return style.display !== 'none'
                      && style.visibility !== 'hidden'
                      && rect.width > 0
                      && rect.height > 0;
                  }

                  function overlaps(first, second) {
                    return first.left < second.right
                      && first.right > second.left
                      && first.top < second.bottom
                      && first.bottom > second.top;
                  }

                  return Array.from(document.querySelectorAll('form'))
                    .flatMap((form) => {
                      const input = form.querySelector("input[name='zipCode']");
                      const button = form.querySelector("button[type='submit'], button:not([type])");
                      if (!visible(input) || !visible(button)) {
                        return [];
                      }

                      const inputRect = input.getBoundingClientRect();
                      const buttonRect = button.getBoundingClientRect();
                      if (!overlaps(inputRect, buttonRect)) {
                        return [];
                      }

                      return [{
                        inputPlaceholder: input.getAttribute('placeholder') || '',
                        buttonText: (button.innerText || '').replace(/\\s+/g, ' ').trim(),
                        input: {
                          left: Math.round(inputRect.left),
                          top: Math.round(inputRect.top),
                          right: Math.round(inputRect.right),
                          bottom: Math.round(inputRect.bottom)
                        },
                        button: {
                          left: Math.round(buttonRect.left),
                          top: Math.round(buttonRect.top),
                          right: Math.round(buttonRect.right),
                          bottom: Math.round(buttonRect.bottom)
                        }
                      }];
                    })
                    .slice(0, 8);
                }
                """);
    }

    @SuppressWarnings("unchecked")
    private List<Map<String, Object>> mobileZipPlaceholderFitReport(Page page) {
        return (List<Map<String, Object>>) page.evaluate("""
                () => {
                  function visible(element) {
                    if (!element) {
                      return false;
                    }
                    const style = window.getComputedStyle(element);
                    const rect = element.getBoundingClientRect();
                    return style.display !== 'none'
                      && style.visibility !== 'hidden'
                      && rect.width > 0
                      && rect.height > 0;
                  }

                  const canvas = document.createElement('canvas');
                  const context = canvas.getContext('2d');
                  return Array.from(document.querySelectorAll("input[name='zipCode'][placeholder]"))
                    .filter(visible)
                    .flatMap((input) => {
                      const style = window.getComputedStyle(input);
                      context.font = style.font;
                      const placeholder = input.getAttribute('placeholder') || '';
                      const availableWidth = input.clientWidth
                        - parseFloat(style.paddingLeft || '0')
                        - parseFloat(style.paddingRight || '0');
                      const placeholderWidth = context.measureText(placeholder).width;
                      if (placeholderWidth <= availableWidth + 2) {
                        return [];
                      }
                      const rect = input.getBoundingClientRect();
                      return [{
                        placeholder,
                        availableWidth: Math.round(availableWidth),
                        placeholderWidth: Math.ceil(placeholderWidth),
                        inputWidth: Math.round(rect.width),
                        font: style.font
                      }];
                    })
                    .slice(0, 8);
                }
                """);
    }

    @SuppressWarnings("unchecked")
    private List<Map<String, Object>> oversizedMobileStickyCtaReport(Page page) {
        return (List<Map<String, Object>>) page.evaluate("""
                () => {
                  const viewportHeight = window.innerHeight;
                  return Array.from(document.querySelectorAll('.mobile-sticky-cta'))
                    .filter((element) => {
                      const style = window.getComputedStyle(element);
                      const rect = element.getBoundingClientRect();
                      const text = (element.innerText || '').replace(/\\s+/g, ' ').trim();
                      return style.display !== 'none'
                        && style.visibility !== 'hidden'
                        && rect.width > 0
                        && rect.height > 0
                        && text === 'Pick My Next Step'
                        && (rect.height > 64 || rect.height / viewportHeight > 0.09);
                    })
                    .map((element) => {
                      const rect = element.getBoundingClientRect();
                      return {
                        text: (element.innerText || '').replace(/\\s+/g, ' ').trim().slice(0, 80),
                        top: Math.round(rect.top),
                        bottom: Math.round(rect.bottom),
                        height: Math.round(rect.height),
                        viewportHeight
                      };
                    });
                }
                """);
    }

    @SuppressWarnings("unchecked")
    private List<Map<String, Object>> levelsQuickReadStickyOverlapReport(Page page) {
        return (List<Map<String, Object>>) page.evaluate("""
                () => {
                  function visible(element) {
                    if (!element) {
                      return false;
                    }
                    const style = window.getComputedStyle(element);
                    const rect = element.getBoundingClientRect();
                    return style.display !== 'none'
                      && style.visibility !== 'hidden'
                      && rect.width > 0
                      && rect.height > 0;
                  }

                  function overlaps(first, second) {
                    return first.left < second.right
                      && first.right > second.left
                      && first.top < second.bottom
                      && first.bottom > second.top;
                  }

                  const quickRead = document.querySelector('.levels-county-hero-quick-read');
                  const sticky = Array.from(document.querySelectorAll('.mobile-sticky-cta'))
                    .find((element) => (element.innerText || '').replace(/\\s+/g, ' ').trim() === 'Pick My Next Step');
                  if (!visible(quickRead) || !visible(sticky)) {
                    return [];
                  }

                  const quickReadRect = quickRead.getBoundingClientRect();
                  const stickyRect = sticky.getBoundingClientRect();
                  if (!overlaps(quickReadRect, stickyRect)) {
                    return [];
                  }

                  return [{
                    quickReadTop: Math.round(quickReadRect.top),
                    quickReadBottom: Math.round(quickReadRect.bottom),
                    stickyTop: Math.round(stickyRect.top),
                    stickyBottom: Math.round(stickyRect.bottom)
                  }];
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
