package com.radonverdict.service;

import com.radonverdict.model.County;
import com.radonverdict.model.CountyStats;
import com.radonverdict.model.ReferenceSource;
import com.radonverdict.model.dto.TrustMetadata;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class TrustMetadataService {

    private final DataLoadService dataLoadService;

    @Value("${app.content.author-name:RadonVerdict Editorial Team}")
    private String authorName;

    @Value("${app.content.author-role:Data and Content Team}")
    private String authorRole;

    @Value("${app.content.reviewer-name:}")
    private String reviewerName;

    @Value("${app.content.reviewer-role:}")
    private String reviewerRole;

    @Value("${app.content.last-reviewed:}")
    private String configuredLastReviewed;

    public TrustMetadata forCountyPage(County county) {
        List<TrustMetadata.SourceLink> sourceLinks = new ArrayList<>();
        String dataRetrievedAt = null;

        if (county != null && county.getStats() != null) {
            CountyStats stats = county.getStats();
            dataRetrievedAt = stats.getRetrievedAt();
            if (stats.getSources() != null) {
                for (CountyStats.Source source : stats.getSources()) {
                    sourceLinks.add(TrustMetadata.SourceLink.builder()
                            .name(source.getName())
                            .url(source.getUrl())
                            .retrievedAt(source.getRetrievedAt())
                            .build());
                }
            }
        }

        if (sourceLinks.isEmpty() && dataLoadService.getReferenceSources() != null) {
            for (ReferenceSource source : dataLoadService.getReferenceSources().stream().limit(3).toList()) {
                sourceLinks.add(TrustMetadata.SourceLink.builder()
                        .name(source.getName())
                        .url(source.getUrl())
                        .retrievedAt(source.getRetrievedAt())
                        .build());
            }
        }

        return baseBuilder()
                .dataRetrievedAt(dataRetrievedAt)
                .sources(sourceLinks)
                .build();
    }

    public TrustMetadata forGuidePage() {
        List<TrustMetadata.SourceLink> sourceLinks = new ArrayList<>();
        if (dataLoadService.getReferenceSources() != null) {
            for (ReferenceSource source : dataLoadService.getReferenceSources().stream().limit(4).toList()) {
                sourceLinks.add(TrustMetadata.SourceLink.builder()
                        .name(source.getName())
                        .url(source.getUrl())
                        .retrievedAt(source.getRetrievedAt())
                        .build());
            }
        }

        return baseBuilder()
                .dataRetrievedAt(null)
                .sources(sourceLinks)
                .build();
    }

    private TrustMetadata.TrustMetadataBuilder baseBuilder() {
        String lastReviewed = (configuredLastReviewed != null && !configuredLastReviewed.isBlank())
                ? configuredLastReviewed
                : null;

        String normalizedReviewerName = (reviewerName != null && !reviewerName.isBlank()) ? reviewerName : null;
        String normalizedReviewerRole = (reviewerRole != null && !reviewerRole.isBlank()) ? reviewerRole : null;

        return TrustMetadata.builder()
                .authorName(authorName)
                .authorRole(authorRole)
                .reviewerName(normalizedReviewerName)
                .reviewerRole(normalizedReviewerName == null ? null : normalizedReviewerRole)
                .lastReviewed(lastReviewed);
    }
}
