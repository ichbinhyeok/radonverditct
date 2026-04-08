package com.radonverdict.controller;

import com.radonverdict.model.dto.ContactSubmissionRequest;
import com.radonverdict.service.ContactMessageService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.view.RedirectView;

@Controller
@RequiredArgsConstructor
public class InfoController {

    private final ContactMessageService contactMessageService;

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
        if (!model.containsAttribute("contactForm")) {
            model.addAttribute("contactForm", new ContactSubmissionRequest());
        }
        return "pages/contact";
    }

    @PostMapping("/contact")
    public RedirectView submitContact(
            @Valid @ModelAttribute("contactForm") ContactSubmissionRequest request,
            BindingResult bindingResult,
            HttpServletRequest httpRequest,
            RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            redirectAttributes.addFlashAttribute("contactErrorMessage",
                    "Please fill out your name, email, and message.");
            redirectAttributes.addFlashAttribute("contactForm", request);
            return contactRedirect();
        }

        try {
            contactMessageService.submit(request, httpRequest.getRemoteAddr(), httpRequest.getHeader("User-Agent"));
            redirectAttributes.addFlashAttribute("contactSuccessMessage",
                    "Thanks. Your message was received and queued for review.");
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("contactErrorMessage",
                    "We could not save your message right now. Please email shinhyeok22@gmail.com instead.");
            redirectAttributes.addFlashAttribute("contactForm", request);
        }

        return contactRedirect();
    }

    private RedirectView contactRedirect() {
        RedirectView view = new RedirectView("/contact", true);
        view.setStatusCode(HttpStatus.SEE_OTHER);
        return view;
    }
}
