@import com.radonverdict.model.County
@import com.radonverdict.model.dto.CountyPageContent

@param County county
@param CountyPageContent page

!{
    final int low = page.getReceipt().getTotalLow();
    final int avg = page.getReceipt().getTotalAvg();
    final int high = page.getReceipt().getTotalHigh();
    final String countyLabel = county.getAreaDisplayName() + ", " + county.getStateAbbr();
}

<section id="quote-coach" class="mt-10 scroll-mt-28 border-y border-slate-200 py-10">
    <div class="grid gap-8 lg:grid-cols-[0.9fr_1.1fr] lg:items-start">
        <div>
            <p class="text-xs font-bold uppercase tracking-[0.18em] text-slate-500">Quote coach</p>
            <h2 class="mt-3 font-display text-3xl font-black tracking-tight text-slate-900 sm:text-4xl">
                Use this page like a quote coach, not just a calculator.
            </h2>
            <p class="mt-4 text-base leading-relaxed text-slate-600">
                In ${countyLabel}, the useful move is not memorizing one price. It is knowing when to test, when to quote, what number to anchor on, and which contractor answers should make you slow down.
            </p>
            <div class="mt-6 grid gap-3 sm:grid-cols-3">
                <div class="border-l-4 border-emerald-500 bg-emerald-50 px-4 py-3">
                    <p class="text-[11px] font-bold uppercase tracking-wider text-emerald-800">Low anchor</p>
                    <p class="mt-1 text-2xl font-black tabular-nums text-slate-900">$${low}</p>
                </div>
                <div class="border-l-4 border-slate-900 bg-slate-50 px-4 py-3">
                    <p class="text-[11px] font-bold uppercase tracking-wider text-slate-600">Quote target</p>
                    <p class="mt-1 text-2xl font-black tabular-nums text-slate-900">$${avg}</p>
                </div>
                <div class="border-l-4 border-amber-500 bg-amber-50 px-4 py-3">
                    <p class="text-[11px] font-bold uppercase tracking-wider text-amber-800">Hard ceiling</p>
                    <p class="mt-1 text-2xl font-black tabular-nums text-slate-900">$${high}</p>
                </div>
            </div>
        </div>

        <div class="divide-y divide-slate-200 rounded-2xl border border-slate-200 bg-white">
            <div class="grid gap-3 p-5 sm:grid-cols-[150px_1fr]">
                <div>
                    <p class="text-sm font-black text-slate-900">No test yet</p>
                    <p class="mt-1 text-xs font-semibold uppercase tracking-wider text-slate-500">Do not quote first</p>
                </div>
                <p class="text-sm leading-relaxed text-slate-700">
                    Buy a short-term test or confirm an old result before calling installers. Use the $${low}-$${high} range as planning context, not a reason to buy a system early.
                </p>
            </div>
            <div class="grid gap-3 p-5 sm:grid-cols-[150px_1fr]">
                <div>
                    <p class="text-sm font-black text-slate-900">2.0-3.9 pCi/L</p>
                    <p class="mt-1 text-xs font-semibold uppercase tracking-wider text-slate-500">Retest or plan</p>
                </div>
                <p class="text-sm leading-relaxed text-slate-700">
                    If this is a normal homeowner decision, retest under better conditions first. If you are buying, selling, or finishing a basement, keep the local average ready so the conversation does not drift.
                </p>
            </div>
            <div class="grid gap-3 p-5 sm:grid-cols-[150px_1fr]">
                <div>
                    <p class="text-sm font-black text-slate-900">4.0+ pCi/L</p>
                    <p class="mt-1 text-xs font-semibold uppercase tracking-wider text-slate-500">Get real bids</p>
                </div>
                <p class="text-sm leading-relaxed text-slate-700">
                    Get two or three quotes and compare them against $${avg}. A bid near $${high} needs a clear reason: crawl space membrane, difficult pipe route, sump sealing, electrical work, or finish repair.
                </p>
            </div>
            <div class="grid gap-3 p-5 sm:grid-cols-[150px_1fr]">
                <div>
                    <p class="text-sm font-black text-slate-900">Buying or selling</p>
                    <p class="mt-1 text-xs font-semibold uppercase tracking-wider text-slate-500">Negotiate cleanly</p>
                </div>
                <p class="text-sm leading-relaxed text-slate-700">
                    Start the repair or credit conversation around the local average and keep $${high} as the defensible ceiling. Do not let the deal anchor on a generic national average.
                </p>
            </div>
        </div>
    </div>

    <div class="mt-8 grid gap-6 lg:grid-cols-[1fr_0.85fr]">
        <div class="rounded-2xl bg-slate-950 p-6 text-white sm:p-7">
            <div class="flex flex-col gap-4 sm:flex-row sm:items-start sm:justify-between">
                <div>
                    <p class="text-xs font-bold uppercase tracking-[0.18em] text-slate-400">Copy this call script</p>
                    <h3 class="mt-2 font-display text-2xl font-black tracking-tight">Sound like you already know the job.</h3>
                </div>
                <a href="#estimate-form" class="inline-flex shrink-0 items-center justify-center rounded-xl bg-white px-4 py-2 text-sm font-bold text-slate-950 transition-colors hover:bg-slate-100">
                    Get my plan
                </a>
            </div>
            <p class="mt-5 rounded-xl border border-white/10 bg-white/5 p-4 text-sm leading-relaxed text-slate-100">
                My lowest-level radon test was ___ pCi/L in ${countyLabel}. Before you give me a number, can you tell me whether this needs sub-slab suction, crawl space membrane work, sump sealing, or a combination system?
            </p>
            <div class="mt-5">
                <p class="text-sm font-bold text-white">Ask these six questions:</p>
                <ol class="mt-3 grid gap-3 text-sm leading-relaxed text-slate-200 sm:grid-cols-2">
                    <li><span class="font-bold text-white">1.</span> What foundation condition is driving the price?</li>
                    <li><span class="font-bold text-white">2.</span> Where will the pipe route and fan sit?</li>
                    <li><span class="font-bold text-white">3.</span> Is sump cover, slab sealing, or membrane work included?</li>
                    <li><span class="font-bold text-white">4.</span> Who handles electrical, permit, and exterior finish details?</li>
                    <li><span class="font-bold text-white">5.</span> What post-mitigation retest proves the system worked?</li>
                    <li><span class="font-bold text-white">6.</span> What warranty covers the fan, labor, and follow-up adjustment?</li>
                </ol>
            </div>
        </div>

        <div class="rounded-2xl border border-rose-200 bg-rose-50 p-6 sm:p-7">
            <p class="text-xs font-bold uppercase tracking-[0.18em] text-rose-700">Red flags</p>
            <h3 class="mt-2 font-display text-2xl font-black tracking-tight text-slate-900">Slow down before you say yes.</h3>
            <ul class="mt-5 space-y-3 text-sm leading-relaxed text-slate-700">
                <li class="flex gap-3">
                    <span class="mt-1 h-2 w-2 shrink-0 rounded-full bg-rose-500"></span>
                    <span>A quote that never asks for your reading, lowest level, foundation, sump, or crawl space details.</span>
                </li>
                <li class="flex gap-3">
                    <span class="mt-1 h-2 w-2 shrink-0 rounded-full bg-rose-500"></span>
                    <span>A high price with no reason tied to route difficulty, sealing, membrane work, electrical, or finish repair.</span>
                </li>
                <li class="flex gap-3">
                    <span class="mt-1 h-2 w-2 shrink-0 rounded-full bg-rose-500"></span>
                    <span>No post-install retest plan. The goal is lower radon, not just a fan on the wall.</span>
                </li>
                <li class="flex gap-3">
                    <span class="mt-1 h-2 w-2 shrink-0 rounded-full bg-rose-500"></span>
                    <span>Vague warranty language or no clear follow-up path if the result stays elevated.</span>
                </li>
            </ul>
        </div>
    </div>
</section>
