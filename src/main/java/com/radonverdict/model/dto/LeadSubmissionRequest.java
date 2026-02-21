package com.radonverdict.model.dto;

import lombok.Data;

@Data
public class LeadSubmissionRequest {
    private String customerName;
    private String customerPhone;
    private String customerEmail;
    private String zipCode;
    private String foundationType;
    private String preferredContactTime;

    // Hidden fields from context
    private String countySlug;
    private String stateAbbr;
    private String consentVersion;
    private Boolean hasTested;
}
