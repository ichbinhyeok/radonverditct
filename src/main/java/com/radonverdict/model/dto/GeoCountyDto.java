package com.radonverdict.model.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

@Data
public class GeoCountyDto {
    private String fips;
    @JsonProperty("state_abbr")
    private String stateAbbr;
    @JsonProperty("county_name")
    private String countyName;
    @JsonProperty("state_slug")
    private String stateSlug;
    @JsonProperty("county_slug")
    private String countySlug;
}
