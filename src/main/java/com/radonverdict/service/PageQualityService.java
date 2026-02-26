package com.radonverdict.service;

import com.radonverdict.model.County;
import com.radonverdict.model.dto.CountyPageContent;
import com.radonverdict.model.dto.PageQualityResult;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class PageQualityService {

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
            score -= 10;
            reasons.add("unknown_epa_zone");
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

        boolean indexable = !criticalDataMissing && score >= 65;
        return PageQualityResult.builder()
                .score(score)
                .indexable(indexable)
                .reasons(reasons)
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
            score -= 8;
            reasons.add("unknown_epa_zone");
        }

        if (nearbyCountyCount < 3) {
            score -= 5;
            reasons.add("weak_internal_link_graph");
        }

        if (score < 0) {
            score = 0;
        }

        boolean indexable = !criticalDataMissing && score >= 65;
        return PageQualityResult.builder()
                .score(score)
                .indexable(indexable)
                .reasons(reasons)
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
}
