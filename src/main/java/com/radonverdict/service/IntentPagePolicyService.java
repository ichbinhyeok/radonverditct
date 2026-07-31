package com.radonverdict.service;

import com.radonverdict.model.County;
import org.springframework.stereotype.Service;

import java.util.Set;

@Service
public class IntentPagePolicyService {

    // Search Console demand observed through 2026-07-29. Keep this cohort deliberately
    // small: these counties earned explicit local testing impressions before getting a
    // dedicated intent-matched landing page.
    private static final Set<String> TESTING_INTENT_KEYS = Set.of(
            "new-york/ulster-county",
            "virginia/powhatan-county",
            "colorado/broomfield-county",
            "new-mexico/bernalillo-county");

    private static final String LOS_ANGELES_COMMERCIAL_KEY = "california/los-angeles-county";

    public boolean isTestingIntentCandidate(County county) {
        return county != null
                && TESTING_INTENT_KEYS.contains(key(county));
    }

    public String testingPath(County county) {
        return "/radon-testing/" + county.getStateSlug() + "/" + county.getCountySlug();
    }

    public boolean isCommercialIntentCandidate(County county) {
        return county != null && LOS_ANGELES_COMMERCIAL_KEY.equals(key(county));
    }

    public String commercialPath(County county) {
        return "/commercial-radon-testing/" + county.getStateSlug() + "/" + county.getCountySlug();
    }

    private String key(County county) {
        return county.getStateSlug() + "/" + county.getCountySlug();
    }

}
