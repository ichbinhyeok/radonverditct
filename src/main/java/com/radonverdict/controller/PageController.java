package com.radonverdict.controller;

import com.radonverdict.model.County;
import com.radonverdict.model.StateRegulations;
import com.radonverdict.model.dto.AeoAnswerBlock;
import com.radonverdict.model.dto.CountyPageContent;
import com.radonverdict.model.dto.ItemizedReceipt;
import com.radonverdict.model.dto.PageQualityResult;
import com.radonverdict.model.dto.TrustMetadata;
import com.radonverdict.service.ContentGenerationService;
import com.radonverdict.service.DataLoadService;
import com.radonverdict.service.InternalLinkService;
import com.radonverdict.service.PageQualityService;
import com.radonverdict.service.PricingCalculatorService;
import com.radonverdict.service.SeoIndexingPolicyService;
import com.radonverdict.service.TrustMetadataService;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.view.RedirectView;

import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.time.LocalDate;
import java.util.stream.Collectors;

@Controller
@RequiredArgsConstructor
public class PageController {

    private final DataLoadService dataLoadService;
    private final PricingCalculatorService calcService;
    private final ContentGenerationService contentService;
    private final PageQualityService pageQualityService;
    private final SeoIndexingPolicyService seoIndexingPolicyService;
    private final TrustMetadataService trustMetadataService;
    private final InternalLinkService internalLinkService;

    @Value("${app.feature.monetization-hooks.enabled:false}")
    private boolean monetizationHooksEnabled;

    @Value("${app.site.base-url:https://radonverdict.com}")
    private String baseUrl;

    @Value("${app.feature.seo-debug-visible:false}")
    private boolean seoDebugVisible;

    @GetMapping("/")
    public RedirectView home() {
        return redirect("/radon-cost-calculator", HttpStatus.MOVED_PERMANENTLY);
    }

    @GetMapping("/radon-cost-calculator")
    public String globalCalculator(@RequestParam(name = "error", required = false) String error, Model model) {
        model.addAttribute("title", "National Radon Action Plan + Mitigation Cost Calculator " + LocalDate.now().getYear());
        ItemizedReceipt defaultReceipt = calcService.calculate("US", "National Average", "other", "homeowner");
        model.addAttribute("defaultReceipt", defaultReceipt);

        if (error != null) {
            model.addAttribute("noindex", true);
        }

        // Group counties by state for the directory
        Map<String, List<County>> stateMap = dataLoadService.getCountyBySlugMap().values().stream()
                .collect(Collectors.groupingBy(County::getStateAbbr, TreeMap::new, Collectors.toList()));
        model.addAttribute("stateMap", stateMap);

        return "calculator";
    }

    @GetMapping("/radon-mitigation-cost")
    public String mitigationCostRoot(Model model) {
        model.addAttribute("title", "Radon Mitigation Cost by State, Foundation Type, and Result | RadonVerdict");
        model.addAttribute("basementReceipt", calcService.calculate("US", "National Average", "Basement", "basement", "homeowner", "under_2000"));
        model.addAttribute("slabReceipt", calcService.calculate("US", "National Average", "Slab-on-Grade", "slab", "homeowner", "under_2000"));
        model.addAttribute("crawlspaceReceipt", calcService.calculate("US", "National Average", "Crawl Space", "crawlspace", "homeowner", "under_2000"));
        model.addAttribute("defaultReceipt", calcService.calculate("US", "National Average", "other", "homeowner"));
        model.addAttribute("trust", trustMetadataService.forGuidePage());

        Map<String, List<County>> stateMap = dataLoadService.getCountyBySlugMap().values().stream()
                .filter(seoIndexingPolicyService::isCountyIndexableCandidate)
                .collect(Collectors.groupingBy(County::getStateAbbr, TreeMap::new, Collectors.toList()));
        model.addAttribute("stateMap", stateMap);

        return "mitigation_cost_root";
    }

    @GetMapping("/radon-credit-calculator")
    public String globalCreditCalculator(@RequestParam(name = "error", required = false) String error, Model model) {
        model.addAttribute("title", "Radon Seller Credit Calculator " + LocalDate.now().getYear());
        ItemizedReceipt defaultReceipt = calcService.calculate("US", "National Average", "other", "buying");
        model.addAttribute("defaultReceipt", defaultReceipt);

        if (error != null) {
            model.addAttribute("noindex", true);
        }

        Map<String, List<County>> stateMap = dataLoadService.getCountyBySlugMap().values().stream()
                .collect(Collectors.groupingBy(County::getStateAbbr, TreeMap::new, Collectors.toList()));
        model.addAttribute("stateMap", stateMap);

        return "credit_calculator_landing";
    }

