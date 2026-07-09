package com.radonverdict.model.dto;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class SearchConsoleCohortReport {
    private boolean exportAvailable;
    private String exportPath;
    private int exportedUrlCount;
    private String summary;
    private List<CohortRow> cohortRows;
    private List<RecommendedInspectionRow> recommendedInspectionRows;

    @Data
    @Builder
    public static class CohortRow {
        private String cohort;
        private String sitemapUrl;
        private int expectedUrlCount;
        private int seenInExportCount;
        private int indexedCount;
        private int crawledNotIndexedCount;
        private int discoveredNotIndexedCount;
        private int otherNotIndexedCount;
        private String action;
    }

    @Data
    @Builder
    public static class RecommendedInspectionRow {
        private String url;
        private String cohort;
        private String status;
        private String reason;
    }
}
