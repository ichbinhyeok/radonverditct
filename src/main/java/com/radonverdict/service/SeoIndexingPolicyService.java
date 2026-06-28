package com.radonverdict.service;

import com.radonverdict.model.County;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Set;

@Service
public class SeoIndexingPolicyService {

    private static final int LARGE_HOUSING_UNIT_THRESHOLD = 50_000;
    private static final int ZONE_ONE_HOUSING_FLOOR = 10_000;

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

    @Value("${app.site.index-zone3-pages:false}")
    private boolean indexZone3Pages;

    @Value("${app.site.priority-county-indexing:true}")
    private boolean priorityCountyIndexing;

    public boolean isCountyIndexableCandidate(County county) {
        if (county == null || !hasDataMoat(county)) {
            return false;
        }

        if (county.getEpaZone() <= 0) {
            return false;
        }

        if (!indexZone3Pages && county.getEpaZone() == 3) {
            return false;
        }

        return !priorityCountyIndexing || isPriorityCountyCandidate(county);
    }

    public boolean includeZoneLowSitemap() {
        return indexZone3Pages;
    }

    public boolean isRecoveryTrafficCandidate(County county) {
        if (!hasDataMoat(county) || county.getEpaZone() <= 0) {
            return false;
        }
        if (!indexZone3Pages && county.getEpaZone() == 3) {
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

    public boolean hasDataMoat(County county) {
        return county != null
                && county.getStats() != null
                && county.getStats().getMetrics() != null
                && county.getStats().getMetrics().getTotalHousingUnits() > 0;
    }

    public boolean isPriorityCountyCandidate(County county) {
        if (!hasDataMoat(county) || county.getEpaZone() <= 0) {
            return false;
        }

        if (isRecoveryTrafficCandidate(county) || HISTORICAL_PRIORITY_COUNTIES.contains(slugKey(county))) {
            return true;
        }

        int housingUnits = county.getStats().getMetrics().getTotalHousingUnits();
        if (housingUnits >= LARGE_HOUSING_UNIT_THRESHOLD) {
            return true;
        }

        return county.getEpaZone() == 1 && housingUnits >= ZONE_ONE_HOUSING_FLOOR;
    }

    private String slugKey(County county) {
        return county.getStateSlug() + "/" + county.getCountySlug();
    }
}
