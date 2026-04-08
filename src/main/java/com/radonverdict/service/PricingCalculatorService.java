package com.radonverdict.service;

import com.radonverdict.model.County;
import com.radonverdict.model.PricingConfig;
import com.radonverdict.model.StateRegulations;
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

        return calculate(county.getStateAbbr(), county.getCountyName(), county.getAreaDisplayName(), request.getFoundationType(),
                request.getUserIntent(), request.getSqftCategory());
    }

    public ItemizedReceipt calculate(String stateAbbr, String countyName, String foundationType, String userIntent) {
        return calculate(stateAbbr, countyName, countyName, foundationType, userIntent, "under_2000");
    }

    public ItemizedReceipt calculate(String stateAbbr, String countyName, String foundationType, String userIntent,
            String sqftCategory) {
        return calculate(stateAbbr, countyName, countyName, foundationType, userIntent, sqftCategory);
    }

    public ItemizedReceipt calculate(String stateAbbr, String countyName, String areaDisplayName, String foundationType,
            String userIntent, String sqftCategory) {

        PricingConfig config = dataLoadService.getPricingConfig();
        StateRegulations regulations = dataLoadService.getStateRegulations();
        StateRegulations.StateRule stateRule = regulations != null ? regulations.getStateRules().getOrDefault(
                stateAbbr.toUpperCase(), regulations.getDefaultStateRule()) : null;

        // 2. Load Regional Multiplier
        double multiplier = config.getRegionalMultipliers().getOrDefault(stateAbbr.toUpperCase(),
                config.getDefaultMultiplier());

        // 3. Materials & Permits
        PricingConfig.Range foundationMatMod = config.getFoundationMaterialModifiers() != null
                ? config.getFoundationMaterialModifiers().getOrDefault(
                        foundationType != null ? foundationType.toLowerCase() : "other",
                        null)
                : null;
        int matLowMod = foundationMatMod != null ? foundationMatMod.getLow() : 0;
        int matHighMod = foundationMatMod != null ? foundationMatMod.getHigh() : 0;

        int matLow = config.getBaseComponents().getMaterials().getLow() + matLowMod;
        int matHigh = config.getBaseComponents().getMaterials().getHigh() + matHighMod;

        int permitsLow = config.getBaseComponents().getPermitsSetup().getLow();
        int permitsHigh = config.getBaseComponents().getPermitsSetup().getHigh();

        // License Premium
        if (stateRule != null && stateRule.isLicenseRequired()) {
            permitsLow += 100;
            permitsHigh += 200;
        }

        // 4. Labor Calculation (Base + Foundation Modifier) * Multiplier
        int laborBaseLow = config.getLaborBase().getLow();
        int laborBaseHigh = config.getLaborBase().getHigh();

        PricingConfig.Range foundationMod = config.getFoundationLaborModifiers().getOrDefault(
                foundationType != null ? foundationType.toLowerCase() : "other",
                config.getFoundationLaborModifiers().get("other"));

        int labLow = (int) Math.round((laborBaseLow + foundationMod.getLow()) * multiplier);
        int labHigh = (int) Math.round((laborBaseHigh + foundationMod.getHigh()) * multiplier);

        // 4.5. Square Footage Multiplier
        double sqftMult = 1.0;
        if (sqftCategory != null && config.getSqftMultipliers() != null) {
            sqftMult = config.getSqftMultipliers().getOrDefault(sqftCategory, 1.0);
        }

        // 5. Totals
        int totalLow = (int) Math.round((matLow + labLow + permitsLow) * sqftMult);
        int totalHigh = (int) Math.round((matHigh + labHigh + permitsHigh) * sqftMult);

        // Sanity Check Bounds
        totalLow = Math.max(totalLow, config.getSanityBounds().getMinTotal());
        totalHigh = Math.min(totalHigh, config.getSanityBounds().getMaxTotal());

        int totalAvg = (totalLow + totalHigh) / 2;

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
                .countyName(countyName)
                .areaDisplayName(areaDisplayName)
                .stateAbbr(stateAbbr)
                .build();
    }

    private ItemizedReceipt fallbackGlobalEstimate() {
        // Safe default if absolutely unknown location mapped (e.g., zip format
        // incorrect)
        return calculate("US", "Unknown", "other", "homeowner");
    }
}
