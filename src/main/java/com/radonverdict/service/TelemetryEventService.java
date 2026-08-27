package com.radonverdict.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.Instant;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Set;

@Slf4j
@Service
@RequiredArgsConstructor
public class TelemetryEventService {

    private static final Set<String> PRODUCT_EVENTS = Set.of(
            "inspector_landing_view", "plan_completed", "share_created",
            "client_share_opened", "share_copy_succeeded", "handoff_action_copied");
    private static final Set<String> PRODUCT_PAYLOAD_KEYS = Set.of(
            "schema_version", "result_band", "intent", "source");

    private static final Set<String> FORBIDDEN_KEYS = Set.of(
            "ip", "ip_address", "user_agent", "ua", "email", "phone", "name", "address",
            "street", "radon_reading", "reading", "zip", "zip_code");

    @Value("${app.storage.product-events-csv-path:${app.storage.telemetry-csv-path:data/product_events.csv}}")
    private String telemetryCsvPath;

    @Value("${app.storage.telemetry-csv-path:data/telemetry_events.csv}")
    private String legacyTelemetryCsvPath;

    private final ObjectMapper objectMapper;
    private final Object writeLock = new Object();

    public void persistEvent(
            String eventName,
            String pagePath,
            String ipAddress,
            String userAgent,
            Map<String, Object> payload) {
        try {
            synchronized (writeLock) {
                Path path = Paths.get(PRODUCT_EVENTS.contains(eventName) ? telemetryCsvPath : legacyTelemetryCsvPath);
                if (path.getParent() != null) {
                    Files.createDirectories(path.getParent());
                }
                boolean isNewFile = !Files.exists(path);

                try (PrintWriter pw = new PrintWriter(new FileWriter(path.toFile(), true))) {
                    if (isNewFile) {
                        pw.println("Timestamp,Event,Path,SchemaVersion,PayloadJson");
                    }

                    Map<String, Object> safePayload = privacySafePayload(payload, PRODUCT_EVENTS.contains(eventName));
                    pw.printf("\"%s\",\"%s\",\"%s\",\"%s\",\"%s\"%n",
                            Instant.now(),
                            escapeCsv(eventName),
                            escapeCsv(safePath(pagePath)),
                            escapeCsv(String.valueOf(safePayload.getOrDefault("schema_version", 1))),
                            escapeCsv(toJson(safePayload)));
                }
            }
        } catch (IOException e) {
            log.error("Failed to write telemetry event to CSV", e);
            throw new RuntimeException("Could not persist telemetry event", e);
        }
    }

    private Map<String, Object> privacySafePayload(Map<String, Object> payload, boolean productEvent) {
        if (payload == null || payload.isEmpty()) return Map.of("schema_version", 1);
        Map<String, Object> safe = new LinkedHashMap<>();
        safe.put("schema_version", bounded(payload.getOrDefault("schema_version", 1)));
        payload.forEach((key, value) -> {
            String normalizedKey = key == null ? "" : key.trim().toLowerCase();
            if (!normalizedKey.isBlank() && !FORBIDDEN_KEYS.contains(normalizedKey)
                    && (!productEvent || PRODUCT_PAYLOAD_KEYS.contains(normalizedKey))
                    && normalizedKey.matches("[a-z0-9_]{1,48}")) {
                safe.put(normalizedKey, boundedAndScrubbed(value));
            }
        });
        return Map.copyOf(safe);
    }

    private Object bounded(Object value) {
        if (value instanceof Number || value instanceof Boolean) return value;
        String text = value == null ? "" : String.valueOf(value);
        return text.substring(0, Math.min(text.length(), 120));
    }

    private Object boundedAndScrubbed(Object value) {
        Object bounded = bounded(value);
        if (!(bounded instanceof String text)) return bounded;
        return text.replaceAll("(?<![A-Za-z0-9_-])[A-Za-z0-9_-]{43}(?![A-Za-z0-9_-])", ":token");
    }

    private String safePath(String value) {
        if (value == null || value.isBlank()) return "/";
        String path = value.split("\\?", 2)[0];
        if (path.matches("/plan/share/[A-Za-z0-9_-]{43}")) return "/plan/share/:token";
        return path.matches("/[A-Za-z0-9/_-]{0,180}") ? path : "/";
    }

    private String toJson(Map<String, Object> payload) {
        try {
            return objectMapper.writeValueAsString(payload != null ? payload : Map.of());
        } catch (JsonProcessingException e) {
            log.warn("Failed to serialize telemetry payload, using toString fallback", e);
            return String.valueOf(payload);
        }
    }

    private String escapeCsv(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("\"", "\"\"");
    }
}
