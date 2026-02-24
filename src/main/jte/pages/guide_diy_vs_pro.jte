@param String title

@template.layout.main(
    title = title,
    description = "A detailed breakdown of DIY radon mitigation vs. hiring a professional, including hidden costs and legal implications.",
    content = @`
        <div class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-16 md:py-24 prose prose-slate md:prose-lg max-w-none">
            <a href="/guides" class="not-prose inline-flex items-center gap-1 text-xs font-bold text-slate-400 hover:text-indigo-600 transition-colors uppercase tracking-wider mb-6"><svg class="w-3 h-3" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3"><path stroke-linecap="round" stroke-linejoin="round" d="M15 19l-7-7 7-7"/></svg> All Guides</a>
            <span class="inline-block py-1 px-3 rounded-full bg-indigo-50 text-indigo-700 text-xs font-bold tracking-wider uppercase mb-6 ml-3">Cost Strategy</span>
            <h1 class="font-display font-bold text-4xl text-slate-900 mb-6 tracking-tight">DIY Radon Mitigation vs. Hiring a Professional: The Real Costs</h1>
            <p class="lead text-xl text-slate-600 mb-10 leading-relaxed font-medium pb-10 border-b border-slate-200">
                With average professional mitigation systems costing between $1,200 and $1,800, many homeowners ask: "Can I just install this myself?" The answer is yes, you can. But a better question is: *Should* you?
            </p>

            <h2 class="font-display font-bold text-2xl text-slate-900 mt-12 mb-4">The True Cost of a DIY System</h2>
            <p class="text-slate-600 mb-6">
                On paper, a DIY radon mitigation system looks like an incredible deal. 
            </p>
            <ul class="list-disc pl-6 text-slate-600 mb-6 space-y-2">
                <li><strong>Radon Fan:</strong> $150 - $250</li>
                <li><strong>PVC Piping (3" or 4"):</strong> $60 - $100</li>
                <li><strong>Manometer (Liquid Gauge):</strong> $15 - $25</li>
                <li><strong>Sealants & Coring Bits:</strong> $100 - $150</li>
            </ul>
            <p class="text-slate-700 font-semibold mb-8">
                <strong>Total Material Cost: ~$325 - $525</strong>
            </p>
            
            <p class="text-slate-600 mb-6">
                If the average professional installation is $1,500, you're looking at nearly $1,000 in savings. However, DIYers routinely overlook the specialized tools required for this project, specifically the heavy-duty hammer drills and concrete coring bits required to cut a perfectly round hole through a 4 to 6-inch basement slab. 
            </p>

            <h2 class="font-display font-bold text-2xl text-slate-900 mt-12 mb-4">The 3 Major Risks of DIY Mitigation</h2>
            
            <h3 class="font-display font-bold text-xl text-slate-800 mt-8 mb-3">1. Pressurization Failures (Creating an Exhaust Leak)</h3>
            <p class="text-slate-600 mb-6">
                The core of an Active Sub-Slab Depressurization (ASD) system isn't blowing air *out*. It's creating negative pressure *beneath* the house so radon never enters. If your PVC piping leaks in the attic, or you fail to properly seal the foundation cracks, the fan will actually pull radon gas *into* your living areas before exhausting it.
            </p>
            
            <h3 class="font-display font-bold text-xl text-slate-800 mt-8 mb-3">2. State Code and Electrical Violations</h3>
            <p class="text-slate-600 mb-6">
                Radon fans must be installed outside the conditioned living space (typically the attic or exterior). This means running hard-wired electrical lines to locations that usually don't have outlets. If you do this without an electrical permit, your home insurance could be voided in the event of a fire.
            </p>
            
            <h3 class="font-display font-bold text-xl text-slate-800 mt-8 mb-3">3. The Resale Liability</h3>
            <p class="text-slate-600 mb-6">
                This is the ultimate deal-breaker. When you go to sell your home, the buyer's inspector will invariably flag a DIY radon system. Buyers heavily rely on certifications and warranties. If the system was not installed by a state-certified professional to EPA standards, a buyer will likely demand a completely new system be installed before closing. Your $1,000 "savings" evaporates instantly at the negotiation table.
            </p>
            
            <h2 class="font-display font-bold text-2xl text-slate-900 mt-12 mb-4">The Verdict</h2>
            <p class="text-slate-600 mb-8">
                We strongly advise against DIY radon mitigation. The structural risks of drilling your foundation, the potential electrical hazards, and the guaranteed friction when selling your home vastly outweigh the labor savings. 
            </p>

            <div class="bg-indigo-50 border border-indigo-100 rounded-2xl p-8 mt-12 text-slate-900 shadow-sm relative overflow-hidden">
                <div class="absolute top-0 right-0 -mr-16 -mt-16 w-32 h-32 rounded-full bg-indigo-200 opacity-50 blur-2xl"></div>
                <h3 class="font-display font-bold text-xl text-indigo-950 mb-3 relative z-10">Check mitigation costs &amp; local requirements for your county.</h3>
                <p class="text-indigo-800 mb-6 text-sm leading-relaxed relative z-10">Don't guess on price or rely on national averages. See an itemized cost estimate specific to your state’s labor rates and foundation types.</p>
                <a href="/radon-cost-calculator" class="inline-flex items-center justify-center px-6 py-3 border border-transparent text-sm font-bold rounded-xl text-white bg-indigo-600 hover:bg-indigo-700 transition relative z-10 shadow-sm">
                    Calculate My Local Cost →
                </a>
            </div>
        </div>
    `
)
