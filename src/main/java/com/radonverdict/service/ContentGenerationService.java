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
                return buildPageContent(county, foundationType, userIntent, "under_2000");
        }

        public CountyPageContent buildDefaultPageContent(County county) {
                DefaultScenario scenario = chooseDefaultScenario(county);
                return buildPageContent(county, scenario.foundationType(), scenario.userIntent(), scenario.sqftCategory());
        }

        public CountyPageContent buildPageContent(County county, String foundationType, String userIntent,
                        String sqftCategory) {

                String zoneKey = String.valueOf(county.getEpaZone());
                String stateAbbr = county.getStateAbbr();
                String countyName = county.getCountyName();
                String areaName = county.getAreaDisplayName();

                ContentTemplates templates = dataLoadService.getContentTemplates();
                StateRegulations regulations = dataLoadService.getStateRegulations();
                FaqTemplates faqTemplates = dataLoadService.getFaqTemplates();

                String safeSqftCategory = (sqftCategory == null || sqftCategory.isBlank()) ? "under_2000" : sqftCategory;

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
                                .heroTitle("How Much Does Radon Mitigation Cost in " + areaName + ", " + stateAbbr + "?")
                                .heroSummary(resolve(areaName + " " + zoneDesc.getHeroSummary(), ctx))
                                .seoDescription(buildSeoDescription(areaName, stateAbbr, receipt, pricingRationale))
                                .pricingRationale(pricingRationale)
                                .riskLevel(zoneDesc.getRiskLevel())
                                .badgeColor(zoneDesc.getBadgeColor())
                                .riskNarrative(resolve(zoneDesc.getRiskNarrative(), ctx))
                                .localInsights(localInsights)
                                .intentSectionTitle(resolve(intentContent.getSectionTitle(), ctx))
                                .intentIntro(resolve(intentContent.getIntro(), ctx))
                                .intentSteps(intentContent.getSteps().stream()
                                                .map(s -> resolve(s, ctx)).toList())
                                .intentProTip(resolve(intentContent.getProTip(), ctx))
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

                return new DefaultScenario(foundationType, userIntent, sqftCategory);
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
                        String pricingRationale) {
                if (receipt == null) {
                        return "See the typical radon mitigation price range in " + areaName + ", " + stateAbbr + ".";
                }

                String rationale = pricingRationale == null ? "" : pricingRationale.trim();
                if (rationale.length() > 105) {
                        rationale = rationale.substring(0, 102).trim() + "...";
                }

                return "Radon mitigation in " + areaName + ", " + stateAbbr + " averages $" + receipt.getTotalAvg()
                                + " (common range $" + receipt.getTotalLow() + "-$" + receipt.getTotalHigh() + "). "
                                + rationale;
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

        private record DefaultScenario(String foundationType, String userIntent, String sqftCategory) {
        }
}
