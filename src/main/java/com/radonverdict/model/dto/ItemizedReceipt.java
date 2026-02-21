package com.radonverdict.model.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class ItemizedReceipt {
    private int materialsLow;
    private int materialsHigh;

    private int laborLow;
    private int laborHigh;

    private int permitsSetupLow;
    private int permitsSetupHigh;

    private int totalLow;
    private int totalHigh;
    private int totalAvg;

    private String negotiationAdvice;
    private String countyName;
    private String stateAbbr;
}
