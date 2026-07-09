package com.radonverdict.service;

import com.radonverdict.model.County;
import com.radonverdict.model.CountyRadonMeasurement;
import com.radonverdict.model.CountyRadonTier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Set;

@Service
public class SeoIndexingPolicyService {

    private static final int LARGE_HOUSING_UNIT_THRESHOLD = 50_000;
    private static final int ZONE_ONE_HOUSING_FLOOR = 10_000;
    private static final int EVIDENCE_LEVELS_SCORE_FLOOR = 72;
    private static final int EVIDENCE_COST_SCORE_FLOOR = 84;
    private static final int EVIDENCE_COST_HOUSING_FLOOR = 25_000;

    private static final List<String> RECOVERY_TRAFFIC_COUNTIES = List.of(
            "maryland/prince-georges-county",
            "florida/marion-county",
            "virginia/loudoun-county",
            "virginia/fairfax-city",
            "new-jersey/monmouth-county",
            "colorado/mesa-county",
            "colorado/boulder-county",
            "new-york/ulster-county",
            "iowa/ringgold-county",
            "california/los-angeles-county",
            "new-york/schenectady-county",
            "illinois/dupage-county",
            "virginia/falls-church-city");

    private static final Set<String> RECOVERY_TRAFFIC_COUNTY_SET = Set.copyOf(RECOVERY_TRAFFIC_COUNTIES);

    private static final List<String> GROWTH_TRAFFIC_COUNTIES = List.of(
            "new-jersey/gloucester-county",
            "colorado/broomfield-county",
            "iowa/story-county",
            "michigan/kalamazoo-county",
            "new-york/westchester-county",
            "oregon/washington-county",
            "virginia/rockbridge-county",
            "florida/miami-dade-county",
            "illinois/champaign-county",
            "illinois/madison-county",
            "indiana/dubois-county",
            "iowa/dubuque-county",
            "kansas/shawnee-county",
            "new-jersey/hunterdon-county",
            "ohio/perry-county",
            "pennsylvania/bucks-county",
            "pennsylvania/indiana-county",
            "pennsylvania/pike-county",
            "vermont/rutland-county",
            "virginia/arlington-county",
            "virginia/radford-city",
            "wisconsin/pierce-county",
            "alabama/madison-county",
            "arizona/pima-county",
            "arizona/pinal-county",
            "california/santa-barbara-county",
            "california/santa-clara-county",
            "colorado/la-plata-county",
            "florida/hillsborough-county",
            "georgia/murray-county",
            "georgia/paulding-county",
            "idaho/ada-county",
            "illinois/morgan-county",
            "illinois/sangamon-county",
            "illinois/will-county",
            "indiana/lake-county",
            "indiana/monroe-county",
            "indiana/owen-county",
            "indiana/vanderburgh-county",
            "iowa/marion-county",
            "iowa/palo-alto-county",
            "kansas/finney-county",
            "maine/cumberland-county",
            "massachusetts/franklin-county",
            "massachusetts/nantucket-county",
            "michigan/grand-traverse-county",
            "missouri/jasper-county",
            "missouri/st-charles-county",
            "missouri/st-louis-city",
            "missouri/st-louis-county",
            "new-jersey/burlington-county",
            "new-jersey/middlesex-county",
            "new-mexico/bernalillo-county",
            "new-mexico/los-alamos-county",
            "new-york/onondaga-county",
            "new-york/steuben-county",
            "north-carolina/iredell-county",
            "ohio/belmont-county",
            "ohio/highland-county",
            "ohio/jefferson-county",
            "ohio/knox-county",
            "ohio/mahoning-county",
            "ohio/miami-county",
            "pennsylvania/chester-county",
            "pennsylvania/lawrence-county",
            "pennsylvania/northampton-county",
            "south-carolina/greenville-county",
            "tennessee/sevier-county",
            "tennessee/williamson-county",
            "utah/sanpete-county",
            "utah/tooele-county",
            "virginia/appomattox-county",
            "virginia/charlottesville-city",
            "virginia/fauquier-county",
            "virginia/harrisonburg-city",
            "virginia/lynchburg-city",
            "virginia/patrick-county",
            "virginia/powhatan-county",
            "virginia/salem-city",
            "virginia/stafford-county",
            "virginia/tazewell-county",
            "washington/kitsap-county",
            "washington/san-juan-county",
            "washington/spokane-county",
            "washington/whitman-county",
            "west-virginia/berkeley-county",
            "wisconsin/manitowoc-county",
            "wisconsin/portage-county",
            "wyoming/park-county");

