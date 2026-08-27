@import com.radonverdict.model.County
@import com.radonverdict.model.CountyRadonMeasurement
@import com.radonverdict.model.dto.CountyRadonEvidence
@import com.radonverdict.model.dto.TrustMetadata

@param County county
@param CountyRadonEvidence radonEvidence
@param CountyRadonMeasurement radonMeasurement
@param String canonicalUrl
@param boolean noindex = false
@param String testingIntentPath = null
@param String commercialIntentPath = null
@param TrustMetadata trust = null

@template.layout.main(
    title = county.getAreaDisplayName() + ", " + county.getStateAbbr() + " Radon Zone & Test Data | RadonVerdict",
    description = "Check the EPA radon zone and official test data for " + county.getAreaDisplayName() + ", " + county.getStateAbbr() + ", with source dates and limits.",
    canonicalUrl = canonicalUrl,
    noindex = noindex,
    content = @`
        <section class="bg-stone-100">
            <div class="mx-auto max-w-4xl px-4 py-12 sm:px-6 sm:py-18">
                <p class="text-xs font-black uppercase tracking-[0.24em] text-emerald-800">County evidence note</p>
                <h1 class="mt-4 max-w-3xl font-display text-4xl font-black tracking-tight text-stone-950 sm:text-5xl">Radon zone and test data for ${county.getAreaDisplayName()}, ${county.getStateAbbr()}</h1>
                <p class="mt-5 max-w-3xl text-lg font-semibold leading-relaxed text-stone-700">County data can show why testing matters. It cannot tell you the radon level in a particular house. The only property-level answer comes from a valid test.</p>

                <div class="mt-8 grid gap-6 lg:grid-cols-[1fr_0.9fr]">
                    <article class="rounded-2xl border border-stone-300 bg-white p-6 sm:p-8">
                        <p class="text-xs font-black uppercase tracking-[0.2em] text-stone-500">What the source supports</p>
                        @if (radonEvidence != null)
                            <h2 class="mt-3 font-display text-2xl font-black text-stone-950">${radonEvidence.getDecisionHeadline()}</h2>
                            <p class="mt-4 font-semibold leading-relaxed text-stone-700">${radonEvidence.getMeasuredBurdenSummary()}</p>
                            <p class="mt-4 rounded-xl bg-amber-50 p-4 text-sm font-bold leading-relaxed text-amber-950">${radonEvidence.getSourceCoverageSummary()}</p>
                        @else
                            <h2 class="mt-3 font-display text-2xl font-black text-stone-950">No county measurement summary is available.</h2>
                            <p class="mt-4 font-semibold leading-relaxed text-stone-700">Use the EPA zone only as broad planning context and rely on a home test for the decision.</p>
                        @endif
                        <div class="mt-6 border-t border-stone-200 pt-5 text-sm font-semibold leading-relaxed text-stone-600">
                            <p>EPA map zone: ${county.getEpaZone() > 0 ? "Zone " + county.getEpaZone() : "not classified"}</p>
                            <p class="mt-2">The EPA map predicts broad county potential; it is not a measurement for an address.</p>
                            @if (radonMeasurement != null)
                                <p class="mt-4">Source: ${radonMeasurement.getSourceName()}</p>
                                <p>Coverage: ${radonMeasurement.getPeriod()} · retrieved ${radonMeasurement.getRetrievedAt()}</p>
                                @if (radonMeasurement.getSourceUrl() != null)
                                    <a href="${radonMeasurement.getSourceUrl()}" rel="noopener noreferrer" class="mt-2 inline-block font-black text-emerald-800 underline">Open the original source</a>
                                @endif
                            @endif
                        </div>
                    </article>

                    <aside class="rounded-2xl bg-stone-950 p-6 text-white sm:p-8">
                        <p class="text-xs font-black uppercase tracking-[0.2em] text-emerald-300">Use your home result</p>
                        <h2 class="mt-3 font-display text-2xl font-black">Build the next step</h2>
                        <form action="/plan" method="get" class="mt-6 space-y-4">
                            <input type="hidden" name="source" value="county-evidence">
                            <div>
                                <label for="county-reading" class="text-sm font-black text-stone-100">Radon result</label>
                                <input id="county-reading" name="radonReading" required type="number" min="0" max="999" step="0.01" inputmode="decimal" placeholder="5.5" class="mt-2 min-h-[54px] w-full rounded-xl border border-stone-600 bg-stone-900 px-4 text-lg font-black text-white">
                            </div>
                            <div>
                                <label for="county-zip" class="text-sm font-black text-stone-100">ZIP code</label>
                                <input id="county-zip" name="zipCode" required inputmode="numeric" pattern="[0-9]{5}" maxlength="5" class="mt-2 min-h-[54px] w-full rounded-xl border border-stone-600 bg-stone-900 px-4 text-lg font-black text-white">
                            </div>
                            <div>
                                <label for="county-intent" class="text-sm font-black text-stone-100">Situation</label>
                                <select id="county-intent" name="intent" class="mt-2 min-h-[54px] w-full rounded-xl border border-stone-600 bg-stone-900 px-4 font-bold text-white"><option value="homeowner">Living here</option><option value="buying">Buying</option><option value="selling">Selling</option></select>
                            </div>
                            <button type="submit" class="min-h-[52px] w-full rounded-xl bg-white px-5 font-black text-stone-950">Build private plan</button>
                        </form>
                    </aside>
                </div>

                <section class="mt-10 border-t border-stone-300 pt-8">
                    <h2 class="font-display text-2xl font-black text-stone-950">What to do with this information</h2>
                    <ol class="mt-5 grid gap-4 sm:grid-cols-3">
                        <li class="rounded-xl border border-stone-300 bg-white p-5"><strong class="block text-stone-950">1. Test the home</strong><span class="mt-2 block text-sm font-semibold leading-relaxed text-stone-650">Use a valid device and record duration, placement, and conditions.</span></li>
                        <li class="rounded-xl border border-stone-300 bg-white p-5"><strong class="block text-stone-950">2. Interpret the result</strong><span class="mt-2 block text-sm font-semibold leading-relaxed text-stone-650">Treat 4.0 pCi/L as the main action threshold and preserve the testing context.</span></li>
                        <li class="rounded-xl border border-stone-300 bg-white p-5"><strong class="block text-stone-950">3. Use qualified help</strong><span class="mt-2 block text-sm font-semibold leading-relaxed text-stone-650">For testing or mitigation, use state requirements and recognized proficiency programs.</span></li>
                    </ol>
                </section>
                @if (radonEvidence != null)
                    <section class="mt-10 border-t border-stone-300 pt-8">
                        <h2 class="font-display text-2xl font-black text-stone-950">Evidence profile for ${county.getAreaDisplayName()}</h2>
                        <div class="mt-5 grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
                            @if (radonEvidence.getPrimaryAverageDisplay() != null)
                                <div class="rounded-xl border border-stone-300 bg-white p-5"><span class="text-xs font-black uppercase tracking-wider text-stone-500">Reported average</span><strong class="mt-2 block text-xl text-stone-950">${radonEvidence.getPrimaryAverageDisplay()}</strong></div>
                            @endif
                            @if (radonEvidence.getAbove4Display() != null)
                                <div class="rounded-xl border border-stone-300 bg-white p-5"><span class="text-xs font-black uppercase tracking-wider text-stone-500">At or above 4.0</span><strong class="mt-2 block text-xl text-stone-950">${radonEvidence.getAbove4Display()}</strong></div>
                            @endif
                            @if (radonEvidence.getTestVolumeDisplay() != null)
                                <div class="rounded-xl border border-stone-300 bg-white p-5"><span class="text-xs font-black uppercase tracking-wider text-stone-500">Source test volume</span><strong class="mt-2 block text-xl text-stone-950">${radonEvidence.getTestVolumeDisplay()}</strong></div>
                            @endif
                            @if (radonEvidence.getComparisonPeerCountDisplay() != null)
                                <div class="rounded-xl border border-stone-300 bg-white p-5"><span class="text-xs font-black uppercase tracking-wider text-stone-500">Comparison cohort</span><strong class="mt-2 block text-xl text-stone-950">${radonEvidence.getComparisonPeerCountDisplay()}</strong></div>
                            @endif
                        </div>
                        <p class="mt-5 text-sm font-semibold leading-relaxed text-stone-700">${radonEvidence.getSourceProfileSummary()}</p>
                        <p class="mt-3 text-sm font-semibold leading-relaxed text-stone-700">${radonEvidence.getPeerComparisonSummary()}</p>
                    </section>
                @endif
                @if (testingIntentPath != null || commercialIntentPath != null)
                    <section class="mt-10 border-t border-stone-300 pt-8">
                        <p class="text-xs font-black uppercase tracking-[0.2em] text-emerald-800">Intent-matched guide</p>
                        <h2 class="mt-3 font-display text-2xl font-black text-stone-950">Open the page that answers the actual search</h2>
                        <div class="mt-5 flex flex-col gap-3 sm:flex-row">
                            @if (testingIntentPath != null)
                                <a href="${testingIntentPath}" class="inline-flex min-h-[48px] items-center rounded-xl bg-stone-950 px-5 text-sm font-black text-white">How to test in ${county.getAreaDisplayName()}</a>
                            @endif
                            @if (commercialIntentPath != null)
                                <a href="${commercialIntentPath}" class="inline-flex min-h-[48px] items-center rounded-xl bg-stone-950 px-5 text-sm font-black text-white">Commercial testing protocol</a>
                            @endif
                        </div>
                    </section>
                @endif
                @if (trust != null)
                    @template.components.trust_metadata(trust = trust)
                @endif
            </div>
        </section>
    `
)
