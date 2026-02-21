package com.radonverdict.service;

import com.radonverdict.model.dto.LeadSubmissionRequest;
import com.radonverdict.model.entity.Lead;
import com.radonverdict.repository.LeadRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
public class LeadService {

    private final LeadRepository leadRepository;

    /**
     * Safely stores a new lead into the H2 database
     */
    public void submitLead(LeadSubmissionRequest request, String ipAddress, String userAgent) {

        // This simulates retrieving the actual consent text associated with a version
        String consentTextSnapshot = getConsentSnapshot(request.getConsentVersion());

        Lead lead = Lead.builder()
                .customerName(request.getCustomerName())
                .customerPhone(request.getCustomerPhone())
                .customerEmail(request.getCustomerEmail())
                .zipCode(request.getZipCode())
                .foundationType(request.getFoundationType())
                .isTested(request.getHasTested())
                .preferredContactTime(request.getPreferredContactTime())
                .stateAbbr(request.getStateAbbr())
                .countySlug(request.getCountySlug())
                .consentVersion(request.getConsentVersion())
                .consentTextSnapshot(consentTextSnapshot)
                .ipAddress(ipAddress)
                .userAgent(userAgent)
                .build();

        leadRepository.save(lead);
        log.info("New lead captured and saved for county: {}, State: {}", request.getCountySlug(),
                request.getStateAbbr());
    }

    private String getConsentSnapshot(String version) {
        // Normally this would come from a loaded JSON like lead_consent_templates.json
        if ("v1.0".equals(version)) {
            return "Prior to submitting, I consent to be contacted by local radon professionals to provide quotes for mitigation services.";
        }
        return "I consent to be contacted by a local radon representative.";
    }
}