    private static final Set<String> GROWTH_TRAFFIC_COUNTY_SET = Set.copyOf(GROWTH_TRAFFIC_COUNTIES);

    private static final Set<String> HISTORICAL_PRIORITY_COUNTIES = Set.of(
            "california/san-francisco-county",
            "colorado/boulder-county",
            "florida/marion-county",
            "idaho/ada-county",
            "iowa/carroll-county",
            "iowa/ringgold-county",
            "maine/cumberland-county",
            "missouri/st-charles-county",
            "montana/flathead-county",
            "new-jersey/hunterdon-county",
            "new-mexico/bernalillo-county",
            "new-york/wayne-county",
            "north-carolina/clay-county",
            "north-carolina/iredell-county",
            "ohio/highland-county",
            "ohio/sandusky-county",
            "pennsylvania/bucks-county",
            "pennsylvania/delaware-county",
            "pennsylvania/erie-county",
            "tennessee/montgomery-county",
            "utah/sanpete-county",
            "vermont/rutland-county",
            "virginia/rockbridge-county",
            "virginia/salem-city",
            "virginia/stafford-county",
            "washington/san-juan-county",
            "wisconsin/pierce-county",
            "massachusetts/plymouth-county",
            "ohio/medina-county",
            "virginia/falls-church-city",
            "new-york/schenectady-county",
            "illinois/dupage-county",
            "idaho/fremont-county",
            "ohio/licking-county",
            "iowa/polk-county",
            "missouri/st-louis-county",
            "pennsylvania/allegheny-county",
            "florida/hillsborough-county",
            "california/santa-clara-county",
            "tennessee/williamson-county",
            "georgia/cherokee-county",
            "new-york/westchester-county",
            "florida/polk-county",
            "pennsylvania/chester-county",
            "illinois/kane-county",
            "alabama/madison-county");

    private final DataLoadService dataLoadService;

    public SeoIndexingPolicyService(DataLoadService dataLoadService) {
        this.dataLoadService = dataLoadService;
    }

    @Value("${app.site.index-zone3-pages:false}")
    private boolean indexZone3Pages;

    @Value("${app.site.priority-county-indexing:true}")
    private boolean priorityCountyIndexing;

    @Value("${app.site.index-evidence-rich-cost-pages:true}")
    private boolean indexEvidenceRichCostPages;

    public boolean isCountyIndexableCandidate(County county) {
        if (!hasBaseIndexingEligibility(county)) {
            return false;
        }

        return !priorityCountyIndexing || isPriorityCountyCandidate(county);
    }

    public boolean isCostPageIndexableCandidate(County county) {
        return isCountyIndexableCandidate(county)
                && (isSearchTrafficCandidate(county) || isEvidenceRichCostPageCandidate(county));
    }

    public boolean includeZoneLowSitemap() {
        return indexZone3Pages;
    }

    public boolean isRecoveryTrafficCandidate(County county) {
        if (!hasBaseIndexingEligibility(county)) {
            return false;
        }
        return RECOVERY_TRAFFIC_COUNTY_SET.contains(slugKey(county));
    }

    public int recoveryTrafficRank(County county) {
        if (county == null) {
            return Integer.MAX_VALUE;
        }
        int index = RECOVERY_TRAFFIC_COUNTIES.indexOf(slugKey(county));
        return index >= 0 ? index : Integer.MAX_VALUE;
    }

    public boolean isGrowthTrafficCandidate(County county) {
        if (!hasBaseIndexingEligibility(county)) {
            return false;
        }
        return GROWTH_TRAFFIC_COUNTY_SET.contains(slugKey(county));
    }

