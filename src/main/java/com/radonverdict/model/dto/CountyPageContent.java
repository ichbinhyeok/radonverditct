package com.radonverdict.model.dto;

import lombok.Builder;
import lombok.Data;

import java.util.List;

/**
 * Assembled, ready-to-render page content for a single county.
 * Every field is pre-resolved with county/state/zone specifics.
 * No hardcoded text should exist outside this DTO and the source JSON
 * templates.
 */
@Data
@Builder
public class CountyPageContent {

    @Builder.Default
    private boolean indexable = true;

    // Hero Section
    private String heroTitle;
    private String heroSummary; // Zone-aware summary
    private String seoDescription;
    private String pricingRationale;
    private String riskLevel; // "High", "Moderate", "Low", "Unclassified"
    private String badgeColor; // "red", "yellow", "green", "gray"

    // Risk Narrative
    private String riskNarrative;

    // County-specific insight bullets (state comparison + affordability + stock profile)
    private List<String> localInsights;

    // Intent-specific Content
    private String intentSectionTitle;
    private String intentIntro;
    private List<String> intentSteps;
    private String intentProTip;

    // Foundation Description
    private String foundationLabel;
    private String foundationCostContext;
    private String foundationNegotiationNote;

    // State Regulation
    private boolean disclosureRequired;
    private String disclosureSummary;
    private String stateProgramUrl;
    private boolean licenseRequired;
    private String licenseNote;

    // Dynamic FAQ (zone-specific + universal, all placeholders resolved)
    private List<FaqItem> faqs;

    // Itemized Receipt (from PricingCalculatorService)
    private ItemizedReceipt receipt;

    // Comparison benchmarks (same input conditions)
    private int stateAverageTotal;
    private int nationalAverageTotal;

    // Current calculator context used for explanation blocks
    private String selectedFoundationType;
    private String selectedIntent;
    private String selectedSqftCategory;
    private String selectedRadonResultBand;

    // SEO Silo: Neighboring Counties in the same state
    private List<com.radonverdict.model.County> nearbyCounties;

    public int getComparisonMaxTotal() {
        int county = receipt != null ? receipt.getTotalAvg() : 0;
        return Math.max(county, Math.max(stateAverageTotal, nationalAverageTotal));
    }

    public int getCountyVsStateDeltaPct() {
        if (stateAverageTotal <= 0 || receipt == null) {
            return 0;
        }
        return (int) Math.round(((receipt.getTotalAvg() - stateAverageTotal) * 100.0) / stateAverageTotal);
    }

    public int getCountyVsNationalDeltaPct() {
        if (nationalAverageTotal <= 0 || receipt == null) {
            return 0;
        }
        return (int) Math.round(((receipt.getTotalAvg() - nationalAverageTotal) * 100.0) / nationalAverageTotal);
    }

    public String getSelectedFoundationLabel() {
        if (selectedFoundationType == null) {
            return "Other / Not Sure";
        }
        return switch (selectedFoundationType.toLowerCase()) {
            case "basement" -> "Basement";
            case "crawlspace" -> "Crawl Space";
            case "slab" -> "Slab-on-Grade";
            default -> "Other / Not Sure";
        };
    }

    public String getSelectedIntentLabel() {
        if (selectedIntent == null) {
            return "Living Here";
        }
        return switch (selectedIntent.toLowerCase()) {
            case "buying" -> "Buying";
            case "selling" -> "Selling";
            default -> "Living Here";
        };
    }

    public String getSelectedSqftLabel() {
        if ("over_2000".equalsIgnoreCase(selectedSqftCategory)) {
            return "Over 2,000 sq ft";
        }
        return "Under 2,000 sq ft";
    }

    public String getSelectedRadonResultBandLabel() {
        if (selectedRadonResultBand == null) {
            return "Confirmed reading pending";
        }
        return switch (selectedRadonResultBand.toLowerCase()) {
            case "under_2" -> "Under 2.0 pCi/L";
            case "between_2_and_4" -> "2.0 to 3.9 pCi/L";
            case "above_4" -> "4.0+ pCi/L";
            default -> "Not tested yet";
        };
    }

    @Data
    @Builder
    public static class FaqItem {
        private String question;
        private String answer;
    }
}
