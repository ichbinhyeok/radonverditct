package com.radonverdict.controller;

import com.radonverdict.model.entity.Lead;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.view.RedirectView;

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

    @GetMapping("/admin")
    public RedirectView adminIndex() {
        return new RedirectView("/admin/leads");
    }

    @GetMapping("/admin/leads")
    public String viewLeads(Model model) {
        model.addAttribute("title", "Admin | Leads Dashboard");

        model.addAttribute("leads", loadLeads());
        return "pages/admin_leads";
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

        return Lead.builder()
                .submittedAt(submittedAt)
                .customerName(cols.get(1))
                .customerPhone(cols.get(2))
                .customerEmail(cols.get(3).isBlank() ? null : cols.get(3))
                .zipCode(cols.get(4))
                .stateAbbr(cols.get(5))
                .countySlug(cols.get(6))
                .foundationType(cols.get(7).isBlank() ? null : cols.get(7))
                .isTested(cols.get(8).isBlank() ? null : Boolean.parseBoolean(cols.get(8)))
                .build();
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
