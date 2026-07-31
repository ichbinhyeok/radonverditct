package com.radonverdict.service;

import com.radonverdict.model.County;
import com.radonverdict.model.dto.RadonActionPlan;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Locale;

@Service
@RequiredArgsConstructor
public class ActionPlanService {
    private final DataLoadService dataLoadService;
    private final CountyRadonEvidenceService countyRadonEvidenceService;
    private final RadonDecisionService radonDecisionService;

    public RadonActionPlan build(String zipCode, String radonReading, boolean noTest, String intent, String source) {
        String normalizedZip = zipCode == null ? "" : zipCode.trim();
        String normalizedIntent = normalizeIntent(intent);
        RadonDecisionService.Decision decision = radonDecisionService.decide(radonReading, noTest, normalizedIntent);

        County county = null;
        String locationMessage = null;
        if (!normalizedZip.isBlank()) {
            if (!normalizedZip.matches("\\d{5}")) {
                locationMessage = "Enter a five-digit ZIP code.";
            } else {
                String fips = dataLoadService.getZipToFipsMap().get(normalizedZip);
                county = fips == null ? null : dataLoadService.getCountByFipsMap().get(fips);
                if (county == null) {
                    locationMessage = "We could not match that ZIP to a primary county. No local estimate was substituted.";
                }
            }
        }

        return RadonActionPlan.builder()
                .zipCode(normalizedZip)
                .rawReading(radonReading == null ? "" : radonReading.trim())
                .intent(normalizedIntent)
                .intentLabel(intentLabel(normalizedIntent))
                .source(sanitizeSource(source))
                .resultBand(decision.resultBand())
                .readingDisplay(decision.readingDisplay())
                .verdictHeadline(decision.verdictHeadline())
                .interpretation(decision.interpretation())
                .actions(decision.actions())
                .validationError(decision.validationError())
                .locationMessage(locationMessage)
                .county(county)
                .evidence(county == null ? null : countyRadonEvidenceService.buildEvidence(county))
                .measurement(county == null ? null : dataLoadService.getRadonMeasurementByFipsMap().get(county.getFips()))
                .build();
    }

    private String normalizeIntent(String intent) {
        if (intent == null) return "homeowner";
        return switch (intent.toLowerCase(Locale.ROOT)) {
            case "buying", "selling" -> intent.toLowerCase(Locale.ROOT);
            default -> "homeowner";
        };
    }

    private String intentLabel(String intent) {
        return switch (intent) {
            case "buying" -> "Buying";
            case "selling" -> "Selling";
            default -> "Living here";
        };
    }

    private String sanitizeSource(String source) {
        if (source == null || source.isBlank()) return null;
        String safe = source.toLowerCase(Locale.ROOT).replaceAll("[^a-z0-9_-]", "");
        return safe.isBlank() ? null : safe.substring(0, Math.min(64, safe.length()));
    }
}
