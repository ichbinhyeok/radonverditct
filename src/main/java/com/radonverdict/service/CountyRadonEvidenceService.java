package com.radonverdict.service;

import com.radonverdict.model.County;
import com.radonverdict.model.CountyRadonMeasurement;
import com.radonverdict.model.CountyRadonTier;
import com.radonverdict.model.dto.CountyRadonEvidence;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Comparator;
import java.util.List;
import java.util.Locale;
import java.util.Objects;
import java.util.function.Function;

@Service
@RequiredArgsConstructor
public class CountyRadonEvidenceService {

    private final DataLoadService dataLoadService;

    public CountyRadonEvidence buildEvidence(County county) {
        if (county == null) {
            return emptyEvidence();
        }

        CountyRadonMeasurement measurement = dataLoadService.getRadonMeasurementByFipsMap().get(county.getFips());
        if (measurement == null || measurement.getMetrics() == null) {
            return noMeasurementEvidence(county);
        }

        CountyRadonMeasurement.Metrics metrics = measurement.getMetrics();
        Double average = firstNonNull(
                metrics.getAverageTestResultPciL(),
                metrics.getArithmeticMeanRadonValuePciL(),
                metrics.getMedianRadonValuePciL());
        Double median = metrics.getMedianRadonValuePciL();
        Double above4 = metrics.getPercentTestsAtOrAbove4PciL();
        Double highEnd = firstNonNull(metrics.getRadon95thPercentilePciL(), metrics.getMaximumTestResultPciL());
        Double testVolume = testVolume(measurement);
        boolean highEndOnly = isHighEndOnlyMeasurement(average, median, above4, highEnd);

        String riskTone = highEndOnly ? highEndOnlyRiskTone(highEnd) : riskTone(average, median, above4);
        String riskBand = highEndOnly
                ? highEndOnlyRiskBand(highEnd)
                : switch (riskTone) {
                    case "high" -> "High measured burden";
                    case "elevated" -> "Elevated measured burden";
                    case "borderline" -> "Borderline measured burden";
                    case "lower" -> "Lower measured burden";
                    default -> "Measured source present";
                };

        int confidenceScore = confidenceScore(measurement, average, median, above4, highEnd, testVolume);
        String confidenceLabel = confidenceLabel(confidenceScore);
        String countyLabel = county.getAreaDisplayName() + ", " + county.getStateAbbr();
        String sourceShort = sourceShortName(measurement);

        int averagePercentile = statePercentile(county, m -> primaryAverage(m.getMetrics()));
        int above4Percentile = statePercentile(county, m -> safeMetric(m, CountyRadonMeasurement.Metrics::getPercentTestsAtOrAbove4PciL));
        int highEndPercentile = statePercentile(county, m -> highEndValue(m.getMetrics()));
        int testVolumePercentile = statePercentile(county, this::testVolume);
        int peerCount = stateMeasurementPeerCount(county);

        String measuredBurdenSummary = measuredBurdenSummary(countyLabel, average, above4, highEnd, measurement);
        String stateComparisonSummary = stateComparisonSummary(
                county, countyLabel, peerCount, averagePercentile, above4Percentile, highEndPercentile,
                testVolumePercentile);

        return CountyRadonEvidence.builder()
                .measurementBacked(true)
                .riskBand(riskBand)
                .riskTone(riskTone)
                .confidenceLabel(confidenceLabel)
                .confidenceScore(confidenceScore)
                .confidenceSummary(confidenceSummary(confidenceLabel, confidenceScore, sourceShort, testVolume, highEndOnly))
                .decisionHeadline(highEndOnly
                        ? highEndOnlyDecisionHeadline(county, highEnd)
                        : decisionHeadline(county, riskTone))
                .whyThisPageExists(whyMeasurementPageExists(
                        countyLabel, measurement, sourceShort, average, median, above4, highEnd, testVolume))
                .localDecisionSummary(highEndOnly
                        ? highEndOnlyLocalDecisionSummary(county, highEnd, highEndPercentile, sourceShort)
                        : localDecisionSummary(
                                county, riskTone, average, median, above4, averagePercentile, above4Percentile))
                .realEstateDecisionSummary(highEndOnly
                        ? highEndOnlyRealEstateDecisionSummary(county, highEnd)
                        : realEstateDecisionSummary(county, riskTone))
                .retestTriggerSummary(highEndOnly
                        ? highEndOnlyRetestTriggerSummary(county, highEnd)
                        : retestTriggerSummary(county, riskTone, average, median, above4))
                .measuredBurdenSummary(measuredBurdenSummary)
                .stateComparisonSummary(stateComparisonSummary)
                .recommendedAction(highEndOnly
                        ? highEndOnlyRecommendedAction(county, highEnd)
                        : recommendedAction(county, riskTone, above4, average))
                .intentQuestion(highEndOnly
                        ? "What does the highest reported radon result mean in " + county.getAreaDisplayName() + "?"
                        : intentQuestion(county, riskTone, above4, average))
                .intentAnswer(highEndOnly
                        ? highEndOnlyIntentAnswer(county, highEnd, sourceShort)
                        : intentAnswer(county, riskTone, above4, average, highEnd, sourceShort))
                .intentLabel(highEndOnly ? "High-end-source answer" : intentLabel(riskTone))
                .noReadingAction(highEndOnly ? highEndOnlyNoReadingAction(county) : noReadingAction(county, riskTone))
                .borderlineAction(highEndOnly ? highEndOnlyBorderlineAction(county) : borderlineAction(county, riskTone))
                .elevatedAction(elevatedAction(county, riskTone))
                .sourceCoverageSummary(sourceCoverageSummary(measurement))
                .sourceProfileLabel(sourceProfileLabel(measurement))
                .sourceProfileSummary(sourceProfileSummary(measurement))
                .metricShapeLabel(metricShapeLabel(measurement, average, median, above4, highEnd, highEndOnly))
                .metricShapeSummary(metricShapeSummary(measurement, average, median, above4, highEnd, testVolume, highEndOnly))
                .peerComparisonSummary(peerComparisonSummary(county, measurement, highEndOnly, average, above4, highEnd))
                .intentMatchSummary(intentMatchSummary(county, measurement, riskTone, highEndOnly))
                .averagePercentileDisplay(percentileDisplay(averagePercentile))
                .above4PercentileDisplay(percentileDisplay(above4Percentile))
                .highEndPercentileDisplay(percentileDisplay(highEndPercentile))
                .testVolumePercentileDisplay(percentileDisplay(testVolumePercentile))
                .comparisonPeerCountDisplay(peerCount > 0 ? Integer.toString(peerCount) : "n/a")
                .primaryAverageDisplay(highEndOnly ? formatPci(highEnd) : formatPci(average))
                .medianDisplay(formatPci(median))
                .above4Display(formatPercent(above4))
                .highEndDisplay(formatPci(highEnd))
                .testVolumeDisplay(testVolumeDisplay(measurement))
                .build();
    }

