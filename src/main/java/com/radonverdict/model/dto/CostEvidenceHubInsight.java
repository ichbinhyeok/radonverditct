package com.radonverdict.model.dto;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class CostEvidenceHubInsight {
    private int indexableCostCountyCount;
    private int evidenceBackedCostCountyCount;
    private int measuredCostCountyCount;
    private int tierBackedCostCountyCount;
    private int searchCohortCostCountyCount;
    private String decisionHeadline;
    private String discoverySummary;
    private String sourceSummary;
    private String routingSummary;
    private String reportSummary;
    private String nationalCostRangeDisplay;
    private String quoteLedgerBridgeSummary;
    private List<StateCostRow> priorityStateRows;
    private List<CountyCostRow> priorityCountyRows;

    @Data
    @Builder
    public static class StateCostRow {
        private String stateAbbr;
        private String statePath;
        private String priorityLabel;
        private int costCountyCount;
        private int evidenceCountyCount;
        private int measuredCountyCount;
        private String topCountyName;
        private String topCountyPath;
        private String decisionDisplay;
    }

    @Data
    @Builder
    public static class CountyCostRow {
        private String countyName;
        private String countyPath;
        private String stateAbbr;
        private int indexingScore;
        private String priorityLabel;
        private String costRangeDisplay;
        private String evidenceDisplay;
        private String supportDisplay;
        private String sourceUrl;
        private String userQuestion;
        private String whyThisCounty;
        private String inspectionPriority;
    }
}
