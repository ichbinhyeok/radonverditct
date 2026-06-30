package com.radonverdict.service;

import java.util.Locale;

public final class LeadScoringService {

    private LeadScoringService() {
    }

    public static LeadScore score(String intent, String resultBand, String contactPriority, String phone, Boolean hasTested) {
        int score = 20;
        String normalizedIntent = normalize(intent);
        String normalizedResult = normalize(resultBand);
        String normalizedPriority = normalize(contactPriority);
        boolean hasPhone = phone != null && !phone.isBlank();

        if ("above_4".equals(normalizedResult)) {
            score += 30;
        } else if ("between_2_and_4".equals(normalizedResult)) {
            score += 12;
        } else if ("not_tested".equals(normalizedResult)) {
            score -= 8;
        }

        if ("buying".equals(normalizedIntent) || "selling".equals(normalizedIntent)) {
            score += 24;
        } else if ("homeowner".equals(normalizedIntent) && "above_4".equals(normalizedResult)) {
            score += 12;
        }

        if ("urgent_24h".equals(normalizedPriority)) {
            score += 20;
        } else if ("this_week".equals(normalizedPriority)) {
            score += 9;
        }

        if (hasPhone) {
            score += 14;
        }
        if (Boolean.TRUE.equals(hasTested)) {
            score += 8;
        }

        score = Math.max(0, Math.min(100, score));
        String tier = score >= 82
                ? "HOT"
                : score >= 62
                ? "WARM"
                : score >= 38
                ? "NURTURE"
                : "TEST_FIRST";

        return new LeadScore(score, tier, nextAction(tier, normalizedIntent, normalizedResult, normalizedPriority, hasPhone));
    }

    private static String nextAction(String tier, String intent, String resultBand, String priority, boolean hasPhone) {
        if ("HOT".equals(tier) && hasPhone) {
            return "Call first, then email the quote/credit packet.";
        }
        if ("HOT".equals(tier)) {
            return "Email immediately and ask for phone availability.";
        }
        if ("WARM".equals(tier) && ("buying".equals(intent) || "selling".equals(intent))) {
            return "Send the seller-credit range and ask about inspection deadline.";
        }
        if ("WARM".equals(tier) && "above_4".equals(resultBand)) {
            return "Send local quote range and ask whether they want contractor intros.";
        }
        if ("urgent_24h".equals(priority)) {
            return "Reply today; confirm whether they have a valid test report.";
        }
        if ("not_tested".equals(resultBand)) {
            return "Send test-first guide and follow up after results.";
        }
        return "Send saved plan and keep in nurture follow-up.";
    }

    private static String normalize(String raw) {
        return raw == null ? "" : raw.trim().toLowerCase(Locale.US);
    }

    public record LeadScore(int score, String tier, String nextAction) {
    }
}
