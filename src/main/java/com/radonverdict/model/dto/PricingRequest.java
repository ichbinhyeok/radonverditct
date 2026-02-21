package com.radonverdict.model.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class PricingRequest {
    private String zipCode;
    private String foundationType; // "basement", "crawlspace", "slab", "other"
    private String userIntent; // "buying", "selling", "homeowner"
    private String sqftCategory; // "under_2000", "over_2000"
}
