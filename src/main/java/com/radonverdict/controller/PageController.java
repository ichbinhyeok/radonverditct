package com.radonverdict.controller;

import com.radonverdict.model.County;
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
import com.radonverdict.service.TrustMetadataService;
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

import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.stream.Collectors;

@Controller
@RequiredArgsConstructor
public class PageController {

    private final DataLoadService dataLoadService;
    private final PricingCalculatorService calcService;
    private final ContentGenerationService contentService;
    private final PageQualityService pageQualityService;
    private final TrustMetadataService trustMetadataService;
    private final InternalLinkService internalLinkService;

    @Value("${app.feature.monetization-hooks.enabled:false}")
    private boolean monetizationHooksEnabled;

    @GetMapping("/")
    public String home() {
        return "redirect:/radon-cost-calculator";
    }

    @GetMapping("/radon-cost-calculator")
    public String globalCalculator(@RequestParam(name = "error", required = false) String error, Model model) {
        model.addAttribute("title", "National Radon Mitigation Cost Calculator 2026");
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

    // New Endpoint: Redirect ZIP code to its county page
    @PostMapping("/search-zip")
    public String searchZip(@RequestParam("zipCode") String zipCode) {
        String fips = dataLoadService.getZipToFipsMap().get(zipCode.trim());
        if (fips == null) {
            // Handle invalid zip - redirect to global calculator with error
            return "redirect:/radon-cost-calculator?error=notfound";
        }
        County county = dataLoadService.getCountByFipsMap().get(fips);
        if (county == null) {
            return "redirect:/radon-cost-calculator?error=notfound";
        }
        return "redirect:/radon-mitigation-cost/" + county.getStateSlug() + "/" + county.getCountySlug();
    }

    @GetMapping("/radon-mitigation-cost/{stateSlug}")
    public String stateHub(@PathVariable("stateSlug") String stateSlug, Model model) {
        List<County> stateCounties = dataLoadService.getCountyBySlugMap().values().stream()
                .filter(c -> c.getStateSlug().equalsIgnoreCase(stateSlug))
                .sorted(Comparator.comparing(County::getCountyName))
                .collect(Collectors.toList());

        if (stateCounties.isEmpty())
            throw new ResponseStatusException(HttpStatus.NOT_FOUND);

        model.addAttribute("stateSlug", stateSlug);
        model.addAttribute("stateAbbr", stateCounties.get(0).getStateAbbr());
        model.addAttribute("counties", stateCounties);
        return "state_hub";
    }

    @GetMapping("/radon-mitigation-cost/{stateSlug}/{countySlug}")
    public String countyPage(@PathVariable("stateSlug") String stateSlug, @PathVariable("countySlug") String countySlug,
            Model model) {
        String key = stateSlug.toLowerCase() + "/" + countySlug.toLowerCase();
        County county = dataLoadService.getCountyBySlugMap().get(key);

        if (county == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "County not found");
        }

        // Build the FULL page content (Zone + State regulation + Intent + FAQ +
        // Receipt)
        CountyPageContent pageContent = contentService.buildPageContent(county, "basement", "buying");
        PageQualityResult quality = pageQualityService.scoreMitigationCountyPage(county, pageContent);
        pageContent.setIndexable(quality.isIndexable());

        TrustMetadata trust = trustMetadataService.forCountyPage(county);
        AeoAnswerBlock aeo = buildMitigationAeoBlock(county, pageContent, trust);

        model.addAttribute("county", county);
        model.addAttribute("page", pageContent);
        model.addAttribute("quality", quality);
        model.addAttribute("trust", trust);
        model.addAttribute("aeo", aeo);
        model.addAttribute("relatedLinks", internalLinkService.buildMitigationCountyLinks(county, pageContent));
        model.addAttribute("monetizationHooksEnabled", monetizationHooksEnabled);
        model.addAttribute("canonicalUrl",
                "https://radonverdict.com/radon-mitigation-cost/" + stateSlug + "/" + countySlug);

        return "county_hub";
    }

    // HTMX Endpoint: recalculates receipt + content fragment based on user input
    @PostMapping("/htmx/calculate-receipt")
    public String calculateReceiptFragment(
            @RequestParam("stateSlug") String stateSlug,
            @RequestParam("countySlug") String countySlug,
            @RequestParam("foundation") String foundation,
            @RequestParam("intent") String intent,
            @RequestParam(value = "sqftCategory", defaultValue = "under_2000") String sqftCategory,
            Model model) {

        String key = stateSlug.toLowerCase() + "/" + countySlug.toLowerCase();
        County county = dataLoadService.getCountyBySlugMap().get(key);

        if (county == null) {
            // Fallback: just return empty receipt
            model.addAttribute("page", contentService.buildPageContent(
                    dataLoadService.getCountByFipsMap().values().iterator().next(), foundation, intent, sqftCategory));
        } else {
            // Build full content based on the new user selection
            CountyPageContent pageContent = contentService.buildPageContent(county, foundation, intent, sqftCategory);
            model.addAttribute("page", pageContent);
        }

        return "fragments/receipt";
    }

    private AeoAnswerBlock buildMitigationAeoBlock(County county, CountyPageContent page, TrustMetadata trust) {
        if (county == null || page == null || page.getReceipt() == null) {
            return null;
        }

        String answer = "Estimated average mitigation cost in " + county.getCountyName() + " County is $"
                + page.getReceipt().getTotalAvg() + ", with a common range of $"
                + page.getReceipt().getTotalLow() + " to $" + page.getReceipt().getTotalHigh()
                + ". Final pricing depends on foundation type, home size, and routing complexity.";

        return AeoAnswerBlock.builder()
                .question("How much does radon mitigation cost in " + county.getCountyName() + " County?")
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
}
