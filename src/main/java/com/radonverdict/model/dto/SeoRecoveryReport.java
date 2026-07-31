package com.radonverdict.model.dto;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class SeoRecoveryReport {
    private boolean snapshotsAvailable;
    private int snapshotCount;
    private String latestSnapshotDate;
    private String priorSnapshotDate;
    private String summary;
    private List<RecoveryAction> actions;
    private List<ActivationBrief> activationBriefs;

    @Data
    @Builder
    public static class RecoveryAction {
        private String path;
        private String cohort;
        private String primaryQuery;
        private String indexingStatus;
        private String decision;
        private String reason;
        private String urgency;
        private double latestClicks;
        private double latestImpressions;
        private double latestCtr;
        private double latestPosition;
        private double clickChangePercent;
        private double impressionChangePercent;
    }

    @Data
    @Builder
    public static class ActivationBrief {
        private String path;
        private String primaryQuery;
        private String status;
        private String releaseReason;
        private String publicCitationUrl;
        private String evidenceClaim;
        private String claimBoundary;
        private String targetEditors;
        private String outreachSubject;
        private String outreachBody;
    }
}
