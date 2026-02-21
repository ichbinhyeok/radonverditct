@param String title

@template.layout.main(
    title = title,
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
