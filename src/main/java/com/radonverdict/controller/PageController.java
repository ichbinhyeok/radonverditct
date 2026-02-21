package com.radonverdict.controller;

import com.radonverdict.model.County;
import com.radonverdict.model.dto.CountyPageContent;
import com.radonverdict.model.dto.ItemizedReceipt;
import com.radonverdict.model.dto.PricingRequest;
import com.radonverdict.service.ContentGenerationService;
import com.radonverdict.service.DataLoadService;
import com.radonverdict.service.PricingCalculatorService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.server.ResponseStatusException;

@Controller
@RequiredArgsConstructor
public class PageController {

    private final DataLoadService dataLoadService;
    private final PricingCalculatorService calcService;
    private final ContentGenerationService contentService;

    @GetMapping("/")
    public String home() {
        return "redirect:/radon-cost-calculator";
    }

    @GetMapping("/radon-cost-calculator")
    public String globalCalculator(Model model) {
        model.addAttribute("title", "National Radon Mitigation Cost Calculator 2026");
        ItemizedReceipt defaultReceipt = calcService.calculate("US", "National Average", "other", "homeowner");
        model.addAttribute("defaultReceipt", defaultReceipt);
        return "calculator";
    }

    @GetMapping("/radon-mitigation-cost/{stateSlug}")
    public String stateHub(@PathVariable String stateSlug, Model model) {
        boolean validState = dataLoadService.getCountyBySlugMap().values().stream()
                .anyMatch(c -> c.getStateSlug().equalsIgnoreCase(stateSlug));

        if (!validState)
            throw new ResponseStatusException(HttpStatus.NOT_FOUND);

        model.addAttribute("stateSlug", stateSlug);
        return "state_hub";
    }

    @GetMapping("/radon-mitigation-cost/{stateSlug}/{countySlug}")
    public String countyPage(@PathVariable String stateSlug, @PathVariable String countySlug, Model model) {
        String key = stateSlug.toLowerCase() + "/" + countySlug.toLowerCase();
        County county = dataLoadService.getCountyBySlugMap().get(key);

        if (county == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "County not found");
        }

        // Build the FULL page content (Zone + State regulation + Intent + FAQ +
        // Receipt)
        CountyPageContent pageContent = contentService.buildPageContent(county, "basement", "buying");

        model.addAttribute("county", county);
        model.addAttribute("page", pageContent);

        return "county_hub";
    }

    // HTMX Endpoint: recalculates receipt + content fragment based on user input
    @PostMapping("/htmx/calculate-receipt")
    public String calculateReceiptFragment(
            @RequestParam String stateSlug,
            @RequestParam String countySlug,
            @RequestParam String foundation,
            @RequestParam String intent,
            Model model) {

        String key = stateSlug.toLowerCase() + "/" + countySlug.toLowerCase();
        County county = dataLoadService.getCountyBySlugMap().get(key);

        if (county == null) {
            // Fallback: just return empty receipt
            model.addAttribute("page", contentService.buildPageContent(
                    dataLoadService.getCountByFipsMap().values().iterator().next(), foundation, intent));
        } else {
            // Build full content based on the new user selection
            CountyPageContent pageContent = contentService.buildPageContent(county, foundation, intent);
            model.addAttribute("page", pageContent);
        }

        return "fragments/receipt";
    }
}
