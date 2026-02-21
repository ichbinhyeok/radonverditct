package com.radonverdict.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.radonverdict.model.*;
import com.radonverdict.model.dto.EpaZoneDto;
import com.radonverdict.model.dto.GeoCountyDto;
import jakarta.annotation.PostConstruct;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class DataLoadService {

    private final ObjectMapper objectMapper;

    // In-memory repositories
    @Getter
    private Map<String, County> countByFipsMap = new HashMap<>();
    @Getter
    private Map<String, County> countyBySlugMap = new HashMap<>(); // key: stateSlug/countySlug
    @Getter
    private Map<String, String> zipToFipsMap = new HashMap<>();
    @Getter
    private List<ReferenceSource> referenceSources;
    @Getter
    private PricingConfig pricingConfig;
    @Getter
    private ContentTemplates contentTemplates;
    @Getter
    private StateRegulations stateRegulations;
    @Getter
    private FaqTemplates faqTemplates;

    @PostConstruct
    public void init() {
        log.info("Starting in-memory data load...");

        try {
            // 1. Load GeoCounties
            List<GeoCountyDto> geoCounties = readJson("data/geo_counties.json",
                    new TypeReference<List<GeoCountyDto>>() {
                    });
            log.info("Loaded {} GeoCounties", geoCounties.size());

            // 2. Load EPA Zones
            List<EpaZoneDto> epaZones = readJson("data/epa_county_radon_zones.json",
                    new TypeReference<List<EpaZoneDto>>() {
                    });
            Map<String, EpaZoneDto> epaZoneMap = new HashMap<>();
            epaZones.forEach(z -> epaZoneMap.put(z.getFips(), z));
            log.info("Loaded {} EPA Zones", epaZones.size());

            // 3. Merge into County map
            for (GeoCountyDto geo : geoCounties) {
                EpaZoneDto epa = epaZoneMap.get(geo.getFips());
                int zone = (epa != null) ? epa.getEpaZone() : 0;
                String zoneLabel = (epa != null) ? epa.getZoneLabel() : "Unknown";

                County county = County.builder()
                        .fips(geo.getFips())
                        .stateAbbr(geo.getStateAbbr())
                        .countyName(geo.getCountyName())
                        .stateSlug(geo.getStateSlug())
                        .countySlug(geo.getCountySlug())
                        .epaZone(zone)
                        .zoneLabel(zoneLabel)
                        .build();

                countByFipsMap.put(county.getFips(), county);
                String slugKey = county.getStateSlug() + "/" + county.getCountySlug();
                countyBySlugMap.put(slugKey, county);
            }
            log.info("Successfully merged {} County data objects", countByFipsMap.size());

            // 4. Load ZIP to FIPS Map
            zipToFipsMap = readJson("data/zip_primary_county.json", new TypeReference<Map<String, String>>() {
            });
            log.info("Loaded {} ZIP to FIPS mappings", zipToFipsMap.size());

            // 5. Load Sources
            referenceSources = readJson("data/reference_sources.json", new TypeReference<List<ReferenceSource>>() {
            });
            log.info("Loaded {} reference sources", referenceSources.size());

            // 6. Load Pricing Config
            pricingConfig = readJson("data/pricing_config.json", new TypeReference<PricingConfig>() {
            });
            log.info("Loaded pricing config. Default Multiplier: {}", pricingConfig.getDefaultMultiplier());

            // 7. Load Content Templates
            contentTemplates = readJson("data/content_templates.json", new TypeReference<ContentTemplates>() {
            });
            log.info("Loaded content templates: {} zones, {} foundations, {} intents",
                    contentTemplates.getZoneDescriptions().size(),
                    contentTemplates.getFoundationDescriptions().size(),
                    contentTemplates.getIntentContent().size());

            // 8. Load State Regulations
            stateRegulations = readJson("data/state_regulations.json", new TypeReference<StateRegulations>() {
            });
            log.info("Loaded state regulations for {} states", stateRegulations.getStateRules().size());

            // 9. Load FAQ Templates
            faqTemplates = readJson("data/faq_templates.json", new TypeReference<FaqTemplates>() {
            });
            log.info("Loaded FAQ templates: {} pools", faqTemplates.getFaqPool().size());

            log.info("In-memory data load complete.");

        } catch (Exception e) {
            log.error("Failed to load in-memory data on startup!", e);
            throw new RuntimeException("Startup Error: In-memory data load failed.", e);
        }
    }

    private <T> T readJson(String path, TypeReference<T> typeReference) throws IOException {
        InputStream is = new ClassPathResource(path).getInputStream();
        return objectMapper.readValue(is, typeReference);
    }
}