    private CountyRadonEvidence noMeasurementEvidence(County county) {
        CountyRadonTier tier = dataLoadService.getRadonTierByFipsMap().get(county.getFips());
        if (tier != null) {
            return tierBackedEvidence(county, tier);
        }

        String countyLabel = county.getAreaDisplayName() + ", " + county.getStateAbbr();
        String zoneSignal = county.getEpaZone() == 1
                ? "EPA Zone 1 keeps testing urgency high even before a county measurement table is ingested."
                : county.getEpaZone() == 2
                ? "EPA Zone 2 is a moderate county signal; direct testing matters more than the map label."
                : "The EPA map is useful context, but it cannot clear an individual home.";

        return CountyRadonEvidence.builder()
                .measurementBacked(false)
                .riskBand("Official source follow-up")
                .riskTone("unknown")
                .confidenceLabel("Source detail limited")
                .confidenceScore(30)
                .confidenceSummary("Official state source context is identified, but county-level measurement metrics are not normalized yet.")
                .decisionHeadline(countyLabel + " has source context, but the home test still controls the decision.")
                .whyThisPageExists(countyLabel + " has enough EPA zone, Census housing, and state-source context to explain what to do before a home reading exists.")
                .localDecisionSummary(zoneSignal + " The practical decision is still home-specific: get a first result before comparing mitigation prices or negotiating credits.")
                .realEstateDecisionSummary("Buyer or seller use: do not negotiate from the county map alone. Ask for a fresh lowest-level test, then use a 4.0+ result as the trigger for quotes or credits.")
                .retestTriggerSummary("Retest trigger: a 2.0-3.9 pCi/L result should be confirmed because the page has source context but not a normalized local measurement distribution yet.")
                .measuredBurdenSummary(countyLabel + " is not being treated as a data-free page; it is held on EPA zone, Census housing context, and a state-source follow-up path.")
                .stateComparisonSummary("No state percentile is shown until an official county measurement table is ingested.")
                .recommendedAction(zoneSignal + " Use a home test result before deciding whether mitigation cost or seller-credit planning matters.")
                .intentQuestion("Should homeowners in " + county.getAreaDisplayName() + " still test for radon?")
                .intentAnswer("Yes. This county has useful map, housing, and source context, but the missing county measurement table means a direct home test carries the decision.")
                .intentLabel("Testing answer")
                .noReadingAction("Run a first radon test before using the county map to make a decision.")
                .borderlineAction("A 2.0-3.9 pCi/L result should be retested or tracked because county source coverage is not enough to dismiss it.")
                .elevatedAction("A 4.0+ pCi/L result should move straight into mitigation pricing or real-estate credit planning.")
                .sourceCoverageSummary("Measurement gap: an official state source is identified, but normalized county metrics are not available yet.")
                .sourceProfileLabel("Source context only")
                .sourceProfileSummary("This page is held on EPA zone, Census housing context, and an identified source path, not a normalized county measurement row.")
                .metricShapeLabel("Map-and-context signal")
                .metricShapeSummary("No county measurement distribution is shown yet, so the page should explain testing decisions without ranking the county by pCi/L.")
                .peerComparisonSummary("Peer comparison is deferred until comparable county measurement metrics are available.")
                .intentMatchSummary("Best for: deciding whether a first home test is still warranted before any mitigation or credit planning.")
                .averagePercentileDisplay("n/a")
                .above4PercentileDisplay("n/a")
                .highEndPercentileDisplay("n/a")
                .testVolumePercentileDisplay("n/a")
                .comparisonPeerCountDisplay("n/a")
                .primaryAverageDisplay("Not available")
                .medianDisplay("Not available")
                .above4Display("Not available")
                .highEndDisplay("Not available")
                .testVolumeDisplay("Not available")
                .build();
    }

