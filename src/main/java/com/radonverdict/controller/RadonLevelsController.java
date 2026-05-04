package com.radonverdict.controller;

import com.radonverdict.model.County;
import com.radonverdict.model.StateRegulations;
import com.radonverdict.model.dto.AeoAnswerBlock;
import com.radonverdict.model.dto.PageQualityResult;
import com.radonverdict.model.dto.TrustMetadata;
import com.radonverdict.service.DataLoadService;
import com.radonverdict.service.InternalLinkService;
import com.radonverdict.service.PageQualityService;
import com.radonverdict.service.SeoIndexingPolicyService;
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
import java.util.Map;
import java.util.TreeMap;
import java.util.stream.Collectors;

@Controller
@RequiredArgsConstructor
public class RadonLevelsController {

    private final DataLoadService dataLoadService;
    private final PageQualityService pageQualityService;
    private final SeoIndexingPolicyService seoIndexingPolicyService;
    private final TrustMetadataService trustMetadataService;
    private final InternalLinkService internalLinkService;

    @Value("${app.feature.monetization-hooks.enabled:false}")
    private boolean monetizationHooksEnabled;

    @Value("${app.site.base-url:https://radonverdict.com}")
    private String baseUrl;

    @Value("${app.feature.seo-debug-visible:false}")
    private boolean seoDebugVisible;

    @GetMapping("/radon-levels")
    public String radonLevelsRoot(Model model) {
        List<County> allCounties = dataLoadService.getCountyBySlugMap().values().stream()
                .sorted(Comparator.comparing(County::getStateAbbr).thenComparing(County::getCountyName))
                .toList();
        List<County> visibleCounties = allCounties.stream()
                .filter(seoIndexingPolicyService::isCountyIndexableCandidate)
                .toList();

        Map<String, List<County>> stateMap = visibleCounties.stream()
                .collect(Collectors.groupingBy(County::getStateAbbr, TreeMap::new, Collectors.toList()));

        long zone1Count = allCounties.stream().filter(c -> c.getEpaZone() == 1).count();
        long zone2Count = allCounties.stream().filter(c -> c.getEpaZone() == 2).count();
        long zone3Count = allCounties.stream().filter(c -> c.getEpaZone() == 3).count();
        TrustMetadata trust = trustMetadataService.forGuidePage();

        model.addAttribute("stateMap", stateMap);
        model.addAttribute("zone1Count", zone1Count);
        model.addAttribute("zone2Count", zone2Count);
        model.addAttribute("zone3Count", zone3Count);
        model.addAttribute("visibleCountyCount", visibleCounties.size());
        model.addAttribute("trust", trust);
        model.addAttribute("aeo", AeoAnswerBlock.builder()
                .question("What radon level should homeowners act on?")
                .directAnswer("In US guidance, 4.0 pCi/L or higher is the main action threshold for fixing a home. Results from 2.0 to 3.9 pCi/L still deserve attention because radon risk is not zero below 4.0; retest, track long-term, or consider reduction depending on the home and situation.")
                .evidenceRows(List.of(
                        AeoAnswerBlock.Row.builder().label("Under 2.0 pCi/L").value("Lower concern; keep periodic testing").build(),
                        AeoAnswerBlock.Row.builder().label("2.0 to 3.9 pCi/L").value("Retest, track, or consider reduction").build(),
                        AeoAnswerBlock.Row.builder().label("4.0+ pCi/L").value("EPA action threshold for fixing the home").build(),
                        AeoAnswerBlock.Row.builder().label("8.0+ pCi/L").value("High reading; prioritize mitigation planning").build()))
                .sources(trust != null ? trust.getSources() : List.of())
                .build());
        return "radon_levels_root";
    }

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
        List<County> visibleCounties = stateCounties.stream()
                .filter(seoIndexingPolicyService::isCountyIndexableCandidate)
                .toList();

        // Count zones for state-level insight
        long zone1Count = stateCounties.stream().filter(c -> c.getEpaZone() == 1).count();
        long zone2Count = stateCounties.stream().filter(c -> c.getEpaZone() == 2).count();
        long zone3Count = stateCounties.stream().filter(c -> c.getEpaZone() == 3).count();

        model.addAttribute("stateSlug", canonicalStateSlug);
        model.addAttribute("stateAbbr", stateAbbr);
        model.addAttribute("stateRule", resolveStateRule(stateAbbr));
        model.addAttribute("counties", visibleCounties);
        model.addAttribute("zone1Count", zone1Count);
        model.addAttribute("zone2Count", zone2Count);
        model.addAttribute("zone3Count", zone3Count);
        model.addAttribute("noindex", visibleCounties.isEmpty());

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

        model.addAttribute("noindex", !(quality.isIndexable() && seoIndexingPolicyService.isCountyIndexableCandidate(county)));
        model.addAttribute("quality", quality);
        model.addAttribute("trust", trust);
        model.addAttribute("aeo", aeo);
        model.addAttribute("relatedLinks", internalLinkService.buildRadonLevelsCountyLinks(county, nearbyCounties));
        model.addAttribute("monetizationHooksEnabled", monetizationHooksEnabled);
        model.addAttribute("showSeoDebug", seoDebugVisible);
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
        RedirectView view = new RedirectView(path, true);
        view.setStatusCode(HttpStatus.MOVED_PERMANENTLY);
        return view;
    }

    private StateRegulations.StateRule resolveStateRule(String stateAbbr) {
        StateRegulations regulations = dataLoadService.getStateRegulations();
        if (regulations == null || stateAbbr == null) {
            return null;
        }
        return regulations.getStateRules().getOrDefault(
                stateAbbr.toUpperCase(),
                regulations.getDefaultStateRule());
    }
}
