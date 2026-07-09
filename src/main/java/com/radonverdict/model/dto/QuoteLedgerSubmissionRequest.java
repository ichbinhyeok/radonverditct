package com.radonverdict.model.dto;

import jakarta.validation.constraints.AssertTrue;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class QuoteLedgerSubmissionRequest {

    @NotBlank(message = "ZIP code is required")
    @Pattern(regexp = "^\\d{5}$", message = "ZIP code must be 5 digits")
    private String zipCode;

    @NotBlank(message = "Role is required")
    @Pattern(regexp = "^(homeowner|buyer|seller|agent|inspector|mitigator|other)$", message = "Choose a valid role")
    private String role;

    @NotBlank(message = "Result band is required")
    @Pattern(regexp = "^(not_tested|under_2|between_2_and_4|above_4|above_8|unknown)$", message = "Choose a valid result band")
    private String resultBand;

    @Pattern(regexp = "^$|^\\d{1,2}(\\.\\d{1,2})?$", message = "Use a reading like 4.2")
    private String radonReadingPciL;

    @NotBlank(message = "Foundation type is required")
    @Pattern(regexp = "^(basement|slab|crawlspace|mixed|unknown)$", message = "Choose a valid foundation type")
    private String foundationType;

    @NotBlank(message = "Quote status is required")
    @Pattern(regexp = "^(quoted|paid|seller_credit|declined|planning)$", message = "Choose a valid quote status")
    private String quoteStatus;

    @Pattern(regexp = "^$|^[0-9]{2,6}$", message = "Use a whole dollar amount")
    private String quotedPrice;

    @Pattern(regexp = "^$|^[0-9]{2,6}$", message = "Use a whole dollar amount")
    private String finalPrice;

    @Size(max = 80, message = "Scope must be under 80 characters")
    private String systemScope;

    @Size(max = 80, message = "Timeline must be under 80 characters")
    private String timeline;

    @Email(message = "Invalid email format")
    @Size(max = 150, message = "Email must be under 150 characters")
    private String email;

    @Size(max = 1200, message = "Notes must be under 1200 characters")
    private String notes;

    @AssertTrue(message = "Consent is required")
    private boolean consentAccepted;

    // Honeypot field - must be empty
    private String additionalPhone;
}
