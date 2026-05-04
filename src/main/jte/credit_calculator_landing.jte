@import java.util.List
@import java.util.Map
@import com.radonverdict.model.County
@import com.radonverdict.model.dto.ItemizedReceipt
@import com.radonverdict.model.dto.TrustMetadata

@param String title
@param ItemizedReceipt defaultReceipt
@param Map<String, List<County>> stateMap
@param TrustMetadata trust = null
@param boolean noindex = false

@template.layout.main(
    title = title,
    canonicalUrl = "https://radonverdict.com/radon-credit-calculator",
    description = "Use a failed radon inspection result to estimate a local seller credit, repair request, or price reduction before a buyer-seller negotiation.",
    noindex = noindex,
    content = @`
        <div class="bg-slate-950 border-b border-slate-800">
            <div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 pt-16 pb-18">
                <div class="max-w-4xl">
                    <span class="inline-flex items-center gap-2 rounded-full border border-white/10 bg-white/5 px-3 py-1 text-xs font-bold uppercase tracking-wider text-slate-300">
                        Failed Inspection Negotiation Tool
                    </span>
                    <h1 class="mt-5 font-display text-4xl font-black tracking-tight text-white sm:text-6xl">
                        Radon Failed Inspection <span class="text-slate-400">Credit Calculator</span>
                    </h1>
                    <p class="mt-6 max-w-3xl text-lg leading-relaxed text-slate-300 sm:text-xl">
                        A failed radon inspection changes the conversation from "is radon a problem?" to "who pays, how much, and how fast?" Enter the property ZIP code to open a county-specific seller credit, repair request, or price-reduction range.
                    </p>
                    <div class="mt-5 flex flex-col gap-3 text-sm font-semibold text-slate-300 sm:flex-row sm:items-center">
                        <a href="/guides/who-pays-radon-mitigation-buyer-or-seller"
                           class="inline-flex items-center gap-2 text-sky-300 transition-colors hover:text-sky-200">
                            Who usually pays after a failed radon test?
                            <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M9 5l7 7-7 7" /></svg>
                        </a>
                        <a href="/radon-cost-calculator"
                           data-track-event="credit_landing_bridge_click"
                           data-track-label="credit_to_action_plan"
                           class="inline-flex items-center gap-2 text-slate-300 transition-colors hover:text-white">
                            Need the broader next step first? Open the full action-plan flow
                            <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M9 5l7 7-7 7" /></svg>
                        </a>
                    </div>
                </div>

                <div class="mt-10 grid gap-8 lg:grid-cols-[1.22fr_0.78fr]">
                    <form action="/search-zip-credit" method="POST" class="rounded-2xl border border-white/10 bg-white/5 p-6 sm:p-8 shadow-2xl">
                        <div class="grid gap-6">
                            <div>
                                <label class="block text-xs font-bold uppercase tracking-[0.25em] text-slate-400 mb-3">ZIP Code</label>
                                <input type="text" name="zipCode" pattern="[0-9]{5}" required placeholder="Enter 5-digit ZIP code"
                                       class="block w-full rounded-2xl border-0 bg-white px-5 py-4 text-lg font-medium text-slate-900 shadow-xl shadow-black/10 ring-1 ring-inset ring-slate-200 placeholder:text-slate-400 focus:ring-2 focus:ring-brand-500">
                                <script>
                                    if (window.location.search.includes('error=notfound')) {
                                        document.write('<p class="mt-3 text-rose-400 text-sm font-medium">ZIP code not found in database.</p>');
                                    }
                                </script>
                            </div>

                            <div>
                                <p class="text-xs font-bold uppercase tracking-[0.25em] text-slate-400 mb-3">Deal Side</p>
                                <div class="grid grid-cols-2 gap-3">
                                    <label class="cursor-pointer" data-track-event="credit_prefill_pick" data-track-label="intent-buying">
                                        <input type="radio" name="intent" value="buying" checked class="peer sr-only">
                                        <div class="min-h-[76px] rounded-2xl border border-white/10 bg-slate-900/70 px-4 py-4 text-center text-sm font-bold text-white transition-all hover:border-sky-400/50 peer-checked:border-sky-400 peer-checked:bg-sky-500/15">
                                            Buyer asking for credit
                                        </div>
                                    </label>
                                    <label class="cursor-pointer" data-track-event="credit_prefill_pick" data-track-label="intent-selling">
                                        <input type="radio" name="intent" value="selling" class="peer sr-only">
                                        <div class="min-h-[76px] rounded-2xl border border-white/10 bg-slate-900/70 px-4 py-4 text-center text-sm font-bold text-white transition-all hover:border-fuchsia-400/50 peer-checked:border-fuchsia-400 peer-checked:bg-fuchsia-500/15">
                                            Seller budgeting response
                                        </div>
                                    </label>
                                </div>
                            </div>

                            <div>
                                <p class="text-xs font-bold uppercase tracking-[0.25em] text-slate-400 mb-3">Radon Test Result</p>
                                <div class="grid grid-cols-1 sm:grid-cols-3 gap-3">
                                    <label class="cursor-pointer" data-track-event="credit_prefill_pick" data-track-label="result-between_2_and_4">
                                        <input type="radio" name="radonResultBand" value="between_2_and_4" class="peer sr-only">
                                        <div class="min-h-[64px] rounded-2xl border border-white/10 bg-slate-900/70 px-4 py-4 text-center text-sm font-bold text-white transition-all hover:border-amber-400/50 peer-checked:border-amber-400 peer-checked:bg-amber-500/15">
                                            2.0-3.9
                                        </div>
                                    </label>
                                    <label class="cursor-pointer" data-track-event="credit_prefill_pick" data-track-label="result-above_4">
                                        <input type="radio" name="radonResultBand" value="above_4" checked class="peer sr-only">
                                        <div class="min-h-[64px] rounded-2xl border border-white/10 bg-slate-900/70 px-4 py-4 text-center text-sm font-bold text-white transition-all hover:border-rose-400/50 peer-checked:border-rose-400 peer-checked:bg-rose-500/15">
                                            4.0+ failed inspection
                                        </div>
                                    </label>
                                    <label class="cursor-pointer" data-track-event="credit_prefill_pick" data-track-label="result-under_2">
                                        <input type="radio" name="radonResultBand" value="under_2" class="peer sr-only">
                                        <div class="min-h-[64px] rounded-2xl border border-white/10 bg-slate-900/70 px-4 py-4 text-center text-sm font-bold text-white transition-all hover:border-emerald-400/50 peer-checked:border-emerald-400 peer-checked:bg-emerald-500/15">
                                            Under 2.0
                                        </div>
                                    </label>
                                </div>
                            </div>

                            <button type="submit" class="inline-flex items-center justify-center rounded-2xl bg-white px-6 py-4 text-sm font-black uppercase tracking-wider text-slate-950 transition-colors hover:bg-slate-100">
                                Get My Local Credit Number
                            </button>
                        </div>
                    </form>

                    <div class="rounded-2xl border border-white/10 bg-white/5 p-6 sm:p-8 shadow-2xl">
                        <p class="text-xs font-bold uppercase tracking-[0.25em] text-slate-400">National Planning Snapshot</p>
                        <div class="mt-5 rounded-2xl bg-white p-5">
                            @template.components.receipt_card(receipt = defaultReceipt)
                        </div>
                        <div class="mt-5 grid gap-3 text-sm text-slate-300">
                            <div class="rounded-2xl border border-white/10 bg-slate-900/50 p-4">
                                Buyer ask: start from the local average when the test is 4.0+ pCi/L and the deal needs a clean repair request.
                            </div>
                            <div class="rounded-2xl border border-white/10 bg-slate-900/50 p-4">
                                Seller response: use the low-to-average range to budget a fast-close credit without promising a contractor bid.
                            </div>
                            <div class="rounded-2xl border border-white/10 bg-slate-900/50 p-4">
                                Agent handoff: keep the high range for harder routes, crawl spaces, licensing, or tight closing timelines.
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-14">
            <section class="grid gap-6 lg:grid-cols-[0.92fr_1.08fr] lg:items-start">
                <div>
                    <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Real-estate use case</p>
                    <h2 class="mt-3 font-display text-3xl font-bold tracking-tight text-slate-900">This is the Radon Seller Credit Calculator for a deal that already has a test result</h2>
                    <p class="mt-4 text-sm leading-relaxed text-slate-600">
                        The calculator is strongest when a home inspection, buyer test, or seller disclosure has already surfaced a radon number. It turns the local mitigation estimate into three negotiation numbers: opening ask, defensible ceiling, and quick-close fallback.
                    </p>
                </div>
                <div class="overflow-hidden rounded-2xl border border-slate-200 bg-white">
                    <div class="grid grid-cols-1 md:grid-cols-[0.72fr_1.14fr_1.14fr] border-b border-slate-200 bg-slate-50 text-xs font-bold uppercase tracking-wider text-slate-500">
                        <div class="p-4">Situation</div>
                        <div class="p-4">Better ask</div>
                        <div class="p-4">What to avoid</div>
                    </div>
                    <div class="divide-y divide-slate-100">
                        <div class="grid grid-cols-1 md:grid-cols-[0.72fr_1.14fr_1.14fr]">
                            <div class="p-4 font-display text-lg font-black text-rose-700">4.0+ pCi/L</div>
                            <div class="p-4 text-sm leading-relaxed text-slate-700">Ask for repair, seller credit, or price reduction based on the local mitigation range.</div>
                            <div class="p-4 text-sm leading-relaxed text-slate-600">Do not use a random national average if county labor and state rules change the quote.</div>
                        </div>
                        <div class="grid grid-cols-1 md:grid-cols-[0.72fr_1.14fr_1.14fr]">
                            <div class="p-4 font-display text-lg font-black text-amber-700">2.0-3.9</div>
                            <div class="p-4 text-sm leading-relaxed text-slate-700">Use a smaller planning number or retest request if the contract does not treat this as a failed inspection.</div>
                            <div class="p-4 text-sm leading-relaxed text-slate-600">Do not overstate the EPA action threshold. The page keeps this separate from 4.0+.</div>
                        </div>
                        <div class="grid grid-cols-1 md:grid-cols-[0.72fr_1.14fr_1.14fr]">
                            <div class="p-4 font-display text-lg font-black text-slate-900">No reading</div>
                            <div class="p-4 text-sm leading-relaxed text-slate-700">Start with a test or action plan before negotiating a credit.</div>
                            <div class="p-4 text-sm leading-relaxed text-slate-600">Do not turn a county EPA zone into a home-specific defect claim.</div>
                        </div>
                    </div>
                </div>
            </section>

            <section class="mt-12 grid gap-4 lg:grid-cols-3">
                <div class="rounded-2xl border border-slate-200 bg-white p-6 shadow-sm">
                    <p class="text-xs font-bold uppercase tracking-widest text-slate-500">Buyer script</p>
                    <h2 class="mt-3 font-display text-2xl font-bold tracking-tight text-slate-900">Ask for a number tied to the property</h2>
                    <p class="mt-3 text-sm leading-relaxed text-slate-600">
                        Use the county average as the first repair request, then move toward the high range only when foundation, access, or timing makes the job harder.
                    </p>
                </div>
                <div class="rounded-2xl border border-slate-200 bg-white p-6 shadow-sm">
                    <p class="text-xs font-bold uppercase tracking-widest text-slate-500">Seller script</p>
                    <h2 class="mt-3 font-display text-2xl font-bold tracking-tight text-slate-900">Separate credit from guarantee</h2>
                    <p class="mt-3 text-sm leading-relaxed text-slate-600">
                        A seller can offer a fast-close credit without guaranteeing the final contractor price. That is why the page shows average, low, and high anchors.
                    </p>
                </div>
                <div class="rounded-2xl border border-slate-200 bg-white p-6 shadow-sm">
                    <p class="text-xs font-bold uppercase tracking-widest text-slate-500">Agent handoff</p>
                    <h2 class="mt-3 font-display text-2xl font-bold tracking-tight text-slate-900">Send the worksheet when the number is disputed</h2>
                    <p class="mt-3 text-sm leading-relaxed text-slate-600">
                        The worksheet keeps the repair request, seller credit, contractor quote, and closing concession in one place.
                    </p>
                    <a href="/guides/radon-seller-credit-worksheet" class="mt-4 inline-flex items-center justify-center rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm font-semibold text-slate-700 transition-colors hover:bg-slate-100">
                        Open Negotiation Worksheet
                    </a>
                </div>
            </section>

            <section class="mt-12 rounded-2xl border border-slate-200 bg-white p-8 shadow-sm">
                <div class="flex flex-col gap-6 lg:flex-row lg:items-center lg:justify-between">
                    <div>
                        <p class="text-xs font-bold uppercase tracking-[0.25em] text-slate-500">Fast county jump</p>
                        <h2 class="mt-3 font-display text-3xl font-bold tracking-tight text-slate-900">Browse by state if you already know the county</h2>
                        <p class="mt-3 max-w-2xl text-sm leading-relaxed text-slate-600">
                            ZIP lookup is still the cleanest path. If you already know the state and county, open the state cost hub and jump into the county-specific calculator.
                        </p>
                    </div>
                    <div class="flex flex-col gap-2 text-sm font-bold sm:flex-row">
                        <a href="/radon-mitigation-cost" class="inline-flex items-center justify-center rounded-xl border border-slate-200 bg-slate-50 px-5 py-3 text-slate-700 transition-colors hover:bg-slate-100">
                            Compare Cost Ranges
                        </a>
                        <a href="/radon-levels" class="inline-flex items-center justify-center rounded-xl bg-slate-900 px-5 py-3 text-white transition-colors hover:bg-slate-800">
                            Interpret Radon Levels
                        </a>
                    </div>
                </div>

                <div class="mt-8 grid grid-cols-2 gap-4 sm:grid-cols-4 md:grid-cols-6 lg:grid-cols-8">
                    @for(String stateAbbr : stateMap.keySet())
                        <a href="/radon-mitigation-cost/${stateMap.get(stateAbbr).get(0).getStateSlug()}"
                           class="flex min-h-[68px] flex-col items-center justify-center rounded-xl border border-slate-200 bg-slate-50 py-4 shadow-sm transition-all hover:border-brand-300 hover:bg-brand-50 hover:shadow-md">
                            <span class="font-display text-lg font-bold text-slate-700">${stateAbbr}</span>
                            <span class="mt-1 text-xs text-slate-500">${stateMap.get(stateAbbr).size()} counties</span>
                        </a>
                    @endfor
                </div>
            </section>

            <section class="mt-12 rounded-2xl border border-slate-200 bg-slate-50 p-6">
                <h2 class="font-display text-xl font-bold tracking-tight text-slate-900">Sources, legal limits, and quote limits</h2>
                <p class="mt-3 text-sm leading-relaxed text-slate-600">
                    These are planning estimates, not contractor bids, legal advice, or real-estate contract advice. Verify state disclosure rules, mitigation licensing requirements, test validity, and contractor credentials before turning a range into a binding repair addendum or closing credit.
                </p>
                <div class="mt-4 flex flex-col gap-3 text-sm font-bold sm:flex-row">
                    <a href="/methodology" class="text-indigo-700 hover:underline">RadonVerdict methodology</a>
                    <a href="/radon-mitigation-cost" class="text-indigo-700 hover:underline">Radon mitigation cost guide</a>
                    <a href="/guides/who-pays-radon-mitigation-buyer-or-seller" class="text-indigo-700 hover:underline">Buyer vs seller payment guide</a>
                </div>
            </section>

            @if(trust != null)
                @template.components.trust_metadata(trust = trust)
            @endif
        </div>
    `
)
