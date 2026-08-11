package com.radonverdict.controller;

import com.radonverdict.service.EvidenceDatasetService;
import org.springframework.http.CacheControl;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.nio.charset.StandardCharsets;
import java.time.Duration;

@RestController
public class EvidenceDatasetController {

    private static final MediaType CSV = new MediaType("text", "csv", StandardCharsets.UTF_8);

    private final EvidenceDatasetService evidenceDatasetService;

    public EvidenceDatasetController(EvidenceDatasetService evidenceDatasetService) {
        this.evidenceDatasetService = evidenceDatasetService;
    }

    @GetMapping(value = "/datasets/us-county-radon-evidence.csv", produces = "text/csv")
    public ResponseEntity<String> countyEvidenceCsv() {
        return ResponseEntity.ok()
                .contentType(CSV)
                .cacheControl(CacheControl.maxAge(Duration.ofHours(1)).cachePublic())
                .header(HttpHeaders.CONTENT_DISPOSITION,
                        "attachment; filename=radonverdict-us-county-radon-evidence.csv")
                .body(evidenceDatasetService.countyEvidenceCsv());
    }
}
