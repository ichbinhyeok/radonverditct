package com.radonverdict.model.dto;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class RadonNationalEvidenceInsight {
    private int visibleCountyCount;
    private int measuredCountyCount;
    private int stateOfficialMeasuredCount;
    private int cdcMeasuredCount;
    private int tierBackedCount;
    private int sourcePendingCount;
    private String decisionHeadline;
    private String routerSummary;
    private String sourceMoatSummary;
    private String deployReadinessSummary;
    private List<StateEvidenceRow> priorityStateRows;

    @Data
    @Builder
    public static class StateEvidenceRow {
        private String stateAbbr;
        private String statePath;
        private String priorityLabel;
        private String coverageDisplay;
        private String measuredDisplay;
        private String elevatedDisplay;
        private String sourceMixDisplay;
        private String decisionDisplay;
    }
}
