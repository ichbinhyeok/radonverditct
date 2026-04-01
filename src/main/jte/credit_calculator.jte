@import com.radonverdict.model.County
@import com.radonverdict.model.dto.CountyPageContent

@param County county
@param CountyPageContent page
@param String canonicalActionPlanUrl

!{
    final boolean isSelling = "selling".equals(page.getSelectedIntent());
    final String countyDisplay = county.getSeoDisplayName() + ", " + county.getStateAbbr();
    final String pageTitle = (isSelling ? "Seller" : "Buyer") + " Radon Credit Calculator for " + countyDisplay;
    final String description = "Use local mitigation pricing in " + countyDisplay + " to set a repair request, closing credit, or compromise number for a radon negotiation.";
    final int openingAsk = page.getReceipt().getTotalAvg();
    final int ceilingAsk = page.getReceipt().getTotalHigh();
    final int splitFallback = Math.max(100, ((page.getReceipt().getTotalAvg() / 2 + 25) / 50) * 50);
    final int quickCloseTarget = Math.max(100, (((page.getReceipt().getTotalLow() + page.getReceipt().getTotalAvg()) / 2 + 25) / 50) * 50);
    final String openingLabel = isSelling ? "Reserve target" : "Opening ask";
    final String ceilingLabel = isSelling ? "No-surprise ceiling" : "Defensible ceiling";
    final String splitLabel = isSelling ? "Compromise floor" : "Split-cost fallback";
    final String quickCloseLabel = isSelling ? "Fast-close credit" : "Quick-close target";
    final String heroSummary = isSelling
            ? "If you want a cleaner close in " + county.getAreaDisplayName() + ", budget around $" + openingAsk
                    + " first and keep $" + ceilingAsk
                    + " in reserve before the buyer starts naming numbers."
            : "If you are negotiating after a radon result in " + county.getAreaDisplayName() + ", start around $"
                    + openingAsk + " and keep $" + ceilingAsk
                    + " as your strongest local ceiling if routing or timing gets harder.";
}

