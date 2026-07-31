@import com.radonverdict.model.County
@import com.radonverdict.model.dto.AeoAnswerBlock
@import com.radonverdict.model.dto.RadonEvidenceCoverageSummary
@import com.radonverdict.model.dto.RadonNationalEvidenceInsight
@import com.radonverdict.model.dto.TrustMetadata
@import com.radonverdict.util.JsonLdUtils
@import java.util.List
@import java.util.Map

@param Map<String, List<County>> stateMap
@param long zone1Count = 0
@param long zone2Count = 0
@param long zone3Count = 0
@param int visibleCountyCount = 0
@param AeoAnswerBlock aeo = null
@param RadonEvidenceCoverageSummary evidenceCoverage = null
@param RadonNationalEvidenceInsight nationalEvidenceInsight = null
@param TrustMetadata trust = null

!{
    final String seoTitle = "Radon Levels by County: EPA Zones & Local Context";
    final String seoDescription = "Browse radon levels by state and county, compare EPA radon zones, and open the source behind local radon context.";
}

@template.layout.main(
    title = seoTitle,
    description = seoDescription,
    canonicalUrl = "https://radonverdict.com/radon-levels",
    headContent = @`
        <script type="application/ld+json">
            {
                "@context": "https://schema.org",
                "@type": "WebPage",
                "name": $unsafe{JsonLdUtils.json(seoTitle)},
                "url": "https://radonverdict.com/radon-levels",
                "description": $unsafe{JsonLdUtils.json(seoDescription)},
                "inLanguage": "en-US",
                "about": [{
                    "@type": "Thing",
                    "name": "Radon levels"
                },{
                    "@type": "Thing",
                    "name": "EPA radon action level"
                }]
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
                    "name": "Radon Levels",
                    "item": "https://radonverdict.com/radon-levels"
                }]
            }
        </script>
    `,
    content = @`
        <div class="bg-white border-b border-slate-200">
            <div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-14 md:py-20">
                <nav class="text-sm font-medium text-slate-500 mb-8" aria-label="Breadcrumb">
                    <ol class="inline-flex items-center space-x-2">
                        <li><a href="/" class="hover:text-slate-900 transition-colors">Home</a></li>
                        <li><span class="mx-1 text-slate-300">/</span></li>
                        <li class="text-slate-900 font-semibold" aria-current="page">Radon Levels</li>
                    </ol>
                </nav>

                <div class="grid grid-cols-1 lg:grid-cols-[1.15fr_0.85fr] gap-10 items-start">
                    <div>
                        <p class="text-xs font-bold uppercase tracking-wider text-indigo-700 mb-4">Local radon context</p>
                        <h1 class="font-display font-black text-4xl sm:text-5xl text-slate-900 tracking-tight leading-tight">
                            Radon Levels by County and State
                        </h1>
                        <p class="mt-6 text-lg sm:text-xl text-slate-600 leading-relaxed font-medium">
                            Compare EPA zone context and source-backed local records. County data is context, not a substitute for testing the home you live in.
                        </p>
                        <div class="mt-8 rounded-2xl border border-slate-200 bg-slate-50 p-4 sm:p-5">
                            <p class="text-sm font-bold text-slate-900">Already have a number from a radon report?</p>
                            <a href="/radon-test-result-meaning" data-track-event="levels_root_result_interpreter" data-track-label="hero" class="mt-3 inline-flex min-h-12 items-center justify-center rounded-xl bg-slate-900 px-5 text-sm font-black text-white hover:bg-slate-800">Interpret my test result</a>
                            <div class="mt-3 flex flex-wrap gap-x-4 gap-y-2 text-sm font-semibold">
                                <a href="/guides/how-to-test-for-radon" class="text-indigo-700 hover:underline">No result yet? Start with testing.</a>
                                <a href="#state-directory" class="text-slate-600 hover:text-slate-950 hover:underline">Browse state records.</a>
                            </div>
                        </div>
                    </div>

                    <div class="rounded-2xl border border-slate-200 bg-slate-50 p-5 sm:p-6">
                        <p class="text-xs font-bold uppercase tracking-wider text-slate-500">What county context can tell you</p>
                        <div class="mt-4 space-y-3">
                            <div class="rounded-xl border border-emerald-200 bg-white p-4">
                                <p class="text-sm font-bold text-emerald-800">EPA zone</p>
                                <p class="mt-1 text-sm text-slate-600">A county-level potential category, useful for context but never a home measurement.</p>
                            </div>
                            <div class="rounded-xl border border-amber-200 bg-white p-4">
                                <p class="text-sm font-bold text-amber-800">Official local records</p>
                                <p class="mt-1 text-sm text-slate-600">Some county pages include state or public-health tables with period and source limits shown.</p>
                            </div>
                            <div class="rounded-xl border border-rose-200 bg-white p-4">
                                <p class="text-sm font-bold text-rose-800">What it cannot tell you</p>
                                <p class="mt-1 text-sm text-slate-600">It cannot predict the radon level in one basement, slab, or crawl-space home.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-14">
            <section class="mb-14 rounded-2xl border border-slate-200 bg-white p-5 shadow-sm sm:p-6">
                <div class="flex flex-col gap-3 lg:flex-row lg:items-end lg:justify-between">
                    <div>
                        <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Directory guide</p>
                        <h2 class="mt-2 font-display text-2xl font-black tracking-tight text-slate-950">Use local evidence without mistaking it for your result</h2>
                        <p class="mt-3 max-w-3xl text-sm leading-relaxed text-slate-600">
                            Start with your state, then open a listed county source. Each page makes the geography, source period, and statistical limit visible before asking you to act.
                        </p>
                    </div>
                    <a href="#state-directory" class="text-sm font-black text-indigo-700 hover:underline">Open state directory</a>
                </div>

                <div class="mt-6 grid grid-cols-1 gap-3 md:grid-cols-2">
                    <a href="#state-directory" class="block rounded-xl border border-indigo-100 bg-indigo-50 p-4 transition-all hover:border-indigo-200 hover:bg-indigo-100">
                        <p class="text-sm font-black text-indigo-950">Browse by state</p>
                        <p class="mt-2 text-sm leading-relaxed text-slate-700">Open the state hub first when you need county-level EPA zone or public source context.</p>
                        <span class="mt-3 inline-flex text-xs font-black uppercase tracking-wider text-indigo-800">Open state directory &rarr;</span>
                    </a>
                    <a href="/radon-data-sources" class="block rounded-xl border border-amber-100 bg-amber-50 p-4 transition-all hover:border-amber-200 hover:bg-amber-100">
                        <p class="text-sm font-black text-amber-950">Read the source base</p>
                        <p class="mt-2 text-sm leading-relaxed text-slate-700">See which public source is used and why a county summary has limits.</p>
                        <span class="mt-3 inline-flex text-xs font-black uppercase tracking-wider text-amber-800">Open data sources &rarr;</span>
                    </a>
                    <a href="/radon-test-result-meaning" class="block rounded-xl border border-rose-100 bg-rose-50 p-4 transition-all hover:border-rose-200 hover:bg-rose-100">
                        <p class="text-sm font-black text-rose-950">Already have a report?</p>
                        <p class="mt-2 text-sm leading-relaxed text-slate-700">Use the result interpreter for test-type-aware next steps rather than comparing your number to a county average.</p>
                        <span class="mt-3 inline-flex text-xs font-black uppercase tracking-wider text-rose-800">Interpret my result &rarr;</span>
                    </a>
                    <a href="/guides/how-to-test-for-radon" class="block rounded-xl border border-emerald-100 bg-emerald-50 p-4 transition-all hover:border-emerald-200 hover:bg-emerald-100">
                        <p class="text-sm font-black text-emerald-950">No report yet?</p>
                        <p class="mt-2 text-sm leading-relaxed text-slate-700">Start with a correctly placed test. A zone map is never a substitute for it.</p>
                        <span class="mt-3 inline-flex text-xs font-black uppercase tracking-wider text-emerald-800">Read testing guide &rarr;</span>
                    </a>
                    <a href="/radon-testing/new-york/ulster-county" class="block rounded-xl border border-sky-200 bg-sky-50 p-4 transition-all hover:border-sky-300 hover:bg-sky-100 md:col-span-2">
                        <p class="text-sm font-black text-sky-950">Radon gas testing in Ulster County, NY</p>
                        <p class="mt-2 text-sm leading-relaxed text-slate-700">Use the dedicated local guide when the question is how to place the test, preserve closed-house conditions, and act on the result—not just what the county level data says.</p>
                        <span class="mt-3 inline-flex text-xs font-black uppercase tracking-wider text-sky-800">Open the Ulster County testing guide &rarr;</span>
                    </a>
                    <a href="/radon-testing/virginia/powhatan-county" class="block rounded-xl border border-sky-100 bg-sky-50 p-4 transition-all hover:border-sky-300 hover:bg-sky-100">
                        <p class="text-sm font-black text-sky-950">Radon testing in Powhatan County, VA</p>
                        <p class="mt-2 text-sm leading-relaxed text-slate-700">Placement, closed-house conditions, local evidence, and the decision after the result.</p>
                        <span class="mt-3 inline-flex text-xs font-black uppercase tracking-wider text-sky-800">Open Powhatan testing &rarr;</span>
                    </a>
                    <a href="/radon-testing/colorado/broomfield-county" class="block rounded-xl border border-sky-100 bg-sky-50 p-4 transition-all hover:border-sky-300 hover:bg-sky-100">
                        <p class="text-sm font-black text-sky-950">Radon testing in Broomfield County, CO</p>
                        <p class="mt-2 text-sm leading-relaxed text-slate-700">A test-first path for searchers who are otherwise sent straight to mitigation pages.</p>
                        <span class="mt-3 inline-flex text-xs font-black uppercase tracking-wider text-sky-800">Open Broomfield testing &rarr;</span>
                    </a>
                    <a href="/commercial-radon-testing/california/los-angeles-county" class="block rounded-xl border border-cyan-200 bg-cyan-50 p-4 transition-all hover:border-cyan-300 hover:bg-cyan-100 md:col-span-2">
                        <p class="text-sm font-black text-cyan-950">Commercial radon testing in Los Angeles County</p>
                        <p class="mt-2 text-sm leading-relaxed text-slate-700">Build a compliant measurement scope for multifamily, mixed-use, school, office, retail, or other non-residential property before asking for a mitigation bid.</p>
                        <span class="mt-3 inline-flex text-xs font-black uppercase tracking-wider text-cyan-800">Open commercial testing protocol &rarr;</span>
                    </a>
                </div>
            </section>

            @template.components.search_intent_router(className = "mb-14")

            @if(evidenceCoverage != null && evidenceCoverage.getTotalCount() > 0)
                <section class="mb-14 rounded-2xl border border-slate-200 bg-white p-5 sm:p-6 shadow-sm">
                    <div class="flex flex-col gap-4 lg:flex-row lg:items-start lg:justify-between">
                        <div>
                            <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Official County Data</p>
                            <h2 class="mt-2 font-display text-2xl font-black text-slate-900">
                                Every listed county page is tied to an official radon source
                            </h2>
                            <p class="mt-2 max-w-3xl text-sm leading-relaxed text-slate-600">
                                Coverage currently spans ${evidenceCoverage.getTotalCount()} listed county pages. Measured counties use official state tables or CDC Tracking summaries; map-classified counties use official radon-potential categories when a county pCi/L table is not published.
                            </p>
                        </div>
                        <div class="rounded-2xl border border-emerald-100 bg-emerald-50 px-5 py-4 text-center">
                            <p class="font-display text-3xl font-black text-emerald-700">${evidenceCoverage.getOfficialEvidencePercent()}%</p>
                            <p class="mt-1 text-xs font-bold uppercase tracking-wider text-emerald-800">official support</p>
                        </div>
                    </div>

                    <div class="mt-5 grid grid-cols-2 gap-3 md:grid-cols-4">
                        <div class="rounded-xl border border-slate-100 bg-slate-50 p-4">
                            <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Measured counties</p>
                            <p class="mt-2 font-display text-2xl font-black text-slate-900">${evidenceCoverage.getMeasuredCount()}</p>
                        </div>
                        <div class="rounded-xl border border-slate-100 bg-slate-50 p-4">
                            <p class="text-xs font-bold uppercase tracking-wider text-slate-500">State tables</p>
                            <p class="mt-2 font-display text-2xl font-black text-slate-900">${evidenceCoverage.getStateOfficialMeasuredCount()}</p>
                        </div>
                        <div class="rounded-xl border border-slate-100 bg-slate-50 p-4">
                            <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Map classified</p>
                            <p class="mt-2 font-display text-2xl font-black text-slate-900">${evidenceCoverage.getTierCount()}</p>
                        </div>
                        <div class="rounded-xl border border-slate-100 bg-slate-50 p-4">
                            <p class="text-xs font-bold uppercase tracking-wider text-slate-500">More county detail</p>
                            <p class="mt-2 font-display text-2xl font-black text-slate-900">${evidenceCoverage.getSourcePendingCount()}</p>
                        </div>
                    </div>

                    <div class="mt-5 flex flex-wrap gap-2">
                        @for(var source : evidenceCoverage.getSourceRows())
                            <span class="rounded-full border border-slate-200 bg-slate-50 px-3 py-1 text-xs font-semibold text-slate-700">
                                ${"source_pending".equals(source.getSourceId()) ? "More county detail needed" : source.getSourceName()}: ${source.getCount()}
                            </span>
                        @endfor
                    </div>
                </section>
            @endif

            <section class="mb-14 rounded-2xl border border-slate-200 bg-slate-950 p-5 text-white shadow-sm sm:p-6">
                <div class="grid grid-cols-1 gap-6 lg:grid-cols-[0.95fr_1.05fr] lg:items-start">
                    <div>
                        <p class="text-xs font-bold uppercase tracking-wider text-cyan-200">Open Official-Data States First</p>
                        <h2 class="mt-2 font-display text-2xl font-black tracking-tight">
                            Route from the national threshold to state-specific radon data
                        </h2>
                        <p class="mt-3 text-sm leading-relaxed text-slate-300">
                            Some states publish county measurements, while others are best read through CDC Tracking or official radon-potential maps. Start with the states below when you need county pages with clearer public data behind the recommendation.
                        </p>
                    </div>
                    <div class="grid grid-cols-2 gap-2 sm:grid-cols-3">
                        <a href="/radon-levels/iowa" class="rounded-xl border border-white/10 bg-white/10 px-3 py-3 text-sm font-black text-white transition-colors hover:bg-white/15">IA <span class="block text-xs font-semibold text-cyan-100">Iowa HHS medians</span></a>
                        <a href="/radon-levels/north-carolina" class="rounded-xl border border-white/10 bg-white/10 px-3 py-3 text-sm font-black text-white transition-colors hover:bg-white/15">NC <span class="block text-xs font-semibold text-cyan-100">NCDHHS highs</span></a>
                        <a href="/radon-levels/pennsylvania" class="rounded-xl border border-white/10 bg-white/10 px-3 py-3 text-sm font-black text-white transition-colors hover:bg-white/15">PA <span class="block text-xs font-semibold text-cyan-100">DEP ZIP data</span></a>
                        <a href="/radon-levels/illinois" class="rounded-xl border border-white/10 bg-white/10 px-3 py-3 text-sm font-black text-white transition-colors hover:bg-white/15">IL <span class="block text-xs font-semibold text-cyan-100">state results</span></a>
                        <a href="/radon-levels/colorado" class="rounded-xl border border-white/10 bg-white/10 px-3 py-3 text-sm font-black text-white transition-colors hover:bg-white/15">CO <span class="block text-xs font-semibold text-cyan-100">CDPHE data</span></a>
                        <a href="/radon-levels/utah" class="rounded-xl border border-white/10 bg-white/10 px-3 py-3 text-sm font-black text-white transition-colors hover:bg-white/15">UT <span class="block text-xs font-semibold text-cyan-100">EPHT results</span></a>
                    </div>
                </div>

                <div class="mt-6 grid grid-cols-1 gap-3 md:grid-cols-3">
                    <div class="rounded-xl border border-cyan-300/20 bg-cyan-300/10 p-4">
                        <p class="text-xs font-bold uppercase tracking-wider text-cyan-100">State measurements</p>
                        <p class="mt-2 text-sm leading-relaxed text-slate-100">Iowa HHS publishes county median radon values. Osceola County, IA shows an 11.4 pCi/L median, so its page should be opened before treating Iowa as only a zone-map question.</p>
                    </div>
                    <div class="rounded-xl border border-rose-300/20 bg-rose-300/10 p-4">
                        <p class="text-xs font-bold uppercase tracking-wider text-rose-100">Highest measured examples</p>
                        <p class="mt-2 text-sm leading-relaxed text-slate-100">North Carolina DHHS maps the highest measured radon level by county. Rutherford County, NC shows 681 pCi/L as a high-end county signal, not a county average.</p>
                    </div>
                    <div class="rounded-xl border border-amber-300/20 bg-amber-300/10 p-4">
                        <p class="text-xs font-bold uppercase tracking-wider text-amber-100">CDC and map coverage</p>
                        <p class="mt-2 text-sm leading-relaxed text-slate-100">CDC summaries and official state/federal radon-potential maps still help when a state does not publish a county measurement table. Use them as context, then let a home test decide.</p>
                    </div>
                </div>
            </section>

            @if(nationalEvidenceInsight != null)
                <section class="mb-14 rounded-2xl border border-slate-200 bg-white p-5 sm:p-6 shadow-sm">
                    <div class="flex flex-col gap-4 lg:flex-row lg:items-start lg:justify-between">
                        <div>
                            <p class="text-xs font-bold uppercase tracking-wider text-slate-500">National Data Guide</p>
                            <h2 class="mt-2 font-display text-2xl font-black text-slate-900">${nationalEvidenceInsight.getDecisionHeadline()}</h2>
                            <p class="mt-2 max-w-3xl text-sm leading-relaxed text-slate-600">${nationalEvidenceInsight.getRouterSummary()}</p>
                        </div>
                        <div class="rounded-2xl border border-slate-100 bg-slate-50 px-5 py-4 text-center">
                            <p class="font-display text-3xl font-black text-slate-900">${nationalEvidenceInsight.getMeasuredCountyCount()}</p>
                            <p class="mt-1 text-xs font-bold uppercase tracking-wider text-slate-500">measured counties</p>
                        </div>
                    </div>

                    <div class="mt-5 grid grid-cols-1 gap-3 lg:grid-cols-3">
                        <div class="rounded-2xl border border-emerald-100 bg-emerald-50 p-4">
                            <p class="text-xs font-bold uppercase tracking-wider text-emerald-700">Official source base</p>
                            <p class="mt-2 text-sm leading-relaxed text-slate-700">${nationalEvidenceInsight.getSourceMoatSummary()}</p>
                        </div>
                        <div class="rounded-2xl border border-sky-100 bg-sky-50 p-4">
                            <p class="text-xs font-bold uppercase tracking-wider text-sky-700">How to use it</p>
                            <p class="mt-2 text-sm leading-relaxed text-slate-700">${nationalEvidenceInsight.getDeployReadinessSummary()}</p>
                        </div>
                        <div class="rounded-2xl border border-amber-100 bg-amber-50 p-4">
                            <p class="text-xs font-bold uppercase tracking-wider text-amber-700">Where county detail is lighter</p>
                            <p class="mt-2 text-sm leading-relaxed text-slate-700">
                                Some counties still depend on broader federal summaries or state pages without county pCi/L metrics. In those cases, use the county page as context and let a fresh home test control the decision.
                            </p>
                        </div>
                    </div>

                    @if(nationalEvidenceInsight.getPriorityStateRows() != null && !nationalEvidenceInsight.getPriorityStateRows().isEmpty())
                        <div class="mt-5 rounded-2xl border border-slate-200 bg-slate-50 p-4">
                            <div class="flex flex-col gap-2 sm:flex-row sm:items-end sm:justify-between">
                                <div>
                                    <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Open these state hubs first</p>
                                    <h3 class="mt-1 font-display text-xl font-black text-slate-950">States with the strongest county evidence</h3>
                                </div>
                                <p class="max-w-sm text-xs leading-relaxed text-slate-500">
                                    Ranked by official coverage, measured county pages, elevated/high county count, and state measurement strength.
                                </p>
                            </div>

                            <div class="mt-4 grid grid-cols-1 gap-3 md:grid-cols-2">
                                @for(var row : nationalEvidenceInsight.getPriorityStateRows())
                                    <a href="${row.getStatePath()}" class="block rounded-xl border border-white bg-white p-4 hover:border-slate-300 hover:shadow-sm transition-all">
                                        <div class="flex items-start justify-between gap-3">
                                            <div>
                                                <p class="text-lg font-black text-slate-950">${row.getStateAbbr()}</p>
                                                <p class="mt-1 text-xs font-bold uppercase tracking-wider text-slate-400">${row.getSourceMixDisplay()}</p>
                                            </div>
                                            <span class="shrink-0 rounded-full border border-slate-200 bg-slate-50 px-2.5 py-1 text-xs font-black text-slate-700">${row.getPriorityLabel()}</span>
                                        </div>
                                        <div class="mt-3 grid grid-cols-1 gap-2 sm:grid-cols-3">
                                            <p class="rounded-lg border border-slate-100 bg-slate-50 px-3 py-2 text-xs font-semibold text-slate-600">${row.getCoverageDisplay()}</p>
                                            <p class="rounded-lg border border-slate-100 bg-slate-50 px-3 py-2 text-xs font-semibold text-slate-600">${row.getMeasuredDisplay()}</p>
                                            <p class="rounded-lg border border-slate-100 bg-slate-50 px-3 py-2 text-xs font-semibold text-slate-600">${row.getElevatedDisplay()}</p>
                                        </div>
                                        <p class="mt-3 text-sm leading-relaxed text-slate-700">${row.getDecisionDisplay()}</p>
                                    </a>
                                @endfor
                            </div>
                        </div>
                    @endif
                </section>
            @endif

            @if(aeo != null)
                @template.components.aeo_answer_block(block = aeo)
            @endif

            <section class="mt-16 grid grid-cols-1 lg:grid-cols-3 gap-4">
                <a href="/radon-test-result-meaning" class="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm hover:border-slate-900 hover:shadow-md transition-all">
                    <p class="text-xs font-bold uppercase tracking-wider text-slate-500 mb-2">Have a report</p>
                    <h2 class="font-display font-bold text-lg text-slate-900 mb-2">Interpret the result</h2>
                    <p class="text-sm text-slate-600 leading-relaxed">Use the national threshold and your test type, not a county average, for the next decision.</p>
                </a>
                <a href="/guides/how-to-test-for-radon" class="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm hover:border-emerald-300 hover:shadow-md transition-all">
                    <p class="text-xs font-bold uppercase tracking-wider text-emerald-700 mb-2">Need a test</p>
                    <h2 class="font-display font-bold text-lg text-slate-900 mb-2">Test the actual home</h2>
                    <p class="text-sm text-slate-600 leading-relaxed">A correctly placed home test is the only way to know the level where you live.</p>
                </a>
                <a href="/methodology" class="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm hover:border-indigo-300 hover:shadow-md transition-all">
                    <p class="text-xs font-bold uppercase tracking-wider text-indigo-700 mb-2">Trust & Sources</p>
                    <h2 class="font-display font-bold text-lg text-slate-900 mb-2">Read the Methodology</h2>
                    <p class="text-sm text-slate-600 leading-relaxed">See how public EPA, state, and public-health data are distinguished from a property-level result.</p>
                </a>
            </section>

            <section class="mt-16">
                <p class="text-xs font-bold uppercase tracking-wider text-slate-500">EPA Zone Context</p>
                <h2 class="mt-2 font-display font-bold text-3xl text-slate-900 tracking-tight">EPA zones are map context, not your home result</h2>
                <p class="mt-4 max-w-3xl text-slate-600 leading-relaxed">
                    EPA radon zones estimate county-level potential. They are useful for deciding how seriously to treat local risk, but the reading inside one basement, slab home, or crawl-space home can be higher or lower than the county prediction.
                </p>
                <div class="mt-6 grid grid-cols-1 md:grid-cols-3 gap-4">
                    <div class="rounded-2xl border border-red-100 bg-red-50 p-5">
                        <div class="font-display font-black text-3xl text-red-700">${zone1Count}</div>
                        <h3 class="mt-2 font-bold text-red-950">Zone 1 counties</h3>
                        <p class="mt-2 text-sm leading-relaxed text-red-900">Highest predicted average potential. Testing and mitigation planning deserve early attention.</p>
                    </div>
                    <div class="rounded-2xl border border-amber-100 bg-amber-50 p-5">
                        <div class="font-display font-black text-3xl text-amber-700">${zone2Count}</div>
                        <h3 class="mt-2 font-bold text-amber-950">Zone 2 counties</h3>
                        <p class="mt-2 text-sm leading-relaxed text-amber-900">Moderate predicted average potential. Borderline readings should not be dismissed.</p>
                    </div>
                    <div class="rounded-2xl border border-emerald-100 bg-emerald-50 p-5">
                        <div class="font-display font-black text-3xl text-emerald-700">${zone3Count}</div>
                        <h3 class="mt-2 font-bold text-emerald-950">Zone 3 counties</h3>
                        <p class="mt-2 text-sm leading-relaxed text-emerald-900">Lower predicted average potential. Direct testing is still the deciding evidence.</p>
                    </div>
                </div>
                <div class="mt-5">
                    <a href="https://www.epa.gov/radon/epa-map-radon-zones"
                       target="_blank"
                       rel="noopener"
                       class="inline-flex items-center text-sm font-bold text-indigo-700 hover:underline">
                        Open the official EPA Map of Radon Zones
                    </a>
                </div>
            </section>

            <section id="state-directory" class="mt-16">
                <div class="flex flex-col gap-3 md:flex-row md:items-end md:justify-between mb-6">
                    <div>
                        <p class="text-xs font-bold uppercase tracking-wider text-slate-500">State and County Maps</p>
                        <h2 class="font-display font-bold text-3xl text-slate-900 tracking-tight">Browse radon levels by state</h2>
                    </div>
                    <p class="text-sm text-slate-500">${visibleCountyCount} county pages currently available in the state map directory.</p>
                </div>

                <div class="grid grid-cols-2 gap-3 sm:grid-cols-4 md:grid-cols-6 lg:grid-cols-8">
                    @for(String stateAbbr : stateMap.keySet())
                        <a href="/radon-levels/${stateMap.get(stateAbbr).get(0).getStateSlug()}"
                           class="flex min-h-[68px] flex-col items-center justify-center rounded-xl border border-slate-200 bg-white py-4 shadow-sm transition-all hover:border-indigo-300 hover:bg-indigo-50 hover:shadow-md">
                            <span class="font-display text-lg font-bold text-slate-800">${stateAbbr}</span>
                            <span class="mt-1 text-xs text-slate-500">${stateMap.get(stateAbbr).size()} counties</span>
                        </a>
                    @endfor
                </div>
            </section>

            <section class="mt-16 rounded-2xl border border-slate-200 bg-white p-6">
                <h2 class="font-display font-bold text-xl text-slate-900 mb-3">Sources and limits</h2>
                <p class="text-sm leading-relaxed text-slate-600">
                    This page uses EPA radon action-level guidance and EPA zone data for public-risk context. It is not medical advice, legal advice, or a substitute for a valid home radon test. If you already have a result, your own measured level matters more than the county zone.
                </p>
                <div class="mt-4 flex flex-col sm:flex-row gap-3 text-sm font-bold">
                    <a href="https://www.epa.gov/radon" target="_blank" rel="noopener" class="text-indigo-700 hover:underline">EPA radon resources</a>
                    <a href="https://www.who.int/publications/i/item/9789241547673" target="_blank" rel="noopener" class="text-indigo-700 hover:underline">WHO Handbook on Indoor Radon</a>
                    <a href="/methodology" class="text-indigo-700 hover:underline">RadonVerdict methodology</a>
                </div>
            </section>

            @if(trust != null)
                @template.components.trust_metadata(trust = trust)
            @endif
        </div>
    `
)
