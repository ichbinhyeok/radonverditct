package com.radonverdict.model.dto;

import com.radonverdict.model.County;
import com.radonverdict.model.CountyRadonMeasurement;
import lombok.Builder;
import lombok.Getter;

import java.util.List;

@Getter
@Builder
public class RadonActionPlan {
    private String zipCode;
    private String rawReading;
    private String intent;
    private String intentLabel;
    private String source;
    private String resultBand;
    private String readingDisplay;
    private String verdictHeadline;
    private String interpretation;
    private List<String> actions;
    private String validationError;
    private String locationMessage;
    private County county;
    private CountyRadonEvidence evidence;
    private CountyRadonMeasurement measurement;

    public boolean hasValidationError() {
        return validationError != null;
    }

    public boolean hasCounty() {
        return county != null;
    }
}
