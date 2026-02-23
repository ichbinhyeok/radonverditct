package com.radonverdict.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;
import static org.springframework.security.config.Customizer.withDefaults;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf.disable()) // Disable CSRF for simple MVP compatibility
                .authorizeHttpRequests(authz -> authz
                        .requestMatchers("/admin/**").authenticated() // Protect /admin URLs
                        .anyRequest().permitAll() // Allow everything else
                )
                .httpBasic(withDefaults()); // Enable Basic Authentication

        return http.build();
    }
}
