package com.radonverdict.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.factory.PasswordEncoderFactories;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;
import static org.springframework.security.config.Customizer.withDefaults;

import java.util.UUID;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public UserDetailsService userDetailsService(
            @Value("${spring.security.user.name:admin}") String username,
            @Value("${spring.security.user.password:}") String password) {
        PasswordEncoder passwordEncoder = PasswordEncoderFactories.createDelegatingPasswordEncoder();
        String effectivePassword = password == null || password.isBlank()
                ? UUID.randomUUID().toString()
                : password;
        UserDetails adminUser = User.withUsername(username)
                .password(passwordEncoder.encode(effectivePassword))
                .roles("ADMIN")
                .build();
        return new InMemoryUserDetailsManager(adminUser);
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf.ignoringRequestMatchers(
                        "/api/telemetry/**",
                        "/submit-lead",
                        "/contact",
                        "/search-zip",
                        "/search-zip-credit",
                        "/htmx/**",
                        "/plan/share",
                        "/radon-quote-ledger"))
                .authorizeHttpRequests(authz -> authz
                        .requestMatchers("/admin/**").authenticated() // Protect /admin URLs
                        .anyRequest().permitAll() // Allow everything else
                )
                .headers(headers -> headers.cacheControl(cache -> cache.disable()))
                .httpBasic(withDefaults()); // Enable Basic Authentication

        return http.build();
    }
}
