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

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/telemetry")
public class TelemetryController {

    private final TelemetryEventService telemetryEventService;

    @PostMapping("/events")
    public ResponseEntity<Void> collectEvent(@RequestBody(required = false) Map<String, Object> payload,
            HttpServletRequest request) {
        String ip = request.getRemoteAddr();
        String userAgent = request.getHeader("User-Agent");

        String eventName = payload != null && payload.get("event") != null
                ? String.valueOf(payload.get("event"))
                : "unknown_event";

        String pagePath = payload != null && payload.get("path") != null
                ? String.valueOf(payload.get("path"))
                : request.getRequestURI();

        try {
            telemetryEventService.persistEvent(eventName, pagePath, ip, userAgent, payload);
        } catch (Exception e) {
            // Telemetry storage failure should not break user requests.
            log.warn("Failed to persist telemetry event, continuing. event={} path={}", eventName, pagePath, e);
        }

        log.info("telemetry_event event={} path={} ip={} ua={} payload={}",
                eventName, pagePath, ip, userAgent, payload);
        return ResponseEntity.noContent().build();
    }
}
