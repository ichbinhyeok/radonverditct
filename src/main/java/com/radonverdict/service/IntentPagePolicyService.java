package com.radonverdict.service;

import com.radonverdict.model.County;
import org.springframework.stereotype.Service;

@Service
public class IntentPagePolicyService {

    public boolean isTestingIntentCandidate(County county) {
        // Testing demand is consolidated into the county levels URL so Google sees
        // one local informational page instead of competing levels/testing siblings.
        return false;
    }

    public String testingPath(County county) {
        return "/radon-testing/" + county.getStateSlug() + "/" + county.getCountySlug();
    }

}
