package com.radonverdict.controller;

import jakarta.servlet.http.HttpServletRequest;
import com.radonverdict.service.TelemetryEventService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;
import java.util.LinkedHashMap;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/telemetry")
public class TelemetryController {

    private final TelemetryEventService telemetryEventService;

    @PostMapping("/events")
    public ResponseEntity<Void> collectEvent(@RequestBody(required = false) Map<String, Object> payload,
            HttpServletRequest request) {
        String eventName = payload != null && payload.get("event") != null
                ? String.valueOf(payload.get("event"))
                : "unknown_event";

        String pagePath = payload != null && payload.get("path") != null
                ? String.valueOf(payload.get("path"))
                : request.getRequestURI();

        try {
            telemetryEventService.persistEvent(eventName, pagePath, null, null, eventPayload(payload));
        } catch (Exception e) {
            // Telemetry storage failure should not break user requests.
            log.warn("Failed to persist telemetry event, continuing. event={} path={}", eventName, pagePath, e);
        }

        log.debug("telemetry_event event={} path={}", eventName, pagePath);
        return ResponseEntity.noContent().build();
    }

    @SuppressWarnings("unchecked")
    private Map<String, Object> eventPayload(Map<String, Object> envelope) {
        if (envelope == null) return Map.of();
        Object nested = envelope.get("payload");
        if (nested instanceof Map<?, ?> nestedMap) {
            Map<String, Object> result = new LinkedHashMap<>();
            nestedMap.forEach((key, value) -> result.put(String.valueOf(key), value));
            return result;
        }
        Map<String, Object> result = new LinkedHashMap<>(envelope);
        result.remove("event");
        result.remove("path");
        result.remove("ts");
        return result;
    }
}
