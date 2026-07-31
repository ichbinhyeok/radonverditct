package com.radonverdict.controller;

import com.radonverdict.service.ActionPlanService;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequiredArgsConstructor
public class ActionPlanController {
    private final ActionPlanService actionPlanService;

    @GetMapping("/plan")
    public String plan(@RequestParam(name = "zipCode", required = false) String zipCode,
                       @RequestParam(name = "radonReading", required = false) String radonReading,
                       @RequestParam(name = "noTest", defaultValue = "false") boolean noTest,
                       @RequestParam(name = "intent", required = false) String intent,
                       @RequestParam(name = "source", required = false) String source,
                       HttpServletResponse response,
                       Model model) {
        response.setHeader("X-Robots-Tag", "noindex, noarchive");
        response.setHeader("Cache-Control", "private, no-store");
        response.setHeader("Referrer-Policy", "no-referrer");
        model.addAttribute("plan", actionPlanService.build(zipCode, radonReading, noTest, intent, source));
        return "action_plan";
    }
}
