package com.radonverdict.model.dto;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class RadonStateEvidenceInsight {
    private int measuredCountyCount;
    private String decisionHeadline;
    private String stateDecisionSummary;
    private String firstClickSummary;
    private String buyerSellerSummary;
    private String retestSummary;
    private String patternSummary;
    private String zoneContrastSummary;
    private String sourceStrategySummary;
    private List<CountySignalRow> priorityDecisionRows;
    private List<CountySignalRow> topAbove4Rows;
    private List<CountySignalRow> topHighEndRows;
    private List<CountySignalRow> topTestVolumeRows;

    @Data
    @Builder
    public static class CountySignalRow {
        private String countyName;
        private String countyPath;
        private String metricLabel;
        private String metricDisplay;
        private String supportingDisplay;
        private String decisionDisplay;
        private String sourceShortName;
        private String riskTone;
    }
}
