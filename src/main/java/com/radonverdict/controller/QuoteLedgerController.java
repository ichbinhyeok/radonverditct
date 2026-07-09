package com.radonverdict.controller;

import com.radonverdict.model.County;
import com.radonverdict.model.dto.QuoteLedgerSubmissionRequest;
import com.radonverdict.service.DataLoadService;
import com.radonverdict.service.QuoteLedgerService;
import com.radonverdict.service.TelemetryEventService;
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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.view.RedirectView;

@Slf4j
@Controller
@RequiredArgsConstructor
public class QuoteLedgerController {

    private static final String ZIP_CODE_PATTERN = "^\\d{5}$";
    private static final String ROLE_PATTERN = "^(homeowner|buyer|seller|agent|inspector|mitigator|other)$";
    private static final String RESULT_BAND_PATTERN = "^(not_tested|under_2|between_2_and_4|above_4|above_8|unknown)$";
    private static final String RADON_READING_PATTERN = "^\\d{1,2}(\\.\\d{1,2})?$";
    private static final String FOUNDATION_PATTERN = "^(basement|slab|crawlspace|mixed|unknown)$";
    private static final String QUOTE_STATUS_PATTERN = "^(quoted|paid|seller_credit|declined|planning)$";
    private static final String PRICE_PATTERN = "^[0-9]{2,6}$";

    private final QuoteLedgerService quoteLedgerService;
    private final DataLoadService dataLoadService;
    private final TelemetryEventService telemetryEventService;

    @GetMapping("/radon-quote-ledger")
    public String quoteLedger(Model model, HttpServletRequest request) {
        model.addAttribute("title", "Observed Radon Quote Ledger | RadonVerdict");
        if (!model.containsAttribute("quoteLedgerForm")) {
            model.addAttribute("quoteLedgerForm", prefillQuoteLedgerForm(request));
        }
        model.addAttribute("quoteBenchmark", quoteLedgerService.getBenchmarkSnapshot());
        return "pages/quote_ledger";
    }

    @GetMapping(value = "/radon-quote-ledger/benchmark.csv", produces = "text/csv")
    @ResponseBody
    public String quoteLedgerBenchmarkCsv() {
        return quoteLedgerService.publicBenchmarkCsv();
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
            telemetryEventService.persistEvent(
                    "quote_ledger_submit_success",
                    "/radon-quote-ledger",
                    httpRequest.getRemoteAddr(),
                    httpRequest.getHeader("User-Agent"),
                    java.util.Map.of(
                            "event", "quote_ledger_submit_success",
                            "state", safeTelemetryValue(county.getStateSlug()),
                            "state_abbr", safeTelemetryValue(county.getStateAbbr()),
                            "county", safeTelemetryValue(county.getCountySlug()),
                            "role", safeTelemetryValue(request.getRole()),
                            "result_band", safeTelemetryValue(request.getResultBand()),
                            "foundation", safeTelemetryValue(request.getFoundationType()),
                            "quote_status", safeTelemetryValue(request.getQuoteStatus()),
                            "has_price", hasPrice(request)));
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
        if (zipCode == null || !zipCode.matches(ZIP_CODE_PATTERN)) {
            return null;
        }
        String fips = dataLoadService.getZipToFipsMap().get(zipCode);
        return fips == null ? null : dataLoadService.getCountByFipsMap().get(fips);
    }

    private QuoteLedgerSubmissionRequest prefillQuoteLedgerForm(HttpServletRequest request) {
        QuoteLedgerSubmissionRequest form = new QuoteLedgerSubmissionRequest();
        form.setZipCode(matchingParam(request, "zipCode", ZIP_CODE_PATTERN));
        form.setRole(matchingParam(request, "role", ROLE_PATTERN));
        form.setResultBand(matchingParam(request, "resultBand", RESULT_BAND_PATTERN));
        form.setRadonReadingPciL(matchingParam(request, "radonReadingPciL", RADON_READING_PATTERN));
        form.setFoundationType(matchingParam(request, "foundationType", FOUNDATION_PATTERN));
        form.setQuoteStatus(matchingParam(request, "quoteStatus", QUOTE_STATUS_PATTERN));
        form.setQuotedPrice(matchingParam(request, "quotedPrice", PRICE_PATTERN));
        form.setFinalPrice(matchingParam(request, "finalPrice", PRICE_PATTERN));
        form.setSystemScope(textParam(request, "systemScope", 80));
        form.setTimeline(textParam(request, "timeline", 80));
        form.setNotes(textParam(request, "notes", 1200));
        return form;
    }

    private String matchingParam(HttpServletRequest request, String name, String pattern) {
        String value = textParam(request, name, 80);
        if (value == null || !value.matches(pattern)) {
            return null;
        }
        return value;
    }

    private String textParam(HttpServletRequest request, String name, int maxLength) {
        String value = request.getParameter(name);
        if (value == null) {
            return null;
        }
        String normalized = value.trim().replaceAll("\\p{Cntrl}", " ");
        if (normalized.isBlank()) {
            return null;
        }
        return normalized.length() <= maxLength ? normalized : normalized.substring(0, maxLength);
    }

    private boolean hasPrice(QuoteLedgerSubmissionRequest request) {
        return (request.getQuotedPrice() != null && !request.getQuotedPrice().isBlank())
                || (request.getFinalPrice() != null && !request.getFinalPrice().isBlank());
    }

    private String safeTelemetryValue(String value) {
        if (value == null || value.isBlank()) {
            return "";
        }
        return value.trim().replaceAll("[^A-Za-z0-9_\\- ]", "").toLowerCase(java.util.Locale.US);
    }

    private RedirectView quoteLedgerRedirect() {
        RedirectView view = new RedirectView("/radon-quote-ledger", true);
        view.setStatusCode(HttpStatus.SEE_OTHER);
        return view;
    }
}
