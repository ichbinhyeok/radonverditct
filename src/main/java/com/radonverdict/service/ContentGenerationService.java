package com.radonverdict.service;

import com.radonverdict.model.*;
import com.radonverdict.model.dto.CountyPageContent;
import com.radonverdict.model.dto.ItemizedReceipt;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
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

    /**
     * Build the complete page content for a given county.
     * This single method assembles everything the frontend template needs.
     */
    public CountyPageContent buildPageContent(County county, String foundationType, String userIntent) {

        String zoneKey = String.valueOf(county.getEpaZone());
        String stateAbbr = county.getStateAbbr();
        String countyName = county.getCountyName();

        ContentTemplates templates = dataLoadService.getContentTemplates();
        StateRegulations regulations = dataLoadService.getStateRegulations();
        FaqTemplates faqTemplates = dataLoadService.getFaqTemplates();

        // 1. Get the receipt first (needed for placeholder resolution in text)
        ItemizedReceipt receipt = pricingCalculatorService.calculate(
                stateAbbr, countyName, foundationType, userIntent);

        // 2. Resolve Zone Description
        ContentTemplates.ZoneDescription zoneDesc = templates.getZoneDescriptions().getOrDefault(
                zoneKey, templates.getZoneDescriptions().get("0"));

        // 3. Resolve State Regulation
        StateRegulations.StateRule stateRule = regulations.getStateRules().getOrDefault(
                stateAbbr.toUpperCase(), regulations.getDefaultStateRule());

        // 4. Resolve Foundation Description
        String safeFoundation = (foundationType != null) ? foundationType.toLowerCase() : "other";
        ContentTemplates.FoundationDescription foundationDesc = templates.getFoundationDescriptions().getOrDefault(
                safeFoundation, templates.getFoundationDescriptions().get("other"));

        // 5. Resolve Intent Content
        String safeIntent = (userIntent != null) ? userIntent.toLowerCase() : "homeowner";
        ContentTemplates.IntentContent intentContent = templates.getIntentContent().getOrDefault(
                safeIntent, templates.getIntentContent().get("homeowner"));

        // 6. Build Dynamic FAQs (zone-specific + universal)
        List<CountyPageContent.FaqItem> faqs = buildFaqs(
                faqTemplates, zoneKey, county, receipt, stateRule);

        // 7. Placeholder context map for text resolution
        Map<String, String> ctx = Map.of(
                "{countyName}", countyName,
                "{stateAbbr}", stateAbbr,
                "{totalLow}", String.valueOf(receipt.getTotalLow()),
                "{totalHigh}", String.valueOf(receipt.getTotalHigh()),
                "{totalAvg}", String.valueOf(receipt.getTotalAvg()),
                "{epaZone}", zoneKey,
                "{regulationNote}", stateRule.getDisclosureSummary(),
                "{disclosureNote}", stateRule.isDisclosureRequired()
                        ? "radon disclosure is required during property sales"
                        : "there is no specific radon disclosure mandate, but general disclosure laws may apply",
                "{licenseNote}", stateRule.getLicenseNote());

        // 8. Assemble Final DTO
        return CountyPageContent.builder()
                .heroTitle("Radon Mitigation Cost in " + countyName + ", " + stateAbbr)
                .heroSummary(resolve(countyName + " " + zoneDesc.getHeroSummary(), ctx))
                .riskLevel(zoneDesc.getRiskLevel())
                .badgeColor(zoneDesc.getBadgeColor())
                .riskNarrative(resolve(zoneDesc.getRiskNarrative(), ctx))
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
                .build();
    }

    /**
     * Build FAQs: Zone-specific questions + universal questions.
     * All placeholders are resolved against the current county context.
     */
    private List<CountyPageContent.FaqItem> buildFaqs(
            FaqTemplates faqTemplates, String zoneKey,
            County county, ItemizedReceipt receipt,
            StateRegulations.StateRule stateRule) {

        List<CountyPageContent.FaqItem> result = new ArrayList<>();

        Map<String, String> ctx = Map.of(
                "{countyName}", county.getCountyName(),
                "{stateAbbr}", county.getStateAbbr(),
                "{totalLow}", String.valueOf(receipt.getTotalLow()),
                "{totalHigh}", String.valueOf(receipt.getTotalHigh()),
                "{totalAvg}", String.valueOf(receipt.getTotalAvg()),
                "{epaZone}", zoneKey,
                "{regulationNote}", stateRule.getDisclosureSummary(),
                "{disclosureNote}", stateRule.isDisclosureRequired()
                        ? "radon disclosure is required during property sales"
                        : "there is no specific radon disclosure mandate",
                "{licenseNote}", stateRule.getLicenseNote());

        // Add zone-specific FAQs
        String zonePoolKey = "zone_" + zoneKey;
        List<FaqTemplates.FaqEntry> zoneFaqs = faqTemplates.getFaqPool().get(zonePoolKey);
        if (zoneFaqs != null) {
            for (FaqTemplates.FaqEntry entry : zoneFaqs) {
                result.add(CountyPageContent.FaqItem.builder()
                        .question(resolve(entry.getQuestion(), ctx))
                        .answer(resolve(entry.getAnswer(), ctx))
                        .build());
            }
        }

        // Add universal FAQs
        List<FaqTemplates.FaqEntry> universalFaqs = faqTemplates.getFaqPool().get("universal");
        if (universalFaqs != null) {
            for (FaqTemplates.FaqEntry entry : universalFaqs) {
                result.add(CountyPageContent.FaqItem.builder()
                        .question(resolve(entry.getQuestion(), ctx))
                        .answer(resolve(entry.getAnswer(), ctx))
                        .build());
            }
        }

        return result;
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