    private CountyRadonEvidence tierBackedEvidence(County county, CountyRadonTier tier) {
        String riskTone = tierRiskTone(tier);
        String riskBand = switch (riskTone) {
            case "high" -> "High official tier burden";
            case "elevated" -> "Elevated official tier burden";
            case "borderline" -> "Mixed official tier burden";
            default -> "Lower official tier burden";
        };
        String countyLabel = county.getAreaDisplayName() + ", " + county.getStateAbbr();
        String tierSummary = countyLabel + " has " + tier.getTier1Count() + " Tier 1 municipalities, "
                + tier.getTier2Count() + " Tier 2 municipalities, and " + tier.getTier3Count()
                + " Tier 3 municipalities in the NJ DEP radon potential table.";
        String comparison = String.format(Locale.US,
                "%.1f%% of municipalities are Tier 1 and %.1f%% are Tier 1 or Tier 2. This is a potential-tier signal, not a county average pCi/L measurement.",
                tier.getTier1Pct(), tier.getTier1Or2Pct());

        return CountyRadonEvidence.builder()
                .measurementBacked(false)
                .riskBand(riskBand)
                .riskTone(riskTone)
                .confidenceLabel("Tier-backed")
                .confidenceScore(62)
                .confidenceSummary("Tier-backed confidence (62/100) from NJ DEP municipality-level radon potential designations; numeric county pCi/L metrics are still not normalized.")
                .decisionHeadline(countyLabel + " is judged from NJ municipal radon tiers, not a county average.")
                .whyThisPageExists(countyLabel + " has more than the EPA map: NJ DEP exposes municipality radon potential tiers, with " + String.format(Locale.US, "%.1f%%", tier.getTier1Pct()) + " Tier 1 and " + String.format(Locale.US, "%.1f%%", tier.getTier1Or2Pct()) + " Tier 1 or Tier 2 municipalities.")
                .localDecisionSummary(tierLocalDecisionSummary(county, riskTone, tier))
                .realEstateDecisionSummary(realEstateDecisionSummary(county, riskTone))
                .retestTriggerSummary("Retest trigger: a 2.0-3.9 pCi/L home result should be confirmed when local NJ tier concentration is meaningful; the tier table is a priority signal, not a home result.")
                .measuredBurdenSummary(tierSummary)
                .stateComparisonSummary(comparison)
                .recommendedAction(tierRecommendedAction(county, riskTone))
                .intentQuestion("Is " + county.getAreaDisplayName() + " a higher-priority radon testing county?")
                .intentAnswer(county.getAreaDisplayName() + " is not shown from a county average table here; it is judged from NJ DEP municipal tier distribution. Treat Tier 1/Tier 2 concentration as a test-priority signal, then let the home result decide mitigation.")
                .intentLabel("Tier-intent answer")
                .noReadingAction("No reading yet: use the NJ tier signal to prioritize testing, but do not treat a tier as a home result.")
                .borderlineAction("2.0-3.9 pCi/L: retest or track; tier context can justify not dismissing a borderline result.")
                .elevatedAction("4.0+ pCi/L: move to mitigation quotes or seller-credit planning; the home result outranks the tier map.")
                .sourceCoverageSummary("Source hierarchy: NJ DEP radon potential tiers are used for this county, with EPA zone and Census housing data as supporting context.")
                .sourceProfileLabel("Official tier table")
                .sourceProfileSummary("NJ DEP publishes municipal radon-potential tiers, so this county is interpreted from local tier concentration rather than a county pCi/L average.")
                .metricShapeLabel("Potential-tier signal")
                .metricShapeSummary("The useful metric shape is Tier 1/Tier 2 concentration across municipalities; treat it as a testing-priority signal, not a home reading.")
                .peerComparisonSummary("Tier peer context: compare this county by Tier 1 and Tier 1-or-2 municipal share, then let the property test decide action.")
                .intentMatchSummary("Best for: deciding whether an NJ county deserves priority testing before purchase, renovation, or retest decisions.")
                .averagePercentileDisplay("n/a")
                .above4PercentileDisplay("n/a")
                .highEndPercentileDisplay("n/a")
                .testVolumePercentileDisplay("n/a")
                .comparisonPeerCountDisplay("21")
                .primaryAverageDisplay("Tier " + tier.getDominantTier() + " dominant")
                .medianDisplay("Not available")
                .above4Display(String.format(Locale.US, "%.1f%% Tier 1", tier.getTier1Pct()))
                .highEndDisplay("Tier " + tier.getHighestRiskTier() + " present")
                .testVolumeDisplay(tier.getMunicipalityCount() + " municipalities")
                .build();
    }

    private CountyRadonEvidence emptyEvidence() {
        return CountyRadonEvidence.builder()
                .measurementBacked(false)
                .riskBand("Unknown")
                .riskTone("unknown")
                .confidenceLabel("Unknown")
                .confidenceScore(0)
                .build();
    }

    private boolean isHighEndOnlyMeasurement(Double average, Double median, Double above4, Double highEnd) {
        return average == null && median == null && above4 == null && highEnd != null;
    }

    private String highEndOnlyRiskTone(Double highEnd) {
        if (highEnd != null && highEnd >= 4.0) {
            return "borderline";
        }
        if (highEnd != null && highEnd >= 2.0) {
            return "lower";
        }
        return "unknown";
    }

    private String highEndOnlyRiskBand(Double highEnd) {
        if (highEnd != null && highEnd >= 4.0) {
            return "Official high-end signal";
        }
        if (highEnd != null && highEnd >= 2.0) {
            return "Moderate high-end signal";
        }
        return "High-end source present";
    }

    private String highEndOnlyDecisionHeadline(County county, Double highEnd) {
        return county.getAreaDisplayName() + " has an official high-end county result of " + formatPci(highEnd)
                + ", but no county average in this source.";
    }

    private String highEndOnlyLocalDecisionSummary(County county, Double highEnd, int highEndPercentile,
            String sourceShort) {
        String rank = highEndPercentile > 0 ? " It ranks at the " + percentileDisplay(highEndPercentile)
                + " for high-end readings among measured counties in the state." : "";
        return county.getAreaDisplayName() + " is not being judged from an average table here. "
                + sourceShort + " exposes a highest measured county value of " + formatPci(highEnd)
                + ", so the useful decision is proof of local spike potential: test the home directly, then use a 4.0+ property result for mitigation pricing."
                + rank;
    }

    private String highEndOnlyRealEstateDecisionSummary(County county, Double highEnd) {
        return "Buyer or seller use: do not negotiate from the highest county value alone. Use it to justify requiring a fresh lowest-level property test, then price quotes or credits only from the home's own 4.0+ result.";
    }

    private String highEndOnlyRetestTriggerSummary(County county, Double highEnd) {
        return "Retest trigger: a 2.0-3.9 pCi/L home result should be confirmed because the official source shows local high-end readings up to "
                + formatPci(highEnd) + ", even though it does not publish a county average here.";
    }

    private String highEndOnlyRecommendedAction(County county, Double highEnd) {
        return county.getAreaDisplayName() + " should be treated as a direct-test county: the official high-end value reaches "
                + formatPci(highEnd) + ", but the source cannot tell whether a specific home is high until that home is tested.";
    }

    private String highEndOnlyIntentAnswer(County county, Double highEnd, String sourceShort) {
        return sourceShort + " reports a highest measured county value of " + formatPci(highEnd) + " for "
                + county.getAreaDisplayName()
                + ". That is a high-end local signal, not a county average. The practical answer is to test the property and let the home's result decide mitigation, retesting, or credit math.";
    }

    private String highEndOnlyNoReadingAction(County county) {
        return "No reading yet: use the official high-end signal as a reason to test the home, not as a substitute for a home result.";
    }

    private String highEndOnlyBorderlineAction(County county) {
        return "2.0-3.9 pCi/L: confirm with a follow-up or longer-term test because a high-end-only source proves elevated readings occur locally but does not show the full county distribution.";
    }

    private String measuredBurdenSummary(String countyLabel, Double average, Double above4, Double highEnd,
            CountyRadonMeasurement measurement) {
        StringBuilder summary = new StringBuilder(countyLabel).append(" is measurement-backed");
        if (measurement.getPeriod() != null && !measurement.getPeriod().isBlank()) {
            summary.append(" for ").append(measurement.getPeriod());
        }
        summary.append(".");

        if (average != null) {
            summary.append(" The measured average is ").append(formatPci(average));
        }
        if (above4 != null) {
            summary.append(average != null ? ", and " : " ");
            summary.append(formatPercent(above4)).append(" of reported results are at or above 4.0 pCi/L");
        }
        if (highEnd != null) {
            summary.append(". The high-end signal reaches ").append(formatPci(highEnd));
        }
        summary.append(".");
        return summary.toString();
    }

