package com.radonverdict.service;

import com.radonverdict.model.County;
import com.radonverdict.model.CountyStats;
import com.radonverdict.model.dto.ItemizedReceipt;
import com.radonverdict.model.dto.SimilarityAssessment;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;

@Service
@RequiredArgsConstructor
public class SimilarityEngineService {

    private final DataLoadService dataLoadService;

    private final Map<String, Profile> profileByFips = new HashMap<>();
    private final Map<String, Integer> fingerprintCounts = new HashMap<>();
    private final Map<String, List<Double>> stateHomeValueSeries = new HashMap<>();
    private final Map<String, List<Double>> stateHousingSeries = new HashMap<>();
    private final Map<String, List<Double>> stateAgeSeries = new HashMap<>();

    @PostConstruct
    public void init() {
        rebuildCache();
    }

    public SimilarityAssessment assessMitigationPage(County county, ItemizedReceipt receipt) {
        ensureCache();
        return assessInternal(county, receipt);
    }

    public SimilarityAssessment assessLevelsPage(County county) {
        ensureCache();
        return assessInternal(county, null);
    }

    public List<String> buildDifferentiationNarratives(County county, ItemizedReceipt receipt,
            SimilarityAssessment assessment) {
        ensureCache();
        if (county == null || county.getStats() == null || county.getStats().getMetrics() == null || assessment == null) {
            return List.of();
        }

        Profile profile = profileByFips.get(county.getFips());
        if (profile == null) {
            return List.of();
        }

        CountyStats.Metrics metrics = county.getStats().getMetrics();
        int templateSelector = Math.floorMod(Objects.hashCode(county.getFips()), 4);
        double burden = mitigationBurdenPct(metrics, receipt);

        List<String> lines = new ArrayList<>();
        if (templateSelector == 0) {
            lines.add(String.format(Locale.US,
                    "Relative position in %s: home values are around the %dth percentile, while pre-1980 housing share sits near the %dth percentile. This shifts remediation scope and budget planning.",
                    county.getStateAbbr(), profile.homeValuePercentile(), profile.agePercentile()));
        } else if (templateSelector == 1) {
            lines.add(String.format(Locale.US,
                    "County profile dispersion: %s ranks near the %dth percentile for housing stock size and the %dth percentile for older-home concentration within %s.",
                    county.getAreaDisplayName(), profile.housingPercentile(), profile.agePercentile(), county.getStateAbbr()));
        } else if (templateSelector == 2) {
            lines.add(String.format(Locale.US,
                    "In-state contrast: %s is not a median-case area. Its valuation percentile (%dth) and housing-age percentile (%dth) create a distinct mitigation decision context.",
                    county.getAreaDisplayName(), profile.homeValuePercentile(), profile.agePercentile()));
        } else {
            lines.add(String.format(Locale.US,
                    "Peer comparison signal: %s shows a %dth percentile home-value profile and a %dth percentile housing-volume profile in %s, influencing quote spread and negotiation leverage.",
                    county.getAreaDisplayName(), profile.homeValuePercentile(), profile.housingPercentile(), county.getStateAbbr()));
        }

        lines.add(String.format(Locale.US,
                "Similarity cohort size is %d pages (fingerprint: %s). Uniqueness score: %d/100. Larger cohorts are typically harder for search systems to prioritize.",
                assessment.getCohortSize(), assessment.getFingerprint(), assessment.getUniquenessScore()));

        if (receipt != null && receipt.getTotalAvg() > 0 && metrics.getMedianHomeValue() > 0) {
            lines.add(String.format(Locale.US,
                    "Affordability context: estimated mitigation average ($%,d) is %.2f%% of local median home value. This ratio is used to differentiate guidance for financing vs immediate remediation.",
                    receipt.getTotalAvg(), burden));
        }

        return lines;
    }

    private SimilarityAssessment assessInternal(County county, ItemizedReceipt receipt) {
        if (county == null || county.getStats() == null || county.getStats().getMetrics() == null) {
            return SimilarityAssessment.builder()
                    .uniquenessScore(0)
                    .cohortSize(Integer.MAX_VALUE)
                    .fingerprint("missing-data")
                    .reasons(List.of("missing_county_metrics"))
                    .build();
        }

        Profile profile = profileByFips.get(county.getFips());
        if (profile == null) {
            return SimilarityAssessment.builder()
                    .uniquenessScore(0)
                    .cohortSize(Integer.MAX_VALUE)
                    .fingerprint("profile-missing")
                    .reasons(List.of("missing_similarity_profile"))
                    .build();
        }

        String fingerprint = profile.baseFingerprint();
        int cohortSize = fingerprintCounts.getOrDefault(fingerprint, 1);
        List<String> reasons = new ArrayList<>();
        if (cohortSize >= 250) {
            reasons.add("very_large_similarity_cohort");
        } else if (cohortSize >= 120) {
            reasons.add("large_similarity_cohort");
        } else if (cohortSize >= 60) {
            reasons.add("medium_similarity_cohort");
        }

        int score = 100;
        score -= similarityPenalty(cohortSize);
        if (county.getEpaZone() <= 0) {
            score -= 10;
            reasons.add("zone_data_unclassified");
        }
        if (receipt == null || receipt.getTotalAvg() <= 0) {
            score -= 6;
            reasons.add("missing_receipt_signal");
        }
        score = Math.max(0, score);

        return SimilarityAssessment.builder()
                .uniquenessScore(score)
                .cohortSize(cohortSize)
                .fingerprint(fingerprint)
                .reasons(reasons)
                .build();
    }

