package com.radonverdict.model.dto;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class SimilarityAssessment {
    private int uniquenessScore;
    private int cohortSize;
    private String fingerprint;
    private List<String> reasons;
}
