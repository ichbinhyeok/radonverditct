@import com.radonverdict.model.dto.CountyPageContent

@param CountyPageContent page

!{
    final boolean notTested = "not_tested".equals(page.getSelectedRadonResultBand());
    final String budgetLabel = notTested ? "Future Cost Context:" : "Budget Context:";
}

<div class="mb-12 relative overflow-hidden rounded-[2.5rem] bg-slate-900 border border-slate-800 p-8 sm:p-12 shadow-2xl">
    <!-- Decorative background elements -->
    <div class="absolute top-0 right-0 -mr-20 -mt-20 w-64 h-64 rounded-full mix-blend-multiply filter blur-3xl opacity-20 pointer-events-none 
        @if("red".equals(page.getBadgeColor())) bg-rose-500 @elseif("yellow".equals(page.getBadgeColor())) bg-amber-500 @else bg-emerald-500 @endif">
    </div>

    <div class="relative z-10 max-w-3xl">
        <!-- Zone Badge -->
        <span class="inline-flex items-center gap-2 px-3 py-1 rounded-full text-xs font-bold tracking-wider uppercase bg-white/10 text-white backdrop-blur-md border border-white/20 mb-6 shadow-sm">
            <span class="w-2 h-2 rounded-full shadow-sm shadow-current 
                @if("red".equals(page.getBadgeColor())) bg-rose-400 @elseif("yellow".equals(page.getBadgeColor())) bg-amber-400 @else bg-emerald-400 @endif
            "></span>
            EPA Zone ${page.getRiskLevel()} Risk
        </span>
        <div class="mb-4">
            <span class="inline-flex items-center gap-2 rounded-full bg-white/10 px-3 py-1 text-[11px] font-bold uppercase tracking-wider text-slate-200 border border-white/10">
                Scenario
                <span class="text-white">${page.getSelectedRadonResultBandLabel()}</span>
            </span>
        </div>

        <!-- Hero Title -->
        <h1 class="font-display font-black text-3xl sm:text-5xl lg:text-6xl text-white tracking-tighter leading-tight mb-6">
            ${page.getHeroTitle()}
        </h1>

        <!-- Hero Narrative & AEO Hook -->
        <div class="text-slate-300 text-base sm:text-xl leading-relaxed font-medium mb-6 space-y-4">
            <p><strong class="text-white">Quick Answer:</strong> ${page.getHeroSummary()}</p>
            <p><strong class="text-white">${budgetLabel}</strong> Typical local pricing centers around <strong>$${page.getReceipt().getTotalAvg()}</strong> and the common range is <strong>$${page.getReceipt().getTotalLow()} to $${page.getReceipt().getTotalHigh()}</strong>. ${page.getPricingRationale()}</p>
        </div>

        @if(notTested)
            <div class="mb-6 rounded-2xl border border-emerald-400/20 bg-emerald-500/10 p-5 text-sm text-emerald-50">
                <p class="font-bold uppercase tracking-widest text-[11px] text-emerald-200">Best First Step</p>
                <p class="mt-2 leading-relaxed">
                    Do not treat this as a quote request page yet. Test first, then come back with your real reading if it lands near or above the action range.
                </p>
                <div class="mt-4 flex flex-col gap-3 sm:flex-row">
                    <a href="/guides/how-to-test-for-radon" class="inline-flex items-center justify-center rounded-xl bg-white px-4 py-2.5 text-sm font-bold text-slate-900 transition-colors hover:bg-slate-100">
                        Start With the Testing Guide
                    </a>
                    <a href="#estimate-form" class="inline-flex items-center justify-center rounded-xl border border-white/20 px-4 py-2.5 text-sm font-bold text-white transition-colors hover:bg-white/10">
                        Skip to the Local Plan Form
                    </a>
                </div>
            </div>
        @endif

        <!-- Deep Dive Narrative (Glassmorphism inset) -->
        <div class="bg-white/5 backdrop-blur-sm border border-white/10 rounded-2xl p-5 sm:p-6 text-sm text-slate-300 leading-relaxed font-medium">
            <p>${page.getRiskNarrative()}</p>
        </div>
    </div>
</div>
