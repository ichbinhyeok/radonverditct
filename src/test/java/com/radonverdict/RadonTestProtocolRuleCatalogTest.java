package com.radonverdict;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;

import java.io.InputStream;
import java.util.HashSet;
import java.util.Set;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertTrue;

class RadonTestProtocolRuleCatalogTest {

    private final ObjectMapper objectMapper = new ObjectMapper();

    @Test
    void everyRuleHasAUniqueIdSupportedSeverityAndResolvableOfficialSource() throws Exception {
        try (InputStream input = getClass().getResourceAsStream("/static/data/radon-test-protocol-rules.json")) {
            assertNotNull(input, "rule catalog must be packaged as a public static resource");
            JsonNode catalog = objectMapper.readTree(input);
            assertFalse(catalog.path("catalogVersion").asText().isBlank());
            assertTrue(catalog.path("reviewedOn").asText().matches("\\d{4}-\\d{2}-\\d{2}"));

            Set<String> sourceIds = new HashSet<>();
            catalog.path("sources").fieldNames().forEachRemaining(sourceIds::add);
            assertFalse(sourceIds.isEmpty());
            catalog.path("sources").forEach(source -> {
                assertTrue(source.path("url").asText().startsWith("https://www.cdc.gov/")
                                || source.path("url").asText().startsWith("https://www.epa.gov/"),
                        "only CDC or EPA sources are allowed in this catalog");
                assertFalse(source.path("publishedOn").asText().isBlank());
            });

            Set<String> ruleIds = new HashSet<>();
            catalog.path("rules").forEach(rule -> {
                assertTrue(ruleIds.add(rule.path("id").asText()), "rule ids must be unique");
                assertTrue(Set.of("caution", "retest").contains(rule.path("severity").asText()));
                assertFalse(rule.path("conditions").isEmpty());
                assertFalse(rule.path("message").asText().isBlank());
                assertFalse(rule.path("action").asText().isBlank());
                assertFalse(rule.path("sourceIds").isEmpty());
                rule.path("sourceIds").forEach(sourceId ->
                        assertTrue(sourceIds.contains(sourceId.asText()), "rule source id must resolve"));
            });
            assertTrue(ruleIds.contains("SHORT_TERM_UNDER_48_HOURS"));
            assertTrue(ruleIds.contains("LONG_TERM_NOT_OVER_90_DAYS"));
            assertTrue(ruleIds.contains("TRANSACTION_SHORT_CLOSED_HOUSE_NO"));
        }
    }
}
