package com.radonverdict.model.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.Data;

@Data
public class LeadSubmissionRequest {
    @NotBlank(message = "Name is required")
    private String customerName;

    @NotBlank(message = "Phone number is required")
    @Pattern(regexp = "^\\+?[0-9\\-\\s()]{7,20}$", message = "Invalid phone number format")
    private String customerPhone;

    @Email(message = "Invalid email format")
    private String customerEmail;

    @NotBlank(message = "ZIP code is required")
    private String zipCode;

    private String foundationType;
    private String preferredContactTime;

    // Honeypot field - must be empty
    private String additionalPhone;

    // Hidden fields from context
    private String countySlug;
    private String stateAbbr;
    private String consentVersion;
    private Boolean hasTested;
}
