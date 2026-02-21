package com.radonverdict.service;

import com.radonverdict.model.County;
import com.radonverdict.model.PricingConfig;
import com.radonverdict.model.dto.ItemizedReceipt;
import com.radonverdict.model.dto.PricingRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
public class PricingCalculatorService {

    private final DataLoadService dataLoadService;

    public ItemizedReceipt calculate(PricingRequest request) {
        // 1. Resolve Location (County & State) from ZIP
        String fips = dataLoadService.getZipToFipsMap().get(request.getZipCode());
        if (fips == null) {
            log.warn("Unknown ZIP code: {}", request.getZipCode());
            return fallbackGlobalEstimate();
        }

        County county = dataLoadService.getCountByFipsMap().get(fips);
        if (county == null) {
            log.warn("County not found for FIPS: {}", fips);
            return fallbackGlobalEstimate();
        }

        return calculate(county.getStateAbbr(), county.getCountyName(), request.getFoundationType(),
                request.getUserIntent());
    }

    public ItemizedReceipt calculate(String stateAbbr, String countyName, String foundationType, String userIntent) {

        PricingConfig config = dataLoadService.getPricingConfig();

        // 2. Load Regional Multiplier
        double multiplier = config.getRegionalMultipliers().getOrDefault(stateAbbr.toUpperCase(),
                config.getDefaultMultiplier());

        // 3. Materials & Permits (Fixed items, unaffected by state multiplier for now)
        int matLow = config.getBaseComponents().getMaterials().getLow();
        int matHigh = config.getBaseComponents().getMaterials().getHigh();

        int permitsLow = config.getBaseComponents().getPermitsSetup().getLow();
        int permitsHigh = config.getBaseComponents().getPermitsSetup().getHigh();

        // 4. Labor Calculation (Base + Foundation Modifier) * Multiplier
        int laborBaseLow = config.getLaborBase().getLow();
        int laborBaseHigh = config.getLaborBase().getHigh();

        PricingConfig.Range foundationMod = config.getFoundationLaborModifiers().getOrDefault(
                foundationType != null ? foundationType.toLowerCase() : "other",
                config.getFoundationLaborModifiers().get("other"));

        int labLow = (int) Math.round((laborBaseLow + foundationMod.getLow()) * multiplier);
        int labHigh = (int) Math.round((laborBaseHigh + foundationMod.getHigh()) * multiplier);

        // 5. Totals
        int totalLow = matLow + labLow + permitsLow;
        int totalHigh = matHigh + labHigh + permitsHigh;

        // Sanity Check Bounds
        totalLow = Math.max(totalLow, config.getSanityBounds().getMinTotal());
        totalHigh = Math.min(totalHigh, config.getSanityBounds().getMaxTotal());

        int totalAvg = (totalLow + totalHigh) / 2;

        // 6. Generate Negotiation Advice
        String advice = generateAdvice(userIntent, totalAvg);

        return ItemizedReceipt.builder()
                .materialsLow(matLow)
                .materialsHigh(matHigh)
                .laborLow(labLow)
                .laborHigh(labHigh)
                .permitsSetupLow(permitsLow)
                .permitsSetupHigh(permitsHigh)
                .totalLow(totalLow)
                .totalHigh(totalHigh)
                .totalAvg(totalAvg)
                .negotiationAdvice(advice)
                .countyName(countyName)
                .stateAbbr(stateAbbr)
                .build();
    }

    private String generateAdvice(String intent, int totalAvg) {
        if ("buying".equalsIgnoreCase(intent)) {
            return "As a buyer, do not ask the seller to do the work themselves. " +
                    "Request a Seller Credit (Closing Credit) of $" + totalAvg + " based on this estimate. " +
                    "This lets you hire a trusted professional directly after closing.";
        } else if ("selling".equalsIgnoreCase(intent)) {
            return "Buyers will likely demand a credit for mitigation. " +
                    "You can proactively mitigate to market the home as 'Radon Safe', " +
                    "or offer an upfront credit of $" + totalAvg + " to prevent the buyer from walking away.";
        } else {
            return "Investing approximately $" + totalAvg + " in a professional mitigation system " +
                    "protects your family's health from lung cancer risk and permanently increases your home's resale value.";
        }
    }

    private ItemizedReceipt fallbackGlobalEstimate() {
        // Safe default if absolutely unknown location mapped (e.g., zip format
        // incorrect)
        return calculate("US", "Unknown", "other", "homeowner");
    }
}
