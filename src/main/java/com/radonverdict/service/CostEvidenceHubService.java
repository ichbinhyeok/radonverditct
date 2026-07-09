package com.radonverdict.service;

import com.radonverdict.model.County;
import com.radonverdict.model.CountyRadonMeasurement;
import com.radonverdict.model.CountyRadonTier;
import com.radonverdict.model.dto.CostEvidenceHubInsight;
import com.radonverdict.model.dto.ItemizedReceipt;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.Collection;
import java.util.Comparator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.TreeMap;
import java.util.stream.Collectors;

@Service
public class CostEvidenceHubService {

    private final DataLoadService dataLoadService;
    private final SeoIndexingPolicyService seoIndexingPolicyService;
    private final PricingCalculatorService calcService;

    @Value("${app.site.index-county-cost-pages:true}")
    private boolean indexCountyCostPages;

    public CostEvidenceHubService(DataLoadService dataLoadService,
            SeoIndexingPolicyService seoIndexingPolicyService,
            PricingCalculatorService calcService) {
        this.dataLoadService = dataLoadService;
        this.seoIndexingPolicyService = seoIndexingPolicyService;
        this.calcService = calcService;
    }

    public List<County> costIndexableCounties(Collection<County> counties) {
        if (counties == null || !indexCountyCostPages) {
            return List.of();
        }
        return counties.stream()
                .filter(seoIndexingPolicyService::isCostPageIndexableCandidate)
                .sorted(Comparator
                        .comparing(County::getStateAbbr)
                        .thenComparing(County::getCountyName))
                .toList();
    }

    public Map<String, List<County>> stateMap(List<County> costCounties) {
        if (costCounties == null || costCounties.isEmpty()) {
            return Map.of();
        }
        return costCounties.stream()
                .collect(Collectors.groupingBy(County::getStateAbbr, TreeMap::new, Collectors.toList()));
    }

    public CostEvidenceHubInsight buildInsight(Map<String, List<County>> stateMap, List<County> costCounties) {
        if (costCounties == null || costCounties.isEmpty()) {
            return null;
        }

        int evidenceCount = (int) costCounties.stream()
                .filter(this::hasOfficialRadonEvidence)
                .count();
        int measuredCount = (int) costCounties.stream()
                .filter(county -> dataLoadService.getRadonMeasurementByFipsMap().containsKey(county.getFips()))
                .count();
        int tierCount = (int) costCounties.stream()
                .filter(county -> dataLoadService.getRadonTierByFipsMap().containsKey(county.getFips()))
                .count();
        int searchCohortCount = (int) costCounties.stream()
                .filter(seoIndexingPolicyService::isSearchTrafficCandidate)
                .count();

        List<CostEvidenceHubInsight.StateCostRow> priorityStateRows = stateMap.entrySet().stream()
                .map(entry -> buildStateCostRow(entry.getKey(), entry.getValue()))
                .filter(row -> row != null)
                .sorted((left, right) -> Double.compare(
                        stateCostPriorityScore(right),
                        stateCostPriorityScore(left)))
                .limit(10)
                .toList();
        List<CostEvidenceHubInsight.CountyCostRow> priorityCountyRows = costCounties.stream()
                .sorted((left, right) -> {
                    int scoreCompare = Integer.compare(
                            seoIndexingPolicyService.countyIndexingScore(right),
                            seoIndexingPolicyService.countyIndexingScore(left));
                    if (scoreCompare != 0) {
                        return scoreCompare;
                    }
                    int housingCompare = Integer.compare(housingUnits(right), housingUnits(left));
                    if (housingCompare != 0) {
                        return housingCompare;
                    }
                    return (left.getStateSlug() + left.getCountySlug())
                            .compareTo(right.getStateSlug() + right.getCountySlug());
                })
                .limit(20)
                .map(this::buildCountyCostRow)
                .toList();

        ItemizedReceipt nationalReceipt = calcService.calculate("US", "National Average", "Basement", "basement", "homeowner", "under_2000");

        return CostEvidenceHubInsight.builder()
                .indexableCostCountyCount(costCounties.size())
                .evidenceBackedCostCountyCount(evidenceCount)
                .measuredCostCountyCount(measuredCount)
                .tierBackedCostCountyCount(tierCount)
                .searchCohortCostCountyCount(searchCohortCount)
                .decisionHeadline("Open cost pages that have a real reason to exist: demand, official radon evidence, or both.")
                .discoverySummary("The cost directory follows the same eligibility rule as the county cost pages themselves. State hubs, sitemap candidates, and internal links point at pages Google can actually index.")
                .sourceSummary("Evidence-backed cost pages combine the local price model with official radon measurements or official map tiers before asking users to compare contractors.")
                .routingSummary("Use the state rows for crawl discovery, then use the county rows for the highest-signal first clicks from the cost pillar.")
                .reportSummary("This report separates three layers that often get mixed together: official radon evidence, modeled local mitigation cost, and observed quote signals. That makes the page useful to homeowners, agents, contractors, and journalists without pretending a county average predicts a single house.")
                .nationalCostRangeDisplay("$" + nationalReceipt.getTotalLow() + "-$" + nationalReceipt.getTotalHigh())
                .quoteLedgerBridgeSummary("The quote ledger is the feedback loop: official data decides whether a page deserves search, while anonymized quote signals help verify whether the modeled range is realistic in the field.")
                .priorityStateRows(priorityStateRows)
                .priorityCountyRows(priorityCountyRows)
                .build();
    }

