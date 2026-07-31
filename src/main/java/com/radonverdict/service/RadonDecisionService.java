package com.radonverdict.service;

import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;

@Service
public class RadonDecisionService {

    public Decision decide(String rawReading, boolean noTest, String intent) {
        String safeIntent = normalizeIntent(intent);
        if (noTest || rawReading == null || rawReading.isBlank()) {
            return new Decision(
                    "not_tested",
                    "No test result entered",
                    "Test before making a mitigation or transaction decision",
                    "County data cannot predict the result in a particular home.",
                    actionsForNoTest(safeIntent),
                    null);
        }

        BigDecimal reading;
        try {
            String normalized = rawReading.trim();
            if (!normalized.matches("(?:\\d+(?:\\.\\d+)?|\\.\\d+)")) {
                throw new NumberFormatException("unsupported format");
            }
            reading = new BigDecimal(normalized);
        } catch (NumberFormatException ex) {
            return invalid(rawReading, safeIntent);
        }

        if (reading.signum() < 0 || reading.compareTo(BigDecimal.valueOf(999)) > 0) {
            return invalid(rawReading, safeIntent);
        }

        String display = reading.stripTrailingZeros().toPlainString() + " pCi/L";
        if (reading.compareTo(BigDecimal.valueOf(2)) < 0) {
            return new Decision(
                    "under_2", display, "Lower reading — keep the result and testing context",
                    "A result below 2.0 pCi/L is lower, but it is not a prediction of future readings.",
                    List.of("Save the report and test conditions.", "Retest when the building or occupancy conditions materially change."),
                    null);
        }
        if (reading.compareTo(BigDecimal.valueOf(4)) < 0) {
            return new Decision(
                    "between_2_and_4", display, "Below 4.0, but worth a deliberate follow-up",
                    "This result is below the EPA action level. A follow-up or longer-term test can reduce uncertainty.",
                    List.of("Check the test duration and placement.", "Plan a follow-up or long-term test before committing to work."),
                    null);
        }

        return new Decision(
                "above_4", display, "At or above the EPA action level",
                "Confirm the result according to the test type, then plan the next step. This page does not invent a local price.",
                actionsForElevated(safeIntent),
                null);
    }

    private Decision invalid(String rawReading, String intent) {
        return new Decision(
                "invalid", rawReading, "Check the radon result",
                "Enter a numeric result from 0 to 999 pCi/L. An invalid value is never treated as an elevated result.",
                List.of("Correct the result or choose no test yet."),
                "Enter a valid radon result between 0 and 999 pCi/L.");
    }

    private List<String> actionsForNoTest(String intent) {
        if ("buying".equals(intent) || "selling".equals(intent)) {
            return List.of("Arrange a valid test before the transaction deadline.", "Record the device, duration, placement, and result.");
        }
        return List.of("Start with a valid short-term or long-term radon test.", "Record the device, duration, placement, and result.");
    }

    private List<String> actionsForElevated(String intent) {
        if ("buying".equals(intent)) {
            return List.of("Confirm the test conditions and deadline.", "Ask for comparable written mitigation quotes before setting a credit.", "Keep contractor choice independent from the inspector.");
        }
        if ("selling".equals(intent)) {
            return List.of("Confirm the test conditions.", "Compare repair and credit options using written quotes.", "Document the agreed scope and post-mitigation test." );
        }
        return List.of("Confirm the result according to the test type.", "Request comparable written mitigation quotes.", "Plan a post-mitigation test." );
    }

    private String normalizeIntent(String intent) {
        if (intent == null) return "homeowner";
        return switch (intent.toLowerCase()) {
            case "buying", "selling" -> intent.toLowerCase();
            default -> "homeowner";
        };
    }

    public record Decision(
            String resultBand,
            String readingDisplay,
            String verdictHeadline,
            String interpretation,
            List<String> actions,
            String validationError) {
    }
}
