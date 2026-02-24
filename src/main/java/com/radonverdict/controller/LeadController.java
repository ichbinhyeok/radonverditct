package com.radonverdict.controller;

import com.radonverdict.model.dto.LeadSubmissionRequest;
import com.radonverdict.service.LeadService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Slf4j
@Controller
@RequiredArgsConstructor
public class LeadController {

    private final LeadService leadService;

    @PostMapping("/submit-lead")
    public String submitLead(@Valid @ModelAttribute LeadSubmissionRequest request, BindingResult bindingResult,
            HttpServletRequest httpRequest,
            RedirectAttributes redirectAttributes) {

        if (request.getAdditionalPhone() != null && !request.getAdditionalPhone().isEmpty()) {
            log.warn("Spam bot detected via honeypot. IP: {}", httpRequest.getRemoteAddr());
            return "redirect:/radon-mitigation-cost/" + request.getStateAbbr() + "/" + request.getCountySlug();
        }

        if (bindingResult.hasErrors()) {
            log.warn("Lead validation failed: {}", bindingResult.getAllErrors());
            redirectAttributes.addFlashAttribute("leadErrorMessage",
                    "Please check your input fields make sure they are correct.");
            return "redirect:/radon-mitigation-cost/" + request.getStateAbbr() + "/" + request.getCountySlug();
        }

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
                    "Thank you! We've received your information. A local expert will contact you when coverage is available in your area.");

        } catch (Exception e) {
            log.error("Failed to save lead: ", e);
            redirectAttributes.addFlashAttribute("leadErrorMessage",
                    "There was an error submitting your request. Please try again later.");
        }

        return "redirect:/radon-mitigation-cost/" + request.getStateAbbr() + "/" + request.getCountySlug();
    }
}
