package com.radonverdict.service;

import com.radonverdict.model.County;
import com.radonverdict.model.CountyRadonMeasurement;
import com.radonverdict.model.CountyStats;
import com.radonverdict.model.ReferenceSource;
import com.radonverdict.model.StateRegulations;
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
            addCountyStatsSources(sourceLinks, stats);
        }

        if (sourceLinks.isEmpty() && dataLoadService.getReferenceSources() != null) {
            for (ReferenceSource source : dataLoadService.getReferenceSources().stream().limit(3).toList()) {
                addSource(sourceLinks, source.getName(), source.getUrl(), source.getRetrievedAt());
            }
        }

        return baseBuilder()
                .dataRetrievedAt(dataRetrievedAt)
                .sources(sourceLinks)
                .build();
    }

    public TrustMetadata forRadonLevelsCountyPage(County county) {
        List<TrustMetadata.SourceLink> sourceLinks = new ArrayList<>();
        String dataRetrievedAt = null;

        addReferenceSourceById(sourceLinks, "epa_radon_zones");
        addReferenceSourceById(sourceLinks, "epa_citizens_guide");
        addReferenceSourceById(sourceLinks, "cdc_radon_testing");

        CountyRadonMeasurement measurement = county != null
                ? dataLoadService.getRadonMeasurementByFipsMap().get(county.getFips())
                : null;
        if (measurement != null) {
            addSource(sourceLinks, measurement.getSourceName(), measurement.getSourceUrl(), measurement.getRetrievedAt());
        }

        StateRegulations.StateRule stateRule = resolveStateRule(county);
        if (stateRule != null && stateRule.getStateProgramUrl() != null && !stateRule.getStateProgramUrl().isBlank()) {
            String stateName = county != null ? county.getStateAbbr() : "State";
            addSource(sourceLinks, "Official " + stateName + " radon program", stateRule.getStateProgramUrl(), null);
        }

        if (county != null && county.getStats() != null) {
            dataRetrievedAt = county.getStats().getRetrievedAt();
            addCountyStatsSources(sourceLinks, county.getStats());
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
                addSource(sourceLinks, source.getName(), source.getUrl(), source.getRetrievedAt());
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

    private void addCountyStatsSources(List<TrustMetadata.SourceLink> sourceLinks, CountyStats stats) {
        if (stats == null || stats.getSources() == null) {
            return;
        }

        for (CountyStats.Source source : stats.getSources()) {
            addSource(sourceLinks, source.getName(), source.getUrl(), source.getRetrievedAt());
        }
    }

    private void addReferenceSourceById(List<TrustMetadata.SourceLink> sourceLinks, String id) {
        if (id == null || dataLoadService.getReferenceSources() == null) {
            return;
        }

        dataLoadService.getReferenceSources().stream()
                .filter(source -> id.equals(source.getId()))
                .findFirst()
                .ifPresent(source -> addSource(sourceLinks, source.getName(), source.getUrl(), source.getRetrievedAt()));
    }

    private void addSource(List<TrustMetadata.SourceLink> sourceLinks, String name, String url, String retrievedAt) {
        if (name == null || name.isBlank() || url == null || url.isBlank()) {
            return;
        }

        boolean alreadyAdded = sourceLinks.stream().anyMatch(source -> url.equals(source.getUrl()));
        if (alreadyAdded) {
            return;
        }

        sourceLinks.add(TrustMetadata.SourceLink.builder()
                .name(name)
                .url(url)
                .retrievedAt(retrievedAt)
                .build());
    }

    private StateRegulations.StateRule resolveStateRule(County county) {
        if (county == null || county.getStateAbbr() == null || dataLoadService.getStateRegulations() == null) {
            return null;
        }

        StateRegulations regulations = dataLoadService.getStateRegulations();
        return regulations.getStateRules().getOrDefault(
                county.getStateAbbr().toUpperCase(),
                regulations.getDefaultStateRule());
    }
}
