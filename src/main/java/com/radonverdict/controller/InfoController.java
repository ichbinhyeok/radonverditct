package com.radonverdict.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class InfoController {

    @Value("${app.content.privacy-last-updated:February 1, 2026}")
    private String privacyLastUpdated;

    @GetMapping("/about")
    public String about(Model model) {
        model.addAttribute("title", "About Us | RadonVerdict");
        return "pages/about";
    }

    @GetMapping("/privacy")
    public String privacy(Model model) {
        model.addAttribute("title", "Privacy Policy | RadonVerdict");
        model.addAttribute("privacyLastUpdated", privacyLastUpdated);
        return "pages/privacy";
    }

    @GetMapping("/terms")
    public String terms(Model model) {
        model.addAttribute("title", "Terms & Conditions | RadonVerdict");
        return "pages/terms";
    }

    @GetMapping("/contact")
    public String contact(Model model) {
        model.addAttribute("title", "Contact Us | RadonVerdict");
        return "pages/contact";
    }
}
