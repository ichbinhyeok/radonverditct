package com.radonverdict.model.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class QuoteLedgerBenchmarkRow {
    private String marketLabel;
    private String stateAbbr;
    private String countySlug;
    private String foundationLabel;
    private String resultBandLabel;
    private int signalCount;
    private int pricedSignalCount;
    private String priceRangeDisplay;
    private String medianPriceDisplay;
    private String confidenceLabel;
}
