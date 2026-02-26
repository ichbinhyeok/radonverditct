package com.radonverdict.service;

import com.radonverdict.model.County;
import com.radonverdict.model.CountyStats;
import com.radonverdict.model.dto.ItemizedReceipt;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Locale;

@Service
@RequiredArgsConstructor
public class CountyInsightService {

    private final DataLoadService dataLoadService;

    public List<String> buildLocalInsights(County county, ItemizedReceipt receipt) {
        if (county == null || county.getStats() == null || county.getStats().getMetrics() == null) {
            return List.of(
                    "County-level housing and valuation metrics are limited for this page. Use a direct home test and contractor quote for final decision-making.",
                    "Radon risk can vary significantly at the individual-home level even within the same county.",
                    "Collect at least two mitigation quotes and compare scope details (fan model, routing path, warranty, and post-mitigation retest plan).");
        }

        CountyStats.Metrics metrics = county.getStats().getMetrics();
        List<County> peers = dataLoadService.getCountyBySlugMap().values().stream()
                .filter(c -> c.getStateAbbr().equalsIgnoreCase(county.getStateAbbr()))
                .filter(c -> c.getStats() != null && c.getStats().getMetrics() != null)
                .toList();

        double stateAvgBuiltBefore1980 = peers.stream()
                .mapToDouble(c -> c.getStats().getMetrics().getBuiltBefore1980Pct())
                .average()
                .orElse(metrics.getBuiltBefore1980Pct());

        double stateAvgHomeValue = peers.stream()
                .mapToInt(c -> c.getStats().getMetrics().getMedianHomeValue())
                .average()
                .orElse(metrics.getMedianHomeValue());

        double housingDelta = metrics.getBuiltBefore1980Pct() - stateAvgBuiltBefore1980;
        String stockDirection = housingDelta >= 0 ? "higher" : "lower";

        int mitigationAvg = receipt != null ? receipt.getTotalAvg() : 0;
        double mitigationBurdenPct = metrics.getMedianHomeValue() > 0
                ? (mitigationAvg / (double) metrics.getMedianHomeValue()) * 100.0
                : 0.0;

        String marketDepth;
        int housingUnits = metrics.getTotalHousingUnits();
        if (housingUnits < 10_000) {
            marketDepth = "smaller contractor market; quote variance can be wider";
        } else if (housingUnits < 100_000) {
            marketDepth = "mid-sized market; compare scopes, not just headline price";
        } else {
            marketDepth = "large market; competitive bidding should produce tighter pricing";
        }

        String area = county.getAreaDisplayName();
        return List.of(
                String.format(Locale.US,
                        "Housing stock profile: %.1f%% of homes in %s were built before 1980 vs %.1f%% statewide (%s by %.1f percentage points). Older foundations often have more radon entry paths.",
                        metrics.getBuiltBefore1980Pct(), area, stateAvgBuiltBefore1980, stockDirection, Math.abs(housingDelta)),
                String.format(Locale.US,
                        "Cost burden check: median home value in %s is $%,d (state average $%,.0f). A typical mitigation project (~$%,d) is about %.2f%% of local median home value.",
                        area, metrics.getMedianHomeValue(), stateAvgHomeValue, mitigationAvg, mitigationBurdenPct),
                String.format(Locale.US,
                        "Market depth signal: %s has %,d housing units, which usually means a %s.",
                        area, housingUnits, marketDepth));
    }
}
