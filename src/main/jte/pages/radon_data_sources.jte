@import com.radonverdict.model.dto.EvidenceSourceRow
@import com.radonverdict.util.JsonLdUtils
@import java.util.List

@param String title
@param int measurementCountyCount = 0
@param int tierCountyCount = 0
@param int zipMappingCount = 0
@param int referenceSourceCount = 0
@param List<EvidenceSourceRow> sourceRows = null

!{
    final String seoTitle = "Radon Data Sources & Evidence Policy | RadonVerdict";
    final String seoDescription = "See how RadonVerdict uses EPA zones, official state radon measurement data, NJ DEP tier data, Census housing data, ZIP-to-county mapping, and cost references.";
    final int officialEvidenceCount = measurementCountyCount + tierCountyCount;
}

@template.layout.main(
    title = seoTitle,
    description = seoDescription,
    canonicalUrl = "https://radonverdict.com/radon-data-sources",
    headContent = @`
        <script type="application/ld+json">
            {
                "@context": "https://schema.org",
                "@type": "ItemList",
                "name": "RadonVerdict official radon evidence sources",
                "itemListElement": [
                    @if(sourceRows != null)
                    @for(int i = 0; i < sourceRows.size(); i++)
                    {
                        "@type": "ListItem",
                        "position": ${i + 1},
                        "name": $unsafe{JsonLdUtils.json(sourceRows.get(i).getSourceName())},
                        "url": $unsafe{JsonLdUtils.json(sourceRows.get(i).getSourceUrl())}
                    }
                    @if(i < sourceRows.size() - 1),@endif
                    @endfor
                    @endif
                ]
            }
        </script>
    `,
    content = @`
        <div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-12 md:py-20">
            <nav class="text-sm font-medium text-slate-500 mb-8" aria-label="Breadcrumb">
                <ol class="inline-flex items-center space-x-2">
                    <li><a href="/" class="hover:text-slate-900 transition-colors">Home</a></li>
                    <li><span class="mx-1 text-slate-300">/</span></li>
                    <li class="text-slate-900 font-semibold" aria-current="page">Data Sources</li>
                </ol>
            </nav>

            <section class="border-b border-slate-200 pb-12">
                <p class="text-xs font-bold uppercase tracking-[0.18em] text-indigo-700 mb-4">Evidence policy</p>
                <h1 class="font-display text-4xl font-black tracking-tight text-slate-950 sm:text-5xl">
                    Radon data sources, evidence hierarchy, and indexing policy
                </h1>
                <p class="mt-6 max-w-3xl text-lg leading-relaxed text-slate-600">
                    RadonVerdict is built around a simple rule: official radon evidence comes before calculators. County pages use public EPA, state, CDC, NJ DEP, Census, ZIP, and cost-reference data to decide whether a page has enough local evidence for search and what next step a user should see.
                </p>
                <div class="mt-8 flex flex-col gap-3 sm:flex-row">
                    <a href="/methodology" class="inline-flex items-center justify-center rounded-xl bg-slate-900 px-5 py-3 text-sm font-bold text-white transition-colors hover:bg-slate-800">
                        Read Methodology
                    </a>
                    <a href="/radon-cost-data-report" class="inline-flex items-center justify-center rounded-xl border border-slate-200 bg-white px-5 py-3 text-sm font-bold text-slate-800 transition-colors hover:bg-slate-50">
                        Open Cost Data Report
                    </a>
                    <a href="/radon-levels" class="inline-flex items-center justify-center rounded-xl border border-slate-200 bg-white px-5 py-3 text-sm font-bold text-slate-800 transition-colors hover:bg-slate-50">
                        Open Radon Levels
                    </a>
                </div>
            </section>

            <section class="py-10">
                <div class="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">
                    <div class="rounded-2xl border border-slate-200 bg-white p-5">
                        <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Official county evidence</p>
                        <p class="mt-3 font-display text-3xl font-black text-slate-950">${String.format(java.util.Locale.US, "%,d", officialEvidenceCount)}</p>
                        <p class="mt-2 text-sm leading-relaxed text-slate-600">Measurement or tier-backed county summaries loaded for radon-level decisions.</p>
                    </div>
                    <div class="rounded-2xl border border-slate-200 bg-white p-5">
                        <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Measurement summaries</p>
                        <p class="mt-3 font-display text-3xl font-black text-slate-950">${String.format(java.util.Locale.US, "%,d", measurementCountyCount)}</p>
                        <p class="mt-2 text-sm leading-relaxed text-slate-600">County rows from official health, tracking, or state radon datasets.</p>
                    </div>
                    <div class="rounded-2xl border border-slate-200 bg-white p-5">
                        <p class="text-xs font-bold uppercase tracking-wider text-slate-500">ZIP mappings</p>
                        <p class="mt-3 font-display text-3xl font-black text-slate-950">${String.format(java.util.Locale.US, "%,d", zipMappingCount)}</p>
                        <p class="mt-2 text-sm leading-relaxed text-slate-600">ZIP-to-primary-county mappings used to route cost and credit searches.</p>
                    </div>
                    <div class="rounded-2xl border border-slate-200 bg-white p-5">
                        <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Reference anchors</p>
                        <p class="mt-3 font-display text-3xl font-black text-slate-950">${referenceSourceCount}</p>
                        <p class="mt-2 text-sm leading-relaxed text-slate-600">EPA, CDC, HUD, and cost-reference sources used across guides and calculators.</p>
                    </div>
                </div>
            </section>

            <section class="grid grid-cols-1 gap-8 border-t border-slate-200 py-12 lg:grid-cols-[0.9fr_1.1fr]">
                <div>
                    <p class="text-xs font-bold uppercase tracking-[0.18em] text-slate-500">Evidence hierarchy</p>
                    <h2 class="mt-3 font-display text-3xl font-black tracking-tight text-slate-950">What gets trusted first</h2>
                    <p class="mt-4 text-sm leading-relaxed text-slate-600">
                        The hierarchy matters because EPA zone maps, state measurements, and cost models answer different questions. We keep them separate so a county page does not overstate what any single source can prove.
                    </p>
                </div>
                <div class="space-y-3">
                    <div class="rounded-2xl border border-slate-200 bg-white p-5">
                        <p class="font-bold text-slate-950">1. Official measured radon data</p>
                        <p class="mt-2 text-sm leading-relaxed text-slate-600">State health departments, CDC tracking exports, public dashboards, and official county or ZIP aggregates come first when available.</p>
                    </div>
                    <div class="rounded-2xl border border-slate-200 bg-white p-5">
                        <p class="font-bold text-slate-950">2. Official tier or potential data</p>
                        <p class="mt-2 text-sm leading-relaxed text-slate-600">For New Jersey, DEP municipal radon-potential tiers are used as testing-priority evidence, not as a county pCi/L average.</p>
                    </div>
                    <div class="rounded-2xl border border-slate-200 bg-white p-5">
                        <p class="font-bold text-slate-950">3. EPA zone and state program context</p>
                        <p class="mt-2 text-sm leading-relaxed text-slate-600">EPA zones explain predicted county potential. State program pages explain testing, disclosure, and credential expectations.</p>
                    </div>
                    <div class="rounded-2xl border border-slate-200 bg-white p-5">
                        <p class="font-bold text-slate-950">4. Census housing and cost references</p>
                        <p class="mt-2 text-sm leading-relaxed text-slate-600">Housing stock, home value, foundation assumptions, and national cost references support budgeting, but they never replace a home test.</p>
                    </div>
                </div>
            </section>

            <section class="border-t border-slate-200 py-12">
                <div class="flex flex-col gap-4 md:flex-row md:items-end md:justify-between">
                    <div>
                        <p class="text-xs font-bold uppercase tracking-[0.18em] text-slate-500">Official source inventory</p>
                        <h2 class="mt-3 font-display text-3xl font-black tracking-tight text-slate-950">Primary radon evidence feeds</h2>
                    </div>
                    <p class="max-w-md text-sm leading-relaxed text-slate-600">
                        Counts below describe source-backed rows currently loaded into the application, not a claim that every county page should be indexed.
                    </p>
                </div>

                <div class="mt-8 overflow-hidden rounded-2xl border border-slate-200 bg-white">
                    <div class="grid grid-cols-1 divide-y divide-slate-200">
                        @if(sourceRows != null)
                        @for(var source : sourceRows)
                            <div class="grid gap-4 p-5 lg:grid-cols-[1fr_170px_150px] lg:items-start">
                                <div>
                                    @if(source.getSourceUrl() != null && !source.getSourceUrl().isBlank())
                                        <a href="${source.getSourceUrl()}" target="_blank" rel="noopener nofollow" class="font-bold text-slate-950 hover:text-indigo-700">
                                            ${source.getSourceName()}
                                        </a>
                                    @else
                                        <p class="font-bold text-slate-950">${source.getSourceName()}</p>
                                    @endif
                                    <p class="mt-2 text-sm leading-relaxed text-slate-600">${source.getCaveatSummary()}</p>
                                </div>
                                <div>
                                    <p class="text-[11px] font-bold uppercase tracking-widest text-slate-500">Evidence type</p>
                                    <p class="mt-1 text-sm font-semibold text-slate-800">${source.getEvidenceType()}</p>
                                    <p class="mt-1 text-xs text-slate-500">${source.getPeriodLabel()}</p>
                                </div>
                                <div>
                                    <p class="text-[11px] font-bold uppercase tracking-widest text-slate-500">Loaded counties</p>
                                    <p class="mt-1 font-display text-2xl font-black text-slate-950">${String.format(java.util.Locale.US, "%,d", source.getCountyCount())}</p>
                                </div>
                            </div>
                        @endfor
                        @endif
                    </div>
                </div>
            </section>

            <section class="grid grid-cols-1 gap-6 border-t border-slate-200 py-12 lg:grid-cols-3">
                <div class="lg:col-span-1">
                    <p class="text-xs font-bold uppercase tracking-[0.18em] text-slate-500">Indexing discipline</p>
                    <h2 class="mt-3 font-display text-3xl font-black tracking-tight text-slate-950">Why some pages stay out of search</h2>
                </div>
                <div class="lg:col-span-2">
                    <p class="text-base leading-relaxed text-slate-600">
                        RadonVerdict does not try to submit every possible county or ZIP combination to search engines. A county page can be useful to a direct user and still stay out of search if the available evidence is weak, missing, too similar to other pages, or not supported by enough demand yet.
                    </p>
                    <div class="mt-6 grid grid-cols-1 gap-4 sm:grid-cols-2">
                        <div class="rounded-2xl border border-slate-200 bg-white p-5">
                            <p class="font-bold text-slate-950">Submit pages with distinct evidence</p>
                            <p class="mt-2 text-sm leading-relaxed text-slate-600">Official evidence, housing context, state rules, clear related pages, and a distinct user task must support the page.</p>
                        </div>
                        <div class="rounded-2xl border border-slate-200 bg-white p-5">
                            <p class="font-bold text-slate-950">Hold thin or low-signal pages back</p>
                            <p class="mt-2 text-sm leading-relaxed text-slate-600">Zone-only, duplicate, unknown-zone, or unsupported county pages are kept out of the sitemap until they earn a stronger reason to rank.</p>
                        </div>
                    </div>
                </div>
            </section>

            <section class="rounded-3xl bg-slate-900 p-6 text-white sm:p-8">
                <div class="grid gap-6 lg:grid-cols-[1fr_auto] lg:items-center">
                    <div>
                        <p class="text-xs font-bold uppercase tracking-[0.18em] text-slate-300">Bottom line</p>
                        <h2 class="mt-3 font-display text-3xl font-black tracking-tight">County evidence helps choose the next step. A home test still decides the home.</h2>
                        <p class="mt-4 max-w-3xl text-sm leading-relaxed text-slate-300">
                            Public radon data can tell you whether a county deserves urgency. It cannot diagnose a property. That boundary is why our county pages separate evidence, testing guidance, cost planning, and lead capture.
                        </p>
                    </div>
                    <a href="/guides/how-to-test-for-radon" class="inline-flex items-center justify-center rounded-xl bg-white px-5 py-3 text-sm font-bold text-slate-950 transition-colors hover:bg-slate-100">
                        See Testing Guide
                    </a>
                </div>
            </section>
        </div>
    `
)
