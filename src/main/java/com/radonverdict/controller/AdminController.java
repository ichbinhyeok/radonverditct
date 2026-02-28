package com.radonverdict.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@Slf4j
@Controller
@RequiredArgsConstructor
public class AdminController {

    @Value("${app.storage.leads-csv-path:data/leads.csv}")
    private String leadsCsvPath;

    @GetMapping("/admin/leads")
    public String viewLeads(Model model) {
        model.addAttribute("title", "Admin | Leads Dashboard");

        List<String[]> leadsList = new ArrayList<>();
        try {
            Path path = Paths.get(leadsCsvPath);
            if (Files.exists(path)) {
                List<String> lines = Files.readAllLines(path);
                // Skip header logic implicitly if reversing, or deal with it.
                if (!lines.isEmpty()) {
                    // Remove header
                    lines.remove(0);
                    for (String line : lines) {
                        // Very naive CSV split by ","
                        String[] cols = line.split("\",\"");
                        for (int i = 0; i < cols.length; i++) {
                            cols[i] = cols[i].replace("\"", "");
                        }
                        leadsList.add(cols);
                    }
                    Collections.reverse(leadsList); // Latest first
                }
            }
        } catch (Exception e) {
            log.error("Error reading leads CSV", e);
        }

        model.addAttribute("leadsList", leadsList);
        return "pages/admin_leads";
    }
}
