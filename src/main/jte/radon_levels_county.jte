@import com.radonverdict.model.County
@import com.radonverdict.model.CountyRadonMeasurement
@import com.radonverdict.model.StateRegulations.StateRule
@import com.radonverdict.model.dto.AeoAnswerBlock
@import com.radonverdict.model.dto.CountyRadonEvidence
@import com.radonverdict.model.dto.InternalLinkItem
@import com.radonverdict.model.dto.PageQualityResult
@import com.radonverdict.model.dto.TrustMetadata
@import com.radonverdict.util.JsonLdUtils
@import java.util.List

@param County county
@param StateRule stateRule = null
@param List<County> nearbyCounties = null
@param String canonicalUrl = null
@param boolean noindex = false
@param AeoAnswerBlock aeo = null
@param List relatedLinks = null
@param CountyRadonMeasurement radonMeasurement = null
@param CountyRadonEvidence radonEvidence = null
@param PageQualityResult quality = null
@param TrustMetadata trust = null
@param int stateHousingPercentile = 0
@param int stateOlderHomePercentile = 0
@param int statePeerCountyCount = 0
@param boolean priorityCounty = false
@param boolean searchTrafficCounty = false
@param boolean monetizationHooksEnabled = false
@param boolean showSeoDebug = false
!{
    final String seoCountyDisplay = county.getSeoDisplayName();
    final String seoPlaceLabel = seoCountyDisplay + ", " + county.getStateAbbr();
    String[] stateSlugParts = county.getStateSlug().split("-");
    StringBuilder stateNameBuilder = new StringBuilder();
    for (int i = 0; i < stateSlugParts.length; i++) {
        String part = stateSlugParts[i];
        if (part == null || part.isBlank()) {
            continue;
        }
        String normalized = part.toLowerCase(java.util.Locale.ROOT);
        String displayPart;
        if (i > 0 && ("of".equals(normalized) || "and".equals(normalized))) {
            displayPart = normalized;
        } else {
            displayPart = normalized.substring(0, 1).toUpperCase(java.util.Locale.ROOT) + normalized.substring(1);
        }
        if (stateNameBuilder.length() > 0) {
            stateNameBuilder.append(" ");
        }
        stateNameBuilder.append(displayPart);
    }
    final String stateName = stateNameBuilder.length() > 0 ? stateNameBuilder.toString() : county.getStateAbbr();
    final boolean hasCountyStats = county.getStats() != null && county.getStats().getMetrics() != null;
    final int totalHousingUnits = hasCountyStats ? county.getStats().getMetrics().getTotalHousingUnits() : 0;
    final double builtBefore1980Pct = hasCountyStats ? county.getStats().getMetrics().getBuiltBefore1980Pct() : 0.0;
    final int medianHomeValue = hasCountyStats ? county.getStats().getMetrics().getMedianHomeValue() : 0;
    final String totalHousingUnitsDisplay = totalHousingUnits > 0
            ? String.format(java.util.Locale.US, "%,d", totalHousingUnits)
            : "Not available";
    final String olderHomeDisplay = hasCountyStats
            ? String.format(java.util.Locale.US, "%.1f%%", builtBefore1980Pct)
            : "Not available";
    final String medianHomeValueDisplay = medianHomeValue > 0
            ? "$" + String.format(java.util.Locale.US, "%,d", medianHomeValue)
            : "Not available";
    final String housingPercentileDisplay = stateHousingPercentile > 0 ? stateHousingPercentile + "th" : "n/a";
    final String olderHomePercentileDisplay = stateOlderHomePercentile > 0 ? stateOlderHomePercentile + "th" : "n/a";
    final String priorityDisplay = priorityCounty
            ? "Source-backed county page"
            : "County reference page";
    final boolean hasRadonMeasurement = radonMeasurement != null && radonMeasurement.getMetrics() != null;
    final boolean paZipRadonMeasurement = hasRadonMeasurement && "pa_dep_radon_zip".equals(radonMeasurement.getSourceId());
    final boolean highEndOnlyRadonMeasurement = hasRadonMeasurement
            && radonMeasurement.getMetrics().getAverageTestResultPciL() == null
            && radonMeasurement.getMetrics().getArithmeticMeanRadonValuePciL() == null
            && radonMeasurement.getMetrics().getMedianRadonValuePciL() == null
            && radonMeasurement.getMetrics().getPercentTestsAtOrAbove4PciL() == null
            && (radonMeasurement.getMetrics().getMaximumTestResultPciL() != null
            || radonMeasurement.getMetrics().getRadon95thPercentilePciL() != null);
    final boolean historicalSurveyRadonMeasurement = hasRadonMeasurement
            && "epa_usgs_ms_residential_radon_survey".equals(radonMeasurement.getSourceId());
    final boolean tierBackedRadonEvidence = radonEvidence != null
            && !radonEvidence.isMeasurementBacked()
            && "NJ municipal radon-potential table".equals(radonEvidence.getSourceProfileLabel());
    final String evidenceRiskTone = radonEvidence != null && radonEvidence.getRiskTone() != null
            ? radonEvidence.getRiskTone()
            : "";
    final boolean highOfficialEvidence = "high".equals(evidenceRiskTone);
    final boolean elevatedOfficialEvidence = "elevated".equals(evidenceRiskTone);
    final boolean evidencePrimaryAvailable = radonEvidence != null
            && radonEvidence.getPrimaryAverageDisplay() != null
            && !radonEvidence.getPrimaryAverageDisplay().isBlank()
            && !"Not available".equals(radonEvidence.getPrimaryAverageDisplay())
            && !"n/a".equalsIgnoreCase(radonEvidence.getPrimaryAverageDisplay());
    final boolean evidenceAbove4Available = radonEvidence != null
            && radonEvidence.getAbove4Display() != null
            && !radonEvidence.getAbove4Display().isBlank()
            && !"Not available".equals(radonEvidence.getAbove4Display())
            && !"n/a".equalsIgnoreCase(radonEvidence.getAbove4Display());
    final String evidenceMetricBrief = tierBackedRadonEvidence
            ? " The NJ DEP tier table makes this a testing-priority county; use the tier signal to prioritize a home test, not as a home reading."
            : evidencePrimaryAvailable && evidenceAbove4Available
            ? " Official county data shows " + radonEvidence.getPrimaryAverageDisplay()
                    + " and " + radonEvidence.getAbove4Display() + " at or above 4.0."
            : evidencePrimaryAvailable
            ? " Official county data shows " + radonEvidence.getPrimaryAverageDisplay()
                    + " as the primary measured signal."
            : " Official source context is strong enough to prioritize testing before dismissing the county.";
    final String officialSignalPosition = county.getEpaZone() == 1
            ? "backs up the EPA high-zone warning"
            : "is stronger than the EPA zone label suggests";
    final String measuredAverageDisplay = hasRadonMeasurement && radonMeasurement.getMetrics().getAverageTestResultPciL() != null
            ? String.format(java.util.Locale.US, "%.1f pCi/L", radonMeasurement.getMetrics().getAverageTestResultPciL())
            : "Not available";
    final String measuredPrimaryResultLabel = paZipRadonMeasurement && radonMeasurement.getMetrics().getBasementAverageTestResultPciL() != null
            ? "Basement average"
            : historicalSurveyRadonMeasurement
            ? "Historical survey average"
            : highEndOnlyRadonMeasurement
            ? "Highest measured"
            : hasRadonMeasurement && radonMeasurement.getMetrics().getAverageTestResultPciL() != null
            ? "Average result"
            : hasRadonMeasurement && radonMeasurement.getMetrics().getMedianRadonValuePciL() != null
            ? "Median result"
            : "Primary result";
    final String measuredPrimaryResultDisplay = hasRadonMeasurement && radonMeasurement.getMetrics().getAverageTestResultPciL() != null
            ? measuredAverageDisplay
            : highEndOnlyRadonMeasurement && radonMeasurement.getMetrics().getMaximumTestResultPciL() != null
            ? String.format(java.util.Locale.US, "%.1f pCi/L", radonMeasurement.getMetrics().getMaximumTestResultPciL())
            : highEndOnlyRadonMeasurement && radonMeasurement.getMetrics().getRadon95thPercentilePciL() != null
            ? String.format(java.util.Locale.US, "%.1f pCi/L", radonMeasurement.getMetrics().getRadon95thPercentilePciL())
            : hasRadonMeasurement && radonMeasurement.getMetrics().getMedianRadonValuePciL() != null
            ? String.format(java.util.Locale.US, "%.1f pCi/L", radonMeasurement.getMetrics().getMedianRadonValuePciL())
            : "Not available";
    final String measuredMaxDisplay = hasRadonMeasurement && radonMeasurement.getMetrics().getMaximumTestResultPciL() != null
            ? String.format(java.util.Locale.US, "%.1f pCi/L", radonMeasurement.getMetrics().getMaximumTestResultPciL())
            : "Not available";
    final String measuredHighEndLabel = hasRadonMeasurement && radonMeasurement.getMetrics().getMaximumTestResultPciL() != null
            ? "Maximum reported"
            : hasRadonMeasurement && radonMeasurement.getMetrics().getRadon95thPercentilePciL() != null
            ? "95th percentile"
            : "High-end signal";
    final String measuredHighEndDisplay = hasRadonMeasurement && radonMeasurement.getMetrics().getMaximumTestResultPciL() != null
            ? measuredMaxDisplay
            : hasRadonMeasurement && radonMeasurement.getMetrics().getRadon95thPercentilePciL() != null
            ? String.format(java.util.Locale.US, "%.1f pCi/L", radonMeasurement.getMetrics().getRadon95thPercentilePciL())
            : "Not available";
    final String measuredPercentAbove4Display = hasRadonMeasurement && radonMeasurement.getMetrics().getPercentTestsAtOrAbove4PciL() != null
            ? String.format(java.util.Locale.US, "%.1f%%", radonMeasurement.getMetrics().getPercentTestsAtOrAbove4PciL())
            : "Not available";
    final String measuredPercentAbove2Display = hasRadonMeasurement && radonMeasurement.getMetrics().getPercentTestsAtOrAbove2PciL() != null
            ? String.format(java.util.Locale.US, "%.1f%%", radonMeasurement.getMetrics().getPercentTestsAtOrAbove2PciL())
            : "Not available";
    final String measuredMedianDisplay = hasRadonMeasurement && radonMeasurement.getMetrics().getMedianRadonValuePciL() != null
            ? String.format(java.util.Locale.US, "%.1f pCi/L", radonMeasurement.getMetrics().getMedianRadonValuePciL())
            : "Not available";
    final String measuredTestVolumeLabel = hasRadonMeasurement && radonMeasurement.getMetrics().getTotalTests() != null
            ? "Reported tests"
            : hasRadonMeasurement && radonMeasurement.getMetrics().getNumberBuildingsTested10Year() != null
            ? "10-year tested"
            : "Avg. tests/year";
    final String measuredAverageTestsDisplay = hasRadonMeasurement && radonMeasurement.getMetrics().getTotalTests() != null
            ? String.format(java.util.Locale.US, "%,.0f", radonMeasurement.getMetrics().getTotalTests())
            : hasRadonMeasurement && radonMeasurement.getMetrics().getNumberBuildingsTested10Year() != null
            ? String.format(java.util.Locale.US, "%,.0f", radonMeasurement.getMetrics().getNumberBuildingsTested10Year())
            : hasRadonMeasurement && radonMeasurement.getMetrics().getAverageNumberOfTests() != null
            ? String.format(java.util.Locale.US, "%.1f", radonMeasurement.getMetrics().getAverageNumberOfTests())
            : "Not available";
    final boolean hasPaFloorBreakdown = paZipRadonMeasurement
            && (radonMeasurement.getMetrics().getBasementAverageTestResultPciL() != null
            || radonMeasurement.getMetrics().getFirstFloorAverageTestResultPciL() != null);
    final String measuredBasementAverageDisplay = hasRadonMeasurement && radonMeasurement.getMetrics().getBasementAverageTestResultPciL() != null
            ? String.format(java.util.Locale.US, "%.1f pCi/L", radonMeasurement.getMetrics().getBasementAverageTestResultPciL())
            : "Not available";
    final String measuredBasementTestsDisplay = hasRadonMeasurement && radonMeasurement.getMetrics().getBasementTestCount() != null
            ? String.format(java.util.Locale.US, "%,.0f", radonMeasurement.getMetrics().getBasementTestCount())
            : "Not available";
    final String measuredFirstFloorAverageDisplay = hasRadonMeasurement && radonMeasurement.getMetrics().getFirstFloorAverageTestResultPciL() != null
            ? String.format(java.util.Locale.US, "%.1f pCi/L", radonMeasurement.getMetrics().getFirstFloorAverageTestResultPciL())
            : "Not available";
    final String measuredFirstFloorTestsDisplay = hasRadonMeasurement && radonMeasurement.getMetrics().getFirstFloorTestCount() != null
            ? String.format(java.util.Locale.US, "%,.0f", radonMeasurement.getMetrics().getFirstFloorTestCount())
            : "Not available";
    final String evidenceFirstSourceHeading = hasRadonMeasurement && radonMeasurement.getSourceName() != null && !radonMeasurement.getSourceName().isBlank()
            ? radonMeasurement.getSourceName()
            : "Official county evidence";
    final String evidenceFirstPeriodDisplay = hasRadonMeasurement && radonMeasurement.getPeriod() != null && !radonMeasurement.getPeriod().isBlank()
            ? radonMeasurement.getPeriod()
            : "Current source summary";
    final String stateProgramUrl = stateRule != null && stateRule.getStateProgramUrl() != null && !stateRule.getStateProgramUrl().isBlank()
            ? stateRule.getStateProgramUrl()
            : "https://www.epa.gov/radon/find-information-about-local-radon-zones-and-state-contact-information";
    final String epaZoneMapUrl = "https://www.epa.gov/radon/epa-map-radon-zones";
    final String censusAcsUrl = "https://www.census.gov/programs-surveys/acs";
    final String nrppProSearchUrl = "https://nrpp.info/pro-search/";
    final String epaQualifiedProviderUrl = "https://www.epa.gov/radon/how-can-you-find-qualified-radon-service-provider-your-area";
    final String evidenceSourceLinkUrl = hasRadonMeasurement && radonMeasurement.getSourceUrl() != null && !radonMeasurement.getSourceUrl().isBlank()
            ? radonMeasurement.getSourceUrl()
            : stateProgramUrl;
    final String evidenceSourceLinkLabel = hasRadonMeasurement
            ? "Open source dataset"
            : "Open official state source";
    final String evidenceRetrievedDisplay = hasRadonMeasurement && radonMeasurement.getRetrievedAt() != null && !radonMeasurement.getRetrievedAt().isBlank()
            ? radonMeasurement.getRetrievedAt()
            : "See source";
    final String evidenceDossierSourceLabel = radonEvidence != null && radonEvidence.getSourceProfileLabel() != null && !radonEvidence.getSourceProfileLabel().isBlank()
            ? radonEvidence.getSourceProfileLabel()
            : evidenceFirstSourceHeading;
    final String evidenceDossierSourceSummary = radonEvidence != null && radonEvidence.getSourceProfileSummary() != null && !radonEvidence.getSourceProfileSummary().isBlank()
            ? radonEvidence.getSourceProfileSummary()
            : "County evidence is shown as source context only; a valid home test controls mitigation and hiring decisions.";
    final String evidenceCaveatDisplay = hasRadonMeasurement && radonMeasurement.getCaveat() != null && !radonMeasurement.getCaveat().isBlank()
            ? radonMeasurement.getCaveat()
            : "This county context cannot diagnose a specific property. Use it to choose the right test and official follow-up path.";
    final boolean fallsChurchDecisionCounty =
            "virginia".equals(county.getStateSlug()) && "falls-church-city".equals(county.getCountySlug());
    final boolean schenectadyZoneCounty =
            "new-york".equals(county.getStateSlug()) && "schenectady-county".equals(county.getCountySlug());
    final boolean dupageCtrCounty =
            "illinois".equals(county.getStateSlug()) && "dupage-county".equals(county.getCountySlug());
    final boolean fremontZoneCounty =
            "idaho".equals(county.getStateSlug()) && "fremont-county".equals(county.getCountySlug());
    final boolean williamsonDecisionCounty =
            "tennessee".equals(county.getStateSlug()) && "williamson-county".equals(county.getCountySlug());
    final boolean santaClaraDecisionCounty =
            "california".equals(county.getStateSlug()) && "santa-clara-county".equals(county.getCountySlug());
    final boolean cherokeeDecisionCounty =
            "georgia".equals(county.getStateSlug()) && "cherokee-county".equals(county.getCountySlug());
    final boolean westchesterDecisionCounty =
            "new-york".equals(county.getStateSlug()) && "westchester-county".equals(county.getCountySlug());
    final boolean polkFloridaDecisionCounty =
            "florida".equals(county.getStateSlug()) && "polk-county".equals(county.getCountySlug());
    final boolean adaDecisionCounty =
            "idaho".equals(county.getStateSlug()) && "ada-county".equals(county.getCountySlug());
    final boolean chesterDecisionCounty =
            "pennsylvania".equals(county.getStateSlug()) && "chester-county".equals(county.getCountySlug());
    final boolean kaneDecisionCounty =
            "illinois".equals(county.getStateSlug()) && "kane-county".equals(county.getCountySlug());
    final boolean madisonAlabamaDecisionCounty =
            "alabama".equals(county.getStateSlug()) && "madison-county".equals(county.getCountySlug());
    final boolean phaseOneCtrLiftCounty =
            fallsChurchDecisionCounty
                    || williamsonDecisionCounty
                    || santaClaraDecisionCounty
                    || cherokeeDecisionCounty;
    final boolean phaseTwoCtrLiftCounty =
            westchesterDecisionCounty
                    || polkFloridaDecisionCounty
                    || adaDecisionCounty;
    final boolean phaseThreeCtrLiftCounty =
            chesterDecisionCounty
                    || kaneDecisionCounty
                    || madisonAlabamaDecisionCounty;
    final boolean ulsterServiceSearchCounty =
            "new-york".equals(county.getStateSlug()) && "ulster-county".equals(county.getCountySlug());
    final boolean losAngelesCommercialSearchCounty =
            "california".equals(county.getStateSlug()) && "los-angeles-county".equals(county.getCountySlug());
    final boolean boulderServiceSearchCounty =
            "colorado".equals(county.getStateSlug()) && "boulder-county".equals(county.getCountySlug());
    final boolean broomfieldServiceSearchCounty =
            "colorado".equals(county.getStateSlug()) && "broomfield-county".equals(county.getCountySlug());
    final boolean loudounTestingSearchCounty =
            "virginia".equals(county.getStateSlug()) && "loudoun-county".equals(county.getCountySlug());
    final boolean stLouisRadonSearchCounty =
            "missouri".equals(county.getStateSlug()) && "st-louis-county".equals(county.getCountySlug());
    final boolean gscServiceIntentCounty =
            ulsterServiceSearchCounty
                    || losAngelesCommercialSearchCounty
                    || boulderServiceSearchCounty
                    || broomfieldServiceSearchCounty
                    || loudounTestingSearchCounty
                    || stLouisRadonSearchCounty;
    final boolean gscSurvivorNearMissCounty =
            ("new-york".equals(county.getStateSlug()) && "monroe-county".equals(county.getCountySlug()))
                    || ("tennessee".equals(county.getStateSlug()) && "sevier-county".equals(county.getCountySlug()))
                    || ("new-jersey".equals(county.getStateSlug()) && "warren-county".equals(county.getCountySlug()))
                    || ("vermont".equals(county.getStateSlug()) && "rutland-county".equals(county.getCountySlug()))
                    || ("maryland".equals(county.getStateSlug()) && "prince-georges-county".equals(county.getCountySlug()))
                    || ("pennsylvania".equals(county.getStateSlug()) && "northampton-county".equals(county.getCountySlug()));
    final boolean nextStepCtrLiftCounty =
            phaseOneCtrLiftCounty || phaseTwoCtrLiftCounty || phaseThreeCtrLiftCounty;
    final String countyEvidenceSummary = !nextStepCtrLiftCounty && highOfficialEvidence
            ? county.getAreaDisplayName() + " should be treated as a testing-priority county because the official source signal "
                    + officialSignalPosition + ". " + evidenceMetricBrief.trim()
                    + " Use the EPA map as context, but let the home test decide mitigation or credit planning."
            : !nextStepCtrLiftCounty && elevatedOfficialEvidence
            ? county.getAreaDisplayName() + " has enough official radon signal that the answer should not stop at the EPA map. "
                    + evidenceMetricBrief.trim()
                    + " Confirm the home before pricing mitigation, but do not dismiss the county as low urgency."
            : county.getEpaZone() == 1
            ? county.getAreaDisplayName() + " is a higher-priority testing county because the EPA zone signal is high and the page now ties that signal to local housing context."
            : county.getEpaZone() == 2
            ? county.getAreaDisplayName() + " is a moderate-signal county: the EPA map is useful context, but the local evidence, housing profile, and your own home test decide the next step."
            : county.getEpaZone() == 3
            ? county.getAreaDisplayName() + " has a lower predicted countywide zone signal, so direct testing matters more than the map label."
            : county.getAreaDisplayName() + " has no published EPA zone in this dataset, so the only reliable next step is direct home testing.";
    final boolean priorityCtrCounty =
            ("new-york".equals(county.getStateSlug()) && "schenectady-county".equals(county.getCountySlug()))
                    || ("massachusetts".equals(county.getStateSlug()) && "franklin-county".equals(county.getCountySlug()))
                    || ("virginia".equals(county.getStateSlug()) && "fairfax-city".equals(county.getCountySlug()))
                    || fallsChurchDecisionCounty
                    || ("maryland".equals(county.getStateSlug()) && "howard-county".equals(county.getCountySlug()))
                    || ("florida".equals(county.getStateSlug()) && "miami-dade-county".equals(county.getCountySlug()))
                    || fremontZoneCounty;
    final boolean topCtrPriorityCounty =
            fallsChurchDecisionCounty
                    || ("new-york".equals(county.getStateSlug()) && "westchester-county".equals(county.getCountySlug()))
                    || ("ohio".equals(county.getStateSlug()) && "licking-county".equals(county.getCountySlug()))
                    || ("iowa".equals(county.getStateSlug()) && "polk-county".equals(county.getCountySlug()))
                    || ("california".equals(county.getStateSlug()) && "santa-clara-county".equals(county.getCountySlug()))
                    || ("missouri".equals(county.getStateSlug()) && "st-louis-county".equals(county.getCountySlug()))
                    || ("tennessee".equals(county.getStateSlug()) && "williamson-county".equals(county.getCountySlug()))
                    || ("pennsylvania".equals(county.getStateSlug()) && "allegheny-county".equals(county.getCountySlug()))
                    || ("florida".equals(county.getStateSlug()) && "hillsborough-county".equals(county.getCountySlug()));
    final boolean basementCtrPriorityCounty =
            fallsChurchDecisionCounty || dupageCtrCounty;
    final boolean epaZoneCtrPriorityCounty =
            fremontZoneCounty || schenectadyZoneCounty;
    final boolean searchedOfficialEvidenceCounty =
            ("virginia".equals(county.getStateSlug()) && "loudoun-county".equals(county.getCountySlug()))
                    || ("florida".equals(county.getStateSlug()) && "marion-county".equals(county.getCountySlug()))
                    || ("new-jersey".equals(county.getStateSlug()) && "gloucester-county".equals(county.getCountySlug()));
    final boolean officialEvidenceSerpCounty =
            searchedOfficialEvidenceCounty
                    && !nextStepCtrLiftCounty
                    && (highOfficialEvidence || elevatedOfficialEvidence || tierBackedRadonEvidence);
    final boolean gscSurvivorIntentCopyCounty =
            gscSurvivorNearMissCounty && !officialEvidenceSerpCounty;
    final String evidenceSerpTitleMetric = tierBackedRadonEvidence
            ? "NJ DEP Tier Signal"
            : evidencePrimaryAvailable && evidenceAbove4Available
            ? radonEvidence.getPrimaryAverageDisplay() + " & " + radonEvidence.getAbove4Display() + " 4.0+"
            : evidencePrimaryAvailable
            ? radonEvidence.getPrimaryAverageDisplay() + " Official Data"
            : "Official Data";
    final String evidenceSerpDescription = tierBackedRadonEvidence
            ? "NJ DEP tier data makes " + seoPlaceLabel
                    + " a testing-priority county. See what the tier signal means before you test, retest, or price mitigation."
            : evidencePrimaryAvailable && evidenceAbove4Available
            ? "Official data shows " + radonEvidence.getPrimaryAverageDisplay()
                    + " and " + radonEvidence.getAbove4Display() + " at or above 4.0 in " + seoPlaceLabel
                    + ". See whether to test, retest, or budget mitigation."
            : evidencePrimaryAvailable
            ? "Official data shows " + radonEvidence.getPrimaryAverageDisplay()
                    + " as the primary signal in " + seoPlaceLabel
                    + ". See whether to test, retest, or budget mitigation."
            : "Official source evidence makes " + seoPlaceLabel
                    + " a testing-priority county. See whether to test, retest, or budget mitigation.";
    final String evidenceBadgeLabel = tierBackedRadonEvidence
            ? "NJ DEP Tier Signal"
            : evidencePrimaryAvailable
            ? "Official Signal " + radonEvidence.getPrimaryAverageDisplay()
            : "Official County Evidence";
    final String gscQueryCluster = ulsterServiceSearchCounty
            ? "radon gas testing Ulster County NY; radon mitigation services Ulster County NY"
            : losAngelesCommercialSearchCounty
            ? "commercial radon Los Angeles CA; radon testing Los Angeles"
            : boulderServiceSearchCounty
            ? "radon testing Boulder CO; Boulder radon mitigation"
            : broomfieldServiceSearchCounty
            ? "Broomfield radon mitigation"
            : loudounTestingSearchCounty
            ? "radon testing Loudoun County"
            : stLouisRadonSearchCounty
            ? "St Louis radon"
            : "radon testing, mitigation services, and commercial radon";
    final String serviceSearchTitle = ulsterServiceSearchCounty
            ? seoPlaceLabel + " Radon Gas Testing & Mitigation Services"
            : losAngelesCommercialSearchCounty
            ? seoPlaceLabel + " Commercial Radon, Testing & Levels"
            : boulderServiceSearchCounty
            ? seoPlaceLabel + " Radon Testing & Mitigation Guide"
            : broomfieldServiceSearchCounty
            ? seoPlaceLabel + " Radon Mitigation & Testing Guide"
            : loudounTestingSearchCounty
            ? seoPlaceLabel + " Radon Testing, Levels & Cost Path"
            : stLouisRadonSearchCounty
            ? seoPlaceLabel + " Radon Levels, Testing & Mitigation"
            : seoPlaceLabel + " Radon Levels & Testing | 4.0+ Next Step";
    final String serviceBridgeSummary = losAngelesCommercialSearchCounty
            ? "Commercial radon searches usually need a different call than a one-family home: building type, testing protocol, occupancy, access, scope, and whether the quote is for testing, mitigation, or both."
            : ulsterServiceSearchCounty
            ? "Ulster demand is mostly testing and mitigation-service language. The page has to answer the local testing question first, then move a confirmed 4.0+ result into cost and quote comparison."
            : boulderServiceSearchCounty || broomfieldServiceSearchCounty
            ? "Colorado service searches tend to jump straight to mitigation. The safer path is to confirm the reading, check the county evidence, and then compare the contractor scope against the local cost page."
            : loudounTestingSearchCounty
            ? "Loudoun searchers are already close to action. Keep the sequence tight: test result, official county signal, local cost range, then a quote or seller-credit decision."
            : stLouisRadonSearchCounty
            ? "St. Louis searches need the official Missouri test signal and the local contractor path in one place, because generic state guidance is too slow for a user with a real reading."
            : "Service searches need a result-to-cost path, not a generic radon article.";
    final String providerSearchPackHeading = losAngelesCommercialSearchCounty
            ? "Commercial provider search pack"
            : "Local provider search pack";
    final String providerSearchPackBody = losAngelesCommercialSearchCounty
            ? "Before contacting a commercial radon provider, write down building type, occupied areas, number of test locations, lowest occupied level, result band, deadline, and whether mitigation or testing documentation is the deliverable."
            : "Before contacting a radon provider, write down the test type, pCi/L result, lowest tested level, foundation type, deadline, and whether you need testing, mitigation, seller-credit support, or post-mitigation retest documentation.";

    final String seoTitle = officialEvidenceSerpCounty
            ? seoPlaceLabel + " Radon Levels: " + evidenceSerpTitleMetric
            : gscServiceIntentCounty
            ? serviceSearchTitle
            : gscSurvivorIntentCopyCounty
            ? seoPlaceLabel + " Radon Levels | Test, Retest, or Cost Path"
            : epaZoneCtrPriorityCounty
            ? seoPlaceLabel + " EPA Radon Zone | Basement Levels & 4.0 Guide"
            : basementCtrPriorityCounty
            ? seoPlaceLabel + " Basement Radon Levels | EPA Zone & 4.0 Guide"
            : nextStepCtrLiftCounty
            ? seoPlaceLabel + " Radon Levels | EPA Zone, 4.0+, and Next Step"
            : topCtrPriorityCounty
            ? seoPlaceLabel + " Basement Radon Levels | EPA Zone & 4.0 Guide"
            : priorityCtrCounty
            ? seoPlaceLabel + " Radon Levels: EPA Zone & Basement Test Guide"
            : searchTrafficCounty
            ? "Radon Levels in " + seoPlaceLabel + " | Official Data & Testing Guide"
            : seoPlaceLabel + " Radon Levels, Zone Map & Home Testing Guide | EPA 4.0 pCi/L";

    final String seoDescription = officialEvidenceSerpCounty
            ? evidenceSerpDescription
            : gscServiceIntentCounty
            ? "Searching for " + gscQueryCluster + "? Use the " + seoPlaceLabel
            + " decision path: confirm the reading, check county evidence, and open the local cost or quote path."
            : gscSurvivorIntentCopyCounty
            ? "Check radon levels in " + seoPlaceLabel
            + ", see the official county signal, and choose the fast path from first test to retest, cost, or seller-credit planning."
            : epaZoneCtrPriorityCounty
            ? "Check the EPA radon zone for " + seoPlaceLabel
            + ", see what that zone means for basement radon levels, and know when 2.0-3.9 versus 4.0+ changes the next step."
            : basementCtrPriorityCounty
            ? "Check basement radon levels in " + seoPlaceLabel
            + ", see the EPA zone, and understand what 2.0 vs 4.0+ pCi/L means before you retest or compare mitigation quotes."
            : nextStepCtrLiftCounty
            ? "Check radon levels in " + seoPlaceLabel
            + ", see the EPA zone, and know whether to test, retest, or budget mitigation after a 4.0+ result."
            : topCtrPriorityCounty
            ? "Check basement radon levels in " + seoPlaceLabel
            + ", see the EPA zone, and understand what 2.0 vs 4.0+ pCi/L means before you retest or compare mitigation quotes."
            : priorityCtrCounty
            ? "Check the EPA radon zone for " + seoPlaceLabel
            + ", what a basement test means at 2.0 vs 4.0+ pCi/L, and when to retest or compare mitigation quotes."
            : searchTrafficCounty
            ? "Check radon levels in " + seoPlaceLabel
            + " using official county, state, EPA zone, and testing-source context. See when to test, retest, or act after a 4.0+ pCi/L result."
            : seoPlaceLabel + " radon guide for basement and lowest-level home tests. See EPA zone data, what 2.0, 4.0, and 8.0+ pCi/L mean, and when mitigation quotes are worth comparing.";

    final String heroTitle = epaZoneCtrPriorityCounty
            ? "EPA Radon Zone & Basement Testing in " + seoPlaceLabel
            : gscServiceIntentCounty
            ? "Radon testing, levels & next step in " + seoPlaceLabel
            : gscSurvivorIntentCopyCounty
            ? seoPlaceLabel + " radon levels: test-to-decision path"
            : basementCtrPriorityCounty
            ? "Basement Radon Levels, EPA Zone & Test Meaning in " + seoPlaceLabel
            : nextStepCtrLiftCounty
            ? seoPlaceLabel + " Radon Levels, EPA Zone & Next Step"
            : topCtrPriorityCounty
            ? "Basement Radon Levels, EPA Zone & Test Meaning in " + seoPlaceLabel
            : priorityCtrCounty
            ? "Radon Levels, EPA Zone & Basement Testing in " + seoPlaceLabel
            : searchTrafficCounty
            ? "Radon Levels in " + seoPlaceLabel
            : "Radon Levels & Zone Map in " + seoPlaceLabel;

    final String directAnswerLead = epaZoneCtrPriorityCounty
            ? "EPA zone answer first: "
            : gscServiceIntentCounty
            ? "Local service search answer: "
            : gscSurvivorIntentCopyCounty
            ? "Fast county answer: "
            : basementCtrPriorityCounty
            ? "Basement test answer: "
            : nextStepCtrLiftCounty
            ? "Fast local answer: "
            : topCtrPriorityCounty
            ? "Basement test answer: "
            : priorityCtrCounty
            ? "Short answer for homeowners, buyers, and sellers: "
            : searchTrafficCounty
            ? "Official local answer: "
            : "Direct Answer for basement and lowest-level tests: ";

    final String introIntentLead = gscServiceIntentCounty
            ? "If you searched for radon gas testing, mitigation services, commercial radon, or a local contractor in "
                    + county.getAreaDisplayName()
                    + ", use this page to separate the reading from the hiring decision. Confirm the result first, then open the local cost or quote path."
            : gscSurvivorIntentCopyCounty
            ? "If you landed here from a " + county.getAreaDisplayName()
                    + " radon-level search, start with the short lane: no reading yet, borderline result, or 4.0+ result."
            : fallsChurchDecisionCounty
            ? "If you are checking radon levels in a " + county.getAreaDisplayName()
                    + " basement, use the EPA zone as context first, then decide whether a 2.0-3.9 result needs a retest or a 4.0+ result needs mitigation planning."
            : schenectadyZoneCounty
            ? "If you are trying to confirm the EPA radon zone for " + county.getAreaDisplayName()
                    + ", use this page for the zone answer first, then map that zone to what a basement or lowest-level test result actually means."
            : dupageCtrCounty
            ? "If you are checking basement radon levels in " + county.getAreaDisplayName()
                    + ", use the EPA zone as context first, then decide whether a 2.0-3.9 result needs retesting or a 4.0+ result needs mitigation planning."
            : phaseOneCtrLiftCounty
            ? "Use the " + county.getAreaDisplayName()
                    + " quick path to decide between first testing, retesting, or budgeting mitigation instead of starting with a generic radon guide."
            : phaseTwoCtrLiftCounty
            ? "If you already have a reading in " + county.getAreaDisplayName()
                    + ", start with the local next-step answer before opening a longer guide."
            : phaseThreeCtrLiftCounty
            ? "Start with the short local evidence read for " + county.getAreaDisplayName()
                    + ", then go deeper only if you still need context."
            : fremontZoneCounty
            ? "If you are trying to confirm the EPA radon zone for " + county.getAreaDisplayName()
                    + ", use this page for the quick zone answer first, then map that zone to what a basement or lowest-level test result actually means."
            : null;

    final String decisionFlowIntro = gscServiceIntentCounty
            ? "Use this as the pre-contractor triage for " + county.getAreaDisplayName()
                    + ": test first, price after 4.0+, and add any real quote to the ledger."
            : gscSurvivorIntentCopyCounty
            ? "Use the " + county.getAreaDisplayName()
                    + " short path first; the deeper source detail is below if you need it."
            : fallsChurchDecisionCounty
            ? "Open the " + county.getAreaDisplayName()
                    + " action plan from the basement result you already have, instead of starting from a generic cost page."
            : phaseOneCtrLiftCounty
            ? "Open the " + county.getAreaDisplayName()
                    + " action plan from the result you already have, instead of reading a longer general guide first."
            : phaseTwoCtrLiftCounty
            ? "Jump into the " + county.getAreaDisplayName()
                    + " action plan from your current result, instead of backing into it from a generic cost page."
            : phaseThreeCtrLiftCounty
            ? "Use the " + county.getAreaDisplayName()
                    + " quick path first, then open the deeper reference only if you still need it."
            : fremontZoneCounty
            ? "Open the " + county.getAreaDisplayName()
                    + " action plan from the EPA zone or reading you already have, instead of starting from a generic cost page."
            : "Jump into a prefilled " + county.getAreaDisplayName()
                    + " action plan based on the result you already have, instead of starting from a generic cost page.";

    final String borderlineResultCta = gscServiceIntentCounty
            ? "Confirm the reading before quotes"
            : gscSurvivorIntentCopyCounty
            ? "Confirm the " + county.getAreaDisplayName() + " borderline result"
            : fallsChurchDecisionCounty
            ? "Plan a confirmatory basement test"
            : fremontZoneCounty
            ? "Plan a confirmatory zone test"
            : nextStepCtrLiftCounty
            ? "Confirm the " + county.getAreaDisplayName() + " 2.0-3.9 result"
            : "Plan the confirmatory test";

    final String highResultCta = gscServiceIntentCounty
            ? "Open the " + county.getAreaDisplayName() + " 4.0+ cost path before calling contractors"
            : gscSurvivorIntentCopyCounty
            ? "Open the " + county.getAreaDisplayName() + " local cost path"
            : fallsChurchDecisionCounty
            ? "See " + county.getAreaDisplayName() + " mitigation cost before calling contractors"
            : fremontZoneCounty
            ? "Open the " + county.getAreaDisplayName() + " 4.0+ mitigation plan"
            : nextStepCtrLiftCounty
            ? "Open the " + county.getAreaDisplayName() + " 4.0+ action plan"
            : "Budget mitigation before you call contractors";

    final String buyerSellerResultCta = gscServiceIntentCounty
            ? "Convert the " + county.getAreaDisplayName() + " quote into a credit plan"
            : gscSurvivorIntentCopyCounty
            ? "Turn the " + county.getAreaDisplayName() + " result into a credit plan"
            : fallsChurchDecisionCounty || fremontZoneCounty
            ? "Turn a " + county.getAreaDisplayName() + " result into seller-credit numbers"
            : nextStepCtrLiftCounty
            ? "Turn a " + county.getAreaDisplayName() + " result into a credit plan"
            : "Turn the result into a seller-credit plan";

    final String heroQuickEvidenceRead = gscServiceIntentCounty
            ? county.getAreaDisplayName()
            + " searchers are often looking for testing, mitigation services, or a commercial radon answer. The useful sequence is still the same: confirm the reading, then decide cost, credit, or quote."
            : gscSurvivorIntentCopyCounty
            ? county.getAreaDisplayName()
            + " is a near-miss county from the search data. Keep the path short: first test, retest a borderline result, or price a confirmed 4.0+ result."
            : phaseOneCtrLiftCounty
            ? county.getAreaDisplayName()
            + " searchers usually need the practical next move fast. The first useful split is simple: no test yet, 2.0-3.9, or 4.0+."
            : !nextStepCtrLiftCounty && highOfficialEvidence
            ? county.getAreaDisplayName() + " " + officialSignalPosition + "."
                    + evidenceMetricBrief
                    + " Do the home test, and treat a confirmed 4.0+ result as mitigation-planning territory."
            : !nextStepCtrLiftCounty && elevatedOfficialEvidence
            ? county.getAreaDisplayName()
                    + " has enough official radon signal that the practical answer is not just map-reading."
                    + evidenceMetricBrief
                    + " Start with a real home test, then retest or price only from the result."
            : schenectadyZoneCounty
            ? county.getAreaDisplayName()
            + " is EPA Zone 2, which means a predicted indoor screening range between 2.0 and 4.0 pCi/L. Individual basements can still test above 4.0, so your own reading decides the next move."
            : dupageCtrCounty
            ? county.getAreaDisplayName()
            + " basement searchers usually need the practical split fast: no test yet, 2.0-3.9, or 4.0+. The county map is context, but the reading in your home drives the decision."
            : phaseTwoCtrLiftCounty
            ? county.getAreaDisplayName()
            + " works best as a reading-to-decision page. The county signal is context, but your result is what changes the next move."
            : phaseThreeCtrLiftCounty
            ? "Start with the quick local evidence read for " + county.getAreaDisplayName()
            + ". If you still need more detail after that, the longer reference is below."
            : county.getEpaZone() == 1
            ? county.getAreaDisplayName() + " is a strong county-level radon signal. You still need a home test, but this is not a county where skipping the first test makes sense."
            : county.getEpaZone() == 2
            ? county.getAreaDisplayName() + " sits in the gray zone. The map helps, but your own reading matters more than the countywide signal."
            : county.getEpaZone() == 3
            ? county.getAreaDisplayName() + " has a lower countywide signal, but that does not clear an individual home. A real test still beats the map."
            : county.getAreaDisplayName() + " has no published county zone in our dataset, so the useful answer starts with a direct home test.";

    final String quickDecisionHeading = gscServiceIntentCounty
            ? "Do not hire from a blind reading"
            : gscSurvivorIntentCopyCounty
            ? "Keep the county path short"
            : phaseOneCtrLiftCounty
            ? "Pick the lane fast"
            : !nextStepCtrLiftCounty && highOfficialEvidence
            ? "Treat this as a test-now county"
            : !nextStepCtrLiftCounty && elevatedOfficialEvidence
            ? "Do not stop at the map label"
            : phaseTwoCtrLiftCounty
            ? "Use the reading to choose the lane"
            : phaseThreeCtrLiftCounty
            ? "Take the quick evidence read first"
            : county.getEpaZone() == 1
            ? "Do not guess in a higher-risk county"
            : county.getEpaZone() == 2
            ? "Treat the map as a hint, not the answer"
            : county.getEpaZone() == 3
            ? "Low county risk is not a home-level clear signal"
            : "No map answer here";

    final String quickDecisionBody = gscServiceIntentCounty
            ? "A service search is only useful after the number is real. Use this page to verify the result band, open the cost path, and capture the quote signal if you talk to a contractor."
            : gscSurvivorIntentCopyCounty
            ? "These counties already showed search traction. The page now removes the extra step between county evidence and the next action."
            : phaseOneCtrLiftCounty
            ? "No test yet, 2.0-3.9, and 4.0+ each point to a different next move. This page is built to get you there without extra reading."
            : !nextStepCtrLiftCounty && highOfficialEvidence
            ? "The official source signal is strong enough that a first test is the minimum; a confirmed 4.0+ result should move into cost or credit planning."
            : !nextStepCtrLiftCounty && elevatedOfficialEvidence
            ? "The official data is not a clear dismissal. Use it to justify testing or retesting, then let the home result decide whether pricing makes sense."
            : phaseTwoCtrLiftCounty
            ? "The county signal matters less than the result in your home. Use the number to decide whether you test, retest, or price mitigation."
            : phaseThreeCtrLiftCounty
            ? "If your goal is just the next practical step, start with the local evidence read and save the long explanation for later."
            : county.getEpaZone() == 1
            ? "Most users should either get a first test or move a 4.0+ result straight into mitigation pricing."
            : county.getEpaZone() == 2
            ? "Zone 2 is the gray area. A real reading is what decides whether you retest, track, or price mitigation."
            : county.getEpaZone() == 3
            ? "Do not let a Zone 3 label talk you out of the first test. House-by-house differences still matter."
            : "With no county signal, direct testing is the first decision that matters.";

    final String countySignalSummary = gscServiceIntentCounty
            ? "Service intent detected: testing, mitigation, or commercial radon searches need a result-to-cost path."
            : gscSurvivorIntentCopyCounty
            ? "Near-miss search signal: keep the page focused on the next practical decision."
            : highEndOnlyRadonMeasurement
            ? "Official source shows a highest reported county value, not a county average."
            : tierBackedRadonEvidence
            ? "Official tier data shows local radon potential, not a county pCi/L average."
            : historicalSurveyRadonMeasurement
            ? "Older survey data is context for testing, not a current county prediction."
            : !nextStepCtrLiftCounty && highOfficialEvidence
            ? "Official measured data puts this county in a high-priority testing lane."
            : !nextStepCtrLiftCounty && elevatedOfficialEvidence
            ? "Official measured data is elevated enough to justify testing or retesting."
            : nextStepCtrLiftCounty
            ? "County map context helps, but your own result is what changes the decision."
            : county.getEpaZone() == 1
            ? "Higher countywide chance of 4.0+ readings."
            : county.getEpaZone() == 2
            ? "Gray-zone county signal. Some homes stay low, others cross the EPA line."
            : county.getEpaZone() == 3
            ? "Lower countywide map signal, but house-by-house spikes still happen."
            : "No county signal published. Treat direct testing as the only reliable input.";

    final String thresholdSummary = gscServiceIntentCounty
            ? "No reading yet means test first. 4.0+ means pricing and quote comparison become relevant."
            : gscSurvivorIntentCopyCounty
            ? "No reading yet means test first. Borderline means retest. 4.0+ means cost or credit planning."
            : nextStepCtrLiftCounty
            ? "No reading yet means test first. 2.0-3.9 usually means retest or track. 4.0+ means local budget planning starts."
            : "2.0-3.9 pCi/L usually means retest or track. 4.0+ is where EPA action and quote planning start to matter.";

    final String fastMoveSummary = gscServiceIntentCounty
            ? "Test result -> county cost path -> quote ledger if a contractor gives a number."
            : gscSurvivorIntentCopyCounty
            ? "Pick one route now: test, retest, local cost, or seller-credit math."
            : nextStepCtrLiftCounty
            ? "No reading: test first. 2.0-3.9: retest or track. 4.0+: budget local mitigation."
            : county.getEpaZone() == 1
            ? "No reading: test now. Reading at 4.0+: move into mitigation planning."
            : county.getEpaZone() == 2
            ? "No reading: test first. Borderline results often need retest or long-term tracking."
            : county.getEpaZone() == 3
            ? "Low zone is not a free pass. Use a kit before you rule radon out."
            : "Start with a test kit, then let the result decide whether pricing or credit planning matters.";

    String radonSignalQuestion;
    String radonSignalAnswerBase;
    if (highEndOnlyRadonMeasurement) {
        radonSignalQuestion = "What does the highest reported radon reading in " + seoPlaceLabel + " mean?";
        String sourceName = radonMeasurement.getSourceName() != null && !radonMeasurement.getSourceName().isBlank()
                ? radonMeasurement.getSourceName()
                : "The official county source";
        radonSignalAnswerBase = sourceName + " reports " + measuredPrimaryResultDisplay
                + " as the highest measured county value for " + county.getAreaDisplayName()
                + ". That is not a county average; use it as proof that high readings have occurred locally, then test the home directly.";
    } else if (tierBackedRadonEvidence) {
        radonSignalQuestion = "What do the radon potential tiers mean in " + seoPlaceLabel + "?";
        radonSignalAnswerBase = radonEvidence.getSourceProfileSummary() + " "
                + radonEvidence.getIntentAnswer();
    } else if (historicalSurveyRadonMeasurement) {
        radonSignalQuestion = "What does the historical radon survey show in " + seoPlaceLabel + "?";
        radonSignalAnswerBase = "The EPA/USGS survey row for " + county.getAreaDisplayName()
                + " is older official context from " + evidenceFirstPeriodDisplay + ". It reports "
                + measuredPrimaryResultDisplay + " in that survey, but it is not a current property prediction; test the home directly before mitigation or credit decisions.";
    } else if (radonEvidence != null && radonEvidence.getIntentAnswer() != null && !radonEvidence.getIntentAnswer().isBlank()) {
        radonSignalQuestion = "What do the radon data show in " + seoPlaceLabel + "?";
        radonSignalAnswerBase = radonEvidence.getIntentAnswer();
    } else if (county.getEpaZone() == 1) {
        radonSignalQuestion = "What radon zone applies in " + seoPlaceLabel + "?";
        radonSignalAnswerBase = county.getAreaDisplayName() + " is classified as EPA Zone 1 (High Risk). The predicted indoor screening range is above 4.0 pCi/L, which is above the EPA action level.";
    } else if (county.getEpaZone() == 2) {
        radonSignalQuestion = "What radon zone applies in " + seoPlaceLabel + "?";
        radonSignalAnswerBase = county.getAreaDisplayName() + " is classified as EPA Zone 2 (Moderate Risk). The predicted indoor screening range is between 2.0 and 4.0 pCi/L.";
    } else if (county.getEpaZone() == 3) {
        radonSignalQuestion = "What radon zone applies in " + seoPlaceLabel + "?";
        radonSignalAnswerBase = county.getAreaDisplayName() + " is classified as EPA Zone 3 (Low Risk). The predicted indoor screening range is below 2.0 pCi/L.";
    } else {
        radonSignalQuestion = "What radon zone applies in " + seoPlaceLabel + "?";
        radonSignalAnswerBase = county.getAreaDisplayName() + " is classified as an unclassified EPA zone (Data Pending). The EPA zone for this county is currently unclassified in our source data. Please rely on direct home testing to determine risk.";
    }
    final String radonSignalAnswer = radonSignalAnswerBase + " The EPA recommends testing all homes regardless of zone.";

    final String isProblemAnswer;
    if (!nextStepCtrLiftCounty && (highOfficialEvidence || elevatedOfficialEvidence)) {
        isProblemAnswer = "Yes. " + county.getAreaDisplayName()
                + " should be treated as a testing-priority county. " + evidenceMetricBrief.trim()
                + " The home result still controls mitigation, but a missing reading should start with testing.";
    } else if (county.getEpaZone() == 1) {
        isProblemAnswer = "Yes, " + county.getAreaDisplayName() + " is in EPA Zone 1 (High Risk). Most homes should be tested, and confirmed 4.0+ home results should move into mitigation planning.";
    } else if (county.getEpaZone() == 2) {
        isProblemAnswer = county.getAreaDisplayName() + " is in EPA Zone 2 (Moderate Risk). Many individual homes can still have elevated levels above the EPA action threshold.";
    } else if (county.getEpaZone() == 3) {
        isProblemAnswer = county.getAreaDisplayName() + " is in EPA Zone 3 (Low Risk), but elevated radon has been found in homes in every zone. Testing is always recommended.";
    } else {
        isProblemAnswer = county.getAreaDisplayName() + " does not currently have a published EPA zone assignment in our dataset. Because radon risk can vary significantly by home, testing is strongly recommended.";
    }

    final String testAnswer = "Purchase a short-term radon test kit ($15-$30) from a hardware store or online as your first step. Place it in the lowest livable level of your home for 2-7 days with closed-house conditions, then mail it to the lab. If you have already tested once and want ongoing tracking, consider a digital radon monitor ($150-$200).";
}

