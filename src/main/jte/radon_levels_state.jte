@import com.radonverdict.model.County
@import com.radonverdict.model.StateRegulations.StateRule
@import com.radonverdict.model.dto.RadonEvidenceCoverageSummary
@import com.radonverdict.model.dto.RadonStateEvidenceInsight
@import java.util.List

@param String stateSlug
@param String stateAbbr
@param StateRule stateRule = null
@param List<County> counties
@param long zone1Count = 0
@param long zone2Count = 0
@param long zone3Count = 0
@param RadonEvidenceCoverageSummary evidenceCoverage = null
@param RadonStateEvidenceInsight stateEvidenceInsight = null
@param boolean noindex = false

!{
    String[] stateSlugParts = stateSlug.split("-");
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
    final String stateName = stateNameBuilder.length() > 0 ? stateNameBuilder.toString() : stateAbbr;
    final boolean priorityCtrState = "montana".equals(stateSlug);
    final String seoTitle = priorityCtrState
            ? stateName + " Radon Map by County | EPA Zones, Levels & Basement Testing"
            : stateName + " Radon Map, Levels & Testing Guide by County (" + java.time.LocalDate.now().getYear() + ") | EPA 4.0 pCi/L";
    final String seoDescription = priorityCtrState
            ? "Use the " + stateName + " radon map by county to check EPA zones, see what 2.0 vs 4.0+ pCi/L basement test results mean, and decide when mitigation pricing is worth checking."
            : "Check the " + stateName + " radon map by county, see what 2.0 to 8.0+ pCi/L readings mean, and decide when home testing or mitigation quotes make sense.";
    final String heroTitle = priorityCtrState
            ? stateName + " Radon Map by County, EPA Zones & Basement Testing"
            : stateName + " Radon Map, Levels & Testing Guide";
    final String heroIntro = priorityCtrState
            ? "Check county-by-county EPA radon zones across " + stateName + ". Start with your county if you want to know what a basement result means at 2.0 vs 4.0+ pCi/L before you price mitigation."
            : "View EPA radon zone classifications for every county in " + stateName + ". Open your county to compare basement test meaning, EPA action thresholds, and when mitigation pricing becomes worth checking.";
}

