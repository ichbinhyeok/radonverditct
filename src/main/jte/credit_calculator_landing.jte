@import java.util.List
@import java.util.Map
@import com.radonverdict.model.County
@import com.radonverdict.model.dto.ItemizedReceipt

@param String title
@param ItemizedReceipt defaultReceipt
@param Map<String, List<County>> stateMap
@param boolean noindex = false

@template.layout.main(
    title = title,
    canonicalUrl = "https://radonverdict.com/radon-credit-calculator",
    description = "Enter your ZIP code to get a local radon seller credit or repair-request range for your county.",
    noindex = noindex,
    content = @`
        <div class="bg-slate-950 border-b border-slate-800 relative overflow-hidden">
            <div class="absolute inset-0 opacity-20 bg-[radial-gradient(circle_at_top_right,_rgba(59,130,246,0.35),_transparent_35%),radial-gradient(circle_at_bottom_left,_rgba(244,114,182,0.28),_transparent_30%)]"></div>
            <div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 pt-20 pb-24 relative z-10">
                <div class="max-w-4xl">
                    <span class="inline-flex items-center gap-2 rounded-full border border-white/10 bg-white/5 px-3 py-1 text-xs font-bold uppercase tracking-wider text-slate-300">
                        Transaction Intent Tool
                    </span>
                    <h1 class="mt-5 font-display text-4xl font-black tracking-tight text-white sm:text-6xl">
                        Radon Seller Credit <span class="text-slate-400">Calculator</span>
                    </h1>
                    <p class="mt-6 max-w-3xl text-lg leading-relaxed text-slate-300 sm:text-xl">
                        If a radon result is holding up a deal, stop negotiating from a generic national average. Use your ZIP code to open a county-specific credit calculator with a local opening ask, a ceiling, and a quick-close target.
                    </p>
                </div>

                <div class="mt-10 grid gap-8 lg:grid-cols-[1.25fr_0.75fr]">
                    <form action="/search-zip-credit" method="POST" class="rounded-[2rem] border border-white/10 bg-white/5 p-6 sm:p-8 shadow-2xl backdrop-blur-sm">
                        <div class="grid gap-6">
                            <div>
                                <label class="block text-xs font-bold uppercase tracking-[0.25em] text-slate-400 mb-3">ZIP Code</label>
                                <div class="relative">
                                    <input type="text" name="zipCode" pattern="[0-9]{5}" required placeholder="Enter 5-digit ZIP code"
                                           class="block w-full rounded-2xl border-0 bg-white px-5 py-4 text-lg font-medium text-slate-900 shadow-xl shadow-black/10 ring-1 ring-inset ring-slate-200 placeholder:text-slate-400 focus:ring-2 focus:ring-brand-500">
                                </div>
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
                                        <div class="rounded-2xl border border-white/10 bg-slate-900/70 px-4 py-4 text-center text-sm font-bold text-white transition-all hover:border-sky-400/50 peer-checked:border-sky-400 peer-checked:bg-sky-500/15">
                                            Buyer asking for credit
                                        </div>
                                    </label>
                                    <label class="cursor-pointer" data-track-event="credit_prefill_pick" data-track-label="intent-selling">
                                        <input type="radio" name="intent" value="selling" class="peer sr-only">
                                        <div class="rounded-2xl border border-white/10 bg-slate-900/70 px-4 py-4 text-center text-sm font-bold text-white transition-all hover:border-fuchsia-400/50 peer-checked:border-fuchsia-400 peer-checked:bg-fuchsia-500/15">
                                            Seller budgeting response
                                        </div>
                                    </label>
                                </div>
                            </div>

                            <div>
                                <p class="text-xs font-bold uppercase tracking-[0.25em] text-slate-400 mb-3">Result Band</p>
                                <div class="grid grid-cols-1 sm:grid-cols-3 gap-3">
                                    <label class="cursor-pointer" data-track-event="credit_prefill_pick" data-track-label="result-between_2_and_4">
                                        <input type="radio" name="radonResultBand" value="between_2_and_4" class="peer sr-only">
                                        <div class="rounded-2xl border border-white/10 bg-slate-900/70 px-4 py-4 text-center text-sm font-bold text-white transition-all hover:border-amber-400/50 peer-checked:border-amber-400 peer-checked:bg-amber-500/15">
                                            2.0-3.9
                                        </div>
                                    </label>
                                    <label class="cursor-pointer" data-track-event="credit_prefill_pick" data-track-label="result-above_4">
                                        <input type="radio" name="radonResultBand" value="above_4" checked class="peer sr-only">
                                        <div class="rounded-2xl border border-white/10 bg-slate-900/70 px-4 py-4 text-center text-sm font-bold text-white transition-all hover:border-rose-400/50 peer-checked:border-rose-400 peer-checked:bg-rose-500/15">
                                            4.0+
                                        </div>
                                    </label>
                                    <label class="cursor-pointer" data-track-event="credit_prefill_pick" data-track-label="result-under_2">
                                        <input type="radio" name="radonResultBand" value="under_2" class="peer sr-only">
                                        <div class="rounded-2xl border border-white/10 bg-slate-900/70 px-4 py-4 text-center text-sm font-bold text-white transition-all hover:border-emerald-400/50 peer-checked:border-emerald-400 peer-checked:bg-emerald-500/15">
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

                    <div class="rounded-[2rem] border border-white/10 bg-white/5 p-6 sm:p-8 shadow-2xl backdrop-blur-sm">
                        <p class="text-xs font-bold uppercase tracking-[0.25em] text-slate-400">National Planning Snapshot</p>
                        <div class="mt-5 rounded-3xl bg-white p-5">
                            @template.components.receipt_card(receipt = defaultReceipt)
                        </div>
                        <div class="mt-5 grid gap-3 text-sm text-slate-300">
                            <div class="rounded-2xl border border-white/10 bg-slate-900/50 p-4">
                                Start with the local average when you need a clean first ask.
                            </div>
                            <div class="rounded-2xl border border-white/10 bg-slate-900/50 p-4">
                                Keep the county high range in reserve if the route, timing, or scope gets harder.
                            </div>
                            <div class="rounded-2xl border border-white/10 bg-slate-900/50 p-4">
                                Use the quick-close target when both sides care more about speed than squeezing the last dollar.
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
            <div class="grid gap-6 lg:grid-cols-3">
                <div class="rounded-3xl border border-slate-200 bg-white p-6 shadow-sm">
                    <p class="text-xs font-bold uppercase tracking-widest text-slate-500">What you get</p>
                    <h2 class="mt-3 font-display text-2xl font-bold tracking-tight text-slate-900">A local ask, not a blog post</h2>
                    <p class="mt-3 text-sm leading-relaxed text-slate-600">
                        This flow gives you a real county number for repairs, closing credits, and fallback negotiation instead of sending you straight into a generic cost article.
                    </p>
                </div>
                <div class="rounded-3xl border border-slate-200 bg-white p-6 shadow-sm">
                    <p class="text-xs font-bold uppercase tracking-widest text-slate-500">Best for</p>
                    <h2 class="mt-3 font-display text-2xl font-bold tracking-tight text-slate-900">Buyers, sellers, and agents</h2>
                    <p class="mt-3 text-sm leading-relaxed text-slate-600">
                        Use it when a test is already in hand and the real question is not whether radon exists, but how much room you have to ask for a repair or credit.
                    </p>
                </div>
                <div class="rounded-3xl border border-slate-200 bg-white p-6 shadow-sm">
                    <p class="text-xs font-bold uppercase tracking-widest text-slate-500">If you are not there yet</p>
                    <h2 class="mt-3 font-display text-2xl font-bold tracking-tight text-slate-900">Use the full action-plan calculator</h2>
                    <p class="mt-3 text-sm leading-relaxed text-slate-600">
                        Still deciding whether to retest, mitigate, or price the job? Start with the broader action-plan flow instead of forcing a transaction number too early.
                    </p>
                    <a href="/radon-cost-calculator" class="mt-4 inline-flex items-center justify-center rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-sm font-semibold text-slate-700 transition-colors hover:bg-slate-100">
                        Open Action Plan + Cost
                    </a>
                </div>
            </div>

            <div class="mt-12 rounded-[2rem] border border-slate-200 bg-white p-8 shadow-sm">
                <div class="flex flex-col gap-6 lg:flex-row lg:items-center lg:justify-between">
                    <div>
                        <p class="text-xs font-bold uppercase tracking-[0.25em] text-slate-500">Fast county jump</p>
                        <h2 class="mt-3 font-display text-3xl font-bold tracking-tight text-slate-900">Browse by state if you already know the county</h2>
                        <p class="mt-3 max-w-2xl text-sm leading-relaxed text-slate-600">
                            Use the ZIP path first if you can. If not, jump into your state and open the county calculator from there.
                        </p>
                    </div>
                    <a href="/guides/radon-seller-credit-worksheet" class="inline-flex items-center justify-center rounded-xl bg-slate-900 px-5 py-3 text-sm font-bold text-white transition-colors hover:bg-slate-800">
                        Open Negotiation Worksheet
                    </a>
                </div>

                <div class="mt-8 grid grid-cols-2 gap-4 sm:grid-cols-4 md:grid-cols-6 lg:grid-cols-8">
                    @for(String stateAbbr : stateMap.keySet())
                        <a href="/radon-mitigation-cost/${stateMap.get(stateAbbr).get(0).getStateSlug()}"
                           class="flex min-h-[68px] flex-col items-center justify-center rounded-xl border border-slate-200 bg-slate-50 py-4 shadow-sm transition-all hover:border-brand-300 hover:bg-brand-50 hover:shadow-md">
                            <span class="font-display text-lg font-bold text-slate-700">${stateAbbr}</span>
                        </a>
                    @endfor
                </div>
            </div>
        </div>
    `
)
