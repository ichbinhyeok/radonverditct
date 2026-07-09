package com.radonverdict.controller;

import com.radonverdict.model.County;
import com.radonverdict.model.dto.QuoteLedgerSubmissionRequest;
import com.radonverdict.service.DataLoadService;
import com.radonverdict.service.QuoteLedgerService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.view.RedirectView;

@Slf4j
@Controller
@RequiredArgsConstructor
public class QuoteLedgerController {

    private final QuoteLedgerService quoteLedgerService;
    private final DataLoadService dataLoadService;

    @GetMapping("/radon-quote-ledger")
    public String quoteLedger(Model model) {
        model.addAttribute("title", "Observed Radon Quote Ledger | RadonVerdict");
        if (!model.containsAttribute("quoteLedgerForm")) {
            model.addAttribute("quoteLedgerForm", new QuoteLedgerSubmissionRequest());
        }
        return "pages/quote_ledger";
    }

    @PostMapping("/radon-quote-ledger")
    public RedirectView submitQuoteLedger(
            @Valid @ModelAttribute("quoteLedgerForm") QuoteLedgerSubmissionRequest request,
            BindingResult bindingResult,
            HttpServletRequest httpRequest,
            RedirectAttributes redirectAttributes) {

        if (request.getAdditionalPhone() != null && !request.getAdditionalPhone().isBlank()) {
            log.warn("Quote ledger honeypot triggered. IP: {}", httpRequest.getRemoteAddr());
            redirectAttributes.addFlashAttribute("quoteLedgerSuccessMessage",
                    "Thanks. Your quote signal was received.");
            return quoteLedgerRedirect();
        }

        County county = resolveCounty(request.getZipCode());
        if (county == null) {
            redirectAttributes.addFlashAttribute("quoteLedgerErrorMessage",
                    "That ZIP did not match the current county lookup. Use a 5-digit property ZIP.");
            redirectAttributes.addFlashAttribute("quoteLedgerForm", request);
            return quoteLedgerRedirect();
        }

        if (bindingResult.hasErrors()) {
            redirectAttributes.addFlashAttribute("quoteLedgerErrorMessage",
                    "Check the ZIP, role, result band, foundation, quote status, and consent box.");
            redirectAttributes.addFlashAttribute("quoteLedgerForm", request);
            return quoteLedgerRedirect();
        }

        try {
            quoteLedgerService.submit(request, county, httpRequest.getRemoteAddr(), httpRequest.getHeader("User-Agent"));
            redirectAttributes.addFlashAttribute("quoteLedgerSuccessMessage",
                    "Saved. Your anonymized quote signal now helps benchmark local radon pricing.");
        } catch (RuntimeException e) {
            log.error("Failed to save quote ledger submission", e);
            redirectAttributes.addFlashAttribute("quoteLedgerErrorMessage",
                    "We could not save this quote signal right now. Please try again later.");
            redirectAttributes.addFlashAttribute("quoteLedgerForm", request);
        }

        return quoteLedgerRedirect();
    }

    private County resolveCounty(String zipCode) {
        if (zipCode == null || !zipCode.matches("^\\d{5}$")) {
            return null;
        }
        String fips = dataLoadService.getZipToFipsMap().get(zipCode);
        return fips == null ? null : dataLoadService.getCountByFipsMap().get(fips);
    }

    private RedirectView quoteLedgerRedirect() {
        RedirectView view = new RedirectView("/radon-quote-ledger", true);
        view.setStatusCode(HttpStatus.SEE_OTHER);
        return view;
    }
}
