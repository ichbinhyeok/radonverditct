package com.radonverdict.config;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.net.URI;
import java.util.Set;

@Component
public class SameOriginMutationFilter extends OncePerRequestFilter {
    private static final Set<String> MUTATING_METHODS = Set.of("POST", "PUT", "PATCH", "DELETE");
    private final String allowedOrigin;

    public SameOriginMutationFilter(@Value("${app.site.base-url:https://radonverdict.com}") String baseUrl) {
        URI uri = URI.create(baseUrl);
        this.allowedOrigin = uri.getScheme() + "://" + uri.getAuthority();
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
            throws ServletException, IOException {
        if (MUTATING_METHODS.contains(request.getMethod())) {
            String fetchSite = request.getHeader("Sec-Fetch-Site");
            String origin = request.getHeader("Origin");
            boolean crossSite = "cross-site".equalsIgnoreCase(fetchSite);
            boolean wrongOrigin = origin != null && !origin.isBlank() && !"null".equalsIgnoreCase(origin)
                    && !allowedOrigin.equalsIgnoreCase(origin)
                    && !matchesRequestOrigin(origin, request);
            if (crossSite || wrongOrigin) {
                response.setHeader("X-RadonVerdict-Blocked-By", crossSite ? "fetch-site" : "origin");
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Cross-site mutation rejected");
                return;
            }
        }
        chain.doFilter(request, response);
    }

    private boolean matchesRequestOrigin(String origin, HttpServletRequest request) {
        try {
            URI parsed = URI.create(origin);
            String host = request.getHeader("Host");
            return parsed.getScheme() != null
                    && parsed.getScheme().equalsIgnoreCase(request.getScheme())
                    && parsed.getAuthority() != null
                    && parsed.getAuthority().equalsIgnoreCase(host);
        } catch (IllegalArgumentException exception) {
            return false;
        }
    }
}
