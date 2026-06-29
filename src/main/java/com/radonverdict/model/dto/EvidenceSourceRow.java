package com.radonverdict.model.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class EvidenceSourceRow {
    private String sourceName;
    private String sourceUrl;
    private String evidenceType;
    private String periodLabel;
    private int countyCount;
    private String caveatSummary;
}
