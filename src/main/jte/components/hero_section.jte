@import com.radonverdict.model.dto.CountyPageContent

@param CountyPageContent page

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

        <!-- Hero Title -->
        <h1 class="font-display font-black text-3xl sm:text-5xl lg:text-6xl text-white tracking-tighter leading-tight mb-6">
            ${page.getHeroTitle()}
        </h1>

        <!-- Hero Narrative & AEO Hook -->
        <div class="text-slate-300 text-base sm:text-xl leading-relaxed font-medium mb-6 space-y-4">
            <p><strong class="text-white">Quick Answer:</strong> The average cost for radon mitigation in <strong>${page.getReceipt().getAreaDisplayName()}</strong> is <strong>$${page.getReceipt().getTotalAvg()}</strong> (typically ranging from $${page.getReceipt().getTotalLow()} to $${page.getReceipt().getTotalHigh()}). ${page.getPricingRationale()}</p>
            <p>${page.getHeroSummary()}</p>
        </div>

        <!-- Deep Dive Narrative (Glassmorphism inset) -->
        <div class="bg-white/5 backdrop-blur-sm border border-white/10 rounded-2xl p-5 sm:p-6 text-sm text-slate-300 leading-relaxed font-medium">
            <p>${page.getRiskNarrative()}</p>
        </div>
    </div>
</div>
