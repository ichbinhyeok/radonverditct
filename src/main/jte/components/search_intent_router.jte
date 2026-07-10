@import com.radonverdict.model.County

@param County county = null
@param String className = "mt-16"
@param String sectionId = "search-intent-router"

!{
    final boolean hasCounty = county != null;
    final String placeLabel = hasCounty
            ? county.getAreaDisplayName() + ", " + county.getStateAbbr()
            : "your home";
    final String costPath = hasCounty
            ? "/radon-mitigation-cost/" + county.getStateSlug() + "/" + county.getCountySlug()
            : "/radon-cost-calculator";
    final String levelsPath = hasCounty
            ? "/radon-levels/" + county.getStateSlug() + "/" + county.getCountySlug()
            : "/radon-levels";
    final String creditPath = hasCounty
            ? "/radon-credit-calculator/" + county.getStateSlug() + "/" + county.getCountySlug()
            : "/radon-credit-calculator";
    final String highResultCostPath = hasCounty
            ? costPath + "?radonResultBand=above_4&intent=homeowner#estimate-form"
            : "/radon-cost-calculator";
    final String failedInspectionPath = hasCounty
            ? creditPath + "?intent=buying&radonResultBand=above_4&foundation=basement"
            : "/guides/radon-failed-inspection";
    final String sellerResponsePath = hasCounty
            ? creditPath + "?intent=selling&radonResultBand=above_4&foundation=basement"
            : "/radon-credit-calculator";
    final String borderlinePath = hasCounty
            ? levelsPath + "#result-translator"
            : "/radon-levels#level-meaning";
    final String basementPath = hasCounty
            ? costPath + "?foundation=basement&radonResultBand=above_4&intent=homeowner#estimate-form"
            : "/radon-cost-calculator?foundation=basement";
    final String slabPath = hasCounty
            ? costPath + "?foundation=slab&radonResultBand=above_4&intent=homeowner#estimate-form"
            : "/radon-cost-calculator?foundation=slab";
    final String crawlspacePath = hasCounty
            ? costPath + "?foundation=crawlspace&radonResultBand=above_4&intent=homeowner#estimate-form"
            : "/radon-cost-calculator?foundation=crawlspace";
    final String quoteCheckerPath = "/radon-quote-ledger#quote-checker";
}

