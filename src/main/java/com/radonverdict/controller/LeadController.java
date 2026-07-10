package com.radonverdict.controller;

import com.radonverdict.model.dto.LeadSubmissionRequest;
import com.radonverdict.service.LeadScoringService;
import com.radonverdict.service.LeadService;
import com.radonverdict.service.TelemetryEventService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.util.UriComponentsBuilder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.view.RedirectView;

import java.util.Locale;
import java.util.Map;

@Slf4j
@Controller
@RequiredArgsConstructor
public class LeadController {

    private final LeadService leadService;
    private final TelemetryEventService telemetryEventService;

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

        try {
            LeadScoringService.LeadScore leadScore = leadService.submitLead(request, ipAddress, userAgent);
            telemetryEventService.persistEvent("lead_submit_success", "/submit-lead", ipAddress, userAgent, Map.of(
                    "event", "lead_submit_success",
                    "lead_source", "county_action_plan_form",
                    "state", safeTelemetryValue(request.getStateSlug()),
                    "state_abbr", safeTelemetryValue(request.getStateAbbr()),
                    "county", safeTelemetryValue(request.getCountySlug()),
                    "intent", safeTelemetryValue(request.getSelectedIntent()),
                    "result_band", safeTelemetryValue(request.getSelectedRadonResultBand()),
                    "foundation", safeTelemetryValue(request.getFoundationType()),
                    "lead_tier", safeTelemetryValue(leadScore.tier()),
                    "lead_score", leadScore.score()));
            log.info("Successfully received lead for {}, {}", request.getCountySlug(), request.getStateAbbr());

            // Add flash attribute to show a thank you message on redirect
            redirectAttributes.addFlashAttribute("leadSuccessMessage",
                    "Thank you. We saved your scenario, priority, and local context so follow-up can focus on the quote or credit decision.");

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
        String intent = normalizeQueryValue(request.getSelectedIntent());
        String resultBand = normalizeQueryValue(request.getSelectedRadonResultBand());

        if (stateSlug == null || countySlug == null) {
            RedirectView fallback = new RedirectView("/radon-cost-calculator", true);
            fallback.setStatusCode(HttpStatus.SEE_OTHER);
            return fallback;
        }

        UriComponentsBuilder targetBuilder = UriComponentsBuilder
                .fromPath("/radon-mitigation-cost/" + stateSlug + "/" + countySlug);

        if (intent != null) {
            targetBuilder.queryParam("intent", intent);
        }
        if (resultBand != null) {
            targetBuilder.queryParam("radonResultBand", resultBand);
        }
        String zipCode = normalizeZip(request.getZipCode());
        if (zipCode != null) {
            targetBuilder.queryParam("zipCode", zipCode);
        }

        String target = targetBuilder
                .fragment("estimate-form")
                .build()
                .toUriString();
        RedirectView view = new RedirectView(target, true);
        view.setStatusCode(HttpStatus.SEE_OTHER);
        return view;
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

    private String safeTelemetryValue(String value) {
        if (value == null || value.isBlank()) {
            return "";
        }
        return value.trim().replaceAll("[^A-Za-z0-9_\\- ]", "").toLowerCase(Locale.US);
    }

    private String normalizeQueryValue(String raw) {
        if (raw == null || raw.isBlank()) {
            return null;
        }
        String normalized = raw.trim().toLowerCase(Locale.US);
        if (!normalized.matches("^[a-z0-9_-]{2,40}$")) {
            return null;
        }
        return normalized;
    }

    private String normalizeZip(String raw) {
        if (raw == null || raw.isBlank()) {
            return null;
        }
        String normalized = raw.trim();
        return normalized.matches("^\\d{5}$") ? normalized : null;
    }
}
