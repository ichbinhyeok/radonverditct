package com.radonverdict;

import com.radonverdict.config.SecurityConfig;
import org.junit.jupiter.api.Test;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;

import static org.assertj.core.api.Assertions.assertThat;

class SecurityConfigTest {

    @Test
    void blankDeploymentCredentialsStillCreateASafeAdminPrincipal() {
        UserDetailsService users = new SecurityConfig().userDetailsService("", "");

        UserDetails admin = users.loadUserByUsername("admin");
        assertThat(admin.getUsername()).isEqualTo("admin");
        assertThat(admin.getPassword()).startsWith("{bcrypt}").doesNotContain("tlsgur3108");
        assertThat(admin.getAuthorities()).extracting("authority").containsExactly("ROLE_ADMIN");
    }
}
