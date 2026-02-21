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

    private String countyName;
    private String stateAbbr;

    public int getMaterialsAvg() {
        return (materialsLow + materialsHigh) / 2;
    }

    public int getLaborAvg() {
        return (laborLow + laborHigh) / 2;
    }

    public int getPermitsSetupAvg() {
        return (permitsSetupLow + permitsSetupHigh) / 2;
    }
}
