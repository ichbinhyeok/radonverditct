package com.radonverdict.config;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.net.URI;
import java.util.Locale;

@Component
@Order(Ordered.HIGHEST_PRECEDENCE)
public class CanonicalUrlRedirectFilter extends OncePerRequestFilter {

    private final URI canonicalBaseUri;
    private final boolean enforceCanonicalHost;

    public CanonicalUrlRedirectFilter(
            @Value("${app.site.base-url:https://radonverdict.com}") String baseUrl,
            @Value("${app.site.enforce-canonical-host:true}") boolean enforceCanonicalHost) {
        this.canonicalBaseUri = URI.create(baseUrl.endsWith("/") ? baseUrl.substring(0, baseUrl.length() - 1) : baseUrl);
        this.enforceCanonicalHost = enforceCanonicalHost;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        if (!enforceCanonicalHost || !isSafeMethod(request.getMethod())) {
            filterChain.doFilter(request, response);
            return;
        }

        String canonicalScheme = canonicalBaseUri.getScheme() == null ? "https"
                : canonicalBaseUri.getScheme().toLowerCase(Locale.ROOT);
        String canonicalHost = canonicalBaseUri.getHost() == null ? "radonverdict.com"
                : canonicalBaseUri.getHost().toLowerCase(Locale.ROOT);

        String forwardedProto = firstHeaderValue(request.getHeader("X-Forwarded-Proto"));
        String currentScheme = (forwardedProto == null || forwardedProto.isBlank())
                ? request.getScheme()
                : forwardedProto;

        String forwardedHost = firstHeaderValue(request.getHeader("X-Forwarded-Host"));
        String currentHost = (forwardedHost == null || forwardedHost.isBlank())
                ? request.getServerName()
                : forwardedHost;

        String normalizedCurrentHost = stripPort(currentHost).toLowerCase(Locale.ROOT);
        boolean localHost = isLocalHost(normalizedCurrentHost);
        boolean needsSchemeRedirect = !canonicalScheme.equalsIgnoreCase(currentScheme);
        boolean needsHostRedirect = !canonicalHost.equalsIgnoreCase(normalizedCurrentHost);

        if (!localHost && (needsSchemeRedirect || needsHostRedirect)) {
            StringBuilder target = new StringBuilder();
            target.append(canonicalScheme).append("://").append(canonicalHost);
            if (canonicalBaseUri.getPort() != -1) {
                target.append(':').append(canonicalBaseUri.getPort());
            }
            target.append(request.getRequestURI());
            if (request.getQueryString() != null && !request.getQueryString().isBlank()) {
                target.append('?').append(request.getQueryString());
            }

            response.setStatus(HttpServletResponse.SC_MOVED_PERMANENTLY);
            response.setHeader("Location", target.toString());
            return;
        }

        filterChain.doFilter(request, response);
    }

    private boolean isSafeMethod(String method) {
        return "GET".equalsIgnoreCase(method) || "HEAD".equalsIgnoreCase(method);
    }

    private String firstHeaderValue(String value) {
        if (value == null) {
            return null;
        }
        int comma = value.indexOf(',');
        if (comma < 0) {
            return value.trim();
        }
        return value.substring(0, comma).trim();
    }

    private String stripPort(String host) {
        int idx = host.indexOf(':');
        if (idx < 0) {
            return host;
        }
        return host.substring(0, idx);
    }

    private boolean isLocalHost(String host) {
        return "localhost".equalsIgnoreCase(host)
                || "127.0.0.1".equals(host)
                || host.endsWith(".local");
    }
}
