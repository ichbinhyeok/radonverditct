package com.radonverdict.service;

import com.radonverdict.model.dto.LeadSubmissionRequest;
import com.radonverdict.model.entity.Lead;
// import com.radonverdict.repository.LeadRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Slf4j
@Service
@RequiredArgsConstructor
public class LeadService {

    // private final LeadRepository leadRepository;

    @Value("${app.storage.leads-csv-path:data/leads.csv}")
    private String leadsCsvPath;

    private final Object writeLock = new Object();

    /**
     * Safely stores a new lead into a CSV file
     */
    public LeadScoringService.LeadScore submitLead(LeadSubmissionRequest request, String ipAddress, String userAgent) {

        // This simulates retrieving the actual consent text associated with a version
        String consentTextSnapshot = getConsentSnapshot(request.getConsentVersion());
        LeadScoringService.LeadScore leadScore = LeadScoringService.score(
                request.getSelectedIntent(),
                request.getSelectedRadonResultBand(),
                request.getPreferredContactTime(),
                request.getCustomerPhone(),
                request.getHasTested());

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
                .selectedIntent(request.getSelectedIntent())
                .selectedRadonResultBand(request.getSelectedRadonResultBand())
                .leadScore(leadScore.score())
                .leadTier(leadScore.tier())
                .nextAction(leadScore.nextAction())
                .status("PENDING")
                .lifecycleStatus("SUBMITTED")
                .leadDisposition("UNREVIEWED")
                .leadChannel("ORGANIC_COUNTY_ACTION_PLAN")
                .exclusiveRouting(false)
                .responseSlaMinutes(responseSlaMinutes(leadScore))
                .revenueExpected(expectedLeadValue(leadScore))
                .revenueActual(BigDecimal.ZERO)
                .partnerNotes("Initial capture. Update lifecycle after first contact, contractor feedback, or sale.")
                .consentVersion(request.getConsentVersion())
                .consentTextSnapshot(consentTextSnapshot)
                .ipAddress(ipAddress)
                .userAgent(userAgent)
                .build();

        // leadRepository.save(lead);
        saveToCsv(lead, request);

        log.info("New lead captured and saved into CSV for county: {}, State: {}", request.getCountySlug(),
                request.getStateAbbr());
        return leadScore;
    }

    private void saveToCsv(Lead lead, LeadSubmissionRequest request) {
        try {
            synchronized (writeLock) {
                Path path = Paths.get(leadsCsvPath);
                if (path.getParent() != null) {
                    Files.createDirectories(path.getParent());
                }
                boolean isNewFile = !Files.exists(path);

                try (PrintWriter pw = new PrintWriter(new FileWriter(path.toFile(), true))) {
                    if (isNewFile) {
                        pw.println("Date,Name,Phone,Email,Zip,State,County,Foundation,Tested,Intent,ResultBand,ContactPriority,LeadScore,LeadTier,NextAction,Status,LifecycleStatus,LeadDisposition,LeadChannel,ExclusiveRouting,ResponseSlaMinutes,RevenueExpected,RevenueActual,RefundReason,PartnerNotes");
                    }

                    String date = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
                    pw.printf("\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\"%n",
                            date,
                            escapeCsv(lead.getCustomerName()),
                            escapeCsv(lead.getCustomerPhone()),
                            escapeCsv(lead.getCustomerEmail() != null ? lead.getCustomerEmail() : ""),
                            escapeCsv(lead.getZipCode()),
                            escapeCsv(lead.getStateAbbr()),
                            escapeCsv(lead.getCountySlug()),
                            escapeCsv(lead.getFoundationType() != null ? lead.getFoundationType() : ""),
                            lead.getIsTested() != null ? lead.getIsTested().toString() : "",
                            escapeCsv(request.getSelectedIntent() != null ? request.getSelectedIntent() : ""),
                            escapeCsv(request.getSelectedRadonResultBand() != null ? request.getSelectedRadonResultBand() : ""),
                            escapeCsv(lead.getPreferredContactTime() != null ? lead.getPreferredContactTime() : ""),
                            lead.getLeadScore() != null ? lead.getLeadScore().toString() : "",
                            escapeCsv(lead.getLeadTier() != null ? lead.getLeadTier() : ""),
                            escapeCsv(lead.getNextAction() != null ? lead.getNextAction() : ""),
                            escapeCsv(lead.getStatus() != null ? lead.getStatus() : "PENDING"),
                            escapeCsv(lead.getLifecycleStatus() != null ? lead.getLifecycleStatus() : "SUBMITTED"),
                            escapeCsv(lead.getLeadDisposition() != null ? lead.getLeadDisposition() : "UNREVIEWED"),
                            escapeCsv(lead.getLeadChannel() != null ? lead.getLeadChannel() : "ORGANIC_COUNTY_ACTION_PLAN"),
                            lead.getExclusiveRouting() != null ? lead.getExclusiveRouting().toString() : "false",
                            lead.getResponseSlaMinutes() != null ? lead.getResponseSlaMinutes().toString() : "",
                            lead.getRevenueExpected() != null ? lead.getRevenueExpected().toPlainString() : "",
                            lead.getRevenueActual() != null ? lead.getRevenueActual().toPlainString() : "",
                            escapeCsv(lead.getRefundReason() != null ? lead.getRefundReason() : ""),
                            escapeCsv(lead.getPartnerNotes() != null ? lead.getPartnerNotes() : ""));
                }
            }
        } catch (IOException e) {
            log.error("Failed to write lead to CSV", e);
            throw new RuntimeException("Could not save lead data", e);
        }
    }

    private String escapeCsv(String val) {
        if (val == null)
            return "";
        return val.replace("\"", "\"\"");
    }

    private int responseSlaMinutes(LeadScoringService.LeadScore leadScore) {
        if (leadScore == null || leadScore.tier() == null) {
            return 240;
        }
        return switch (leadScore.tier()) {
            case "HOT" -> 15;
            case "WARM" -> 60;
            default -> 240;
        };
    }

    private BigDecimal expectedLeadValue(LeadScoringService.LeadScore leadScore) {
        if (leadScore == null || leadScore.tier() == null) {
            return BigDecimal.ZERO;
        }
        return switch (leadScore.tier()) {
            case "HOT" -> BigDecimal.valueOf(85);
            case "WARM" -> BigDecimal.valueOf(35);
            default -> BigDecimal.valueOf(10);
        };
    }

    private String getConsentSnapshot(String version) {
        // Normally this would come from a loaded JSON like lead_consent_templates.json
        if ("v1.0".equals(version)) {
            return "Prior to submitting, I consent to be contacted regarding my personalized radon plan and relevant local follow-up options.";
        }
        return "I consent to be contacted by a local radon representative.";
    }
}
