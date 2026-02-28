package com.radonverdict.service;

import com.radonverdict.model.County;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
public class SeoIndexingPolicyService {

    @Value("${app.site.index-zone3-pages:false}")
    private boolean indexZone3Pages;

    public boolean isCountyIndexableCandidate(County county) {
        if (county == null || !hasDataMoat(county)) {
            return false;
        }

        if (county.getEpaZone() <= 0) {
            return false;
        }

        return indexZone3Pages || county.getEpaZone() != 3;
    }

    public boolean includeZoneLowSitemap() {
        return indexZone3Pages;
    }

    public boolean hasDataMoat(County county) {
        return county != null
                && county.getStats() != null
                && county.getStats().getMetrics() != null
                && county.getStats().getMetrics().getTotalHousingUnits() > 0;
    }
}
