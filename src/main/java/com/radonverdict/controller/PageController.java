package com.radonverdict.controller;

import com.radonverdict.model.County;
import com.radonverdict.model.CountyRadonMeasurement;
import com.radonverdict.model.CountyRadonTier;
import com.radonverdict.model.StateRegulations;
import com.radonverdict.model.dto.AeoAnswerBlock;
import com.radonverdict.model.dto.CostEvidenceHubInsight;
import com.radonverdict.model.dto.CountyPageContent;
import com.radonverdict.model.dto.ItemizedReceipt;
import com.radonverdict.model.dto.PageQualityResult;
import com.radonverdict.model.dto.TrustMetadata;
import com.radonverdict.service.ContentGenerationService;
import com.radonverdict.service.DataLoadService;
import com.radonverdict.service.InternalLinkService;
import com.radonverdict.service.PageQualityService;
import com.radonverdict.service.PricingCalculatorService;
import com.radonverdict.service.QuoteLedgerService;
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
import org.springframework.web.util.UriComponentsBuilder;
import org.springframework.web.servlet.view.RedirectView;

import java.util.Comparator;
import java.util.List;
import java.util.Locale;
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
    private final QuoteLedgerService quoteLedgerService;

    @Value("${app.feature.monetization-hooks.enabled:false}")
    private boolean monetizationHooksEnabled;

    @Value("${app.site.index-county-cost-pages:true}")
    private boolean indexCountyCostPages;

    @Value("${app.site.base-url:https://radonverdict.com}")
    private String baseUrl;

    @Value("${app.feature.seo-debug-visible:false}")
    private boolean seoDebugVisible;

    @GetMapping("/")
    public String home() {
        return "index";
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
                .filter(seoIndexingPolicyService::isCountyIndexableCandidate)
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

        List<County> costCounties = costIndexableCounties(dataLoadService.getCountyBySlugMap().values().stream()
                .sorted(Comparator.comparing(County::getStateAbbr).thenComparing(County::getCountyName))
                .toList());
        Map<String, List<County>> stateMap = costCounties.stream()
                .collect(Collectors.groupingBy(County::getStateAbbr, TreeMap::new, Collectors.toList()));
        model.addAttribute("stateMap", stateMap);
        model.addAttribute("costEvidenceInsight", buildCostEvidenceHubInsight(stateMap, costCounties));

        return "mitigation_cost_root";
    }

    @GetMapping("/radon-credit-calculator")
    public String globalCreditCalculator(@RequestParam(name = "error", required = false) String error, Model model) {
        model.addAttribute("title", "Radon Failed Inspection Credit Calculator | Buyer/Seller Negotiation");
        ItemizedReceipt defaultReceipt = calcService.calculate("US", "National Average", "other", "buying");
        model.addAttribute("defaultReceipt", defaultReceipt);
        model.addAttribute("trust", trustMetadataService.forGuidePage());

        if (error != null) {
            model.addAttribute("noindex", true);
        }

        Map<String, List<County>> stateMap = dataLoadService.getCountyBySlugMap().values().stream()
                .filter(seoIndexingPolicyService::isCountyIndexableCandidate)
                .collect(Collectors.groupingBy(County::getStateAbbr, TreeMap::new, Collectors.toList()));
        model.addAttribute("stateMap", stateMap);

        return "credit_calculator_landing";
    }

    // New Endpoint: Redirect ZIP code to its county page
    @PostMapping("/search-zip")
    public RedirectView searchZip(@RequestParam("zipCode") String zipCode,
                                  @RequestParam(name = "intent", required = false) String intent,
                                  @RequestParam(name = "radonResultBand", required = false) String radonResultBand,
                                  @RequestParam(name = "foundationType", required = false) String foundationType,
                                  @RequestParam(name = "foundation", required = false) String foundation) {
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

        return redirect(buildCountyScenarioRedirect(
                        "/radon-mitigation-cost/{stateSlug}/{countySlug}",
                        county,
                        sanitizeIntent(intent, null),
                        sanitizeRadonResultBand(radonResultBand, null),
                        normalizedZip,
                        sanitizeFoundation(firstPresent(foundationType, foundation))),
                HttpStatus.SEE_OTHER);
    }

    @PostMapping("/search-zip-credit")
    public RedirectView searchZipCredit(@RequestParam("zipCode") String zipCode,
                                        @RequestParam(name = "intent", required = false) String intent,
                                        @RequestParam(name = "role", required = false) String role,
                                        @RequestParam(name = "radonResultBand", required = false) String radonResultBand,
                                        @RequestParam(name = "foundationType", required = false) String foundationType,
                                        @RequestParam(name = "foundation", required = false) String foundation) {
        String normalizedZip = zipCode == null ? null : zipCode.trim();
        String fips = dataLoadService.getZipToFipsMap().get(normalizedZip);
        if (fips == null) {
            return redirect("/radon-credit-calculator?error=notfound", HttpStatus.SEE_OTHER);
        }

        County county = dataLoadService.getCountByFipsMap().get(fips);
        if (county == null) {
            return redirect("/radon-credit-calculator?error=notfound", HttpStatus.SEE_OTHER);
        }

        return redirect(buildCountyScenarioRedirect(
                        "/radon-credit-calculator/{stateSlug}/{countySlug}",
                        county,
                        sanitizeCreditIntent(intent, role),
                        sanitizeRadonResultBand(radonResultBand, "above_4"),
                        normalizedZip,
                        sanitizeFoundation(firstPresent(foundationType, foundation))),
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

        List<County> visibleCounties = costIndexableCounties(stateCounties);
        String stateName = humanizeStateSlug(canonicalStateSlug, stateCounties.get(0).getStateAbbr());
        String stateAbbr = stateCounties.get(0).getStateAbbr();

        model.addAttribute("stateSlug", canonicalStateSlug);
        model.addAttribute("stateAbbr", stateAbbr);
        model.addAttribute("stateRule", resolveStateRule(stateAbbr));
        model.addAttribute("counties", visibleCounties);
        model.addAttribute("basementReceipt", calcService.calculate(stateAbbr, stateName + " State Average", stateName, "basement", "homeowner", "under_2000"));
        model.addAttribute("slabReceipt", calcService.calculate(stateAbbr, stateName + " State Average", stateName, "slab", "homeowner", "under_2000"));
        model.addAttribute("crawlspaceReceipt", calcService.calculate(stateAbbr, stateName + " State Average", stateName, "crawlspace", "homeowner", "under_2000"));
        model.addAttribute("zone1Count", stateCounties.stream().filter(c -> c.getEpaZone() == 1).count());
        model.addAttribute("zone2Count", stateCounties.stream().filter(c -> c.getEpaZone() == 2).count());
        model.addAttribute("zone3Count", stateCounties.stream().filter(c -> c.getEpaZone() == 3).count());
        model.addAttribute("costEvidenceInsight", buildCostEvidenceHubInsight(
                Map.of(stateAbbr, visibleCounties),
                visibleCounties));
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
                : contentService.buildCostLandingPageContent(county);
        PageQualityResult quality = pageQualityService.scoreMitigationCountyPage(county, pageContent);
        pageContent.setIndexable(indexCountyCostPages
                && quality.isIndexable()
                && seoIndexingPolicyService.isCostPageIndexableCandidate(county));

        TrustMetadata trust = trustMetadataService.forCountyPage(county);
        AeoAnswerBlock aeo = buildMitigationAeoBlock(county, pageContent, trust);

        model.addAttribute("county", county);
        model.addAttribute("page", pageContent);
        model.addAttribute("quality", quality);
        model.addAttribute("trust", trust);
        model.addAttribute("aeo", aeo);
        model.addAttribute("relatedLinks", internalLinkService.buildMitigationCountyLinks(county, pageContent));
        model.addAttribute("countyZipCodes", countyZipCodes(county));
        model.addAttribute("quoteBenchmark", quoteLedgerService.getCountyBenchmarkSnapshot(county));
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

    private List<County> costIndexableCounties(List<County> counties) {
        if (counties == null || !indexCountyCostPages) {
            return List.of();
        }
        return counties.stream()
                .filter(seoIndexingPolicyService::isCostPageIndexableCandidate)
                .sorted(Comparator
                        .comparing(County::getStateAbbr)
                        .thenComparing(County::getCountyName))
                .toList();
    }

    private CostEvidenceHubInsight buildCostEvidenceHubInsight(Map<String, List<County>> stateMap,
            List<County> costCounties) {
        if (costCounties == null || costCounties.isEmpty()) {
            return null;
        }

        int evidenceCount = (int) costCounties.stream()
                .filter(this::hasOfficialRadonEvidence)
                .count();
        int measuredCount = (int) costCounties.stream()
                .filter(county -> dataLoadService.getRadonMeasurementByFipsMap().containsKey(county.getFips()))
                .count();
        int tierCount = (int) costCounties.stream()
                .filter(county -> dataLoadService.getRadonTierByFipsMap().containsKey(county.getFips()))
                .count();
        int searchCohortCount = (int) costCounties.stream()
                .filter(seoIndexingPolicyService::isSearchTrafficCandidate)
                .count();

        List<CostEvidenceHubInsight.StateCostRow> priorityStateRows = stateMap.entrySet().stream()
                .map(entry -> buildStateCostRow(entry.getKey(), entry.getValue()))
                .filter(row -> row != null)
                .sorted((left, right) -> Double.compare(
                        stateCostPriorityScore(right),
                        stateCostPriorityScore(left)))
                .limit(8)
                .toList();
        List<CostEvidenceHubInsight.CountyCostRow> priorityCountyRows = costCounties.stream()
                .sorted((left, right) -> {
                    int scoreCompare = Integer.compare(
                            seoIndexingPolicyService.countyIndexingScore(right),
                            seoIndexingPolicyService.countyIndexingScore(left));
                    if (scoreCompare != 0) {
                        return scoreCompare;
                    }
                    int housingCompare = Integer.compare(housingUnits(right), housingUnits(left));
                    if (housingCompare != 0) {
                        return housingCompare;
                    }
                    return (left.getStateSlug() + left.getCountySlug())
                            .compareTo(right.getStateSlug() + right.getCountySlug());
                })
                .limit(12)
                .map(this::buildCountyCostRow)
                .toList();

        return CostEvidenceHubInsight.builder()
                .indexableCostCountyCount(costCounties.size())
                .evidenceBackedCostCountyCount(evidenceCount)
                .measuredCostCountyCount(measuredCount)
                .tierBackedCostCountyCount(tierCount)
                .searchCohortCostCountyCount(searchCohortCount)
                .decisionHeadline("Open cost pages that have a real reason to exist: demand, official radon evidence, or both.")
                .discoverySummary("The cost directory now follows the same eligibility rule as the county cost pages themselves. That keeps state hubs, sitemap candidates, and internal links pointed at pages Google can actually index.")
                .sourceSummary("Evidence-backed cost pages combine the local price model with official radon measurements or official map tiers before asking users to compare contractors.")
                .routingSummary("Use the state rows for crawl discovery, then use the county rows for the highest-signal first clicks from the cost pillar.")
                .priorityStateRows(priorityStateRows)
                .priorityCountyRows(priorityCountyRows)
                .build();
    }

    private CostEvidenceHubInsight.StateCostRow buildStateCostRow(String stateAbbr, List<County> counties) {
        if (counties == null || counties.isEmpty()) {
            return null;
        }
        County topCounty = counties.stream()
                .max(Comparator
                        .comparingInt(seoIndexingPolicyService::countyIndexingScore)
                        .thenComparingInt(this::housingUnits))
                .orElse(counties.get(0));
        int evidenceCount = (int) counties.stream().filter(this::hasOfficialRadonEvidence).count();
        int measuredCount = (int) counties.stream()
                .filter(county -> dataLoadService.getRadonMeasurementByFipsMap().containsKey(county.getFips()))
                .count();

        return CostEvidenceHubInsight.StateCostRow.builder()
                .stateAbbr(stateAbbr)
                .statePath("/radon-mitigation-cost/" + counties.get(0).getStateSlug())
                .priorityLabel(stateCostPriorityLabel(counties.size(), evidenceCount, measuredCount))
                .costCountyCount(counties.size())
                .evidenceCountyCount(evidenceCount)
                .measuredCountyCount(measuredCount)
                .topCountyName(topCounty.getAreaDisplayName())
                .topCountyPath("/radon-mitigation-cost/" + topCounty.getStateSlug() + "/" + topCounty.getCountySlug())
                .decisionDisplay(stateCostDecisionDisplay(stateAbbr, counties.size(), evidenceCount, measuredCount))
                .build();
    }

    private CostEvidenceHubInsight.CountyCostRow buildCountyCostRow(County county) {
        ItemizedReceipt receipt = calcService.calculate(
                county.getStateAbbr(),
                county.getCountyName(),
                county.getAreaDisplayName(),
                "basement",
                "homeowner",
                "under_2000");
        return CostEvidenceHubInsight.CountyCostRow.builder()
                .countyName(county.getAreaDisplayName())
                .countyPath("/radon-mitigation-cost/" + county.getStateSlug() + "/" + county.getCountySlug())
                .stateAbbr(county.getStateAbbr())
                .indexingScore(seoIndexingPolicyService.countyIndexingScore(county))
                .priorityLabel(countyCostPriorityLabel(county))
                .costRangeDisplay("$" + receipt.getTotalLow() + "-$" + receipt.getTotalHigh())
                .evidenceDisplay(countyEvidenceDisplay(county))
                .supportDisplay(countySupportDisplay(county))
                .build();
    }

    private double stateCostPriorityScore(CostEvidenceHubInsight.StateCostRow row) {
        if (row == null) {
            return 0.0;
        }
        double score = row.getCostCountyCount() * 2.0 + row.getEvidenceCountyCount() * 3.0
                + row.getMeasuredCountyCount() * 5.0;
        if ("Start here".equals(row.getPriorityLabel())) {
            score += 35.0;
        } else if ("Evidence dense".equals(row.getPriorityLabel())) {
            score += 20.0;
        }
        return score;
    }

    private String stateCostPriorityLabel(int costCount, int evidenceCount, int measuredCount) {
        if (measuredCount >= 8 || (measuredCount >= 3 && costCount >= 10)) {
            return "Start here";
        }
        if (evidenceCount >= Math.max(3, costCount / 2)) {
            return "Evidence dense";
        }
        if (costCount >= 5) {
            return "Cost coverage";
        }
        return "Focused set";
    }

    private String stateCostDecisionDisplay(String stateAbbr, int costCount, int evidenceCount, int measuredCount) {
        if (measuredCount > 0) {
            return stateAbbr + " has " + costCount + " indexable cost counties, including " + measuredCount
                    + " with measured radon evidence behind the cost path.";
        }
        if (evidenceCount > 0) {
            return stateAbbr + " has " + evidenceCount
                    + " official evidence-backed cost pages, so users can move from risk context into budget planning.";
        }
        return stateAbbr + " is shown only where the cost page has enough demand or local data to deserve a first click.";
    }

    private String countyCostPriorityLabel(County county) {
        if (seoIndexingPolicyService.isSearchTrafficCandidate(county)) {
            return "Demand cohort";
        }
        if (seoIndexingPolicyService.isEvidenceRichCostPageCandidate(county)) {
            return "Evidence-backed";
        }
        return "Cost eligible";
    }

    private String countyEvidenceDisplay(County county) {
        CountyRadonMeasurement measurement = dataLoadService.getRadonMeasurementByFipsMap().get(county.getFips());
        if (measurement != null) {
            String source = shortSourceName(measurement.getSourceName());
            String metric = measurementMetricDisplay(measurement);
            return source + (metric.isBlank() ? "" : ": " + metric);
        }
        CountyRadonTier tier = dataLoadService.getRadonTierByFipsMap().get(county.getFips());
        if (tier != null) {
            String source = shortSourceName(tier.getSourceName());
            return source + ": " + tier.getTier1Or2Pct() + "% Zone 1/2 municipalities";
        }
        return "EPA zone and local housing support";
    }

    private String countySupportDisplay(County county) {
        int housing = housingUnits(county);
        String zone = county.getEpaZone() > 0 ? "EPA Zone " + county.getEpaZone() : "EPA zone pending";
        return zone + " - " + String.format(Locale.US, "%,d", housing) + " housing units - score "
                + seoIndexingPolicyService.countyIndexingScore(county);
    }

    private String measurementMetricDisplay(CountyRadonMeasurement measurement) {
        if (measurement == null || measurement.getMetrics() == null) {
            return "";
        }
        CountyRadonMeasurement.Metrics metrics = measurement.getMetrics();
        if (metrics.getPercentTestsAtOrAbove4PciL() != null) {
            return formatDecimal(metrics.getPercentTestsAtOrAbove4PciL()) + "% 4.0+";
        }
        if (metrics.getAverageTestResultPciL() != null) {
            return formatDecimal(metrics.getAverageTestResultPciL()) + " pCi/L average";
        }
        if (metrics.getBasementAverageTestResultPciL() != null) {
            return formatDecimal(metrics.getBasementAverageTestResultPciL()) + " pCi/L basement average";
        }
        if (metrics.getMedianRadonValuePciL() != null) {
            return formatDecimal(metrics.getMedianRadonValuePciL()) + " pCi/L median";
        }
        if (metrics.getMaximumTestResultPciL() != null) {
            return formatDecimal(metrics.getMaximumTestResultPciL()) + " pCi/L high-end";
        }
        return "";
    }

    private String shortSourceName(String sourceName) {
        if (sourceName == null || sourceName.isBlank()) {
            return "Official radon source";
        }
        return sourceName
                .replace("Department of Health", "Health Dept.")
                .replace("Environmental Public Health Tracking", "EPHT")
                .replace("Pre-Mitigation Radon Test Results", "radon tests");
    }

    private String formatDecimal(double value) {
        if (Math.abs(value - Math.rint(value)) < 0.05) {
            return String.format(Locale.US, "%.0f", value);
        }
        return String.format(Locale.US, "%.1f", value);
    }

    private boolean hasOfficialRadonEvidence(County county) {
        if (county == null) {
            return false;
        }
        return dataLoadService.getRadonMeasurementByFipsMap().containsKey(county.getFips())
                || dataLoadService.getRadonTierByFipsMap().containsKey(county.getFips());
    }

    private int housingUnits(County county) {
        if (county == null || county.getStats() == null || county.getStats().getMetrics() == null) {
            return 0;
        }
        return county.getStats().getMetrics().getTotalHousingUnits();
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

    private String humanizeStateSlug(String stateSlug, String fallback) {
        if (stateSlug == null || stateSlug.isBlank()) {
            return fallback;
        }

        String[] stateSlugParts = stateSlug.split("-");
        StringBuilder stateNameBuilder = new StringBuilder();
        for (int i = 0; i < stateSlugParts.length; i++) {
            String part = stateSlugParts[i];
            if (part == null || part.isBlank()) {
                continue;
            }
            String normalized = part.toLowerCase(Locale.ROOT);
            String displayPart;
            if (i > 0 && ("of".equals(normalized) || "and".equals(normalized))) {
                displayPart = normalized;
            } else {
                displayPart = normalized.substring(0, 1).toUpperCase(Locale.ROOT) + normalized.substring(1);
            }
            if (stateNameBuilder.length() > 0) {
                stateNameBuilder.append(" ");
            }
            stateNameBuilder.append(displayPart);
        }

        return stateNameBuilder.length() > 0 ? stateNameBuilder.toString() : fallback;
    }

    private boolean hasCostScenarioOverrides(String foundation, String intent, String sqftCategory, String radonResultBand) {
        return foundation != null || intent != null || sqftCategory != null || radonResultBand != null;
    }

    private List<String> countyZipCodes(County county) {
        if (county == null || county.getFips() == null) {
            return List.of();
        }

        return dataLoadService.getZipToFipsMap().entrySet().stream()
                .filter(entry -> county.getFips().equals(entry.getValue()))
                .map(Map.Entry::getKey)
                .filter(zip -> zip != null && zip.matches("\\d{5}"))
                .sorted()
                .limit(10)
                .toList();
    }

    private String buildCountyScenarioRedirect(
            String pathTemplate,
            County county,
            String intent,
            String radonResultBand,
            String zipCode,
            String foundation) {
        UriComponentsBuilder builder = UriComponentsBuilder.fromPath(pathTemplate);
        addQueryParam(builder, "intent", intent);
        addQueryParam(builder, "radonResultBand", radonResultBand);
        if (zipCode != null && zipCode.matches("\\d{5}")) {
            addQueryParam(builder, "zipCode", zipCode);
        }
        addQueryParam(builder, "foundation", foundation);

        return builder
                .buildAndExpand(county.getStateSlug(), county.getCountySlug())
                .encode()
                .toUriString();
    }

    private void addQueryParam(UriComponentsBuilder builder, String key, String value) {
        if (value != null && !value.isBlank()) {
            builder.queryParam(key, value);
        }
    }

    private String sanitizeCreditIntent(String intent, String role) {
        String sanitizedIntent = sanitizeIntent(intent, null);
        if ("buying".equals(sanitizedIntent) || "selling".equals(sanitizedIntent)) {
            return sanitizedIntent;
        }

        String sanitizedRole = sanitizeIntent(role, null);
        if ("buying".equals(sanitizedRole) || "selling".equals(sanitizedRole)) {
            return sanitizedRole;
        }

        return "buying";
    }

    private String sanitizeIntent(String value, String fallback) {
        String normalized = normalizeToken(value);
        if (normalized == null) {
            return fallback;
        }

        return switch (normalized) {
            case "buying", "buyer" -> "buying";
            case "selling", "seller" -> "selling";
            case "homeowner", "owner", "living_here" -> "homeowner";
            default -> fallback;
        };
    }

    private String sanitizeRadonResultBand(String value, String fallback) {
        String normalized = normalizeToken(value);
        if (normalized == null) {
            return fallback;
        }

        return switch (normalized) {
            case "not_tested", "under_2", "between_2_and_4", "above_4" -> normalized;
            default -> fallback;
        };
    }

    private String sanitizeFoundation(String value) {
        String normalized = normalizeToken(value);
        if (normalized == null) {
            return null;
        }

        return switch (normalized) {
            case "basement", "slab", "other" -> normalized;
            case "crawlspace", "crawl_space" -> "crawlspace";
            default -> null;
        };
    }

    private String normalizeToken(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }

        return value.trim()
                .toLowerCase(Locale.ROOT)
                .replace('-', '_')
                .replace(' ', '_');
    }

    private String firstPresent(String first, String second) {
        if (first != null && !first.isBlank()) {
            return first;
        }
        return second;
    }

    private RedirectView redirect(String path, HttpStatus status) {
        RedirectView view = new RedirectView(path, true);
        view.setStatusCode(status);
        return view;
    }
}