    private String stateComparisonSummary(County county, String countyLabel, int peerCount, int averagePercentile,
            int above4Percentile, int highEndPercentile, int testVolumePercentile) {
        if (peerCount < 3) {
            return "State percentile comparison is not shown because too few peer counties have comparable measurement data.";
        }

        String summary = countyLabel + " sits at the " + percentileDisplay(averagePercentile)
                + " for measured average, " + percentileDisplay(above4Percentile)
                + " for 4.0+ share, " + percentileDisplay(highEndPercentile)
                + " for high-end readings, and " + percentileDisplay(testVolumePercentile)
                + " for test volume among " + peerCount + " measured counties in the state.";
        String nearestAveragePeer = nearestPeerComparison(county, m -> primaryAverage(m.getMetrics()), "measured average");
        if (nearestAveragePeer.isBlank()) {
            return summary;
        }
        return summary + " " + nearestAveragePeer;
    }

    private String decisionHeadline(County county, String riskTone) {
        String place = county.getAreaDisplayName();
        return switch (riskTone) {
            case "high" -> place + " crosses the action threshold in the official county data.";
            case "elevated" -> place + " is elevated enough that map-reading should turn into a home test.";
            case "borderline" -> place + " is a retest-and-watch market, not a dismiss-it market.";
            case "lower" -> place + " looks lower at county level, but the home still needs its own number.";
            default -> place + " needs a direct home reading before any mitigation decision.";
        };
    }

    private String whyMeasurementPageExists(String countyLabel, CountyRadonMeasurement measurement, String sourceShort,
            Double average, Double median, Double above4, Double highEnd, Double testVolume) {
        String evidence = compactEvidence(
                testVolume != null ? String.format(Locale.US, "%,.0f reported tests", testVolume) : null,
                average != null ? formatPci(average) + " county average" : null,
                median != null ? formatPci(median) + " median" : null,
                above4 != null ? formatPercent(above4) + " of reported tests at or above 4.0 pCi/L" : null,
                highEnd != null ? formatPci(highEnd) + " high-end signal" : null);
        String period = measurement.getPeriod() != null && !measurement.getPeriod().isBlank()
                ? " for " + measurement.getPeriod()
                : "";
        return countyLabel + " has more than the EPA map: " + sourceShort + " exposes " + evidence + period + ".";
    }

    private String localDecisionSummary(County county, String riskTone, Double average, Double median, Double above4,
            int averagePercentile, int above4Percentile) {
        String place = county.getAreaDisplayName();
        String evidence = localMetricBrief(average, median, above4);
        String rank = rankBrief(averagePercentile, above4Percentile);

        return switch (riskTone) {
            case "high" -> place + " is a test-now case because " + evidence + "." + rank
                    + " No reading means get the first number; a 4.0+ home result should move straight to mitigation quotes or seller-credit math.";
            case "elevated" -> place + " is a priority-test case because " + evidence + "." + rank
                    + " The county signal is strong enough to justify testing or retesting before cost decisions.";
            case "borderline" -> place + " is a confirmation case because " + evidence + "." + rank
                    + " A 2.0-3.9 result should not be treated as final without a follow-up test or longer-term read.";
            case "lower" -> place + " is a home-specific check because " + evidence + "." + rank
                    + " The county signal is lower, but one house can still sit above the county pattern.";
            default -> place + " needs a direct home test before the county context can become a mitigation or credit decision.";
        };
    }

    private String tierLocalDecisionSummary(County county, String riskTone, CountyRadonTier tier) {
        String place = county.getAreaDisplayName();
        String tierEvidence = String.format(Locale.US, "%.1f%% Tier 1 and %.1f%% Tier 1 or Tier 2 municipalities",
                tier.getTier1Pct(), tier.getTier1Or2Pct());
        return switch (riskTone) {
            case "high" -> place + " is a test-now case because the NJ DEP table shows " + tierEvidence
                    + ". No reading means get the first number; a 4.0+ result should move into mitigation quotes.";
            case "elevated" -> place + " is a priority-test case because the NJ DEP table shows " + tierEvidence
                    + ". Use the tier pattern to prioritize testing, then let the home result decide cost.";
            case "borderline" -> place + " is a confirmation case because the NJ DEP table shows " + tierEvidence
                    + ". A borderline result deserves a follow-up test before being dismissed.";
            default -> place + " has a lower NJ tier pattern, but the home still needs a direct result before the county context can settle the decision.";
        };
    }

    private String realEstateDecisionSummary(County county, String riskTone) {
        return switch (riskTone) {
            case "high", "elevated" -> "Buyer or seller use: ask for a fresh lowest-level test before inspection deadlines, tie any 4.0+ result to a contractor quote, and do not negotiate from the county average alone.";
            case "borderline" -> "Buyer or seller use: use the county signal to justify a test contingency or retest, then reserve credits for confirmed 4.0+ home results.";
            case "lower" -> "Buyer or seller use: the county pattern is not enough for a credit demand by itself; use an actual home test to decide whether anything needs pricing.";
            default -> "Buyer or seller use: treat the county context as a prompt to test, not as a substitute for the property's own radon result.";
        };
    }

    private String retestTriggerSummary(County county, String riskTone, Double average, Double median, Double above4) {
        String evidence = localMetricBrief(average, median, above4);
        return switch (riskTone) {
            case "high", "elevated" -> "Retest trigger: a 2.0-3.9 pCi/L home result should be confirmed here because " + evidence + " keeps the county from being a dismiss-it signal.";
            case "borderline" -> "Retest trigger: a 2.0-3.9 pCi/L home result is exactly the gray zone for this county; retest before ignoring it or paying for mitigation.";
            case "lower" -> "Retest trigger: a 2.0-3.9 pCi/L result can be watched or confirmed, while a 4.0+ result should still override the lower county pattern.";
            default -> "Retest trigger: confirm 2.0-3.9 pCi/L and price action only after a confirmed 4.0+ home result.";
        };
    }

    private String localMetricBrief(Double average, Double median, Double above4) {
        return compactEvidence(
                average != null ? formatPci(average) + " average" : null,
                median != null ? formatPci(median) + " median" : null,
                above4 != null ? formatPercent(above4) + " of reported tests at or above 4.0" : null);
    }

