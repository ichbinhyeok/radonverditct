package com.radonverdict.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

@Data
public class CountyRadonMeasurement {
    @JsonProperty("county_fips")
    private String countyFips;

    @JsonProperty("state_abbr")
    private String stateAbbr;

    @JsonProperty("county_name")
    private String countyName;

    @JsonProperty("source_id")
    private String sourceId;

    @JsonProperty("source_name")
    private String sourceName;

    @JsonProperty("source_url")
    private String sourceUrl;

    @JsonProperty("period")
    private String period;

    @JsonProperty("retrieved_at")
    private String retrievedAt;

    @JsonProperty("caveat")
    private String caveat;

    @JsonProperty("metrics")
    private Metrics metrics;

    @Data
    public static class Metrics {
        @JsonProperty("total_tests")
        private Double totalTests;

        @JsonProperty("average_number_of_tests")
        private Double averageNumberOfTests;

        @JsonProperty("number_buildings_tested_10_year")
        private Double numberBuildingsTested10Year;

        @JsonProperty("average_test_result_pci_l")
        private Double averageTestResultPciL;

        @JsonProperty("maximum_test_result_pci_l")
        private Double maximumTestResultPciL;

        @JsonProperty("basement_test_count")
        private Double basementTestCount;

        @JsonProperty("basement_average_test_result_pci_l")
        private Double basementAverageTestResultPciL;

        @JsonProperty("basement_maximum_test_result_pci_l")
        private Double basementMaximumTestResultPciL;

        @JsonProperty("first_floor_test_count")
        private Double firstFloorTestCount;

        @JsonProperty("first_floor_average_test_result_pci_l")
        private Double firstFloorAverageTestResultPciL;

        @JsonProperty("first_floor_maximum_test_result_pci_l")
        private Double firstFloorMaximumTestResultPciL;

        @JsonProperty("radon_95th_percentile_pci_l")
        private Double radon95thPercentilePciL;

        @JsonProperty("median_radon_value_pci_l")
        private Double medianRadonValuePciL;

        @JsonProperty("geometric_mean_radon_value_pci_l")
        private Double geometricMeanRadonValuePciL;

        @JsonProperty("arithmetic_mean_radon_value_pci_l")
        private Double arithmeticMeanRadonValuePciL;

        @JsonProperty("percent_houses_tested")
        private Double percentHousesTested;

        @JsonProperty("average_annual_properties_tested_per_10000")
        private Double averageAnnualPropertiesTestedPer10000;

        @JsonProperty("rate_housing_units_tested_per_10000")
        private Double rateHousingUnitsTestedPer10000;

        @JsonProperty("number_properties_at_or_above_2_pci_l")
        private Double numberPropertiesAtOrAbove2PciL;

        @JsonProperty("number_properties_at_or_above_4_pci_l")
        private Double numberPropertiesAtOrAbove4PciL;

        @JsonProperty("number_pre_mitigation_tests_at_or_above_4_pci_l")
        private Double numberPreMitigationTestsAtOrAbove4PciL;

        @JsonProperty("percent_tests_below_2_pci_l")
        private Double percentTestsBelow2PciL;

        @JsonProperty("percent_tests_at_or_above_2_pci_l")
        private Double percentTestsAtOrAbove2PciL;

        @JsonProperty("percent_tests_2_to_below_4_pci_l")
        private Double percentTests2ToBelow4PciL;

        @JsonProperty("percent_tests_at_or_above_4_pci_l")
        private Double percentTestsAtOrAbove4PciL;

        @JsonProperty("unstable_average_annual_properties_tested")
        private Boolean unstableAverageAnnualPropertiesTested;

        @JsonProperty("unstable_percent_at_or_above_2_pci_l")
        private Boolean unstablePercentAtOrAbove2PciL;

        @JsonProperty("unstable_percent_at_or_above_4_pci_l")
        private Boolean unstablePercentAtOrAbove4PciL;

        @JsonProperty("vdh_average_suppressed_below_25_tests")
        private Boolean vdhAverageSuppressedBelow25Tests;

        @JsonProperty("percent_tests_basement")
        private Double percentTestsBasement;

        @JsonProperty("percent_tests_first_floor")
        private Double percentTestsFirstFloor;

        @JsonProperty("percent_tests_other_floors")
        private Double percentTestsOtherFloors;
    }
}
