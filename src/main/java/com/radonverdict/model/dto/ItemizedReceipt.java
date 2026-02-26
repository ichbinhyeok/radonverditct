package com.radonverdict.model.dto;

import lombok.Builder;
import lombok.Data;

import java.util.Locale;

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

    public String getAreaTypeLabel() {
        if (countyName == null || countyName.isBlank()) {
            return "County";
        }

        String normalized = countyName.toLowerCase(Locale.ROOT);
        if (normalized.contains("city and borough")) {
            return "City and Borough";
        }
        if (normalized.endsWith("census area")) {
            return "Census Area";
        }
        if (normalized.endsWith("municipio")) {
            return "Municipio";
        }
        if (normalized.endsWith("parish")) {
            return "Parish";
        }
        if (normalized.endsWith("borough")) {
            return "Borough";
        }
        if (normalized.endsWith("city")) {
            return "City";
        }
        return "County";
    }

    public String getAreaDisplayName() {
        if (countyName == null || countyName.isBlank()) {
            return "";
        }
        String areaType = getAreaTypeLabel().toLowerCase(Locale.ROOT);
        String normalized = countyName.toLowerCase(Locale.ROOT);
        if (normalized.endsWith(areaType)) {
            return countyName;
        }
        return countyName + " " + getAreaTypeLabel();
    }
}
