package com.radonverdict.service;

import com.radonverdict.model.County;
import com.radonverdict.model.dto.CountyPageContent;
import com.radonverdict.model.dto.PageQualityResult;
import com.radonverdict.model.dto.SimilarityAssessment;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class PageQualityService {

    private final SimilarityEngineService similarityEngineService;

    public PageQualityResult scoreMitigationCountyPage(County county, CountyPageContent page) {
        int score = 100;
        List<String> reasons = new ArrayList<>();
        boolean criticalDataMissing = false;

        if (county == null) {
            return PageQualityResult.builder()
                    .score(0)
                    .indexable(false)
                    .reasons(List.of("county_not_found"))
                    .build();
        }

        if (county.getStats() == null || county.getStats().getMetrics() == null) {
            score -= 35;
            criticalDataMissing = true;
            reasons.add("missing_county_stats");
        } else if (county.getStats().getMetrics().getTotalHousingUnits() <= 0) {
            score -= 35;
            criticalDataMissing = true;
            reasons.add("invalid_housing_units");
        }

        if (county.getEpaZone() <= 0) {
            score -= 20;
            criticalDataMissing = true;
            reasons.add("unknown_epa_zone_data_pending");
        }

        if (page != null) {
            if (page.getFaqs() == null || page.getFaqs().size() < 4) {
                score -= 10;
                reasons.add("low_faq_depth");
            }

            if (page.getIntentSteps() == null || page.getIntentSteps().size() < 3) {
                score -= 10;
                reasons.add("low_intent_depth");
            }

            if (textLength(page.getHeroSummary()) < 140) {
                score -= 8;
                reasons.add("short_hero_summary");
            }

            if (textLength(page.getRiskNarrative()) < 180) {
                score -= 8;
                reasons.add("short_risk_narrative");
            }

            if (isNearDuplicate(page.getHeroSummary(), page.getRiskNarrative())) {
                score -= 12;
                reasons.add("duplicate_summary_risk");
            }
        }

        if (score < 0) {
            score = 0;
        }

        SimilarityAssessment similarity = similarityEngineService.assessMitigationPage(county,
                page != null ? page.getReceipt() : null);
        score -= similarityPenalty(similarity, reasons);
        if (score < 0) {
            score = 0;
        }

        boolean indexable = !criticalDataMissing && score >= 65;
        return PageQualityResult.builder()
                .score(score)
                .indexable(indexable)
                .reasons(reasons)
                .similarityScore(similarity.getUniquenessScore())
                .similarityCohortSize(similarity.getCohortSize())
                .similarityFingerprint(similarity.getFingerprint())
                .build();
    }

    public PageQualityResult scoreRadonLevelsCountyPage(County county, int nearbyCountyCount) {
        int score = 100;
        List<String> reasons = new ArrayList<>();
        boolean criticalDataMissing = false;

        if (county == null) {
            return PageQualityResult.builder()
                    .score(0)
                    .indexable(false)
                    .reasons(List.of("county_not_found"))
                    .build();
        }

        if (county.getStats() == null || county.getStats().getMetrics() == null) {
            score -= 35;
            criticalDataMissing = true;
            reasons.add("missing_county_stats");
        } else if (county.getStats().getMetrics().getTotalHousingUnits() <= 0) {
            score -= 35;
            criticalDataMissing = true;
            reasons.add("invalid_housing_units");
        }

        if (county.getEpaZone() <= 0) {
            score -= 20;
            criticalDataMissing = true;
            reasons.add("unknown_epa_zone_data_pending");
        }

        if (nearbyCountyCount < 3) {
            score -= 5;
            reasons.add("weak_internal_link_graph");
        }

        if (score < 0) {
            score = 0;
        }

        SimilarityAssessment similarity = similarityEngineService.assessLevelsPage(county);
        score -= similarityPenalty(similarity, reasons);
        if (score < 0) {
            score = 0;
        }

        boolean indexable = !criticalDataMissing && score >= 65;
        return PageQualityResult.builder()
                .score(score)
                .indexable(indexable)
                .reasons(reasons)
                .similarityScore(similarity.getUniquenessScore())
                .similarityCohortSize(similarity.getCohortSize())
                .similarityFingerprint(similarity.getFingerprint())
                .build();
    }

    private int textLength(String value) {
        return value == null ? 0 : value.trim().length();
    }

    private boolean isNearDuplicate(String left, String right) {
        if (left == null || right == null) {
            return false;
        }

        String normalizedLeft = left.toLowerCase().replaceAll("[^a-z0-9 ]", " ").replaceAll("\\s+", " ").trim();
        String normalizedRight = right.toLowerCase().replaceAll("[^a-z0-9 ]", " ").replaceAll("\\s+", " ").trim();
        if (normalizedLeft.isEmpty() || normalizedRight.isEmpty()) {
            return false;
        }

        return normalizedLeft.equals(normalizedRight);
    }

    private int similarityPenalty(SimilarityAssessment similarity, List<String> reasons) {
        if (similarity == null) {
            return 0;
        }
        int penalty = 0;
        if (similarity.getCohortSize() >= 250) {
            penalty += 12;
            reasons.add("similarity_cluster_very_large");
        } else if (similarity.getCohortSize() >= 120) {
            penalty += 8;
            reasons.add("similarity_cluster_large");
        } else if (similarity.getCohortSize() >= 60) {
            penalty += 4;
            reasons.add("similarity_cluster_medium");
        }

        if (similarity.getUniquenessScore() < 50) {
            penalty += 8;
            reasons.add("low_uniqueness_score");
        }
        return penalty;
    }
}
