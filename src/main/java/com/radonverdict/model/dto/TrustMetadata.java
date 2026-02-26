package com.radonverdict.model.dto;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class TrustMetadata {
    private String authorName;
    private String authorRole;
    private String reviewerName;
    private String reviewerRole;
    private String lastReviewed;
    private String dataRetrievedAt;
    private List<SourceLink> sources;

    @Data
    @Builder
    public static class SourceLink {
        private String name;
        private String url;
        private String retrievedAt;
    }
}
