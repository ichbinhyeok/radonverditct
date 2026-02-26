package com.radonverdict.model.dto;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class AeoAnswerBlock {
    private String question;
    private String directAnswer;
    private List<Row> evidenceRows;
    private List<TrustMetadata.SourceLink> sources;

    @Data
    @Builder
    public static class Row {
        private String label;
        private String value;
    }
}