    // New Endpoint: Redirect ZIP code to its county page
    @PostMapping("/search-zip")
    public RedirectView searchZip(@RequestParam("zipCode") String zipCode,
                                  @RequestParam(name = "intent", required = false) String intent,
                                  @RequestParam(name = "radonResultBand", required = false) String radonResultBand) {
        String normalizedZip = zipCode == null ? null : zipCode.trim();
        String fips = dataLoadService.getZipToFipsMap().get(normalizedZip);
        if (fips == null) {
            // Handle invalid zip - redirect to global calculator with error
            return redirect("/radon-cost-calculator?error=notfound", HttpStatus.SEE_OTHER);
        }
        County county = dataLoadService.getCountByFipsMap().get(fips);
        if (county == null) {
            return redirect("/radon-cost-calculator?error=notfound", HttpStatus.SEE_OTHER);
        }
        StringBuilder target = new StringBuilder("/radon-mitigation-cost/")
                .append(county.getStateSlug())
                .append("/")
                .append(county.getCountySlug());

        boolean hasQuery = false;
        if (intent != null && !intent.isBlank()) {
            target.append(hasQuery ? "&" : "?").append("intent=").append(intent);
            hasQuery = true;
        }
        if (radonResultBand != null && !radonResultBand.isBlank()) {
            target.append(hasQuery ? "&" : "?").append("radonResultBand=").append(radonResultBand);
            hasQuery = true;
        }
        if (normalizedZip != null && normalizedZip.matches("\\d{5}")) {
            target.append(hasQuery ? "&" : "?").append("zipCode=").append(normalizedZip);
        }

        return redirect(target.toString(),
                HttpStatus.SEE_OTHER);
    }

    @PostMapping("/search-zip-credit")
    public RedirectView searchZipCredit(@RequestParam("zipCode") String zipCode,
                                        @RequestParam(name = "intent", required = false) String intent,
                                        @RequestParam(name = "radonResultBand", required = false) String radonResultBand) {
        String fips = dataLoadService.getZipToFipsMap().get(zipCode.trim());
        if (fips == null) {
            return redirect("/radon-credit-calculator?error=notfound", HttpStatus.SEE_OTHER);
        }

        County county = dataLoadService.getCountByFipsMap().get(fips);
        if (county == null) {
            return redirect("/radon-credit-calculator?error=notfound", HttpStatus.SEE_OTHER);
        }

        String transactionIntent = "selling".equalsIgnoreCase(intent) ? "selling" : "buying";
        String resultBand = radonResultBand != null && !radonResultBand.isBlank() ? radonResultBand : "above_4";

        return redirect("/radon-credit-calculator/" + county.getStateSlug() + "/" + county.getCountySlug()
                        + "?intent=" + transactionIntent + "&radonResultBand=" + resultBand,
                HttpStatus.SEE_OTHER);
    }

    @GetMapping("/radon-mitigation-cost/{stateSlug}")
    public Object stateHub(@PathVariable("stateSlug") String stateSlug, Model model) {
        List<County> stateCounties = dataLoadService.getCountyBySlugMap().values().stream()
                .filter(c -> c.getStateSlug().equalsIgnoreCase(stateSlug))
                .sorted(Comparator.comparing(County::getCountyName))
                .collect(Collectors.toList());

        if (stateCounties.isEmpty())
            throw new ResponseStatusException(HttpStatus.NOT_FOUND);

        String canonicalStateSlug = stateCounties.get(0).getStateSlug();
        if (!canonicalStateSlug.equals(stateSlug)) {
            return permanentRedirect("/radon-mitigation-cost/" + canonicalStateSlug);
        }

        List<County> visibleCounties = stateCounties.stream()
                .filter(seoIndexingPolicyService::isCountyIndexableCandidate)
                .toList();

        model.addAttribute("stateSlug", canonicalStateSlug);
        model.addAttribute("stateAbbr", stateCounties.get(0).getStateAbbr());
        model.addAttribute("stateRule", resolveStateRule(stateCounties.get(0).getStateAbbr()));
        model.addAttribute("counties", visibleCounties);
        model.addAttribute("noindex", visibleCounties.isEmpty());
        return "state_hub";
    }

