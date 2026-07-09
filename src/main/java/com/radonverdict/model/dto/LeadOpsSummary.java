package com.radonverdict.model.dto;

import lombok.Builder;
import lombok.Data;

import java.math.BigDecimal;

@Data
@Builder
public class LeadOpsSummary {
    private int totalLeads;
    private int submittedCount;
    private int validCount;
    private int contactedCount;
    private int appointmentCount;
    private int soldCount;
    private int rejectedCount;
    private int refundCount;
    private int slaRiskCount;
    private BigDecimal expectedRevenue;
    private BigDecimal actualRevenue;
    private String nextBottleneck;
}
