package com.radonverdict.controller;

import com.radonverdict.model.entity.Lead;
import com.radonverdict.model.dto.LeadOpsSummary;
import com.radonverdict.service.SearchConsoleCohortReportService;
import com.radonverdict.service.SearchDemandService;
import com.radonverdict.service.LeadScoringService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.view.RedirectView;

import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@Slf4j
@Controller
@RequiredArgsConstructor
public class AdminController {
    private static final DateTimeFormatter LEAD_CSV_DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    @Value("${app.storage.leads-csv-path:data/leads.csv}")
    private String leadsCsvPath;

    @Autowired(required = false)
    private SearchConsoleCohortReportService searchConsoleCohortReportService;

    @Autowired(required = false)
    private SearchDemandService searchDemandService;

    @GetMapping("/admin")
    public RedirectView adminIndex() {
        return new RedirectView("/admin/leads");
    }

    @GetMapping("/admin/leads")
    public String viewLeads(Model model) {
        model.addAttribute("title", "Admin | Leads Dashboard");

        List<Lead> leads = loadLeads();
        model.addAttribute("leads", leads);
        model.addAttribute("leadOpsSummary", buildLeadOpsSummary(leads));
        return "pages/admin_leads";
    }

    @GetMapping("/admin/search-console")
    public String viewSearchConsole(Model model) {
        model.addAttribute("title", "Admin | Search Console Cohorts");
        if (searchConsoleCohortReportService != null) {
            model.addAttribute("report", searchConsoleCohortReportService.buildReport());
        }
        if (searchDemandService != null) {
            model.addAttribute("demandExportAvailable", searchDemandService.exportAvailable());
            model.addAttribute("demandProfiles", searchDemandService.topOpportunities(20));
        }
        return "pages/admin_search_console";
    }

    private List<Lead> loadLeads() {
        List<Lead> leads = new ArrayList<>();

        try {
            Path path = Paths.get(leadsCsvPath);
            if (!Files.exists(path)) {
                return leads;
            }

            List<String> lines = Files.readAllLines(path);
            for (int i = 1; i < lines.size(); i++) {
                Lead lead = parseLead(lines.get(i));
                if (lead != null) {
                    leads.add(lead);
                }
            }
        } catch (Exception e) {
            log.error("Error reading leads CSV", e);
        }

        Collections.reverse(leads);
        return leads;
    }

    private Lead parseLead(String line) {
        List<String> cols = parseCsvColumns(line);
        if (cols.size() < 9) {
            log.warn("Skipping malformed lead row: {}", line);
            return null;
        }

        LocalDateTime submittedAt = null;
        if (!cols.get(0).isBlank()) {
            try {
                submittedAt = LocalDateTime.parse(cols.get(0), LEAD_CSV_DATE_FORMATTER);
            } catch (Exception e) {
                log.warn("Could not parse lead timestamp: {}", cols.get(0), e);
            }
        }

        String intent = cols.size() > 9 ? cols.get(9) : "";
        String resultBand = cols.size() > 10 ? cols.get(10) : "";
        String contactPriority = cols.size() > 11 ? cols.get(11) : "";
        String phone = cols.get(2);
        Boolean hasTested = cols.get(8).isBlank() ? null : Boolean.parseBoolean(cols.get(8));
        LeadScoringService.LeadScore fallbackScore = LeadScoringService.score(
                intent,
                resultBand,
                contactPriority,
                phone,
                hasTested);

        Integer leadScore = parseLeadScore(cols.size() > 12 ? cols.get(12) : null, fallbackScore.score());
        String leadTier = cols.size() > 13 && !cols.get(13).isBlank() ? cols.get(13) : fallbackScore.tier();
        String nextAction = cols.size() > 14 && !cols.get(14).isBlank() ? cols.get(14) : fallbackScore.nextAction();
        String status = cols.size() > 15 && !cols.get(15).isBlank() ? cols.get(15) : "PENDING";
        String lifecycleStatus = cols.size() > 16 && !cols.get(16).isBlank()
                ? cols.get(16)
                : lifecycleFromLegacyStatus(status);
        String leadDisposition = cols.size() > 17 && !cols.get(17).isBlank() ? cols.get(17) : "UNREVIEWED";
        String leadChannel = cols.size() > 18 && !cols.get(18).isBlank()
                ? cols.get(18)
                : "ORGANIC_COUNTY_ACTION_PLAN";
        Boolean exclusiveRouting = cols.size() > 19 && !cols.get(19).isBlank()
                ? Boolean.parseBoolean(cols.get(19))
                : false;
        Integer responseSlaMinutes = parseInteger(cols.size() > 20 ? cols.get(20) : null, null);
        BigDecimal revenueExpected = parseMoney(cols.size() > 21 ? cols.get(21) : null);
        BigDecimal revenueActual = parseMoney(cols.size() > 22 ? cols.get(22) : null);
        String refundReason = cols.size() > 23 && !cols.get(23).isBlank() ? cols.get(23) : null;
        String partnerNotes = cols.size() > 24 && !cols.get(24).isBlank() ? cols.get(24) : null;

        return Lead.builder()
                .submittedAt(submittedAt)
                .customerName(cols.get(1))
                .customerPhone(cols.get(2))
                .customerEmail(cols.get(3).isBlank() ? null : cols.get(3))
                .zipCode(cols.get(4))
                .stateAbbr(cols.get(5))
                .countySlug(cols.get(6))
                .foundationType(cols.get(7).isBlank() ? null : cols.get(7))
                .isTested(hasTested)
                .selectedIntent(intent.isBlank() ? null : intent)
                .selectedRadonResultBand(resultBand.isBlank() ? null : resultBand)
                .preferredContactTime(contactPriority.isBlank() ? null : contactPriority)
                .leadScore(leadScore)
                .leadTier(leadTier)
                .nextAction(nextAction)
                .status(status)
                .lifecycleStatus(lifecycleStatus)
                .leadDisposition(leadDisposition)
                .leadChannel(leadChannel)
                .exclusiveRouting(exclusiveRouting)
                .responseSlaMinutes(responseSlaMinutes)
                .revenueExpected(revenueExpected)
                .revenueActual(revenueActual)
                .refundReason(refundReason)
                .partnerNotes(partnerNotes)
                .build();
    }

