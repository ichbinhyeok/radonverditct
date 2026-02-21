package com.radonverdict.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import java.util.Map;

@Data
public class StateRegulations {

    @JsonProperty("state_rules")
    private Map<String, StateRule> stateRules;

    @JsonProperty("default_state_rule")
    private StateRule defaultStateRule;

    @Data
    public static class StateRule {
        @JsonProperty("disclosure_required")
        private boolean disclosureRequired;
        @JsonProperty("disclosure_summary")
        private String disclosureSummary;
        @JsonProperty("state_program_url")
        private String stateProgramUrl;
        @JsonProperty("license_required")
        private boolean licenseRequired;
        @JsonProperty("license_note")
        private String licenseNote;
    }
}
