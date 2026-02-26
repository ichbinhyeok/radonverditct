@import com.radonverdict.model.dto.AeoAnswerBlock
@import com.radonverdict.model.dto.TrustMetadata

@param String title
@param AeoAnswerBlock aeo = null
@param TrustMetadata trust = null

@template.layout.main(
    title = title,
    description = "Complete guide to radon testing: how to test, which kit to buy, understanding results, and when to retest. Expert-level advice from RadonVerdict.",
    headContent = @`
        <script type="application/ld+json">
            {
                "@context": "https://schema.org",
                "@type": "HowTo",
                "name": "How to Test Your Home for Radon",
                "description": "Radon testing is the only way to know if your home has dangerous radon levels. This guide covers how to test, place your kit, and interpret the results.",
                "totalTime": "P3D",
                "estimatedCost": {
                    "@type": "MonetaryAmount",
                    "currency": "USD",
                    "value": "20.00"
                },
                "supply": [
                    { "@type": "HowToSupply", "name": "Short-Term Charcoal Radon Test Kit" }
                ],
                "step": [
                    {
                        "@type": "HowToStep",
                        "name": "Buy a Test Kit",
                        "text": "Purchase a short-term charcoal test kit online or from a local hardware store. Place it in the lowest livable level of your home, such as a basement, about 2-5 feet above the floor."
                    },
                    {
                        "@type": "HowToStep",
                        "name": "Maintain Closed-House Conditions",
                        "text": "Keep doors and windows closed (except for normal entry/exit) for 12 hours before starting the test and during the entire 2-7 day test period. Do not run whole-house fans."
                    },
                    {
                        "@type": "HowToStep",
                        "name": "Wait 2-7 Days and Mail to Lab",
                        "text": "Leave the kit absorbing radon for the duration specified by the manufacturer (usually 48 to 96 hours). Afterward, seal the kit immediately and mail it to the certified lab for analysis."
                    },
                    {
                        "@type": "HowToStep",
                        "name": "Read Your Results",
                        "text": "If results are below 2.0 pCi/L, no action is needed. If between 2.0 and 4.0 pCi/L, consider mitigation. If above 4.0 pCi/L, the EPA recommends mitigating your home within a few months."
                    }
                ]
            }
        </script>
    `,
    content = @`
        <div class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-16 md:py-24 prose prose-slate md:prose-lg max-w-none">
            <a href="/guides" class="not-prose inline-flex items-center gap-1 text-xs font-bold text-slate-400 hover:text-indigo-600 transition-colors uppercase tracking-wider mb-6"><svg class="w-3 h-3" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3"><path stroke-linecap="round" stroke-linejoin="round" d="M15 19l-7-7 7-7"/></svg> All Guides</a>
            <span class="inline-block py-1 px-3 rounded-full bg-emerald-50 text-emerald-700 text-xs font-bold tracking-wider uppercase mb-6 ml-3">Testing &amp; Detection</span>
            <h1 class="font-display font-bold text-4xl text-slate-900 mb-6 tracking-tight">How to Test for Radon: A Complete Homeowner's Guide</h1>
            <p class="lead text-xl text-slate-600 mb-10 leading-relaxed font-medium pb-10 border-b border-slate-200">
                Radon testing is the only way to know if your home has dangerous radon levels. This guide covers every testing method, how to interpret your results, and the critical mistakes that invalidate tests.
            </p>
            @if(aeo != null)
                @template.components.aeo_answer_block(block = aeo)
            @endif

            <h2 class="font-display font-bold text-2xl text-slate-900 mt-12 mb-4">Why Testing Is Non-Negotiable</h2>
            <p class="text-slate-600 mb-4">
                Radon is invisible, odorless, and tasteless. You cannot detect it without a test. The EPA estimates that <strong>1 in every 15 US homes</strong> has radon levels above the 4.0 pCi/L action threshold. Even homes in "low-risk" EPA zones can have dangerously elevated readings due to localized geological conditions.
            </p>
            <p class="text-slate-600 mb-6">
                Testing is inexpensive ($15–$200 depending on method), takes minutes to set up, and provides a definitive answer. There is no scenario in which skipping this test makes sense.
            </p>

            <h2 class="font-display font-bold text-2xl text-slate-900 mt-12 mb-4">The 3 Types of Radon Tests</h2>

            <!-- Test Type 1 -->
            <div class="not-prose bg-white rounded-2xl border border-slate-200 p-6 shadow-sm mb-6">
                <div class="flex items-start gap-4">
                    <div class="w-12 h-12 rounded-xl bg-indigo-100 text-indigo-600 flex items-center justify-center shrink-0">
                        <svg class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                        </svg>
                    </div>
                    <div>
                        <h3 class="font-display font-bold text-lg text-slate-900 mb-2">Short-Term Test Kits (2–7 Days)</h3>
                        <p class="text-sm text-slate-600 leading-relaxed mb-3">
                            Charcoal canisters or alpha-track detectors that absorb radon over 2–7 days. You mail the kit to a certified lab, which returns your result in about a week. This is the most common first test.
                        </p>
                        <div class="grid grid-cols-2 gap-3 text-xs">
                            <div class="bg-emerald-50 rounded-lg p-3">
                                <span class="font-bold text-emerald-700 block mb-1">Pros</span>
                                <span class="text-emerald-600">Fast results · Cheapest option · Available everywhere</span>
                            </div>
                            <div class="bg-red-50 rounded-lg p-3">
                                <span class="font-bold text-red-700 block mb-1">Cons</span>
                                <span class="text-red-600">Snapshot only · Affected by weather · Can be invalidated</span>
                            </div>
                        </div>
                        <div class="mt-3 text-sm font-bold text-slate-900">Cost: $15–$30</div>
                        <a href="https://www.amazon.com/s?k=radon+test+kit+charcoal+short+term" target="_blank" rel="noopener nofollow"
                           class="inline-flex items-center gap-2 mt-3 px-4 py-2 rounded-lg bg-slate-900 text-white text-xs font-bold hover:bg-slate-800 transition-colors">
                            Shop Short-Term Kits →
                        </a>
                    </div>
                </div>
            </div>

            <!-- Test Type 2 -->
            <div class="not-prose bg-white rounded-2xl border border-slate-200 p-6 shadow-sm mb-6">
                <div class="flex items-start gap-4">
                    <div class="w-12 h-12 rounded-xl bg-amber-100 text-amber-600 flex items-center justify-center shrink-0">
                        <svg class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                        </svg>
                    </div>
                    <div>
                        <h3 class="font-display font-bold text-lg text-slate-900 mb-2">Long-Term Test Kits (90+ Days)</h3>
                        <p class="text-sm text-slate-600 leading-relaxed mb-3">
                            Alpha-track detectors or electret ion chambers that measure radon over 90 days to one year. These provide the most accurate long-term average, accounting for seasonal fluctuations. The EPA recommends a long-term test for the definitive measurement.
                        </p>
                        <div class="grid grid-cols-2 gap-3 text-xs">
                            <div class="bg-emerald-50 rounded-lg p-3">
                                <span class="font-bold text-emerald-700 block mb-1">Pros</span>
                                <span class="text-emerald-600">Most accurate average · Accounts for seasons · EPA gold standard</span>
                            </div>
                            <div class="bg-red-50 rounded-lg p-3">
                                <span class="font-bold text-red-700 block mb-1">Cons</span>
                                <span class="text-red-600">Slow results · No real-time feedback · Easy to forget</span>
                            </div>
                        </div>
                        <div class="mt-3 text-sm font-bold text-slate-900">Cost: $25–$40</div>
                    </div>
                </div>
            </div>

            <!-- Test Type 3 -->
            <div class="not-prose bg-white rounded-2xl border border-slate-200 p-6 shadow-sm mb-6">
                <div class="flex items-start gap-4">
                    <div class="w-12 h-12 rounded-xl bg-indigo-100 text-indigo-600 flex items-center justify-center shrink-0">
                        <svg class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                        </svg>
                    </div>
                    <div>
                        <h3 class="font-display font-bold text-lg text-slate-900 mb-2">Continuous Radon Monitors (CRM)</h3>
                        <p class="text-sm text-slate-600 leading-relaxed mb-3">
                            Electronic devices that continuously sample air and display real-time radon readings. Consumer-grade models like the Airthings Wave or Corentium Home provide hourly measurements. Professional monitors used during real estate transactions (like the Sun Nuclear 1027) log data for 48+ hours.
                        </p>
                        <div class="grid grid-cols-2 gap-3 text-xs">
                            <div class="bg-emerald-50 rounded-lg p-3">
                                <span class="font-bold text-emerald-700 block mb-1">Pros</span>
                                <span class="text-emerald-600">Real-time data · Reusable · Smart home integration</span>
                            </div>
                            <div class="bg-red-50 rounded-lg p-3">
                                <span class="font-bold text-red-700 block mb-1">Cons</span>
                                <span class="text-red-600">Higher upfront cost · Needs calibration · Battery dependent</span>
                            </div>
                        </div>
                        <div class="mt-3 text-sm font-bold text-slate-900">Cost: $150–$250 (consumer) · $1,500+ (professional)</div>
                        <a href="https://www.amazon.com/s?k=digital+radon+detector+monitor" target="_blank" rel="noopener nofollow"
                           class="inline-flex items-center gap-2 mt-3 px-4 py-2 rounded-lg bg-slate-900 text-white text-xs font-bold hover:bg-slate-800 transition-colors">
                            Shop Digital Monitors →
                        </a>
                    </div>
                </div>
            </div>

            <h2 class="font-display font-bold text-2xl text-slate-900 mt-12 mb-4">How to Place Your Test Kit: The 5 Rules</h2>
            <p class="text-slate-600 mb-6">
                Test placement directly affects accuracy. An improperly placed test can produce a falsely low reading, giving you a dangerous false sense of security. Follow these rules exactly:
            </p>

            <ol class="list-decimal pl-6 text-slate-600 mb-6 space-y-3">
                <li><strong>Lowest livable level.</strong> Place the test in the lowest level of the home that is regularly occupied — usually the basement or ground floor. Garages and storage rooms don't count.</li>
                <li><strong>2–5 feet above the floor.</strong> Radon is heavier than air but mixes continuously. Testing at breathing height (a table or shelf) gives the most relevant result.</li>
                <li><strong>Away from exterior walls, windows, and doors.</strong> At least 20 inches from exterior walls and 12 inches from any window or door. Drafts dilute local readings.</li>
                <li><strong>Away from sump pits and foundation cracks.</strong> These are radon entry points and will produce artificially high readings that don't represent the room's average level.</li>
                <li><strong>Closed-house conditions.</strong> Keep windows and doors closed for 12 hours before the test begins and throughout the test duration. Normal entry/exit is fine. Do not run whole-house fans.</li>
            </ol>

            <div class="not-prose bg-amber-50 border border-amber-200 rounded-2xl p-6 mb-8">
                <h3 class="font-display font-bold text-amber-900 mb-2">⚠ Common Invalidation Mistakes</h3>
                <ul class="text-sm text-amber-800 space-y-2 leading-relaxed">
                    <li>&bull; <strong>Leaving windows open</strong> — even cracked windows dilute radon readings by 30–50%</li>
                    <li>&bull; <strong>Testing during renovation</strong> — open walls and disturbed foundation material can spike readings</li>
                    <li>&bull; <strong>HVAC changes mid-test</strong> — switching from AC to heat (or vice versa) alters air pressure dynamics</li>
                    <li>&bull; <strong>Placing near humidity sources</strong> — bathrooms and laundry areas produce moisture that interferes with charcoal kits</li>
                </ul>
            </div>

            <h2 class="font-display font-bold text-2xl text-slate-900 mt-12 mb-4">Understanding Your Results</h2>

            <div class="not-prose bg-white rounded-2xl border border-slate-200 overflow-hidden mb-8">
                <table class="w-full text-sm">
                    <thead class="bg-slate-50">
                        <tr>
                            <th class="px-4 py-3 text-left font-bold text-slate-700">Reading (pCi/L)</th>
                            <th class="px-4 py-3 text-left font-bold text-slate-700">Risk Level</th>
                            <th class="px-4 py-3 text-left font-bold text-slate-700">Recommended Action</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-100">
                        <tr>
                            <td class="px-4 py-3 font-semibold text-emerald-600">Below 2.0</td>
                            <td class="px-4 py-3 text-slate-700">Low</td>
                            <td class="px-4 py-3 text-slate-600">No action needed. Re-test every 2 years.</td>
                        </tr>
                        <tr>
                            <td class="px-4 py-3 font-semibold text-amber-600">2.0 – 4.0</td>
                            <td class="px-4 py-3 text-slate-700">Moderate</td>
                            <td class="px-4 py-3 text-slate-600">Consider mitigation (WHO recommends action at 2.7). Confirm with long-term test.</td>
                        </tr>
                        <tr>
                            <td class="px-4 py-3 font-semibold text-red-600">4.0 – 8.0</td>
                            <td class="px-4 py-3 text-slate-700">High</td>
                            <td class="px-4 py-3 text-slate-600">Mitigate within a few months. Confirm with second short-term test.</td>
                        </tr>
                        <tr>
                            <td class="px-4 py-3 font-semibold text-red-700">Above 8.0</td>
                            <td class="px-4 py-3 text-slate-700">Very High</td>
                            <td class="px-4 py-3 text-slate-600">Mitigate immediately. Limit time in lower levels until fixed.</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <p class="text-slate-600 mb-6">
                If your short-term test reads above 4.0 pCi/L, the EPA recommends confirming with a second short-term test or a long-term test before committing to mitigation. However, if your reading is above 8.0, the risk is high enough that the EPA recommends acting immediately rather than waiting for confirmation.
            </p>

            <h2 class="font-display font-bold text-2xl text-slate-900 mt-12 mb-4">When to Re-Test (Even If Your First Test Was Low)</h2>
            <p class="text-slate-600 mb-4">Radon levels fluctuate. A one-time test provides a snapshot, not a guarantee. The EPA recommends re-testing in these scenarios:</p>
            <ul class="list-disc pl-6 text-slate-600 mb-6 space-y-2">
                <li><strong>Every 2 years</strong> as routine maintenance — even if previous tests were low</li>
                <li><strong>After major renovation</strong> — especially if you've altered the foundation, waterproofing, or HVAC system</li>
                <li><strong>After any real estate transaction</strong> — tests conducted under "closed house" conditions for sales may not reflect normal living patterns</li>
                <li><strong>Seasonal change</strong> — radon levels typically peak during winter when homes are sealed and heating systems create negative pressure. A summer test may underrepresent your actual annual average by 20–50%</li>
            </ul>

            <h2 class="font-display font-bold text-2xl text-slate-900 mt-12 mb-4">Professional Testing vs. DIY</h2>
            <p class="text-slate-600 mb-6">
                Professional radon testing (by a certified NRPP or AARST professional) costs $150–$300 and uses calibrated continuous monitors that log hourly data with tamper-detection.
                This is the standard required for real estate transactions in most states. However, for personal screening purposes, a $15–$30 charcoal canister provides
                a reliable initial reading. If the result is borderline (near 4.0 pCi/L), follow up with professional testing or a long-term kit.
            </p>

            <!-- CTA Section -->
            <div class="not-prose bg-indigo-50 border border-indigo-100 rounded-2xl p-8 mt-12 text-slate-900 shadow-sm relative overflow-hidden">
                <div class="absolute top-0 right-0 -mr-16 -mt-16 w-32 h-32 rounded-full bg-indigo-200 opacity-50 blur-2xl"></div>
                <h3 class="font-display font-bold text-xl text-indigo-950 mb-3 relative z-10">Check mitigation costs &amp; local requirements for your county.</h3>
                <p class="text-indigo-800 mb-6 text-sm leading-relaxed relative z-10">Check your radon level against EPA and WHO thresholds, then get an itemized mitigation cost estimate specific to your state’s labor rates and foundation types.</p>
                <div class="flex flex-col sm:flex-row gap-3 relative z-10">
                    <a href="/radon-cost-calculator" class="inline-flex items-center justify-center px-6 py-3 border border-transparent text-sm font-bold rounded-xl text-white bg-indigo-600 hover:bg-indigo-700 transition shadow-sm">
                        Calculate My Local Cost →
                    </a>
                    <a href="/guides/diy-vs-professional-radon-mitigation" class="inline-flex items-center justify-center px-6 py-3 border border-indigo-200 text-sm font-bold rounded-xl text-indigo-800 bg-white hover:bg-indigo-50 transition">
                        DIY vs. Professional
                    </a>
                </div>
            </div>

            <!-- Source Citation -->
            <div class="mt-8 p-4 rounded-xl bg-indigo-50 border border-indigo-100">
                <p class="text-xs text-indigo-800 font-semibold not-prose">
                    📊 Sources: EPA "A Citizen's Guide to Radon" (EPA 402/K-12/002), EPA "Home Buyer's and Seller's Guide to Radon", WHO Handbook on Indoor Radon (2009). All testing protocol recommendations follow ANSI/AARST MAH 2019 standards.
                </p>
            </div>

            @if(trust != null)
                @template.components.trust_metadata(trust = trust)
            @endif
        </div>
    `
)
