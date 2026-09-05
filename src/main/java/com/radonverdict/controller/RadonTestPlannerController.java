package com.radonverdict.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class RadonTestPlannerController {

    @GetMapping("/radon-test-planner")
    public String planner() {
        return "radon_test_planner";
    }
}

