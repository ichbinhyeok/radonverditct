package com.radonverdict.model;

import lombok.Builder;
import lombok.Data;

import java.util.Locale;

@Data
@Builder
public class County {
    private String fips;
    private String stateAbbr;
    private String countyName;
    private String stateSlug;
    private String countySlug;
    private int epaZone;
    private String zoneLabel;

    // Loaded from county_stats.json (Census data)
    private CountyStats stats;

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

        if (countySlug != null
                && countySlug.endsWith("-city")
                && !countyName.toLowerCase(Locale.ROOT).endsWith(" city")) {
            return countyName;
        }

        String areaType = getAreaTypeLabel().toLowerCase(Locale.ROOT);
        String normalized = countyName.toLowerCase(Locale.ROOT);
        if (normalized.endsWith(areaType)) {
            return countyName;
        }
        return countyName + " " + getAreaTypeLabel();
    }

    public String getSeoDisplayName() {
        if (countyName == null || countyName.isBlank()) {
            return "";
        }

        if (countySlug != null
                && countySlug.endsWith("-city")
                && !countyName.toLowerCase(Locale.ROOT).endsWith(" city")) {
            return countyName;
        }

        return getAreaDisplayName();
    }
}
