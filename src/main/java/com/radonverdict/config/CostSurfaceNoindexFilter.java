package com.radonverdict.config;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Component
public class CostSurfaceNoindexFilter extends OncePerRequestFilter {
    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        String path = request.getRequestURI();
        if (path.equals("/radon-mitigation-cost")
                || path.equals("/radon-cost-calculator")
                || path.equals("/radon-credit-calculator")
                || path.startsWith("/radon-credit-calculator/")
                || path.equals("/radon-cost-data-report")
                || path.equals("/radon-quote-ledger")
                || path.startsWith("/htmx/calculate-receipt")) {
            response.setHeader("X-Robots-Tag", "noindex, follow");
        }
        filterChain.doFilter(request, response);
    }
}