@template.layout.main(
    title = seoTitle,
    description = seoDescription,
    canonicalUrl = canonicalUrl,
    noindex = noindex,
    headContent = @`
        <script type="application/ld+json">
            {
                "@context": "https://schema.org",
                "@type": "FAQPage",
                "mainEntity": [
                    {
                        "@type": "Question",
                        "name": $unsafe{JsonLdUtils.json(radonSignalQuestion)},
                        "acceptedAnswer": {
                            "@type": "Answer",
                            "text": $unsafe{JsonLdUtils.json(radonSignalAnswer)}
                        }
                    },
                    {
                        "@type": "Question",
                        "name": $unsafe{JsonLdUtils.json("Is radon a problem in " + seoPlaceLabel + "?")},
                        "acceptedAnswer": {
                            "@type": "Answer",
                            "text": $unsafe{JsonLdUtils.json(isProblemAnswer)}
                        }
                    },
                    {
                        "@type": "Question",
                        "name": $unsafe{JsonLdUtils.json("How do I test for radon in " + seoPlaceLabel + "?")},
                        "acceptedAnswer": {
                            "@type": "Answer",
                            "text": $unsafe{JsonLdUtils.json(testAnswer)}
                        }
                    }
                ]
            }
        </script>
        <script type="application/ld+json">
            {
                "@context": "https://schema.org",
                "@type": "BreadcrumbList",
                "itemListElement": [{
                    "@type": "ListItem",
                    "position": 1,
                    "name": "Home",
                    "item": "https://radonverdict.com/"
                },{
                    "@type": "ListItem",
                    "position": 2,
                    "name": $unsafe{JsonLdUtils.json(county.getStateAbbr() + " Radon Levels")},
                    "item": $unsafe{JsonLdUtils.json("https://radonverdict.com/radon-levels/" + county.getStateSlug())}
                },{
                    "@type": "ListItem",
                    "position": 3,
                    "name": $unsafe{JsonLdUtils.json(seoCountyDisplay)},
                    "item": $unsafe{JsonLdUtils.json("https://radonverdict.com/radon-levels/" + county.getStateSlug() + "/" + county.getCountySlug())}
                }]
            }
        </script>
    `,
    content = @`
        <div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 pt-10 pb-24 lg:pb-10">

            <!-- Breadcrumb -->
            <nav class="text-sm font-medium text-slate-500 mb-8" aria-label="Breadcrumb">
                <ol class="inline-flex items-center space-x-2">
                    <li><a href="/" class="hover:text-slate-900 transition-colors">Home</a></li>
                    <li><span class="mx-1 text-slate-300">/</span></li>
                    <li><a href="/radon-levels/${county.getStateSlug()}" class="hover:text-slate-900 transition-colors uppercase">${county.getStateAbbr()}</a></li>
                    <li><span class="mx-1 text-slate-300">/</span></li>
                    <li class="text-slate-900 font-semibold" aria-current="page">${county.getAreaDisplayName()}</li>
                </ol>
            </nav>

            <!-- Hero Section -->
            <div class="rounded-3xl bg-gradient-to-br from-slate-900 via-slate-800 to-slate-900 p-6 sm:p-10 mb-10 relative overflow-hidden">
                <div class="absolute inset-0 opacity-5" style="background-image: url('data:image/svg+xml,%3Csvg width=&quot;60&quot; height=&quot;60&quot; viewBox=&quot;0 0 60 60&quot; xmlns=&quot;http://www.w3.org/2000/svg&quot;%3E%3Cg fill=&quot;none&quot; fill-rule=&quot;evenodd&quot;%3E%3Cg fill=&quot;%23ffffff&quot; fill-opacity=&quot;1&quot;%3E%3Cpath d=&quot;M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z&quot;/%3E%3C/g%3E%3C/g%3E%3C/svg%3E');"></div>

                <div class="relative z-10">
                    <div class="mb-6 flex flex-wrap gap-2">
                        <div class="inline-flex items-center gap-2 px-3 py-1.5 rounded-full text-xs font-bold uppercase tracking-wider
                            @if(officialEvidenceSerpCounty && highOfficialEvidence) bg-red-500/20 text-red-300
                            @elseif(officialEvidenceSerpCounty) bg-sky-500/20 text-sky-200
                            @elseif(county.getEpaZone() == 1) bg-red-500/20 text-red-300
                            @elseif(county.getEpaZone() == 2) bg-amber-500/20 text-amber-300
                            @elseif(county.getEpaZone() == 3) bg-emerald-500/20 text-emerald-300
                            @else bg-slate-500/20 text-slate-200
                            @endif
                        ">
                            <span class="w-2 h-2 rounded-full
                                @if(officialEvidenceSerpCounty && highOfficialEvidence) bg-red-400
                                @elseif(officialEvidenceSerpCounty) bg-sky-300
                                @elseif(county.getEpaZone() == 1) bg-red-400
                                @elseif(county.getEpaZone() == 2) bg-amber-400
                                @elseif(county.getEpaZone() == 3) bg-emerald-400
                                @else bg-slate-300
                                @endif
                            "></span>
                            @if(officialEvidenceSerpCounty)
                                ${evidenceBadgeLabel}
                            @else
                                EPA Zone ${county.getEpaZone() > 0 ? Integer.toString(county.getEpaZone()) : "Unclassified"} -
                                @if(county.getEpaZone() == 1) High Risk
                                @elseif(county.getEpaZone() == 2) Moderate Risk
                                @elseif(county.getEpaZone() == 3) Low Risk
                                @else Data Pending
                                @endif
                            @endif
                        </div>
                        @if(officialEvidenceSerpCounty)
                            <div class="inline-flex items-center gap-2 rounded-full bg-white/10 px-3 py-1.5 text-xs font-bold uppercase tracking-wider text-slate-200">
                                EPA Zone ${county.getEpaZone() > 0 ? Integer.toString(county.getEpaZone()) : "Unclassified"} context
                            </div>
                        @endif
                    </div>

                    <div class="grid grid-cols-1 lg:grid-cols-[minmax(0,1.1fr)_minmax(0,0.9fr)] gap-6 items-start">
                        <div class="min-w-0">
                            <h1 class="font-display font-black text-white leading-[0.98] mb-5 break-words" style="font-size: clamp(2rem, 10vw, 3.5rem);">${heroTitle}</h1>

                            <p class="text-base sm:text-lg text-slate-300 leading-relaxed max-w-3xl" itemscope itemtype="https://schema.org/Answer" itemprop="text">
                                <strong class="text-white">${directAnswerLead}</strong>
                                @if(introIntentLead != null)
                                    ${introIntentLead}
                                @endif
                                ${heroQuickEvidenceRead}
                            </p>

                            <div class="mt-6 flex flex-col sm:flex-row gap-3">
                                <a href="#situation-picker"
                                   data-track-event="levels_primary_jump_click"
                                   data-track-label="hero_jump"
                                   class="inline-flex items-center justify-center gap-2 px-5 py-3 rounded-2xl bg-white text-slate-900 text-sm font-black hover:bg-slate-100 transition-colors shadow-lg">
                                    Pick My Next Step
                                </a>
                                <a href="/guides/how-to-test-for-radon"
                                   data-track-event="levels_test_guide_click"
                                   data-track-label="hero_primary"
                                   class="inline-flex items-center justify-center gap-2 px-5 py-3 rounded-2xl border border-white/20 text-white text-sm font-bold hover:bg-white/10 transition-colors">
                                    I Need to Test First
                                </a>
                            </div>
                        </div>

                        <div class="levels-county-hero-quick-read min-w-0 rounded-[1.75rem] border border-white/15 bg-white/10 backdrop-blur-sm p-5 sm:p-6 shadow-2xl">
                            <div class="text-xs font-bold uppercase tracking-[0.18em] text-sky-200 mb-3">Quick Read</div>
                            <h2 class="font-display font-black text-2xl text-white leading-tight mb-3">${quickDecisionHeading}</h2>
                            <p class="text-sm sm:text-base text-slate-200 leading-relaxed">${quickDecisionBody}</p>

                            <div class="mt-5 space-y-3">
                                <div class="rounded-2xl border border-white/10 bg-slate-950/20 p-3">
                                    <div class="text-[11px] font-bold uppercase tracking-[0.18em] text-slate-300">County signal</div>
                                    <p class="mt-1 text-sm font-semibold text-white leading-snug">${countySignalSummary}</p>
                                </div>
                                <div class="rounded-2xl border border-white/10 bg-slate-950/20 p-3">
                                    <div class="text-[11px] font-bold uppercase tracking-[0.18em] text-slate-300">What the number changes</div>
                                    <p class="mt-1 text-sm font-semibold text-white leading-snug">${thresholdSummary}</p>
                                </div>
                                <div class="rounded-2xl border border-white/10 bg-slate-950/20 p-3">
                                    <div class="text-[11px] font-bold uppercase tracking-[0.18em] text-slate-300">Fastest next move</div>
                                    <p class="mt-1 text-sm font-semibold text-white leading-snug">${fastMoveSummary}</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    @if(radonEvidence != null)
                        <div id="county-evidence-first" class="levels-evidence-reading-block mt-8 rounded-[1.75rem] bg-white p-4 sm:p-6 shadow-2xl border border-white/10">
                            <div class="flex flex-col gap-3 lg:flex-row lg:items-start lg:justify-between">
                                <div>
                                    <p class="text-xs font-bold uppercase tracking-[0.18em] text-slate-500">
                                        @if(hasRadonMeasurement) Measured Radon Data
                                        @else Official County Evidence
                                        @endif
                                    </p>
                                    <h2 class="mt-2 font-display text-2xl font-black text-slate-900">${county.getAreaDisplayName()} evidence before the next step</h2>
                                    <p class="mt-2 max-w-3xl text-sm leading-relaxed text-slate-600">
                                        @if(radonEvidence.getWhyThisPageExists() != null && !radonEvidence.getWhyThisPageExists().isBlank())
                                            ${radonEvidence.getWhyThisPageExists()}
                                        @else
                                            ${evidenceFirstSourceHeading} is shown before calculators or cost paths so the page starts with source context, then turns that context into a home-specific next step.
                                        @endif
                                    </p>
                                </div>
                                <div class="rounded-2xl border border-slate-100 bg-slate-50 px-4 py-3">
                                    <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Source window</p>
                                    <p class="mt-1 text-sm font-black text-slate-900">${evidenceFirstPeriodDisplay}</p>
                                </div>
                            </div>

                            <div class="mt-5 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-4">
                                <div class="rounded-2xl border border-slate-100 bg-slate-50 p-4">
                                    <p class="text-xs font-bold uppercase tracking-wider text-slate-500">County evidence type</p>
                                    <p class="mt-2 font-display text-xl font-black text-slate-900">${radonEvidence.getRiskBand()}</p>
                                    <p class="mt-1 text-xs text-slate-500">County context only; your home test controls the decision.</p>
                                </div>
                                <div class="rounded-2xl border border-slate-100 bg-slate-50 p-4">
                                    <p class="text-xs font-bold uppercase tracking-wider text-slate-500">
                                        @if(highEndOnlyRadonMeasurement) Highest measured
                                        @else Primary result
                                        @endif
                                    </p>
                                    <p class="mt-2 font-display text-xl font-black text-slate-900">${radonEvidence.getPrimaryAverageDisplay()}</p>
                                    <p class="mt-1 text-xs text-slate-500">
                                        @if(highEndOnlyRadonMeasurement) ${radonEvidence.getHighEndPercentileDisplay()} in-state
                                        @else ${radonEvidence.getAveragePercentileDisplay()} in-state
                                        @endif
                                    </p>
                                </div>
                                <div class="rounded-2xl border border-slate-100 bg-slate-50 p-4">
                                    <p class="text-xs font-bold uppercase tracking-wider text-slate-500">4.0+ signal</p>
                                    <p class="mt-2 font-display text-xl font-black text-slate-900">${radonEvidence.getAbove4Display()}</p>
                                    <p class="mt-1 text-xs text-slate-500">${radonEvidence.getAbove4PercentileDisplay()} in-state</p>
                                </div>
                                <div class="rounded-2xl border border-slate-100 bg-slate-50 p-4">
                                    <p class="text-xs font-bold uppercase tracking-wider text-slate-500">High-end signal</p>
                                    <p class="mt-2 font-display text-xl font-black text-slate-900">${radonEvidence.getHighEndDisplay()}</p>
                                    <p class="mt-1 text-xs text-slate-500">${radonEvidence.getHighEndPercentileDisplay()} in-state</p>
                                </div>
                            </div>

                            <div class="mt-5 rounded-2xl border border-slate-200 bg-slate-50 p-4 sm:p-5">
                                <div class="flex flex-col gap-3 lg:flex-row lg:items-start lg:justify-between">
                                    <div>
                                        <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Official evidence dossier</p>
                                        <h3 class="mt-2 font-display text-xl font-black text-slate-950">Source record for ${county.getAreaDisplayName()}, ${county.getStateAbbr()}</h3>
                                        <p class="mt-2 max-w-3xl text-sm leading-relaxed text-slate-700">${evidenceDossierSourceSummary}</p>
                                    </div>
                                    <a href="${evidenceSourceLinkUrl}"
                                       target="_blank"
                                       rel="noopener"
                                       data-track-event="levels_official_source_click"
                                       data-track-label="evidence_dossier_source"
                                       class="inline-flex shrink-0 items-center justify-center rounded-xl border border-slate-300 bg-white px-4 py-3 text-sm font-black text-slate-900 hover:border-slate-500 transition-colors">
                                        ${evidenceSourceLinkLabel}
                                    </a>
                                </div>

                                <div class="mt-5 grid grid-cols-1 gap-3 md:grid-cols-4">
                                    <div>
                                        <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Primary public source</p>
                                        <p class="mt-1 text-sm font-black text-slate-900">${evidenceDossierSourceLabel}</p>
                                    </div>
                                    <div>
                                        <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Measurement window</p>
                                        <p class="mt-1 text-sm font-black text-slate-900">${evidenceFirstPeriodDisplay}</p>
                                    </div>
                                    <div>
                                        <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Retrieved / checked</p>
                                        <p class="mt-1 text-sm font-black text-slate-900">${evidenceRetrievedDisplay}</p>
                                    </div>
                                    <div>
                                        <p class="text-xs font-bold uppercase tracking-wider text-slate-500">County FIPS</p>
                                        <p class="mt-1 text-sm font-black text-slate-900">${county.getFips()}</p>
                                    </div>
                                </div>

                                <div class="mt-5 rounded-2xl border border-slate-200 bg-white p-4">
                                    <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Evidence stack</p>
                                    <div class="mt-3 grid grid-cols-1 gap-3 md:grid-cols-2 xl:grid-cols-4">
                                        <a href="${evidenceSourceLinkUrl}"
                                           target="_blank"
                                           rel="noopener"
                                           data-track-event="levels_official_source_click"
                                           data-track-label="evidence_stack_primary"
                                           class="rounded-xl border border-slate-200 bg-slate-50 p-3 hover:border-slate-400 transition-colors">
                                            <p class="text-xs font-bold uppercase tracking-wider text-slate-500">County source</p>
                                            <p class="mt-1 text-sm font-black text-slate-950">${evidenceDossierSourceLabel}</p>
                                            <p class="mt-1 text-xs leading-relaxed text-slate-600">Primary source used for the county evidence row.</p>
                                        </a>
                                        <a href="${epaZoneMapUrl}"
                                           target="_blank"
                                           rel="noopener"
                                           data-track-event="levels_official_source_click"
                                           data-track-label="evidence_stack_epa_zone"
                                           class="rounded-xl border border-slate-200 bg-slate-50 p-3 hover:border-slate-400 transition-colors">
                                            <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Federal map</p>
                                            <p class="mt-1 text-sm font-black text-slate-950">EPA Map of Radon Zones</p>
                                            <p class="mt-1 text-xs leading-relaxed text-slate-600">Zone ${county.getEpaZone() > 0 ? Integer.toString(county.getEpaZone()) : "?"} is context, not a property result.</p>
                                        </a>
                                        <a href="${censusAcsUrl}"
                                           target="_blank"
                                           rel="noopener"
                                           data-track-event="levels_official_source_click"
                                           data-track-label="evidence_stack_census"
                                           class="rounded-xl border border-slate-200 bg-slate-50 p-3 hover:border-slate-400 transition-colors">
                                            <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Housing context</p>
                                            <p class="mt-1 text-sm font-black text-slate-950">US Census ACS housing context</p>
                                            <p class="mt-1 text-xs leading-relaxed text-slate-600">${olderHomeDisplay} built before 1980; ${totalHousingUnitsDisplay} housing units.</p>
                                        </a>
                                        <a href="${stateProgramUrl}"
                                           target="_blank"
                                           rel="noopener"
                                           data-track-event="levels_official_source_click"
                                           data-track-label="evidence_stack_state_program"
                                           class="rounded-xl border border-slate-200 bg-slate-50 p-3 hover:border-slate-400 transition-colors">
                                            <p class="text-xs font-bold uppercase tracking-wider text-slate-500">State follow-up</p>
                                            <p class="mt-1 text-sm font-black text-slate-950">State radon program</p>
                                            <p class="mt-1 text-xs leading-relaxed text-slate-600">Use the state source before hiring or interpreting local rules.</p>
                                        </a>
                                    </div>
                                </div>

                                <div class="mt-5 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-4">
                                    <div class="rounded-xl border border-white bg-white p-3">
                                        <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Primary field</p>
                                        <p class="mt-1 text-sm font-black text-slate-900">${radonEvidence.getPrimaryAverageDisplay()}</p>
                                    </div>
                                    <div class="rounded-xl border border-white bg-white p-3">
                                        <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Median field</p>
                                        <p class="mt-1 text-sm font-black text-slate-900">${radonEvidence.getMedianDisplay()}</p>
                                    </div>
                                    <div class="rounded-xl border border-white bg-white p-3">
                                        <p class="text-xs font-bold uppercase tracking-wider text-slate-500">4.0+ field</p>
                                        <p class="mt-1 text-sm font-black text-slate-900">${radonEvidence.getAbove4Display()}</p>
                                    </div>
                                    <div class="rounded-xl border border-white bg-white p-3">
                                        <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Sample / volume</p>
                                        <p class="mt-1 text-sm font-black text-slate-900">${radonEvidence.getTestVolumeDisplay()}</p>
                                    </div>
                                </div>

                                <div class="mt-5 grid grid-cols-1 gap-3 lg:grid-cols-3">
                                    <div>
                                        <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Metric shape</p>
                                        <p class="mt-1 text-sm leading-relaxed text-slate-700">${radonEvidence.getMetricShapeSummary()}</p>
                                    </div>
                                    <div>
                                        <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Source limitation</p>
                                        <p class="mt-1 text-sm leading-relaxed text-slate-700">${evidenceCaveatDisplay}</p>
                                    </div>
                                    <div>
                                        <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Property-level limit</p>
                                        <p class="mt-1 text-sm leading-relaxed text-slate-700">Not a property-level diagnosis. The county record explains local evidence; your home's own test result controls the next decision.</p>
                                    </div>
                                </div>
                            </div>

                            @if(radonEvidence.getDecisionHeadline() != null && !radonEvidence.getDecisionHeadline().isBlank())
                                <div class="mt-5 grid grid-cols-1 gap-3 lg:grid-cols-3">
                                    <div class="rounded-2xl border border-slate-200 bg-slate-50 p-4 lg:col-span-2">
                                        <p class="text-xs font-bold uppercase tracking-wider text-slate-500">County-specific interpretation</p>
                                        <h3 class="mt-2 font-display text-xl font-black text-slate-950">${radonEvidence.getDecisionHeadline()}</h3>
                                        <p class="mt-2 text-sm leading-relaxed text-slate-700">${radonEvidence.getLocalDecisionSummary()}</p>
                                    </div>
                                    <div class="rounded-2xl border border-slate-200 bg-slate-50 p-4">
                                        <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Real-estate use</p>
                                        <p class="mt-2 text-sm leading-relaxed text-slate-700">${radonEvidence.getRealEstateDecisionSummary()}</p>
                                    </div>
                                </div>
                            @endif

                            <div class="mt-5 grid grid-cols-1 gap-3 lg:grid-cols-[minmax(0,1fr)_auto] lg:items-center">
                                <p class="text-sm leading-relaxed text-slate-700">${radonEvidence.getRecommendedAction()}</p>
                                <a href="#situation-picker"
                                   data-track-event="levels_evidence_next_step_click"
                                   data-track-label="evidence_first"
                                   class="inline-flex items-center justify-center rounded-xl border border-slate-900 bg-slate-900 px-4 py-3 text-sm font-black text-white hover:bg-slate-800 transition-colors">
                                    Use This Evidence
                                </a>
                            </div>

                            <div class="mt-5 grid grid-cols-1 gap-3 md:grid-cols-3">
                                <a href="${stateProgramUrl}"
                                   target="_blank"
                                   rel="noopener"
                                   data-track-event="levels_official_source_click"
                                   data-track-label="state_program"
                                   class="rounded-2xl border border-slate-200 bg-white p-4 hover:border-slate-300 hover:bg-slate-50 transition-colors">
                                    <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Official state path</p>
                                    <p class="mt-2 text-sm font-black text-slate-950">Open the state radon program</p>
                                    <p class="mt-1 text-xs leading-relaxed text-slate-600">Use state rules and local program contacts before choosing a contractor.</p>
                                </a>
                                <a href="${epaQualifiedProviderUrl}"
                                   target="_blank"
                                   rel="noopener"
                                   data-track-event="levels_official_source_click"
                                   data-track-label="epa_provider_guidance"
                                   class="rounded-2xl border border-slate-200 bg-white p-4 hover:border-slate-300 hover:bg-slate-50 transition-colors">
                                    <p class="text-xs font-bold uppercase tracking-wider text-slate-500">EPA hiring guidance</p>
                                    <p class="mt-2 text-sm font-black text-slate-950">Find a qualified radon provider</p>
                                    <p class="mt-1 text-xs leading-relaxed text-slate-600">EPA points homeowners to state programs and national proficiency listings.</p>
                                </a>
                                <a href="${nrppProSearchUrl}"
                                   target="_blank"
                                   rel="noopener"
                                   data-track-event="levels_official_source_click"
                                   data-track-label="nrpp_pro_search"
                                   class="rounded-2xl border border-slate-200 bg-white p-4 hover:border-slate-300 hover:bg-slate-50 transition-colors">
                                    <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Certified professional search</p>
                                    <p class="mt-2 text-sm font-black text-slate-950">Search NRPP-certified pros</p>
                                    <p class="mt-1 text-xs leading-relaxed text-slate-600">Use this after you have a valid result or need professional testing.</p>
                                </a>
                            </div>

                            @if(radonEvidence.getIntentQuestion() != null && !radonEvidence.getIntentQuestion().isBlank())
                                <div class="mt-4 rounded-2xl border border-slate-200 bg-slate-50 p-4">
                                    <p class="text-xs font-bold uppercase tracking-wider text-slate-500">${radonEvidence.getIntentLabel()}</p>
                                    <h3 class="mt-2 font-display text-lg font-black text-slate-950">${radonEvidence.getIntentQuestion()}</h3>
                                    <p class="mt-2 text-sm leading-relaxed text-slate-700">${radonEvidence.getIntentAnswer()}</p>
                                </div>
                            @endif
                        </div>
                    @endif

                    @template.components.radon_result_translator(
                        county = county,
                        countySignalSummary = countySignalSummary,
                        measuredPrimaryResultDisplay = measuredPrimaryResultDisplay,
                        measuredPercentAbove4Display = measuredPercentAbove4Display
                    )
                    @template.components.search_intent_router(county = county, className = "mt-8")

                    <div id="situation-picker" class="mt-8 rounded-[1.75rem] bg-white p-5 sm:p-6 shadow-2xl border border-white/10">
                        <div class="flex flex-col gap-2 sm:flex-row sm:items-end sm:justify-between mb-5">
                            <div>
                                <div class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-slate-100 text-slate-700 text-xs font-bold tracking-wider uppercase mb-3">
                                    Fastest Path
                                </div>
                                <h2 class="font-display font-black text-2xl text-slate-900 leading-tight">Pick the situation that matches you</h2>
                                <p class="mt-2 text-sm text-slate-600 leading-relaxed max-w-2xl">
                                    You should not need to read the whole guide before clicking one of these. Start with the lane that matches your current stage, then come back for the deeper reference only if you still need it.
                                </p>
                            </div>
                            <p class="text-sm text-slate-500 leading-relaxed max-w-sm">${decisionFlowIntro}</p>
                        </div>

                        <div class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-3">
                            <div class="rounded-2xl border border-emerald-200 bg-emerald-50 p-4 flex flex-col">
                                <div class="text-xs font-bold uppercase tracking-wider text-emerald-700">No reading yet</div>
                                <h3 class="mt-2 font-display font-bold text-lg text-slate-900">I have not tested yet</h3>
                                <p class="mt-2 text-sm text-slate-700 leading-relaxed">
                                    Do not price mitigation blind. Get the first number, then decide whether you need monitoring, quotes, or nothing at all.
                                </p>
                                <div class="mt-4 flex flex-col gap-2">
                                    <a href="/guides/how-to-test-for-radon"
                                       data-track-event="levels_test_guide_click"
                                       data-track-label="situation_not_tested_primary"
                                       class="inline-flex items-center justify-center gap-2 px-4 py-3 rounded-xl bg-emerald-600 text-white text-sm font-bold hover:bg-emerald-700 transition-colors">
                                        Read the testing guide first
                                    </a>
                                    <a href="${stateProgramUrl}"
                                       target="_blank"
                                       rel="noopener"
                                       data-track-event="levels_official_source_click"
                                       data-track-label="situation_state_program"
                                       class="inline-flex items-center justify-center gap-2 px-4 py-3 rounded-xl border border-emerald-200 text-emerald-800 text-sm font-bold hover:bg-emerald-100 transition-colors">
                                        Check your state radon program
                                    </a>
                                </div>
                            </div>

                            <a href="/guides/how-to-test-for-radon"
                               data-track-event="levels_test_guide_click"
                               data-track-label="borderline_result"
                               class="rounded-2xl border border-amber-200 bg-amber-50 p-4 hover:border-amber-300 hover:bg-amber-100 transition-colors flex flex-col">
                                <div class="text-xs font-bold uppercase tracking-wider text-amber-700">2.0-3.9 pCi/L</div>
                                <h3 class="mt-2 font-display font-bold text-lg text-slate-900">My result is 2.0-3.9</h3>
                                <p class="mt-2 text-sm text-slate-700 leading-relaxed flex-1">
                                    Usually confirm the reading first. If it keeps showing up, use the county evidence and official guidance before deciding whether pricing makes sense.
                                </p>
                                <div class="mt-4 inline-flex items-center justify-between gap-3 text-sm font-semibold text-slate-900">
                                    <span>${borderlineResultCta}</span>
                                    <svg class="w-4 h-4 text-amber-700 shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                                        <path stroke-linecap="round" stroke-linejoin="round" d="M9 5l7 7-7 7" />
                                    </svg>
                                </div>
                            </a>

                            <a href="/radon-mitigation-cost/${county.getStateSlug()}/${county.getCountySlug()}?radonResultBand=above_4&intent=homeowner#estimate-form"
                               data-track-event="levels_result_path_click"
                               data-track-label="high_result"
                               class="rounded-2xl border border-red-200 bg-red-50 p-4 hover:border-red-300 hover:bg-red-100 transition-colors flex flex-col">
                                <div class="text-xs font-bold uppercase tracking-wider text-red-700">4.0+ pCi/L</div>
                                <h3 class="mt-2 font-display font-bold text-lg text-slate-900">My result is 4.0+</h3>
                                <p class="mt-2 text-sm text-slate-700 leading-relaxed flex-1">
                                    This is the EPA action line. Use the local cost page before calling contractors so you know the likely scope, timing, and budget.
                                </p>
                                <div class="mt-4 inline-flex items-center justify-between gap-3 text-sm font-semibold text-slate-900">
                                    <span>${highResultCta}</span>
                                    <svg class="w-4 h-4 text-red-700 shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                                        <path stroke-linecap="round" stroke-linejoin="round" d="M9 5l7 7-7 7" />
                                    </svg>
                                </div>
                            </a>

                            <a href="/radon-credit-calculator/${county.getStateSlug()}/${county.getCountySlug()}?radonResultBand=above_4&intent=buying"
                               data-track-event="levels_result_path_click"
                               data-track-label="buyer_seller_path"
                               class="rounded-2xl border border-blue-200 bg-blue-50 p-4 hover:border-blue-300 hover:bg-blue-100 transition-colors flex flex-col">
                                <div class="text-xs font-bold uppercase tracking-wider text-blue-700">Buying or selling</div>
                                <h3 class="mt-2 font-display font-bold text-lg text-slate-900">I am buying or selling</h3>
                                <p class="mt-2 text-sm text-slate-700 leading-relaxed flex-1">
                                    Turn the reading into a credit or repair number before negotiation starts. This is the faster path than arguing from a generic article.
                                </p>
                                <div class="mt-4 inline-flex items-center justify-between gap-3 text-sm font-semibold text-slate-900">
                                    <span>${buyerSellerResultCta}</span>
                                    <svg class="w-4 h-4 text-blue-700 shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                                        <path stroke-linecap="round" stroke-linejoin="round" d="M9 5l7 7-7 7" />
                                    </svg>
                                </div>
                            </a>
                        </div>

                        <div class="mt-5 pt-4 border-t border-slate-200 flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
                            <p class="text-xs text-slate-500 leading-relaxed">Already tested once and need the cleanest follow-up path?</p>
                            <a href="/guides/how-to-test-for-radon"
                               data-track-event="levels_test_guide_click"
                               data-track-label="situation_followup_link"
                               class="inline-flex items-center gap-2 text-sm font-bold text-indigo-700 hover:text-indigo-900 transition-colors">
                                Review retesting steps
                                <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                                    <path stroke-linecap="round" stroke-linejoin="round" d="M17.25 8.25L21 12m0 0l-3.75 3.75M21 12H3" />
                                </svg>
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            @if(gscServiceIntentCounty || gscSurvivorNearMissCounty)
                <section id="search-intent-bridge" class="mb-10 rounded-[1.75rem] border border-slate-200 bg-white p-5 sm:p-6 shadow-sm">
                    <div class="grid gap-6 lg:grid-cols-[0.78fr_1.22fr] lg:items-start">
                        <div>
                            <p class="text-xs font-bold uppercase tracking-[0.18em] text-slate-500">
                                @if(gscServiceIntentCounty) Local Service Search Bridge
                                @else Near-Miss County Playbook
                                @endif
                            </p>
                            <h2 class="mt-2 font-display text-2xl font-black tracking-tight text-slate-950">
                                @if(gscServiceIntentCounty)
                                    Searched for ${gscQueryCluster}?
                                @else
                                    This county gets the short route first.
                                @endif
                            </h2>
                            <p class="mt-3 text-sm leading-relaxed text-slate-600">
                                @if(gscServiceIntentCounty)
                                    ${serviceBridgeSummary}
                                    RadonVerdict is not a contractor directory. It turns the search into a decision: get or confirm the reading, open the local cost path after 4.0+, then record any real quote so the benchmark gets less generic.
                                @else
                                    Search Console already showed enough signal to keep this page focused. The fastest useful answer is whether the visitor needs a first test, a retest, a local cost range, or seller-credit math.
                                @endif
                            </p>
                            @if(gscServiceIntentCounty)
                                <div class="mt-4 grid gap-3">
                                    <div class="rounded-2xl border border-emerald-200 bg-emerald-50 p-4">
                                        <p class="text-xs font-bold uppercase tracking-[0.16em] text-emerald-700">${providerSearchPackHeading}</p>
                                        <p class="mt-2 text-sm font-semibold leading-relaxed text-emerald-950">
                                            ${providerSearchPackBody}
                                        </p>
                                    </div>
                                    <div class="rounded-2xl border border-indigo-200 bg-indigo-50 p-4">
                                        <p class="text-xs font-bold uppercase tracking-[0.16em] text-indigo-700">Provider lookup</p>
                                        <p class="mt-2 text-sm leading-relaxed text-indigo-950">
                                            Use the official state radon program and EPA provider guidance to verify licensing or certification before treating any local service listing as enough.
                                        </p>
                                        <div class="mt-3 flex flex-col gap-2 sm:flex-row">
                                            <a href="${stateProgramUrl}" target="_blank" rel="noopener nofollow" class="inline-flex text-xs font-black uppercase tracking-wider text-indigo-700 hover:underline">State radon program</a>
                                            <a href="${epaQualifiedProviderUrl}" target="_blank" rel="noopener nofollow" class="inline-flex text-xs font-black uppercase tracking-wider text-indigo-700 hover:underline">EPA provider guidance</a>
                                        </div>
                                    </div>
                                </div>
                                <div class="mt-4 rounded-2xl border border-slate-200 bg-slate-50 p-4">
                                    <p class="text-xs font-bold uppercase tracking-[0.16em] text-slate-500">Local call script</p>
                                    <p class="mt-2 text-sm font-semibold leading-relaxed text-slate-800">
                                        I have a radon result of ___ pCi/L in ${county.getAreaDisplayName()}, ${county.getStateAbbr()}. Before I compare quotes, can you confirm what foundation and suction method your price assumes, whether sump or crawl-space work is included, and how the post-mitigation retest will be documented?
                                    </p>
                                </div>
                            @endif
                        </div>
                        <div class="divide-y divide-slate-200 rounded-2xl border border-slate-200 bg-slate-50">
                            <a href="/guides/how-to-test-for-radon"
                               data-track-event="levels_intent_bridge_click"
                               data-track-label="testing_guide"
                               class="grid gap-2 p-4 transition-colors hover:bg-white sm:grid-cols-[0.24fr_0.76fr]">
                                <span class="text-xs font-black uppercase tracking-wider text-emerald-700">Test</span>
                                <span>
                                    <span class="block text-sm font-black text-slate-950">Confirm the reading before the money step</span>
                                    <span class="mt-1 block text-sm leading-relaxed text-slate-600">Use the testing guide if there is no valid short-term, long-term, or continuous monitor result yet.</span>
                                </span>
                            </a>
                            <a href="/radon-mitigation-cost/${county.getStateSlug()}/${county.getCountySlug()}?radonResultBand=above_4&intent=homeowner#estimate-form"
                               data-track-event="levels_intent_bridge_click"
                               data-track-label="cost_path"
                               class="grid gap-2 p-4 transition-colors hover:bg-white sm:grid-cols-[0.24fr_0.76fr]">
                                <span class="text-xs font-black uppercase tracking-wider text-red-700">4.0+</span>
                                <span>
                                    <span class="block text-sm font-black text-slate-950">Open the local cost path before calling contractors</span>
                                    <span class="mt-1 block text-sm leading-relaxed text-slate-600">This keeps the conversation anchored to county evidence, foundation type, and actual result band.</span>
                                </span>
                            </a>
                            <a href="/guides/radon-mitigation-quote-checklist"
                               data-track-event="levels_intent_bridge_click"
                               data-track-label="quote_checklist"
                               class="grid gap-2 p-4 transition-colors hover:bg-white sm:grid-cols-[0.24fr_0.76fr]">
                                <span class="text-xs font-black uppercase tracking-wider text-slate-700">Call</span>
                                <span>
                                    <span class="block text-sm font-black text-slate-950">Use the contractor quote checklist before the call</span>
                                    <span class="mt-1 block text-sm leading-relaxed text-slate-600">Ask about foundation, suction method, fan, permit, warranty, retest, and exclusions before comparing prices.</span>
                                </span>
                            </a>
                            <a href="/radon-quote-ledger#quote-checker"
                               data-track-event="levels_intent_bridge_click"
                               data-track-label="quote_checker"
                               class="grid gap-2 p-4 transition-colors hover:bg-white sm:grid-cols-[0.24fr_0.76fr]">
                                <span class="text-xs font-black uppercase tracking-wider text-indigo-700">Quote</span>
                                <span>
                                    <span class="block text-sm font-black text-slate-950">Check if the contractor quote is fair</span>
                                    <span class="mt-1 block text-sm leading-relaxed text-slate-600">Screen price, foundation scope, fan, warranty, permit, sealing, and retest before adding an anonymized signal.</span>
                                </span>
                            </a>
                        </div>
                    </div>
                </section>
            @endif

            <div class="mobile-sticky-cta levels-mobile-sticky-cta fixed bottom-4 right-4 z-40 lg:hidden" data-nosnippet>
                <a href="#situation-picker"
                   data-track-event="levels_mobile_jump_click"
                   data-track-label="sticky_picker"
                   class="inline-flex items-center gap-2 rounded-full border border-slate-800 bg-slate-950/95 px-4 py-3 text-sm font-black text-white shadow-2xl backdrop-blur transition-transform active:scale-95">
                    Pick My Next Step
                    <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M13.5 4.5L21 12m0 0l-7.5 7.5M21 12H3" />
                    </svg>
                </a>
            </div>
            <script>
                document.addEventListener('DOMContentLoaded', () => {
                    const stickyCta = document.querySelector('.levels-mobile-sticky-cta');
                    const evidenceBlocks = Array.from(document.querySelectorAll(
                        '.levels-county-hero-quick-read, .levels-evidence-reading-block, .levels-result-tool'));
                    if (!stickyCta || evidenceBlocks.length === 0 || !('IntersectionObserver' in window)) {
                        return;
                    }
                    const visibleBlocks = new Set();
                    const observer = new IntersectionObserver((entries) => {
                        entries.forEach((entry) => {
                            if (entry.isIntersecting) {
                                visibleBlocks.add(entry.target);
                            } else {
                                visibleBlocks.delete(entry.target);
                            }
                        });
                        stickyCta.classList.toggle('levels-mobile-sticky-cta--hidden', visibleBlocks.size > 0);
                    }, {
                        root: null,
                        rootMargin: '0px 0px -10% 0px',
                        threshold: 0.04
                    });
                    evidenceBlocks.forEach((block) => observer.observe(block));
                });
            </script>

            <section class="mb-10 rounded-[1.75rem] border border-slate-200 bg-white p-5 sm:p-6 shadow-sm">
                <div class="flex flex-col gap-3 md:flex-row md:items-start md:justify-between">
                    <div>
                        <p class="text-xs font-bold uppercase tracking-[0.18em] text-slate-500">County Evidence Snapshot</p>
                        <h2 class="mt-2 font-display text-2xl font-black text-slate-900">${county.getAreaDisplayName()} testing context</h2>
                    </div>
                    <div class="rounded-full border px-3 py-1 text-xs font-bold
                        @if(priorityCounty) border-indigo-200 bg-indigo-50 text-indigo-700
                        @else border-slate-200 bg-slate-50 text-slate-600
                        @endif
                    ">
                        ${priorityDisplay}
                    </div>
                </div>

                <p class="mt-4 max-w-3xl text-sm leading-relaxed text-slate-700">${countyEvidenceSummary}</p>

                <div class="mt-6 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-4">
                    <div class="rounded-2xl border border-slate-200 bg-slate-50 p-4">
                        <p class="text-xs font-bold uppercase tracking-wider text-slate-500">EPA map signal</p>
                        <p class="mt-2 font-display text-2xl font-black text-slate-900">Zone ${county.getEpaZone() > 0 ? Integer.toString(county.getEpaZone()) : "?"}</p>
                        <p class="mt-1 text-xs leading-relaxed text-slate-500">County-level predicted indoor screening range, not a home-level test result.</p>
                    </div>
                    <div class="rounded-2xl border border-slate-200 bg-slate-50 p-4">
                        <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Housing base</p>
                        <p class="mt-2 font-display text-2xl font-black text-slate-900">${totalHousingUnitsDisplay}</p>
                        <p class="mt-1 text-xs leading-relaxed text-slate-500">${housingPercentileDisplay} percentile among ${statePeerCountyCount} ${county.getStateAbbr()} counties with data.</p>
                    </div>
                    <div class="rounded-2xl border border-slate-200 bg-slate-50 p-4">
                        <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Older housing share</p>
                        <p class="mt-2 font-display text-2xl font-black text-slate-900">${olderHomeDisplay}</p>
                        <p class="mt-1 text-xs leading-relaxed text-slate-500">${olderHomePercentileDisplay} percentile in-state; older homes often need clearer test placement decisions.</p>
                    </div>
                    <div class="rounded-2xl border border-slate-200 bg-slate-50 p-4">
                        <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Median home value</p>
                        <p class="mt-2 font-display text-2xl font-black text-slate-900">${medianHomeValueDisplay}</p>
                        <p class="mt-1 text-xs leading-relaxed text-slate-500">Used as context for whether mitigation is a small maintenance item or a negotiation issue.</p>
                    </div>
                </div>

                @if(hasRadonMeasurement)
                    <div class="mt-5 rounded-[1.5rem] border border-sky-200 bg-sky-50 p-4 sm:p-5">
                        <div class="flex flex-col gap-2 md:flex-row md:items-start md:justify-between">
                            <div>
                                <p class="text-xs font-bold uppercase tracking-[0.18em] text-sky-700">Measured Radon Data</p>
                                <h3 class="mt-1 font-display text-xl font-black text-slate-900">${radonMeasurement.getSourceName()}</h3>
                            </div>
                            <p class="text-xs font-bold text-sky-800">${radonMeasurement.getPeriod()}</p>
                        </div>

                        <div class="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2 lg:grid-cols-4">
                            <div class="rounded-2xl border border-sky-100 bg-white p-4">
                                <p class="text-xs font-bold uppercase tracking-wider text-slate-500">${measuredPrimaryResultLabel}</p>
                                <p class="mt-2 font-display text-2xl font-black text-slate-900">${measuredPrimaryResultDisplay}</p>
                            </div>
                            <div class="rounded-2xl border border-sky-100 bg-white p-4">
                                <p class="text-xs font-bold uppercase tracking-wider text-slate-500">At or above 4.0</p>
                                <p class="mt-2 font-display text-2xl font-black text-slate-900">${measuredPercentAbove4Display}</p>
                            </div>
                            <div class="rounded-2xl border border-sky-100 bg-white p-4">
                                <p class="text-xs font-bold uppercase tracking-wider text-slate-500">${measuredHighEndLabel}</p>
                                <p class="mt-2 font-display text-2xl font-black text-slate-900">${measuredHighEndDisplay}</p>
                            </div>
                            <div class="rounded-2xl border border-sky-100 bg-white p-4">
                                <p class="text-xs font-bold uppercase tracking-wider text-slate-500">${measuredTestVolumeLabel}</p>
                                <p class="mt-2 font-display text-2xl font-black text-slate-900">${measuredAverageTestsDisplay}</p>
                            </div>
                        </div>

                        @if(!"Not available".equals(measuredMedianDisplay) || !"Not available".equals(measuredPercentAbove2Display))
                            <div class="mt-3 rounded-2xl border border-sky-100 bg-white p-4 text-sm leading-relaxed text-slate-700">
                                @if(!"Not available".equals(measuredMedianDisplay))
                                    <span class="font-semibold text-slate-900">Median result:</span> ${measuredMedianDisplay}.
                                @endif
                                @if(!"Not available".equals(measuredPercentAbove2Display))
                                    <span class="font-semibold text-slate-900">At or above 2.0 pCi/L:</span> ${measuredPercentAbove2Display}.
                                @endif
                            </div>
                        @endif

                        @if(hasPaFloorBreakdown)
                            <div class="mt-3 rounded-2xl border border-sky-100 bg-white p-4 text-sm leading-relaxed text-slate-700">
                                <span class="font-semibold text-slate-900">PA DEP floor rollup:</span>
                                basement average ${measuredBasementAverageDisplay} from ${measuredBasementTestsDisplay} tests;
                                first-floor average ${measuredFirstFloorAverageDisplay} from ${measuredFirstFloorTestsDisplay} tests.
                            </div>
                        @endif

                        <p class="mt-4 text-xs leading-relaxed text-sky-900">
                            ${radonMeasurement.getCaveat()}
                        </p>
                    </div>
                @endif

                @if(radonEvidence != null)
                    <div class="levels-evidence-reading-block mt-5 rounded-[1.5rem] border p-3 sm:p-5
                        @if("high".equals(radonEvidence.getRiskTone())) border-red-200 bg-red-50
                        @elseif("elevated".equals(radonEvidence.getRiskTone())) border-orange-200 bg-orange-50
                        @elseif("borderline".equals(radonEvidence.getRiskTone())) border-amber-200 bg-amber-50
                        @elseif("lower".equals(radonEvidence.getRiskTone())) border-emerald-200 bg-emerald-50
                        @else border-slate-200 bg-slate-50
                        @endif
                    ">
                        <div class="flex flex-col gap-3 lg:flex-row lg:items-start lg:justify-between">
                            <div>
                                <p class="text-xs font-bold uppercase tracking-[0.18em] text-slate-600">County evidence interpretation</p>
                                <h3 class="mt-1 font-display text-xl font-black text-slate-950">${radonEvidence.getRiskBand()}</h3>
                            </div>
                            <div class="flex flex-wrap gap-2">
                                <span class="rounded-full border border-white/70 bg-white/80 px-3 py-1 text-xs font-black text-slate-800">
                                    Source-backed context
                                </span>
                                <span class="rounded-full border border-white/70 bg-white/80 px-3 py-1 text-xs font-black text-slate-800">
                                    Not a home-specific result
                                </span>
                            </div>
                        </div>

                        <div class="mt-4 grid grid-cols-1 gap-3 sm:grid-cols-2 xl:grid-cols-4">
                            <div class="rounded-2xl border border-white/80 bg-white/80 p-4">
                                <p class="text-xs font-bold uppercase tracking-wider text-slate-500">
                                    @if(highEndOnlyRadonMeasurement) High-end rank
                                    @else Primary result rank
                                    @endif
                                </p>
                                <p class="mt-2 font-display text-xl font-black text-slate-900">
                                    @if(highEndOnlyRadonMeasurement) ${radonEvidence.getHighEndPercentileDisplay()}
                                    @else ${radonEvidence.getAveragePercentileDisplay()}
                                    @endif
                                </p>
                                <p class="mt-1 text-xs text-slate-500">
                                    @if(highEndOnlyRadonMeasurement) ${radonEvidence.getHighEndDisplay()}
                                    @else ${radonEvidence.getPrimaryAverageDisplay()}
                                    @endif
                                </p>
                            </div>
                            <div class="rounded-2xl border border-white/80 bg-white/80 p-4">
                                <p class="text-xs font-bold uppercase tracking-wider text-slate-500">4.0+ rank</p>
                                <p class="mt-2 font-display text-xl font-black text-slate-900">${radonEvidence.getAbove4PercentileDisplay()}</p>
                                <p class="mt-1 text-xs text-slate-500">${radonEvidence.getAbove4Display()} at or above 4.0</p>
                            </div>
                            <div class="rounded-2xl border border-white/80 bg-white/80 p-4">
                                <p class="text-xs font-bold uppercase tracking-wider text-slate-500">High-end rank</p>
                                <p class="mt-2 font-display text-xl font-black text-slate-900">${radonEvidence.getHighEndPercentileDisplay()}</p>
                                <p class="mt-1 text-xs text-slate-500">${radonEvidence.getHighEndDisplay()}</p>
                            </div>
                            <div class="rounded-2xl border border-white/80 bg-white/80 p-4">
                                <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Test volume rank</p>
                                <p class="mt-2 font-display text-xl font-black text-slate-900">${radonEvidence.getTestVolumePercentileDisplay()}</p>
                                <p class="mt-1 text-xs text-slate-500">${radonEvidence.getTestVolumeDisplay()}</p>
                            </div>
                        </div>

                        @if(radonEvidence.getSourceProfileLabel() != null && !radonEvidence.getSourceProfileLabel().isBlank())
                            <div class="mt-4 rounded-2xl border border-white/80 bg-white/70 p-3 sm:p-4">
                                <p class="text-sm font-bold text-slate-950">How to use this county data</p>
                                <div class="mt-3 grid grid-cols-1 gap-2 sm:gap-3 lg:grid-cols-2">
                                    <div class="rounded-xl border border-white/80 bg-white/80 p-3">
                                        <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Data source</p>
                                        <p class="mt-1 text-sm font-black text-slate-900">${radonEvidence.getSourceProfileLabel()}</p>
                                        <p class="mt-2 text-xs leading-relaxed text-slate-600">${radonEvidence.getSourceProfileSummary()}</p>
                                    </div>
                                    <div class="rounded-xl border border-white/80 bg-white/80 p-3">
                                        <p class="text-xs font-bold uppercase tracking-wider text-slate-500">What the numbers show</p>
                                        <p class="mt-1 text-sm font-black text-slate-900">${radonEvidence.getMetricShapeLabel()}</p>
                                        <p class="mt-2 text-xs leading-relaxed text-slate-600">${radonEvidence.getMetricShapeSummary()}</p>
                                    </div>
                                    <div class="rounded-xl border border-white/80 bg-white/80 p-3">
                                        <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Nearby comparison</p>
                                        <p class="mt-2 text-xs leading-relaxed text-slate-600">${radonEvidence.getPeerComparisonSummary()}</p>
                                    </div>
                                    <div class="rounded-xl border border-white/80 bg-white/80 p-3">
                                        <p class="text-xs font-bold uppercase tracking-wider text-slate-500">How this helps</p>
                                        <p class="mt-2 text-xs leading-relaxed text-slate-600">${radonEvidence.getIntentMatchSummary()}</p>
                                    </div>
                                </div>
                            </div>
                        @endif

                        <div class="mt-4 grid grid-cols-1 gap-3 lg:grid-cols-2">
                            <div class="rounded-2xl border border-white/80 bg-white/80 p-4">
                                <p class="text-sm font-bold text-slate-950">What the data says</p>
                                <p class="mt-2 text-sm leading-relaxed text-slate-700">${radonEvidence.getMeasuredBurdenSummary()}</p>
                                <p class="mt-2 text-sm leading-relaxed text-slate-700">${radonEvidence.getStateComparisonSummary()}</p>
                            </div>
                            <div class="rounded-2xl border border-white/80 bg-white/80 p-4">
                                <p class="text-sm font-bold text-slate-950">What to do with it</p>
                                <p class="mt-2 text-sm leading-relaxed text-slate-700">${radonEvidence.getRecommendedAction()}</p>
                                @if(radonEvidence.getRetestTriggerSummary() != null && !radonEvidence.getRetestTriggerSummary().isBlank())
                                    <p class="mt-2 text-sm leading-relaxed text-slate-700">${radonEvidence.getRetestTriggerSummary()}</p>
                                @endif
                                <p class="mt-2 text-xs leading-relaxed text-slate-500">${radonEvidence.getConfidenceSummary()}</p>
                            </div>
                        </div>

                        <div class="mt-4 grid grid-cols-1 gap-3 md:grid-cols-3">
                            <div class="rounded-2xl border border-white/80 bg-white/80 p-4">
                                <p class="text-xs font-bold uppercase tracking-wider text-emerald-700">No reading yet</p>
                                <p class="mt-2 text-sm leading-relaxed text-slate-700">${radonEvidence.getNoReadingAction()}</p>
                            </div>
                            <div class="rounded-2xl border border-white/80 bg-white/80 p-4">
                                <p class="text-xs font-bold uppercase tracking-wider text-amber-700">2.0-3.9 result</p>
                                <p class="mt-2 text-sm leading-relaxed text-slate-700">${radonEvidence.getBorderlineAction()}</p>
                            </div>
                            <div class="rounded-2xl border border-white/80 bg-white/80 p-4">
                                <p class="text-xs font-bold uppercase tracking-wider text-red-700">4.0+ result</p>
                                <p class="mt-2 text-sm leading-relaxed text-slate-700">${radonEvidence.getElevatedAction()}</p>
                            </div>
                        </div>

                        <p class="mt-4 text-xs leading-relaxed text-slate-600">${radonEvidence.getSourceCoverageSummary()}</p>
                    </div>
                @endif
            </section>

            @if(aeo != null)
                @template.components.aeo_answer_block(block = aeo)
            @endif

            <!-- Main Two-Column Layout -->
            <div class="grid grid-cols-1 lg:grid-cols-12 gap-10 mb-20">

                <!-- LEFT: Interactive Radon Level Checker + Info -->
                <div class="lg:col-span-7">

                    <!-- Radon Level Analyzer (Reused component with enhanced context) -->
                    @template.components.radon_level_advisor(county = county, radonMeasurement = radonMeasurement, radonEvidence = radonEvidence)

                    <!-- What the Numbers Mean - Educational Section -->
                    <div class="bg-white rounded-[2rem] p-6 sm:p-8 shadow-sm border border-slate-200 mt-6" data-nosnippet>
                        <h2 class="font-display font-bold text-xl text-slate-900 mb-6">Understanding Radon Levels: Complete Reference</h2>

                        <div class="space-y-4">
                            <!-- Tier 1: Below 2.0 -->
                            <div class="flex gap-4 items-start p-4 rounded-xl bg-emerald-50 border border-emerald-100">
                                <div class="w-12 h-12 rounded-xl bg-emerald-500 text-white flex items-center justify-center shrink-0 font-display font-bold text-xs px-1">
                                    &lt;2.0
                                </div>
                                <div>
                                    <h3 class="font-bold text-emerald-900 text-sm">Below 2.0 pCi/L - Lower Concern, Keep Testing</h3>
                                    <p class="text-xs text-emerald-800 leading-relaxed mt-1">
                                        Below both the EPA (4.0) and WHO (2.7) action reference levels. This usually means mitigation is not the next immediate step after a confirmed result. The average outdoor radon level
                                        is approximately 0.4 pCi/L, and there is no known risk-free indoor level. Periodic testing is still recommended because levels can change over time due to
                                        seasonal variations, changes in home ventilation, or foundation settling.
                                    </p>
                                </div>
                            </div>

                            <!-- Tier 2: 2.0 - 4.0 -->
                            <div class="flex gap-4 items-start p-4 rounded-xl bg-amber-50 border border-amber-100">
                                <div class="w-12 h-12 rounded-xl bg-amber-500 text-white flex items-center justify-center shrink-0 font-display font-bold text-xs px-1 text-center leading-tight">
                                    2.0<br>-4.0
                                </div>
                                <div>
                                    <h3 class="font-bold text-amber-900 text-sm">2.0 - 4.0 pCi/L - Elevated, Consider Action</h3>
                                    <p class="text-xs text-amber-800 leading-relaxed mt-1">
                                        Exceeds the World Health Organization's reference level of 2.7 pCi/L but falls below the US EPA action threshold.
                                        The EPA states that homeowners should <em>"consider fixing"</em> homes in this range, especially if the home has a basement
                                        used as living space, if children are present, or in connection with a real estate transaction.
                                        Practical next step: run a confirmatory long-term test, then compare mitigation quotes if levels remain elevated.
                                    </p>
                                </div>
                            </div>

                            <!-- Tier 3: 4.0 - 8.0 -->
                            <div class="flex gap-4 items-start p-4 rounded-xl bg-red-50 border border-red-100">
                                <div class="w-12 h-12 rounded-xl bg-red-500 text-white flex items-center justify-center shrink-0 font-display font-bold text-xs px-1 text-center leading-tight">
                                    4.0<br>-8.0
                                </div>
                                <div>
                                    <h3 class="font-bold text-red-900 text-sm">4.0 - 8.0 pCi/L - Action Recommended</h3>
                                    <p class="text-xs text-red-800 leading-relaxed mt-1">
                                        Exceeds the EPA action level of 4.0 pCi/L. The EPA and Surgeon General strongly recommend mitigation within a few months.
                                        At this level, prioritize confirmatory testing and contractor planning. Standard sub-slab depressurization
                                        systems typically reduce indoor levels by 80-99%.
                                    </p>
                                </div>
                            </div>

                            <!-- Tier 4: Above 8.0 -->
                            <div class="flex gap-4 items-start p-4 rounded-xl bg-red-100 border border-red-200">
                                <div class="w-12 h-12 rounded-xl bg-red-700 text-white flex items-center justify-center shrink-0 font-display font-bold text-xs px-1">
                                    8.0+
                                </div>
                                <div>
                                    <h3 class="font-bold text-red-900 text-sm">Above 8.0 pCi/L - Urgent Action Required</h3>
                                    <p class="text-xs text-red-800 leading-relaxed mt-1">
                                        At these levels, the EPA recommends expedited mitigation - ideally within weeks, not months.
                                        Occupants should minimize time in lower-level rooms until the system is installed.
                                        Use a certified mitigator and request priority scheduling to shorten high-exposure time.
                                        Many mitigators offer priority scheduling for homes above 8.0 pCi/L.
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Geological Context - Zone-Specific Unique Content -->
                    <div class="bg-white rounded-[2rem] p-6 sm:p-8 shadow-sm border border-slate-200 mt-6" data-nosnippet>
                        <h2 class="font-display font-bold text-xl text-slate-900 mb-4">Why Radon is
                            @if(!nextStepCtrLiftCounty && (highOfficialEvidence || elevatedOfficialEvidence))
                                a Testing Priority
                            @elseif(county.getEpaZone() == 1)
                                a Serious Concern
                            @elseif(county.getEpaZone() == 2)
                                Worth Monitoring
                            @elseif(county.getEpaZone() == 3)
                                Still Relevant
                            @else
                                Worth Testing
                            @endif
                            in ${county.getAreaDisplayName()}
                        </h2>

                        @if(!nextStepCtrLiftCounty && (highOfficialEvidence || elevatedOfficialEvidence))
                            <p class="text-sm text-slate-700 leading-relaxed mb-4">
                                The EPA map is only the starting layer for ${county.getAreaDisplayName()}. ${evidenceMetricBrief.trim()}
                                That source-backed signal is why the practical move is testing or retesting before treating the county as low urgency.
                            </p>
                            <p class="text-sm text-slate-700 leading-relaxed mb-4">
                                This still is not a diagnosis for any single home. Foundation type, lowest-level use, pressure differences,
                                and small geological changes can move one house above or below the county pattern.
                            </p>
                            <p class="text-sm text-slate-700 leading-relaxed">
                                If you do not have a reading yet, start with a short-term test in the lowest lived-in level. If the result is
                                2.0-3.9 pCi/L, confirm it; if it is 4.0+ pCi/L, move into mitigation pricing or seller-credit planning.
                            </p>
                        @elseif(county.getEpaZone() == 1)
                            <p class="text-sm text-slate-700 leading-relaxed mb-4">
                                ${county.getAreaDisplayName()} sits in a geological region with elevated uranium concentrations in the underlying bedrock and soil.
                                As uranium naturally decays, it produces radium, which further decays into radon gas. This gas migrates upward through soil
                                and enters homes through foundation cracks, gaps around pipes, and sump pits.
                            </p>
                            <p class="text-sm text-slate-700 leading-relaxed mb-4">
                                In Zone 1 counties like ${county.getCountyName()}, the EPA predicts indoor screening levels are commonly above
                                4.0 pCi/L. Individual homes can still vary dramatically - even neighboring houses can differ by a factor of 10 or more.
                                This is why <strong>every home needs its own test</strong>, regardless of what a neighbor's reading shows.
                            </p>
                            <p class="text-sm text-slate-700 leading-relaxed">
                                Factors that amplify radon entry include: basement foundations (more soil contact area), granitic or shale bedrock,
                                tight energy-efficient construction (less natural ventilation), and negative indoor air pressure from HVAC systems,
                                exhaust fans, and dryers.
                            </p>
                        @elseif(county.getEpaZone() == 2)
                            <p class="text-sm text-slate-700 leading-relaxed mb-4">
                                ${county.getAreaDisplayName()} falls in EPA Zone 2, where the predicted indoor screening range is
                                between 2.0 and 4.0 pCi/L. Even when the countywide map signal sits below the EPA action level,
                                geological variability means that some individual homes will still test above 4.0 pCi/L.
                            </p>
                            <p class="text-sm text-slate-700 leading-relaxed mb-4">
                                The soil composition in this area typically includes a mix of sedimentary formations that can contain moderate
                                uranium deposits. Homes with basement or crawlspace foundations are particularly susceptible, as they provide
                                more pathways for soil gas entry.
                            </p>
                            <p class="text-sm text-slate-700 leading-relaxed">
                                The World Health Organization recommends action at 2.7 pCi/L - well below the US EPA threshold.
                                If you have children, spend significant time in below-grade rooms, or are buying/selling a home,
                                testing is essential even in a Zone 2 area.
                            </p>
                        @elseif(county.getEpaZone() == 3)
                            <p class="text-sm text-slate-700 leading-relaxed mb-4">
                                ${county.getAreaDisplayName()} is classified as EPA Zone 3, with a lower predicted indoor screening range below 2.0 pCi/L.
                                This does <strong>not</strong> mean radon is absent - it means the countywide map signal is low.
                            </p>
                            <p class="text-sm text-slate-700 leading-relaxed mb-4">
                                The EPA has documented elevated radon readings in every state and in homes in every zone classification.
                                Local geological anomalies - pockets of granite, shale intrusions, or fractured bedrock - can create
                                localized high-radon areas even within an otherwise low-risk county.
                            </p>
                            <p class="text-sm text-slate-700 leading-relaxed">
                                The Surgeon General and EPA recommend testing all homes, regardless of geographic zone.
                                A simple short-term test kit ($15-$30) provides results within a few days and can give you peace of mind.
                            </p>
                        @else
                            <p class="text-sm text-slate-700 leading-relaxed mb-4">
                                ${county.getAreaDisplayName()} currently has no published EPA zone assignment in our source dataset.
                                This does <strong>not</strong> mean the county is low risk or radon free.
                            </p>
                            <p class="text-sm text-slate-700 leading-relaxed mb-4">
                                Missing classification can happen due to source-data gaps, mapping updates, or jurisdiction edge cases.
                                Radon risk is still home specific and can vary significantly by foundation type, ventilation, and underlying geology.
                            </p>
                            <p class="text-sm text-slate-700 leading-relaxed">
                                The EPA and Surgeon General recommend testing all homes regardless of county zone status.
                                Start with a short-term test kit and follow up with confirmatory testing if your result is elevated.
                            </p>
                        @endif
                    </div>

                    <!-- Health Impact Section -->
                    <div class="bg-white rounded-[2rem] p-6 sm:p-8 shadow-sm border border-slate-200 mt-6" data-nosnippet>
                        <h2 class="font-display font-bold text-xl text-slate-900 mb-4">Radon & Health: What the Science Says</h2>

                        <div class="grid grid-cols-1 sm:grid-cols-3 gap-4 mb-6">
                            <div class="text-center p-4 rounded-xl bg-slate-50 border border-slate-100">
                                <div class="font-display font-black text-3xl text-slate-900">#2</div>
                                <div class="text-xs text-slate-500 font-semibold mt-1">Leading cause of<br>lung cancer</div>
                            </div>
                            <div class="text-center p-4 rounded-xl bg-slate-50 border border-slate-100">
                                <div class="font-display font-black text-3xl text-slate-900">21K</div>
                                <div class="text-xs text-slate-500 font-semibold mt-1">US deaths per year<br>from radon</div>
                            </div>
                            <div class="text-center p-4 rounded-xl bg-slate-50 border border-slate-100">
                                <div class="font-display font-black text-3xl text-slate-900">1 in 15</div>
                                <div class="text-xs text-slate-500 font-semibold mt-1">US homes above<br>4.0 pCi/L</div>
                            </div>
                        </div>

                        <p class="text-sm text-slate-700 leading-relaxed mb-4">
                            Radon is a Class A carcinogen - the same classification as asbestos and tobacco smoke.
                            The National Academy of Sciences estimates that radon causes approximately 21,000 lung cancer deaths
                            annually in the United States, making it the leading environmental cause of cancer death.
                        </p>
                        <p class="text-sm text-slate-700 leading-relaxed">
                            Unlike smoking, radon exposure is involuntary and often invisible. There is no safe level of radon -
                            risk increases linearly with exposure. The good news: radon mitigation systems are highly effective,
                            typically reducing indoor levels by 80-99% within hours of activation.
                        </p>

                        <div class="mt-6 p-4 rounded-xl bg-indigo-50 border border-indigo-100">
                            <p class="text-xs text-indigo-800 font-semibold">
                                Source: US Environmental Protection Agency, "A Citizen's Guide to Radon" (EPA 402/K-12/002).
                                National Academy of Sciences, Biological Effects of Ionizing Radiation (BEIR VI) Report, 1999.
                            </p>
                        </div>
                    </div>
                </div>

                <!-- RIGHT: Sticky Action Panel -->
                <div class="lg:col-span-5">
                    <div class="sticky top-24 space-y-6">

                        <!-- CTA Card 1: Test Your Home -->
                        <div class="bg-white rounded-[2rem] p-6 sm:p-8 shadow-sm border border-slate-200">
                            <div class="flex items-center gap-3 mb-4">
                                <div class="w-10 h-10 rounded-xl bg-indigo-600 text-white flex items-center justify-center">
                                    <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                                        <path stroke-linecap="round" stroke-linejoin="round" d="M9.75 17L9 20l-1 1h8l-1-1-.75-3M3 13h18M5 17h14a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                                    </svg>
                                </div>
                                <h3 class="font-display font-bold text-lg text-slate-900">Step 1: Test Your Home</h3>
                            </div>

                            <p class="text-sm text-slate-600 leading-relaxed mb-5">
                                Testing is the <strong>only</strong> way to know your home's radon level. Zone and county data tell you the regional signal,
                                but your home could be significantly higher or lower than the countywide pattern. Start with a valid test setup before using any cost path.
                            </p>

                            <div class="space-y-4">
                                <a href="/guides/how-to-test-for-radon"
                                   data-track-event="levels_test_guide_click"
                                   data-track-label="sticky_primary_card"
                                   class="flex items-center justify-between w-full px-4 py-3 rounded-xl bg-slate-900 text-white hover:bg-slate-800 transition-colors group">
                                    <div>
                                        <div class="text-xs font-bold uppercase tracking-wider text-slate-400">Testing first</div>
                                        <div class="mt-1 text-sm font-bold">Open the home testing guide</div>
                                        <div class="text-xs text-slate-400">Short-term, long-term, retest, and real-estate setup</div>
                                    </div>
                                    <svg class="w-4 h-4 text-slate-400 group-hover:translate-x-1 transition-transform" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                                        <path stroke-linecap="round" stroke-linejoin="round" d="M17.25 8.25L21 12m0 0l-3.75 3.75M21 12H3" />
                                    </svg>
                                </a>
                                <div class="rounded-xl border border-slate-200 bg-slate-50 p-4">
                                    <div class="text-xs font-bold uppercase tracking-wider text-slate-500">Need the official path?</div>
                                    <p class="mt-1 text-sm text-slate-600 leading-relaxed">
                                        State radon programs and EPA provider guidance are the right reference before hiring or confirming local requirements.
                                    </p>
                                    <a href="${stateProgramUrl}"
                                       target="_blank" rel="noopener"
                                       data-track-event="levels_official_source_click"
                                       data-track-label="sticky_state_program"
                                       class="inline-flex items-center gap-2 mt-3 text-sm font-bold text-indigo-700 hover:text-indigo-900 transition-colors">
                                        Open the state radon program
                                        <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                                            <path stroke-linecap="round" stroke-linejoin="round" d="M17.25 8.25L21 12m0 0l-3.75 3.75M21 12H3" />
                                        </svg>
                                    </a>
                                </div>
                            </div>
                        </div>

                        <!-- CTA Card 2: Already Have Results? Go to Cost Calculator -->
                        <div class="bg-gradient-to-br from-indigo-600 to-indigo-700 rounded-[2rem] p-6 sm:p-8 shadow-lg text-white">
                            <h3 class="font-display font-bold text-lg mb-3">Already Know Your Level?</h3>
                            <p class="text-sm text-indigo-100 leading-relaxed mb-5">
                                If your test shows 4.0 pCi/L or higher, get an itemized cost estimate specific to
                                ${county.getAreaDisplayName()} - including regional labor rates and permit requirements.
                            </p>
                            <a href="/radon-mitigation-cost/${county.getStateSlug()}/${county.getCountySlug()}"
                               class="flex items-center justify-center gap-2 w-full py-3.5 rounded-xl bg-white text-indigo-700 font-bold text-sm hover:bg-indigo-50 transition-colors shadow-sm">
                                <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
                                    <path stroke-linecap="round" stroke-linejoin="round" d="M9 7h6m0 10v-3m-3 3h.01M9 17h.01M9 14h.01M12 14h.01M15 11h.01M12 11h.01M9 11h.01M7 21h10a2 2 0 002-2V5a2 2 0 00-2-2H7a2 2 0 00-2 2v14a2 2 0 002 2z" />
                                </svg>
                                Get Mitigation Cost Estimate ->
                            </a>
                        </div>

                        <!-- State Regulation Box -->
                        @if(stateRule != null)
                        <div class="bg-white rounded-[2rem] p-6 shadow-sm border border-slate-200">
                            <h3 class="font-display font-bold text-sm text-slate-900 mb-3">${county.getStateAbbr()} Radon Regulations</h3>

                            <div class="space-y-3">
                                <div class="flex items-start gap-3">
                                    <div class="w-6 h-6 rounded-full shrink-0 flex items-center justify-center text-xs
                                        ${stateRule.isDisclosureRequired() ? "bg-amber-100 text-amber-600" : "bg-slate-100 text-slate-400"}">
                                        ${stateRule.isDisclosureRequired() ? "!" : "-"}
                                    </div>
                                    <div>
                                        <div class="text-xs font-bold text-slate-700">Seller Disclosure</div>
                                        <p class="text-xs text-slate-500 leading-relaxed mt-0.5">
                                            ${stateRule.getDisclosureSummary()}
                                        </p>
                                    </div>
                                </div>

                                <div class="flex items-start gap-3">
                                    <div class="w-6 h-6 rounded-full shrink-0 flex items-center justify-center text-xs
                                        ${stateRule.isLicenseRequired() ? "bg-indigo-100 text-indigo-600" : "bg-slate-100 text-slate-400"}">
                                        ${stateRule.isLicenseRequired() ? "yes" : "-"}
                                    </div>
                                    <div>
                                        <div class="text-xs font-bold text-slate-700">Professional Licensing</div>
                                        <p class="text-xs text-slate-500 leading-relaxed mt-0.5">
                                            ${stateRule.getLicenseNote()}
                                        </p>
                                    </div>
                                </div>
                            </div>

                            <a href="${stateRule.getStateProgramUrl()}" target="_blank" rel="noopener nofollow"
                               class="inline-flex items-center text-xs font-bold text-indigo-600 hover:text-indigo-800 mt-4 uppercase tracking-wider transition-colors">
                                Official state radon program
                                <svg class="w-3 h-3 ml-1" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" /></svg>
                            </a>
                        </div>
                        @endif

                    </div>
                </div>
            </div>
            @if(monetizationHooksEnabled)
                @template.components.monetization_hooks(countyName = county.getCountyName(), stateAbbr = county.getStateAbbr())
            @endif

            <!-- How to Test Section -->
            <div class="border-t border-slate-200 pt-16 mb-20">
                <h2 class="font-display font-bold text-2xl text-slate-900 mb-8 text-center">How to Test for Radon in ${county.getAreaDisplayName()}</h2>

                <div class="grid grid-cols-1 md:grid-cols-3 gap-6 max-w-4xl mx-auto">
                    <div class="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm text-center">
                        <div class="w-12 h-12 rounded-xl bg-indigo-100 text-indigo-600 flex items-center justify-center mx-auto mb-4">
                            <span class="font-display font-bold">1</span>
                        </div>
                        <h3 class="font-bold text-slate-900 mb-2">Buy a Test Kit</h3>
                        <p class="text-sm text-slate-600 leading-relaxed">
                            Purchase a short-term charcoal test kit online or from a local hardware store.
                            Cost: $15-$30. Place it in the lowest livable level of your home.
                        </p>
                    </div>
                    <div class="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm text-center">
                        <div class="w-12 h-12 rounded-xl bg-indigo-100 text-indigo-600 flex items-center justify-center mx-auto mb-4">
                            <span class="font-display font-bold">2</span>
                        </div>
                        <h3 class="font-bold text-slate-900 mb-2">Wait 2-7 Days</h3>
                        <p class="text-sm text-slate-600 leading-relaxed">
                            Keep doors and windows closed (except normal entry/exit) during the test period.
                            Avoid running whole-house fans. Mail the kit to the lab provided.
                        </p>
                    </div>
                    <div class="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm text-center">
                        <div class="w-12 h-12 rounded-xl bg-indigo-100 text-indigo-600 flex items-center justify-center mx-auto mb-4">
                            <span class="font-display font-bold">3</span>
                        </div>
                        <h3 class="font-bold text-slate-900 mb-2">Read Your Results</h3>
                        <p class="text-sm text-slate-600 leading-relaxed">
                            If results are <strong>below 4.0 pCi/L</strong>, re-test every 2 years or use a monitor for ongoing tracking.
                            If <strong>above 4.0</strong>, use our
                            <a href="/radon-mitigation-cost/${county.getStateSlug()}/${county.getCountySlug()}"
                               class="text-indigo-600 font-semibold hover:underline">cost calculator</a>
                            to see mitigation options.
                        </p>
                    </div>
                </div>
            </div>

            @template.components.related_links(
                title = "Related Radon Resources for " + county.getAreaDisplayName(),
                links = relatedLinks
            )

            <!-- Explore Other Counties -->
            @if(nearbyCounties != null && !nearbyCounties.isEmpty())
            <div class="border-t border-slate-200 pt-16 mb-10">
                <h3 class="font-display font-bold text-2xl text-slate-900 mb-6">Explore Other ${county.getStateAbbr()} Counties</h3>
                <div class="grid grid-cols-2 md:grid-cols-3 gap-4">
                    @for(var nearby : nearbyCounties)
                        <a href="/radon-levels/${nearby.getStateSlug()}/${nearby.getCountySlug()}"
                           class="block p-4 rounded-xl border border-slate-200 bg-white hover:border-indigo-300 hover:shadow-md transition-all group">
                            <span class="block font-bold text-slate-800 group-hover:text-indigo-600 transition-colors">${nearby.getCountyName()}</span>
                            <span class="text-xs text-slate-500 mt-1">Zone ${nearby.getEpaZone() > 0 ? Integer.toString(nearby.getEpaZone()) : "Unclassified"} -
                                @if(nearby.getEpaZone() == 1) High Risk
                                @elseif(nearby.getEpaZone() == 2) Moderate
                                @elseif(nearby.getEpaZone() == 3) Low Risk
                                @else Data Pending
                                @endif
                            </span>
                        </a>
                    @endfor
                </div>
            </div>
            @endif

            @if(stateRule != null)
                @template.components.state_radon_resources(
                    stateName = stateName,
                    stateAbbr = county.getStateAbbr(),
                    stateProgramUrl = stateRule.getStateProgramUrl(),
                    disclosureRequired = stateRule.isDisclosureRequired(),
                    disclosureSummary = stateRule.getDisclosureSummary(),
                    licenseRequired = stateRule.isLicenseRequired(),
                    licenseNote = stateRule.getLicenseNote(),
                    className = "mt-20 mb-10"
                )
            @endif

            <!-- Sources & Disclaimers -->
            <div class="border-t border-slate-200 pt-16 mb-10 text-sm text-slate-500">
                <h3 class="font-display font-bold text-xl text-slate-900 mb-4">Sources & Methodology</h3>
                <p class="mb-4">
                    Radon zone classifications for ${county.getAreaDisplayName()} are sourced from the EPA's Map of Radon Zones,
                    which uses geological surveys, indoor radon measurements, and soil permeability data to assign each county a risk tier.
                </p>
                <ul class="space-y-2 pl-4 mb-6">
                    <li class="relative before:content-['*'] before:absolute before:-left-4 before:text-slate-300">
                        <a href="https://www.epa.gov/radon/epa-map-radon-zones" target="_blank" rel="nofollow noopener" class="text-indigo-600 hover:underline">EPA Map of Radon Zones</a>
                    </li>
                    <li class="relative before:content-['*'] before:absolute before:-left-4 before:text-slate-300">
                        <a href="https://www.epa.gov/radon" target="_blank" rel="nofollow noopener" class="text-indigo-600 hover:underline">EPA Radon Home Page</a>
                    </li>
                    <li class="relative before:content-['*'] before:absolute before:-left-4 before:text-slate-300">
                        <a href="https://www.who.int/publications/i/item/9789241547673" target="_blank" rel="nofollow noopener" class="text-indigo-600 hover:underline">WHO Handbook on Indoor Radon</a>
                    </li>
                </ul>
                <p class="text-xs text-slate-400">
                    <strong>Disclaimer:</strong> Zone data represents county-level screening ranges and cannot predict the radon level in any specific home.
                    Testing is the only reliable method to determine your home's radon concentration. This content is for informational purposes
                    and is not medical advice.
                </p>
                <p class="mt-4 text-xs text-slate-400 font-medium">
                    Content review:
                    ${trust != null && trust.getLastReviewed() != null && !trust.getLastReviewed().isBlank() ? trust.getLastReviewed() : "Source-level retrieval dates"}
                </p>
            </div>
            @if(trust != null)
                @template.components.trust_metadata(trust = trust, quality = quality, showDebug = showSeoDebug)
            @endif

        </div>
    `
)

