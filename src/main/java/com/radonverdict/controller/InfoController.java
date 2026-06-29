package com.radonverdict.controller;

import com.radonverdict.model.dto.ContactSubmissionRequest;
import com.radonverdict.model.dto.EvidenceSourceRow;
import com.radonverdict.service.ContactMessageService;
import com.radonverdict.service.DataLoadService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.view.RedirectView;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;

@Controller
@RequiredArgsConstructor
public class InfoController {

    private final ContactMessageService contactMessageService;
    private final DataLoadService dataLoadService;

    @Value("${app.content.privacy-last-updated:February 1, 2026}")
    private String privacyLastUpdated;

    @GetMapping("/about")
    public String about(Model model) {
        model.addAttribute("title", "About Us | RadonVerdict");
        return "pages/about";
    }

    @GetMapping("/methodology")
    public String methodology(Model model) {
        model.addAttribute("title", "Methodology | RadonVerdict");
        return "pages/methodology";
    }

    @GetMapping("/radon-data-sources")
    public String radonDataSources(Model model) {
        model.addAttribute("title", "Radon Data Sources & Evidence Policy | RadonVerdict");
        model.addAttribute("measurementCountyCount", dataLoadService.getRadonMeasurementByFipsMap().size());
        model.addAttribute("tierCountyCount", dataLoadService.getRadonTierByFipsMap().size());
        model.addAttribute("zipMappingCount", dataLoadService.getZipToFipsMap().size());
        model.addAttribute("referenceSourceCount",
                dataLoadService.getReferenceSources() != null ? dataLoadService.getReferenceSources().size() : 0);
        model.addAttribute("sourceRows", buildEvidenceSourceRows());
        return "pages/radon_data_sources";
    }

    @GetMapping("/privacy")
    public String privacy(Model model) {
        model.addAttribute("title", "Privacy Policy | RadonVerdict");
        model.addAttribute("privacyLastUpdated", privacyLastUpdated);
        return "pages/privacy";
    }

    @GetMapping("/terms")
    public String terms(Model model) {
        model.addAttribute("title", "Terms & Conditions | RadonVerdict");
        return "pages/terms";
    }

    @GetMapping("/contact")
    public String contact(Model model) {
        model.addAttribute("title", "Contact Us | RadonVerdict");
        if (!model.containsAttribute("contactForm")) {
            model.addAttribute("contactForm", new ContactSubmissionRequest());
        }
        return "pages/contact";
    }

    @PostMapping("/contact")
    public RedirectView submitContact(
            @Valid @ModelAttribute("contactForm") ContactSubmissionRequest request,
            BindingResult bindingResult,
            HttpServletRequest httpRequest,
            RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            redirectAttributes.addFlashAttribute("contactErrorMessage",
                    "Please fill out your name, email, and message.");
            redirectAttributes.addFlashAttribute("contactForm", request);
            return contactRedirect();
        }

        try {
            contactMessageService.submit(request, httpRequest.getRemoteAddr(), httpRequest.getHeader("User-Agent"));
            redirectAttributes.addFlashAttribute("contactSuccessMessage",
                    "Thanks. Your message was received and queued for review.");
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("contactErrorMessage",
                    "We could not save your message right now. Please email shinhyeok22@gmail.com instead.");
            redirectAttributes.addFlashAttribute("contactForm", request);
        }

        return contactRedirect();
    }

    private RedirectView contactRedirect() {
        RedirectView view = new RedirectView("/contact", true);
        view.setStatusCode(HttpStatus.SEE_OTHER);
        return view;
    }

    private List<EvidenceSourceRow> buildEvidenceSourceRows() {
        Map<String, SourceAccumulator> grouped = new LinkedHashMap<>();

        dataLoadService.getRadonMeasurementByFipsMap().values().forEach(measurement -> {
            if (measurement == null || measurement.getSourceName() == null || measurement.getSourceName().isBlank()) {
                return;
            }
            String key = "measurement|" + measurement.getSourceName() + "|" + measurement.getSourceUrl();
            SourceAccumulator accumulator = grouped.computeIfAbsent(key,
                    ignored -> new SourceAccumulator(measurement.getSourceName(), measurement.getSourceUrl(),
                            "County measurement summary"));
            accumulator.count++;
            if (measurement.getPeriod() != null && !measurement.getPeriod().isBlank()) {
                accumulator.periods.add(measurement.getPeriod());
            }
            if (measurement.getCaveat() != null && !measurement.getCaveat().isBlank()) {
                accumulator.caveat = measurement.getCaveat();
            }
        });

        dataLoadService.getRadonTierByFipsMap().values().forEach(tier -> {
            if (tier == null || tier.getSourceName() == null || tier.getSourceName().isBlank()) {
                return;
            }
            String key = "tier|" + tier.getSourceName() + "|" + tier.getSourceUrl();
            SourceAccumulator accumulator = grouped.computeIfAbsent(key,
                    ignored -> new SourceAccumulator(tier.getSourceName(), tier.getSourceUrl(),
                            "Official radon-potential tier"));
            accumulator.count++;
            if (tier.getRetrievedAt() != null && !tier.getRetrievedAt().isBlank()) {
                accumulator.periods.add("retrieved " + tier.getRetrievedAt());
            }
            if (tier.getCaveat() != null && !tier.getCaveat().isBlank()) {
                accumulator.caveat = tier.getCaveat();
            }
        });

        return grouped.values().stream()
                .map(SourceAccumulator::toRow)
                .sorted(Comparator
                        .comparingInt(EvidenceSourceRow::getCountyCount).reversed()
                        .thenComparing(EvidenceSourceRow::getSourceName))
                .limit(12)
                .toList();
    }

    private static class SourceAccumulator {
        private final String sourceName;
        private final String sourceUrl;
        private final String evidenceType;
        private final LinkedHashSet<String> periods = new LinkedHashSet<>();
        private int count;
        private String caveat;

        private SourceAccumulator(String sourceName, String sourceUrl, String evidenceType) {
            this.sourceName = sourceName;
            this.sourceUrl = sourceUrl;
            this.evidenceType = evidenceType;
        }

        private EvidenceSourceRow toRow() {
            List<String> periodList = new ArrayList<>(periods);
            String periodLabel = periodList.isEmpty()
                    ? "Source-specific"
                    : periodList.size() == 1
                    ? periodList.get(0)
                    : "Varies by county";
            String caveatSummary = caveat != null && !caveat.isBlank()
                    ? caveat
                    : "Used as county context only; a valid home test controls property-level decisions.";

            return EvidenceSourceRow.builder()
                    .sourceName(sourceName)
                    .sourceUrl(sourceUrl)
                    .evidenceType(evidenceType)
                    .periodLabel(periodLabel)
                    .countyCount(count)
                    .caveatSummary(caveatSummary)
                    .build();
        }
    }
}