<section id="${sectionId}" class="${className} rounded-[1.75rem] border border-slate-200 bg-white p-5 shadow-sm sm:p-6">
    <div class="grid gap-6 lg:grid-cols-[0.82fr_1.18fr] lg:items-start">
        <div>
            <p class="text-xs font-bold uppercase tracking-[0.22em] text-slate-500">Choose your next step</p>
            <h2 class="mt-3 font-display text-2xl font-black tracking-tight text-slate-950 sm:text-3xl">
                Start from the exact job, not another generic radon article.
            </h2>
            <p class="mt-3 text-sm leading-relaxed text-slate-600">
                Pick the situation that matches ${placeLabel}. Each route keeps the reading, deal side, or foundation clue attached so the next page answers the search instead of resetting the user.
            </p>
        </div>

        <div class="grid gap-3">
            <div class="grid gap-3 md:grid-cols-2">
                <a href="${failedInspectionPath}"
                   data-track-event="search_intent_router_click"
                   data-track-label="failed_inspection"
                   class="group rounded-2xl border border-rose-200 bg-rose-50 p-4 transition-colors hover:border-rose-300 hover:bg-rose-100">
                    <p class="text-xs font-black uppercase tracking-wider text-rose-700">Failed inspection</p>
                    <h3 class="mt-2 text-lg font-black text-slate-950">I need a repair or seller credit number</h3>
                    <p class="mt-2 text-sm leading-relaxed text-slate-700">Open the local credit path with a 4.0+ buyer scenario already selected.</p>
                    <span class="mt-3 inline-flex text-sm font-black text-rose-800">Open negotiation route</span>
                </a>

                <a href="${highResultCostPath}"
                   data-track-event="search_intent_router_click"
                   data-track-label="above_4_cost"
                   class="group rounded-2xl border border-slate-200 bg-slate-50 p-4 transition-colors hover:border-slate-400 hover:bg-slate-100">
                    <p class="text-xs font-black uppercase tracking-wider text-slate-500">4.0+ pCi/L</p>
                    <h3 class="mt-2 text-lg font-black text-slate-950">I have a high result and need the cost path</h3>
                    <p class="mt-2 text-sm leading-relaxed text-slate-700">Go straight to the county estimate, quote context, and contractor checklist.</p>
                    <span class="mt-3 inline-flex text-sm font-black text-slate-950">Open cost route</span>
                </a>

                <a href="${borderlinePath}"
                   data-track-event="search_intent_router_click"
                   data-track-label="borderline_result"
                   class="group rounded-2xl border border-amber-200 bg-amber-50 p-4 transition-colors hover:border-amber-300 hover:bg-amber-100">
                    <p class="text-xs font-black uppercase tracking-wider text-amber-700">2.0-3.9 pCi/L</p>
                    <h3 class="mt-2 text-lg font-black text-slate-950">I need to know if this number is bad</h3>
                    <p class="mt-2 text-sm leading-relaxed text-slate-700">Use the level explanation first, then decide whether to retest, monitor, or price mitigation.</p>
                    <span class="mt-3 inline-flex text-sm font-black text-amber-800">Open level route</span>
                </a>

                <a href="/guides/how-to-test-for-radon"
                   data-track-event="search_intent_router_click"
                   data-track-label="not_tested"
                   class="group rounded-2xl border border-emerald-200 bg-emerald-50 p-4 transition-colors hover:border-emerald-300 hover:bg-emerald-100">
                    <p class="text-xs font-black uppercase tracking-wider text-emerald-700">No test yet</p>
                    <h3 class="mt-2 text-lg font-black text-slate-950">I need the first valid result</h3>
                    <p class="mt-2 text-sm leading-relaxed text-slate-700">Start with kit placement, timing, closed-house conditions, and result interpretation.</p>
                    <span class="mt-3 inline-flex text-sm font-black text-emerald-800">Open testing route</span>
                </a>
            </div>

            <div class="rounded-2xl border border-slate-200 bg-slate-950 p-4 text-white">
                <div class="grid gap-4 lg:grid-cols-3">
                    <div>
                        <p class="text-xs font-bold uppercase tracking-[0.2em] text-slate-400">Foundation fast lanes</p>
                        <div class="mt-3 grid grid-cols-3 gap-2">
                            <a href="${basementPath}" class="rounded-xl border border-white/10 bg-white/10 px-3 py-2 text-center text-xs font-black text-white transition-colors hover:bg-white/15">Basement</a>
                            <a href="${slabPath}" class="rounded-xl border border-white/10 bg-white/10 px-3 py-2 text-center text-xs font-black text-white transition-colors hover:bg-white/15">Slab</a>
                            <a href="${crawlspacePath}" class="rounded-xl border border-white/10 bg-white/10 px-3 py-2 text-center text-xs font-black text-white transition-colors hover:bg-white/15">Crawlspace</a>
                        </div>
                    </div>
                    <div>
                        <p class="text-xs font-bold uppercase tracking-[0.2em] text-slate-400">Deal fast lanes</p>
                        <div class="mt-3 grid grid-cols-2 gap-2">
                            <a href="${failedInspectionPath}" class="rounded-xl border border-white/10 bg-white px-3 py-2 text-center text-xs font-black text-slate-950 transition-colors hover:bg-slate-100">Buyer ask</a>
                            <a href="${sellerResponsePath}" class="rounded-xl border border-white/10 bg-white/10 px-3 py-2 text-center text-xs font-black text-white transition-colors hover:bg-white/15">Seller response</a>
                        </div>
                    </div>
                    <div>
                        <p class="text-xs font-bold uppercase tracking-[0.2em] text-slate-400">Already got a bid?</p>
                        <a href="${quoteCheckerPath}"
                           data-track-event="search_intent_router_click"
                           data-track-label="quote_checker"
                           class="mt-3 flex min-h-[40px] items-center justify-center rounded-xl border border-cyan-200 bg-cyan-50 px-3 py-2 text-center text-xs font-black text-slate-950 transition-colors hover:bg-white">
                            Check quote fairness
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
