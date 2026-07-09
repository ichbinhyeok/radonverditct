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
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Base64;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.regex.Pattern;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

@SpringBootTest(
        webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT,
        properties = {
                "app.site.enforce-canonical-host=false",
                "app.site.base-url=http://127.0.0.1",
                "app.feature.leads.enabled=true",
                "app.feature.monetization-hooks.enabled=true",
                "app.storage.leads-csv-path=build/tmp/playwright-hundred-user/leads.csv",
                "app.storage.telemetry-csv-path=build/tmp/playwright-hundred-user/telemetry_events.csv",
                "app.storage.contact-csv-path=build/tmp/playwright-hundred-user/contact_messages.csv",
                "app.storage.quote-ledger-csv-path=build/tmp/playwright-hundred-user/quote_ledger.csv",
                "spring.jpa.show-sql=false"
        })
@TestInstance(TestInstance.Lifecycle.PER_CLASS)
class PlaywrightHundredUserAuditE2ETest {

    private static final Pattern BAD_VISIBLE_COPY = Pattern.compile(
            "(?i)(\\bundefined\\b|\\bNaN\\b|At\\s+pCi/L|At\\s+NaN\\s+pCi/L|\\$\\s*NaN|\\$\\s*null)");

    private static final Set<String> GENERIC_KEYWORD_TOKENS = Set.of(
            "radon", "county", "cost", "costs", "level", "levels", "guide", "near", "with",
            "from", "home", "testing", "test", "services", "mitigation", "system", "calculator");

    @LocalServerPort
    private int port;

    private Playwright playwright;
    private Browser browser;
    private Path artifactDir;
    private Path tmpDir;

    private enum UserAction {
        SCAN,
        ZIP_COST_SEARCH,
        ZIP_CREDIT_SEARCH,
        LEVELS_TO_COST,
        HTMX_RECEIPT,
        QUOTE_CHECKER,
        QUOTE_LEDGER_SUBMIT,
        LEAD_SUBMIT,
        CONTACT_SUBMIT,
        MOBILE_NAV,
        ADMIN_SCAN
    }

    private record ViewportCase(String label, int width, int height, boolean mobile) {
    }

    private record RoutePlan(String keyword, String path, UserAction action, String value) {
    }

    private record UserScenario(
            int id,
            String keyword,
            String path,
            ViewportCase viewport,
            UserAction action,
            String value) {
    }

    private record ScenarioResult(
            int id,
            String keyword,
            String path,
            String finalUrl,
            String viewport,
            UserAction action,
            int status,
            String title,
            List<String> failures,
            List<String> warnings,
            String screenshot) {
    }