    private CostEvidenceHubInsight.StateCostRow buildStateCostRow(String stateAbbr, List<County> counties) {
        if (counties == null || counties.isEmpty()) {
            return null;
        }
        County topCounty = counties.stream()
                .max(Comparator
                        .comparingInt(seoIndexingPolicyService::countyIndexingScore)
                        .thenComparingInt(this::housingUnits))
                .orElse(counties.get(0));
        int evidenceCount = (int) counties.stream().filter(this::hasOfficialRadonEvidence).count();
        int measuredCount = (int) counties.stream()
                .filter(county -> dataLoadService.getRadonMeasurementByFipsMap().containsKey(county.getFips()))
                .count();

        return CostEvidenceHubInsight.StateCostRow.builder()
                .stateAbbr(stateAbbr)
                .statePath("/radon-mitigation-cost/" + counties.get(0).getStateSlug())
                .priorityLabel(stateCostPriorityLabel(counties.size(), evidenceCount, measuredCount))
                .costCountyCount(counties.size())
                .evidenceCountyCount(evidenceCount)
                .measuredCountyCount(measuredCount)
                .topCountyName(topCounty.getAreaDisplayName())
                .topCountyPath("/radon-mitigation-cost/" + topCounty.getStateSlug() + "/" + topCounty.getCountySlug())
                .decisionDisplay(stateCostDecisionDisplay(stateAbbr, counties.size(), evidenceCount, measuredCount))
                .build();
    }

    private CostEvidenceHubInsight.CountyCostRow buildCountyCostRow(County county) {
        ItemizedReceipt receipt = calcService.calculate(
                county.getStateAbbr(),
                county.getCountyName(),
                county.getAreaDisplayName(),
                "basement",
                "homeowner",
                "under_2000");
        return CostEvidenceHubInsight.CountyCostRow.builder()
                .countyName(county.getAreaDisplayName())
                .countyPath("/radon-mitigation-cost/" + county.getStateSlug() + "/" + county.getCountySlug())
                .stateAbbr(county.getStateAbbr())
                .indexingScore(seoIndexingPolicyService.countyIndexingScore(county))
                .priorityLabel(countyCostPriorityLabel(county))
                .costRangeDisplay("$" + receipt.getTotalLow() + "-$" + receipt.getTotalHigh())
                .evidenceDisplay(countyEvidenceDisplay(county))
                .supportDisplay(countySupportDisplay(county))
                .sourceUrl(countySourceUrl(county))
                .userQuestion("What should a " + county.getAreaDisplayName() + " homeowner budget before calling radon contractors?")
                .whyThisCounty(whyThisCounty(county, receipt))
                .inspectionPriority(inspectionPriority(county))
                .build();
    }

    private double stateCostPriorityScore(CostEvidenceHubInsight.StateCostRow row) {
        if (row == null) {
            return 0.0;
        }
        double score = row.getCostCountyCount() * 2.0 + row.getEvidenceCountyCount() * 3.0
                + row.getMeasuredCountyCount() * 5.0;
        if ("Start here".equals(row.getPriorityLabel())) {
            score += 35.0;
        } else if ("Evidence dense".equals(row.getPriorityLabel())) {
            score += 20.0;
        }
        return score;
    }

    private String stateCostPriorityLabel(int costCount, int evidenceCount, int measuredCount) {
        if (measuredCount >= 8 || (measuredCount >= 3 && costCount >= 10)) {
            return "Start here";
        }
        if (evidenceCount >= Math.max(3, costCount / 2)) {
            return "Evidence dense";
        }
        if (costCount >= 5) {
            return "Cost coverage";
        }
        return "Focused set";
    }

    private String stateCostDecisionDisplay(String stateAbbr, int costCount, int evidenceCount, int measuredCount) {
        if (measuredCount > 0) {
            return stateAbbr + " has " + costCount + " indexable cost counties, including " + measuredCount
                    + " with measured radon evidence behind the cost path.";
        }
        if (evidenceCount > 0) {
            return stateAbbr + " has " + evidenceCount
                    + " official evidence-backed cost pages, so users can move from risk context into budget planning.";
        }
        return stateAbbr + " is shown only where the cost page has enough demand or local data to deserve a first click.";
    }

    private String countyCostPriorityLabel(County county) {
        if (seoIndexingPolicyService.isSearchTrafficCandidate(county)) {
            return "Demand cohort";
        }
        if (seoIndexingPolicyService.isEvidenceRichCostPageCandidate(county)) {
            return "Evidence-backed";
        }
        return "Cost eligible";
    }

