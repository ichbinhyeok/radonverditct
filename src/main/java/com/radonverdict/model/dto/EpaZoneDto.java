package com.radonverdict.model.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

@Data
public class EpaZoneDto {
    private String fips;
    @JsonProperty("epa_zone")
    private int epaZone;
    @JsonProperty("zone_label")
    private String zoneLabel;
}