    private Integer parseLeadScore(String raw, int fallback) {
        if (raw == null || raw.isBlank()) {
            return fallback;
        }
        try {
            return Integer.parseInt(raw);
        } catch (NumberFormatException e) {
            return fallback;
        }
    }

    private Integer parseInteger(String raw, Integer fallback) {
        if (raw == null || raw.isBlank()) {
            return fallback;
        }
        try {
            return Integer.parseInt(raw);
        } catch (NumberFormatException e) {
            return fallback;
        }
    }

    private BigDecimal parseMoney(String raw) {
        if (raw == null || raw.isBlank()) {
            return BigDecimal.ZERO;
        }
        try {
            return new BigDecimal(raw.replace("$", "").replace(",", "").trim());
        } catch (NumberFormatException e) {
            return BigDecimal.ZERO;
        }
    }

    private String lifecycleFromLegacyStatus(String status) {
        if ("ACCEPTED".equalsIgnoreCase(status)) {
            return "VALID";
        }
        if ("REJECTED".equalsIgnoreCase(status)) {
            return "REJECTED";
        }
        return "SUBMITTED";
    }

    private LeadOpsSummary buildLeadOpsSummary(List<Lead> leads) {
        if (leads == null || leads.isEmpty()) {
            return LeadOpsSummary.builder()
                    .totalLeads(0)
                    .expectedRevenue(BigDecimal.ZERO)
                    .actualRevenue(BigDecimal.ZERO)
                    .nextBottleneck("No leads captured yet.")
                    .build();
        }

        int submitted = 0;
        int valid = 0;
        int contacted = 0;
        int appointment = 0;
        int sold = 0;
        int rejected = 0;
        int refund = 0;
        int slaRisk = 0;
        BigDecimal expected = BigDecimal.ZERO;
        BigDecimal actual = BigDecimal.ZERO;

        for (Lead lead : leads) {
            String lifecycle = lead.getLifecycleStatus() == null ? "SUBMITTED" : lead.getLifecycleStatus().toUpperCase();
            switch (lifecycle) {
                case "VALID" -> valid++;
                case "CONTACTED" -> contacted++;
                case "APPOINTMENT" -> appointment++;
                case "SOLD" -> sold++;
                case "REJECTED" -> rejected++;
                default -> submitted++;
            }
            if (Boolean.TRUE.equals(lead.getChargebackStatus())
                    || lead.getRefundReason() != null && !lead.getRefundReason().isBlank()) {
                refund++;
            }
            if (lead.getResponseSlaMinutes() != null && lead.getResponseSlaMinutes() <= 60
                    && ("SUBMITTED".equals(lifecycle) || "VALID".equals(lifecycle))) {
                slaRisk++;
            }
            if (lead.getRevenueExpected() != null) {
                expected = expected.add(lead.getRevenueExpected());
            }
            if (lead.getRevenueActual() != null) {
                actual = actual.add(lead.getRevenueActual());
            }
        }

        return LeadOpsSummary.builder()
                .totalLeads(leads.size())
                .submittedCount(submitted)
                .validCount(valid)
                .contactedCount(contacted)
                .appointmentCount(appointment)
                .soldCount(sold)
                .rejectedCount(rejected)
                .refundCount(refund)
                .slaRiskCount(slaRisk)
                .expectedRevenue(expected)
                .actualRevenue(actual)
                .nextBottleneck(nextLeadBottleneck(submitted, valid, contacted, appointment, sold, rejected))
                .build();
    }

    private String nextLeadBottleneck(int submitted, int valid, int contacted, int appointment, int sold, int rejected) {
        if (submitted > 0) {
            return "Review submitted leads first: mark valid, rejected, duplicate, or unreachable.";
        }
        if (valid > contacted) {
            return "Speed-to-lead is the bottleneck: valid leads need contact status.";
        }
        if (contacted > appointment) {
            return "Qualification is the bottleneck: contacted leads need appointment outcome.";
        }
        if (appointment > sold) {
            return "Revenue close is the bottleneck: appointments need sold or lost reasons.";
        }
        if (rejected > 0) {
            return "Bad-fit feedback is available: inspect rejected reasons before buying more traffic.";
        }
        return "No obvious revenue bottleneck yet.";
    }

    static List<String> parseCsvColumns(String line) {
        List<String> columns = new ArrayList<>();
        if (line == null || line.isBlank()) {
            return columns;
        }

        StringBuilder current = new StringBuilder();
        boolean inQuotes = false;

        for (int i = 0; i < line.length(); i++) {
            char ch = line.charAt(i);

            if (ch == '"') {
                if (inQuotes && i + 1 < line.length() && line.charAt(i + 1) == '"') {
                    current.append('"');
                    i++;
                } else {
                    inQuotes = !inQuotes;
                }
                continue;
            }

            if (ch == ',' && !inQuotes) {
                columns.add(current.toString().trim());
                current.setLength(0);
                continue;
            }

            current.append(ch);
        }

        columns.add(current.toString().trim());
        return columns;
    }
}
