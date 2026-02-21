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
}
