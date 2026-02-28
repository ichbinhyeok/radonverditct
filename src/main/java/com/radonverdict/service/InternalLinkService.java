package com.radonverdict.service;

import com.radonverdict.model.County;
import com.radonverdict.model.dto.CountyPageContent;
import com.radonverdict.model.dto.InternalLinkItem;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
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
        add(links, intentGuideLink(page));

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
                .title("Mitigation Cost in " + county.getAreaDisplayName())
                .description("Itemized local estimate by foundation and home size.")
                .url("/radon-mitigation-cost/" + county.getStateSlug() + "/" + county.getCountySlug())
                .bucket("cost")
                .build());

        add(links, InternalLinkItem.builder()
                .title(county.getStateAbbr() + " Radon Levels Hub")
                .description("Compare every county in the state.")
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

        if (nearbyCounties != null) {
            nearbyCounties.stream()
                    .filter(seoIndexingPolicyService::isCountyIndexableCandidate)
                    .limit(3)
                    .forEach(nearby -> add(links, InternalLinkItem.builder()
                    .title(nearby.getAreaDisplayName() + " Levels")
                    .description("Nearby county comparison in " + county.getStateAbbr() + ".")
                    .url("/radon-levels/" + nearby.getStateSlug() + "/" + nearby.getCountySlug())
                    .bucket("nearby")
                    .build()));
        }

        return new ArrayList<>(links.values());
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

    private InternalLinkItem intentGuideLink(CountyPageContent page) {
        String intent = page != null && page.getIntentSectionTitle() != null
                ? page.getIntentSectionTitle().toLowerCase(Locale.ROOT)
                : "";

        if (intent.contains("buy") || intent.contains("seller")) {
            return InternalLinkItem.builder()
                    .title("Who Pays: Buyer or Seller?")
                    .description("Real-estate negotiation patterns for radon mitigation.")
                    .url("/guides/who-pays-radon-mitigation-buyer-or-seller")
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
