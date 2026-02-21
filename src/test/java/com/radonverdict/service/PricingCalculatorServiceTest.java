package com.radonverdict.service;

import com.radonverdict.model.PricingConfig;
import com.radonverdict.model.dto.ItemizedReceipt;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;

import java.util.HashMap;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.when;

class PricingCalculatorServiceTest {

    private DataLoadService dataLoadService;
    private PricingCalculatorService pricingService;

    @BeforeEach
    void setUp() {
        dataLoadService = Mockito.mock(DataLoadService.class);
        pricingService = new PricingCalculatorService(dataLoadService);

        // Mock PricingConfig
        PricingConfig config = new PricingConfig();

        PricingConfig.BaseComponents baseCmd = new PricingConfig.BaseComponents();

        PricingConfig.Range matRange = new PricingConfig.Range();
        matRange.setLow(300);
        matRange.setHigh(500);
        baseCmd.setMaterials(matRange);

        PricingConfig.Range permitRange = new PricingConfig.Range();
        permitRange.setLow(100);
        permitRange.setHigh(200);
        baseCmd.setPermitsSetup(permitRange);
        config.setBaseComponents(baseCmd);

        PricingConfig.Range laborBase = new PricingConfig.Range();
        laborBase.setLow(400);
        laborBase.setHigh(600);
        config.setLaborBase(laborBase);

        Map<String, PricingConfig.Range> foundationMod = new HashMap<>();
        PricingConfig.Range slabMod = new PricingConfig.Range();
        slabMod.setLow(50);
        slabMod.setHigh(150);
        foundationMod.put("slab", slabMod);
        config.setFoundationLaborModifiers(foundationMod);

        Map<String, Double> multipliers = new HashMap<>();
        multipliers.put("NY", 1.25);
        multipliers.put("AL", 0.85);
        config.setRegionalMultipliers(multipliers);
        config.setDefaultMultiplier(1.0);

        PricingConfig.SanityBounds bounds = new PricingConfig.SanityBounds();
        bounds.setMinTotal(600);
        bounds.setMaxTotal(4000);
        config.setSanityBounds(bounds);

        when(dataLoadService.getPricingConfig()).thenReturn(config);
    }

    @Test
    void testItemizedCostCalculationWithRegionalMultiplier() {
        // NY (1.25 multiplier)
        ItemizedReceipt receiptNY = pricingService.calculate("NY", "New York", "slab", "buying");

        assertEquals(300, receiptNY.getMaterialsLow());
        assertEquals(500, receiptNY.getMaterialsHigh());
        assertEquals(100, receiptNY.getPermitsSetupLow());

        // Labor Base(400) + Slab(50) = 450 * 1.25 = 562.5 -> 563
        assertEquals(563, receiptNY.getLaborLow());

        // Total Base = 300(mat) + 100(permit) + 563(lab) = 963
        assertEquals(963, receiptNY.getTotalLow());

        // Total Avg check
        assertTrue(receiptNY.getTotalAvg() > 0);
    }

    @Test
    void testNoZonePricingGuarantee() {
        // Guarantee: Changing the county (Zone 1 vs 3) but keeping the state the same
        // yields identical pricing.
        ItemizedReceipt receiptZone1 = pricingService.calculate("AL", "HighRisk County", "slab", "homeowner");
        ItemizedReceipt receiptZone3 = pricingService.calculate("AL", "LowRisk County", "slab", "homeowner");

        assertEquals(receiptZone1.getTotalAvg(), receiptZone3.getTotalAvg(),
                "Pricing must be identical regardless of Zone context");
        assertEquals(receiptZone1.getLaborHigh(), receiptZone3.getLaborHigh());
    }
}