    @GetMapping("/radon-mitigation-cost/{stateSlug}/{countySlug}")
    public Object countyPage(@PathVariable("stateSlug") String stateSlug, @PathVariable("countySlug") String countySlug,
            @RequestParam(name = "foundation", required = false) String foundation,
            @RequestParam(name = "intent", required = false) String intent,
            @RequestParam(name = "sqftCategory", required = false) String sqftCategory,
            @RequestParam(name = "radonResultBand", required = false) String radonResultBand,
            @RequestParam(name = "zipCode", required = false) String zipCode,
            Model model) {
        String key = stateSlug.toLowerCase() + "/" + countySlug.toLowerCase();
        County county = dataLoadService.getCountyBySlugMap().get(key);

        if (county == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "County not found");
        }

        if (!county.getStateSlug().equals(stateSlug) || !county.getCountySlug().equals(countySlug)) {
            return permanentRedirect("/radon-mitigation-cost/" + county.getStateSlug() + "/" + county.getCountySlug());
        }

        // Build the FULL page content (Zone + State regulation + Intent + FAQ +
        // Receipt)
        CountyPageContent pageContent = hasCostScenarioOverrides(foundation, intent, sqftCategory, radonResultBand)
                ? contentService.buildPageContent(
                        county,
                        foundation != null ? foundation : "other",
                        intent != null ? intent : "homeowner",
                        sqftCategory != null ? sqftCategory : "under_2000",
                        radonResultBand != null ? radonResultBand : "not_tested")
                : contentService.buildDefaultPageContent(county);
        PageQualityResult quality = pageQualityService.scoreMitigationCountyPage(county, pageContent);
        pageContent.setIndexable(quality.isIndexable() && seoIndexingPolicyService.isCountyIndexableCandidate(county));

        TrustMetadata trust = trustMetadataService.forCountyPage(county);
        AeoAnswerBlock aeo = buildMitigationAeoBlock(county, pageContent, trust);

        model.addAttribute("county", county);
        model.addAttribute("page", pageContent);
        model.addAttribute("quality", quality);
        model.addAttribute("trust", trust);
        model.addAttribute("aeo", aeo);
        model.addAttribute("relatedLinks", internalLinkService.buildMitigationCountyLinks(county, pageContent));
        model.addAttribute("monetizationHooksEnabled", monetizationHooksEnabled);
        model.addAttribute("showSeoDebug", seoDebugVisible);
        model.addAttribute("canonicalUrl",
                normalizedBaseUrl() + "/radon-mitigation-cost/" + county.getStateSlug() + "/" + county.getCountySlug());
        model.addAttribute("prefilledZip", zipCode != null && zipCode.matches("\\d{5}") ? zipCode : null);

