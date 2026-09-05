package com.radonverdict.model.dto;

import java.util.List;

public record TestProtocolGuide(
        String slug,
        String title,
        String seoTitle,
        String description,
        String eyebrow,
        String category,
        String directAnswer,
        List<Section> sections,
        List<String> checklist,
        List<Faq> faqs,
        List<Source> sources,
        List<Related> related
) {
    public record Section(String id, String heading, List<String> paragraphs, List<String> points) {}
    public record Faq(String question, String answer) {}
    public record Source(String label, String publisher, String url, String scope) {}
    public record Related(String title, String url) {}
}
