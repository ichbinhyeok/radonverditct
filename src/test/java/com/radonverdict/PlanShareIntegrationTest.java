package com.radonverdict;

import com.radonverdict.model.entity.PlanShare;
import com.radonverdict.repository.PlanShareRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.servlet.MockMvc;

import java.nio.file.Files;
import java.nio.file.Path;
import java.security.MessageDigest;
import java.time.Instant;
import java.util.HexFormat;

import static org.assertj.core.api.Assertions.assertThat;
import static org.hamcrest.Matchers.containsString;
import static org.hamcrest.Matchers.not;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.header;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest(properties = {
        "app.site.enforce-canonical-host=false",
        "app.storage.product-events-csv-path=build/tmp/plan-share/product_events.csv"
})
@AutoConfigureMockMvc
class PlanShareIntegrationTest {
    private static final Path EVENTS = Path.of("build", "tmp", "plan-share", "product_events.csv");

    @Autowired MockMvc mockMvc;
    @Autowired PlanShareRepository repository;

    @BeforeEach
    void reset() throws Exception {
        repository.deleteAll();
        Files.deleteIfExists(EVENTS);
    }

    @Test
    void createsOpaquePrivateShareAndPreservesSnapshot() throws Exception {
        String location = mockMvc.perform(post("/plan/share")
                        .param("zipCode", "22030")
                        .param("radonReading", "5.8")
                        .param("intent", "buying"))
                .andExpect(status().isSeeOther())
                .andReturn().getResponse().getRedirectedUrl();

        assertThat(location).matches("/plan/share/[A-Za-z0-9_-]{43}");
        PlanShare stored = repository.findAll().getFirst();
        assertThat(stored.getTokenHash()).hasSize(64);
        assertThat(stored.getSnapshotJson()).doesNotContain(location.substring(location.lastIndexOf('/') + 1));
        assertThat(stored.getSnapshotJson()).doesNotContain("email", "phone", "street", "inspection report");

        mockMvc.perform(get(location))
                .andExpect(status().isOk())
                .andExpect(header().string("X-Robots-Tag", "noindex, noarchive, nofollow"))
                .andExpect(header().string("Cache-Control", "private, no-store"))
                .andExpect(header().string("Referrer-Policy", "no-referrer"))
                .andExpect(content().string(containsString("At or above the EPA action level")))
                .andExpect(content().string(containsString("Private read-only handoff")))
                .andExpect(content().string(not(containsString("22030"))));
    }

    @Test
    void rejectsInvalidReadingAndCrossSiteMutation() throws Exception {
        mockMvc.perform(post("/plan/share")
                        .param("zipCode", "22030")
                        .param("radonReading", "not-a-number")
                        .param("intent", "buying"))
                .andExpect(status().isOk())
                .andExpect(content().string(containsString("Correct the result before creating a share link")));
        assertThat(repository.count()).isZero();

        mockMvc.perform(post("/plan/share")
                        .header("Origin", "https://evil.example")
                        .header("Sec-Fetch-Site", "cross-site")
                        .param("zipCode", "22030")
                        .param("radonReading", "5.8")
                        .param("intent", "buying"))
                .andExpect(status().isForbidden());
    }

    @Test
    void telemetryDropsDirectIdentifiers() throws Exception {
        mockMvc.perform(post("/api/telemetry/events")
                        .contentType("application/json")
                        .content("""
                                {"event":"plan_completed","path":"/plan?zipCode=22030","email":"person@example.com","ip_address":"203.0.113.5","result_band":"above_4"}
                                """))
                .andExpect(status().isNoContent());

        String events = Files.readString(EVENTS);
        assertThat(events).contains("plan_completed", "above_4");
        assertThat(events).doesNotContain("person@example.com", "203.0.113.5", "22030", "IpAddress", "UserAgent");
    }

    @Test
    void telemetryNeverStoresAPrivateShareToken() throws Exception {
        String location = createShare();
        String token = location.substring(location.lastIndexOf('/') + 1);
        mockMvc.perform(post("/api/telemetry/events")
                        .contentType("application/json")
                        .content("""
                                {"event":"plan_completed","path":"%s","payload":{"schema_version":1,"result_band":"above_4","note":"%s"}}
                                """.formatted(location, token)))
                .andExpect(status().isNoContent());
        String events = Files.readString(EVENTS);
        assertThat(events).doesNotContain(token);
        assertThat(events).contains("/plan/share/:token");
    }

    @Test
    void rejectsTamperedExpiredAndRevokedLinks() throws Exception {
        String location = createShare();
        String token = location.substring(location.lastIndexOf('/') + 1);
        String tampered = token.substring(0, 42) + (token.endsWith("A") ? "B" : "A");
        mockMvc.perform(get("/plan/share/" + tampered)).andExpect(status().isNotFound());

        PlanShare original = repository.findAll().getFirst();
        repository.deleteAll();
        repository.save(PlanShare.builder()
                .tokenHash(sha256(token))
                .snapshotJson(original.getSnapshotJson())
                .createdAt(original.getCreatedAt())
                .expiresAt(Instant.now().minusSeconds(1))
                .build());
        mockMvc.perform(get(location)).andExpect(status().isGone());

        repository.deleteAll();
        repository.save(PlanShare.builder()
                .tokenHash(sha256(token))
                .snapshotJson(original.getSnapshotJson())
                .createdAt(original.getCreatedAt())
                .expiresAt(Instant.now().plusSeconds(3600))
                .revoked(true)
                .build());
        mockMvc.perform(get(location)).andExpect(status().isGone());
    }

    private String createShare() throws Exception {
        return mockMvc.perform(post("/plan/share")
                        .param("zipCode", "22030")
                        .param("radonReading", "5.8")
                        .param("intent", "buying"))
                .andExpect(status().isSeeOther())
                .andReturn().getResponse().getRedirectedUrl();
    }

    private String sha256(String token) throws Exception {
        return HexFormat.of().formatHex(MessageDigest.getInstance("SHA-256")
                .digest(token.getBytes(java.nio.charset.StandardCharsets.UTF_8)));
    }
}
