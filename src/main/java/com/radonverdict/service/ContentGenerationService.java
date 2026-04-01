package com.radonverdict.service;

import com.radonverdict.model.*;
import com.radonverdict.model.dto.CountyPageContent;
import com.radonverdict.model.dto.ItemizedReceipt;
import com.radonverdict.model.dto.SimilarityAssessment;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Assembles complete, unique, render-ready content for each county page.
 * All text is sourced from JSON templates and dynamically resolved with
 * county-specific, zone-specific, and state-specific variables.
 * 
 * This is the core anti-thin-content engine.
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class ContentGenerationService {

        private static final Set<String> SLAB_DEFAULT_STATES = Set.of(
                        "AZ", "CA", "FL", "HI", "LA", "NM", "NV", "TX");

        private static final Set<String> CRAWLSPACE_DEFAULT_STATES = Set.of(
                        "AL", "AR", "GA", "KY", "MS", "NC", "SC", "TN", "VA");

        private final DataLoadService dataLoadService;
        private final PricingCalculatorService pricingCalculatorService;
        private final CountyInsightService countyInsightService;
        private final SimilarityEngineService similarityEngineService;

        /**
         * Build the complete page content for a given county.
         * This single method assembles everything the frontend template needs.
         */
        public CountyPageContent buildPageContent(County county, String foundationType, String userIntent) {
                return buildPageContent(county, foundationType, userIntent, "under_2000", "not_tested");
        }

        public CountyPageContent buildDefaultPageContent(County county) {
                DefaultScenario scenario = chooseDefaultScenario(county);
                return buildPageContent(
                                county,
                                scenario.foundationType(),
                                scenario.userIntent(),
                                scenario.sqftCategory(),
                                scenario.radonResultBand());
        }

        public CountyPageContent buildPageContent(County county, String foundationType, String userIntent,
                        String sqftCategory) {
                return buildPageContent(county, foundationType, userIntent, sqftCategory, "not_tested");
        }

        public CountyPageContent buildPageContent(County county, String foundationType, String userIntent,
                        String sqftCategory, String radonResultBand) {

                String zoneKey = String.valueOf(county.getEpaZone());
                String stateAbbr = county.getStateAbbr();
                String countyName = county.getCountyName();
                String areaName = county.getAreaDisplayName();

                ContentTemplates templates = dataLoadService.getContentTemplates();
                StateRegulations regulations = dataLoadService.getStateRegulations();
                FaqTemplates faqTemplates = dataLoadService.getFaqTemplates();

                String safeSqftCategory = (sqftCategory == null || sqftCategory.isBlank()) ? "under_2000" : sqftCategory;
                String safeRadonResultBand = normalizeRadonResultBand(radonResultBand);

                // 1. Get the receipt first (needed for placeholder resolution in text)
                ItemizedReceipt receipt = pricingCalculatorService.calculate(
                                stateAbbr, countyName, foundationType, userIntent, safeSqftCategory);
                ItemizedReceipt stateAverageReceipt = pricingCalculatorService.calculate(
                                stateAbbr, "State Average", foundationType, userIntent, safeSqftCategory);
                ItemizedReceipt nationalAverageReceipt = pricingCalculatorService.calculate(
                                "US", "National Average", foundationType, userIntent, safeSqftCategory);

                // 2. Resolve Zone Description
                ContentTemplates.ZoneDescription zoneDesc = templates.getZoneDescriptions().getOrDefault(
                                zoneKey, templates.getZoneDescriptions().get("0"));

                // 3. Resolve State Regulation
                StateRegulations.StateRule stateRule = regulations.getStateRules().getOrDefault(
                                stateAbbr.toUpperCase(), regulations.getDefaultStateRule());

                // 4. Resolve Foundation Description
                String safeFoundation = (foundationType != null) ? foundationType.toLowerCase() : "other";
                ContentTemplates.FoundationDescription foundationDesc = templates.getFoundationDescriptions()
                                .getOrDefault(
                                                safeFoundation, templates.getFoundationDescriptions().get("other"));

                // 5. Resolve Intent Content
                String safeIntent = (userIntent != null) ? userIntent.toLowerCase() : "homeowner";
                ContentTemplates.IntentContent intentContent = templates.getIntentContent().getOrDefault(
                                safeIntent, templates.getIntentContent().get("homeowner"));

                SimilarityAssessment similarity = similarityEngineService.assessMitigationPage(county, receipt);
                List<String> localInsights = new ArrayList<>(countyInsightService.buildLocalInsights(county, receipt));
                localInsights.addAll(similarityEngineService.buildDifferentiationNarratives(county, receipt, similarity));
                String pricingRationale = buildPricingRationale(county, receipt, stateAverageReceipt, similarity);

                // 6. Build Dynamic FAQs (zone-specific + universal)
                Map<String, String> ctx = buildContext(areaName, stateAbbr, receipt, zoneKey, stateRule, pricingRationale);
                List<CountyPageContent.FaqItem> faqs = buildFaqs(
                                faqTemplates, zoneKey, stateRule, ctx);

                // 6.5 Calculate nearby counties for SEO siloing
                List<County> nearbyCounties = dataLoadService.getCountyBySlugMap().values().stream()
                                .filter(c -> c.getStateAbbr().equals(stateAbbr)
                                                && !c.getCountySlug().equals(county.getCountySlug()))
                                .limit(6)
                                .toList();

                // 6.7 Evaluate indexing quality gate
                boolean isIndexable = (county.getStats() != null
                                && county.getStats().getMetrics() != null
                                && county.getStats().getMetrics().getTotalHousingUnits() > 0);

                // 7. Assemble Final DTO
                return CountyPageContent.builder()
                                .indexable(isIndexable)
                                .heroTitle(buildHeroTitle(areaName, stateAbbr, safeRadonResultBand))
                                .heroSummary(buildHeroSummary(areaName, receipt, safeRadonResultBand))
                                .seoDescription(buildSeoDescription(
                                                areaName,
                                                stateAbbr,
                                                receipt,
                                                pricingRationale,
                                                safeRadonResultBand))
                                .pricingRationale(pricingRationale)
                                .riskLevel(zoneDesc.getRiskLevel())
                                .badgeColor(zoneDesc.getBadgeColor())
                                .riskNarrative(resolve(zoneDesc.getRiskNarrative(), ctx))
                                .localInsights(localInsights)
                                .intentSectionTitle(buildIntentSectionTitle(safeIntent, safeRadonResultBand))
                                .intentIntro(buildIntentIntro(
                                                areaName,
                                                stateAbbr,
                                                receipt,
                                                safeIntent,
                                                safeRadonResultBand))
                                .intentSteps(buildIntentSteps(
                                                areaName,
                                                stateAbbr,
                                                receipt,
                                                safeIntent,
                                                safeRadonResultBand,
                                                intentContent,
                                                ctx))
                                .intentProTip(buildIntentProTip(
                                                areaName,
                                                stateAbbr,
                                                safeIntent,
                                                safeRadonResultBand,
                                                intentContent,
                                                ctx))
                                .foundationLabel(foundationDesc.getLabel())
                                .foundationCostContext(resolve(foundationDesc.getCostContext(), ctx))
                                .foundationNegotiationNote(resolve(foundationDesc.getNegotiationNote(), ctx))
                                .disclosureRequired(stateRule.isDisclosureRequired())
                                .disclosureSummary(resolve(stateRule.getDisclosureSummary(), ctx))
                                .stateProgramUrl(stateRule.getStateProgramUrl())
                                .licenseRequired(stateRule.isLicenseRequired())
                                .licenseNote(resolve(stateRule.getLicenseNote(), ctx))
                                .faqs(faqs)
                                .receipt(receipt)
                                .stateAverageTotal(stateAverageReceipt.getTotalAvg())
                                .nationalAverageTotal(nationalAverageReceipt.getTotalAvg())
                                .selectedFoundationType(safeFoundation)
                                .selectedIntent(safeIntent)
                                .selectedSqftCategory(safeSqftCategory)
                                .selectedRadonResultBand(safeRadonResultBand)
                                .nearbyCounties(nearbyCounties)
                                .build();
        }

        /**
         * Build a reusable placeholder context map.
         */
        private Map<String, String> buildContext(
                        String areaName, String stateAbbr, ItemizedReceipt receipt,
                        String zoneKey, StateRegulations.StateRule stateRule, String pricingRationale) {
                Map<String, String> ctx = new HashMap<>();
                ctx.put("{countyName}", areaName);
                ctx.put("{stateAbbr}", stateAbbr);
                ctx.put("{totalLow}", String.valueOf(receipt.getTotalLow()));
                ctx.put("{totalHigh}", String.valueOf(receipt.getTotalHigh()));
                ctx.put("{totalAvg}", String.valueOf(receipt.getTotalAvg()));
                ctx.put("${totalAvg}", "$" + receipt.getTotalAvg());
                ctx.put("${totalLow}", "$" + receipt.getTotalLow());
                ctx.put("${totalHigh}", "$" + receipt.getTotalHigh());
                ctx.put("{epaZone}", zoneKey);
                ctx.put("{regulationNote}", stateRule.getDisclosureSummary());
                ctx.put("{disclosureNote}", stateRule.isDisclosureRequired()
                                ? "radon disclosure is required during property sales"
                                : "there is no specific radon disclosure mandate, but general disclosure laws may apply");
                ctx.put("{licenseNote}", stateRule.getLicenseNote());
                ctx.put("{pricingReason}", pricingRationale);
                return ctx;
        }

        /**
         * Build FAQs: Zone-specific questions + universal questions.
         */
        private List<CountyPageContent.FaqItem> buildFaqs(
                        FaqTemplates faqTemplates, String zoneKey,
                        StateRegulations.StateRule stateRule, Map<String, String> ctx) {

                List<CountyPageContent.FaqItem> result = new ArrayList<>();
                result.add(buildCountyPricingFaq(ctx));

                // Add zone-specific FAQs
                String zonePoolKey = "zone_" + zoneKey;
                addFaqPool(faqTemplates, zonePoolKey, ctx, result);

                // Add state-specific disclosure FAQs
                String disclosurePoolKey = stateRule.isDisclosureRequired()
                                ? "state_disclosure_yes"
                                : "state_disclosure_no";
                addFaqPool(faqTemplates, disclosurePoolKey, ctx, result);

                // Add universal FAQs
                addFaqPool(faqTemplates, "universal", ctx, result);

                return result;
        }

        private CountyPageContent.FaqItem buildCountyPricingFaq(Map<String, String> ctx) {
                String pricingReason = ctx.getOrDefault("{pricingReason}",
                                "foundation type and roofline routing change scope more than the national average.");
                if (!pricingReason.isBlank()) {
                        pricingReason = pricingReason.substring(0, 1).toLowerCase() + pricingReason.substring(1);
                }
                return CountyPageContent.FaqItem.builder()
                                .question("Why do radon mitigation quotes in " + ctx.getOrDefault("{countyName}", "this county")
                                                + ", " + ctx.getOrDefault("{stateAbbr}", "")
                                                + " cluster around " + ctx.getOrDefault("${totalAvg}", "$0") + "?")
                                .answer("Typical pricing in " + ctx.getOrDefault("{countyName}", "this county")
                                                + " falls between " + ctx.getOrDefault("${totalLow}", "$0") + " and "
                                                + ctx.getOrDefault("${totalHigh}", "$0") + " because "
                                                + pricingReason
                                                + " Final contractor quotes still move with foundation type and on-site routing.")
                                .build();
        }

        private void addFaqPool(FaqTemplates faqTemplates, String poolKey,
                        Map<String, String> ctx, List<CountyPageContent.FaqItem> result) {
                List<FaqTemplates.FaqEntry> entries = faqTemplates.getFaqPool().get(poolKey);
                if (entries != null) {
                        for (FaqTemplates.FaqEntry entry : entries) {
                                result.add(CountyPageContent.FaqItem.builder()
                                                .question(resolve(entry.getQuestion(), ctx))
                                                .answer(resolve(entry.getAnswer(), ctx))
                                                .build());
                        }
                }
        }

        private DefaultScenario chooseDefaultScenario(County county) {
                String stateAbbr = county != null && county.getStateAbbr() != null
                                ? county.getStateAbbr().toUpperCase()
                                : "";

                String foundationType;
                if (SLAB_DEFAULT_STATES.contains(stateAbbr)) {
                        foundationType = "slab";
                } else if (CRAWLSPACE_DEFAULT_STATES.contains(stateAbbr)) {
                        foundationType = "crawlspace";
                } else {
                        foundationType = "basement";
                }

                String userIntent = "homeowner";
                String sqftCategory = "under_2000";
                String radonResultBand = county != null && county.getEpaZone() == 1 ? "above_4"
                                : county != null && county.getEpaZone() == 2 ? "between_2_and_4"
                                                : "not_tested";
                if (county != null && county.getStats() != null && county.getStats().getMetrics() != null) {
                        var metrics = county.getStats().getMetrics();
                        if (metrics.getMedianHomeValue() >= 475000) {
                                userIntent = "buying";
                                sqftCategory = "over_2000";
                        } else if (metrics.getBuiltBefore1980Pct() >= 58) {
                                userIntent = "selling";
                        } else if (county.getEpaZone() == 2) {
                                userIntent = "buying";
                        }
                }

                return new DefaultScenario(foundationType, userIntent, sqftCategory, radonResultBand);
        }

        private String buildPricingRationale(County county, ItemizedReceipt receipt,
                        ItemizedReceipt stateAverageReceipt, SimilarityAssessment assessment) {
                List<String> drivers = new ArrayList<>();
                int stateDeltaPct = 0;
                if (receipt != null && stateAverageReceipt != null && stateAverageReceipt.getTotalAvg() > 0) {
                        stateDeltaPct = (int) Math.round(
                                        ((receipt.getTotalAvg() - stateAverageReceipt.getTotalAvg()) * 100.0)
                                                        / stateAverageReceipt.getTotalAvg());
                }

                if (stateDeltaPct >= 10) {
                        drivers.add("local estimates run above the state midpoint");
                } else if (stateDeltaPct <= -10) {
                        drivers.add("local estimates land below the state midpoint");
                } else {
                        drivers.add("this county prices close to the state midpoint");
                }

                if (county != null && county.getStats() != null && county.getStats().getMetrics() != null) {
                        var metrics = county.getStats().getMetrics();
                        if (metrics.getBuiltBefore1980Pct() >= 55) {
                                drivers.add("older housing stock usually adds more routing and sealing variation");
                        } else if (metrics.getBuiltBefore1980Pct() <= 28) {
                                drivers.add("newer housing stock keeps more installs near standard scope");
                        }

                        if (metrics.getMedianHomeValue() >= 500000) {
                                drivers.add("higher-value homes more often include longer pipe runs and cleaner finish expectations");
                        } else if (metrics.getMedianHomeValue() > 0 && metrics.getMedianHomeValue() <= 180000) {
                                drivers.add("contractors see more straightforward retrofits than luxury concealment work");
                        }
                }

                if (assessment != null && assessment.getCohortSize() >= 120) {
                        drivers.add("foundation type and roofline routing matter more here than a one-size-fits-all national average");
                }

                if (drivers.isEmpty()) {
                        return "foundation type and roofline routing shift the scope more than a national average suggests.";
                }
                if (drivers.size() == 1) {
                        return capitalize(drivers.get(0)) + ".";
                }

                StringBuilder sentence = new StringBuilder(capitalize(drivers.get(0))).append(", while ");
                for (int i = 1; i < drivers.size(); i++) {
                        if (i > 1) {
                                sentence.append(i == drivers.size() - 1 ? " and " : ", ");
                        }
                        sentence.append(drivers.get(i));
                }
                sentence.append(".");
                return sentence.toString();
        }

        private String buildSeoDescription(String areaName, String stateAbbr, ItemizedReceipt receipt,
                        String pricingRationale, String radonResultBand) {
                if (receipt == null) {
                        return "See the typical radon mitigation price range in " + areaName + ", " + stateAbbr + ".";
                }

                String rationale = pricingRationale == null ? "" : pricingRationale.trim();
                if (rationale.length() > 105) {
                        rationale = rationale.substring(0, 102).trim() + "...";
                }

                String resultLead = switch (radonResultBand) {
                        case "under_2" -> "For readings under 2.0 pCi/L, this page is mostly future budgeting context.";
                        case "between_2_and_4" ->
                                "For readings between 2.0 and 3.9 pCi/L, compare retesting versus quote-planning.";
                        case "above_4" ->
                                "For readings at 4.0+ pCi/L, use this page to budget your next step and compare quotes.";
                        default ->
                                "If you have not tested yet, use this page to understand likely cost before you call a pro.";
                };

                return resultLead + " Radon mitigation in " + areaName + ", " + stateAbbr + " averages $"
                                + receipt.getTotalAvg()
                                + " (common range $" + receipt.getTotalLow() + "-$" + receipt.getTotalHigh() + "). "
                                + rationale;
        }

        private String normalizeRadonResultBand(String radonResultBand) {
                if (radonResultBand == null || radonResultBand.isBlank()) {
                        return "not_tested";
                }
                return switch (radonResultBand.toLowerCase()) {
                        case "under_2", "between_2_and_4", "above_4" -> radonResultBand.toLowerCase();
                        default -> "not_tested";
                };
        }

        private String buildHeroTitle(String areaName, String stateAbbr, String radonResultBand) {
                return switch (radonResultBand) {
                        case "under_2" ->
                                "What Should You Do With a Low Radon Result in " + areaName + ", " + stateAbbr + "?";
                        case "between_2_and_4" ->
                                "What Should You Do With a 2.0-3.9 Radon Result in " + areaName + ", " + stateAbbr + "?";
                        case "above_4" ->
                                "What Should You Do With a 4.0+ Radon Result in " + areaName + ", " + stateAbbr + "?";
                        default ->
                                "Radon Action Plan + Mitigation Cost in " + areaName + ", " + stateAbbr;
                };
        }

        private String buildHeroSummary(String areaName, ItemizedReceipt receipt, String radonResultBand) {
                String priceRange = receipt == null
                                ? ""
                                : " Local mitigation usually lands around $" + receipt.getTotalAvg()
                                                + " (often $" + receipt.getTotalLow() + "-$" + receipt.getTotalHigh()
                                                + ").";
                return switch (radonResultBand) {
                        case "under_2" ->
                                "A confirmed reading under 2.0 pCi/L in " + areaName
                                                + " is usually a monitor-and-retest situation, not an immediate mitigation job."
                                                + priceRange;
                        case "between_2_and_4" ->
                                "A reading between 2.0 and 3.9 pCi/L in " + areaName
                                                + " is borderline: many owners retest first, but buyers, sellers, and heavy basement use can justify planning quotes now."
                                                + priceRange;
                        case "above_4" ->
                                "A confirmed reading at or above 4.0 pCi/L in " + areaName
                                                + " is above the EPA action level. Use the local range below to budget mitigation and compare next steps."
                                                + priceRange;
                        default ->
                                "If you have not tested yet, start with a confirmed reading. This page shows what mitigation would likely cost in "
                                                + areaName
                                                + " if your result comes back elevated, so you can plan before you contact contractors."
                                                + priceRange;
                };
        }

        private String buildIntentSectionTitle(String safeIntent, String radonResultBand) {
                String suffix = switch (safeIntent) {
                        case "buying" -> "for Buyers";
                        case "selling" -> "for Sellers";
                        default -> "for Homeowners";
                };
                return switch (radonResultBand) {
                        case "under_2" -> "Low Reading Plan " + suffix;
                        case "between_2_and_4" -> "Borderline Reading Plan " + suffix;
                        case "above_4" -> "4.0+ Action Plan " + suffix;
                        default -> "First Test Plan " + suffix;
                };
        }

        private String buildIntentIntro(String areaName, String stateAbbr, ItemizedReceipt receipt, String safeIntent,
                        String radonResultBand) {
                String priceAnchor = receipt == null ? ""
                                : " In " + areaName + ", many quotes cluster near $" + receipt.getTotalAvg() + ".";
                return switch (radonResultBand) {
                        case "under_2" ->
                                "This result does not usually justify urgent mitigation. Your job is to document the reading, decide when to retest, and keep budget context handy."
                                                + priceAnchor;
                        case "between_2_and_4" ->
                                "This is the gray zone. The right move depends on how the basement is used, whether the reading was short-term, and whether a sale timeline forces faster decisions."
                                                + priceAnchor;
                        case "above_4" ->
                                "This reading is high enough that you should plan your next move now. Use the local range, then decide whether to get quotes, negotiate credits, or schedule mitigation."
                                                + priceAnchor;
                        default ->
                                "Before you spend money on mitigation in " + areaName + ", confirm the reading first. Then move into quote comparison only if the result stays elevated."
                                                + priceAnchor;
                };
        }

        private List<String> buildIntentSteps(String areaName, String stateAbbr, ItemizedReceipt receipt,
                        String safeIntent, String radonResultBand, ContentTemplates.IntentContent intentContent,
                        Map<String, String> ctx) {
                List<String> steps = new ArrayList<>();
                switch (radonResultBand) {
                        case "under_2" -> {
                                steps.add("Save the test result and note whether it was short-term, long-term, or a digital monitor average.");
                                steps.add("Retest after major ventilation, HVAC, or seasonal changes instead of treating this like an immediate contractor job.");
                                steps.add(intentAwareThirdStep(safeIntent));
                        }
                        case "between_2_and_4" -> {
                                steps.add("Confirm whether the reading came from the lowest livable level and whether closed-house conditions were followed.");
                                steps.add("Use this local range to decide whether a quote is worth getting now or after confirmatory testing.");
                                steps.add(intentAwareThirdStep(safeIntent));
                        }
                        case "above_4" -> {
                                steps.add("Keep the report, reading method, and test location handy so you can compare contractor recommendations against the same baseline.");
                                steps.add("Use the " + areaName + ", " + stateAbbr + " cost range here as your first budget anchor before you request quotes.");
                                steps.add(intentAwareThirdStep(safeIntent));
                                steps.add("Plan a post-mitigation retest so the money actually buys a safer result, not just a fan installation.");
                        }
                        default -> {
                                steps.add("Start with a short-term test kit or continuous monitor in the lowest livable level of the home.");
                                steps.add("If the result comes back near or above 4.0 pCi/L, return here with the reading and compare local cost before you call contractors.");
                                steps.add(intentAwareThirdStep(safeIntent));
                        }
                }

                if (intentContent != null && intentContent.getSteps() != null && !intentContent.getSteps().isEmpty()) {
                        String resolvedStep = resolve(intentContent.getSteps().get(0), ctx);
                        if (steps.stream().noneMatch(existing -> existing.equalsIgnoreCase(resolvedStep))) {
                                steps.add(resolvedStep);
                        }
                }
                return steps;
        }

        private String buildIntentProTip(String areaName, String stateAbbr, String safeIntent, String radonResultBand,
                        ContentTemplates.IntentContent intentContent, Map<String, String> ctx) {
                String fallback = intentContent != null ? resolve(intentContent.getProTip(), ctx) : "";
                return switch (radonResultBand) {
                        case "under_2" ->
                                "Low readings are still useful in negotiations. Keep the report and date so you can show why you chose monitoring over a rushed mitigation spend.";
                        case "between_2_and_4" ->
                                "Borderline readings convert best when you frame them as a decision problem, not a scare problem: confirm the result, compare the budget, then choose whether timing matters.";
                        case "above_4" ->
                                "Do not ask contractors what you should spend before you know your own budget range. Use the local estimate first, then compare quotes against that anchor.";
                        default ->
                                fallback == null || fallback.isBlank()
                                                ? "The smartest first step is a confirmed reading, not a contractor form."
                                                : fallback;
                };
        }

        private String intentAwareThirdStep(String safeIntent) {
                return switch (safeIntent) {
                        case "buying" ->
                                "If you are under contract, translate the result into a seller credit or mitigation request before inspection deadlines close.";
                        case "selling" ->
                                "If you are selling, compare the likely mitigation cost against the size of the credit you may be asked to offer.";
                        default ->
                                "If you are staying in the home, compare the quote range against how often the basement is used and whether a long-term monitor changes the decision.";
                };
        }

        private String capitalize(String input) {
                        if (input == null || input.isBlank()) {
                                return "";
                        }
                        return input.substring(0, 1).toUpperCase() + input.substring(1);
        }

        /**
         * Resolve all {placeholder} tokens in a template string.
         */
        private String resolve(String template, Map<String, String> context) {
                if (template == null)
                        return "";
                String result = template;
                for (Map.Entry<String, String> entry : context.entrySet()) {
                        result = result.replace(entry.getKey(), entry.getValue());
                }
                return result;
        }

        private record DefaultScenario(String foundationType, String userIntent, String sqftCategory,
                        String radonResultBand) {
        }
}
