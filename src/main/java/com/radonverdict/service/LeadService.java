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

        // leadRepository.save(lead);
        saveToCsv(lead, request);

        log.info("New lead captured and saved into CSV for county: {}, State: {}", request.getCountySlug(),
                request.getStateAbbr());
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
                        pw.println("Date,Name,Phone,Email,Zip,State,County,Foundation,Tested,Intent,ResultBand");
                    }

                    String date = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
                    pw.printf("\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\"%n",
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
                            escapeCsv(request.getSelectedRadonResultBand() != null ? request.getSelectedRadonResultBand() : ""));
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

    private String getConsentSnapshot(String version) {
        // Normally this would come from a loaded JSON like lead_consent_templates.json
        if ("v1.0".equals(version)) {
            return "Prior to submitting, I consent to be contacted regarding my personalized radon action plan and local contractor availability.";
        }
        return "I consent to be contacted by a local radon representative.";
    }
}
