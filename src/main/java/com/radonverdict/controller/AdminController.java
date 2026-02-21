package com.radonverdict.controller;

import com.radonverdict.repository.LeadRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
@RequiredArgsConstructor
public class AdminController {

    private final LeadRepository leadRepository;

    @GetMapping("/admin/leads")
    public String viewLeads(Model model) {
        model.addAttribute("title", "Admin | Leads Dashboard");
        // Sort by submittedAt descending
        model.addAttribute("leads", leadRepository.findAll(Sort.by(Sort.Direction.DESC, "submittedAt")));
        return "pages/admin_leads";
    }
}
