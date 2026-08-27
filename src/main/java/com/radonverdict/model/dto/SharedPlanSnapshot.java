package com.radonverdict.model.dto;

import java.time.Instant;
import java.util.List;

public record SharedPlanSnapshot(
        int schemaVersion,
        String decisionVersion,
        String dataVersion,
        Instant createdAt,
        Instant expiresAt,
        String zipCode,
        String countyName,
        String stateAbbr,
        String readingDisplay,
        String resultBand,
        String intentLabel,
        String verdictHeadline,
        String interpretation,
        List<String> actions,
        String evidenceSummary,
        String evidenceSourceName,
        String evidenceSourceUrl,
        String evidencePeriod) {
}