        return "county_hub";
    }

    @GetMapping("/radon-credit-calculator/{stateSlug}/{countySlug}")
    public Object countyCreditCalculator(
            @PathVariable("stateSlug") String stateSlug,
            @PathVariable("countySlug") String countySlug,
            @RequestParam(name = "foundation", required = false) String foundation,
            @RequestParam(name = "intent", required = false) String intent,
            @RequestParam(name = "sqftCategory", required = false) String sqftCategory,
            @RequestParam(name = "radonResultBand", required = false) String radonResultBand,
            Model model) {
        String key = stateSlug.toLowerCase() + "/" + countySlug.toLowerCase();
        County county = dataLoadService.getCountyBySlugMap().get(key);

        if (county == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "County not found");
        }

        if (!county.getStateSlug().equals(stateSlug) || !county.getCountySlug().equals(countySlug)) {
            return permanentRedirect("/radon-credit-calculator/" + county.getStateSlug() + "/" + county.getCountySlug());
        }

        CountyPageContent defaultScenario = contentService.buildDefaultPageContent(county);
        String transactionIntent = "selling".equalsIgnoreCase(intent) ? "selling" : "buying";
        String resolvedFoundation = foundation != null ? foundation : defaultScenario.getSelectedFoundationType();
        String resolvedSqftCategory = sqftCategory != null ? sqftCategory : defaultScenario.getSelectedSqftCategory();
        String resolvedResultBand = radonResultBand != null ? radonResultBand : "above_4";

        CountyPageContent pageContent = contentService.buildPageContent(
                county,
                resolvedFoundation,
                transactionIntent,
                resolvedSqftCategory,
                resolvedResultBand);

        model.addAttribute("county", county);
        model.addAttribute("page", pageContent);
        model.addAttribute("canonicalActionPlanUrl",
                normalizedBaseUrl() + "/radon-mitigation-cost/" + county.getStateSlug() + "/" + county.getCountySlug()
                        + "?intent=" + transactionIntent
                        + "&radonResultBand=" + resolvedResultBand);

        return "credit_calculator";
    }

    // HTMX Endpoint: recalculates receipt + content fragment based on user input
    @PostMapping("/htmx/calculate-receipt")
    public String calculateReceiptFragment(
            @RequestParam("stateSlug") String stateSlug,
            @RequestParam("countySlug") String countySlug,
            @RequestParam("foundation") String foundation,
            @RequestParam("intent") String intent,
            @RequestParam(value = "sqftCategory", defaultValue = "under_2000") String sqftCategory,
            @RequestParam(value = "radonResultBand", defaultValue = "not_tested") String radonResultBand,
            HttpServletResponse response,
            Model model) {
        response.setHeader("X-Robots-Tag", "noindex");

        String key = stateSlug.toLowerCase() + "/" + countySlug.toLowerCase();
        County county = dataLoadService.getCountyBySlugMap().get(key);

        if (county == null) {
            // Fallback: just return empty receipt
            model.addAttribute("page", contentService.buildPageContent(
                    dataLoadService.getCountByFipsMap().values().iterator().next(),
                    foundation,
                    intent,
                    sqftCategory,
                    radonResultBand));
        } else {
            // Build full content based on the new user selection
            CountyPageContent pageContent = contentService.buildPageContent(
                    county,
                    foundation,
                    intent,
                    sqftCategory,
                    radonResultBand);
            model.addAttribute("page", pageContent);
        }

        return "fragments/receipt";
    }

    private AeoAnswerBlock buildMitigationAeoBlock(County county, CountyPageContent page, TrustMetadata trust) {
        if (county == null || page == null || page.getReceipt() == null) {
            return null;
        }

        String answer = "Estimated average mitigation cost in " + county.getAreaDisplayName() + " is $"
                + page.getReceipt().getTotalAvg() + ", with a common range of $"
                + page.getReceipt().getTotalLow() + " to $" + page.getReceipt().getTotalHigh()
                + ". Final pricing depends on foundation type, home size, and routing complexity.";

        return AeoAnswerBlock.builder()
                .question("How much does radon mitigation cost in " + county.getAreaDisplayName() + "?")
                .directAnswer(answer)
                .evidenceRows(List.of(
                        AeoAnswerBlock.Row.builder()
                                .label("EPA Zone")
                                .value(county.getEpaZone() > 0 ? "Zone " + county.getEpaZone() : "Unclassified")
                                .build(),
                        AeoAnswerBlock.Row.builder()
                                .label("Average Cost")
                                .value("$" + page.getReceipt().getTotalAvg())
                                .build(),
                        AeoAnswerBlock.Row.builder()
                                .label("Typical Range")
                                .value("$" + page.getReceipt().getTotalLow() + " - $" + page.getReceipt().getTotalHigh())
                                .build(),
                        AeoAnswerBlock.Row.builder()
                                .label("Housing Units (Census)")
                                .value(county.getStats() != null && county.getStats().getMetrics() != null
                                        ? String.format("%,d", county.getStats().getMetrics().getTotalHousingUnits())
                                        : "Data unavailable")
                                .build()))
                .sources(trust != null ? trust.getSources() : List.of())
                .build();
    }

    private String normalizedBaseUrl() {
        if (baseUrl == null || baseUrl.isBlank()) {
            return "https://radonverdict.com";
        }
        return baseUrl.endsWith("/") ? baseUrl.substring(0, baseUrl.length() - 1) : baseUrl;
    }

    private RedirectView permanentRedirect(String path) {
        return redirect(path, HttpStatus.MOVED_PERMANENTLY);
    }

    private StateRegulations.StateRule resolveStateRule(String stateAbbr) {
        StateRegulations regulations = dataLoadService.getStateRegulations();
        if (regulations == null || stateAbbr == null) {
            return null;
        }
        return regulations.getStateRules().getOrDefault(
                stateAbbr.toUpperCase(),
                regulations.getDefaultStateRule());
    }

    private boolean hasCostScenarioOverrides(String foundation, String intent, String sqftCategory, String radonResultBand) {
        return foundation != null || intent != null || sqftCategory != null || radonResultBand != null;
    }

    private RedirectView redirect(String path, HttpStatus status) {
        RedirectView view = new RedirectView(path, true);
        view.setStatusCode(status);
        return view;
    }
}

