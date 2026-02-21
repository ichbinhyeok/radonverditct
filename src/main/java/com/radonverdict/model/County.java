package com.radonverdict.model;

import lombok.Builder;
import lombok.Data;

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
}
