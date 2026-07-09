package com.radonverdict.model.dto;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class QuoteLedgerBenchmarkSnapshot {
    private int totalSignalCount;
    private int pricedSignalCount;
    private int leadDerivedSignalCount;
    private int publicBenchmarkCount;
    private int stateCount;
    private int countyCount;
    private String freshnessLabel;
    private List<QuoteLedgerBenchmarkRow> rows;

    public boolean hasRows() {
        return rows != null && !rows.isEmpty();
    }
}