    private String rankBrief(int averagePercentile, int above4Percentile) {
        String averageRank = averagePercentile > 0 ? percentileDisplay(averagePercentile) + " for average" : null;
        String above4Rank = above4Percentile > 0 ? percentileDisplay(above4Percentile) + " for 4.0+ share" : null;
        String rank = compactEvidence(averageRank, above4Rank);
        if ("the official county measurement fields are present".equals(rank)) {
            return "";
        }
        return " In-state rank: " + rank + ".";
    }

    private String recommendedAction(County county, String riskTone, Double above4, Double average) {
        String place = county.getAreaDisplayName();
        return switch (riskTone) {
            case "high" -> place + " should be treated as a county where a first test is urgent and a 4.0+ result should move directly into mitigation pricing or seller-credit math.";
            case "elevated" -> place + " has enough measured elevation that buyers and owners should not stop at the county average; confirm the home and price mitigation if the result crosses 4.0.";
            case "borderline" -> place + " is a split-decision county: no reading means test first, 2.0-3.9 means retest or track, and 4.0+ means cost planning starts.";
            case "lower" -> place + " has a lower measured county signal, but the page should still push direct testing because individual homes can sit above the county pattern.";
            default -> place + " needs direct home testing before any mitigation or credit decision.";
        };
    }

    private String intentQuestion(County county, String riskTone, Double above4, Double average) {
        String place = county.getAreaDisplayName();
        return switch (riskTone) {
            case "high" -> "Is radon bad in " + place + "?";
            case "elevated" -> "Are radon levels elevated in " + place + "?";
            case "borderline" -> "What does a borderline radon result mean in " + place + "?";
            case "lower" -> "Should homeowners in " + place + " still test for radon?";
            default -> "What should homeowners in " + place + " do about radon?";
        };
    }

    private String intentAnswer(County county, String riskTone, Double above4, Double average, Double highEnd,
            String sourceShort) {
        String place = county.getAreaDisplayName();
        String elevatedShare = above4 != null ? formatPercent(above4) + " of reported tests at or above 4.0 pCi/L" : null;
        String primary = average != null ? formatPci(average) + " primary measured result" : null;
        String high = highEnd != null ? formatPci(highEnd) + " high-end signal" : null;
        String evidence = compactEvidence(elevatedShare, primary, high);

        return switch (riskTone) {
            case "high" -> place + " should be treated as a high-priority testing market because "
                    + evidence + " in " + sourceShort + " data. A missing home reading means test now; a 4.0+ result means mitigation pricing or seller-credit math should start.";
            case "elevated" -> place + " has enough measured elevation that the answer should not stop at the EPA zone. "
                    + evidence + " makes a first test or confirmatory retest the right next step before cost decisions.";
            case "borderline" -> place + " is a split-decision county. "
                    + evidence + " means a 2.0-3.9 pCi/L home result should be retested or tracked instead of dismissed.";
            case "lower" -> place + " has a lower county-level measured signal, but the page should still send homeowners to a direct test because individual homes can sit above the county pattern.";
            default -> place + " needs a direct home test before mitigation, monitoring, or credit decisions.";
        };
    }

    private String compactEvidence(String... parts) {
        List<String> values = java.util.Arrays.stream(parts)
                .filter(value -> value != null && !value.isBlank())
                .toList();
        if (values.isEmpty()) {
            return "the official county measurement fields are present";
        }
        if (values.size() == 1) {
            return values.get(0);
        }
        return String.join(", ", values.subList(0, values.size() - 1)) + ", and " + values.get(values.size() - 1);
    }

    private String intentLabel(String riskTone) {
        return switch (riskTone) {
            case "high" -> "High-risk intent answer";
            case "elevated" -> "Elevated-intent answer";
            case "borderline" -> "Borderline-intent answer";
            case "lower" -> "Lower-signal intent answer";
            default -> "County-intent answer";
        };
    }

    private String noReadingAction(County county, String riskTone) {
        if ("high".equals(riskTone) || "elevated".equals(riskTone)) {
            return "No reading yet: run a short-term test now, then confirm or price mitigation quickly if the result is elevated.";
        }
        return "No reading yet: start with a test kit; the county data is context, not a substitute for the home result.";
    }

    private String borderlineAction(County county, String riskTone) {
        if ("high".equals(riskTone) || "elevated".equals(riskTone)) {
            return "2.0-3.9 pCi/L: retest or track longer-term rather than dismissing the result, because the county distribution has meaningful elevated readings.";
        }
        return "2.0-3.9 pCi/L: retest or monitor before paying for mitigation, then escalate if the level repeats or rises.";
    }

    private String elevatedAction(County county, String riskTone) {
        return "4.0+ pCi/L: use the result for mitigation quotes, repair scope, or seller-credit negotiation; the county average is no longer the deciding input.";
    }

    private String sourceCoverageSummary(CountyRadonMeasurement measurement) {
        return "Source hierarchy: " + sourceShortName(measurement)
                + " is used for this county, with EPA zone and Census housing data kept as supporting context. "
                + sourceInterpretation(measurement);
    }

    private String sourceProfileLabel(CountyRadonMeasurement measurement) {
        if (measurement == null || measurement.getSourceId() == null) {
            return "Official source context";
        }
        return switch (measurement.getSourceId()) {
            case "pa_dep_radon_zip" -> "Basement ZIP rollup";
            case "nc_dhhs_radon" -> "High-end-only map";
            case "epa_usgs_ms_residential_radon_survey" -> "Historical federal survey";
            case "ia_hhs_radon" -> "Median county dashboard";
            case "nj_dep_radon_potential" -> "Official tier table";
            case "cdc_tracking_radon" -> "National measurement fallback";
            default -> "Official measurement table";
        };
    }

    private String sourceProfileSummary(CountyRadonMeasurement measurement) {
        if (measurement == null) {
            return "The source layer is used as context until county-level measurement metrics are normalized.";
        }
        return sourceInterpretation(measurement);
    }

    private String metricShapeLabel(CountyRadonMeasurement measurement, Double average, Double median, Double above4,
            Double highEnd, boolean highEndOnly) {
        if (measurement != null && "pa_dep_radon_zip".equals(measurement.getSourceId())) {
            return "Floor-specific burden";
        }
        if (highEndOnly) {
            return "Spike-potential signal";
        }
        if (average != null && above4 != null && highEnd != null) {
            return "Distribution-backed burden";
        }
        if (median != null && average != null && above4 == null) {
            return "Central-tendency signal";
        }
        if (median != null && average == null) {
            return "Median-only burden";
        }
        if (average != null) {
            return "Average-only signal";
        }
        if (highEnd != null) {
            return "High-end context";
        }
        return "Limited metric shape";
    }

