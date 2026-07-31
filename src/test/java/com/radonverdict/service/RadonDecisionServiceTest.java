package com.radonverdict.service;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import org.junit.jupiter.params.provider.NullAndEmptySource;
import org.junit.jupiter.params.provider.ValueSource;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertNull;

class RadonDecisionServiceTest {
    private final RadonDecisionService service = new RadonDecisionService();

    @ParameterizedTest
    @NullAndEmptySource
    @ValueSource(strings = {" ", "\t"})
    void missingReadingIsNotTested(String reading) {
        var decision = service.decide(reading, false, "homeowner");
        assertEquals("not_tested", decision.resultBand());
        assertNull(decision.validationError());
    }

    @ParameterizedTest
    @ValueSource(strings = {"abc", "-1", "NaN", "Infinity", "4..0", "1,5", "999999"})
    void invalidReadingNeverBecomesElevated(String reading) {
        var decision = service.decide(reading, false, "homeowner");
        assertEquals("invalid", decision.resultBand());
        assertNotNull(decision.validationError());
    }

    @ParameterizedTest
    @CsvSource({
            "0,under_2",
            "1.99,under_2",
            "2.0,between_2_and_4",
            "3.99,between_2_and_4",
            "4.0,above_4",
            "99.99,above_4",
            "999,above_4"
    })
    void boundariesFollowTheDecisionContract(String reading, String expectedBand) {
        var decision = service.decide(reading, false, "homeowner");
        assertEquals(expectedBand, decision.resultBand());
        assertNull(decision.validationError());
    }

    @Test
    void explicitNoTestOverridesAStaleReading() {
        assertEquals("not_tested", service.decide("5.5", true, "buying").resultBand());
    }
}
