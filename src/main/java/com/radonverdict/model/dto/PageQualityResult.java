package com.radonverdict.model.dto;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class PageQualityResult {
    private int score;
    private boolean indexable;
    private List<String> reasons;
}
