package com.radonverdict.controller;

import com.radonverdict.model.County;
import com.radonverdict.model.CountyRadonMeasurement;
import com.radonverdict.model.CountyRadonTier;
import com.radonverdict.model.StateRegulations;
import com.radonverdict.model.dto.AeoAnswerBlock;
import com.radonverdict.model.dto.CountyRadonEvidence;
import com.radonverdict.model.dto.PageQualityResult;
import com.radonverdict.model.dto.RadonEvidenceCoverageSummary;
import com.radonverdict.model.dto.RadonNationalEvidenceInsight;
import com.radonverdict.model.dto.RadonStateEvidenceInsight;
import com.radonverdict.model.dto.SearchDemandProfile;
import com.radonverdict.model.dto.TrustMetadata;
import com.radonverdict.service.DataLoadService;
import com.radonverdict.service.CountyRadonEvidenceService;
import com.radonverdict.service.InternalLinkService;
import com.radonverdict.service.PageQualityService;
import com.radonverdict.service.SeoIndexingPolicyService;
import com.radonverdict.service.SearchDemandService;
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

import java.util.LinkedHashMap;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.function.Function;
import java.util.stream.Collectors;

@Controller
@RequiredArgsConstructor
public class RadonLevelsController {

    private final DataLoadService dataLoadService;
    private final CountyRadonEvidenceService countyRadonEvidenceService;
    private final PageQualityService pageQualityService;
    private final SeoIndexingPolicyService seoIndexingPolicyService;
    private final TrustMetadataService trustMetadataService;
    private final InternalLinkService internalLinkService;
    private final SearchDemandService searchDemandService;

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
        model.addAttribute("evidenceCoverage", buildEvidenceCoverageSummary(visibleCounties));
        model.addAttribute("nationalEvidenceInsight", buildNationalEvidenceInsight(stateMap, visibleCounties));
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
        model.addAttribute("evidenceCoverage", buildEvidenceCoverageSummary(visibleCounties));
        model.addAttribute("stateEvidenceInsight", buildStateEvidenceInsight(visibleCounties));
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
                .filter(seoIndexingPolicyService::isCountyIndexableCandidate)
                .sorted(Comparator
                        .comparingDouble((County c) -> measuredCountySimilarityScore(county, c))
                        .thenComparing((County c) -> c.getEpaZone() != county.getEpaZone())
                        .thenComparing((County c) -> -housingUnits(c))
                        .thenComparing(County::getCountyName))
                .limit(6)
                .collect(Collectors.toList());

        model.addAttribute("county", county);
        model.addAttribute("stateRule", stateRule);
        model.addAttribute("nearbyCounties", nearbyCounties);
        PageQualityResult quality = pageQualityService.scoreRadonLevelsCountyPage(county, nearbyCounties.size());
        TrustMetadata trust = trustMetadataService.forRadonLevelsCountyPage(county);
        CountyRadonEvidence radonEvidence = countyRadonEvidenceService.buildEvidence(county);
        AeoAnswerBlock aeo = buildRadonLevelAeoBlock(county, trust, radonEvidence);

        model.addAttribute("noindex", !(quality.isIndexable() && seoIndexingPolicyService.isCountyIndexableCandidate(county)));
        model.addAttribute("quality", quality);
        model.addAttribute("trust", trust);
        model.addAttribute("aeo", aeo);
        model.addAttribute("relatedLinks", internalLinkService.buildRadonLevelsCountyLinks(county, nearbyCounties));
        CountyRadonMeasurement radonMeasurement = dataLoadService.getRadonMeasurementByFipsMap().get(county.getFips());
        model.addAttribute("radonMeasurement", radonMeasurement);
        model.addAttribute("radonEvidence", radonEvidence);
        model.addAttribute("stateHousingPercentile", statePercentile(county, Metric.HOUSING_UNITS));
        model.addAttribute("stateOlderHomePercentile", statePercentile(county, Metric.OLDER_HOME_SHARE));
        model.addAttribute("statePeerCountyCount", statePeerCountyCount(county));
        model.addAttribute("priorityCounty", seoIndexingPolicyService.isPriorityCountyCandidate(county));
        model.addAttribute("searchTrafficCounty", seoIndexingPolicyService.isSearchTrafficCandidate(county));
        model.addAttribute("demandProfile", searchDemandService.profileForPath(
                "/radon-levels/" + county.getStateSlug() + "/" + county.getCountySlug()));
        model.addAttribute("monetizationHooksEnabled", monetizationHooksEnabled);
        model.addAttribute("showSeoDebug", seoDebugVisible);
        model.addAttribute("canonicalUrl",
                normalizedBaseUrl() + "/radon-levels/" + county.getStateSlug() + "/" + county.getCountySlug());

