package com.radonverdict.service;

import com.radonverdict.model.County;
import com.radonverdict.model.CountyRadonMeasurement;
import com.radonverdict.model.dto.CountyPageContent;
import com.radonverdict.model.dto.InternalLinkItem;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class InternalLinkService {

    private final DataLoadService dataLoadService;
    private final SeoIndexingPolicyService seoIndexingPolicyService;

    public List<InternalLinkItem> buildMitigationCountyLinks(County county, CountyPageContent page) {
        Map<String, InternalLinkItem> links = new LinkedHashMap<>();
        if (county == null) {
            return List.of();
        }

        add(links, InternalLinkItem.builder()
                .title("Radon Mitigation Cost Guide")
                .description("National cost ranges by foundation, result, and state.")
                .url("/radon-mitigation-cost")
                .bucket("pillar")
                .build());

        add(links, InternalLinkItem.builder()
                .title(county.getAreaDisplayName() + " Radon Levels")
                .description("EPA zone interpretation and testing guidance.")
                .url("/radon-levels/" + county.getStateSlug() + "/" + county.getCountySlug())
                .bucket("zone")
                .build());

        add(links, InternalLinkItem.builder()
                .title(county.getStateAbbr() + " Mitigation Cost Hub")
                .description("Browse every county cost page in the state.")
                .url("/radon-mitigation-cost/" + county.getStateSlug())
                .bucket("state")
                .build());

        add(links, InternalLinkItem.builder()
                .title("How to Test for Radon")
                .description("Step-by-step sampling protocol and threshold guidance.")
                .url("/guides/how-to-test-for-radon")
                .bucket("topic")
                .build());

        add(links, zoneGuideLink(county.getEpaZone()));
        add(links, intentGuideLink(county, page));

        List<County> sameZoneNearby = dataLoadService.getCountyBySlugMap().values().stream()
                .filter(c -> c.getStateAbbr().equalsIgnoreCase(county.getStateAbbr()))
                .filter(c -> !c.getCountySlug().equalsIgnoreCase(county.getCountySlug()))
                .filter(seoIndexingPolicyService::isCountyIndexableCandidate)
                .filter(c -> c.getEpaZone() == county.getEpaZone())
                .sorted((left, right) -> left.getCountyName().compareToIgnoreCase(right.getCountyName()))
                .limit(3)
                .toList();

        for (County nearby : sameZoneNearby) {
            add(links, InternalLinkItem.builder()
                    .title("Cost in " + nearby.getAreaDisplayName())
                    .description("Compare same-zone county pricing in " + county.getStateAbbr() + ".")
                    .url("/radon-mitigation-cost/" + nearby.getStateSlug() + "/" + nearby.getCountySlug())
                    .bucket("zone")
                    .build());
        }

        return new ArrayList<>(links.values());
    }

    public List<InternalLinkItem> buildRadonLevelsCountyLinks(County county, List<County> nearbyCounties) {
        Map<String, InternalLinkItem> links = new LinkedHashMap<>();
        if (county == null) {
            return List.of();
        }

        add(links, InternalLinkItem.builder()
                .title("Action Plan + Cost in " + county.getAreaDisplayName())
                .description("Use your test result to compare local next steps and budget.")
                .url("/radon-mitigation-cost/" + county.getStateSlug() + "/" + county.getCountySlug())
                .bucket("cost")
                .build());

        add(links, InternalLinkItem.builder()
                .title("Radon Levels: 2.0 vs 4.0 vs 8.0")
                .description("Understand what the numbers mean before comparing local next steps.")
                .url("/radon-levels")
                .bucket("pillar")
                .build());

        add(links, InternalLinkItem.builder()
                .title(county.getStateAbbr() + " Radon Levels Hub")
                .description("Compare measured 4.0+ share, high-end readings, and official source coverage.")
                .url("/radon-levels/" + county.getStateSlug())
                .bucket("state")
                .build());

        add(links, InternalLinkItem.builder()
                .title("How to Test for Radon")
                .description("Closed-house protocol, kit placement, and retest intervals.")
                .url("/guides/how-to-test-for-radon")
                .bucket("topic")
                .build());

        add(links, zoneGuideLink(county.getEpaZone()));
        add(links, InternalLinkItem.builder()
                .title("Who Pays: Buyer or Seller?")
                .description("Use radon cost context for credits, repairs, and closing negotiation.")
                .url("/guides/who-pays-radon-mitigation-buyer-or-seller")
                .bucket("intent")
                .build());

        add(links, InternalLinkItem.builder()
                .title("Local Seller Credit Calculator")
                .description("Turn this county's mitigation range into a repair or credit ask.")
                .url("/radon-credit-calculator/" + county.getStateSlug() + "/" + county.getCountySlug()
                        + "?intent=buying&radonResultBand=above_4")
                .bucket("intent")
                .build());

        buildMeasuredRiskPeerLinks(county).forEach(link -> add(links, link));

        if (nearbyCounties != null) {
            nearbyCounties.stream()
                    .filter(seoIndexingPolicyService::isCountyIndexableCandidate)
                    .limit(3)
                    .forEach(nearby -> add(links, InternalLinkItem.builder()
                    .title(nearby.getAreaDisplayName() + " Levels")
                    .description(nearbyDescription(county, nearby))
                    .url("/radon-levels/" + nearby.getStateSlug() + "/" + nearby.getCountySlug())
                    .bucket("measured-peer")
                    .build()));
        }

        return new ArrayList<>(links.values());
    }

    private List<InternalLinkItem> buildMeasuredRiskPeerLinks(County county) {
        CountyRadonMeasurement target = measurement(county);
        if (target == null || target.getMetrics() == null) {
            return List.of();
        }

        return dataLoadService.getCountyBySlugMap().values().stream()
                .filter(candidate -> candidate.getStateAbbr().equalsIgnoreCase(county.getStateAbbr()))
                .filter(candidate -> !candidate.getFips().equals(county.getFips()))
                .filter(seoIndexingPolicyService::isCountyIndexableCandidate)
                .filter(candidate -> measurement(candidate) != null)
                .sorted(Comparator
                        .comparingDouble((County candidate) -> measuredSimilarityScore(target, measurement(candidate)))
                        .thenComparing(County::getCountyName))
                .limit(2)
                .map(candidate -> InternalLinkItem.builder()
                        .title("Measured-risk peer: " + candidate.getAreaDisplayName())
                        .description(peerDescription(target, measurement(candidate)))
                        .url("/radon-levels/" + candidate.getStateSlug() + "/" + candidate.getCountySlug())
                        .bucket("measured-peer")
                        .build())
                .toList();
    }

    private String nearbyDescription(County county, County nearby) {
        CountyRadonMeasurement target = measurement(county);
        CountyRadonMeasurement peer = measurement(nearby);
        if (target == null || peer == null) {
            return "Same-state county comparison in " + county.getStateAbbr() + ".";
        }
        return peerDescription(target, peer);
    }

    private String peerDescription(CountyRadonMeasurement target, CountyRadonMeasurement peer) {
        Double targetAbove4 = above4(target);
        Double peerAbove4 = above4(peer);
        Double peerPrimary = primaryResult(peer);
        if (targetAbove4 != null && peerAbove4 != null) {
            return "Compare against a county with " + formatPercent(peerAbove4)
                    + " of reported tests at or above 4.0 pCi/L"
                    + (peerPrimary != null ? " and " + formatPci(peerPrimary) + " primary result." : ".");
        }
        if (peerPrimary != null) {
            return "Compare against a same-state county with " + formatPci(peerPrimary)
                    + " primary measured radon result.";
        }
        return "Compare against another same-state official measurement page.";
    }

    private double measuredSimilarityScore(CountyRadonMeasurement target, CountyRadonMeasurement peer) {
        double score = 0.0;
        score += normalizedDiff(above4(target), above4(peer), 100.0) * 5.0;
        score += normalizedDiff(primaryResult(target), primaryResult(peer), 10.0) * 3.0;
        score += normalizedDiff(highEnd(target), highEnd(peer), 100.0);
        if (target.getSourceId() != null && target.getSourceId().equals(peer.getSourceId())) {
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

    private CountyRadonMeasurement measurement(County county) {
        if (county == null) {
            return null;
        }
        return dataLoadService.getRadonMeasurementByFipsMap().get(county.getFips());
    }

    private Double primaryResult(CountyRadonMeasurement measurement) {
        if (measurement == null || measurement.getMetrics() == null) {
            return null;
        }
        CountyRadonMeasurement.Metrics metrics = measurement.getMetrics();
        if (metrics.getAverageTestResultPciL() != null) {
            return metrics.getAverageTestResultPciL();
        }
        if (metrics.getArithmeticMeanRadonValuePciL() != null) {
            return metrics.getArithmeticMeanRadonValuePciL();
        }
        return metrics.getMedianRadonValuePciL();
    }

    private Double above4(CountyRadonMeasurement measurement) {
        return measurement != null && measurement.getMetrics() != null
                ? measurement.getMetrics().getPercentTestsAtOrAbove4PciL()
                : null;
    }

    private Double highEnd(CountyRadonMeasurement measurement) {
        if (measurement == null || measurement.getMetrics() == null) {
            return null;
        }
        CountyRadonMeasurement.Metrics metrics = measurement.getMetrics();
        if (metrics.getRadon95thPercentilePciL() != null) {
            return metrics.getRadon95thPercentilePciL();
        }
        return metrics.getMaximumTestResultPciL();
    }

    private String formatPci(Double value) {
        return value != null ? String.format(Locale.US, "%.1f pCi/L", value) : "n/a";
    }

    private String formatPercent(Double value) {
        return value != null ? String.format(Locale.US, "%.1f%%", value) : "n/a";
    }

    private InternalLinkItem zoneGuideLink(int zone) {
        if (zone == 1) {
            return InternalLinkItem.builder()
                    .title("Radon Exposure Symptoms Guide")
                    .description("Health-risk context for elevated radon environments.")
                    .url("/guides/radon-exposure-symptoms")
                    .bucket("zone")
                    .build();
        }

        if (zone == 2) {
            return InternalLinkItem.builder()
                    .title("DIY vs Professional Mitigation")
                    .description("Decision framework for moderate-risk homes.")
                    .url("/guides/diy-vs-professional-radon-mitigation")
                    .bucket("zone")
                    .build();
        }

        if (zone == 3) {
            return InternalLinkItem.builder()
                    .title("Radon Myths: Granite Countertops")
                    .description("Low-risk zone misconceptions and evidence.")
                    .url("/guides/radon-myths-granite-countertops")
                    .bucket("zone")
                    .build();
        }

        return InternalLinkItem.builder()
                .title("How to Test for Radon")
                .description("Unknown-zone fallback: test the home directly.")
                .url("/guides/how-to-test-for-radon")
                .bucket("zone")
                .build();
    }

    private InternalLinkItem intentGuideLink(County county, CountyPageContent page) {
        String intent = page != null && page.getSelectedIntent() != null
                ? page.getSelectedIntent().toLowerCase(Locale.ROOT)
                : "";

        if (intent.contains("buy") || intent.contains("seller")) {
            return InternalLinkItem.builder()
                    .title("Local Seller Credit Calculator")
                    .description("Turn a local quote range into a cleaner repair or credit ask.")
                    .url("/radon-credit-calculator/" + county.getStateSlug() + "/" + county.getCountySlug()
                            + "?intent=" + page.getSelectedIntent()
                            + "&radonResultBand=" + page.getSelectedRadonResultBand())
                    .bucket("intent")
                    .build();
        }

        if (intent.contains("homeowner") || intent.contains("living")) {
            return InternalLinkItem.builder()
                    .title("Mitigation Timeline Guide")
                    .description("Typical install timeline and disruption expectations.")
                    .url("/guides/radon-mitigation-timeline-how-long-does-it-take")
                    .bucket("intent")
                    .build();
        }

        return InternalLinkItem.builder()
                .title("How to Test for Radon")
                .description("Default next step when intent is unclear.")
                .url("/guides/how-to-test-for-radon")
                .bucket("intent")
                .build();
    }

    private void add(Map<String, InternalLinkItem> links, InternalLinkItem item) {
        if (item == null || item.getUrl() == null || item.getUrl().isBlank()) {
            return;
        }
        links.putIfAbsent(item.getUrl(), item);
    }
}