    public int growthTrafficRank(County county) {
        if (county == null) {
            return Integer.MAX_VALUE;
        }
        int index = GROWTH_TRAFFIC_COUNTIES.indexOf(slugKey(county));
        return index >= 0 ? index : Integer.MAX_VALUE;
    }

    public boolean isSearchTrafficCandidate(County county) {
        return isRecoveryTrafficCandidate(county) || isGrowthTrafficCandidate(county);
    }

    public boolean hasDataMoat(County county) {
        return county != null
                && county.getStats() != null
                && county.getStats().getMetrics() != null
                && county.getStats().getMetrics().getTotalHousingUnits() > 0;
    }

    public boolean isPriorityCountyCandidate(County county) {
        if (!hasBaseIndexingEligibility(county)) {
            return false;
        }

        if (isSearchTrafficCandidate(county) || HISTORICAL_PRIORITY_COUNTIES.contains(slugKey(county))) {
            return true;
        }

        int housingUnits = county.getStats().getMetrics().getTotalHousingUnits();
        if (housingUnits >= LARGE_HOUSING_UNIT_THRESHOLD) {
            return true;
        }

        return county.getEpaZone() == 1 && housingUnits >= ZONE_ONE_HOUSING_FLOOR;
    }

    public boolean isEvidenceExpansionCandidate(County county) {
        if (!hasBaseIndexingEligibility(county) || !hasOfficialRadonEvidence(county)) {
            return false;
        }

        return countyIndexingScore(county) >= EVIDENCE_LEVELS_SCORE_FLOOR;
    }

    public boolean isEvidenceRichCostPageCandidate(County county) {
        if (!indexEvidenceRichCostPages || !hasBaseIndexingEligibility(county) || !hasOfficialRadonEvidence(county)) {
            return false;
        }

        return housingUnits(county) >= EVIDENCE_COST_HOUSING_FLOOR
                && countyIndexingScore(county) >= EVIDENCE_COST_SCORE_FLOOR;
    }

    public int countyIndexingScore(County county) {
        if (!hasBaseIndexingEligibility(county)) {
            return 0;
        }

        int score = 0;
        if (isSearchTrafficCandidate(county)) {
            score += 55;
        } else if (HISTORICAL_PRIORITY_COUNTIES.contains(slugKey(county))) {
            score += 28;
        }

        score += switch (county.getEpaZone()) {
            case 1 -> 18;
            case 2 -> 10;
            default -> 2;
        };

        int housingUnits = housingUnits(county);
        if (housingUnits >= 250_000) {
            score += 20;
        } else if (housingUnits >= 100_000) {
            score += 17;
        } else if (housingUnits >= 50_000) {
            score += 14;
        } else if (housingUnits >= 25_000) {
            score += 9;
        } else if (housingUnits >= 10_000) {
            score += 5;
        }

        CountyRadonMeasurement measurement = dataLoadService.getRadonMeasurementByFipsMap().get(county.getFips());
        if (measurement != null && measurement.getMetrics() != null) {
            score += 30;
            if (measurement.getSourceId() != null && !measurement.getSourceId().isBlank()) {
                score += 6;
            }
            if (measurement.getPeriod() != null && !measurement.getPeriod().isBlank()) {
                score += 4;
            }
            score += measurementCompletenessScore(measurement);
            score += measurementRiskScore(measurement);
        }

        CountyRadonTier tier = dataLoadService.getRadonTierByFipsMap().get(county.getFips());
        if (tier != null) {
            score += 26;
            if (tier.getMunicipalityCount() >= 10) {
                score += 8;
            }
            if (tier.getTier1Pct() >= 20.0 || tier.getTier1Or2Pct() >= 70.0) {
                score += 10;
            } else if (tier.getTier1Or2Pct() >= 40.0) {
                score += 5;
            }
        }

        return Math.min(score, 100);
    }

