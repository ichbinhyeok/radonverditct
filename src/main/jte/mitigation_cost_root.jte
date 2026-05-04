@import com.radonverdict.model.County
@import com.radonverdict.model.dto.ItemizedReceipt
@import com.radonverdict.model.dto.TrustMetadata
@import com.radonverdict.util.JsonLdUtils
@import java.util.List
@import java.util.Map

@param ItemizedReceipt defaultReceipt
@param ItemizedReceipt basementReceipt
@param ItemizedReceipt slabReceipt
@param ItemizedReceipt crawlspaceReceipt
@param Map<String, List<County>> stateMap
@param TrustMetadata trust = null

!{
    final String seoTitle = "Radon Mitigation Cost by State, Foundation Type, and Result";
    final String seoDescription = "See radon mitigation cost ranges by foundation type, test result, and state. Use ZIP lookup to open a local county estimate before comparing contractors or seller credits.";
}

@template.layout.main(
    title = seoTitle + " | RadonVerdict",
    description = seoDescription,
    canonicalUrl = "https://radonverdict.com/radon-mitigation-cost",
    headContent = @`
        <script type="application/ld+json">
            {
                "@context": "https://schema.org",
                "@type": "WebPage",
                "name": $unsafe{JsonLdUtils.json(seoTitle)},
                "url": "https://radonverdict.com/radon-mitigation-cost",
                "description": $unsafe{JsonLdUtils.json(seoDescription)},
                "inLanguage": "en-US",
                "about": [{
                    "@type": "Thing",
                    "name": "Radon mitigation cost"
                },{
                    "@type": "Thing",
                    "name": "Radon mitigation system"
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
                    "name": "Radon Mitigation Cost",
                    "item": "https://radonverdict.com/radon-mitigation-cost"
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
                        <li class="text-slate-900 font-semibold" aria-current="page">Radon Mitigation Cost</li>
                    </ol>
                </nav>

                <div class="grid grid-cols-1 lg:grid-cols-[1.1fr_0.9fr] gap-10 items-start">
                    <div>
                        <p class="text-xs font-bold uppercase tracking-wider text-brand-700 mb-4">Cost Parent Guide</p>
                        <h1 class="font-display font-black text-4xl sm:text-5xl text-slate-900 tracking-tight leading-tight">
                            Radon Mitigation Cost by State, Foundation Type, and Test Result
                        </h1>
                        <p class="mt-6 text-lg sm:text-xl text-slate-600 leading-relaxed font-medium">
                            Most homeowners need one answer first: what is a realistic budget before calling contractors? Start with the national range, then jump to your ZIP or state for local county pricing.
                        </p>
                        <div class="mt-8 flex flex-col sm:flex-row gap-3">
                            <a href="/radon-cost-calculator"
                               class="inline-flex items-center justify-center rounded-xl bg-slate-900 px-5 py-3 text-sm font-bold text-white hover:bg-slate-800 transition-colors">
                                Use ZIP Cost Calculator
                            </a>
                            <a href="#state-directory"
                               class="inline-flex items-center justify-center rounded-xl border border-slate-200 bg-white px-5 py-3 text-sm font-semibold text-slate-700 hover:bg-slate-50 transition-colors">
                                Browse Costs by State
                            </a>
                        </div>
                    </div>

                    <div class="rounded-2xl border border-slate-200 bg-slate-50 p-5 sm:p-6">
                        <p class="text-xs font-bold uppercase tracking-wider text-slate-500">National Planning Range</p>
                        <div class="mt-4 rounded-2xl border border-slate-200 bg-white p-5">
                            <p class="text-sm text-slate-500">Typical standard setup</p>
                            <p class="mt-2 font-display text-5xl font-black tracking-tight text-slate-900">$${defaultReceipt.getTotalLow()}-$${defaultReceipt.getTotalHigh()}</p>
                            <p class="mt-2 text-sm leading-relaxed text-slate-600">
                                Average planning number: <strong>$${defaultReceipt.getTotalAvg()}</strong>. County pages adjust this for state rules, local labor, foundation, and project complexity.
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-14">
            <section>
                <div class="flex flex-col gap-3 md:flex-row md:items-end md:justify-between mb-6">
                    <div>
                        <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Foundation Type</p>
                        <h2 class="font-display font-bold text-3xl text-slate-900 tracking-tight">Basement, slab, and crawl-space cost ranges</h2>
                    </div>
                    <a href="/methodology" class="text-sm font-bold text-indigo-700 hover:underline">How the model works</a>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                    <div class="rounded-2xl border border-slate-200 bg-white p-5">
                        <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Basement</p>
                        <p class="mt-3 font-display text-3xl font-black text-slate-900">$${basementReceipt.getTotalLow()}-$${basementReceipt.getTotalHigh()}</p>
                        <p class="mt-3 text-sm leading-relaxed text-slate-600">Usually the cleanest pricing path when sub-slab suction is straightforward and routing is not unusually complex.</p>
                    </div>
                    <div class="rounded-2xl border border-slate-200 bg-white p-5">
                        <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Slab-on-grade</p>
                        <p class="mt-3 font-display text-3xl font-black text-slate-900">$${slabReceipt.getTotalLow()}-$${slabReceipt.getTotalHigh()}</p>
                        <p class="mt-3 text-sm leading-relaxed text-slate-600">Often similar to basement pricing, but routing, floor penetrations, and finished-space constraints can move the quote.</p>
                    </div>
                    <div class="rounded-2xl border border-slate-200 bg-white p-5">
                        <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Crawl space</p>
                        <p class="mt-3 font-display text-3xl font-black text-slate-900">$${crawlspaceReceipt.getTotalLow()}-$${crawlspaceReceipt.getTotalHigh()}</p>
                        <p class="mt-3 text-sm leading-relaxed text-slate-600">Usually higher when vapor-barrier sealing, sub-membrane suction, or access constraints add labor and material.</p>
                    </div>
                </div>
            </section>

            <section class="mt-16">
                <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Test Result</p>
                <h2 class="mt-2 font-display font-bold text-3xl text-slate-900 tracking-tight">When the cost question becomes urgent</h2>
                <div class="mt-6 overflow-hidden rounded-2xl border border-slate-200 bg-white">
                    <div class="grid grid-cols-1 md:grid-cols-[0.8fr_1.15fr_1.15fr] border-b border-slate-200 bg-slate-50 text-xs font-bold uppercase tracking-wider text-slate-500">
                        <div class="p-4">Reading</div>
                        <div class="p-4">Cost urgency</div>
                        <div class="p-4">Best next step</div>
                    </div>
                    <div class="divide-y divide-slate-100">
                        <div class="grid grid-cols-1 md:grid-cols-[0.8fr_1.15fr_1.15fr]">
                            <div class="p-4 font-display text-xl font-black text-emerald-700">No test yet</div>
                            <div class="p-4 text-sm leading-relaxed text-slate-600">Do not start with contractor quotes. A valid test result changes the whole decision.</div>
                            <div class="p-4 text-sm leading-relaxed text-slate-700"><a href="/guides/how-to-test-for-radon" class="font-bold text-indigo-700 hover:underline">Run a short-term test first</a>.</div>
                        </div>
                        <div class="grid grid-cols-1 md:grid-cols-[0.8fr_1.15fr_1.15fr]">
                            <div class="p-4 font-display text-xl font-black text-amber-700">2.0-3.9</div>
                            <div class="p-4 text-sm leading-relaxed text-slate-600">Borderline. Pricing may be useful for planning, but retesting or long-term monitoring may come first.</div>
                            <div class="p-4 text-sm leading-relaxed text-slate-700"><a href="/radon-levels" class="font-bold text-indigo-700 hover:underline">Interpret the radon level</a>, then decide whether to price reduction.</div>
                        </div>
                        <div class="grid grid-cols-1 md:grid-cols-[0.8fr_1.15fr_1.15fr]">
                            <div class="p-4 font-display text-xl font-black text-rose-700">4.0+</div>
                            <div class="p-4 text-sm leading-relaxed text-slate-600">This is where mitigation pricing becomes practical and time-sensitive.</div>
                            <div class="p-4 text-sm leading-relaxed text-slate-700"><a href="/radon-cost-calculator" class="font-bold text-indigo-700 hover:underline">Use ZIP lookup</a> to open your local cost page.</div>
                        </div>
                        <div class="grid grid-cols-1 md:grid-cols-[0.8fr_1.15fr_1.15fr]">
                            <div class="p-4 font-display text-xl font-black text-red-800">8.0+</div>
                            <div class="p-4 text-sm leading-relaxed text-slate-600">High reading. Waiting usually creates more health risk and more real-estate friction.</div>
                            <div class="p-4 text-sm leading-relaxed text-slate-700">Prioritize local quotes and, in a deal, convert the range into a repair or credit ask.</div>
                        </div>
                    </div>
                </div>
            </section>

            <section class="mt-16 grid grid-cols-1 lg:grid-cols-3 gap-4">
                <a href="/radon-cost-calculator"
                   class="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm hover:border-slate-900 hover:shadow-md transition-all">
                    <p class="text-xs font-bold uppercase tracking-wider text-slate-500 mb-2">Fastest local path</p>
                    <h2 class="font-display font-bold text-lg text-slate-900 mb-2">ZIP Cost Calculator</h2>
                    <p class="text-sm text-slate-600 leading-relaxed">Open the county estimate matched to the property ZIP and situation.</p>
                </a>
                <a href="/radon-credit-calculator"
                   class="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm hover:border-blue-300 hover:shadow-md transition-all">
                    <p class="text-xs font-bold uppercase tracking-wider text-blue-700 mb-2">Real-estate deal</p>
                    <h2 class="font-display font-bold text-lg text-slate-900 mb-2">Seller Credit Calculator</h2>
                    <p class="text-sm text-slate-600 leading-relaxed">Turn a local range into an opening ask, ceiling, or quick-close fallback.</p>
                </a>
                <a href="/radon-levels"
                   class="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm hover:border-indigo-300 hover:shadow-md transition-all">
                    <p class="text-xs font-bold uppercase tracking-wider text-indigo-700 mb-2">Need meaning first?</p>
                    <h2 class="font-display font-bold text-lg text-slate-900 mb-2">2.0 vs 4.0 vs 8.0 pCi/L</h2>
                    <p class="text-sm text-slate-600 leading-relaxed">Understand the test result before you decide how much pricing work is worth doing.</p>
                </a>
            </section>

            <section id="state-directory" class="mt-16">
                <div class="flex flex-col gap-3 md:flex-row md:items-end md:justify-between mb-6">
                    <div>
                        <p class="text-xs font-bold uppercase tracking-wider text-slate-500">State Directory</p>
                        <h2 class="font-display font-bold text-3xl text-slate-900 tracking-tight">Browse radon mitigation cost by state</h2>
                    </div>
                    <p class="text-sm text-slate-500">Open a state, then choose the county for local pricing.</p>
                </div>

                <div class="grid grid-cols-2 gap-3 sm:grid-cols-4 md:grid-cols-6 lg:grid-cols-8">
                    @for(String stateAbbr : stateMap.keySet())
                        <a href="/radon-mitigation-cost/${stateMap.get(stateAbbr).get(0).getStateSlug()}"
                           class="flex min-h-[68px] flex-col items-center justify-center rounded-xl border border-slate-200 bg-white py-4 shadow-sm transition-all hover:border-brand-300 hover:bg-brand-50 hover:shadow-md">
                            <span class="font-display text-lg font-bold text-slate-800">${stateAbbr}</span>
                            <span class="mt-1 text-xs text-slate-500">${stateMap.get(stateAbbr).size()} counties</span>
                        </a>
                    @endfor
                </div>
            </section>

            <section class="mt-16 rounded-2xl border border-slate-200 bg-white p-6">
                <h2 class="font-display font-bold text-xl text-slate-900 mb-3">Sources and estimate limits</h2>
                <p class="text-sm leading-relaxed text-slate-600">
                    These are planning estimates, not contractor bids. The model uses RadonVerdict's pricing configuration, foundation assumptions, regional multipliers, and state-rule context. Real quotes can change with access, routing, fan size, roofline, crawl-space sealing, permits, and contractor availability.
                </p>
                <div class="mt-4 flex flex-col sm:flex-row gap-3 text-sm font-bold">
                    <a href="/methodology" class="text-indigo-700 hover:underline">RadonVerdict methodology</a>
                    <a href="/radon-levels" class="text-indigo-700 hover:underline">Radon level guide</a>
                    <a href="https://www.epa.gov/radon" target="_blank" rel="noopener" class="text-indigo-700 hover:underline">EPA radon resources</a>
                </div>
            </section>

            @if(trust != null)
                @template.components.trust_metadata(trust = trust)
            @endif
        </div>
    `
)
