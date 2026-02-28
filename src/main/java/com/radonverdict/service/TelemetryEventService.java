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
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class TelemetryEventService {

    @Value("${app.storage.telemetry-csv-path:data/telemetry_events.csv}")
    private String telemetryCsvPath;

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
                Path path = Paths.get(telemetryCsvPath);
                if (path.getParent() != null) {
                    Files.createDirectories(path.getParent());
                }
                boolean isNewFile = !Files.exists(path);

                try (PrintWriter pw = new PrintWriter(new FileWriter(path.toFile(), true))) {
                    if (isNewFile) {
                        pw.println("Date,Event,Path,IpAddress,UserAgent,PayloadJson");
                    }

                    String date = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
                    pw.printf("\"%s\",\"%s\",\"%s\",\"%s\",\"%s\",\"%s\"%n",
                            date,
                            escapeCsv(eventName),
                            escapeCsv(pagePath),
                            escapeCsv(ipAddress),
                            escapeCsv(userAgent),
                            escapeCsv(toJson(payload)));
                }
            }
        } catch (IOException e) {
            log.error("Failed to write telemetry event to CSV", e);
            throw new RuntimeException("Could not persist telemetry event", e);
        }
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
