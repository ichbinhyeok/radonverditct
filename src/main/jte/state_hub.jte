@import java.util.List
@import com.radonverdict.model.County

@param String stateSlug
@param String stateAbbr
@param List<County> counties
@param boolean noindex = false

!{
    String[] stateSlugParts = stateSlug.split("-");
    StringBuilder stateNameBuilder = new StringBuilder();
    for (int i = 0; i < stateSlugParts.length; i++) {
        String part = stateSlugParts[i];
        if (part == null || part.isBlank()) {
            continue;
        }
        String normalized = part.toLowerCase(java.util.Locale.ROOT);
        String displayPart;
        if (i > 0 && ("of".equals(normalized) || "and".equals(normalized))) {
            displayPart = normalized;
        } else {
            displayPart = normalized.substring(0, 1).toUpperCase(java.util.Locale.ROOT) + normalized.substring(1);
        }
        if (stateNameBuilder.length() > 0) {
            stateNameBuilder.append(" ");
        }
        stateNameBuilder.append(displayPart);
    }
    final String stateName = stateNameBuilder.length() > 0 ? stateNameBuilder.toString() : stateAbbr;
}

@template.layout.main(
    title = stateName + " Radon Mitigation Cost by County (" + java.time.LocalDate.now().getYear() + ") | Local Price Guide",
    description = "Compare " + stateName + " radon mitigation cost ranges by county for basement, slab, and crawl space homes. Built for homeowners who already have a radon test result and need local quote context.",
    canonicalUrl = "https://radonverdict.com/radon-mitigation-cost/" + stateSlug,
    noindex = noindex,
    content = @`
        <div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
            <!-- Breadcrumbs -->
            <nav class="text-sm font-medium text-slate-500 mb-8" aria-label="Breadcrumb">
                <ol class="inline-flex items-center space-x-2">
                    <li><a href="/" class="hover:text-slate-900 transition-colors">Home</a></li>
                    <li><span class="mx-1 text-slate-300">/</span></li>
                    <li class="text-slate-900 font-semibold" aria-current="page">${stateName}</li>
                </ol>
            </nav>

            <div class="text-center mb-16">
                <span class="inline-flex items-center gap-2 px-3 py-1 rounded-full text-xs font-bold tracking-wider uppercase bg-brand-50 text-brand-700 border border-brand-200 mb-6 shadow-sm">
                    <span class="w-2 h-2 rounded-full bg-brand-500"></span>
                    ${stateName} Price Guide
                </span>
                <h1 class="font-display font-black text-3xl sm:text-5xl lg:text-6xl text-slate-900 tracking-tighter leading-tight mb-6">
                    ${stateName} Radon Mitigation Cost by County
                </h1>
                <p class="text-slate-500 text-lg sm:text-xl leading-relaxed font-medium max-w-2xl mx-auto">
                    Compare typical local price ranges for basement, slab, and crawl space systems. Start with your county if you already have a radon result and need realistic quote context.
                </p>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-10">
                <a href="/radon-cost-calculator"
                   class="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm hover:border-brand-300 hover:shadow-md transition-all">
                    <p class="text-xs font-bold uppercase tracking-wider text-brand-700 mb-2">Fastest Start</p>
                    <h2 class="font-display font-bold text-lg text-slate-900 mb-2">Use ZIP Instead of Scrolling</h2>
                    <p class="text-sm text-slate-600 leading-relaxed">If you know the property ZIP, jump straight to the right county estimate instead of browsing the full state list.</p>
                </a>
                <a href="/radon-levels/${stateSlug}"
                   class="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm hover:border-indigo-300 hover:shadow-md transition-all">
                    <p class="text-xs font-bold uppercase tracking-wider text-indigo-600 mb-2">Validate the Risk</p>
                    <h2 class="font-display font-bold text-lg text-slate-900 mb-2">Check ${stateAbbr} Radon Levels</h2>
                    <p class="text-sm text-slate-600 leading-relaxed">If you do not have a confirmed radon result yet, review EPA zone context before you compare mitigation pricing.</p>
                </a>
                <a href="#county-pricing"
                   class="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm hover:border-emerald-300 hover:shadow-md transition-all">
                    <p class="text-xs font-bold uppercase tracking-wider text-emerald-600 mb-2">Browse Counties</p>
                    <h2 class="font-display font-bold text-lg text-slate-900 mb-2">Jump to County Pricing</h2>
                    <p class="text-sm text-slate-600 leading-relaxed">Open your county if you already know the area and just need a local basement, slab, or crawl-space price range.</p>
                </a>
            </div>

            <!-- County Grid -->
            <div id="county-pricing" class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4 mb-24">
                @for(County county : counties)
                    <a href="/radon-mitigation-cost/${stateSlug}/${county.getCountySlug()}" 
                       class="flex items-center justify-between p-4 bg-white rounded-xl shadow-sm border border-slate-200 hover:border-brand-400 hover:shadow-md hover:bg-brand-50 transition-all group">
                        <span class="font-display font-semibold text-slate-700 group-hover:text-brand-800">${county.getAreaDisplayName()}</span>
                        <svg class="w-4 h-4 text-slate-300 group-hover:text-brand-500 transform group-hover:translate-x-1 transition-transform" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M9 5l7 7-7 7" />
                        </svg>
                    </a>
                @endfor
            </div>

            <!-- Cross-Silo Link to Radon Levels -->
            <div class="flex flex-col sm:flex-row gap-4 mb-12">
                <a href="/radon-levels/${stateSlug}"
                   class="flex items-center gap-3 p-4 rounded-xl border border-slate-200 bg-white hover:border-indigo-300 hover:shadow-md transition-all group flex-1">
                    <div class="w-10 h-10 rounded-lg bg-indigo-50 text-indigo-600 flex items-center justify-center shrink-0">
                        <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" /></svg>
                    </div>
                    <div>
                        <span class="block font-bold text-sm text-slate-800 group-hover:text-indigo-600 transition-colors">${stateAbbr} Radon Levels by County</span>
                        <span class="text-xs text-slate-500">View EPA zone data and risk classifications</span>
                    </div>
                </a>
                <a href="/guides/how-to-test-for-radon"
                   class="flex items-center gap-3 p-4 rounded-xl border border-slate-200 bg-white hover:border-indigo-300 hover:shadow-md transition-all group flex-1">
                    <div class="w-10 h-10 rounded-lg bg-emerald-50 text-emerald-600 flex items-center justify-center shrink-0">
                        <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" /></svg>
                    </div>
                    <div>
                        <span class="block font-bold text-sm text-slate-800 group-hover:text-indigo-600 transition-colors">How to Test for Radon</span>
                        <span class="text-xs text-slate-500">Complete homeowner's testing guide</span>
                    </div>
                </a>
            </div>

            <!-- Contextual State Info (Call to Action to pick a county) -->
            <div class="bg-slate-50 rounded-3xl p-8 sm:p-10 border border-slate-100 mt-10">
                <div class="flex flex-col md:flex-row items-center gap-8 text-center md:text-left">
                    <div class="w-24 h-24 bg-white rounded-full shadow-sm border border-slate-100 flex items-center justify-center shrink-0">
                        <svg class="w-10 h-10 text-brand-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M3 6l3 1m0 0l-3 9a5.002 5.002 0 006.001 0M6 7l3 9M6 7l6-2m6 2l3-1m-3 1l-3 9a5.002 5.002 0 006.001 0M18 7l3 9m-3-9l-6-2m0-2v2m0 16V5m0 16H9m3 0h3" />
                        </svg>
                    </div>
                    <div>
                        <h3 class="font-display font-extrabold text-2xl text-slate-900 tracking-tight mb-2">Why Does Cost Vary in ${stateName}?</h3>
                        <p class="text-slate-600 font-medium leading-relaxed">Price ranges across ${stateName} move with local labor rates, permit friction, roofline routing, and foundation type. County pages narrow this down for homeowners comparing basement, slab, or crawl space mitigation after a confirmed radon reading.</p>
                    </div>
                </div>
            </div>
        </div>
    `
)

