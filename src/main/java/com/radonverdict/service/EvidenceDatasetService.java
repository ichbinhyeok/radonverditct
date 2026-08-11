package com.radonverdict.service;

import com.radonverdict.model.County;
import com.radonverdict.model.CountyRadonMeasurement;
import com.radonverdict.model.CountyRadonTier;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.Comparator;

@Service
public class EvidenceDatasetService {

    private static final String DATASET_HEADER = String.join(",",
            "county_fips", "state_abbr", "county_name", "state_slug", "county_slug", "epa_zone",
            "evidence_type", "period", "retrieved_at", "total_tests", "average_test_result_pci_l",
            "percent_tests_at_or_above_4_pci_l", "municipality_count", "tier_1_pct", "tier_1_or_2_pct",
            "dominant_tier", "source_name", "source_url", "caveat", "county_page_url");

    private final DataLoadService dataLoadService;

    public EvidenceDatasetService(DataLoadService dataLoadService) {
        this.dataLoadService = dataLoadService;
    }

    public String countyEvidenceCsv() {
        StringBuilder csv = new StringBuilder(DATASET_HEADER).append("\r\n");

        dataLoadService.getCountByFipsMap().values().stream()
                .sorted(Comparator.comparing(County::getFips))
                .forEach(county -> appendEvidenceRows(csv, county));

        return csv.toString();
    }

    private void appendEvidenceRows(StringBuilder csv, County county) {
        CountyRadonMeasurement measurement = dataLoadService.getRadonMeasurementByFipsMap().get(county.getFips());
        if (measurement != null) {
            CountyRadonMeasurement.Metrics metrics = measurement.getMetrics();
            appendRow(csv,
                    county.getFips(), county.getStateAbbr(), county.getCountyName(), county.getStateSlug(),
                    county.getCountySlug(), Integer.toString(county.getEpaZone()), "official_measurement",
                    measurement.getPeriod(), measurement.getRetrievedAt(),
                    number(metrics != null ? metrics.getTotalTests() : null),
                    number(metrics != null ? metrics.getAverageTestResultPciL() : null),
                    number(metrics != null ? metrics.getPercentTestsAtOrAbove4PciL() : null),
                    "", "", "", "", measurement.getSourceName(), measurement.getSourceUrl(),
                    measurement.getCaveat(), countyPageUrl(county));
        }

        CountyRadonTier tier = dataLoadService.getRadonTierByFipsMap().get(county.getFips());
        if (tier != null) {
            appendRow(csv,
                    county.getFips(), county.getStateAbbr(), county.getCountyName(), county.getStateSlug(),
                    county.getCountySlug(), Integer.toString(county.getEpaZone()), "official_potential_tier",
                    "", tier.getRetrievedAt(), "", "", "", Integer.toString(tier.getMunicipalityCount()),
                    number(tier.getTier1Pct()), number(tier.getTier1Or2Pct()), Integer.toString(tier.getDominantTier()),
                    tier.getSourceName(), tier.getSourceUrl(), tier.getCaveat(), countyPageUrl(county));
        }
    }

    private void appendRow(StringBuilder csv, String... values) {
        for (int i = 0; i < values.length; i++) {
            if (i > 0) {
                csv.append(',');
            }
            csv.append(csvCell(values[i]));
        }
        csv.append("\r\n");
    }

    private String csvCell(String value) {
        String safe = value == null ? "" : value.replace('\r', ' ').replace('\n', ' ').trim();
        if (!safe.isEmpty() && "=+-@".indexOf(safe.charAt(0)) >= 0) {
            safe = "'" + safe;
        }
        return '"' + safe.replace("\"", "\"\"") + '"';
    }

    private String number(Double value) {
        return value == null ? "" : BigDecimal.valueOf(value).stripTrailingZeros().toPlainString();
    }

    private String number(double value) {
        return BigDecimal.valueOf(value).stripTrailingZeros().toPlainString();
    }

    private String countyPageUrl(County county) {
        return "https://radonverdict.com/radon-levels/" + county.getStateSlug() + "/" + county.getCountySlug();
    }
}
