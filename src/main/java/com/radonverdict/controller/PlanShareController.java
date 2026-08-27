package com.radonverdict.controller;

import com.radonverdict.model.dto.RadonActionPlan;
import com.radonverdict.service.ActionPlanService;
import com.radonverdict.service.PlanShareService;
import com.radonverdict.service.TelemetryEventService;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.servlet.view.RedirectView;

import java.util.Map;

@Controller
@RequiredArgsConstructor
@Slf4j
public class PlanShareController {
    private final ActionPlanService actionPlanService;
    private final PlanShareService planShareService;
    private final TelemetryEventService telemetryEventService;

    @PostMapping("/plan/share")
    public Object create(@RequestParam(name = "zipCode", required = false) String zipCode,
                         @RequestParam(name = "radonReading", required = false) String radonReading,
                         @RequestParam(name = "noTest", defaultValue = "false") boolean noTest,
                         @RequestParam(name = "intent", required = false) String intent,
                         HttpServletResponse response,
                         Model model) {
        RadonActionPlan plan = actionPlanService.build(zipCode, radonReading, noTest, intent, "share");
        if (plan.hasValidationError()) {
            privateHeaders(response);
            model.addAttribute("plan", plan);
            model.addAttribute("shareError", "Correct the result before creating a share link.");
            return "action_plan";
        }

        PlanShareService.CreatedShare created = planShareService.create(plan);
        track("share_created", Map.of(
                "schema_version", 1,
                "result_band", plan.getResultBand(),
                "intent", plan.getIntent()));
        RedirectView redirect = new RedirectView("/plan/share/" + created.token(), true);
        redirect.setStatusCode(HttpStatus.SEE_OTHER);
        return redirect;
    }

    @GetMapping("/plan/share/{token}")
    public String view(@PathVariable String token, HttpServletResponse response, Model model) {
        privateHeaders(response);
        PlanShareService.Lookup lookup = planShareService.lookup(token);
        if (lookup.status() == PlanShareService.Status.EXPIRED || lookup.status() == PlanShareService.Status.REVOKED) {
            throw new ResponseStatusException(HttpStatus.GONE, "This private plan link is no longer available");
        }
        if (lookup.status() != PlanShareService.Status.FOUND) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Plan share not found");
        }
        track("client_share_opened", Map.of(
                "schema_version", lookup.snapshot().schemaVersion(),
                "result_band", lookup.snapshot().resultBand()));
        model.addAttribute("snapshot", lookup.snapshot());
        return "shared_plan";
    }

    private void privateHeaders(HttpServletResponse response) {
        response.setHeader("X-Robots-Tag", "noindex, noarchive, nofollow");
        response.setHeader("Cache-Control", "private, no-store");
        response.setHeader("Referrer-Policy", "no-referrer");
    }

    private void track(String eventName, Map<String, Object> payload) {
        try {
            telemetryEventService.persistEvent(eventName, "/plan/share", null, null, payload);
        } catch (RuntimeException exception) {
            log.warn("Share telemetry failed; user flow continues. event={}", eventName, exception);
        }
    }
}
