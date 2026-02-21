package com.radonverdict.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;
import java.util.Map;

@Data
public class PricingConfig {

    @JsonProperty("base_components")
    private BaseComponents baseComponents;

    @JsonProperty("labor_base")
    private Range laborBase;

    @JsonProperty("foundation_labor_modifiers")
    private Map<String, Range> foundationLaborModifiers;

    @JsonProperty("foundation_material_modifiers")
    private Map<String, Range> foundationMaterialModifiers;

    @JsonProperty("sqft_multipliers")
    private Map<String, Double> sqftMultipliers;

    @JsonProperty("regional_multipliers")
    private Map<String, Double> regionalMultipliers;

    @JsonProperty("default_multiplier")
    private double defaultMultiplier;

    @JsonProperty("sanity_bounds")
    private SanityBounds sanityBounds;

    @Data
    public static class BaseComponents {
        private Range materials;
        @JsonProperty("permits_setup")
        private Range permitsSetup;
    }

    @Data
    public static class Range {
        private int low;
        private int high;

        public int getAvg() {
            return (low + high) / 2;
        }
    }

    @Data
    public static class SanityBounds {
        @JsonProperty("min_total")
        private int minTotal;
        @JsonProperty("max_total")
        private int maxTotal;
    }
}