    private String metricShapeSummary(CountyRadonMeasurement measurement, Double average, Double median, Double above4,
            Double highEnd, Double testVolume, boolean highEndOnly) {
        String volume = testVolume != null ? String.format(Locale.US, "%,.0f reported tests/properties", testVolume)
                : null;
        if (measurement != null && "pa_dep_radon_zip".equals(measurement.getSourceId())) {
            return "The primary read is basement-weighted because PA DEP ZIP reports separate basement and first-floor results; this makes the page stronger for basement-level search intent and mitigation planning.";
        }
        if (highEndOnly) {
            return "The source gives a highest measured value but not a county average or 4.0+ share, so RadonVerdict reads it as proof that elevated readings can occur locally, not as the typical county level.";
        }
        if (average != null && above4 != null && highEnd != null) {
            return "This is the strongest metric shape: central tendency, elevated-result share, high-end tail, and "
                    + (volume != null ? volume : "test-volume context")
                    + " can be read together instead of relying on one number.";
        }
        if (median != null && above4 == null) {
            return "This source is best for median burden and county ranking. It is useful for comparing local tendency, but it does not show how many homes cross 4.0 pCi/L.";
        }
        if (average != null) {
            return "This source supports directional county burden from an average result. Pair it with a fresh home test before mitigation or credit decisions.";
        }
        return "The available fields are limited, so the page keeps the source caveat visible and avoids pretending the county distribution is complete.";
    }

    private String peerComparisonSummary(County county, CountyRadonMeasurement measurement, boolean highEndOnly,
            Double average, Double above4, Double highEnd) {
        if (measurement == null) {
            return "Peer comparison is deferred until a normalized county measurement row is available.";
        }

        String comparison;
        if (highEndOnly || average == null) {
            comparison = nearestPeerComparison(county, m -> highEndValue(m.getMetrics()), "high-end reading");
        } else if (above4 != null && ("high".equals(riskTone(average, null, above4))
                || "elevated".equals(riskTone(average, null, above4)))) {
            comparison = nearestPeerComparison(county,
                    m -> safeMetric(m, CountyRadonMeasurement.Metrics::getPercentTestsAtOrAbove4PciL),
                    "4.0+ share");
        } else {
            comparison = nearestPeerComparison(county, m -> primaryAverage(m.getMetrics()), "measured average");
        }

        if (comparison == null || comparison.isBlank()) {
            return "Measured-risk peer: comparable peer ranking is limited because too few same-state counties expose the same metric shape.";
        }
        return "Measured-risk peer: " + comparison;
    }

    private String intentMatchSummary(County county, CountyRadonMeasurement measurement, String riskTone,
            boolean highEndOnly) {
        String place = county.getAreaDisplayName();
        if (measurement != null && "pa_dep_radon_zip".equals(measurement.getSourceId())) {
            return "Best for: basement radon level searches, floor-specific test planning, and 4.0+ mitigation or seller-credit decisions in "
                    + place + ".";
        }
        if (highEndOnly) {
            return "Best for: proving local spike potential and justifying a direct property test, without treating the highest county value as a typical home result.";
        }
        if (measurement != null && "epa_usgs_ms_residential_radon_survey".equals(measurement.getSourceId())) {
            return "Best for: source-backed historical context and first-test decisions, not current-year county ranking or property prediction.";
        }
        return switch (riskTone) {
            case "high" -> "Best for: 'is radon bad here' searches, no-reading test urgency, and 4.0+ mitigation planning.";
            case "elevated" -> "Best for: deciding whether a county signal is strong enough to justify testing or retesting before cost decisions.";
            case "borderline" -> "Best for: 2.0-3.9 pCi/L interpretation, retest decisions, and avoiding a premature dismiss-or-mitigate answer.";
            case "lower" -> "Best for: explaining why a lower county pattern still does not replace a direct home test.";
            default -> "Best for: turning county context into a first-test decision before mitigation, monitoring, or credit planning.";
        };
    }

    private String sourceInterpretation(CountyRadonMeasurement measurement) {
        if (measurement == null || measurement.getSourceId() == null) {
            return "Treat the county signal as context and let the home test control the final decision.";
        }

        return switch (measurement.getSourceId()) {
            case "tn_health_radon" -> "Tennessee values combine the state county-average layer with a RadonVerdict ZIP-to-county rollup for the 4.0+ share, so they are useful as a local testing-burden signal but still cannot predict a specific home.";
            case "pa_dep_radon_zip" -> "Pennsylvania values are RadonVerdict county rollups from PA DEP ZIP reports, with basement readings treated as the primary local signal and first-floor readings preserved as a separate floor context.";
            case "va_vdh_radon" -> "Virginia values come from VDH-received 2016-2024 indoor air radon results by locality. VDH suppresses averages below 25 tests, so test count and maximum can remain useful even when the average is unavailable.";
            case "mo_dhss_radon" -> "Missouri values come from the DHSS residential radon dashboard. County averages and maximums come from the summary layer, while the 4.0+ share is computed only from non-suppressed point records.";
            case "ut_epht_radon" -> "Utah values come from DHHS EPHT/IBIS radon test kit result queries. RadonVerdict combines county average, test count, 4.0+ count, median, and maximum queries for the same 2006-2019 period; Utah notes that tests outside its subsidized kit program are not included.";
            case "il_iema_radon" -> "Illinois values come from the IEMA-OHS licensed-measurement dashboard. RadonVerdict stores only county-level aggregates, excludes invalid tests and negative result sentinels, and uses the 95th percentile before the raw maximum so outlier records do not dominate the local verdict.";
            case "ia_hhs_radon" -> "Iowa values come from the HHS/IDPH county metrics dashboard export. The median is useful for ranking local testing burden, but it still cannot predict a specific home's reading.";
            case "nc_dhhs_radon" -> "North Carolina values come from the DHHS county radon map export. The source publishes each county's highest measured value, so RadonVerdict treats it as a high-end spike signal rather than a county average.";
            case "epa_usgs_ms_residential_radon_survey" -> "Mississippi values come from the historical State/EPA Residential Radon Survey table in EPA/USGS map-support documentation. Treat the county row as older official context, not a current prediction for a specific home.";
            case "co_cdphe_radon" -> "Colorado values are pre-mitigation test results, so they are strongest as a problem-finding signal and should not be read as post-repair household averages.";
            case "wi_dhs_radon" -> "Wisconsin values are long-period ZIP-level test summaries rolled into county context, so they are useful for local burden but not a current-year snapshot.";
            case "ny_doh_tracking_radon" -> "NY DOH values are submitted residential tests; higher testing participation can make the volume signal especially useful for local context.";
            case "mn_health_radon" -> "Minnesota values combine reported commercial and residential tests, so the verdict favors distribution signals like 4.0+ share and high-end readings.";
            case "ks_kdhe_radon" -> "Kansas values come from a state tracking snapshot, so the county verdict should be paired with a fresh home test before mitigation pricing.";
            case "cdc_tracking_radon" -> "CDC Tracking provides comparable county-level measurement fields; state-specific sources still outrank it when they expose stable county tables.";
            default -> "Use this official measurement table as county context, then let the home's own test result control mitigation or credit decisions.";
        };
    }