    @BeforeAll
    void beforeAll() throws IOException {
        artifactDir = Paths.get("build", "reports", "playwright-hundred-user-audit");
        tmpDir = Paths.get("build", "tmp", "playwright-hundred-user");
        Files.createDirectories(artifactDir);
        Files.createDirectories(tmpDir);
        deleteIfExists(tmpDir.resolve("leads.csv"));
        deleteIfExists(tmpDir.resolve("telemetry_events.csv"));
        deleteIfExists(tmpDir.resolve("contact_messages.csv"));
        deleteIfExists(tmpDir.resolve("quote_ledger.csv"));

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
    void oneHundredSearchIntentUsersCanReadActAndMoveAcrossPageTypes() throws IOException {
        List<UserScenario> scenarios = buildScenarios();
        assertEquals(100, scenarios.size(), "Audit must run exactly 100 user scenarios.");

        List<ScenarioResult> results = new ArrayList<>();
        List<String> criticalFailures = new ArrayList<>();

        for (UserScenario scenario : scenarios) {
            ScenarioResult result = runScenario(scenario);
            results.add(result);
            result.failures().forEach(failure -> criticalFailures.add("S" + scenario.id() + " " + failure));
        }

        writeReports(results, criticalFailures);

        assertTrue(criticalFailures.isEmpty(),
                "100-user browser audit found critical failures. See " + artifactDir.resolve("audit-summary.md"));
    }

    private ScenarioResult runScenario(UserScenario scenario) {
        List<String> failures = new ArrayList<>();
        List<String> warnings = new ArrayList<>();
        List<String> firstPartyFailures = new ArrayList<>();
        List<String> pageErrors = new ArrayList<>();
        List<String> consoleErrors = new ArrayList<>();

        Browser.NewContextOptions contextOptions = new Browser.NewContextOptions()
                .setViewportSize(scenario.viewport().width(), scenario.viewport().height())
                .setLocale("en-US");

        try (BrowserContext context = browser.newContext(contextOptions)) {
            context.setDefaultTimeout(30_000);
            context.setDefaultNavigationTimeout(30_000);
            if (scenario.action() == UserAction.ADMIN_SCAN) {
                String token = Base64.getEncoder()
                        .encodeToString("admin:tlsgur3108".getBytes(StandardCharsets.UTF_8));
                context.setExtraHTTPHeaders(Map.of("Authorization", "Basic " + token));
            }

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

            Page page = context.newPage();
            page.setDefaultTimeout(8_000);
            page.setDefaultNavigationTimeout(15_000);
            page.onPageError(pageErrors::add);
            page.onConsoleMessage(message -> {
                if ("error".equalsIgnoreCase(message.type())
                        && !message.text().contains("Failed to load resource")
                        && !message.text().contains("net::ERR_BLOCKED_BY_CLIENT")
                        && !isThirdPartyFontCorsNoise(message.text())) {
                    consoleErrors.add(message.text());
                }
            });

            Response response = page.navigate(baseUrl() + scenario.path());
            page.waitForLoadState(LoadState.DOMCONTENTLOADED);
            page.waitForTimeout(450);

            int status = response == null ? 0 : response.status();
            if (response == null || response.status() >= 400) {
                failures.add(scenario.path() + " returned " + status);
            }

            inspectPage(page, scenario, failures, warnings);
            performUserAction(page, scenario, failures, warnings);
            page.waitForLoadState(LoadState.DOMCONTENTLOADED);
            page.waitForTimeout(250);
            inspectPage(page, scenario, failures, warnings);

            failures.addAll(firstPartyFailures);
            failures.addAll(pageErrors.stream().map(error -> "PAGE_ERROR " + error).toList());
            warnings.addAll(consoleErrors.stream().map(error -> "CONSOLE_ERROR " + error).toList());

            page.waitForTimeout(450);
            if (!hasReadableViewportText(page)) {
                failures.add(scenario.path() + " has no readable text painted in the final screenshot viewport");
            }
            String screenshot = screenshot(page, scenario);
            return new ScenarioResult(
                    scenario.id(),
                    scenario.keyword(),
                    scenario.path(),
                    page.url(),
                    scenario.viewport().label(),
                    scenario.action(),
                    status,
                    safeTitle(page),
                    List.copyOf(failures),
                    List.copyOf(warnings),
                    screenshot);
        } catch (RuntimeException e) {
            failures.add("EXCEPTION " + e.getClass().getSimpleName() + ": " + e.getMessage());
            return new ScenarioResult(
                    scenario.id(),
                    scenario.keyword(),
                    scenario.path(),
                    "",
                    scenario.viewport().label(),
                    scenario.action(),
                    0,
                    "",
                    List.copyOf(failures),
                    List.copyOf(warnings),
                    "");
        }
    }

    @SuppressWarnings("unchecked")
    private void inspectPage(Page page, UserScenario scenario, List<String> failures, List<String> warnings) {
        String title = safeTitle(page);
        if (title.isBlank()) {
            failures.add(scenario.path() + " has blank title");
        }

        String bodyText = "";
        try {
            bodyText = page.locator("body").innerText().replaceAll("\\s+", " ").trim();
        } catch (RuntimeException e) {
            failures.add(scenario.path() + " body text could not be read: " + e.getMessage());
        }

        if (bodyText.length() < 260 && !scenario.path().endsWith(".xml")) {
            failures.add(scenario.path() + " has thin or blank visible body text (" + bodyText.length() + " chars)");
        }
        if (BAD_VISIBLE_COPY.matcher(bodyText).find()) {
            failures.add(scenario.path() + " exposes placeholder/broken visible copy near: "
                    + excerptAroundBadCopy(bodyText));
        }
        if (bodyText.contains("Whitelabel Error Page")
                || bodyText.contains("This application has no explicit mapping for /error")) {
            failures.add(scenario.path() + " rendered Spring error page copy");
        }

        int h1Count = page.locator("h1").count();
        if (h1Count == 0 && !scenario.path().endsWith(".xml")) {
            failures.add(scenario.path() + " has no visible h1");
        }

        Map<String, Object> viewportReport = (Map<String, Object>) page.evaluate("""
                () => {
                  const root = document.documentElement;
                  const viewportWidth = window.innerWidth;
                  const offenders = [];
                  document.querySelectorAll('body *').forEach((element) => {
                    const style = window.getComputedStyle(element);
                    if (style.display === 'none' || style.visibility === 'hidden' || style.position === 'fixed') {
                      return;
                    }
                    const rect = element.getBoundingClientRect();
                    if (rect.width <= 0 || rect.height <= 0) {
                      return;
                    }
                    if (rect.left < -1 || rect.right > viewportWidth + 1 || rect.width > viewportWidth + 1) {
                      offenders.push({
                        tag: element.tagName,
                        className: element.className ? String(element.className).slice(0, 80) : '',
                        text: (element.innerText || element.textContent || '').replace(/\\s+/g, ' ').trim().slice(0, 80),
                        left: Math.round(rect.left),
                        right: Math.round(rect.right),
                        width: Math.round(rect.width)
                      });
                    }
                  });
                  return {
                    clientWidth: root.clientWidth,
                    scrollWidth: root.scrollWidth,
                    documentOverflow: root.scrollWidth > root.clientWidth + 1,
                    offenders: offenders.slice(0, 10)
                  };
                }
                """);
        if (Boolean.TRUE.equals(viewportReport.get("documentOverflow"))) {
            failures.add(scenario.path() + " has horizontal overflow: " + viewportReport);
        }

        List<Map<String, Object>> clippedControls = (List<Map<String, Object>>) page.evaluate("""
                () => {
                  const viewportWidth = window.innerWidth;
                  const viewportHeight = window.innerHeight;
                  return Array.from(document.querySelectorAll(
                    'a.tap-target-inline, a.inline-flex, button, input, select, textarea, [role="button"]'
                  ))
                    .filter((element) => {
                      const style = window.getComputedStyle(element);
                      const rect = element.getBoundingClientRect();
                      if (element.classList.contains('sr-only')) {
                        return false;
                      }
                      return style.display !== 'none'
                        && style.visibility !== 'hidden'
                        && rect.width > 0
                        && rect.height > 0
                        && rect.bottom > 0
                        && rect.top < viewportHeight;
                    })
                    .filter((element) => {
                      const rect = element.getBoundingClientRect();
                      return rect.left < -1 || rect.right > viewportWidth + 1 || rect.width > viewportWidth + 1;
                    })
                    .slice(0, 10)
                    .map((element) => {
                      const rect = element.getBoundingClientRect();
                      return {
                        tag: element.tagName,
                        className: element.className ? String(element.className).slice(0, 80) : '',
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
        if (!clippedControls.isEmpty()) {
            failures.add(scenario.path() + " has clipped visible controls: " + clippedControls);
        }

        List<Map<String, Object>> visibleViewportText = (List<Map<String, Object>>) page.evaluate("""
                () => Array.from(document.querySelectorAll('h1, h2, p, a, button, label, input, select, textarea'))
                  .filter((element) => {
                    const style = window.getComputedStyle(element);
                    const rect = element.getBoundingClientRect();
                    const text = (element.innerText || element.value || element.getAttribute('placeholder') || element.getAttribute('aria-label') || '')
                      .replace(/\\s+/g, ' ')
                      .trim();
                    return text.length >= 2
                      && style.display !== 'none'
                      && style.visibility !== 'hidden'
                      && Number(style.opacity || '1') > 0
                      && rect.width > 0
                      && rect.height > 0
                      && rect.bottom > 0
                      && rect.right > 0
                      && rect.top < window.innerHeight
                      && rect.left < window.innerWidth;
                  })
                  .slice(0, 6)
                  .map((element) => {
                    const rect = element.getBoundingClientRect();
                    return {
                      tag: element.tagName,
                      text: (element.innerText || element.value || element.getAttribute('placeholder') || element.getAttribute('aria-label') || '')
                        .replace(/\\s+/g, ' ')
                        .trim()
                        .slice(0, 80),
                      top: Math.round(rect.top),
                      left: Math.round(rect.left),
                      width: Math.round(rect.width),
                      height: Math.round(rect.height)
                    };
                  })
                """);
        if (visibleViewportText.isEmpty()) {
            failures.add(scenario.path() + " has no readable text painted inside the current viewport");
        }

        if (scenario.viewport().mobile()) {
            List<Map<String, Object>> tinyControls = (List<Map<String, Object>>) page.evaluate("""
                    () => {
                      const viewportHeight = window.innerHeight;
                      return Array.from(document.querySelectorAll(
                        'button, input, select, textarea, a.inline-flex, a.tap-target, a.tap-target-inline'
                      ))
                        .filter((element) => {
                          const style = window.getComputedStyle(element);
                          const rect = element.getBoundingClientRect();
                          if (element.classList.contains('sr-only')) {
                            return false;
                          }
                          if ((element.type === 'checkbox' || element.type === 'radio')
                              && rect.width >= 18
                              && rect.height >= 18) {
                            return false;
                          }
                          return style.display !== 'none'
                            && style.visibility !== 'hidden'
                            && rect.width > 0
                            && rect.height > 0
                            && rect.bottom > 0
                            && rect.top < viewportHeight
                            && (rect.width < 36 || rect.height < 36);
                        })
                        .slice(0, 8)
                        .map((element) => {
                          const rect = element.getBoundingClientRect();
                          return {
                            tag: element.tagName,
                            text: (element.innerText || element.value || element.getAttribute('aria-label') || '')
                              .replace(/\\s+/g, ' ')
                              .trim()
                              .slice(0, 60),
                            width: Math.round(rect.width),
                            height: Math.round(rect.height)
                          };
                        });
                    }
                    """);
            if (!tinyControls.isEmpty()) {
                warnings.add(scenario.path() + " has small mobile controls: " + tinyControls);
            }
        }

        keywordFitWarning(scenario.keyword(), title + " " + bodyText)
                .ifPresent(warnings::add);
    }

    private void performUserAction(Page page, UserScenario scenario, List<String> failures, List<String> warnings) {
        switch (scenario.action()) {
            case SCAN -> scanPage(page);
            case ZIP_COST_SEARCH -> submitZipCost(page, scenario, failures);
            case ZIP_CREDIT_SEARCH -> submitZipCredit(page, scenario, failures);
            case LEVELS_TO_COST -> clickLevelsToCost(page, scenario, failures);
            case HTMX_RECEIPT -> changeReceiptInputs(page, scenario, failures);
            case QUOTE_CHECKER -> useQuoteChecker(page, scenario, failures);
            case QUOTE_LEDGER_SUBMIT -> submitQuoteLedger(page, scenario, failures);
            case LEAD_SUBMIT -> submitLead(page, scenario, failures);
            case CONTACT_SUBMIT -> submitContact(page, scenario, failures);
            case MOBILE_NAV -> openMobileNav(page, scenario, failures, warnings);
            case ADMIN_SCAN -> scanPage(page);
        }
    }

    private void scanPage(Page page) {
        page.evaluate("() => window.scrollTo(0, Math.min(document.body.scrollHeight * 0.45, 1800))");
        page.waitForTimeout(120);
        page.evaluate("() => window.scrollTo(0, document.body.scrollHeight)");
        page.waitForTimeout(120);
        page.evaluate("() => window.scrollTo(0, 0)");
    }

    private void submitZipCost(Page page, UserScenario scenario, List<String> failures) {
        String zip = scenario.value() == null ? "22030" : scenario.value();
        Locator input = page.locator("form[action='/search-zip'] input[name='zipCode']").first();
        if (input.count() == 0) {
            failures.add(scenario.path() + " ZIP cost form missing");
            return;
        }
        input.fill(zip);
        page.locator("form[action='/search-zip']").first().evaluate("form => form.submit()");
        page.waitForURL("**/radon-mitigation-cost/**");
        if (!page.url().contains("/radon-mitigation-cost/")) {
            failures.add(scenario.path() + " ZIP cost search did not route to county cost page: " + page.url());
        }
        if (page.locator("text=Estimated Local Range").first().count() == 0) {
            failures.add(scenario.path() + " ZIP cost result missing local range");
        }
    }

    private void submitZipCredit(Page page, UserScenario scenario, List<String> failures) {
        String zip = scenario.value() == null ? "22030" : scenario.value();
        Locator input = page.locator("form[action='/search-zip-credit'] input[name='zipCode']").first();
        if (input.count() == 0) {
            failures.add(scenario.path() + " ZIP credit form missing");
            return;
        }
        input.fill(zip);
        page.locator("form[action='/search-zip-credit']").first().evaluate("form => form.submit()");
        page.waitForURL("**/radon-credit-calculator/**");
        if (!page.url().contains("/radon-credit-calculator/")) {
            failures.add(scenario.path() + " ZIP credit search did not route to local credit page: " + page.url());
        }
        if (page.locator("text=Opening ask").first().count() == 0) {
            failures.add(scenario.path() + " ZIP credit result missing negotiation output");
        }
    }

    private void clickLevelsToCost(Page page, UserScenario scenario, List<String> failures) {
        Locator costLink = page.locator("a[href^='/radon-mitigation-cost/']").first();
        if (costLink.count() == 0) {
            failures.add(scenario.path() + " has no cost path from levels page");
            return;
        }
        costLink.click();
        page.waitForURL("**/radon-mitigation-cost/**");
        if (page.locator("text=Estimated Local Range").first().count() == 0) {
            failures.add(scenario.path() + " levels-to-cost click landed without local range: " + page.url());
        }
    }

    private void changeReceiptInputs(Page page, UserScenario scenario, List<String> failures) {
        Locator form = page.locator("form[hx-post='/htmx/calculate-receipt']").first();
        if (form.count() == 0) {
            failures.add(scenario.path() + " missing HTMX receipt form");
            return;
        }

        String before = averageTotal(page);
        if (before.isBlank()) {
            failures.add(scenario.path() + " HTMX receipt missing Average Total before interaction");
            return;
        }
        String currentFoundation = page.locator("form[hx-post='/htmx/calculate-receipt'] input[name='foundation']:checked")
                .first()
                .getAttribute("value");
        String nextFoundation = "crawlspace".equals(currentFoundation) ? "slab" : "crawlspace";
        Locator foundationChoice = page.locator(
                        "form[hx-post='/htmx/calculate-receipt'] label:has(input[name='foundation'][value='" + nextFoundation + "'])")
                .first();
        if (foundationChoice.count() == 0) {
            failures.add(scenario.path() + " missing alternate HTMX foundation option from " + currentFoundation);
            return;
        }

        Locator finalFoundationChoice = foundationChoice;
        Response response = page.waitForResponse(
                r -> r.url().contains("/htmx/calculate-receipt") && r.status() == 200,
                finalFoundationChoice::click);
        if (response.status() != 200) {
            failures.add(scenario.path() + " HTMX receipt returned " + response.status());
        }
        try {
            page.waitForFunction("""
                    (before) => {
                      const rows = Array.from(document.querySelectorAll("tfoot tr"));
                      const averageRow = rows.find((row) => (row.innerText || '').includes('Average Total'));
                      const cell = averageRow ? averageRow.querySelector("td") : null;
                      return cell && cell.innerText.trim() !== before;
                    }
                    """, before);
        } catch (RuntimeException ignored) {
            // The assertion below records the scenario with the exact page path.
        }
        String after = averageTotal(page);
        if (before.equals(after)) {
            failures.add(scenario.path() + " HTMX receipt did not change estimate total");
        }
    }

    private String averageTotal(Page page) {
        Object value = page.evaluate("""
                () => {
                  const rows = Array.from(document.querySelectorAll("tfoot tr"));
                  const averageRow = rows.find((row) => (row.innerText || '').includes('Average Total'));
                  const cell = averageRow ? averageRow.querySelector("td") : null;
                  return cell ? cell.innerText.trim() : '';
                }
                """);
        return value == null ? "" : value.toString().trim();
    }

    private void useQuoteChecker(Page page, UserScenario scenario, List<String> failures) {
        if (page.locator("[data-quote-checker]").count() == 0) {
            failures.add(scenario.path() + " quote checker missing");
            return;
        }
        page.locator("#quoteCheckerPrice").fill(scenario.value() == null ? "650" : scenario.value());
        page.locator("#quoteCheckerFoundation").selectOption("crawlspace");
        page.locator("#quoteCheckerResult").selectOption("above_8");
        String verdict = page.locator("[data-quote-verdict-title]").innerText().trim();
        if (verdict.equals("Enter a quote to compare the scope.") || verdict.isBlank()) {
            failures.add(scenario.path() + " quote checker did not update verdict");
        }
        if (page.locator("[data-quote-verdict-list] li").count() == 0) {
            failures.add(scenario.path() + " quote checker did not produce scope questions");
        }
    }

    private void submitQuoteLedger(Page page, UserScenario scenario, List<String> failures) {
        if (page.locator("#quoteLedgerForm").count() == 0) {
            failures.add(scenario.path() + " quote ledger form missing");
            return;
        }

        page.locator("#ledgerZipCode").fill("22030");
        page.locator("#ledgerRadonReading").fill("4.2");
        page.locator("#ledgerQuotedPrice").fill("2100");
        page.locator("#ledgerScope").fill("sub-slab with sump seal");
        page.locator("#ledgerTimeline").fill("inspection deadline");
        page.locator("input[name='consentAccepted']").check();
        page.locator("#quoteLedgerForm button[type='submit']").click();
        page.waitForURL("**/radon-quote-ledger");
        if (!page.content().contains("Saved. Your anonymized quote signal")) {
            failures.add(scenario.path() + " quote ledger submit did not show saved message");
        }
    }

    private void submitLead(Page page, UserScenario scenario, List<String> failures) {
        if (page.locator("form[action='/submit-lead']").count() == 0) {
            failures.add(scenario.path() + " lead form missing");
            return;
        }
        page.locator("input[name='customerEmail']").fill("audit+" + scenario.id() + "@example.com");
        page.locator("input[name='zipCode']").fill(scenario.value() == null ? "90001" : scenario.value());
        page.locator("input[name='customerName']").fill("Hundred User Audit");
        page.locator("#consent").check();
        page.locator("form[action='/submit-lead'] button[type='submit']").click();
        page.waitForURL("**/radon-mitigation-cost/**");
        if (!page.content().contains("Thank you. We saved your scenario")) {
            failures.add(scenario.path() + " lead submit did not show success message");
        }
    }

    private void submitContact(Page page, UserScenario scenario, List<String> failures) {
        if (page.locator("form[action='/contact']").count() == 0) {
            failures.add(scenario.path() + " contact form missing");
            return;
        }
        page.locator("#name").fill("Hundred User Audit");
        page.locator("#email").fill("audit@example.com");
        page.locator("#message").fill("Testing the contact flow from a user audit.");
        page.locator("form[action='/contact'] button[type='submit']").click();
        page.waitForURL("**/contact");
        if (!page.content().contains("Thanks. Your message was received")) {
            failures.add(scenario.path() + " contact submit did not show success message");
        }
    }

    private void openMobileNav(Page page, UserScenario scenario, List<String> failures, List<String> warnings) {
        if (!scenario.viewport().mobile()) {
            scanPage(page);
            return;
        }

        Locator toggle = page.locator("button[aria-label='Toggle navigation']").first();
        if (toggle.count() == 0) {
            failures.add(scenario.path() + " mobile nav toggle missing");
            return;
        }

        toggle.click();
        page.waitForTimeout(700);
        Locator navPanel = page.locator("#mobile-nav-panel a[href='/radon-quote-ledger']").first();
        if (navPanel.count() == 0 || !navPanel.isVisible()) {
            failures.add(scenario.path() + " mobile nav did not open a visible menu");
            return;
        }
    }

    private boolean isThirdPartyFontCorsNoise(String message) {
        return (message.contains("fonts.gstatic.com") || message.contains("fonts.googleapis.com"))
                && (message.contains("Authorization") || message.contains("CORS"));
    }

    private String screenshot(Page page, UserScenario scenario) {
        String safePath = scenario.path()
                .replaceAll("[^a-zA-Z0-9]+", "-")
                .replaceAll("^-|-$", "");
        if (safePath.isBlank()) {
            safePath = "home";
        }
        String filename = String.format(Locale.US, "s%03d-%s-%s.png",
                scenario.id(), scenario.viewport().label(), safePath);
        Path out = artifactDir.resolve(filename);
        page.screenshot(new Page.ScreenshotOptions()
                .setPath(out)
                .setFullPage(false));
        return out.toString();
    }

    private void writeReports(List<ScenarioResult> results, List<String> criticalFailures) throws IOException {
        StringBuilder markdown = new StringBuilder();
        markdown.append("# 100-User Browser Audit\n\n");
        markdown.append("- Ran at: ").append(Instant.now()).append("\n");
        markdown.append("- Base URL: ").append(baseUrl()).append("\n");
        markdown.append("- Scenarios: ").append(results.size()).append("\n");
        markdown.append("- Critical failures: ").append(criticalFailures.size()).append("\n");
        markdown.append("- Warning count: ").append(results.stream().mapToInt(r -> r.warnings().size()).sum()).append("\n\n");

        markdown.append("## Page-Type Coverage\n\n");
        coverage(results).forEach((key, count) -> markdown.append("- ").append(key).append(": ").append(count).append("\n"));
        markdown.append("\n");

        markdown.append("## Critical Failures\n\n");
        if (criticalFailures.isEmpty()) {
            markdown.append("None.\n\n");
        } else {
            criticalFailures.forEach(failure -> markdown.append("- ").append(failure).append("\n"));
            markdown.append("\n");
        }

        markdown.append("## Warnings\n\n");
        results.stream()
                .filter(result -> !result.warnings().isEmpty())
                .forEach(result -> {
                    markdown.append("### S").append(result.id()).append(" ")
                            .append(result.keyword()).append("\n");
                    result.warnings().forEach(warning -> markdown.append("- ").append(warning).append("\n"));
                });
        markdown.append("\n");

        markdown.append("## Scenario Results\n\n");
        markdown.append("| # | Keyword | Start Path | Final URL | Viewport | Action | Status | Screenshot |\n");
        markdown.append("|---|---|---|---|---|---|---:|---|\n");
        for (ScenarioResult result : results) {
            markdown.append("| ")
                    .append(result.id()).append(" | ")
                    .append(escapeMarkdown(result.keyword())).append(" | ")
                    .append(escapeMarkdown(result.path())).append(" | ")
                    .append(escapeMarkdown(result.finalUrl())).append(" | ")
                    .append(result.viewport()).append(" | ")
                    .append(result.action()).append(" | ")
                    .append(result.status()).append(" | ")
                    .append(escapeMarkdown(result.screenshot())).append(" |\n");
        }

        Files.writeString(artifactDir.resolve("audit-summary.md"), markdown.toString(), StandardCharsets.UTF_8);
        Files.writeString(artifactDir.resolve("audit-results.json"), toJson(results, criticalFailures), StandardCharsets.UTF_8);
    }

    private Map<String, Integer> coverage(List<ScenarioResult> results) {
        Map<String, Integer> coverage = new LinkedHashMap<>();
        for (ScenarioResult result : results) {
            coverage.merge(pageType(result.path()), 1, Integer::sum);
        }
        return coverage;
    }

    private String pageType(String path) {
        if (path == null || path.equals("/")) {
            return "home";
        }
        if (path.startsWith("/radon-levels/") && path.split("/").length >= 4) {
            return "levels_county";
        }
        if (path.startsWith("/radon-levels/")) {
            return "levels_state";
        }
        if (path.equals("/radon-levels")) {
            return "levels_root";
        }
        if (path.startsWith("/radon-mitigation-cost/") && path.split("/").length >= 4) {
            return "cost_county";
        }
        if (path.startsWith("/radon-mitigation-cost/")) {
            return "cost_state";
        }
        if (path.equals("/radon-mitigation-cost")) {
            return "cost_root";
        }
        if (path.startsWith("/radon-credit-calculator/")) {
            return "credit_county";
        }
        if (path.equals("/radon-credit-calculator")) {
            return "credit_root";
        }
        if (path.startsWith("/guides/")) {
            return "guide_article";
        }
        if (path.equals("/guides")) {
            return "guides_root";
        }
        if (path.startsWith("/admin/")) {
            return "admin";
        }
        return path.replaceFirst("^/", "");
    }

    private List<UserScenario> buildScenarios() {
        List<ViewportCase> viewports = List.of(
                new ViewportCase("mobile-390", 390, 844, true),
                new ViewportCase("mobile-375", 375, 812, true),
                new ViewportCase("laptop-1280", 1280, 720, false),
                new ViewportCase("desktop-1440", 1440, 960, false));

        List<RoutePlan> plans = routePlans();
        List<UserScenario> scenarios = new ArrayList<>();
        for (int i = 0; i < 100; i++) {
            RoutePlan plan = plans.get(i % plans.size());
            ViewportCase viewport = viewports.get((i + (i / plans.size())) % viewports.size());
            scenarios.add(new UserScenario(i + 1, plan.keyword(), plan.path(), viewport, plan.action(), plan.value()));
        }
        return scenarios;
    }

    private List<RoutePlan> routePlans() {
        return List.of(
                new RoutePlan("radon mitigation cost", "/radon-mitigation-cost", UserAction.SCAN, null),
                new RoutePlan("radon cost calculator", "/radon-cost-calculator", UserAction.ZIP_COST_SEARCH, "22030"),
                new RoutePlan("radon failed inspection credit", "/radon-credit-calculator", UserAction.ZIP_CREDIT_SEARCH, "22030"),
                new RoutePlan("radon levels by county", "/radon-levels", UserAction.SCAN, null),
                new RoutePlan("california radon map", "/radon-levels/california", UserAction.SCAN, null),
                new RoutePlan("california radon mitigation cost", "/radon-mitigation-cost/california", UserAction.SCAN, null),
                new RoutePlan("commercial radon los angeles ca", "/radon-levels/california/los-angeles-county", UserAction.LEVELS_TO_COST, null),
                new RoutePlan("radon mitigation cost los angeles county", "/radon-mitigation-cost/california/los-angeles-county", UserAction.HTMX_RECEIPT, null),
                new RoutePlan("buyer radon credit los angeles", "/radon-credit-calculator/california/los-angeles-county?intent=buying&radonResultBand=above_4", UserAction.SCAN, null),
                new RoutePlan("radon gas testing ulster county ny", "/radon-levels/new-york/ulster-county", UserAction.LEVELS_TO_COST, null),
                new RoutePlan("radon mitigation services ulster county ny", "/radon-mitigation-cost/new-york/ulster-county", UserAction.LEAD_SUBMIT, "12401"),
                new RoutePlan("radon testing boulder co", "/radon-levels/colorado/boulder-county", UserAction.LEVELS_TO_COST, null),
                new RoutePlan("boulder radon mitigation", "/radon-mitigation-cost/colorado/boulder-county", UserAction.HTMX_RECEIPT, null),
                new RoutePlan("broomfield radon mitigation", "/radon-levels/colorado/broomfield-county", UserAction.SCAN, null),
                new RoutePlan("broomfield radon mitigation cost", "/radon-mitigation-cost/colorado/broomfield-county", UserAction.SCAN, null),
                new RoutePlan("radon testing loudoun county", "/radon-levels/virginia/loudoun-county", UserAction.LEVELS_TO_COST, null),
                new RoutePlan("radon mitigation cost loudoun county", "/radon-mitigation-cost/virginia/loudoun-county", UserAction.SCAN, null),
                new RoutePlan("st louis radon", "/radon-levels/missouri/st-louis-county", UserAction.LEVELS_TO_COST, null),
                new RoutePlan("st louis radon mitigation cost", "/radon-mitigation-cost/missouri/st-louis-county", UserAction.SCAN, null),
                new RoutePlan("nj radon map", "/radon-levels/new-jersey", UserAction.SCAN, null),
                new RoutePlan("bergen county radon", "/radon-levels/new-jersey/bergen-county", UserAction.LEVELS_TO_COST, null),
                new RoutePlan("bergen county radon mitigation cost", "/radon-mitigation-cost/new-jersey/bergen-county", UserAction.SCAN, null),
                new RoutePlan("radon mitigation cost mn", "/radon-mitigation-cost/minnesota/hennepin-county", UserAction.SCAN, null),
                new RoutePlan("radon levels hennepin county", "/radon-levels/minnesota/hennepin-county", UserAction.SCAN, null),
                new RoutePlan("radon mitigation system cost indiana", "/radon-mitigation-cost/indiana/marion-county", UserAction.SCAN, null),
                new RoutePlan("indiana radon levels marion county", "/radon-levels/indiana/marion-county", UserAction.SCAN, null),
                new RoutePlan("iowa radon levels polk county", "/radon-levels/iowa/polk-county", UserAction.SCAN, null),
                new RoutePlan("iowa radon mitigation cost polk county", "/radon-mitigation-cost/iowa/polk-county", UserAction.SCAN, null),
                new RoutePlan("how to test for radon", "/guides/how-to-test-for-radon", UserAction.MOBILE_NAV, null),
                new RoutePlan("radon failed inspection", "/guides/radon-failed-inspection", UserAction.SCAN, null),
                new RoutePlan("radon inspection toolkit", "/guides/radon-inspection-toolkit", UserAction.SCAN, null),
                new RoutePlan("radon mitigation quote checklist", "/guides/radon-mitigation-quote-checklist", UserAction.SCAN, null),
                new RoutePlan("who pays radon mitigation buyer seller", "/guides/who-pays-radon-mitigation-buyer-or-seller", UserAction.SCAN, null),
                new RoutePlan("radon seller credit worksheet", "/guides/radon-seller-credit-worksheet", UserAction.SCAN, null),
                new RoutePlan("diy vs professional radon mitigation", "/guides/diy-vs-professional-radon-mitigation", UserAction.SCAN, null),
                new RoutePlan("radon mitigation timeline how long", "/guides/radon-mitigation-timeline-how-long-does-it-take", UserAction.SCAN, null),
                new RoutePlan("radon exposure symptoms", "/guides/radon-exposure-symptoms", UserAction.SCAN, null),
                new RoutePlan("active vs passive radon system", "/guides/active-vs-passive-radon-system", UserAction.SCAN, null),
                new RoutePlan("radon fan noise troubleshooting", "/guides/radon-fan-noise-troubleshooting", UserAction.SCAN, null),
                new RoutePlan("crawl space radon mitigation", "/guides/crawl-space-radon-mitigation", UserAction.SCAN, null),
                new RoutePlan("sump pump radon mitigation", "/guides/sump-pump-radon-mitigation", UserAction.SCAN, null),
                new RoutePlan("radon system electricity cost", "/guides/radon-system-electricity-cost", UserAction.SCAN, null),
                new RoutePlan("radon myths granite countertops", "/guides/radon-myths-granite-countertops", UserAction.SCAN, null),
                new RoutePlan("radon guides", "/guides", UserAction.SCAN, null),
                new RoutePlan("radon quote ledger", "/radon-quote-ledger", UserAction.QUOTE_CHECKER, "650"),
                new RoutePlan("submit radon quote", "/radon-quote-ledger", UserAction.QUOTE_LEDGER_SUBMIT, null),
                new RoutePlan("radon data sources", "/radon-data-sources", UserAction.SCAN, null),
                new RoutePlan("radon cost data report", "/radon-cost-data-report", UserAction.SCAN, null),
                new RoutePlan("radon methodology", "/methodology", UserAction.SCAN, null),
                new RoutePlan("about radonverdict", "/about", UserAction.SCAN, null),
                new RoutePlan("contact radonverdict", "/contact", UserAction.CONTACT_SUBMIT, null),
                new RoutePlan("radon privacy policy", "/privacy", UserAction.SCAN, null),
                new RoutePlan("radon terms", "/terms", UserAction.SCAN, null),
                new RoutePlan("admin search console dashboard", "/admin/search-console", UserAction.ADMIN_SCAN, null),
                new RoutePlan("home radon action plan", "/", UserAction.MOBILE_NAV, null));
    }

    private java.util.Optional<String> keywordFitWarning(String keyword, String corpus) {
        Set<String> tokens = new LinkedHashSet<>();
        for (String raw : keyword.toLowerCase(Locale.US).split("[^a-z0-9]+")) {
            if (raw.length() >= 4 && !GENERIC_KEYWORD_TOKENS.contains(raw)) {
                tokens.add(raw);
            }
        }
        if (tokens.isEmpty()) {
            return java.util.Optional.empty();
        }

        String normalizedCorpus = corpus.toLowerCase(Locale.US);
        long matched = tokens.stream().filter(normalizedCorpus::contains).count();
        int expected = Math.min(2, tokens.size());
        if (matched < expected) {
            return java.util.Optional.of("Weak search-intent fit for '" + keyword + "': matched "
                    + matched + "/" + tokens.size() + " distinctive tokens " + tokens);
        }
        return java.util.Optional.empty();
    }

    private boolean hasReadableViewportText(Page page) {
        Object value = page.evaluate("""
                () => Array.from(document.querySelectorAll('h1, h2, p, a, button, label, input, select, textarea'))
                  .some((element) => {
                    const style = window.getComputedStyle(element);
                    const rect = element.getBoundingClientRect();
                    const text = (element.innerText || element.value || element.getAttribute('placeholder') || element.getAttribute('aria-label') || '')
                      .replace(/\\s+/g, ' ')
                      .trim();
                    return text.length >= 2
                      && style.display !== 'none'
                      && style.visibility !== 'hidden'
                      && Number(style.opacity || '1') > 0
                      && rect.width > 0
                      && rect.height > 0
                      && rect.bottom > 0
                      && rect.right > 0
                      && rect.top < window.innerHeight
                      && rect.left < window.innerWidth;
                  })
                """);
        return Boolean.TRUE.equals(value);
    }

    private String excerptAroundBadCopy(String bodyText) {
        java.util.regex.Matcher matcher = BAD_VISIBLE_COPY.matcher(bodyText);
        if (!matcher.find()) {
            return "";
        }
        int start = Math.max(0, matcher.start() - 70);
        int end = Math.min(bodyText.length(), matcher.end() + 70);
        return bodyText.substring(start, end);
    }

    private String safeTitle(Page page) {
        try {
            return page.title() == null ? "" : page.title();
        } catch (RuntimeException e) {
            return "";
        }
    }

    private String baseUrl() {
        return "http://127.0.0.1:" + port;
    }

    private String escapeMarkdown(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("|", "\\|").replace("\n", " ");
    }

    private String toJson(List<ScenarioResult> results, List<String> criticalFailures) {
        StringBuilder json = new StringBuilder();
        json.append("{\n");
        json.append("  \"baseUrl\": ").append(json(baseUrl())).append(",\n");
        json.append("  \"scenarioCount\": ").append(results.size()).append(",\n");
        json.append("  \"criticalFailures\": [");
        for (int i = 0; i < criticalFailures.size(); i++) {
            if (i > 0) {
                json.append(", ");
            }
            json.append(json(criticalFailures.get(i)));
        }
        json.append("],\n");
        json.append("  \"results\": [\n");
        for (int i = 0; i < results.size(); i++) {
            ScenarioResult result = results.get(i);
            if (i > 0) {
                json.append(",\n");
            }
            json.append("    {\n");
            json.append("      \"id\": ").append(result.id()).append(",\n");
            json.append("      \"keyword\": ").append(json(result.keyword())).append(",\n");
            json.append("      \"path\": ").append(json(result.path())).append(",\n");
            json.append("      \"finalUrl\": ").append(json(result.finalUrl())).append(",\n");
            json.append("      \"viewport\": ").append(json(result.viewport())).append(",\n");
            json.append("      \"action\": ").append(json(result.action().name())).append(",\n");
            json.append("      \"status\": ").append(result.status()).append(",\n");
            json.append("      \"title\": ").append(json(result.title())).append(",\n");
            json.append("      \"failures\": ").append(jsonArray(result.failures())).append(",\n");
            json.append("      \"warnings\": ").append(jsonArray(result.warnings())).append(",\n");
            json.append("      \"screenshot\": ").append(json(result.screenshot())).append("\n");
            json.append("    }");
        }
        json.append("\n  ]\n");
        json.append("}\n");
        return json.toString();
    }

    private String jsonArray(List<String> values) {
        StringBuilder out = new StringBuilder("[");
        for (int i = 0; i < values.size(); i++) {
            if (i > 0) {
                out.append(", ");
            }
            out.append(json(values.get(i)));
        }
        out.append("]");
        return out.toString();
    }

    private String json(String value) {
        if (value == null) {
            return "null";
        }
        String escaped = value
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
        return "\"" + escaped + "\"";
    }

    private void deleteIfExists(Path path) throws IOException {
        if (Files.exists(path)) {
            Files.delete(path);
        }
    }
}
