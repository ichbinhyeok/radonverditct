package com.radonverdict.controller;

import com.radonverdict.model.dto.AeoAnswerBlock;
import com.radonverdict.model.dto.TrustMetadata;
import com.radonverdict.service.TrustMetadataService;
import com.radonverdict.service.TestProtocolGuideCatalog;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequiredArgsConstructor
public class GuideController {

    private final TrustMetadataService trustMetadataService;
    private final TestProtocolGuideCatalog testProtocolGuideCatalog;

    @GetMapping("/guides")
    public String guidesHub(Model model) {
        model.addAttribute("title", "Radon Testing & System Guides | RadonVerdict");
        model.addAttribute("guides", testProtocolGuideCatalog.all());
        model.addAttribute("priorityGuides", testProtocolGuideCatalog.acquisitionPriority());
        model.addAttribute("guideCategories", testProtocolGuideCatalog.categories());
        return "pages/guides_hub";
    }

    @GetMapping("/guides/diy-vs-professional-radon-mitigation")
    public String guideDiyVsPro(Model model) {
        model.addAttribute("title", "DIY Radon Mitigation vs. Hiring a Pro | RadonVerdict");
        return "pages/guide_diy_vs_pro";
    }

    @GetMapping("/guides/radon-mitigation-timeline-how-long-does-it-take")
    public String guideHowLong(Model model) {
        model.addAttribute("title", "How Long Does Radon Mitigation Take? | RadonVerdict");
        return "pages/guide_how_long";
    }

    @GetMapping("/guides/how-to-test-for-radon")
    public String guideRadonTesting(Model model) {
        model.addAttribute("title", "How to Test for Radon at Home | RadonVerdict");
        TrustMetadata trust = trustMetadataService.forTestingGuidePage();
        model.addAttribute("trust", trust);
        model.addAttribute("aeo", AeoAnswerBlock.builder()
                .question("How do you test a home for radon?")
                .directAnswer("Define why you are testing, choose a device that fits that decision, use the lowest regularly occupied level, follow the device's exact placement and timing instructions, and keep the procedure record with the result.")
                .evidenceRows(List.of(
                        AeoAnswerBlock.Row.builder().label("Short-term").value("2 to 90 days; device instructions set the exact window").build(),
                        AeoAnswerBlock.Row.builder().label("Long-term").value("More than 90 days").build(),
                        AeoAnswerBlock.Row.builder().label("Placement").value("Lowest regularly occupied level plus device instructions").build(),
                        AeoAnswerBlock.Row.builder().label("Record").value("Purpose, device, location, timestamps, conditions, and incidents").build()))
                .sources(trust != null ? trust.getSources() : List.of())
                .build());
        return "pages/guide_radon_testing";
    }

    @GetMapping("/guides/who-pays-radon-mitigation-buyer-or-seller")
    public String guideBuyerSeller(Model model) {
        model.addAttribute("title", "Who Pays for Radon Mitigation: Buyer or Seller? | RadonVerdict");
        return "pages/guide_real_estate";
    }

    @GetMapping("/guides/radon-failed-inspection")
    public String guideFailedInspection(
            @RequestParam(name = "zipCode", required = false) String zipCode,
            @RequestParam(name = "radonReading", required = false) String radonReading,
            @RequestParam(name = "intent", required = false) String intent,
            @RequestParam(name = "source", required = false) String source,
            Model model) {
        model.addAttribute("title", "Radon Failed Inspection: Repair, Credit, or Retest? | RadonVerdict");
        model.addAttribute("clientZip", normalizeZip(zipCode));
        model.addAttribute("clientReading", normalizeReading(radonReading));
        model.addAttribute("clientIntent", normalizeIntent(intent));
        model.addAttribute("clientSource", normalizeSource(source));
        model.addAttribute("sharedByInspector", "inspector-demo".equals(normalizeSource(source))
                ? "Your Inspection Company"
                : null);
        model.addAttribute("trust", trustMetadataService.forGuidePage());
        return "pages/guide_failed_inspection";
    }

    @GetMapping("/guides/radon-inspection-toolkit")
    public String guideInspectionToolkit(Model model) {
        model.addAttribute("title", "Radon Failed Inspection Toolkit for Agents and Home Inspectors | RadonVerdict");
        return "pages/guide_inspection_toolkit";
    }

