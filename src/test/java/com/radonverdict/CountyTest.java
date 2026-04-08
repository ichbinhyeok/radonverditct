package com.radonverdict;

import com.radonverdict.model.County;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

class CountyTest {

    @Test
    void independentCitySlugsDoNotGetCountySuffix() {
        County county = County.builder()
                .countyName("Falls Church")
                .countySlug("falls-church-city")
                .build();

        assertThat(county.getAreaDisplayName()).isEqualTo("Falls Church");
        assertThat(county.getSeoDisplayName()).isEqualTo("Falls Church");
    }

    @Test
    void regularCountiesStillReceiveCountySuffix() {
        County county = County.builder()
                .countyName("Fairfax")
                .countySlug("fairfax-county")
                .build();

        assertThat(county.getAreaDisplayName()).isEqualTo("Fairfax County");
    }

    @Test
    void explicitCityNamesStayAsCities() {
        County county = County.builder()
                .countyName("Carson City")
                .countySlug("carson-city")
                .build();

        assertThat(county.getAreaDisplayName()).isEqualTo("Carson City");
        assertThat(county.getSeoDisplayName()).isEqualTo("Carson City");
    }
}
