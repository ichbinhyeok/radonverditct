package com.radonverdict.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import java.util.List;
import java.util.Map;

@Data
public class ContentTemplates {

    @JsonProperty("zone_descriptions")
    private Map<String, ZoneDescription> zoneDescriptions;

    @JsonProperty("foundation_descriptions")
    private Map<String, FoundationDescription> foundationDescriptions;

    @JsonProperty("intent_content")
    private Map<String, IntentContent> intentContent;

    @Data
    public static class ZoneDescription {
        @JsonProperty("risk_level")
        private String riskLevel;
        @JsonProperty("badge_color")
        private String badgeColor;
        @JsonProperty("hero_summary")
        private String heroSummary;
        @JsonProperty("risk_narrative")
        private String riskNarrative;
        @JsonProperty("buyer_warning")
        private String buyerWarning;
        @JsonProperty("seller_advisory")
        private String sellerAdvisory;
        @JsonProperty("homeowner_guidance")
        private String homeownerGuidance;
    }

    @Data
    public static class FoundationDescription {
        private String label;
        @JsonProperty("cost_context")
        private String costContext;
        @JsonProperty("negotiation_note")
        private String negotiationNote;
    }

    @Data
    public static class IntentContent {
        @JsonProperty("section_title")
        private String sectionTitle;
        private String intro;
        private List<String> steps;
        @JsonProperty("pro_tip")
        private String proTip;
    }
}
