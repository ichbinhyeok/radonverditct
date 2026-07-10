@import com.radonverdict.model.County
@import com.radonverdict.model.dto.CountyRadonEvidence
@import com.radonverdict.model.dto.TrustMetadata
@import com.radonverdict.util.JsonLdUtils

@param County county
@param CountyRadonEvidence evidence
@param TrustMetadata trust = null
@param String canonicalUrl

@template.layout.main(
    title = "Radon Testing in " + county.getAreaDisplayName() + ", " + county.getStateAbbr() + " | RadonVerdict",
    description = "What radon testing data means in " + county.getAreaDisplayName() + ", " + county.getStateAbbr() + ". See the local evidence, testing decision, and next step.",
    canonicalUrl = canonicalUrl,
    content = @`
        <main class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-10 w-full">
            <div class="mb-8">
                <p class="text-xs font-black uppercase tracking-wider text-indigo-600">Local testing decision</p>
                <h1 class="mt-3 font-display text-4xl font-black tracking-normal text-slate-950 sm:text-5xl">
                    Radon Testing in ${county.getAreaDisplayName()}, ${county.getStateAbbr()}
                </h1>
                <p class="mt-5 max-w-3xl text-lg leading-relaxed text-slate-600">${evidence.getIntentAnswer()}</p>
            </div>

            <section class="rounded-2xl border border-slate-200 bg-white p-6 shadow-sm sm:p-8">
                <p class="text-xs font-black uppercase tracking-wider text-emerald-700">Direct answer</p>
                <h2 class="mt-2 font-display text-2xl font-black text-slate-950">${evidence.getDecisionHeadline()}</h2>
                <p class="mt-4 text-base leading-relaxed text-slate-700">${evidence.getRecommendedAction()}</p>
                <div class="mt-6 grid gap-3 sm:grid-cols-3">
                    <div class="rounded-xl bg-slate-50 p-4">
                        <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Evidence</p>
                        <p class="mt-2 font-bold text-slate-950">${evidence.getSourceProfileLabel()}</p>
                    </div>
                    <div class="rounded-xl bg-slate-50 p-4">
                        <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Primary signal</p>
                        <p class="mt-2 font-bold text-slate-950">${evidence.getPrimaryAverageDisplay()}</p>
                    </div>
                    <div class="rounded-xl bg-slate-50 p-4">
                        <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Reported tests</p>
                        <p class="mt-2 font-bold text-slate-950">${evidence.getTestVolumeDisplay()}</p>
                    </div>
                </div>
            </section>

            <section class="mt-8 grid gap-6 md:grid-cols-2">
                <div class="rounded-2xl border border-slate-200 bg-white p-6">
                    <h2 class="font-display text-xl font-black text-slate-950">What this evidence can and cannot tell you</h2>
                    <p class="mt-3 leading-relaxed text-slate-700">${evidence.getWhyThisPageExists()}</p>
                    <p class="mt-3 leading-relaxed text-slate-700">${evidence.getMeasuredBurdenSummary()}</p>
                </div>
                <div class="rounded-2xl border border-slate-200 bg-white p-6">
                    <h2 class="font-display text-xl font-black text-slate-950">Your next test decision</h2>
                    <p class="mt-3 leading-relaxed text-slate-700">${evidence.getNoReadingAction()}</p>
                    <p class="mt-3 leading-relaxed text-slate-700">${evidence.getRetestTriggerSummary()}</p>
                </div>
            </section>

            <section class="mt-8 rounded-2xl border border-indigo-200 bg-indigo-50 p-6">
                <h2 class="font-display text-xl font-black text-slate-950">Move from a test result to a local plan</h2>
                <p class="mt-3 leading-relaxed text-slate-700">Use the result band, foundation type, and county cost range together. A county signal is context; the home's own test controls the decision.</p>
                <div class="mt-5 flex flex-col gap-3 sm:flex-row">
                    <a href="/radon-levels/${county.getStateSlug()}/${county.getCountySlug()}" class="inline-flex items-center justify-center rounded-xl bg-slate-950 px-5 py-3 text-sm font-black text-white hover:bg-slate-800">See local radon levels</a>
                    <a href="/radon-mitigation-cost/${county.getStateSlug()}/${county.getCountySlug()}" class="inline-flex items-center justify-center rounded-xl border border-slate-300 bg-white px-5 py-3 text-sm font-black text-slate-800 hover:bg-slate-50">See local cost range</a>
                </div>
            </section>

            @if(trust != null && trust.getSources() != null && !trust.getSources().isEmpty())
                <section class="mt-8 border-t border-slate-200 pt-6">
                    <p class="text-xs font-black uppercase tracking-wider text-slate-500">Sources</p>
                    <ul class="mt-3 space-y-2 text-sm text-slate-600">
                        @for(var source : trust.getSources())
                            <li><a class="text-indigo-700 hover:underline" href="${source.getUrl()}" target="_blank" rel="noopener nofollow">${source.getName()}</a></li>
                        @endfor
                    </ul>
                </section>
            @endif
        </main>
    `
)
