package com.radonverdict.model.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class SearchDemandProfile {
    private String path;
    private String primaryQuery;
    private String intent;
    private int queryCount;
    private double clicks;
    private double impressions;
    private double averagePosition;
    private double ctr;
    private double opportunityScore;
    private double strikingDistanceScore;
    private double ctrGapScore;
    private String recommendedAction;
}
