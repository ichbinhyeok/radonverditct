package com.radonverdict.service;

import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;

import java.io.InputStream;
import java.security.MessageDigest;
import java.util.HexFormat;
import java.util.List;

@Service
public class DataVersionService {
    private static final List<String> VERSIONED_RESOURCES = List.of(
            "data/geo_counties.json",
            "data/zip_primary_county.json",
            "data/county_radon_measurements.json",
            "data/county_radon_tiers.json",
            "data/radon_measurement_sources.json");

    private final String version;

    public DataVersionService() {
        this.version = calculateVersion();
    }

    public String version() {
        return version;
    }

    private String calculateVersion() {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] buffer = new byte[8192];
            for (String resourceName : VERSIONED_RESOURCES) {
                digest.update(resourceName.getBytes(java.nio.charset.StandardCharsets.UTF_8));
                try (InputStream input = new ClassPathResource(resourceName).getInputStream()) {
                    int read;
                    while ((read = input.read(buffer)) >= 0) {
                        digest.update(buffer, 0, read);
                    }
                }
            }
            return HexFormat.of().formatHex(digest.digest()).substring(0, 16);
        } catch (Exception exception) {
            throw new IllegalStateException("Could not version the evidence dataset", exception);
        }
    }
}
