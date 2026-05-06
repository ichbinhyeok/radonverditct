package com.radonverdict.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

@Data
public class CountyRadonTier {
    @JsonProperty("county_fips")
    private String countyFips;

    @JsonProperty("state_abbr")
    private String stateAbbr;

    @JsonProperty("county_name")
    private String countyName;

    @JsonProperty("source_id")
    private String sourceId;

    @JsonProperty("source_name")
    private String sourceName;

    @JsonProperty("source_url")
    private String sourceUrl;

    @JsonProperty("retrieved_at")
    private String retrievedAt;

    @JsonProperty("caveat")
    private String caveat;

    @JsonProperty("municipality_count")
    private int municipalityCount;

    @JsonProperty("tier_1_count")
    private int tier1Count;

    @JsonProperty("tier_2_count")
    private int tier2Count;

    @JsonProperty("tier_3_count")
    private int tier3Count;

    @JsonProperty("tier_1_pct")
    private double tier1Pct;

    @JsonProperty("tier_1_or_2_pct")
    private double tier1Or2Pct;

    @JsonProperty("dominant_tier")
    private int dominantTier;

    @JsonProperty("highest_risk_tier")
    private int highestRiskTier;
}