    @GetMapping("/for-home-inspectors")
    public String homeInspectorPacket(Model model) {
        model.addAttribute("title", "Radon Decision Packet for Home Inspectors | RadonVerdict");
        model.addAttribute("packetSource", "home-inspector-packet");
        model.addAttribute("pageTitle", "Radon Decision Packet for Home Inspectors | RadonVerdict");
        model.addAttribute("canonicalUrl", "https://radonverdict.com/for-home-inspectors");
        return "pages/home_inspector_packet";
    }

    @GetMapping("/for-home-inspectors/demo")
    public String homeInspectorPacketDemo(Model model) {
        model.addAttribute("title", "Inspector Client Follow-Up Link Demo | RadonVerdict");
        return "pages/home_inspector_demo";
    }

    @GetMapping("/guides/radon-mitigation-quote-checklist")
    public String guideQuoteChecklist(Model model) {
        model.addAttribute("title", "Radon Quote Checklist: Questions Before Hiring | RadonVerdict");
        model.addAttribute("trust", trustMetadataService.forGuidePage());
        return "pages/guide_quote_checklist";
    }

    @GetMapping("/guides/radon-seller-credit-worksheet")
    public String guideSellerCreditWorksheet(Model model) {
        model.addAttribute("title", "Radon Seller Credit Worksheet | RadonVerdict");
        return "pages/guide_seller_credit_worksheet";
    }

    @GetMapping("/guides/radon-exposure-symptoms")
    public String guideHealthSymptoms(Model model) {
        model.addAttribute("title", "Symptoms of Radon Exposure: The Silent Killer Explained | RadonVerdict");
        return "pages/guide_health_symptoms";
    }

    @GetMapping("/guides/active-vs-passive-radon-system")
    public String guideActivePassive(Model model) {
        model.addAttribute("title", "Active vs. Passive Radon Mitigation Systems | RadonVerdict");
        return "pages/guide_active_passive";
    }

    @GetMapping("/guides/crawl-space-radon-mitigation")
    public String guideCrawlSpace(Model model) {
        model.addAttribute("title", "Crawl Space Radon Mitigation: Why It Costs More | RadonVerdict");
        return "pages/guide_crawl_space";
    }

    @GetMapping("/guides/sump-pump-radon-mitigation")
    public String guideSumpPump(Model model) {
        model.addAttribute("title", "Sump Pumps & Radon Mitigation: The Unsealed Pit Problem | RadonVerdict");
        return "pages/guide_sump_pump";
    }

    @GetMapping("/guides/radon-system-electricity-cost")
    public String guideEnergyCosts(Model model) {
        model.addAttribute("title", "Radon System Electricity Cost: $5-$15/Month to Run the Fan | RadonVerdict");
        return "pages/guide_energy_costs";
    }

    private String normalizeZip(String value) {
        if (value == null) {
            return null;
        }
        String normalized = value.trim();
        return normalized.matches("\\d{5}") ? normalized : null;
    }

    private String normalizeReading(String value) {
        if (value == null) {
            return null;
        }
        String normalized = value.trim();
        if (!normalized.matches("\\d{1,2}(?:\\.\\d{1,2})?")) {
            return null;
        }
        try {
            double reading = Double.parseDouble(normalized);
            return reading >= 0 && reading <= 99.99 ? normalized : null;
        } catch (NumberFormatException ignored) {
            return null;
        }
    }

    private String normalizeIntent(String value) {
        if (value == null) {
            return null;
        }
        String normalized = value.trim().toLowerCase(java.util.Locale.US);
        return switch (normalized) {
            case "buying", "selling", "homeowner" -> normalized;
            default -> null;
        };
    }

    private String normalizeSource(String value) {
        if (value == null) {
            return null;
        }
        String normalized = value.trim().toLowerCase(java.util.Locale.US);
        return normalized.matches("[a-z0-9_-]{2,60}") ? normalized : null;
    }

    @GetMapping("/guides/radon-myths-granite-countertops")
    public String guideGraniteMyths(Model model) {
        model.addAttribute("title", "Do Granite Countertops Cause High Radon Levels? Myth vs. Fact | RadonVerdict");
        return "pages/guide_myths";
    }
}
