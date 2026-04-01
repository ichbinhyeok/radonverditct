package com.radonverdict.model.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.Data;

@Data
public class LeadSubmissionRequest {
    private String customerName;

    @Pattern(regexp = "^$|^\\+?[0-9\\-\\s()]{7,20}$", message = "Invalid phone number format")
    private String customerPhone;

    @NotBlank(message = "Email is required")
    @Email(message = "Invalid email format")
    private String customerEmail;

    @NotBlank(message = "ZIP code is required")
    @Pattern(regexp = "^\\d{5}$", message = "ZIP code must be 5 digits")
    private String zipCode;

    private String foundationType;
    private String preferredContactTime;

    // Honeypot field - must be empty
    private String additionalPhone;

    // Hidden fields from context
    private String countySlug;
    private String stateSlug;
    private String stateAbbr;
    private String consentVersion;
    private Boolean hasTested;
    private String selectedIntent;
    private String selectedRadonResultBand;
}
