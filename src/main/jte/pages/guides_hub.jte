@param String title

@template.layout.main(
    title = title,
    canonicalUrl = "https://radonverdict.com/guides",
    description = "Expert guides on radon mitigation, testing, and what to expect during installation.",
    content = @`
        <div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-16 md:py-24">
            <h1 class="font-display font-bold text-4xl text-slate-900 mb-6 tracking-tight">Radon Mitigation Guides</h1>
            <p class="text-xl text-slate-600 mb-16 max-w-2xl leading-relaxed">
                Everything you need to know to lower your home's radon levels safely and cost-effectively. Read our expert resources before hiring a contractor.
            </p>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-8 border-t border-slate-200 pt-16">
                <!-- Article 1 -->
                <a href="/guides/diy-vs-professional-radon-mitigation" class="group block">
                    <div class="aspect-w-16 aspect-h-9 w-full bg-slate-100 rounded-2xl mb-6 overflow-hidden">
                        <div class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300 bg-indigo-50 flex items-center justify-center">
                            <svg class="h-20 w-20 text-indigo-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M11 4a2 2 0 114 0v1a1 1 0 001 1h3a1 1 0 011 1v3a1 1 0 01-1 1h-1a2 2 0 100 4h1a1 1 0 011 1v3a1 1 0 01-1 1h-3a1 1 0 01-1-1v-1a2 2 0 10-4 0v1a1 1 0 01-1 1H7a1 1 0 01-1-1v-3a1 1 0 00-1-1H4a2 2 0 110-4h1a1 1 0 001-1V7a1 1 0 011-1h3a1 1 0 001-1V4z" />
                            </svg>
                        </div>
                    </div>
                    <span class="inline-block py-1 px-3 rounded-full bg-indigo-50 text-indigo-700 text-xs font-bold tracking-wider uppercase mb-4">Cost Strategy</span>
                    <h3 class="font-display font-bold text-2xl text-slate-900 mb-3 group-hover:text-indigo-600 transition-colors">DIY Radon Mitigation vs. Hiring a Pro: Real Costs</h3>
                    <p class="text-slate-600 leading-relaxed font-medium">Is saving $800 worth drilling through your foundation? We break down the true costs, risks, and legal implications of DIY installation.</p>
                </a>

                <!-- Article 2 -->
                <a href="/guides/radon-mitigation-timeline-how-long-does-it-take" class="group block">
                    <div class="aspect-w-16 aspect-h-9 w-full bg-slate-100 rounded-2xl mb-6 overflow-hidden">
                        <div class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300 bg-amber-50 flex items-center justify-center">
                            <svg class="h-20 w-20 text-amber-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                            </svg>
                        </div>
                    </div>
                    <span class="inline-block py-1 px-3 rounded-full bg-amber-50 text-amber-700 text-xs font-bold tracking-wider uppercase mb-4">Process & Timeline</span>
                    <h3 class="font-display font-bold text-2xl text-slate-900 mb-3 group-hover:text-indigo-600 transition-colors">How Long Does Radon Mitigation Take?</h3>
                    <p class="text-slate-600 leading-relaxed font-medium">From the first inspection to the final cleared test. An exact timeline of what happens when a contractor arrives at your home.</p>
                </a>

                <!-- Article 3: Testing Guide -->
                <a href="/guides/how-to-test-for-radon" class="group block">
                    <div class="aspect-w-16 aspect-h-9 w-full bg-slate-100 rounded-2xl mb-6 overflow-hidden">
                        <div class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300 bg-emerald-50 flex items-center justify-center">
                            <svg class="h-20 w-20 text-emerald-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
                            </svg>
                        </div>
                    </div>
                    <span class="inline-block py-1 px-3 rounded-full bg-emerald-50 text-emerald-700 text-xs font-bold tracking-wider uppercase mb-4">Testing &amp; Detection</span>
                    <h3 class="font-display font-bold text-2xl text-slate-900 mb-3 group-hover:text-indigo-600 transition-colors">How to Test for Radon: Complete Guide</h3>
                    <p class="text-slate-600 leading-relaxed font-medium">Every testing method compared, placement rules that prevent false readings, and how to interpret your results like an expert.</p>
                </a>
            </div>

            <!-- Second Grid: New 8 Guides -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-8 border-t border-slate-200 pt-16 mt-16">
                <!-- Guide 4: Buyer vs Seller -->
                <a href="/guides/who-pays-radon-mitigation-buyer-or-seller" class="group block">
                    <div class="aspect-w-16 aspect-h-9 w-full bg-slate-100 rounded-2xl mb-6 overflow-hidden">
                        <div class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300 bg-blue-50 flex items-center justify-center">
                            <svg class="h-20 w-20 text-blue-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5"><path stroke-linecap="round" stroke-linejoin="round" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"/></svg>
                        </div>
                    </div>
                    <span class="inline-block py-1 px-3 rounded-full bg-blue-50 text-blue-700 text-xs font-bold tracking-wider uppercase mb-4">Real Estate</span>
                    <h3 class="font-display font-bold text-2xl text-slate-900 mb-3 group-hover:text-indigo-600 transition-colors">Who Pays for Radon Mitigation: Buyer or Seller?</h3>
                    <p class="text-slate-600 leading-relaxed font-medium">Standard negotiation tactics, seller concessions, and dealing with a failed home inspection.</p>
                </a>

                <!-- Guide 5: Symptoms -->
                <a href="/guides/radon-exposure-symptoms" class="group block">
                    <div class="aspect-w-16 aspect-h-9 w-full bg-slate-100 rounded-2xl mb-6 overflow-hidden">
                        <div class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300 bg-red-50 flex items-center justify-center">
                            <svg class="h-20 w-20 text-red-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5"><path stroke-linecap="round" stroke-linejoin="round" d="M4.318 6.318a4.5 4.5 0 000 6.364L12 20.364l7.682-7.682a4.5 4.5 0 00-6.364-6.364L12 7.636l-1.318-1.318a4.5 4.5 0 00-6.364 0z"/></svg>
                        </div>
                    </div>
                    <span class="inline-block py-1 px-3 rounded-full bg-red-50 text-red-700 text-xs font-bold tracking-wider uppercase mb-4">Health &amp; Medicine</span>
                    <h3 class="font-display font-bold text-2xl text-slate-900 mb-3 group-hover:text-indigo-600 transition-colors">Symptoms of Radon Exposure</h3>
                    <p class="text-slate-600 leading-relaxed font-medium">The invisible DNA damage: uncovering the silent symptoms of long-term radon inhalation.</p>
                </a>

                <!-- Guide 6: Active vs Passive -->
                <a href="/guides/active-vs-passive-radon-system" class="group block">
                    <div class="aspect-w-16 aspect-h-9 w-full bg-slate-100 rounded-2xl mb-6 overflow-hidden">
                        <div class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300 bg-indigo-50 flex items-center justify-center">
                            <svg class="h-20 w-20 text-indigo-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5"><path stroke-linecap="round" stroke-linejoin="round" d="M19.428 15.428a2 2 0 00-1.022-.547l-2.387-.477a6 6 0 00-3.86.517l-.318.158a6 6 0 01-3.86.517L6.05 15.21a2 2 0 00-1.806.547M8 4h8l-1 1v5.172a2 2 0 00.586 1.414l5 5c1.26 1.26.367 3.414-1.415 3.414H4.828c-1.782 0-2.674-2.154-1.414-3.414l5-5A2 2 0 009 10.172V5L8 4z"/></svg>
                        </div>
                    </div>
                    <span class="inline-block py-1 px-3 rounded-full bg-indigo-50 text-indigo-700 text-xs font-bold tracking-wider uppercase mb-4">System Engineering</span>
                    <h3 class="font-display font-bold text-2xl text-slate-900 mb-3 group-hover:text-indigo-600 transition-colors">Active vs. Passive Radon Systems</h3>
                    <p class="text-slate-600 leading-relaxed font-medium">Learn why New Construction pipes fail without a fan, and what it costs to upgrade to full depressurization.</p>
                </a>

                <!-- Guide 7: Fan Noise -->
                <a href="/guides/radon-fan-noise-troubleshooting" class="group block">
                    <div class="aspect-w-16 aspect-h-9 w-full bg-slate-100 rounded-2xl mb-6 overflow-hidden">
                        <div class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300 bg-slate-100 flex items-center justify-center">
                            <svg class="h-20 w-20 text-slate-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5"><path stroke-linecap="round" stroke-linejoin="round" d="M15.536 8.464a5 5 0 010 7.072m2.828-9.9a9 9 0 010 12.728M5.586 15H4a1 1 0 01-1-1v-4a1 1 0 011-1h1.586l4.707-4.707C10.923 3.663 12 4.109 12 5v14c0 .891-1.077 1.337-1.707.707L5.586 15z"/></svg>
                        </div>
                    </div>
                    <span class="inline-block py-1 px-3 rounded-full bg-slate-100 text-slate-700 text-xs font-bold tracking-wider uppercase mb-4">Maintenance</span>
                    <h3 class="font-display font-bold text-2xl text-slate-900 mb-3 group-hover:text-indigo-600 transition-colors">Fan Noise Troubleshooting</h3>
                    <p class="text-slate-600 leading-relaxed font-medium">Diagnosing buzzing, humming, and humming fans. Learn when to replace the motor vs remounting the pipe.</p>
                </a>
                
                <!-- Guide 8: Crawl Space -->
                <a href="/guides/crawl-space-radon-mitigation" class="group block">
                    <div class="aspect-w-16 aspect-h-9 w-full bg-slate-100 rounded-2xl mb-6 overflow-hidden">
                        <div class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300 bg-indigo-50 flex items-center justify-center">
                            <svg class="h-20 w-20 text-indigo-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5"><path stroke-linecap="round" stroke-linejoin="round" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"/></svg>
                        </div>
                    </div>
                    <span class="inline-block py-1 px-3 rounded-full bg-indigo-50 text-indigo-700 text-xs font-bold tracking-wider uppercase mb-4">System Engineering</span>
                    <h3 class="font-display font-bold text-2xl text-slate-900 mb-3 group-hover:text-indigo-600 transition-colors">Crawl Space Mitigation Costs</h3>
                    <p class="text-slate-600 leading-relaxed font-medium">Why vapor barriers and sub-membrane setups cost $1,000 extra compared to basement installations.</p>
                </a>

                <!-- Guide 9: Sump Pump -->
                <a href="/guides/sump-pump-radon-mitigation" class="group block">
                    <div class="aspect-w-16 aspect-h-9 w-full bg-slate-100 rounded-2xl mb-6 overflow-hidden">
                        <div class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300 bg-indigo-50 flex items-center justify-center">
                            <svg class="h-20 w-20 text-indigo-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5"><path stroke-linecap="round" stroke-linejoin="round" d="M13 10V3L4 14h7v7l9-11h-7z"/></svg>
                        </div>
                    </div>
                    <span class="inline-block py-1 px-3 rounded-full bg-indigo-50 text-indigo-700 text-xs font-bold tracking-wider uppercase mb-4">System Engineering</span>
                    <h3 class="font-display font-bold text-2xl text-slate-900 mb-3 group-hover:text-indigo-600 transition-colors">Sump Pumps &amp; Unsealed Pits</h3>
                    <p class="text-slate-600 leading-relaxed font-medium">Why an open sump pump pit ruins your radon fan's suction, and how contractors seal them.</p>
                </a>

                <!-- Guide 10: Energy Costs -->
                <a href="/guides/radon-system-electricity-cost" class="group block">
                    <div class="aspect-w-16 aspect-h-9 w-full bg-slate-100 rounded-2xl mb-6 overflow-hidden">
                        <div class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300 bg-emerald-50 flex items-center justify-center">
                            <svg class="h-20 w-20 text-emerald-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5"><path stroke-linecap="round" stroke-linejoin="round" d="M12 2v20m0-20H5.5c-1.933 0-3.5 1.567-3.5 3.5S3.567 9 5.5 9H12m0-7h6.5A3.5 3.5 0 0122 5.5S20.433 9 18.5 9H12m0 12H5.5a3.5 3.5 0 01-3.5-3.5S3.567 11 5.5 11H12m0 7h6.5a3.5 3.5 0 003.5-3.5S20.433 11 18.5 11H12"/></svg>
                        </div>
                    </div>
                    <span class="inline-block py-1 px-3 rounded-full bg-emerald-50 text-emerald-700 text-xs font-bold tracking-wider uppercase mb-4">Running Costs</span>
                    <h3 class="font-display font-bold text-2xl text-slate-900 mb-3 group-hover:text-indigo-600 transition-colors">Radon System Electricity Cost</h3>
                    <p class="text-slate-600 leading-relaxed font-medium">Calculating the exact wattage and monthly impact of running a continuous-duty inline motor.</p>
                </a>

                <!-- Guide 11: Granite Myths -->
                <a href="/guides/radon-myths-granite-countertops" class="group block">
                    <div class="aspect-w-16 aspect-h-9 w-full bg-slate-100 rounded-2xl mb-6 overflow-hidden">
                        <div class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300 bg-cyan-50 flex items-center justify-center">
                            <svg class="h-20 w-20 text-cyan-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5"><path stroke-linecap="round" stroke-linejoin="round" d="M21 12a9 9 0 01-9 9m9-9a9 9 0 00-9-9m9 9H3m9 9a9 9 0 01-9-9m9 9c1.657 0 3-4.03 3-9s-1.343-9-3-9m0 18c-1.657 0-3-4.03-3-9s1.343-9 3-9m-9 9a9 9 0 019-9"/></svg>
                        </div>
                    </div>
                    <span class="inline-block py-1 px-3 rounded-full bg-cyan-50 text-cyan-700 text-xs font-bold tracking-wider uppercase mb-4">Testing &amp; Myths</span>
                    <h3 class="font-display font-bold text-2xl text-slate-900 mb-3 group-hover:text-indigo-600 transition-colors">Granite Countertops Myth vs Fact</h3>
                    <p class="text-slate-600 leading-relaxed font-medium">Do expensive kitchen countertops actually raise your radon levels, or is it a media hoax?</p>
                </a>
            </div>
            
            <div class="mt-24 bg-slate-50 border border-slate-200 rounded-2xl p-8 flex flex-col md:flex-row items-center justify-between gap-8">
                <div>
                    <h4 class="font-display font-bold text-xl text-slate-900 mb-2">Need an Exact Quote?</h4>
                    <p class="text-slate-600">Find the average mitigation price in your specific county and get matched with certified pros.</p>
                </div>
                <a href="/radon-cost-calculator" class="shrink-0 flex justify-center py-3 px-6 border border-transparent rounded-lg shadow-sm text-sm font-bold text-white bg-indigo-600 hover:bg-indigo-700 transition">
                    Use Local Calculator
                </a>
            </div>
        </div>
    `
)

