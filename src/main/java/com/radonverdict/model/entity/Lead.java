package com.radonverdict.model.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "leads")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Lead {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // User Input (Prequel)
    @Column(name = "customer_name", nullable = false, length = 100)
    private String customerName;

    @Column(name = "customer_phone", nullable = false, length = 20)
    private String customerPhone;

    @Column(name = "customer_email", length = 100)
    private String customerEmail;

    @Column(name = "zip_code", nullable = false, length = 10)
    private String zipCode;

    @Column(name = "foundation_type", length = 50)
    private String foundationType;

    @Column(name = "is_tested")
    private Boolean isTested;

    @Column(name = "preferred_contact_time", length = 50)
    private String preferredContactTime;

    @Column(name = "county_slug", length = 100)
    private String countySlug;

    @Column(name = "state_abbr", length = 10)
    private String stateAbbr;

    // Routing & Consent (Monetization Core)
    @Column(name = "selected_provider_ids", columnDefinition = "TEXT")
    private String selectedProviderIds;

    @Column(name = "consent_version", nullable = false, length = 20)
    private String consentVersion;

    @Column(name = "consent_text_snapshot", nullable = false, columnDefinition = "TEXT")
    private String consentTextSnapshot;

    // Metadata (Compliance & Fraud Check)
    @Column(name = "ip_address", length = 45)
    private String ipAddress;

    @Column(name = "user_agent", columnDefinition = "TEXT")
    private String userAgent;

    @CreationTimestamp
    @Column(name = "submitted_at", updatable = false)
    private LocalDateTime submittedAt;

    @Column(name = "calculator_viewed_at")
    private LocalDateTime calculatorViewedAt;

    // Status & KPI Tracking
    @Column(name = "status", length = 20)
    @Builder.Default
    private String status = "PENDING"; // PENDING, ACCEPTED, REJECTED

    @Column(name = "acceptance_rate_flag")
    private Boolean acceptanceRateFlag;

    @Column(name = "revenue_expected", precision = 10, scale = 2)
    private BigDecimal revenueExpected;

    @Column(name = "chargeback_status")
    @Builder.Default
    private Boolean chargebackStatus = false;
}
