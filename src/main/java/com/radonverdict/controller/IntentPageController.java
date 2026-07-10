package com.radonverdict.controller;

import com.radonverdict.model.County;
import com.radonverdict.model.dto.CountyRadonEvidence;
import com.radonverdict.model.dto.TrustMetadata;
import com.radonverdict.service.CountyRadonEvidenceService;
import com.radonverdict.service.DataLoadService;
import com.radonverdict.service.IntentPagePolicyService;
import com.radonverdict.service.TrustMetadataService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.view.RedirectView;

@Controller
@RequiredArgsConstructor
public class IntentPageController {

    private final DataLoadService dataLoadService;
    private final CountyRadonEvidenceService countyRadonEvidenceService;
    private final IntentPagePolicyService intentPagePolicyService;
    private final TrustMetadataService trustMetadataService;

    @Value("${app.site.base-url:https://radonverdict.com}")
    private String baseUrl;

    @GetMapping("/radon-testing/{stateSlug}/{countySlug}")
    public Object testingPage(@PathVariable String stateSlug, @PathVariable String countySlug, Model model) {
        County county = dataLoadService.getCountyBySlugMap().get(stateSlug.toLowerCase() + "/" + countySlug.toLowerCase());
        if (county == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "County not found");
        }
        if (!county.getStateSlug().equals(stateSlug) || !county.getCountySlug().equals(countySlug)) {
            RedirectView redirect = new RedirectView(intentPagePolicyService.testingPath(county), true);
            redirect.setStatusCode(HttpStatus.MOVED_PERMANENTLY);
            return redirect;
        }
        if (!intentPagePolicyService.isTestingIntentCandidate(county)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Testing intent page is not currently eligible");
        }

        CountyRadonEvidence evidence = countyRadonEvidenceService.buildEvidence(county);
        TrustMetadata trust = trustMetadataService.forRadonLevelsCountyPage(county);
        model.addAttribute("county", county);
        model.addAttribute("evidence", evidence);
        model.addAttribute("trust", trust);
        model.addAttribute("canonicalUrl", normalizedBaseUrl() + intentPagePolicyService.testingPath(county));
        return "intent_testing_county";
    }

    private String normalizedBaseUrl() {
        if (baseUrl == null || baseUrl.isBlank()) {
            return "https://radonverdict.com";
        }
        return baseUrl.endsWith("/") ? baseUrl.substring(0, baseUrl.length() - 1) : baseUrl;
    }
}