    private String tierRiskTone(CountyRadonTier tier) {
        if (tier.getTier1Pct() >= 50.0) {
            return "high";
        }
        if (tier.getTier1Or2Pct() >= 70.0 || tier.getTier1Pct() >= 20.0) {
            return "elevated";
        }
        if (tier.getTier1Or2Pct() >= 40.0) {
            return "borderline";
        }
        return "lower";
    }

    private String tierRecommendedAction(County county, String riskTone) {
        String place = county.getAreaDisplayName();
        return switch (riskTone) {
            case "high" -> place + " should be treated as an NJ tier-heavy county: test before purchase or renovation decisions, and move any 4.0+ result into mitigation pricing.";
            case "elevated" -> place + " has enough Tier 1/Tier 2 municipal coverage that the practical move is direct testing, then retesting or pricing based on the home result.";
            case "borderline" -> place + " has mixed NJ tier signals, so the county page should push a home test rather than implying the map settles the answer.";
            default -> place + " has a lower NJ tier pattern, but a direct home test still controls the actual decision.";
        };
    }

    private String confidenceSummary(String confidenceLabel, int confidenceScore, String sourceShort, Double testVolume,
            boolean highEndOnly) {
        String volumeText = testVolume != null
                ? " based on about " + String.format(Locale.US, "%,.0f", testVolume) + " reported tests/properties"
                : "";
        String fieldText = highEndOnly
                ? " plus high-end county measurement context."
                : " plus comparable county-level measurement fields.";
        return confidenceLabel + " confidence (" + confidenceScore + "/100) from " + sourceShort + volumeText
                + fieldText;
    }

    private int confidenceScore(CountyRadonMeasurement measurement, Double average, Double median, Double above4,
            Double highEnd, Double testVolume) {
        int score = isStateOfficial(measurement) ? 35 : 28;
        if (average != null) {
            score += 15;
        }
        if (above4 != null) {
            score += 15;
        }
        if (median != null) {
            score += 8;
        }
        if (highEnd != null) {
            score += 8;
        }
        if (measurement.getPeriod() != null && !measurement.getPeriod().isBlank()) {
            score += 4;
        }

        if (testVolume != null) {
            if (testVolume >= 1000) {
                score += 15;
            } else if (testVolume >= 250) {
                score += 12;
            } else if (testVolume >= 50) {
                score += 9;
            } else if (testVolume >= 20) {
                score += 6;
            } else {
                score += 3;
            }
        }

        return Math.min(score, 100);
    }

    private String confidenceLabel(int score) {
        if (score >= 85) {
            return "High";
        }
        if (score >= 68) {
            return "Solid";
        }
        if (score >= 48) {
            return "Directional";
        }
        return "Sparse";
    }

    private String riskTone(Double average, Double median, Double above4) {
        double avg = average != null ? average : -1;
        double med = median != null ? median : -1;
        double pct = above4 != null ? above4 : -1;

        if (avg >= 4.0 || med >= 4.0 || pct >= 40.0) {
            return "high";
        }
        if (avg >= 3.0 || med >= 3.0 || pct >= 25.0) {
            return "elevated";
        }
        if (avg >= 2.0 || med >= 2.0 || pct >= 10.0) {
            return "borderline";
        }
        if (avg >= 0 || med >= 0 || pct >= 0) {
            return "lower";
        }
        return "unknown";
    }

    private int stateMeasurementPeerCount(County county) {
        return (int) dataLoadService.getRadonMeasurementByFipsMap().values().stream()
                .filter(m -> m.getStateAbbr() != null && m.getStateAbbr().equalsIgnoreCase(county.getStateAbbr()))
                .count();
    }

    private String nearestPeerComparison(County county, Function<CountyRadonMeasurement, Double> extractor,
            String metricLabel) {
        CountyRadonMeasurement current = dataLoadService.getRadonMeasurementByFipsMap().get(county.getFips());
        if (current == null) {
            return "";
        }

        Double currentValue = extractor.apply(current);
        if (currentValue == null) {
            return "";
        }

        List<MeasuredPeer> peers = dataLoadService.getRadonMeasurementByFipsMap().values().stream()
                .filter(m -> m.getStateAbbr() != null && m.getStateAbbr().equalsIgnoreCase(county.getStateAbbr()))
                .map(m -> new MeasuredPeer(m, extractor.apply(m)))
                .filter(peer -> peer.value() != null)
                .sorted(Comparator
                        .comparing(MeasuredPeer::value)
                        .thenComparing(peer -> peerDisplayName(peer.measurement())))
                .toList();

        if (peers.size() < 3) {
            return "";
        }

        int currentIndex = -1;
        for (int i = 0; i < peers.size(); i++) {
            if (county.getFips().equals(peers.get(i).measurement().getCountyFips())) {
                currentIndex = i;
                break;
            }
        }
        if (currentIndex < 0) {
            return "";
        }

        MeasuredPeer lower = currentIndex > 0 ? peers.get(currentIndex - 1) : null;
        MeasuredPeer higher = currentIndex < peers.size() - 1 ? peers.get(currentIndex + 1) : null;
        if (lower != null && higher != null) {
            return "Closest measured peers by " + metricLabel + ": " + peerDisplayName(lower.measurement())
                    + " (" + formatPci(lower.value()) + ") just below, and " + peerDisplayName(higher.measurement())
                    + " (" + formatPci(higher.value()) + ") just above.";
        }
        if (higher != null) {
            return county.getAreaDisplayName() + " is the lowest measured peer by " + metricLabel + "; next above is "
                    + peerDisplayName(higher.measurement()) + " (" + formatPci(higher.value()) + ").";
        }
        if (lower != null) {
            return county.getAreaDisplayName() + " is the highest measured peer by " + metricLabel + "; next below is "
                    + peerDisplayName(lower.measurement()) + " (" + formatPci(lower.value()) + ").";
        }
        return "";
    }

