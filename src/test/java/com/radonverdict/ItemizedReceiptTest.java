package com.radonverdict;

import com.radonverdict.model.dto.ItemizedReceipt;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

class ItemizedReceiptTest {

    @Test
    void usesExplicitAreaDisplayNameWhenProvided() {
        ItemizedReceipt receipt = ItemizedReceipt.builder()
                .countyName("Falls Church")
                .areaDisplayName("Falls Church")
                .stateAbbr("VA")
                .build();

        assertThat(receipt.getAreaDisplayName()).isEqualTo("Falls Church");
    }

    @Test
    void fallsBackToCountyFormattingWhenDisplayNameMissing() {
        ItemizedReceipt receipt = ItemizedReceipt.builder()
                .countyName("Fairfax")
                .stateAbbr("VA")
                .build();

        assertThat(receipt.getAreaDisplayName()).isEqualTo("Fairfax County");
    }
}