@template.layout.main(
    title = pageTitle,
    description = description,
    canonicalUrl = canonicalActionPlanUrl,
    noindex = true,
    content = @`
        <div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-10 pb-20">
            <nav class="text-sm font-medium text-slate-500 mb-8" aria-label="Breadcrumb">
                <ol class="inline-flex items-center space-x-2">
                    <li><a href="/" class="hover:text-slate-900 transition-colors">Home</a></li>
                    <li><span class="mx-1 text-slate-300">/</span></li>
                    <li><a href="/radon-mitigation-cost/${county.getStateSlug()}/${county.getCountySlug()}" class="hover:text-slate-900 transition-colors">${county.getAreaDisplayName()} Cost Page</a></li>
                    <li><span class="mx-1 text-slate-300">/</span></li>
                    <li class="text-slate-900 font-semibold" aria-current="page">Credit Calculator</li>
                </ol>
            </nav>

            <section class="rounded-[2.5rem] border border-slate-800 bg-slate-900 px-8 py-10 sm:px-12 sm:py-14 shadow-2xl relative overflow-hidden">
                <div class="absolute inset-0 opacity-10 bg-[radial-gradient(circle_at_top_right,_rgba(96,165,250,0.45),_transparent_35%),radial-gradient(circle_at_bottom_left,_rgba(244,114,182,0.35),_transparent_30%)]"></div>
                <div class="relative z-10 max-w-3xl">
                    <div class="inline-flex items-center gap-2 rounded-full border border-white/10 bg-white/10 px-3 py-1 text-[11px] font-bold uppercase tracking-widest text-slate-200">
                        Local Transaction Calculator
                    </div>
                    <h1 class="mt-4 font-display text-3xl font-black tracking-tight text-white sm:text-5xl">
                        ${pageTitle}
                    </h1>
                    <p class="mt-5 text-base leading-relaxed text-slate-300 sm:text-xl">
                        ${heroSummary}
                    </p>
                    <div class="mt-6 flex flex-wrap gap-3 text-xs font-bold uppercase tracking-wider text-slate-300">
                        <span class="rounded-full border border-white/10 bg-white/5 px-3 py-1">${page.getSelectedRadonResultBandLabel()}</span>
                        <span class="rounded-full border border-white/10 bg-white/5 px-3 py-1">${page.getSelectedFoundationLabel()}</span>
                        <span class="rounded-full border border-white/10 bg-white/5 px-3 py-1">${page.getSelectedSqftLabel()}</span>
                    </div>
                </div>
            </section>

            <section class="mt-8 grid gap-4 md:grid-cols-2 xl:grid-cols-4">
                <div class="rounded-3xl border border-slate-200 bg-white p-6 shadow-sm">
                    <p class="text-xs font-bold uppercase tracking-widest text-slate-500">${openingLabel}</p>
                    <p class="mt-3 font-display text-4xl font-black tracking-tight text-slate-900">$${openingAsk}</p>
                    <p class="mt-3 text-sm leading-relaxed text-slate-600">
                        @if(isSelling)
                            The number to budget before you agree to a credit or repair concession.
                        @else
                            The cleanest first number to ask for when you want a realistic local credit.
                        @endif
                    </p>
                </div>
                <div class="rounded-3xl border border-slate-200 bg-white p-6 shadow-sm">
                    <p class="text-xs font-bold uppercase tracking-widest text-slate-500">${ceilingLabel}</p>
                    <p class="mt-3 font-display text-4xl font-black tracking-tight text-slate-900">$${ceilingAsk}</p>
                    <p class="mt-3 text-sm leading-relaxed text-slate-600">
                        Use this when the route looks harder, the reading is clearly elevated, or timing risk is real.
                    </p>
                </div>
                <div class="rounded-3xl border border-slate-200 bg-white p-6 shadow-sm">
                    <p class="text-xs font-bold uppercase tracking-widest text-slate-500">${quickCloseLabel}</p>
                    <p class="mt-3 font-display text-4xl font-black tracking-tight text-slate-900">$${quickCloseTarget}</p>
                    <p class="mt-3 text-sm leading-relaxed text-slate-600">
                        A lower-friction number when both sides care more about speed than squeezing the last dollar.
                    </p>
                </div>
                <div class="rounded-3xl border border-slate-200 bg-white p-6 shadow-sm">
                    <p class="text-xs font-bold uppercase tracking-widest text-slate-500">${splitLabel}</p>
                    <p class="mt-3 font-display text-4xl font-black tracking-tight text-slate-900">$${splitFallback}</p>
                    <p class="mt-3 text-sm leading-relaxed text-slate-600">
                        Keep this in reserve if the conversation moves toward sharing cost instead of full seller coverage.
                    </p>
                </div>
            </section>

            <section class="mt-8 grid gap-6 lg:grid-cols-[1.3fr_0.9fr]">
                <div class="rounded-3xl border border-slate-200 bg-white p-6 sm:p-8 shadow-sm">
                    <h2 class="font-display text-2xl font-bold tracking-tight text-slate-900">How to use the local number</h2>
                    <div class="mt-6 space-y-4">
                        <div class="rounded-2xl border border-slate-200 bg-slate-50 p-5">
                            <p class="text-xs font-bold uppercase tracking-widest text-slate-500">Seller repairs before closing</p>
                            <p class="mt-2 text-lg font-bold text-slate-900">$${openingAsk} to $${ceilingAsk}</p>
                            <p class="mt-2 text-sm leading-relaxed text-slate-600">
                                Use this range when the deal depends on the issue being fixed before move-in. The average keeps the ask grounded, while the high end protects you if the contractor flags harder routing.
                            </p>
                        </div>
                        <div class="rounded-2xl border border-slate-200 bg-slate-50 p-5">
                            <p class="text-xs font-bold uppercase tracking-widest text-slate-500">Closing credit</p>
                            <p class="mt-2 text-lg font-bold text-slate-900">$${quickCloseTarget} to $${openingAsk}</p>
                            <p class="mt-2 text-sm leading-relaxed text-slate-600">
                                Best when both sides want a faster close. Start near the quick-close target if speed matters; use the average when you want a stronger but still defensible local number.
                            </p>
                        </div>
                        <div class="rounded-2xl border border-slate-200 bg-slate-50 p-5">
                            <p class="text-xs font-bold uppercase tracking-widest text-slate-500">Fallback if the seller pushes back</p>
                            <p class="mt-2 text-lg font-bold text-slate-900">$${splitFallback}</p>
                            <p class="mt-2 text-sm leading-relaxed text-slate-600">
                                This is not the first number. It is the compromise line to keep the deal moving if the seller refuses full coverage but both sides still want to close.
                            </p>
                        </div>
                    </div>
                </div>

                <div class="rounded-3xl border border-slate-200 bg-white p-6 sm:p-8 shadow-sm">
                    <h2 class="font-display text-2xl font-bold tracking-tight text-slate-900">Copy you can reuse</h2>
                    <div class="mt-6 rounded-2xl border border-indigo-200 bg-indigo-50 p-5">
                        <p class="text-xs font-bold uppercase tracking-widest text-indigo-700">Sample request</p>
                        <p class="mt-3 text-sm leading-relaxed text-indigo-950">
                            Based on local mitigation pricing in ${county.getAreaDisplayName()}, we are requesting a radon repair or closing credit sized to cover a typical installation. Our working local range is $${quickCloseTarget} to $${openingAsk}, with a ceiling of $${ceilingAsk} if the final scope is more complex.
                        </p>
                    </div>

                    <div class="mt-5 rounded-2xl border border-slate-200 bg-slate-50 p-5">
                        <p class="text-xs font-bold uppercase tracking-widest text-slate-500">Why this is stronger than a national average</p>
                        <p class="mt-3 text-sm leading-relaxed text-slate-600">
                            Your county action plan already reflects local pricing, foundation type, and home-size context. That keeps the conversation anchored to a real local range instead of a generic nationwide number.
                        </p>
                    </div>

                    <div class="mt-6 flex flex-col gap-3">
                        <a href="/guides/radon-seller-credit-worksheet"
                           data-track-event="credit_calculator_click"
                           data-track-label="${county.getCountySlug()}-${page.getSelectedIntent()}-${page.getSelectedRadonResultBand()}-worksheet"
                           class="inline-flex items-center justify-center rounded-xl bg-slate-900 px-5 py-3 text-sm font-bold text-white transition-colors hover:bg-slate-800">
                            Open Seller Credit Worksheet
                        </a>
                        <a href="${canonicalActionPlanUrl}#estimate-form"
                           data-track-event="credit_calculator_click"
                           data-track-label="${county.getCountySlug()}-${page.getSelectedIntent()}-${page.getSelectedRadonResultBand()}-plan"
                           class="inline-flex items-center justify-center rounded-xl border border-slate-200 bg-white px-5 py-3 text-sm font-semibold text-slate-700 transition-colors hover:bg-slate-50">
                            Open Full Local Action Plan
                        </a>
                    </div>
                </div>
            </section>
        </div>
    `
)
