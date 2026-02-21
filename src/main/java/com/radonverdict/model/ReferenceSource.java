package com.radonverdict.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

@Data
public class ReferenceSource {
    private String id;
    private String name;
    private String url;
    private String type;
    @JsonProperty("retrieved_at")
    private String retrievedAt;
    private String notes;
}
