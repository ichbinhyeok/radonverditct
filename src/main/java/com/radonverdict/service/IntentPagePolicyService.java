package com.radonverdict.service;

import com.radonverdict.model.County;
import org.springframework.stereotype.Service;

@Service
public class IntentPagePolicyService {

    private static final String ULSTER_COUNTY_TESTING_KEY = "new-york/ulster-county";

    public boolean isTestingIntentCandidate(County county) {
        return county != null
                && ULSTER_COUNTY_TESTING_KEY.equals(county.getStateSlug() + "/" + county.getCountySlug());
    }

    public String testingPath(County county) {
        return "/radon-testing/" + county.getStateSlug() + "/" + county.getCountySlug();
    }

}
