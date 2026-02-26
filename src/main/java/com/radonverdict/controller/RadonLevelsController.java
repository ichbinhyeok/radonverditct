package com.radonverdict.controller;

import com.radonverdict.model.County;
import com.radonverdict.model.StateRegulations;
import com.radonverdict.model.dto.AeoAnswerBlock;
import com.radonverdict.model.dto.PageQualityResult;
import com.radonverdict.model.dto.TrustMetadata;
import com.radonverdict.service.DataLoadService;
import com.radonverdict.service.InternalLinkService;
import com.radonverdict.service.PageQualityService;
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

import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequiredArgsConstructor
public class RadonLevelsController {

    private final DataLoadService dataLoadService;
    private final PageQualityService pageQualityService;
    private final TrustMetadataService trustMetadataService;
    private final InternalLinkService internalLinkService;

    @Value("${app.feature.monetization-hooks.enabled:false}")
    private boolean monetizationHooksEnabled;

    @Value("${app.site.base-url:https://radonverdict.com}")
    private String baseUrl;

    @GetMapping("/radon-levels/{stateSlug}")
    public Object stateLevelsHub(@PathVariable("stateSlug") String stateSlug, Model model) {
        List<County> stateCounties = dataLoadService.getCountyBySlugMap().values().stream()
                .filter(c -> c.getStateSlug().equalsIgnoreCase(stateSlug))
                .sorted(Comparator.comparing(County::getCountyName))
                .collect(Collectors.toList());

        if (stateCounties.isEmpty())
            throw new ResponseStatusException(HttpStatus.NOT_FOUND);

        String canonicalStateSlug = stateCounties.get(0).getStateSlug();
        if (!canonicalStateSlug.equals(stateSlug)) {
            return permanentRedirect("/radon-levels/" + canonicalStateSlug);
        }

        String stateAbbr = stateCounties.get(0).getStateAbbr();

        // Count zones for state-level insight
        long zone1Count = stateCounties.stream().filter(c -> c.getEpaZone() == 1).count();
        long zone2Count = stateCounties.stream().filter(c -> c.getEpaZone() == 2).count();
        long zone3Count = stateCounties.stream().filter(c -> c.getEpaZone() == 3).count();

        model.addAttribute("stateSlug", canonicalStateSlug);
        model.addAttribute("stateAbbr", stateAbbr);
        model.addAttribute("counties", stateCounties);
        model.addAttribute("zone1Count", zone1Count);
        model.addAttribute("zone2Count", zone2Count);
        model.addAttribute("zone3Count", zone3Count);

        return "radon_levels_state";
    }

    @GetMapping("/radon-levels/{stateSlug}/{countySlug}")
    public Object countyLevelsPage(@PathVariable("stateSlug") String stateSlug,
            @PathVariable("countySlug") String countySlug, Model model) {
        String key = stateSlug.toLowerCase() + "/" + countySlug.toLowerCase();
        County county = dataLoadService.getCountyBySlugMap().get(key);

        if (county == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "County not found");
        }

        if (!county.getStateSlug().equals(stateSlug) || !county.getCountySlug().equals(countySlug)) {
            return permanentRedirect("/radon-levels/" + county.getStateSlug() + "/" + county.getCountySlug());
        }

        // Get state regulation data
        StateRegulations regulations = dataLoadService.getStateRegulations();
        StateRegulations.StateRule stateRule = null;
        if (regulations != null) {
            stateRule = regulations.getStateRules().getOrDefault(
                    county.getStateAbbr().toUpperCase(),
                    regulations.getDefaultStateRule());
        }

        // Get nearby counties for internal linking
        List<County> nearbyCounties = dataLoadService.getCountyBySlugMap().values().stream()
                .filter(c -> c.getStateAbbr().equals(county.getStateAbbr())
                        && !c.getFips().equals(county.getFips()))
                .sorted(Comparator.comparing(County::getCountyName))
                .limit(6)
                .collect(Collectors.toList());

        model.addAttribute("county", county);
        model.addAttribute("stateRule", stateRule);
        model.addAttribute("nearbyCounties", nearbyCounties);
        PageQualityResult quality = pageQualityService.scoreRadonLevelsCountyPage(county, nearbyCounties.size());
        TrustMetadata trust = trustMetadataService.forCountyPage(county);
        AeoAnswerBlock aeo = buildRadonLevelAeoBlock(county, trust);

        model.addAttribute("noindex", !quality.isIndexable());
        model.addAttribute("quality", quality);
        model.addAttribute("trust", trust);
        model.addAttribute("aeo", aeo);
        model.addAttribute("relatedLinks", internalLinkService.buildRadonLevelsCountyLinks(county, nearbyCounties));
        model.addAttribute("monetizationHooksEnabled", monetizationHooksEnabled);
        model.addAttribute("canonicalUrl",
                normalizedBaseUrl() + "/radon-levels/" + county.getStateSlug() + "/" + county.getCountySlug());

        return "radon_levels_county";
    }

    private AeoAnswerBlock buildRadonLevelAeoBlock(County county, TrustMetadata trust) {
        if (county == null) {
            return null;
        }

        String zoneText;
        String actionText;
        if (county.getEpaZone() == 1) {
            zoneText = "EPA Zone 1 (High Risk)";
            actionText = "Prioritize testing now and prepare for possible mitigation.";
        } else if (county.getEpaZone() == 2) {
            zoneText = "EPA Zone 2 (Moderate Risk)";
            actionText = "Test all lived-in levels and confirm with follow-up testing if elevated.";
        } else if (county.getEpaZone() == 3) {
            zoneText = "EPA Zone 3 (Lower Predicted Average Risk)";
            actionText = "Testing is still recommended because home-level variance can be high.";
        } else {
            zoneText = "Unclassified (Data Pending)";
            actionText = "Treat this county as unknown risk and rely on direct home testing.";
        }

        return AeoAnswerBlock.builder()
                .question("What radon risk level should homeowners assume in " + county.getAreaDisplayName() + "?")
                .directAnswer(county.getAreaDisplayName() + " is currently categorized as " + zoneText + ". "
                        + actionText)
                .evidenceRows(List.of(
                        AeoAnswerBlock.Row.builder()
                                .label("Area")
                                .value(county.getAreaDisplayName() + ", " + county.getStateAbbr())
                                .build(),
                        AeoAnswerBlock.Row.builder()
                                .label("EPA Zone")
                                .value(county.getEpaZone() > 0 ? "Zone " + county.getEpaZone() : "Unclassified")
                                .build(),
                        AeoAnswerBlock.Row.builder()
                                .label("Primary Recommendation")
                                .value("Perform direct radon testing in the lowest livable level")
                                .build()))
                .sources(trust != null ? trust.getSources() : List.of())
                .build();
    }

    private String normalizedBaseUrl() {
        if (baseUrl == null || baseUrl.isBlank()) {
            return "https://radonverdict.com";
        }
        return baseUrl.endsWith("/") ? baseUrl.substring(0, baseUrl.length() - 1) : baseUrl;
    }

    private RedirectView permanentRedirect(String path) {
        RedirectView view = new RedirectView(normalizedBaseUrl() + path, false);
        view.setStatusCode(HttpStatus.MOVED_PERMANENTLY);
        return view;
    }
}
