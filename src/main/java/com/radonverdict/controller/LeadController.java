package com.radonverdict.controller;

import com.radonverdict.model.dto.LeadSubmissionRequest;
import com.radonverdict.service.LeadService;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Slf4j
@Controller
@RequiredArgsConstructor
public class LeadController {

    private final LeadService leadService;

    @PostMapping("/submit-lead")
    public String submitLead(@ModelAttribute LeadSubmissionRequest request, HttpServletRequest httpRequest,
            RedirectAttributes redirectAttributes) {

        String ipAddress = httpRequest.getRemoteAddr();
        String userAgent = httpRequest.getHeader("User-Agent");

        // Set default consent version if missing
        if (request.getConsentVersion() == null || request.getConsentVersion().isEmpty()) {
            request.setConsentVersion("v1.0");
        }

        try {
            leadService.submitLead(request, ipAddress, userAgent);
            log.info("Successfully received lead for {}, {}", request.getCountySlug(), request.getStateAbbr());

            // Add flash attribute to show a thank you message on redirect
            redirectAttributes.addFlashAttribute("leadSuccessMessage",
                    "Thank you! We're currently reviewing contractors in your area to ensure you get the best quote. A local expert will contact you within 48 hours.");

        } catch (Exception e) {
            log.error("Failed to save lead: ", e);
            redirectAttributes.addFlashAttribute("leadErrorMessage",
                    "There was an error submitting your request. Please try again later.");
        }

        return "redirect:/radon-mitigation-cost/" + request.getStateAbbr() + "/" + request.getCountySlug();
    }
}
