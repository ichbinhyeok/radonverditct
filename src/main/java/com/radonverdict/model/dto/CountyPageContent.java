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
    private String riskLevel; // "High", "Moderate", "Low", "Unclassified"
    private String badgeColor; // "red", "yellow", "green", "gray"

    // Risk Narrative
    private String riskNarrative;

    // County-specific insight bullets (state comparison + affordability + stock profile)
    private List<String> localInsights;

    // Similarity / uniqueness diagnostics for indexing decisions
    private int similarityUniquenessScore;
    private int similarityCohortSize;
    private String similarityFingerprint;

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

    // SEO Silo: Neighboring Counties in the same state
    private List<com.radonverdict.model.County> nearbyCounties;

    @Data
    @Builder
    public static class FaqItem {
        private String question;
        private String answer;
    }
}
