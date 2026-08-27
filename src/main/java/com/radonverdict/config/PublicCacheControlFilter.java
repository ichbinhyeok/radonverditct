package com.radonverdict.config;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

/**
 * Replaces Spring Security's blanket no-store policy with cache rules that
 * distinguish public SEO documents and assets from private application data.
 */
@Component
@Order(Ordered.HIGHEST_PRECEDENCE + 20)
public class PublicCacheControlFilter extends OncePerRequestFilter {

    @Override
    protected void doFilterInternal(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain) throws ServletException, IOException {
        String method = request.getMethod();
        if ("GET".equals(method) || "HEAD".equals(method)) {
            response.setHeader("Cache-Control", cachePolicy(request.getRequestURI()));
        }
        filterChain.doFilter(request, response);
    }

    private String cachePolicy(String path) {
        if (path == null) {
            return "public, max-age=0, must-revalidate";
        }
        if (path.startsWith("/admin")
                || path.startsWith("/api/")
                || path.startsWith("/plan")
                || path.startsWith("/shared-plan")
                || path.startsWith("/client-action-plan")) {
            return "private, no-store";
        }
        if (path.startsWith("/css/")
                || path.startsWith("/js/")
                || path.startsWith("/images/")
                || path.equals("/favicon.svg")) {
            return "public, max-age=86400, stale-while-revalidate=604800";
        }
        if (path.equals("/robots.txt") || path.contains("sitemap")) {
            return "public, max-age=3600, must-revalidate";
        }
        return "public, max-age=0, must-revalidate";
    }
}
