package com.radonverdict.controller;

import com.radonverdict.model.County;
import com.radonverdict.model.StateRegulations;
import com.radonverdict.service.DataLoadService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.server.ResponseStatusException;

import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequiredArgsConstructor
public class RadonLevelsController {

    private final DataLoadService dataLoadService;

    @GetMapping("/radon-levels/{stateSlug}")
    public String stateLevelsHub(@PathVariable("stateSlug") String stateSlug, Model model) {
        List<County> stateCounties = dataLoadService.getCountyBySlugMap().values().stream()
                .filter(c -> c.getStateSlug().equalsIgnoreCase(stateSlug))
                .sorted(Comparator.comparing(County::getCountyName))
                .collect(Collectors.toList());

        if (stateCounties.isEmpty())
            throw new ResponseStatusException(HttpStatus.NOT_FOUND);

        String stateAbbr = stateCounties.get(0).getStateAbbr();

        // Count zones for state-level insight
        long zone1Count = stateCounties.stream().filter(c -> c.getEpaZone() == 1).count();
        long zone2Count = stateCounties.stream().filter(c -> c.getEpaZone() == 2).count();
        long zone3Count = stateCounties.stream().filter(c -> c.getEpaZone() == 3).count();

        model.addAttribute("stateSlug", stateSlug);
        model.addAttribute("stateAbbr", stateAbbr);
        model.addAttribute("counties", stateCounties);
        model.addAttribute("zone1Count", zone1Count);
        model.addAttribute("zone2Count", zone2Count);
        model.addAttribute("zone3Count", zone3Count);

        return "radon_levels_state";
    }

    @GetMapping("/radon-levels/{stateSlug}/{countySlug}")
    public String countyLevelsPage(@PathVariable("stateSlug") String stateSlug,
            @PathVariable("countySlug") String countySlug, Model model) {
        String key = stateSlug.toLowerCase() + "/" + countySlug.toLowerCase();
        County county = dataLoadService.getCountyBySlugMap().get(key);

        if (county == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "County not found");
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
        model.addAttribute("canonicalUrl",
                "https://radonverdict.com/radon-levels/" + stateSlug + "/" + countySlug);

        return "radon_levels_county";
    }
}
