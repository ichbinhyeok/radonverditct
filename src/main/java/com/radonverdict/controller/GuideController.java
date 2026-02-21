package com.radonverdict.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class GuideController {

    @GetMapping("/guides")
    public String guidesHub(Model model) {
        model.addAttribute("title", "Radon Mitigation Guides | RadonVerdict");
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
        model.addAttribute("title", "How to Test for Radon: Complete Homeowner's Guide | RadonVerdict");
        return "pages/guide_radon_testing";
    }

    @GetMapping("/guides/who-pays-radon-mitigation-buyer-or-seller")
    public String guideBuyerSeller(Model model) {
        model.addAttribute("title", "Who Pays for Radon Mitigation: Buyer or Seller? | RadonVerdict");
        return "pages/guide_real_estate";
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

    @GetMapping("/guides/radon-fan-noise-troubleshooting")
    public String guideFanNoise(Model model) {
        model.addAttribute("title", "Radon Fan Noise Troubleshooting: Is It Normal? | RadonVerdict");
        return "pages/guide_fan_noise";
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
        model.addAttribute("title", "Radon System Electricity Cost: How Much Power Does the Fan Use? | RadonVerdict");
        return "pages/guide_energy_costs";
    }

    @GetMapping("/guides/radon-myths-granite-countertops")
    public String guideGraniteMyths(Model model) {
        model.addAttribute("title", "Do Granite Countertops Cause High Radon Levels? Myth vs. Fact | RadonVerdict");
        return "pages/guide_myths";
    }
}
