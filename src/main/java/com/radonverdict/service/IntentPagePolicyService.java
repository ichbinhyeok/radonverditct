package com.radonverdict.service;

import com.radonverdict.model.County;
import com.radonverdict.model.dto.SearchDemandProfile;
import org.springframework.stereotype.Service;

@Service
public class IntentPagePolicyService {

    private final DataLoadService dataLoadService;
    private final SearchDemandService searchDemandService;

    public IntentPagePolicyService(DataLoadService dataLoadService, SearchDemandService searchDemandService) {
        this.dataLoadService = dataLoadService;
        this.searchDemandService = searchDemandService;
    }

    public boolean isTestingIntentCandidate(County county) {
        if (county == null || county.getFips() == null || !hasOfficialEvidence(county)) {
            return false;
        }
        SearchDemandProfile cost = searchDemandService.profileForPath(costPath(county));
        SearchDemandProfile levels = searchDemandService.profileForPath(levelsPath(county));
        return isTestingProfile(cost) || isTestingProfile(levels);
    }

    public String testingPath(County county) {
        return "/radon-testing/" + county.getStateSlug() + "/" + county.getCountySlug();
    }

    private boolean isTestingProfile(SearchDemandProfile profile) {
        return profile != null
                && profile.getPrimaryQuery() != null
                && !profile.getPrimaryQuery().isBlank()
                && "testing".equals(profile.getIntent());
    }

    private boolean hasOfficialEvidence(County county) {
        return dataLoadService.getRadonMeasurementByFipsMap().containsKey(county.getFips())
                || dataLoadService.getRadonTierByFipsMap().containsKey(county.getFips());
    }

    private String costPath(County county) {
        return "/radon-mitigation-cost/" + county.getStateSlug() + "/" + county.getCountySlug();
    }

    private String levelsPath(County county) {
        return "/radon-levels/" + county.getStateSlug() + "/" + county.getCountySlug();
    }
}