    private String peerDisplayName(CountyRadonMeasurement measurement) {
        if (measurement == null) {
            return "peer county";
        }
        County county = dataLoadService.getCountByFipsMap().get(measurement.getCountyFips());
        if (county != null && county.getAreaDisplayName() != null && !county.getAreaDisplayName().isBlank()) {
            return county.getAreaDisplayName();
        }
        if (measurement.getCountyName() != null && !measurement.getCountyName().isBlank()) {
            return measurement.getCountyName();
        }
        return measurement.getCountyFips() != null ? measurement.getCountyFips() : "peer county";
    }

    private int statePercentile(County county, Function<CountyRadonMeasurement, Double> extractor) {
        CountyRadonMeasurement measurement = dataLoadService.getRadonMeasurementByFipsMap().get(county.getFips());
        if (measurement == null) {
            return 0;
        }

        Double value = extractor.apply(measurement);
        if (value == null) {
            return 0;
        }

        List<Double> stateValues = dataLoadService.getRadonMeasurementByFipsMap().values().stream()
                .filter(m -> m.getStateAbbr() != null && m.getStateAbbr().equalsIgnoreCase(county.getStateAbbr()))
                .map(extractor)
                .filter(Objects::nonNull)
                .sorted(Comparator.naturalOrder())
                .toList();

        if (stateValues.size() < 3) {
            return 0;
        }

        long lessOrEqual = stateValues.stream().filter(v -> v <= value).count();
        return (int) Math.round((lessOrEqual * 100.0) / stateValues.size());
    }

    private Double primaryAverage(CountyRadonMeasurement.Metrics metrics) {
        if (metrics == null) {
            return null;
        }
        return firstNonNull(
                metrics.getAverageTestResultPciL(),
                metrics.getArithmeticMeanRadonValuePciL(),
                metrics.getMedianRadonValuePciL());
    }

    private Double highEndValue(CountyRadonMeasurement.Metrics metrics) {
        if (metrics == null) {
            return null;
        }
        return firstNonNull(metrics.getRadon95thPercentilePciL(), metrics.getMaximumTestResultPciL());
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
        if (periodYears > 1) {
            return metrics.getAverageNumberOfTests() * periodYears;
        }
        return metrics.getAverageNumberOfTests();
    }

    private String testVolumeDisplay(CountyRadonMeasurement measurement) {
        if (measurement == null || measurement.getMetrics() == null) {
            return "Not available";
        }

        CountyRadonMeasurement.Metrics metrics = measurement.getMetrics();
        if (metrics.getTotalTests() != null) {
            return String.format(Locale.US, "%,.0f reported tests", metrics.getTotalTests());
        }
        if (metrics.getNumberBuildingsTested10Year() != null) {
            return String.format(Locale.US, "%,.0f over 10 years", metrics.getNumberBuildingsTested10Year());
        }
        if (metrics.getAverageNumberOfTests() != null) {
            return String.format(Locale.US, "%.1f avg/year", metrics.getAverageNumberOfTests());
        }
        return "Not available";
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

    private String sourceShortName(CountyRadonMeasurement measurement) {
        if (measurement == null || measurement.getSourceId() == null) {
            return "official source";
        }
        return switch (measurement.getSourceId()) {
            case "tn_health_radon" -> "Tennessee Environmental Public Health Tracking";
            case "pa_dep_radon_zip" -> "PA DEP Radon Division";
            case "va_vdh_radon" -> "Virginia Department of Health";
            case "mo_dhss_radon" -> "Missouri DHSS";
            case "ut_epht_radon" -> "Utah DHHS EPHT";
            case "il_iema_radon" -> "Illinois IEMA-OHS";
            case "ia_hhs_radon" -> "Iowa HHS";
            case "nc_dhhs_radon" -> "North Carolina DHHS";
            case "epa_usgs_ms_residential_radon_survey" -> "EPA/USGS Mississippi survey";
            case "ny_doh_tracking_radon" -> "NY DOH";
            case "mn_health_radon" -> "Minnesota Department of Health";
            case "ks_kdhe_radon" -> "Kansas Department of Health and Environment";
            case "co_cdphe_radon" -> "Colorado Department of Public Health and Environment";
            case "wi_dhs_radon" -> "Wisconsin Department of Health Services";
            case "cdc_tracking_radon" -> "CDC Tracking Network";
            default -> measurement.getSourceName() != null ? measurement.getSourceName() : "official source";
        };
    }

    private boolean isStateOfficial(CountyRadonMeasurement measurement) {
        return measurement != null && measurement.getSourceId() != null
                && (measurement.getSourceId().startsWith("ny_")
                || measurement.getSourceId().startsWith("tn_")
                || measurement.getSourceId().startsWith("pa_")
                || measurement.getSourceId().startsWith("va_")
                || measurement.getSourceId().startsWith("mo_")
                || measurement.getSourceId().startsWith("ut_")
                || measurement.getSourceId().startsWith("il_")
                || measurement.getSourceId().startsWith("ia_")
                || measurement.getSourceId().startsWith("nc_")
                || measurement.getSourceId().startsWith("epa_usgs_ms_")
                || measurement.getSourceId().startsWith("mn_")
                || measurement.getSourceId().startsWith("ks_")
                || measurement.getSourceId().startsWith("co_")
                || measurement.getSourceId().startsWith("wi_"));
    }

    private Double safeMetric(CountyRadonMeasurement measurement,
            Function<CountyRadonMeasurement.Metrics, Double> extractor) {
        if (measurement == null || measurement.getMetrics() == null) {
            return null;
        }
        return extractor.apply(measurement.getMetrics());
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

    private String percentileDisplay(int percentile) {
        if (percentile <= 0) {
            return "n/a";
        }
        int mod100 = percentile % 100;
        int mod10 = percentile % 10;
        String suffix = (mod100 >= 11 && mod100 <= 13)
                ? "th"
                : switch (mod10) {
                    case 1 -> "st";
                    case 2 -> "nd";
                    case 3 -> "rd";
                    default -> "th";
                };
        return percentile + suffix + " percentile";
    }

    private String formatPci(Double value) {
        return value != null ? String.format(Locale.US, "%.1f pCi/L", value) : "Not available";
    }

    private String formatPercent(Double value) {
        return value != null ? String.format(Locale.US, "%.1f%%", value) : "Not available";
    }

    private record MeasuredPeer(CountyRadonMeasurement measurement, Double value) {
    }
}
