package com.radonverdict.model;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

import java.util.List;
import java.util.Map;

@Data
public class FaqTemplates {

    @JsonProperty("faq_pool")
    private Map<String, List<FaqEntry>> faqPool;

    @Data
    public static class FaqEntry {
        private String question;
        private String answer;
    }
}