@template.layout.main(
    title = seoTitle,
    description = seoDescription,
    canonicalUrl = "https://radonverdict.com/radon-levels/" + stateSlug,
    noindex = noindex,
    content = @`
        <div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-10">

            <!-- Breadcrumb -->
            <nav class="text-sm font-medium text-slate-500 mb-8" aria-label="Breadcrumb">
                <ol class="inline-flex items-center space-x-2">
                    <li><a href="/" class="hover:text-slate-900 transition-colors">Home</a></li>
                    <li><span class="mx-1 text-slate-300">/</span></li>
                    <li><a href="/radon-levels" class="hover:text-slate-900 transition-colors">Radon Levels</a></li>
                    <li><span class="mx-1 text-slate-300">/</span></li>
                    <li class="text-slate-900 font-semibold" aria-current="page">${stateName} Radon Map</li>
                </ol>
            </nav>

            <!-- Hero -->
            <div class="text-center mb-12">
                <div class="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-slate-100 text-xs font-bold text-slate-600 uppercase tracking-widest mb-6">
                    <span class="w-2 h-2 rounded-full bg-indigo-500"></span>
                    EPA Zone Data ${java.time.LocalDate.now().getYear()}
                </div>

                <h1 class="font-display font-black text-3xl sm:text-5xl text-slate-900 mb-4">${heroTitle}</h1>
                <p class="text-lg text-slate-600 max-w-2xl mx-auto">
                    ${heroIntro}
                </p>
            </div>

            <!-- Zone Breakdown Stats -->
            <div class="grid grid-cols-3 gap-4 max-w-xl mx-auto mb-12">
                <div class="text-center p-4 rounded-2xl bg-red-50 border border-red-100">
                    <div class="font-display font-black text-2xl text-red-600">${zone1Count}</div>
                    <div class="text-xs font-bold text-red-500 uppercase tracking-wider mt-1">Zone 1<br>High Risk</div>
                </div>
                <div class="text-center p-4 rounded-2xl bg-amber-50 border border-amber-100">
                    <div class="font-display font-black text-2xl text-amber-600">${zone2Count}</div>
                    <div class="text-xs font-bold text-amber-500 uppercase tracking-wider mt-1">Zone 2<br>Moderate</div>
                </div>
                <div class="text-center p-4 rounded-2xl bg-emerald-50 border border-emerald-100">
                    <div class="font-display font-black text-2xl text-emerald-600">${zone3Count}</div>
                    <div class="text-xs font-bold text-emerald-500 uppercase tracking-wider mt-1">Zone 3<br>Low Risk</div>
                </div>
            </div>

            @if(evidenceCoverage != null && evidenceCoverage.getTotalCount() > 0)
                <section class="mb-10 rounded-2xl border border-slate-200 bg-white p-5 sm:p-6 shadow-sm">
                    <div class="flex flex-col gap-4 lg:flex-row lg:items-start lg:justify-between">
                        <div>
                            <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Official Evidence in ${stateName}</p>
                            <h2 class="mt-2 font-display text-2xl font-black text-slate-900">
                                ${evidenceCoverage.getOfficialEvidenceCount()} of ${evidenceCoverage.getTotalCount()} listed counties have official evidence
                            </h2>
                            <p class="mt-2 max-w-3xl text-sm leading-relaxed text-slate-600">
                                Open a county page to see the processed verdict: source confidence, local burden, state percentile, and the next step for no reading, 2.0-3.9, or 4.0+ pCi/L.
                            </p>
                        </div>
                        <div class="rounded-2xl border border-indigo-100 bg-indigo-50 px-5 py-4 text-center">
                            <p class="font-display text-3xl font-black text-indigo-700">${evidenceCoverage.getOfficialEvidencePercent()}%</p>
                            <p class="mt-1 text-xs font-bold uppercase tracking-wider text-indigo-800">covered</p>
                        </div>
                    </div>

                    <div class="mt-5 grid grid-cols-2 gap-3 md:grid-cols-4">
                        <div class="rounded-xl border border-slate-100 bg-slate-50 p-4">
                            <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Measured</p>
                            <p class="mt-2 font-display text-2xl font-black text-slate-900">${evidenceCoverage.getMeasuredCount()}</p>
                        </div>
                        <div class="rounded-xl border border-slate-100 bg-slate-50 p-4">
                            <p class="text-xs font-bold uppercase tracking-wider text-slate-500">State source</p>
                            <p class="mt-2 font-display text-2xl font-black text-slate-900">${evidenceCoverage.getStateOfficialMeasuredCount()}</p>
                        </div>
                        <div class="rounded-xl border border-slate-100 bg-slate-50 p-4">
                            <p class="text-xs font-bold uppercase tracking-wider text-slate-500">CDC source</p>
                            <p class="mt-2 font-display text-2xl font-black text-slate-900">${evidenceCoverage.getCdcMeasuredCount()}</p>
                        </div>
                        <div class="rounded-xl border border-slate-100 bg-slate-50 p-4">
                            <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Needs source detail</p>
                            <p class="mt-2 font-display text-2xl font-black text-slate-900">${evidenceCoverage.getSourcePendingCount()}</p>
                        </div>
                    </div>

                    <div class="mt-5 flex flex-wrap gap-2">
                        @for(var source : evidenceCoverage.getSourceRows())
                            <span class="rounded-full border border-slate-200 bg-slate-50 px-3 py-1 text-xs font-semibold text-slate-700">
                                ${source.getSourceName()}: ${source.getCount()}
                            </span>
                        @endfor
                    </div>
                </section>
            @endif

            @if(stateEvidenceInsight != null && stateEvidenceInsight.getMeasuredCountyCount() > 0)
                <section class="mb-10 rounded-2xl border border-slate-200 bg-white p-5 sm:p-6 shadow-sm">
                    <div class="flex flex-col gap-3 lg:flex-row lg:items-start lg:justify-between">
                        <div>
                            <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Measured Risk Leaders in ${stateName}</p>
                            <h2 class="mt-2 font-display text-2xl font-black text-slate-900">
                                County rankings from actual reported radon tests
                            </h2>
                            <p class="mt-2 max-w-3xl text-sm leading-relaxed text-slate-600">
                                These lists rank the visible ${stateName} county pages by measured radon signals, not by the EPA zone label alone. Use them to spot where the state hub has a real data story before opening individual county pages.
                            </p>
                        </div>
                        <div class="rounded-2xl border border-slate-100 bg-slate-50 px-5 py-4 text-center">
                            <p class="font-display text-3xl font-black text-slate-900">${stateEvidenceInsight.getMeasuredCountyCount()}</p>
                            <p class="mt-1 text-xs font-bold uppercase tracking-wider text-slate-500">measured counties</p>
                        </div>
                    </div>

                    @if(stateEvidenceInsight.getDecisionHeadline() != null && !stateEvidenceInsight.getDecisionHeadline().isBlank())
                        <div class="mt-5 rounded-2xl border border-slate-200 bg-slate-50 p-4">
                            <p class="text-xs font-bold uppercase tracking-wider text-slate-500">State-level verdict</p>
                            <h3 class="mt-2 font-display text-xl font-black text-slate-950">${stateEvidenceInsight.getDecisionHeadline()}</h3>
                            <p class="mt-2 text-sm leading-relaxed text-slate-700">${stateEvidenceInsight.getStateDecisionSummary()}</p>
                        </div>

                        <div class="mt-4 grid grid-cols-1 gap-3 lg:grid-cols-3">
                            <div class="rounded-2xl border border-emerald-100 bg-emerald-50 p-4">
                                <p class="text-xs font-bold uppercase tracking-wider text-emerald-700">First-click counties</p>
                                <p class="mt-2 text-sm leading-relaxed text-slate-700">${stateEvidenceInsight.getFirstClickSummary()}</p>
                            </div>
                            <div class="rounded-2xl border border-sky-100 bg-sky-50 p-4">
                                <p class="text-xs font-bold uppercase tracking-wider text-sky-700">Buyer/seller lane</p>
                                <p class="mt-2 text-sm leading-relaxed text-slate-700">${stateEvidenceInsight.getBuyerSellerSummary()}</p>
                            </div>
                            <div class="rounded-2xl border border-amber-100 bg-amber-50 p-4">
                                <p class="text-xs font-bold uppercase tracking-wider text-amber-700">Retest lane</p>
                                <p class="mt-2 text-sm leading-relaxed text-slate-700">${stateEvidenceInsight.getRetestSummary()}</p>
                            </div>
                        </div>
                    @endif

                    @if(stateEvidenceInsight.getPriorityDecisionRows() != null && !stateEvidenceInsight.getPriorityDecisionRows().isEmpty())
                        <div class="mt-5 rounded-2xl border border-slate-200 bg-slate-50 p-4">
                            <div class="flex flex-col gap-2 sm:flex-row sm:items-end sm:justify-between">
                                <div>
                                    <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Best county pages to open first</p>
                                    <h3 class="mt-1 font-display text-xl font-black text-slate-950">Start with these local evidence pages</h3>
                                </div>
                                <p class="max-w-sm text-xs leading-relaxed text-slate-500">
                                    Ranked by measured burden, 4.0+ share, test volume, and whether the EPA zone understates the measurement signal.
                                </p>
                            </div>
                            <div class="mt-4 grid grid-cols-1 gap-3 md:grid-cols-2">
                                @for(var row : stateEvidenceInsight.getPriorityDecisionRows())
                                    <a href="${row.getCountyPath()}" class="block rounded-xl border border-white bg-white p-4 hover:border-slate-300 hover:shadow-sm transition-all">
                                        <div class="flex items-start justify-between gap-3">
                                            <div>
                                                <p class="text-sm font-black text-slate-950">${row.getCountyName()}</p>
                                                <p class="mt-1 text-xs font-bold uppercase tracking-wider text-slate-400">${row.getSourceShortName()}</p>
                                            </div>
                                            <span class="shrink-0 rounded-full border border-slate-200 bg-slate-50 px-2.5 py-1 text-xs font-black text-slate-700">${row.getMetricDisplay()}</span>
                                        </div>
                                        <p class="mt-2 text-xs font-semibold text-slate-600">${row.getSupportingDisplay()}</p>
                                        <p class="mt-2 text-sm leading-relaxed text-slate-700">${row.getDecisionDisplay()}</p>
                                    </a>
                                @endfor
                            </div>
                        </div>
                    @endif

                    <div class="mt-6 grid grid-cols-1 gap-4 lg:grid-cols-3">
                        <div class="rounded-2xl border border-red-100 bg-red-50 p-4">
                            <p class="text-xs font-bold uppercase tracking-wider text-red-700">Highest 4.0+ share</p>
                            <div class="mt-3 space-y-3">
                                @for(var row : stateEvidenceInsight.getTopAbove4Rows())
                                    <a href="${row.getCountyPath()}" class="block rounded-xl border border-white/80 bg-white/85 p-3 hover:border-red-200 hover:bg-white transition-colors">
                                        <div class="flex items-start justify-between gap-3">
                                            <span class="text-sm font-black text-slate-900">${row.getCountyName()}</span>
                                            <span class="shrink-0 text-sm font-black text-red-700">${row.getMetricDisplay()}</span>
                                        </div>
                                        <p class="mt-1 text-xs leading-relaxed text-slate-600">${row.getSupportingDisplay()}</p>
                                        <p class="mt-1 text-[11px] font-bold uppercase tracking-wider text-slate-400">${row.getSourceShortName()}</p>
                                    </a>
                                @endfor
                            </div>
                        </div>

                        <div class="rounded-2xl border border-orange-100 bg-orange-50 p-4">
                            <p class="text-xs font-bold uppercase tracking-wider text-orange-700">Highest high-end reading</p>
                            <div class="mt-3 space-y-3">
                                @for(var row : stateEvidenceInsight.getTopHighEndRows())
                                    <a href="${row.getCountyPath()}" class="block rounded-xl border border-white/80 bg-white/85 p-3 hover:border-orange-200 hover:bg-white transition-colors">
                                        <div class="flex items-start justify-between gap-3">
                                            <span class="text-sm font-black text-slate-900">${row.getCountyName()}</span>
                                            <span class="shrink-0 text-sm font-black text-orange-700">${row.getMetricDisplay()}</span>
                                        </div>
                                        <p class="mt-1 text-xs leading-relaxed text-slate-600">${row.getSupportingDisplay()}</p>
                                        <p class="mt-1 text-[11px] font-bold uppercase tracking-wider text-slate-400">${row.getSourceShortName()}</p>
                                    </a>
                                @endfor
                            </div>
                        </div>

                        <div class="rounded-2xl border border-indigo-100 bg-indigo-50 p-4">
                            <p class="text-xs font-bold uppercase tracking-wider text-indigo-700">Most reported tests</p>
                            <div class="mt-3 space-y-3">
                                @for(var row : stateEvidenceInsight.getTopTestVolumeRows())
                                    <a href="${row.getCountyPath()}" class="block rounded-xl border border-white/80 bg-white/85 p-3 hover:border-indigo-200 hover:bg-white transition-colors">
                                        <div class="flex items-start justify-between gap-3">
                                            <span class="text-sm font-black text-slate-900">${row.getCountyName()}</span>
                                            <span class="shrink-0 text-sm font-black text-indigo-700">${row.getMetricDisplay()}</span>
                                        </div>
                                        <p class="mt-1 text-xs leading-relaxed text-slate-600">${row.getSupportingDisplay()}</p>
                                        <p class="mt-1 text-[11px] font-bold uppercase tracking-wider text-slate-400">${row.getSourceShortName()}</p>
                                    </a>
                                @endfor
                            </div>
                        </div>
                    </div>

                    <div class="mt-5 grid grid-cols-1 gap-3 lg:grid-cols-3">
                        <div class="rounded-2xl border border-slate-200 bg-slate-50 p-4">
                            <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Measured pattern</p>
                            <p class="mt-2 text-sm leading-relaxed text-slate-700">${stateEvidenceInsight.getPatternSummary()}</p>
                        </div>
                        <div class="rounded-2xl border border-slate-200 bg-slate-50 p-4">
                            <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Map vs measurements</p>
                            <p class="mt-2 text-sm leading-relaxed text-slate-700">${stateEvidenceInsight.getZoneContrastSummary()}</p>
                        </div>
                        <div class="rounded-2xl border border-slate-200 bg-slate-50 p-4">
                            <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Source confidence</p>
                            <p class="mt-2 text-sm leading-relaxed text-slate-700">${stateEvidenceInsight.getSourceStrategySummary()}</p>
                        </div>
                    </div>
                </section>
            @endif

            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-10">
                <a href="/radon-mitigation-cost/${stateSlug}"
                   class="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm hover:border-slate-900 hover:shadow-md transition-all">
                    <p class="text-xs font-bold uppercase tracking-wider text-slate-500 mb-2">Already Tested</p>
                    <h2 class="font-display font-bold text-lg text-slate-900 mb-2">View ${stateName} Cost Estimates</h2>
                    <p class="text-sm text-slate-600 leading-relaxed">If you already have a radon result, skip the directory and move straight to local price guidance.</p>
                </a>
                <a href="/radon-levels"
                   class="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm hover:border-indigo-300 hover:shadow-md transition-all">
                    <p class="text-xs font-bold uppercase tracking-wider text-indigo-600 mb-2">Understand the Number</p>
                    <h2 class="font-display font-bold text-lg text-slate-900 mb-2">2.0 vs 4.0 vs 8.0 pCi/L</h2>
                    <p class="text-sm text-slate-600 leading-relaxed">Use the parent levels guide if you need the plain-English meaning of a radon result before browsing counties.</p>
                </a>
                <a href="/guides/how-to-test-for-radon"
                   class="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm hover:border-emerald-300 hover:shadow-md transition-all">
                    <p class="text-xs font-bold uppercase tracking-wider text-emerald-600 mb-2">Need a Number First</p>
                    <h2 class="font-display font-bold text-lg text-slate-900 mb-2">Read the Testing Guide</h2>
                    <p class="text-sm text-slate-600 leading-relaxed">Use the fastest valid radon test setup before you compare quotes or ask whether mitigation is worth it.</p>
                </a>
                <a href="#county-directory"
                   class="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm hover:border-indigo-300 hover:shadow-md transition-all">
                    <p class="text-xs font-bold uppercase tracking-wider text-indigo-600 mb-2">Browse Counties</p>
                    <h2 class="font-display font-bold text-lg text-slate-900 mb-2">Jump to the Directory</h2>
                    <p class="text-sm text-slate-600 leading-relaxed">Open your county to see its EPA zone, testing meaning, and the point where mitigation becomes worth pricing.</p>
                </a>
            </div>

            @if(stateRule != null)
                @template.components.state_radon_resources(
                    stateName = stateName,
                    stateAbbr = stateAbbr,
                    stateProgramUrl = stateRule.getStateProgramUrl(),
                    disclosureRequired = stateRule.isDisclosureRequired(),
                    disclosureSummary = stateRule.getDisclosureSummary(),
                    licenseRequired = stateRule.isLicenseRequired(),
                    licenseNote = stateRule.getLicenseNote(),
                    className = "mb-10"
                )
            @endif

            <!-- County Directory -->
            <div id="county-directory" class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-3">
                @for(var c : counties)
                    <a href="/radon-levels/${c.getStateSlug()}/${c.getCountySlug()}"
                       class="flex items-center justify-between p-4 rounded-xl bg-white border border-slate-200 hover:border-indigo-300 hover:shadow-md transition-all group">
                        <div>
                            <span class="block font-semibold text-sm text-slate-800 group-hover:text-indigo-600 transition-colors">${c.getAreaDisplayName()}</span>
                            <span class="text-xs
                                @if(c.getEpaZone() == 1) text-red-500
                                @elseif(c.getEpaZone() == 2) text-amber-500
                                @else text-emerald-500
                                @endif
                            ">Zone ${c.getEpaZone()}</span>
                        </div>
                        <span class="w-2.5 h-2.5 rounded-full shrink-0
                            @if(c.getEpaZone() == 1) bg-red-400
                            @elseif(c.getEpaZone() == 2) bg-amber-400
                            @else bg-emerald-400
                            @endif
                        "></span>
                    </a>
                @endfor
            </div>

            <!-- CTA at the bottom -->
            <div class="mt-16 text-center">
                <p class="text-sm text-slate-500 mb-4">Already tested? Get your itemized mitigation cost estimate.</p>
                <a href="/radon-mitigation-cost/${stateSlug}"
                   class="inline-flex items-center gap-2 px-6 py-3.5 rounded-xl bg-slate-900 text-white font-bold text-sm hover:bg-slate-800 transition-colors shadow-sm">
                    <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M9 7h6m0 10v-3m-3 3h.01M9 17h.01M9 14h.01M12 14h.01M15 11h.01M12 11h.01M9 11h.01M7 21h10a2 2 0 002-2V5a2 2 0 00-2-2H7a2 2 0 00-2 2v14a2 2 0 002 2z" />
                    </svg>
                    View ${stateName} Mitigation Cost Estimates ->
                </a>
            </div>
        </div>
    `
)

