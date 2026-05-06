package com.radonverdict.model.dto;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class RadonEvidenceCoverageSummary {
    private int totalCount;
    private int measuredCount;
    private int tierCount;
    private int sourcePendingCount;
    private int stateOfficialMeasuredCount;
    private int cdcMeasuredCount;
    private int officialEvidenceCount;
    private int officialEvidencePercent;
    private List<SourceRow> sourceRows;

    @Data
    @Builder
    public static class SourceRow {
        private String sourceId;
        private String sourceName;
        private String sourceType;
        private int count;
    }
}