    private synchronized void ensureCache() {
        if (profileByFips.isEmpty() || fingerprintCounts.isEmpty()) {
            rebuildCache();
        }
    }

    private synchronized void rebuildCache() {
        profileByFips.clear();
        fingerprintCounts.clear();
        stateHomeValueSeries.clear();
        stateHousingSeries.clear();
        stateAgeSeries.clear();

        List<County> counties = dataLoadService.getCountyBySlugMap().values().stream()
                .filter(c -> c.getStats() != null && c.getStats().getMetrics() != null)
                .toList();

        Map<String, List<County>> byState = new HashMap<>();
        for (County county : counties) {
            byState.computeIfAbsent(county.getStateAbbr(), ignored -> new ArrayList<>()).add(county);
        }

        for (Map.Entry<String, List<County>> entry : byState.entrySet()) {
            String state = entry.getKey();
            List<Double> values = entry.getValue().stream()
                    .map(c -> (double) c.getStats().getMetrics().getMedianHomeValue())
                    .sorted(Comparator.naturalOrder())
                    .toList();
            List<Double> housing = entry.getValue().stream()
                    .map(c -> (double) c.getStats().getMetrics().getTotalHousingUnits())
                    .sorted(Comparator.naturalOrder())
                    .toList();
            List<Double> age = entry.getValue().stream()
                    .map(c -> c.getStats().getMetrics().getBuiltBefore1980Pct())
                    .sorted(Comparator.naturalOrder())
                    .toList();
            stateHomeValueSeries.put(state, values);
            stateHousingSeries.put(state, housing);
            stateAgeSeries.put(state, age);
        }

        for (County county : counties) {
            CountyStats.Metrics metrics = county.getStats().getMetrics();
            List<Double> valueSeries = stateHomeValueSeries.getOrDefault(county.getStateAbbr(), List.of());
            List<Double> housingSeries = stateHousingSeries.getOrDefault(county.getStateAbbr(), List.of());
            List<Double> ageSeries = stateAgeSeries.getOrDefault(county.getStateAbbr(), List.of());

            int valuePct = percentile(valueSeries, metrics.getMedianHomeValue());
            int housingPct = percentile(housingSeries, metrics.getTotalHousingUnits());
            int agePct = percentile(ageSeries, metrics.getBuiltBefore1980Pct());

            int ageBand = ageBand(metrics.getBuiltBefore1980Pct());
            int valueBand = quantileBand(valuePct);
            int housingBand = quantileBand(housingPct);
            int zone = county.getEpaZone() <= 0 ? 0 : county.getEpaZone();

            String baseFingerprint = "z" + zone + "-a" + ageBand + "-v" + valueBand + "-h" + housingBand;
            profileByFips.put(county.getFips(), new Profile(baseFingerprint, valuePct, housingPct, agePct));
            fingerprintCounts.put(baseFingerprint, fingerprintCounts.getOrDefault(baseFingerprint, 0) + 1);
        }
    }

    private int percentile(List<Double> sorted, double value) {
        if (sorted.isEmpty()) {
            return 50;
        }
        int idx = Collections.binarySearch(sorted, value);
        if (idx < 0) {
            idx = -idx - 1;
        } else {
            while (idx < sorted.size() && sorted.get(idx) <= value) {
                idx++;
            }
        }
        return (int) Math.round((idx * 100.0) / sorted.size());
    }

    private int quantileBand(int percentile) {
        if (percentile < 25) {
            return 0;
        }
        if (percentile < 50) {
            return 1;
        }
        if (percentile < 75) {
            return 2;
        }
        return 3;
    }

    private int ageBand(double builtBefore1980Pct) {
        if (builtBefore1980Pct < 25) {
            return 0;
        }
        if (builtBefore1980Pct < 35) {
            return 1;
        }
        if (builtBefore1980Pct < 45) {
            return 2;
        }
        if (builtBefore1980Pct < 55) {
            return 3;
        }
        if (builtBefore1980Pct < 65) {
            return 4;
        }
        return 5;
    }

    private double mitigationBurdenPct(CountyStats.Metrics metrics, ItemizedReceipt receipt) {
        if (metrics == null || metrics.getMedianHomeValue() <= 0 || receipt == null || receipt.getTotalAvg() <= 0) {
            return 0.0;
        }
        return (receipt.getTotalAvg() / (double) metrics.getMedianHomeValue()) * 100.0;
    }

    private int similarityPenalty(int cohortSize) {
        if (cohortSize <= 20) {
            return 0;
        }
        if (cohortSize <= 60) {
            return 8;
        }
        if (cohortSize <= 120) {
            return 16;
        }
        if (cohortSize <= 250) {
            return 24;
        }
        return 32;
    }

    private record Profile(String baseFingerprint, int homeValuePercentile, int housingPercentile, int agePercentile) {
    }
}
