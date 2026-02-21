package com.radonverdict.controller;

import com.radonverdict.model.County;
import com.radonverdict.model.dto.ItemizedReceipt;
import com.radonverdict.model.dto.PricingRequest;
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

    @GetMapping("/")
    public String home() {
        return "redirect:/radon-cost-calculator";
    }

    @GetMapping("/radon-cost-calculator")
    public String globalCalculator(Model model) {
        model.addAttribute("title", "National Radon Mitigation Cost Calculator 2026");
        // default receipt for global
        ItemizedReceipt defaultReceipt = calcService.calculate("US", "National Average", "other", "homeowner");
        model.addAttribute("defaultReceipt", defaultReceipt);
        return "calculator"; // JTE template
    }

    @GetMapping("/radon-mitigation-cost/{stateSlug}")
    public String stateHub(@PathVariable String stateSlug, Model model) {
        // Here we could filter counties by state and load state-level data
        // For MVP, if it exists in any county stateSlug, it's valid
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

        // Static Rendering (for AEO / Indexing / Default View)
        // By default, showing buying intent and basement foundation for conservative
        // logic
        ItemizedReceipt defaultReceipt = calcService.calculate(
                county.getStateAbbr(), county.getCountyName(), "basement", "buying");

        model.addAttribute("county", county);
        model.addAttribute("defaultReceipt", defaultReceipt);

        return "county_hub"; // JTE template
    }

    // HTMX Endpoint for dynamically updating the Interactive Receipt fragment!
    @PostMapping("/htmx/calculate-receipt")
    public String calculateReceiptFragment(
            @RequestParam String zipCode,
            @RequestParam String foundation,
            @RequestParam String intent,
            Model model) {

        PricingRequest req = PricingRequest.builder()
                .zipCode(zipCode)
                .foundationType(foundation)
                .userIntent(intent)
                .build();

        ItemizedReceipt newReceipt = calcService.calculate(req);
        model.addAttribute("receipt", newReceipt);

        // This resolves to a specific JTE fragment file (e.g., fragments/receipt.jte)
        return "fragments/receipt";
    }
}