    public String countyIndexingReason(County county) {
        if (!hasDataMoat(county)) {
            return "missing_census_housing";
        }
        if (county.getEpaZone() <= 0) {
            return "missing_epa_zone";
        }
        if (!indexZone3Pages && county.getEpaZone() == 3) {
            return "zone3_paused";
        }
        if (isSearchTrafficCandidate(county)) {
            return "search_traffic_cohort";
        }
        if (HISTORICAL_PRIORITY_COUNTIES.contains(slugKey(county))) {
            return "historical_priority";
        }
        if (isEvidenceRichCostPageCandidate(county)) {
            return "evidence_rich_cost";
        }
        if (isEvidenceExpansionCandidate(county)) {
            return "official_evidence_levels";
        }
        if (housingUnits(county) >= LARGE_HOUSING_UNIT_THRESHOLD) {
            return "large_housing_market";
        }
        if (county.getEpaZone() == 1 && housingUnits(county) >= ZONE_ONE_HOUSING_FLOOR) {
            return "zone1_housing_floor";
        }
        return "below_priority_floor";
    }

    private boolean hasBaseIndexingEligibility(County county) {
        if (county == null || !hasDataMoat(county)) {
            return false;
        }

        if (county.getEpaZone() <= 0) {
            return false;
        }

        return indexZone3Pages || county.getEpaZone() != 3;
    }

    private boolean hasOfficialRadonEvidence(County county) {
        if (county == null || county.getFips() == null) {
            return false;
        }
        CountyRadonMeasurement measurement = dataLoadService.getRadonMeasurementByFipsMap().get(county.getFips());
        if (measurement != null && measurement.getMetrics() != null) {
            return true;
        }
        return dataLoadService.getRadonTierByFipsMap().containsKey(county.getFips());
    }

    private int housingUnits(County county) {
        if (!hasDataMoat(county)) {
            return 0;
        }
        return county.getStats().getMetrics().getTotalHousingUnits();
    }

    private int measurementCompletenessScore(CountyRadonMeasurement measurement) {
        CountyRadonMeasurement.Metrics metrics = measurement.getMetrics();
        int score = 0;
        if (primaryRadonValue(metrics) != null) {
            score += 8;
        }
        if (metrics.getPercentTestsAtOrAbove4PciL() != null) {
            score += 8;
        }
        if (highEndRadonValue(metrics) != null) {
            score += 5;
        }
        Double volume = testVolume(metrics);
        if (volume != null) {
            if (volume >= 1_000) {
                score += 12;
            } else if (volume >= 250) {
                score += 9;
            } else if (volume >= 50) {
                score += 6;
            } else {
                score += 3;
            }
        }
        return score;
    }

    private int measurementRiskScore(CountyRadonMeasurement measurement) {
        CountyRadonMeasurement.Metrics metrics = measurement.getMetrics();
        Double primary = primaryRadonValue(metrics);
        Double above4 = metrics.getPercentTestsAtOrAbove4PciL();
        Double highEnd = highEndRadonValue(metrics);

        int score = 0;
        if ((primary != null && primary >= 4.0) || (above4 != null && above4 >= 30.0)) {
            score += 10;
        } else if ((primary != null && primary >= 2.0) || (above4 != null && above4 >= 10.0)) {
            score += 6;
        }
        if (highEnd != null && highEnd >= 8.0) {
            score += 5;
        }
        return score;
    }

    private Double testVolume(CountyRadonMeasurement.Metrics metrics) {
        if (metrics.getTotalTests() != null) {
            return metrics.getTotalTests();
        }
        if (metrics.getNumberBuildingsTested10Year() != null) {
            return metrics.getNumberBuildingsTested10Year();
        }
        return metrics.getAverageNumberOfTests();
    }

    private Double primaryRadonValue(CountyRadonMeasurement.Metrics metrics) {
        if (metrics.getAverageTestResultPciL() != null) {
            return metrics.getAverageTestResultPciL();
        }
        if (metrics.getArithmeticMeanRadonValuePciL() != null) {
            return metrics.getArithmeticMeanRadonValuePciL();
        }
        return metrics.getMedianRadonValuePciL();
    }

    private Double highEndRadonValue(CountyRadonMeasurement.Metrics metrics) {
        if (metrics.getRadon95thPercentilePciL() != null) {
            return metrics.getRadon95thPercentilePciL();
        }
        return metrics.getMaximumTestResultPciL();
    }

    private String slugKey(County county) {
        return county.getStateSlug() + "/" + county.getCountySlug();
    }
}
