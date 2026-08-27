package com.radonverdict.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.radonverdict.model.dto.RadonActionPlan;
import com.radonverdict.model.dto.SharedPlanSnapshot;
import com.radonverdict.model.entity.PlanShare;
import com.radonverdict.repository.PlanShareRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.security.MessageDigest;
import java.security.SecureRandom;
import java.time.Duration;
import java.time.Instant;
import java.util.Base64;
import java.util.HexFormat;

@Service
@RequiredArgsConstructor
public class PlanShareService {
    public static final String DECISION_VERSION = "2026-08-27-v1";
    private static final Duration SHARE_LIFETIME = Duration.ofDays(30);
    private static final SecureRandom RANDOM = new SecureRandom();

    private final PlanShareRepository repository;
    private final ObjectMapper objectMapper;
    private final DataVersionService dataVersionService;

    @Transactional
    public CreatedShare create(RadonActionPlan plan) {
        if (plan == null || plan.hasValidationError()) {
            throw new IllegalArgumentException("A valid plan is required before sharing");
        }

        Instant createdAt = Instant.now();
        repository.deleteByExpiresAtBefore(createdAt);
        Instant expiresAt = createdAt.plus(SHARE_LIFETIME);
        String token = newToken();
        SharedPlanSnapshot snapshot = snapshot(plan, createdAt, expiresAt);
        repository.save(PlanShare.builder()
                .tokenHash(hash(token))
                .snapshotJson(writeSnapshot(snapshot))
                .createdAt(createdAt)
                .expiresAt(expiresAt)
                .build());
        return new CreatedShare(token, snapshot);
    }

    @Transactional(readOnly = true)
    public Lookup lookup(String token) {
        if (token == null || !token.matches("^[A-Za-z0-9_-]{43}$")) {
            return new Lookup(Status.NOT_FOUND, null);
        }
        return repository.findByTokenHash(hash(token))
                .map(entity -> {
                    if (entity.isRevoked()) return new Lookup(Status.REVOKED, null);
                    if (!entity.getExpiresAt().isAfter(Instant.now())) return new Lookup(Status.EXPIRED, null);
                    return new Lookup(Status.FOUND, readSnapshot(entity.getSnapshotJson()));
                })
                .orElseGet(() -> new Lookup(Status.NOT_FOUND, null));
    }

    private SharedPlanSnapshot snapshot(RadonActionPlan plan, Instant createdAt, Instant expiresAt) {
        String countyName = plan.hasCounty() ? plan.getCounty().getAreaDisplayName() : null;
        String stateAbbr = plan.hasCounty() ? plan.getCounty().getStateAbbr() : null;
        String evidenceSummary = plan.getEvidence() != null ? plan.getEvidence().getMeasuredBurdenSummary() : null;
        String sourceName = plan.getMeasurement() != null ? plan.getMeasurement().getSourceName() : null;
        String sourceUrl = plan.getMeasurement() != null ? plan.getMeasurement().getSourceUrl() : null;
        String period = plan.getMeasurement() != null ? plan.getMeasurement().getPeriod() : null;
        return new SharedPlanSnapshot(
                1,
                DECISION_VERSION,
                dataVersionService.version(),
                createdAt,
                expiresAt,
                plan.getZipCode(),
                countyName,
                stateAbbr,
                plan.getReadingDisplay(),
                plan.getResultBand(),
                plan.getIntentLabel(),
                plan.getVerdictHeadline(),
                plan.getInterpretation(),
                java.util.List.copyOf(plan.getActions()),
                evidenceSummary,
                sourceName,
                sourceUrl,
                period);
    }

    private String newToken() {
        byte[] bytes = new byte[32];
        RANDOM.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }

    private String hash(String token) {
        try {
            return HexFormat.of().formatHex(MessageDigest.getInstance("SHA-256")
                    .digest(token.getBytes(java.nio.charset.StandardCharsets.UTF_8)));
        } catch (Exception exception) {
            throw new IllegalStateException("Could not hash plan-share token", exception);
        }
    }

    private String writeSnapshot(SharedPlanSnapshot snapshot) {
        try {
            return objectMapper.writeValueAsString(snapshot);
        } catch (JsonProcessingException exception) {
            throw new IllegalStateException("Could not serialize plan-share snapshot", exception);
        }
    }

    private SharedPlanSnapshot readSnapshot(String json) {
        try {
            return objectMapper.readValue(json, SharedPlanSnapshot.class);
        } catch (JsonProcessingException exception) {
            throw new IllegalStateException("Stored plan-share snapshot is unreadable", exception);
        }
    }

    public enum Status { FOUND, EXPIRED, REVOKED, NOT_FOUND }
    public record CreatedShare(String token, SharedPlanSnapshot snapshot) { }
    public record Lookup(Status status, SharedPlanSnapshot snapshot) { }
}
