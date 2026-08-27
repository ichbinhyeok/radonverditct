package com.radonverdict.config;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.List;
import java.util.Set;

@Component
public class LegacySurfaceRetirementFilter extends OncePerRequestFilter {
    private static final List<String> RETIRED_PREFIXES = List.of(
            "/radon-cost-calculator", "/radon-mitigation-cost", "/radon-credit-calculator",
            "/radon-quote-ledger", "/radon-cost-data-report", "/submit-lead", "/search-zip",
            "/search-zip-credit", "/htmx/calculate-receipt");
    private static final Set<String> RETAINED_GUIDES = Set.of(
            "/guides/how-to-test-for-radon",
            "/guides/radon-failed-inspection",
            "/guides/radon-mitigation-quote-checklist");
    private final boolean legacySurfacesEnabled;

    public LegacySurfaceRetirementFilter(
            @Value("${app.product.legacy-surfaces-enabled:false}") boolean legacySurfacesEnabled) {
        this.legacySurfacesEnabled = legacySurfacesEnabled;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
            throws ServletException, IOException {
        if (legacySurfacesEnabled) {
            chain.doFilter(request, response);
            return;
        }
        String path = request.getRequestURI();
        if ("/client-action-plan".equals(path)) {
            response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);
            response.setHeader("Location", "/plan");
            return;
        }
        boolean retiredGuide = ("/guides".equals(path) || path.startsWith("/guides/"))
                && !RETAINED_GUIDES.contains(path);
        boolean retiredStateHub = path.matches("/radon-levels/[^/]+");
        if (retiredGuide || retiredStateHub || RETIRED_PREFIXES.stream().anyMatch(path::startsWith)) {
            response.setHeader("X-Robots-Tag", "noindex, noarchive");
            response.setContentType("text/plain;charset=UTF-8");
            response.setStatus(HttpServletResponse.SC_GONE);
            response.getWriter().write("This estimate surface was retired because the available inputs could not support a defensible local answer. Build a result-first plan at /plan.");
            return;
        }
        chain.doFilter(request, response);
    }
}
