@import com.radonverdict.model.dto.CostEvidenceHubInsight
@import com.radonverdict.model.dto.EvidenceSourceRow
@import com.radonverdict.util.JsonLdUtils
@import java.util.List

@param CostEvidenceHubInsight costEvidenceInsight = null
@param List<EvidenceSourceRow> sourceRows = null

!{
    final String seoTitle = "Radon Mitigation Cost Data Report";
    final String seoDescription = "A source-backed report on RadonVerdict's radon mitigation cost index: official county evidence, modeled cost ranges, quote-ledger feedback, and the highest-signal county cost pages.";
}

@template.layout.main(
    title = seoTitle + " | RadonVerdict",
    description = seoDescription,
    canonicalUrl = "https://radonverdict.com/radon-cost-data-report",
    headContent = @`
        <script type="application/ld+json">
            {
                "@context": "https://schema.org",
                "@type": "Dataset",
                "name": "RadonVerdict radon mitigation cost evidence index",
                "url": "https://radonverdict.com/radon-cost-data-report",
                "description": $unsafe{JsonLdUtils.json(seoDescription)},
                "creator": {
                    "@type": "Organization",
                    "name": "RadonVerdict",
                    "url": "https://radonverdict.com/"
                },
                "measurementTechnique": "County-level official radon evidence, EPA zone context, Census housing context, modeled mitigation cost ranges, and anonymized quote-ledger feedback.",
                "license": "https://radonverdict.com/terms",
                "isAccessibleForFree": true
            }
        </script>
    `,
    content = @`
        <div class="bg-slate-950 text-white">
            <div class="mx-auto max-w-6xl px-4 py-14 sm:px-6 lg:px-8 lg:py-20">
                <nav class="mb-8 text-sm font-medium text-slate-400" aria-label="Breadcrumb">
                    <ol class="inline-flex items-center space-x-2">
                        <li><a href="/" class="hover:text-white">Home</a></li>
                        <li><span class="mx-1 text-slate-600">/</span></li>
                        <li><a href="/radon-mitigation-cost" class="hover:text-white">Radon Mitigation Cost</a></li>
                        <li><span class="mx-1 text-slate-600">/</span></li>
                        <li class="font-semibold text-white" aria-current="page">Cost Data Report</li>
                    </ol>
                </nav>

                <div class="grid gap-10 lg:grid-cols-[1fr_0.75fr] lg:items-start">
                    <div>
                        <p class="text-xs font-black uppercase tracking-[0.2em] text-cyan-200">source-backed cost index</p>
                        <h1 class="mt-4 font-display text-4xl font-black tracking-tight sm:text-6xl">
                            Radon mitigation cost data report
                        </h1>
                        <p class="mt-6 max-w-3xl text-lg leading-relaxed text-slate-300">
                            This is the public explanation of how RadonVerdict decides which local cost pages deserve search visibility: official radon evidence first, local cost model second, quote-ledger feedback third.
                        </p>
                        @if(costEvidenceInsight != null)
                            <p class="mt-4 max-w-3xl text-sm leading-relaxed text-slate-400">
                                ${costEvidenceInsight.getReportSummary()}
                            </p>
                        @endif
                        <div class="mt-8 flex flex-col gap-3 sm:flex-row">
                            <a href="/radon-mitigation-cost" class="inline-flex items-center justify-center rounded-xl bg-white px-5 py-3 text-sm font-black text-slate-950 transition-colors hover:bg-cyan-50">
                                Open cost index
                            </a>
                            <a href="/radon-quote-ledger" class="inline-flex items-center justify-center rounded-xl border border-white/15 bg-white/10 px-5 py-3 text-sm font-black text-white transition-colors hover:bg-white/15">
                                View quote ledger
                            </a>
                        </div>
                    </div>

                    @if(costEvidenceInsight != null)
                        <div class="rounded-2xl border border-white/10 bg-white/10 p-5">
                            <p class="text-xs font-black uppercase tracking-wider text-slate-300">Index snapshot</p>
                            <div class="mt-5 grid grid-cols-2 gap-3">
                                <div class="rounded-xl bg-white p-4 text-slate-950">
                                    <p class="font-display text-3xl font-black">${costEvidenceInsight.getIndexableCostCountyCount()}</p>
                                    <p class="mt-1 text-xs font-bold uppercase tracking-wider text-slate-500">Cost URLs</p>
                                </div>
                                <div class="rounded-xl bg-emerald-100 p-4 text-emerald-950">
                                    <p class="font-display text-3xl font-black">${costEvidenceInsight.getEvidenceBackedCostCountyCount()}</p>
                                    <p class="mt-1 text-xs font-bold uppercase tracking-wider text-emerald-700">Evidence-backed</p>
                                </div>
                                <div class="rounded-xl bg-indigo-100 p-4 text-indigo-950">
                                    <p class="font-display text-3xl font-black">${costEvidenceInsight.getMeasuredCostCountyCount()}</p>
                                    <p class="mt-1 text-xs font-bold uppercase tracking-wider text-indigo-700">Measured</p>
                                </div>
                                <div class="rounded-xl bg-amber-100 p-4 text-amber-950">
                                    <p class="font-display text-3xl font-black">${costEvidenceInsight.getSearchCohortCostCountyCount()}</p>
                                    <p class="mt-1 text-xs font-bold uppercase tracking-wider text-amber-700">Demand cohort</p>
                                </div>
                            </div>
                            <p class="mt-5 text-sm leading-relaxed text-slate-300">
                                National planning range anchor: <strong class="text-white">${costEvidenceInsight.getNationalCostRangeDisplay()}</strong>. County pages narrow that range with local rules, evidence, and foundation context.
                            </p>
                        </div>
                    @endif
                </div>
            </div>
        </div>

        <main class="mx-auto max-w-6xl px-4 py-12 sm:px-6 lg:px-8">
            @if(costEvidenceInsight != null)
                <section class="grid gap-6 lg:grid-cols-[0.85fr_1.15fr]">
                    <div>
                        <p class="text-xs font-black uppercase tracking-[0.18em] text-slate-500">What the report proves</p>
                        <h2 class="mt-3 font-display text-3xl font-black tracking-tight text-slate-950">Cost pages are not all treated equally</h2>
                        <p class="mt-4 text-sm leading-relaxed text-slate-600">
                            ${costEvidenceInsight.getDiscoverySummary()}
                        </p>
                        <p class="mt-3 text-sm leading-relaxed text-slate-600">
                            ${costEvidenceInsight.getQuoteLedgerBridgeSummary()}
                        </p>
                    </div>
                    <div class="grid gap-4 sm:grid-cols-2">
                        <div class="rounded-2xl border border-slate-200 bg-white p-5">
                            <p class="text-xs font-black uppercase tracking-wider text-slate-500">Official evidence</p>
                            <h3 class="mt-2 font-display text-xl font-black text-slate-950">Radon source first</h3>
                            <p class="mt-2 text-sm leading-relaxed text-slate-600">County pages are strongest when official measurement tables, CDC rows, or state tier maps give the local page a distinct factual reason to exist.</p>
                        </div>
                        <div class="rounded-2xl border border-slate-200 bg-white p-5">
                            <p class="text-xs font-black uppercase tracking-wider text-slate-500">Cost model</p>
                            <h3 class="mt-2 font-display text-xl font-black text-slate-950">Budget, not a bid</h3>
                            <p class="mt-2 text-sm leading-relaxed text-slate-600">The local range helps homeowners compare quotes, but the final contractor price still depends on foundation, routing, fan, sealing, permits, and access.</p>
                        </div>
                        <div class="rounded-2xl border border-slate-200 bg-white p-5">
                            <p class="text-xs font-black uppercase tracking-wider text-slate-500">Quote ledger</p>
                            <h3 class="mt-2 font-display text-xl font-black text-slate-950">Observed feedback</h3>
                            <p class="mt-2 text-sm leading-relaxed text-slate-600">Anonymized quote signals help identify when a modeled range needs local correction or when a high quote is explainable by scope.</p>
                        </div>
                        <div class="rounded-2xl border border-slate-200 bg-white p-5">
                            <p class="text-xs font-black uppercase tracking-wider text-slate-500">Search policy</p>
                            <h3 class="mt-2 font-display text-xl font-black text-slate-950">Hold weak pages back</h3>
                            <p class="mt-2 text-sm leading-relaxed text-slate-600">ZIP and thin county variants are routed for users, not automatically submitted as search pages.</p>
                        </div>
                    </div>
                </section>

                <section class="mt-14 rounded-2xl border border-indigo-200 bg-indigo-50 p-5 sm:p-6">
                    <div class="grid gap-6 lg:grid-cols-[0.78fr_1.22fr] lg:items-start">
                        <div>
                            <p class="text-xs font-black uppercase tracking-[0.18em] text-indigo-700">Current search-demand routes</p>
                            <h2 class="mt-2 font-display text-3xl font-black tracking-tight text-slate-950">Do not send every query to the same page</h2>
                            <p class="mt-3 text-sm leading-relaxed text-indigo-950">
                                Testing, provider, commercial, map, and cost searches need different first answers. This report keeps those routes explicit so a local page can satisfy the query before asking for a lead, quote, or calculator action.
                            </p>
                        </div>
                        <div class="overflow-hidden rounded-2xl border border-indigo-200 bg-white">
                            <div class="grid gap-0 divide-y divide-slate-100">
                                <a href="/radon-levels/new-york/ulster-county" class="grid gap-3 p-4 transition-colors hover:bg-indigo-50 sm:grid-cols-[0.34fr_0.66fr]">
                                    <span class="text-sm font-black text-slate-950">Ulster County, NY</span>
                                    <span class="text-sm leading-relaxed text-slate-600">radon gas testing and mitigation-services searches should land on the testing/levels decision path, then route 4.0+ users to cost.</span>
                                </a>
                                <a href="/radon-levels/california/los-angeles-county" class="grid gap-3 p-4 transition-colors hover:bg-indigo-50 sm:grid-cols-[0.34fr_0.66fr]">
                                    <span class="text-sm font-black text-slate-950">Los Angeles County, CA</span>
                                    <span class="text-sm leading-relaxed text-slate-600">commercial radon searches need testing protocol, building scope, and quote-screening language before a residential price anchor.</span>
                                </a>
                                <a href="/radon-levels/colorado/boulder-county" class="grid gap-3 p-4 transition-colors hover:bg-indigo-50 sm:grid-cols-[0.34fr_0.66fr]">
                                    <span class="text-sm font-black text-slate-950">Boulder County, CO</span>
                                    <span class="text-sm leading-relaxed text-slate-600">testing and mitigation queries should connect official county evidence to the local cost path and quote checklist.</span>
                                </a>
                                <a href="/radon-levels/virginia/loudoun-county" class="grid gap-3 p-4 transition-colors hover:bg-indigo-50 sm:grid-cols-[0.34fr_0.66fr]">
                                    <span class="text-sm font-black text-slate-950">Loudoun County, VA</span>
                                    <span class="text-sm leading-relaxed text-slate-600">testing and ZIP-cost demand should bridge from the official county signal into the local cost estimate and seller-credit path.</span>
                                </a>
                                <a href="/radon-levels/missouri/st-louis-county" class="grid gap-3 p-4 transition-colors hover:bg-indigo-50 sm:grid-cols-[0.34fr_0.66fr]">
                                    <span class="text-sm font-black text-slate-950">St. Louis County, MO</span>
                                    <span class="text-sm leading-relaxed text-slate-600">broad local radon searches need the Missouri evidence block, result-band explanation, and contractor quote route in one flow.</span>
                                </a>
                            </div>
                        </div>
                    </div>
                </section>

                <section class="mt-14 rounded-2xl border border-slate-200 bg-slate-50 p-5 sm:p-6">
                    <div class="flex flex-col gap-3 md:flex-row md:items-end md:justify-between">
                        <div>
                            <p class="text-xs font-black uppercase tracking-[0.18em] text-slate-500">Top county evidence table</p>
                            <h2 class="mt-2 font-display text-3xl font-black tracking-tight text-slate-950">Twenty county cost pages to inspect first</h2>
                        </div>
                        <p class="max-w-md text-sm leading-relaxed text-slate-600">
                            Ranked by indexing score, demand cohort status, official evidence, and local housing base.
                        </p>
                    </div>

                    <div class="mt-6 grid gap-4">
                        @for(var row : costEvidenceInsight.getPriorityCountyRows())
                            <article class="rounded-2xl border border-slate-200 bg-white p-5">
                                <div class="grid gap-4 lg:grid-cols-[0.8fr_1.2fr_0.55fr] lg:items-start">
                                    <div>
                                        <a href="${row.getCountyPath()}" class="font-display text-xl font-black text-slate-950 hover:text-indigo-700">${row.getCountyName()}, ${row.getStateAbbr()}</a>
                                        <p class="mt-2 text-xs font-black uppercase tracking-wider text-emerald-700">${row.getPriorityLabel()} - score ${row.getIndexingScore()}</p>
                                        <p class="mt-2 font-display text-2xl font-black text-slate-950">${row.getCostRangeDisplay()}</p>
                                    </div>
                                    <div>
                                        <p class="text-sm font-black text-slate-950">${row.getUserQuestion()}</p>
                                        <p class="mt-2 text-sm leading-relaxed text-slate-600">${row.getWhyThisCounty()}</p>
                                        <p class="mt-2 text-sm leading-relaxed text-slate-500">${row.getInspectionPriority()}</p>
                                    </div>
                                    <div class="rounded-xl border border-slate-200 bg-slate-50 p-4">
                                        <p class="text-xs font-black uppercase tracking-wider text-slate-500">Evidence</p>
                                        <p class="mt-2 text-sm font-semibold leading-relaxed text-slate-700">${row.getEvidenceDisplay()}</p>
                                        <p class="mt-2 text-xs leading-relaxed text-slate-500">${row.getSupportDisplay()}</p>
                                        @if(row.getSourceUrl() != null && !row.getSourceUrl().isBlank())
                                            <a href="${row.getSourceUrl()}" target="_blank" rel="noopener nofollow" class="mt-3 inline-flex text-xs font-black uppercase tracking-wider text-indigo-700 hover:underline">Source</a>
                                        @endif
                                    </div>
                                </div>
                            </article>
                        @endfor
                    </div>
                </section>

                <section class="mt-14 grid gap-6 lg:grid-cols-[1fr_1fr]">
                    <div class="rounded-2xl border border-slate-200 bg-white p-6">
                        <p class="text-xs font-black uppercase tracking-[0.18em] text-slate-500">State crawl routes</p>
                        <h2 class="mt-2 font-display text-2xl font-black tracking-tight text-slate-950">Best state hubs for discovery</h2>
                        <div class="mt-5 divide-y divide-slate-100">
                            @for(var row : costEvidenceInsight.getPriorityStateRows())
                                <a href="${row.getStatePath()}" class="block py-4 hover:bg-slate-50">
                                    <div class="flex items-start justify-between gap-4">
                                        <div>
                                            <p class="font-black text-slate-950">${row.getStateAbbr()} <span class="ml-2 rounded-md bg-emerald-50 px-2 py-1 text-xs font-black text-emerald-700">${row.getPriorityLabel()}</span></p>
                                            <p class="mt-1 text-sm leading-relaxed text-slate-600">${row.getDecisionDisplay()}</p>
                                            <p class="mt-1 text-xs text-slate-500">Top county: ${row.getTopCountyName()}</p>
                                        </div>
                                        <span class="shrink-0 text-xs font-black uppercase tracking-wider text-indigo-700">Open</span>
                                    </div>
                                </a>
                            @endfor
                        </div>
                    </div>

                    <div class="rounded-2xl border border-slate-200 bg-white p-6">
                        <p class="text-xs font-black uppercase tracking-[0.18em] text-slate-500">Source inventory</p>
                        <h2 class="mt-2 font-display text-2xl font-black tracking-tight text-slate-950">Official evidence feeds behind the index</h2>
                        <div class="mt-5 space-y-3">
                            @if(sourceRows != null)
                                @for(int i = 0; i < sourceRows.size() && i < 6; i++)
                                    <div class="rounded-xl border border-slate-200 bg-slate-50 p-4">
                                        <p class="text-sm font-black text-slate-950">${sourceRows.get(i).getSourceName()}</p>
                                        <p class="mt-1 text-xs leading-relaxed text-slate-500">${sourceRows.get(i).getEvidenceType()} - ${sourceRows.get(i).getCountyCount()} county rows</p>
                                    </div>
                                @endfor
                            @endif
                        </div>
                        <a href="/radon-data-sources" class="mt-5 inline-flex text-sm font-black text-indigo-700 hover:underline">Open full evidence policy</a>
                    </div>
                </section>
            @else
                <section class="rounded-2xl border border-amber-200 bg-amber-50 p-6">
                    <h1 class="font-display text-3xl font-black text-slate-950">Cost evidence report unavailable</h1>
                    <p class="mt-3 text-sm leading-relaxed text-amber-900">No cost-indexable county pages are currently available for the report.</p>
                </section>
            @endif
        </main>
    `
)