    private String whyThisCounty(County county, ItemizedReceipt receipt) {
        String evidence = countyEvidenceDisplay(county);
        String housing = String.format(Locale.US, "%,d", housingUnits(county));
        return county.getAreaDisplayName() + " is a strong cost page because it pairs " + evidence
                + " with a local housing base of " + housing + " units and a modeled planning range of $"
                + receipt.getTotalLow() + "-$" + receipt.getTotalHigh() + ".";
    }

    private String inspectionPriority(County county) {
        if (seoIndexingPolicyService.isSearchTrafficCandidate(county)) {
            return "Manual inspection priority: check this URL first when GSC shows discovered or crawled-not-indexed because it is already in a demand cohort.";
        }
        if (seoIndexingPolicyService.isEvidenceRichCostPageCandidate(county)) {
            return "Manual inspection priority: check that the official evidence block, local cost range, quote ledger CTA, and state hub links render above the fold cleanly.";
        }
        return "Manual inspection priority: keep it in the state hub, but do not scale similar pages until this cohort indexes.";
    }

    private String countyEvidenceDisplay(County county) {
        CountyRadonMeasurement measurement = dataLoadService.getRadonMeasurementByFipsMap().get(county.getFips());
        if (measurement != null) {
            String source = shortSourceName(measurement.getSourceName());
            String metric = measurementMetricDisplay(measurement);
            return source + (metric.isBlank() ? "" : ": " + metric);
        }
        CountyRadonTier tier = dataLoadService.getRadonTierByFipsMap().get(county.getFips());
        if (tier != null) {
            String source = shortSourceName(tier.getSourceName());
            return source + ": " + formatDecimal(tier.getTier1Or2Pct()) + "% Zone 1/2 municipalities";
        }
        return "EPA zone and local housing support";
    }

    private String countySupportDisplay(County county) {
        int housing = housingUnits(county);
        String zone = county.getEpaZone() > 0 ? "EPA Zone " + county.getEpaZone() : "EPA zone pending";
        return zone + " - " + String.format(Locale.US, "%,d", housing) + " housing units - score "
                + seoIndexingPolicyService.countyIndexingScore(county);
    }

    private String countySourceUrl(County county) {
        CountyRadonMeasurement measurement = dataLoadService.getRadonMeasurementByFipsMap().get(county.getFips());
        if (measurement != null) {
            return measurement.getSourceUrl();
        }
        CountyRadonTier tier = dataLoadService.getRadonTierByFipsMap().get(county.getFips());
        if (tier != null) {
            return tier.getSourceUrl();
        }
        return "https://www.epa.gov/radon";
    }

    private String measurementMetricDisplay(CountyRadonMeasurement measurement) {
        if (measurement == null || measurement.getMetrics() == null) {
            return "";
        }
        CountyRadonMeasurement.Metrics metrics = measurement.getMetrics();
        if (metrics.getPercentTestsAtOrAbove4PciL() != null) {
            return formatDecimal(metrics.getPercentTestsAtOrAbove4PciL()) + "% 4.0+";
        }
        if (metrics.getAverageTestResultPciL() != null) {
            return formatDecimal(metrics.getAverageTestResultPciL()) + " pCi/L average";
        }
        if (metrics.getBasementAverageTestResultPciL() != null) {
            return formatDecimal(metrics.getBasementAverageTestResultPciL()) + " pCi/L basement average";
        }
        if (metrics.getMedianRadonValuePciL() != null) {
            return formatDecimal(metrics.getMedianRadonValuePciL()) + " pCi/L median";
        }
        if (metrics.getMaximumTestResultPciL() != null) {
            return formatDecimal(metrics.getMaximumTestResultPciL()) + " pCi/L high-end";
        }
        return "";
    }

    private String shortSourceName(String sourceName) {
        if (sourceName == null || sourceName.isBlank()) {
            return "Official radon source";
        }
        return sourceName
                .replace("Department of Health", "Health Dept.")
                .replace("Environmental Public Health Tracking", "EPHT")
                .replace("Pre-Mitigation Radon Test Results", "radon tests");
    }

    private String formatDecimal(double value) {
        if (Math.abs(value - Math.rint(value)) < 0.05) {
            return String.format(Locale.US, "%.0f", value);
        }
        return String.format(Locale.US, "%.1f", value);
    }

    private boolean hasOfficialRadonEvidence(County county) {
        if (county == null) {
            return false;
        }
        return dataLoadService.getRadonMeasurementByFipsMap().containsKey(county.getFips())
                || dataLoadService.getRadonTierByFipsMap().containsKey(county.getFips());
    }

    private int housingUnits(County county) {
        if (county == null || county.getStats() == null || county.getStats().getMetrics() == null) {
            return 0;
        }
        return county.getStats().getMetrics().getTotalHousingUnits();
    }
}
