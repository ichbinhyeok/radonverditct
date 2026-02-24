package com.radonverdict.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;
import java.util.List;

@Data
public class CountyStats {
    @JsonProperty("county_fips")
    private String countyFips;

    @JsonProperty("county_name_full")
    private String countyNameFull;

    @JsonProperty("retrieved_at")
    private String retrievedAt;

    @JsonProperty("sources")
    private List<Source> sources;

    @JsonProperty("metrics")
    private Metrics metrics;

    @Data
    public static class Source {
        private String name;
        private String url;
        @JsonProperty("retrieved_at")
        private String retrievedAt;
    }

    @Data
    public static class Metrics {
        @JsonProperty("total_housing_units")
        private int totalHousingUnits;

        @JsonProperty("built_before_1980_pct")
        private double builtBefore1980Pct;

        @JsonProperty("median_home_value")
        private int medianHomeValue;
    }
}
