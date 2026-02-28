package com.radonverdict.controller;

import com.radonverdict.model.dto.LeadSubmissionRequest;
import com.radonverdict.service.LeadService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.view.RedirectView;

import java.util.Locale;

@Slf4j
@Controller
@RequiredArgsConstructor
public class LeadController {

    private final LeadService leadService;

    @Value("${app.site.base-url:https://radonverdict.com}")
    private String baseUrl;

    @PostMapping("/submit-lead")
    public RedirectView submitLead(@Valid @ModelAttribute LeadSubmissionRequest request, BindingResult bindingResult,
            HttpServletRequest httpRequest,
            RedirectAttributes redirectAttributes) {

        if (request.getAdditionalPhone() != null && !request.getAdditionalPhone().isEmpty()) {
            log.warn("Spam bot detected via honeypot. IP: {}", httpRequest.getRemoteAddr());
            return redirectToCounty(request);
        }

        if (bindingResult.hasErrors()) {
            log.warn("Lead validation failed: {}", bindingResult.getAllErrors());
            redirectAttributes.addFlashAttribute("leadErrorMessage",
                    "Please check your input fields make sure they are correct.");
            return redirectToCounty(request);
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

        return redirectToCounty(request);
    }

    private RedirectView redirectToCounty(LeadSubmissionRequest request) {
        String stateSlug = normalizeUrlSegment(request.getStateSlug());
        String countySlug = normalizeUrlSegment(request.getCountySlug());

        if (stateSlug == null || countySlug == null) {
            RedirectView fallback = new RedirectView(normalizedBaseUrl() + "/radon-cost-calculator", false);
            fallback.setStatusCode(HttpStatus.SEE_OTHER);
            return fallback;
        }

        String target = normalizedBaseUrl() + "/radon-mitigation-cost/" + stateSlug + "/" + countySlug;
        RedirectView view = new RedirectView(target, false);
        view.setStatusCode(HttpStatus.SEE_OTHER);
        return view;
    }

    private String normalizedBaseUrl() {
        if (baseUrl == null || baseUrl.isBlank()) {
            return "https://radonverdict.com";
        }
        return baseUrl.endsWith("/") ? baseUrl.substring(0, baseUrl.length() - 1) : baseUrl;
    }

    private String normalizeUrlSegment(String raw) {
        if (raw == null || raw.isBlank()) {
            return null;
        }
        String normalized = raw.trim().toLowerCase(Locale.US);
        if (!normalized.matches("^[a-z0-9-]{2,80}$")) {
            return null;
        }
        return normalized;
    }
}
