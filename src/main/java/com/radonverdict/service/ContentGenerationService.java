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
                // 6. Build Dynamic FAQs (zone-specific + universal)
                Map<String, String> ctx = buildContext(areaName, stateAbbr, receipt, zoneKey, stateRule);

                List<CountyPageContent.FaqItem> faqs = buildFaqs(
                                faqTemplates, zoneKey, stateRule, ctx);

                // 6.5 Calculate nearby counties for SEO siloing
                List<County> nearbyCounties = dataLoadService.getCountyBySlugMap().values().stream()
                                .filter(c -> c.getStateAbbr().equals(stateAbbr)
                                                && !c.getCountySlug().equals(county.getCountySlug()))
                                .limit(6)
                                .toList();

                SimilarityAssessment similarity = similarityEngineService.assessMitigationPage(county, receipt);
                List<String> localInsights = new ArrayList<>(countyInsightService.buildLocalInsights(county, receipt));
                localInsights.addAll(similarityEngineService.buildDifferentiationNarratives(county, receipt, similarity));

                // 6.7 Evaluate indexing quality gate
                boolean isIndexable = (county.getStats() != null
                                && county.getStats().getMetrics() != null
                                && county.getStats().getMetrics().getTotalHousingUnits() > 0);

                // 7. Assemble Final DTO
                return CountyPageContent.builder()
                                .indexable(isIndexable)
                                .heroTitle("Radon Mitigation Cost in " + areaName + ", " + stateAbbr)
                                .heroSummary(resolve(areaName + " " + zoneDesc.getHeroSummary(), ctx))
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
                        String zoneKey, StateRegulations.StateRule stateRule) {
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
                return ctx;
        }

        /**
         * Build FAQs: Zone-specific questions + universal questions.
         */
        private List<CountyPageContent.FaqItem> buildFaqs(
                        FaqTemplates faqTemplates, String zoneKey,
                        StateRegulations.StateRule stateRule, Map<String, String> ctx) {

                List<CountyPageContent.FaqItem> result = new ArrayList<>();

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
}
