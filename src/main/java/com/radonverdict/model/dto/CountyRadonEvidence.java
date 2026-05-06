package com.radonverdict.model.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class CountyRadonEvidence {
    private boolean measurementBacked;
    private String riskBand;
    private String riskTone;
    private String confidenceLabel;
    private int confidenceScore;
    private String confidenceSummary;
    private String decisionHeadline;
    private String whyThisPageExists;
    private String localDecisionSummary;
    private String realEstateDecisionSummary;
    private String retestTriggerSummary;
    private String measuredBurdenSummary;
    private String stateComparisonSummary;
    private String recommendedAction;
    private String intentQuestion;
    private String intentAnswer;
    private String intentLabel;
    private String noReadingAction;
    private String borderlineAction;
    private String elevatedAction;
    private String sourceCoverageSummary;
    private String averagePercentileDisplay;
    private String above4PercentileDisplay;
    private String highEndPercentileDisplay;
    private String testVolumePercentileDisplay;
    private String comparisonPeerCountDisplay;
    private String primaryAverageDisplay;
    private String medianDisplay;
    private String above4Display;
    private String highEndDisplay;
    private String testVolumeDisplay;
}