        return "radon_levels_county";
    }

    private AeoAnswerBlock buildRadonLevelAeoBlock(County county, TrustMetadata trust, CountyRadonEvidence radonEvidence) {
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

        boolean officialEvidencePriority = radonEvidence != null
                && ("high".equals(radonEvidence.getRiskTone()) || "elevated".equals(radonEvidence.getRiskTone()))
                && radonEvidence.getIntentQuestion() != null
                && !radonEvidence.getIntentQuestion().isBlank()
                && radonEvidence.getIntentAnswer() != null
                && !radonEvidence.getIntentAnswer().isBlank();
        String question = officialEvidencePriority
                ? radonEvidence.getIntentQuestion()
                : "What radon risk level should homeowners assume in " + county.getAreaDisplayName() + "?";
        String directAnswer = officialEvidencePriority
                ? radonEvidence.getIntentAnswer()
                : county.getAreaDisplayName() + " is currently categorized as " + zoneText + ". " + actionText;

        return AeoAnswerBlock.builder()
                .question(question)
                .directAnswer(directAnswer)
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

    private RadonEvidenceCoverageSummary buildEvidenceCoverageSummary(List<County> counties) {
        if (counties == null || counties.isEmpty()) {
            return RadonEvidenceCoverageSummary.builder()
                    .totalCount(0)
                    .sourceRows(List.of())
                    .build();
        }

        int measuredCount = 0;
        int tierCount = 0;
        int sourcePendingCount = 0;
        int stateOfficialMeasuredCount = 0;
        int cdcMeasuredCount = 0;
        Map<String, SourceAggregate> sources = new LinkedHashMap<>();

        for (County county : counties) {
            CountyRadonMeasurement measurement = dataLoadService.getRadonMeasurementByFipsMap().get(county.getFips());
            if (measurement != null) {
                measuredCount++;
                boolean cdcSource = "cdc_tracking_radon".equals(measurement.getSourceId());
                if (cdcSource) {
                    cdcMeasuredCount++;
                } else {
                    stateOfficialMeasuredCount++;
                }
                addSourceAggregate(sources,
                        measurement.getSourceId(),
                        measurement.getSourceName(),
                        cdcSource ? "CDC measurement" : officialMeasurementSourceType(measurement));
                continue;
            }

            CountyRadonTier tier = dataLoadService.getRadonTierByFipsMap().get(county.getFips());
            if (tier != null) {
                tierCount++;
                addSourceAggregate(sources, tier.getSourceId(), tier.getSourceName(), "Official tier");
            } else {
                sourcePendingCount++;
                addSourceAggregate(sources, "source_pending", "More county detail needed", "Needs more detail");
            }
        }

        int officialEvidenceCount = measuredCount + tierCount;
        int officialEvidencePercent = (int) Math.round((officialEvidenceCount * 100.0) / counties.size());
        List<RadonEvidenceCoverageSummary.SourceRow> sourceRows = sources.values().stream()
                .sorted(Comparator.comparingInt(SourceAggregate::count).reversed())
                .map(SourceAggregate::toRow)
                .toList();

        return RadonEvidenceCoverageSummary.builder()
                .totalCount(counties.size())
                .measuredCount(measuredCount)
                .tierCount(tierCount)
                .sourcePendingCount(sourcePendingCount)
                .stateOfficialMeasuredCount(stateOfficialMeasuredCount)
                .cdcMeasuredCount(cdcMeasuredCount)
                .officialEvidenceCount(officialEvidenceCount)
                .officialEvidencePercent(officialEvidencePercent)
                .sourceRows(sourceRows)
                .build();
    }

    private RadonNationalEvidenceInsight buildNationalEvidenceInsight(Map<String, List<County>> stateMap,
            List<County> visibleCounties) {
        if (stateMap == null || stateMap.isEmpty() || visibleCounties == null || visibleCounties.isEmpty()) {
            return null;
        }

        RadonEvidenceCoverageSummary coverage = buildEvidenceCoverageSummary(visibleCounties);
        List<RadonNationalEvidenceInsight.StateEvidenceRow> priorityRows = stateMap.entrySet().stream()
                .map(entry -> nationalStateRow(entry.getKey(), entry.getValue()))
                .filter(row -> row != null)
                .sorted((left, right) -> Double.compare(
                        nationalStatePriorityScore(right),
                        nationalStatePriorityScore(left)))
                .limit(8)
                .toList();

        int measuredCount = coverage.getMeasuredCount();
        int stateOfficialCount = coverage.getStateOfficialMeasuredCount();
        int cdcCount = coverage.getCdcMeasuredCount();
        int tierCount = coverage.getTierCount();
        int pendingCount = coverage.getSourcePendingCount();

        return RadonNationalEvidenceInsight.builder()
                .visibleCountyCount(visibleCounties.size())
                .measuredCountyCount(measuredCount)
                .stateOfficialMeasuredCount(stateOfficialCount)
                .cdcMeasuredCount(cdcCount)
                .tierBackedCount(tierCount)
                .sourcePendingCount(pendingCount)
                .decisionHeadline("Start with the national action threshold, then open states with the strongest county evidence.")
                .routerSummary("This page connects the plain 2.0, 4.0, and 8.0 pCi/L answer to state hubs where county evidence is strongest: "
                        + coverage.getOfficialEvidenceCount() + " of " + coverage.getTotalCount()
                        + " surfaced county pages have official evidence, with " + measuredCount
                        + " measured county summaries and " + tierCount + " official map-classification summaries.")
                .sourceMoatSummary(officialSourceSummary(stateOfficialCount, cdcCount, tierCount, pendingCount))
                .deployReadinessSummary(userRoutingSummary(coverage))
                .priorityStateRows(priorityRows)
                .build();
    }

    private RadonNationalEvidenceInsight.StateEvidenceRow nationalStateRow(String stateAbbr, List<County> counties) {
        if (counties == null || counties.isEmpty()) {
            return null;
        }

        RadonEvidenceCoverageSummary coverage = buildEvidenceCoverageSummary(counties);
        List<MeasurementSignal> signals = counties.stream()
                .map(this::measurementSignal)
                .filter(signal -> signal != null)
                .toList();
        long highCount = signals.stream()
                .filter(signal -> "high".equals(riskTone(signal.primaryResult(), signal.above4())))
                .count();
        long elevatedOrHighCount = signals.stream()
                .filter(signal -> {
                    String tone = riskTone(signal.primaryResult(), signal.above4());
                    return "high".equals(tone) || "elevated".equals(tone);
                })
                .count();
        String statePath = "/radon-levels/" + counties.get(0).getStateSlug();

        return RadonNationalEvidenceInsight.StateEvidenceRow.builder()
                .stateAbbr(stateAbbr)
                .statePath(statePath)
                .priorityLabel(priorityStateLabel(coverage, highCount, elevatedOrHighCount))
                .coverageDisplay(coverage.getOfficialEvidenceCount() + "/" + coverage.getTotalCount()
                        + " counties with official support")
                .measuredDisplay(coverage.getMeasuredCount() + " measured, " + coverage.getTierCount()
                        + " map-classified")
                .elevatedDisplay(elevatedOrHighCount + " elevated/high, " + highCount + " high")
                .sourceMixDisplay(stateSourceMixDisplay(coverage))
                .decisionDisplay(stateRouteDecisionDisplay(stateAbbr, coverage, elevatedOrHighCount, highCount))
                .build();
    }

    private double nationalStatePriorityScore(RadonNationalEvidenceInsight.StateEvidenceRow row) {
        if (row == null) {
            return 0.0;
        }
        double score = 0.0;
        String coverage = row.getCoverageDisplay() != null ? row.getCoverageDisplay() : "";
        String measured = row.getMeasuredDisplay() != null ? row.getMeasuredDisplay() : "";
        String elevated = row.getElevatedDisplay() != null ? row.getElevatedDisplay() : "";
        score += parseLeadingInt(coverage) * 2.0;
        score += parseLeadingInt(measured) * 3.0;
        score += parseLeadingInt(elevated) * 8.0;
        if (row.getSourceMixDisplay() != null && row.getSourceMixDisplay().contains("state measurement")) {
            score += 35.0;
        }
        if ("Start here".equals(row.getPriorityLabel())) {
            score += 40.0;
        } else if ("Strong evidence".equals(row.getPriorityLabel())) {
            score += 25.0;
        }
        return score;
    }

    private int parseLeadingInt(String value) {
        if (value == null || value.isBlank()) {
            return 0;
        }
        StringBuilder digits = new StringBuilder();
        for (int i = 0; i < value.length(); i++) {
            char ch = value.charAt(i);
            if (Character.isDigit(ch)) {
                digits.append(ch);
            } else if (digits.length() > 0) {
                break;
            }
        }
        return digits.length() > 0 ? Integer.parseInt(digits.toString()) : 0;
    }

    private String priorityStateLabel(RadonEvidenceCoverageSummary coverage, long highCount, long elevatedOrHighCount) {
        if (highCount > 0 && coverage.getStateOfficialMeasuredCount() > 0) {
            return "Start here";
        }
        if (elevatedOrHighCount > 0 && coverage.getMeasuredCount() > 0) {
            return "Strong evidence";
        }
        if (coverage.getOfficialEvidencePercent() >= 95) {
            return "Broad coverage";
        }
        return "More context";
    }

    private String stateSourceMixDisplay(RadonEvidenceCoverageSummary coverage) {
        if (coverage.getStateOfficialMeasuredCount() > 0 && coverage.getCdcMeasuredCount() > 0) {
            return coverage.getStateOfficialMeasuredCount() + " state measurement, "
                    + coverage.getCdcMeasuredCount() + " CDC";
        }
        if (coverage.getStateOfficialMeasuredCount() > 0) {
            return coverage.getStateOfficialMeasuredCount() + " state measurement summaries";
        }
        if (coverage.getCdcMeasuredCount() > 0) {
            return coverage.getCdcMeasuredCount() + " CDC summaries";
        }
        if (coverage.getTierCount() > 0) {
            return coverage.getTierCount() + " official map-classification summaries";
        }
        return coverage.getSourcePendingCount() + " counties need more county detail";
    }

    private String stateRouteDecisionDisplay(String stateAbbr, RadonEvidenceCoverageSummary coverage,
            long elevatedOrHighCount, long highCount) {
        if (highCount > 0) {
            return stateAbbr + " is a strong starting point because it has " + highCount
                    + " counties with high measured radon signals and " + coverage.getStateOfficialMeasuredCount()
                    + " state measurement summaries.";
        }
        if (elevatedOrHighCount > 0) {
            return stateAbbr + " is worth opening before a generic threshold guide because " + elevatedOrHighCount
                    + " visible counties are elevated or high in official measurements.";
        }
        if (coverage.getOfficialEvidencePercent() >= 95) {
            return stateAbbr + " is useful as a coverage hub: most visible counties have official evidence, but the page should still lead users to a home test.";
        }
        return stateAbbr + " has less county-specific detail: use county pages as context and let the home test control the decision.";
    }

    private String officialSourceSummary(int stateOfficialCount, int cdcCount, int tierCount, int pendingCount) {
        return "Official source base: " + stateOfficialCount + " county summaries come from state-specific or federal measurement tables, "
                + cdcCount + " use CDC Tracking, " + tierCount
                + " use official state or federal map classifications, and " + pendingCount
                + " need more county-specific detail. That helps users tell the difference between a county with reported test data and a broader map guide.";
    }

    private String userRoutingSummary(RadonEvidenceCoverageSummary coverage) {
        if (coverage.getSourcePendingCount() <= 1 && coverage.getOfficialEvidencePercent() >= 99) {
            return "Most surfaced county pages now have official evidence behind them, so users can start with source-backed pages instead of a generic national answer.";
        }
        return "Official coverage is strong enough to use, but lighter-evidence counties should keep clear source caveats until more detailed county tables are available.";
    }

    private RadonStateEvidenceInsight buildStateEvidenceInsight(List<County> counties) {
        if (counties == null || counties.isEmpty()) {
            return null;
        }

        List<MeasurementSignal> signals = counties.stream()
                .map(this::measurementSignal)
                .filter(signal -> signal != null)
                .toList();

        if (signals.isEmpty()) {
            return null;
        }

        long highMeasuredCount = signals.stream()
                .filter(signal -> "high".equals(riskTone(signal.primaryResult(), signal.above4())))
                .count();
        long elevatedOrHighCount = signals.stream()
                .filter(signal -> {
                    String tone = riskTone(signal.primaryResult(), signal.above4());
                    return "high".equals(tone) || "elevated".equals(tone);
                })
                .count();
        long zoneUnderstatedCount = signals.stream()
                .filter(signal -> signal.county().getEpaZone() != 1)
                .filter(signal -> {
                    String tone = riskTone(signal.primaryResult(), signal.above4());
                    return "high".equals(tone) || "elevated".equals(tone);
                })
                .count();
        long cdcCount = signals.stream()
                .filter(signal -> "cdc_tracking_radon".equals(signal.measurement().getSourceId()))
                .count();
        long stateSourceCount = signals.size() - cdcCount;
        List<RadonStateEvidenceInsight.CountySignalRow> priorityDecisionRows = priorityDecisionRows(signals);

        return RadonStateEvidenceInsight.builder()
                .measuredCountyCount(signals.size())
                .decisionHeadline(stateDecisionHeadline(signals.size(), highMeasuredCount, elevatedOrHighCount))
                .stateDecisionSummary(stateDecisionSummary(signals.size(), highMeasuredCount, elevatedOrHighCount,
                        zoneUnderstatedCount))
                .firstClickSummary(firstClickSummary(priorityDecisionRows, elevatedOrHighCount))
                .buyerSellerSummary(stateBuyerSellerSummary(elevatedOrHighCount, stateSourceCount, cdcCount))
                .retestSummary(stateRetestSummary(signals.size(), elevatedOrHighCount))
                .patternSummary(statePatternSummary(signals.size(), highMeasuredCount, elevatedOrHighCount))
                .zoneContrastSummary(zoneContrastSummary(zoneUnderstatedCount, elevatedOrHighCount))
                .sourceStrategySummary(sourceStrategySummary(stateSourceCount, cdcCount))
                .priorityDecisionRows(priorityDecisionRows)
                .topAbove4Rows(topSignalRows(
                        signals,
                        MeasurementSignal::above4,
                        "Highest 4.0+ share",
                        this::formatPercent,
                        signal -> "Primary result " + formatPci(signal.primaryResult())
                                + " - high-end " + formatPci(signal.highEnd())))
                .topHighEndRows(topSignalRows(
                        signals,
                        MeasurementSignal::highEnd,
                        "Highest high-end reading",
                        this::formatPci,
                        signal -> highEndOnlySignal(signal)
                                ? "highest measured county value from source"
                                : "4.0+ share " + formatPercent(signal.above4())
                                + " - primary result " + formatPci(signal.primaryResult())))
                .topTestVolumeRows(topSignalRows(
                        signals,
                        MeasurementSignal::testVolume,
                        "Most reported tests",
                        this::formatVolume,
                        signal -> "4.0+ share " + formatPercent(signal.above4())
                                + " - primary result " + formatPci(signal.primaryResult())))
                .build();
    }

    private String stateDecisionHeadline(int measuredCountyCount, long highMeasuredCount, long elevatedOrHighCount) {
        if (highMeasuredCount > 0) {
            return "This hub has measured high-burden counties, so the first click should be evidence-led.";
        }
        if (elevatedOrHighCount > 0) {
            return "This hub has elevated measured counties, so the map is only the starting point.";
        }
        if (measuredCountyCount > 0) {
            return "This hub has official measurement coverage, but most visible counties need home-specific confirmation.";
        }
        return "This hub needs county measurement coverage before it can rank local radon decisions.";
    }

    private String stateDecisionSummary(int measuredCountyCount, long highMeasuredCount, long elevatedOrHighCount,
            long zoneUnderstatedCount) {
        String base = "The state hub is now doing a decision job: it separates first-click counties, retest counties, and lower-signal counties from "
                + measuredCountyCount + " visible county measurement rows.";
        if (highMeasuredCount > 0) {
            return base + " " + highMeasuredCount
                    + " counties cross the high measured-burden band, so those pages should answer testing and 4.0+ action questions most directly.";
        }
        if (elevatedOrHighCount > 0) {
            return base + " " + elevatedOrHighCount
                    + " counties are elevated or high, including " + zoneUnderstatedCount
                    + " where the EPA zone alone understates the measured signal.";
        }
        return base + " None of the visible measured counties cross the elevated band, so the hub should emphasize home-specific testing rather than implied statewide danger.";
    }

    private String firstClickSummary(List<RadonStateEvidenceInsight.CountySignalRow> rows, long elevatedOrHighCount) {
        if (rows == null || rows.isEmpty()) {
            return "No first-click county lane is shown until at least one visible county has a measured radon row.";
        }
        RadonStateEvidenceInsight.CountySignalRow top = rows.get(0);
        return "Open " + top.getCountyName() + " first when you need the strongest local answer. It is tagged "
                + top.getMetricDisplay() + " from " + top.getSupportingDisplay() + ". "
                + elevatedOrHighCount + " visible measured counties are elevated or high enough to review before lower-signal counties.";
    }

    private String stateBuyerSellerSummary(long elevatedOrHighCount, long stateSourceCount, long cdcCount) {
        String sourceText = stateSourceCount > 0
                ? stateSourceCount + " state-source county rows"
                : cdcCount + " CDC-backed county rows";
        if (elevatedOrHighCount > 0) {
            return "Buyer/seller lane: start with the elevated or high counties, require a fresh lowest-level test, and turn any 4.0+ property result into quote or credit math. The hub has "
                    + sourceText + " to support that routing.";
        }
        return "Buyer/seller lane: use the hub to pick the county page, but do not negotiate from statewide context alone. A property result still controls quotes and credits.";
    }

    private String stateRetestSummary(int measuredCountyCount, long elevatedOrHighCount) {
        if (elevatedOrHighCount > 0) {
            return "Retest lane: 2.0-3.9 pCi/L deserves more caution in the elevated/high county set than in lower-signal counties. The hub should send those users to county pages before product or cost paths.";
        }
        return "Retest lane: with " + measuredCountyCount
                + " measured county rows and no elevated statewide cluster, 2.0-3.9 pCi/L is mostly a confirm-or-monitor decision until a home repeats higher.";
    }

    private String statePatternSummary(int measuredCountyCount, long highMeasuredCount, long elevatedOrHighCount) {
        return "Among " + measuredCountyCount + " visible counties with measurement tables, "
                + highMeasuredCount + " land in the high measured-burden band and "
                + elevatedOrHighCount + " land in high or elevated measured-burden bands. That lets this hub rank counties by observed test distribution instead of repeating the EPA map.";
    }

    private String zoneContrastSummary(long zoneUnderstatedCount, long elevatedOrHighCount) {
        if (zoneUnderstatedCount <= 0) {
            return "The strongest measured signals mostly align with the EPA zone structure, so the county pages can use the map as support while still leading with test data.";
        }
        return zoneUnderstatedCount + " elevated measured counties are not EPA Zone 1. Those are the pages where the actual test distribution matters more than a map-only answer.";
    }

    private String sourceStrategySummary(long stateSourceCount, long cdcCount) {
        if (stateSourceCount > 0 && cdcCount > 0) {
            return stateSourceCount + " measured counties use state-specific sources and " + cdcCount
                    + " use CDC Tracking. State-specific sources carry the clearest local context; CDC rows remain useful but need peer comparison and home-test decision framing.";
        }
        if (stateSourceCount > 0) {
            return "All measured rows shown here use state-specific official sources, so this hub can make source-backed county comparisons without leaning on a national fallback.";
        }
        return "The measured rows shown here use CDC Tracking. This is still official evidence, but the hub should keep source caveats visible until a stable state table is available.";
    }

    private MeasurementSignal measurementSignal(County county) {
        CountyRadonMeasurement measurement = dataLoadService.getRadonMeasurementByFipsMap().get(county.getFips());
        if (measurement == null || measurement.getMetrics() == null) {
            return null;
        }

        CountyRadonMeasurement.Metrics metrics = measurement.getMetrics();
        Double primaryResult = firstNonNull(
                metrics.getAverageTestResultPciL(),
                metrics.getArithmeticMeanRadonValuePciL(),
                metrics.getMedianRadonValuePciL());
        Double above4 = metrics.getPercentTestsAtOrAbove4PciL();
        Double highEnd = firstNonNull(metrics.getRadon95thPercentilePciL(), metrics.getMaximumTestResultPciL());
        Double testVolume = testVolume(measurement);

        return new MeasurementSignal(county, measurement, primaryResult, above4, highEnd, testVolume);
    }

    private List<RadonStateEvidenceInsight.CountySignalRow> topSignalRows(
            List<MeasurementSignal> signals,
            Function<MeasurementSignal, Double> metricExtractor,
            String metricLabel,
            Function<Double, String> formatter,
            Function<MeasurementSignal, String> supportingDisplay) {
        return signals.stream()
                .filter(signal -> metricExtractor.apply(signal) != null)
                .sorted((left, right) -> Double.compare(metricExtractor.apply(right), metricExtractor.apply(left)))
                .limit(5)
                .map(signal -> RadonStateEvidenceInsight.CountySignalRow.builder()
                        .countyName(signal.county().getAreaDisplayName())
                        .countyPath("/radon-levels/" + signal.county().getStateSlug() + "/"
                                + signal.county().getCountySlug())
                        .metricLabel(metricLabel)
                        .metricDisplay(formatter.apply(metricExtractor.apply(signal)))
                        .supportingDisplay(supportingDisplay.apply(signal))
                        .sourceShortName(sourceShortName(signal.measurement()))
                        .riskTone(riskTone(signal.primaryResult(), signal.above4()))
                        .build())
                .toList();
    }

    private List<RadonStateEvidenceInsight.CountySignalRow> priorityDecisionRows(List<MeasurementSignal> signals) {
        return signals.stream()
                .filter(signal -> signal.primaryResult() != null || signal.above4() != null || signal.highEnd() != null)
                .sorted((left, right) -> Double.compare(priorityScore(right), priorityScore(left)))
                .limit(4)
                .map(signal -> RadonStateEvidenceInsight.CountySignalRow.builder()
                        .countyName(signal.county().getAreaDisplayName())
                        .countyPath("/radon-levels/" + signal.county().getStateSlug() + "/"
                                + signal.county().getCountySlug())
                        .metricLabel("Priority county lane")
                        .metricDisplay(decisionTag(signal))
                        .supportingDisplay(highEndOnlySignal(signal)
                                ? formatPci(signal.highEnd()) + " highest measured - source does not publish a county average"
                                : formatPercent(signal.above4()) + " 4.0+ - "
                                        + formatPci(signal.primaryResult()) + " primary - "
                                        + formatVolume(signal.testVolume()) + " tests")
                        .decisionDisplay(priorityDecisionDisplay(signal))
                        .sourceShortName(sourceShortName(signal.measurement()))
                        .riskTone(riskTone(signal.primaryResult(), signal.above4()))
                        .build())
                .toList();
    }

    private double priorityScore(MeasurementSignal signal) {
        String tone = riskTone(signal.primaryResult(), signal.above4());
        double score = highEndOnlySignal(signal)
                ? 35.0
                : switch (tone) {
            case "high" -> 100.0;
            case "elevated" -> 75.0;
            case "borderline" -> 45.0;
            case "lower" -> 15.0;
            default -> 0.0;
        };
        if (highEndOnlySignal(signal)) {
            score += Math.min(35.0, signal.highEnd() / 8.0);
        }
        if (signal.above4() != null) {
            score += signal.above4();
        }
        if (signal.primaryResult() != null) {
            score += signal.primaryResult() * 8.0;
        }
        if (signal.testVolume() != null) {
            score += Math.min(18.0, Math.log10(signal.testVolume() + 1.0) * 4.0);
        }
        if (signal.county().getEpaZone() != 1 && ("high".equals(tone) || "elevated".equals(tone))) {
            score += 6.0;
        }
        return score;
    }

    private String decisionTag(MeasurementSignal signal) {
        if (highEndOnlySignal(signal)) {
            return signal.highEnd() != null && signal.highEnd() >= 4.0 ? "High-end signal" : "Source check";
        }
        return switch (riskTone(signal.primaryResult(), signal.above4())) {
            case "high" -> "Test-now";
            case "elevated" -> "Priority test";
            case "borderline" -> "Retest lane";
            case "lower" -> "Home-specific";
            default -> "Source check";
        };
    }

    private String priorityDecisionDisplay(MeasurementSignal signal) {
        String place = signal.county().getAreaDisplayName();
        if (highEndOnlySignal(signal)) {
            return place + " has an official high-end county value of " + formatPci(signal.highEnd())
                    + ". Open it when the user needs proof that elevated readings have occurred locally, but keep the next step tied to a home-specific test.";
        }
        String evidence = formatPercent(signal.above4()) + " of reported tests at or above 4.0 and "
                + formatPci(signal.primaryResult()) + " primary result";
        return switch (riskTone(signal.primaryResult(), signal.above4())) {
            case "high" -> place + " is a first-click page: " + evidence
                    + ". Route no-reading users to a test now and 4.0+ users to quote or credit planning.";
            case "elevated" -> place + " should be opened before lower-signal counties: " + evidence
                    + ". It is strong enough for testing and retesting language on the hub.";
            case "borderline" -> place + " belongs in the retest lane: " + evidence
                    + ". A 2.0-3.9 home result should be confirmed before the user dismisses it.";
            case "lower" -> place + " is lower at county level: " + evidence
                    + ". Keep the page home-specific rather than presenting it as a statewide alarm.";
            default -> place + " has an official measurement row, but the home result still controls the decision.";
        };
    }

    private Double testVolume(CountyRadonMeasurement measurement) {
        if (measurement == null || measurement.getMetrics() == null) {
            return null;
        }

        CountyRadonMeasurement.Metrics metrics = measurement.getMetrics();
        if (metrics.getTotalTests() != null) {
            return metrics.getTotalTests();
        }
        if (metrics.getNumberBuildingsTested10Year() != null) {
            return metrics.getNumberBuildingsTested10Year();
        }
        if (metrics.getAverageNumberOfTests() == null) {
            return null;
        }

        int periodYears = periodYears(measurement.getPeriod());
        return metrics.getAverageNumberOfTests() * periodYears;
    }

    private int periodYears(String period) {
        if (period == null || !period.matches("\\d{4}-\\d{4}")) {
            return 1;
        }
        String[] parts = period.split("-");
        int start = Integer.parseInt(parts[0]);
        int end = Integer.parseInt(parts[1]);
        return Math.max(1, end - start + 1);
    }

    private double measuredCountySimilarityScore(County targetCounty, County peerCounty) {
        MeasurementSignal target = measurementSignal(targetCounty);
        MeasurementSignal peer = measurementSignal(peerCounty);
        if (target == null || peer == null) {
            return 10.0;
        }

        double score = 0.0;
        score += normalizedDiff(target.above4(), peer.above4(), 100.0) * 5.0;
        score += normalizedDiff(target.primaryResult(), peer.primaryResult(), 10.0) * 3.0;
        score += normalizedDiff(target.highEnd(), peer.highEnd(), 100.0);
        if (target.measurement().getSourceId() != null
                && target.measurement().getSourceId().equals(peer.measurement().getSourceId())) {
            score -= 0.35;
        }
        return Math.max(0.0, score);
    }

    private double normalizedDiff(Double left, Double right, double scale) {
        if (left == null || right == null) {
            return 1.0;
        }
        return Math.min(1.0, Math.abs(left - right) / scale);
    }

    private String riskTone(Double primaryResult, Double above4) {
        double primary = primaryResult != null ? primaryResult : -1;
        double elevatedShare = above4 != null ? above4 : -1;
        if (primary >= 4.0 || elevatedShare >= 40.0) {
            return "high";
        }
        if (primary >= 3.0 || elevatedShare >= 25.0) {
            return "elevated";
        }
        if (primary >= 2.0 || elevatedShare >= 10.0) {
            return "borderline";
        }
        if (primary >= 0 || elevatedShare >= 0) {
            return "lower";
        }
        return "unknown";
    }

    private String sourceShortName(CountyRadonMeasurement measurement) {
        if (measurement == null || measurement.getSourceId() == null) {
            return "official source";
        }
        return switch (measurement.getSourceId()) {
            case "tn_health_radon" -> "TN Health";
            case "pa_dep_radon_zip" -> "PA DEP";
            case "va_vdh_radon" -> "VDH";
            case "mo_dhss_radon" -> "MO DHSS";
            case "ut_epht_radon" -> "UT EPHT";
            case "ia_hhs_radon" -> "IA HHS";
            case "nc_dhhs_radon" -> "NC DHHS";
            case "epa_usgs_ms_residential_radon_survey" -> "EPA/USGS MS";
            case "ny_doh_tracking_radon" -> "NY DOH";
            case "mn_health_radon" -> "MN Health";
            case "ks_kdhe_radon" -> "KDHE";
            case "co_cdphe_radon" -> "CDPHE";
            case "wi_dhs_radon" -> "WI DHS";
            case "cdc_tracking_radon" -> "CDC Tracking";
            default -> measurement.getSourceName() != null ? measurement.getSourceName() : "official source";
        };
    }

    private String officialMeasurementSourceType(CountyRadonMeasurement measurement) {
        if (measurement != null && "epa_usgs_ms_residential_radon_survey".equals(measurement.getSourceId())) {
            return "Federal survey";
        }
        return "State measurement";
    }

    private String formatPci(Double value) {
        return value != null ? String.format(java.util.Locale.US, "%.1f pCi/L", value) : "n/a";
    }

    private String formatPercent(Double value) {
        return value != null ? String.format(java.util.Locale.US, "%.1f%%", value) : "n/a";
    }

    private String formatVolume(Double value) {
        return value != null ? String.format(java.util.Locale.US, "%,.0f", value) : "n/a";
    }

    private boolean highEndOnlySignal(MeasurementSignal signal) {
        return signal != null
                && signal.primaryResult() == null
                && signal.above4() == null
                && signal.highEnd() != null;
    }

    @SafeVarargs
    private final <T> T firstNonNull(T... values) {
        for (T value : values) {
            if (value != null) {
                return value;
            }
        }
        return null;
    }

    private void addSourceAggregate(Map<String, SourceAggregate> sources, String sourceId, String sourceName,
            String sourceType) {
        String id = sourceId == null || sourceId.isBlank() ? "unknown_source" : sourceId;
        SourceAggregate aggregate = sources.computeIfAbsent(id,
                key -> new SourceAggregate(id,
                        sourceName == null || sourceName.isBlank() ? id : sourceName,
                        sourceType));
        aggregate.increment();
    }

    private int housingUnits(County county) {
        if (county == null || county.getStats() == null || county.getStats().getMetrics() == null) {
            return 0;
        }
        return county.getStats().getMetrics().getTotalHousingUnits();
    }

    private int statePeerCountyCount(County county) {
        if (county == null) {
            return 0;
        }
        return (int) dataLoadService.getCountyBySlugMap().values().stream()
                .filter(c -> c.getStateAbbr().equalsIgnoreCase(county.getStateAbbr()))
                .filter(c -> c.getStats() != null && c.getStats().getMetrics() != null)
                .count();
    }

    private int statePercentile(County county, Metric metric) {
        if (county == null || county.getStats() == null || county.getStats().getMetrics() == null) {
            return 0;
        }

        double value = metric.value(county);
        List<Double> values = dataLoadService.getCountyBySlugMap().values().stream()
                .filter(c -> c.getStateAbbr().equalsIgnoreCase(county.getStateAbbr()))
                .filter(c -> c.getStats() != null && c.getStats().getMetrics() != null)
                .map(metric::value)
                .sorted()
                .toList();

        if (values.isEmpty()) {
            return 0;
        }

        long lessOrEqual = values.stream().filter(v -> v <= value).count();
        return (int) Math.round((lessOrEqual * 100.0) / values.size());
    }

    private enum Metric {
        HOUSING_UNITS {
            @Override
            double value(County county) {
                return county.getStats().getMetrics().getTotalHousingUnits();
            }
        },
        OLDER_HOME_SHARE {
            @Override
            double value(County county) {
                return county.getStats().getMetrics().getBuiltBefore1980Pct();
            }
        };

        abstract double value(County county);
    }

    private record MeasurementSignal(
            County county,
            CountyRadonMeasurement measurement,
            Double primaryResult,
            Double above4,
            Double highEnd,
            Double testVolume) {
    }

    private static class SourceAggregate {
        private final String sourceId;
        private final String sourceName;
        private final String sourceType;
        private int count;

        SourceAggregate(String sourceId, String sourceName, String sourceType) {
            this.sourceId = sourceId;
            this.sourceName = sourceName;
            this.sourceType = sourceType;
        }

        void increment() {
            count++;
        }

        int count() {
            return count;
        }

        RadonEvidenceCoverageSummary.SourceRow toRow() {
            return RadonEvidenceCoverageSummary.SourceRow.builder()
                    .sourceId(sourceId)
                    .sourceName(sourceName)
                    .sourceType(sourceType)
                    .count(count)
                    .build();
        }
    }
}
