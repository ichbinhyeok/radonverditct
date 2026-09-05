package com.radonverdict.controller;

import com.radonverdict.model.dto.TestProtocolGuide;
import com.radonverdict.service.TestProtocolGuideCatalog;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.server.ResponseStatusException;

@Controller
@RequiredArgsConstructor
public class TestProtocolGuideController {

    private final TestProtocolGuideCatalog catalog;

    @GetMapping("/guides/{slug}")
    public String protocolGuide(jakarta.servlet.http.HttpServletRequest request, Model model) {
        String requestPath = request.getRequestURI();
        String resolvedSlug = requestPath.substring(requestPath.lastIndexOf('/') + 1);
        TestProtocolGuide guide = catalog.find(resolvedSlug);
        if (guide == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND);
        }
        model.addAttribute("guide", guide);
        return "pages/test_protocol_guide";
    }
}
