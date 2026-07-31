@import com.radonverdict.model.dto.RadonActionPlan

@param RadonActionPlan plan

!{
    final boolean hasInput = (plan.getZipCode() != null && !plan.getZipCode().isBlank())
            || (plan.getRawReading() != null && !plan.getRawReading().isBlank())
            || "not_tested".equals(plan.getResultBand());
}

@template.layout.main(
    title = "Your Radon Action Plan | RadonVerdict",
    description = "Turn a radon result and ZIP code into an evidence-backed next-step plan without an invented local price.",
    canonicalUrl = "https://radonverdict.com/plan",
    noindex = true,
    minimalChrome = true,
    content = @`
        <main class="min-h-screen bg-slate-50 py-10 sm:py-16">
            <div class="mx-auto max-w-4xl px-4 sm:px-6">
                <a href="/" class="text-sm font-bold text-slate-600 hover:text-slate-950">&larr; RadonVerdict</a>
                <header class="mt-6 rounded-3xl bg-slate-950 p-6 text-white shadow-xl sm:p-10">
                    <p class="text-xs font-bold uppercase tracking-[0.24em] text-emerald-300">Private decision workspace</p>
                    <h1 class="mt-4 font-display text-4xl font-black tracking-tight sm:text-5xl">Your radon action plan</h1>
                    <p class="mt-4 max-w-2xl text-base font-semibold leading-relaxed text-slate-300">A result-first plan using official local evidence when it exists. No local price is filled in from county averages or guessed home details.</p>
                </header>

                <section class="mt-6 rounded-3xl border border-slate-200 bg-white p-5 shadow-sm sm:p-8">
                    <form action="/plan" method="get" class="grid gap-4 md:grid-cols-[1fr_1fr_1fr_auto] md:items-end">
                        <div>
                            <label for="planReading" class="text-sm font-bold text-slate-800">Radon result</label>
                            <input id="planReading" name="radonReading" value="${plan.getRawReading()}" inputmode="decimal" placeholder="e.g. 5.5" class="mt-2 min-h-[50px] w-full rounded-xl border border-slate-300 px-4 font-semibold">
                        </div>
                        <div>
                            <label for="planZip" class="text-sm font-bold text-slate-800">ZIP code</label>
                            <input id="planZip" name="zipCode" value="${plan.getZipCode()}" inputmode="numeric" pattern="[0-9]{5}" placeholder="e.g. 22030" class="mt-2 min-h-[50px] w-full rounded-xl border border-slate-300 px-4 font-semibold">
                        </div>
                        <div>
                            <label for="planIntent" class="text-sm font-bold text-slate-800">Situation</label>
                            <select id="planIntent" name="intent" class="mt-2 min-h-[50px] w-full rounded-xl border border-slate-300 bg-white px-4 font-semibold">
                                @if ("homeowner".equals(plan.getIntent()))
                                    <option value="homeowner" selected>Living here</option>
                                @else
                                    <option value="homeowner">Living here</option>
                                @endif
                                @if ("buying".equals(plan.getIntent()))
                                    <option value="buying" selected>Buying</option>
                                @else
                                    <option value="buying">Buying</option>
                                @endif
                                @if ("selling".equals(plan.getIntent()))
                                    <option value="selling" selected>Selling</option>
                                @else
                                    <option value="selling">Selling</option>
                                @endif
                            </select>
                        </div>
                        <button type="submit" class="min-h-[50px] rounded-xl bg-slate-950 px-5 text-sm font-bold text-white">Build plan</button>
                    </form>
                    <p class="mt-3 text-xs font-semibold text-slate-500">No test yet? Leave the result blank. Test duration and placement are not provided, so this plan does not claim the result is confirmed.</p>
                </section>

                @if (hasInput)
                    <section class="mt-6 grid gap-6 lg:grid-cols-[1.1fr_0.9fr]">
                        <article class="rounded-3xl border border-slate-200 bg-white p-6 shadow-sm sm:p-8">
                            <p class="text-xs font-bold uppercase tracking-[0.2em] text-slate-500">Result · ${plan.getIntentLabel()}</p>
                            <p class="mt-2 text-lg font-black text-slate-950">${plan.getReadingDisplay()}</p>
                            <h2 class="mt-4 font-display text-3xl font-black tracking-tight text-slate-950">${plan.getVerdictHeadline()}</h2>
                            <p class="mt-4 font-semibold leading-relaxed text-slate-600">${plan.getInterpretation()}</p>
                            @if (plan.hasValidationError())
                                <p class="mt-5 rounded-xl border border-red-200 bg-red-50 p-4 text-sm font-bold text-red-800">${plan.getValidationError()}</p>
                            @endif
                            <h3 class="mt-7 text-sm font-black uppercase tracking-[0.18em] text-slate-500">Next actions</h3>
                            <ol class="mt-3 space-y-3">
                                @for (int i = 0; i < plan.getActions().size(); i++)
                                    <li class="flex gap-3 rounded-xl bg-slate-50 p-4 font-semibold text-slate-700"><span class="font-black text-slate-950">${i + 1}</span><span>${plan.getActions().get(i)}</span></li>
                                @endfor
                            </ol>
                        </article>

                        <aside class="space-y-6">
                            <section class="rounded-3xl border border-slate-200 bg-white p-6 shadow-sm">
                                <p class="text-xs font-bold uppercase tracking-[0.2em] text-slate-500">Primary county match</p>
                                @if (plan.hasCounty())
                                    <h2 class="mt-3 text-2xl font-black text-slate-950">${plan.getCounty().getAreaDisplayName()}, ${plan.getCounty().getStateAbbr()}</h2>
                                    <p class="mt-3 text-sm font-semibold leading-relaxed text-slate-600">ZIP-to-county data identifies this as the primary match. Confirm the county when a property is near a boundary.</p>
                                    @if (plan.getEvidence() != null)
                                        <p class="mt-4 rounded-xl bg-emerald-50 p-4 text-sm font-bold leading-relaxed text-emerald-950">${plan.getEvidence().getMeasuredBurdenSummary()}</p>
                                    @endif
                                    @if (plan.getMeasurement() != null)
                                        <div class="mt-4 border-t border-slate-200 pt-4 text-xs font-semibold leading-relaxed text-slate-500">
                                            <p>Source: ${plan.getMeasurement().getSourceName()}</p>
                                            <p>Coverage: ${plan.getMeasurement().getPeriod()} · retrieved ${plan.getMeasurement().getRetrievedAt()}</p>
                                            @if (plan.getMeasurement().getSourceUrl() != null)
                                                <a class="mt-2 inline-block font-bold text-slate-800 underline" href="${plan.getMeasurement().getSourceUrl()}" rel="noopener noreferrer">Open official source</a>
                                            @endif
                                        </div>
                                    @endif
                                @else
                                    <p class="mt-3 rounded-xl border border-amber-200 bg-amber-50 p-4 text-sm font-bold leading-relaxed text-amber-900">${plan.getLocationMessage() != null ? plan.getLocationMessage() : "Enter a ZIP to add official local evidence."}</p>
                                @endif
                            </section>

                            <section class="rounded-3xl border border-slate-900 bg-slate-950 p-6 text-white">
                                <p class="text-xs font-bold uppercase tracking-[0.2em] text-slate-400">Cost availability</p>
                                <h2 class="mt-3 text-xl font-black">Unavailable from these inputs</h2>
                                <p class="mt-3 text-sm font-semibold leading-relaxed text-slate-300">A defensible range needs property scope and comparable written quotes. County evidence is not a substitute.</p>
                                <a href="/guides/radon-mitigation-quote-checklist" class="mt-5 inline-flex min-h-[44px] items-center rounded-xl bg-white px-4 text-sm font-bold text-slate-950">Open quote checklist</a>
                            </section>
                        </aside>
                    </section>
                @endif
            </div>
        </main>
    `
)
