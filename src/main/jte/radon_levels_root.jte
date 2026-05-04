@import com.radonverdict.model.County
@import com.radonverdict.model.dto.AeoAnswerBlock
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
@param TrustMetadata trust = null

!{
    final String seoTitle = "Radon Levels: What 2.0, 4.0, and 8.0 pCi/L Mean | EPA Guide";
    final String seoDescription = "Understand radon levels in pCi/L: what 2.0, 4.0, and 8.0 mean, when to retest, when to mitigate, and how to use EPA radon zones by state and county.";
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
                        <p class="text-xs font-bold uppercase tracking-wider text-indigo-700 mb-4">Radon Levels Parent Guide</p>
                        <h1 class="font-display font-black text-4xl sm:text-5xl text-slate-900 tracking-tight leading-tight">
                            Radon Levels: What 2.0, 4.0, and 8.0 pCi/L Mean
                        </h1>
                        <p class="mt-6 text-lg sm:text-xl text-slate-600 leading-relaxed font-medium">
                            Use this page to translate a radon test result into a practical next step. Then open your state or county page for EPA zone context and local mitigation pricing.
                        </p>
                        <div class="mt-8 flex flex-col sm:flex-row gap-3">
                            <a href="#level-meaning"
                               class="inline-flex items-center justify-center rounded-xl bg-slate-900 px-5 py-3 text-sm font-bold text-white hover:bg-slate-800 transition-colors">
                                Interpret My Number
                            </a>
                            <a href="#state-directory"
                               class="inline-flex items-center justify-center rounded-xl border border-slate-200 bg-white px-5 py-3 text-sm font-semibold text-slate-700 hover:bg-slate-50 transition-colors">
                                Browse State Maps
                            </a>
                        </div>
                    </div>

                    <div class="rounded-2xl border border-slate-200 bg-slate-50 p-5 sm:p-6">
                        <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Fast Answer</p>
                        <div class="mt-4 space-y-3">
                            <div class="rounded-xl border border-emerald-200 bg-white p-4">
                                <p class="text-sm font-bold text-emerald-800">Under 2.0 pCi/L</p>
                                <p class="mt-1 text-sm text-slate-600">Lower concern, but retest periodically because home levels change.</p>
                            </div>
                            <div class="rounded-xl border border-amber-200 bg-white p-4">
                                <p class="text-sm font-bold text-amber-800">2.0 to 3.9 pCi/L</p>
                                <p class="mt-1 text-sm text-slate-600">Retest or track long-term. Reduction can still be worth considering.</p>
                            </div>
                            <div class="rounded-xl border border-rose-200 bg-white p-4">
                                <p class="text-sm font-bold text-rose-800">4.0+ pCi/L</p>
                                <p class="mt-1 text-sm text-slate-600">Start mitigation planning. This is the main EPA action threshold.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-14">
            @if(aeo != null)
                @template.components.aeo_answer_block(block = aeo)
            @endif

            <section id="level-meaning" class="mt-14">
                <div class="flex flex-col gap-3 md:flex-row md:items-end md:justify-between mb-6">
                    <div>
                        <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Result Meaning</p>
                        <h2 class="font-display font-bold text-3xl text-slate-900 tracking-tight">What your radon number means</h2>
                    </div>
                    <a href="/guides/how-to-test-for-radon" class="text-sm font-bold text-indigo-700 hover:underline">
                        No result yet? Read the testing guide
                    </a>
                </div>

                <div class="overflow-hidden rounded-2xl border border-slate-200 bg-white">
                    <div class="grid grid-cols-1 md:grid-cols-[0.8fr_1.2fr_1.2fr] border-b border-slate-200 bg-slate-50 text-xs font-bold uppercase tracking-wider text-slate-500">
                        <div class="p-4">Reading</div>
                        <div class="p-4">Plain meaning</div>
                        <div class="p-4">Next step</div>
                    </div>
                    <div class="divide-y divide-slate-100">
                        <div class="grid grid-cols-1 md:grid-cols-[0.8fr_1.2fr_1.2fr]">
                            <div class="p-4 font-display text-xl font-black text-emerald-700">Under 2.0</div>
                            <div class="p-4 text-sm leading-relaxed text-slate-600">Below the range where most homeowners start pricing mitigation, but not a permanent all-clear.</div>
                            <div class="p-4 text-sm leading-relaxed text-slate-700">Keep the result, retest after major home changes, and consider periodic monitoring.</div>
                        </div>
                        <div class="grid grid-cols-1 md:grid-cols-[0.8fr_1.2fr_1.2fr]">
                            <div class="p-4 font-display text-xl font-black text-amber-700">2.0-3.9</div>
                            <div class="p-4 text-sm leading-relaxed text-slate-600">Borderline range. It is below the main EPA action threshold, but risk is not zero.</div>
                            <div class="p-4 text-sm leading-relaxed text-slate-700">Retest with a valid setup, use a long-term monitor, or price mitigation if the home has compounding risk.</div>
                        </div>
                        <div class="grid grid-cols-1 md:grid-cols-[0.8fr_1.2fr_1.2fr]">
                            <div class="p-4 font-display text-xl font-black text-rose-700">4.0-7.9</div>
                            <div class="p-4 text-sm leading-relaxed text-slate-600">Elevated result. This is where mitigation planning becomes the practical next step.</div>
                            <div class="p-4 text-sm leading-relaxed text-slate-700">Confirm the reading if needed, then compare local mitigation costs and contractor requirements.</div>
                        </div>
                        <div class="grid grid-cols-1 md:grid-cols-[0.8fr_1.2fr_1.2fr]">
                            <div class="p-4 font-display text-xl font-black text-red-800">8.0+</div>
                            <div class="p-4 text-sm leading-relaxed text-slate-600">High reading. Waiting usually creates more risk and more negotiation friction.</div>
                            <div class="p-4 text-sm leading-relaxed text-slate-700">Prioritize mitigation quotes. In a real-estate deal, turn the local cost range into a repair or credit ask.</div>
                        </div>
                    </div>
                </div>
            </section>

            <section class="mt-16 grid grid-cols-1 lg:grid-cols-3 gap-4">
                <a href="/radon-cost-calculator"
                   class="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm hover:border-slate-900 hover:shadow-md transition-all">
                    <p class="text-xs font-bold uppercase tracking-wider text-slate-500 mb-2">4.0+ Reading</p>
                    <h2 class="font-display font-bold text-lg text-slate-900 mb-2">Get a Local Action Plan</h2>
                    <p class="text-sm text-slate-600 leading-relaxed">Use your ZIP, foundation type, and result band to open the right county cost page.</p>
                </a>
                <a href="/radon-credit-calculator"
                   class="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm hover:border-blue-300 hover:shadow-md transition-all">
                    <p class="text-xs font-bold uppercase tracking-wider text-blue-700 mb-2">Buying or Selling</p>
                    <h2 class="font-display font-bold text-lg text-slate-900 mb-2">Calculate a Seller Credit</h2>
                    <p class="text-sm text-slate-600 leading-relaxed">Turn a local mitigation range into a repair ask, credit ask, or quick-close fallback.</p>
                </a>
                <a href="/methodology"
                   class="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm hover:border-indigo-300 hover:shadow-md transition-all">
                    <p class="text-xs font-bold uppercase tracking-wider text-indigo-700 mb-2">Trust & Sources</p>
                    <h2 class="font-display font-bold text-lg text-slate-900 mb-2">Read the Methodology</h2>
                    <p class="text-sm text-slate-600 leading-relaxed">See how public EPA, state, housing, and cost data are used across RadonVerdict.</p>
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
