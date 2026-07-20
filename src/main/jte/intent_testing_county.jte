@import com.radonverdict.model.County
@import com.radonverdict.model.dto.CountyRadonEvidence
@import com.radonverdict.model.dto.TrustMetadata
@import com.radonverdict.util.JsonLdUtils

@param County county
@param CountyRadonEvidence evidence
@param TrustMetadata trust = null
@param String canonicalUrl

!{
    final String placeLabel = county.getAreaDisplayName() + ", " + county.getStateAbbr();
    final String seoTitle = "Radon Gas Testing in " + placeLabel + " | Local Data & Test Steps";
    final String seoDescription = "How to test for radon in " + placeLabel + ": placement, closed-house conditions, result thresholds, local evidence, and what to do after the test.";
    final String testProtocolAnswer = "Use a short-term radon test on the lowest level that could be regularly occupied. Keep windows and exterior doors closed under the kit instructions, place the device away from drafts, heat, humidity, and exterior walls, and do not move it during the test.";
    final String resultAnswer = "At 4.0 pCi/L or higher, confirm the result when the test instructions call for it and begin mitigation planning. From 2.0 to 3.9 pCi/L, a follow-up or long-term test can clarify the decision. A county statistic never replaces the home's own reading.";
}

@template.layout.main(
    title = seoTitle,
    description = seoDescription,
    canonicalUrl = canonicalUrl,
    headContent = @`
        <script type="application/ld+json">
            {
                "@context": "https://schema.org",
                "@type": "WebPage",
                "name": $unsafe{JsonLdUtils.json(seoTitle)},
                "url": $unsafe{JsonLdUtils.json(canonicalUrl)},
                "description": $unsafe{JsonLdUtils.json(seoDescription)},
                "inLanguage": "en-US",
                "about": [{
                    "@type": "Thing",
                    "name": "Radon testing"
                },{
                    "@type": "Place",
                    "name": $unsafe{JsonLdUtils.json(placeLabel)}
                }]
            }
        </script>
        <script type="application/ld+json">
            {
                "@context": "https://schema.org",
                "@type": "BreadcrumbList",
                "itemListElement": [{
                    "@type": "ListItem",
                    "position": 1,
                    "name": "Home",
                    "item": "https://radonverdict.com/"
                },{
                    "@type": "ListItem",
                    "position": 2,
                    "name": "New York Radon Levels",
                    "item": "https://radonverdict.com/radon-levels/new-york"
                },{
                    "@type": "ListItem",
                    "position": 3,
                    "name": $unsafe{JsonLdUtils.json("Radon Testing in " + county.getAreaDisplayName())},
                    "item": $unsafe{JsonLdUtils.json(canonicalUrl)}
                }]
            }
        </script>
        <script type="application/ld+json">
            {
                "@context": "https://schema.org",
                "@type": "FAQPage",
                "mainEntity": [{
                    "@type": "Question",
                    "name": $unsafe{JsonLdUtils.json("How should I test for radon in " + placeLabel + "?")},
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": $unsafe{JsonLdUtils.json(testProtocolAnswer)}
                    }
                },{
                    "@type": "Question",
                    "name": "What should I do after a radon test?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": $unsafe{JsonLdUtils.json(resultAnswer)}
                    }
                }]
            }
        </script>
    `,
    content = @`
        <main class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-10 w-full">
            <nav class="mb-8 text-sm font-medium text-slate-500" aria-label="Breadcrumb">
                <ol class="inline-flex flex-wrap items-center gap-2">
                    <li><a href="/" class="hover:text-slate-900">Home</a></li>
                    <li class="text-slate-300">/</li>
                    <li><a href="/radon-levels/new-york" class="hover:text-slate-900">New York Radon Levels</a></li>
                    <li class="text-slate-300">/</li>
                    <li class="font-semibold text-slate-900" aria-current="page">Ulster County Testing</li>
                </ol>
            </nav>

            <header class="grid gap-8 lg:grid-cols-[1.12fr_0.88fr] lg:items-start">
                <div>
                    <p class="text-xs font-black uppercase tracking-[0.2em] text-indigo-700">Ulster County test-first guide</p>
                    <h1 class="mt-3 font-display text-4xl font-black tracking-tight text-slate-950 sm:text-5xl">
                        Radon Gas Testing in ${placeLabel}
                    </h1>
                    <p class="mt-5 max-w-3xl text-lg leading-relaxed text-slate-700">
                        Test the home before pricing mitigation or calling a county map an all-clear. Ulster County evidence explains the local context, but the reading from the lowest regularly occupied level controls the decision.
                    </p>
                    <div class="mt-7 flex flex-col gap-3 sm:flex-row">
                        <a href="#testing-steps" class="inline-flex min-h-12 items-center justify-center rounded-xl bg-slate-950 px-5 text-sm font-black text-white hover:bg-slate-800">
                            Follow the test steps
                        </a>
                        <a href="/radon-levels/new-york/ulster-county" class="inline-flex min-h-12 items-center justify-center rounded-xl border border-slate-300 bg-white px-5 text-sm font-black text-slate-800 hover:bg-slate-50">
                            Check Ulster County radon levels
                        </a>
                    </div>
                </div>

                <aside class="rounded-2xl border border-indigo-200 bg-indigo-50 p-6">
                    <p class="text-xs font-black uppercase tracking-wider text-indigo-700">Direct answer</p>
                    <h2 class="mt-2 font-display text-2xl font-black text-slate-950">${evidence.getDecisionHeadline()}</h2>
                    <p class="mt-4 leading-relaxed text-slate-700">${evidence.getRecommendedAction()}</p>
                    <p class="mt-4 rounded-xl border border-indigo-200 bg-white p-4 text-sm font-semibold leading-relaxed text-slate-700">
                        County data is a reason to test carefully—not a substitute for testing this building.
                    </p>
                </aside>
            </header>

            <section id="testing-steps" class="mt-10 rounded-2xl border border-slate-200 bg-white p-6 shadow-sm sm:p-8">
                <p class="text-xs font-black uppercase tracking-wider text-emerald-700">Short-term test protocol</p>
                <h2 class="mt-2 font-display text-3xl font-black tracking-tight text-slate-950">How to test a home in Ulster County</h2>
                <p class="mt-4 max-w-3xl leading-relaxed text-slate-700">${testProtocolAnswer}</p>

                <ol class="mt-7 grid gap-4 md:grid-cols-2">
                    <li class="rounded-2xl border border-slate-200 bg-slate-50 p-5">
                        <p class="text-xs font-black uppercase tracking-wider text-indigo-700">1. Choose the level</p>
                        <h3 class="mt-2 text-lg font-black text-slate-950">Test the lowest occupiable floor</h3>
                        <p class="mt-2 text-sm leading-relaxed text-slate-600">Use a basement family room, bedroom, office, or the first floor when the basement is not suitable for regular occupancy.</p>
                    </li>
                    <li class="rounded-2xl border border-slate-200 bg-slate-50 p-5">
                        <p class="text-xs font-black uppercase tracking-wider text-indigo-700">2. Stabilize the house</p>
                        <h3 class="mt-2 text-lg font-black text-slate-950">Follow closed-house conditions</h3>
                        <p class="mt-2 text-sm leading-relaxed text-slate-600">Follow the device instructions before and during a short-term test. Avoid unusual ventilation that can distort the reading.</p>
                    </li>
                    <li class="rounded-2xl border border-slate-200 bg-slate-50 p-5">
                        <p class="text-xs font-black uppercase tracking-wider text-indigo-700">3. Place it correctly</p>
                        <h3 class="mt-2 text-lg font-black text-slate-950">Keep the device in normal room air</h3>
                        <p class="mt-2 text-sm leading-relaxed text-slate-600">Keep it away from windows, exterior doors, fans, direct heat, high humidity, and places where it can be disturbed.</p>
                    </li>
                    <li class="rounded-2xl border border-slate-200 bg-slate-50 p-5">
                        <p class="text-xs font-black uppercase tracking-wider text-indigo-700">4. Preserve the result</p>
                        <h3 class="mt-2 text-lg font-black text-slate-950">Record dates, location, and pCi/L</h3>
                        <p class="mt-2 text-sm leading-relaxed text-slate-600">Keep the report with the exact room and test period. Those details matter when comparing a follow-up test, a real-estate test, or a mitigation quote.</p>
                    </li>
                </ol>
            </section>

            <section class="mt-8 grid gap-6 lg:grid-cols-[0.9fr_1.1fr]">
                <div class="rounded-2xl border border-slate-200 bg-white p-6">
                    <p class="text-xs font-black uppercase tracking-wider text-slate-500">Local evidence</p>
                    <h2 class="mt-2 font-display text-2xl font-black text-slate-950">What the Ulster County signal says</h2>
                    <div class="mt-5 grid gap-3">
                        <div class="rounded-xl bg-slate-50 p-4">
                            <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Evidence profile</p>
                            <p class="mt-2 font-bold text-slate-950">${evidence.getSourceProfileLabel()}</p>
                        </div>
                        <div class="rounded-xl bg-slate-50 p-4">
                            <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Primary local signal</p>
                            <p class="mt-2 font-bold text-slate-950">${evidence.getPrimaryAverageDisplay()}</p>
                        </div>
                        <div class="rounded-xl bg-slate-50 p-4">
                            <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Reported tests</p>
                            <p class="mt-2 font-bold text-slate-950">${evidence.getTestVolumeDisplay()}</p>
                        </div>
                    </div>
                    <p class="mt-5 text-sm leading-relaxed text-slate-600">${evidence.getMeasuredBurdenSummary()}</p>
                </div>

                <div class="rounded-2xl border border-slate-200 bg-white p-6">
                    <p class="text-xs font-black uppercase tracking-wider text-slate-500">Result to decision</p>
                    <h2 class="mt-2 font-display text-2xl font-black text-slate-950">What to do after the test</h2>
                    <div class="mt-5 space-y-3">
                        <div class="rounded-xl border border-emerald-200 bg-emerald-50 p-4">
                            <p class="font-black text-emerald-900">Under 2.0 pCi/L</p>
                            <p class="mt-1 text-sm leading-relaxed text-slate-700">Keep the result and retest on a sensible schedule or after major building changes.</p>
                        </div>
                        <div class="rounded-xl border border-amber-200 bg-amber-50 p-4">
                            <p class="font-black text-amber-900">2.0–3.9 pCi/L</p>
                            <p class="mt-1 text-sm leading-relaxed text-slate-700">Use a follow-up or long-term test to reduce uncertainty before making a large spending decision.</p>
                        </div>
                        <div class="rounded-xl border border-rose-200 bg-rose-50 p-4">
                            <p class="font-black text-rose-900">4.0+ pCi/L</p>
                            <p class="mt-1 text-sm leading-relaxed text-slate-700">Confirm as directed, then move into mitigation scope and local cost planning instead of repeatedly delaying the decision.</p>
                        </div>
                    </div>
                    <p class="mt-5 text-sm leading-relaxed text-slate-600">${evidence.getRetestTriggerSummary()}</p>
                </div>
            </section>

            <section class="mt-8 rounded-2xl border border-slate-900 bg-slate-950 p-6 text-white sm:p-8">
                <p class="text-xs font-black uppercase tracking-[0.18em] text-emerald-300">Keep each question on the right page</p>
                <h2 class="mt-2 font-display text-2xl font-black">Testing tells you the number. Levels explain it. Cost pages price the response.</h2>
                <p class="mt-4 max-w-3xl leading-relaxed text-slate-300">
                    Do not use a county average as a home result, and do not start with contractor prices when the property has not been tested. Move through the sequence once: test, interpret, then budget only if the result supports it.
                </p>
                <div class="mt-6 flex flex-col gap-3 sm:flex-row">
                    <a href="/radon-levels/new-york/ulster-county" class="inline-flex min-h-12 items-center justify-center rounded-xl bg-white px-5 text-sm font-black text-slate-950 hover:bg-slate-100">Interpret the Ulster County signal</a>
                    <a href="/radon-mitigation-cost" class="inline-flex min-h-12 items-center justify-center rounded-xl border border-white/20 px-5 text-sm font-black text-white hover:bg-white/10">Open mitigation cost planning</a>
                </div>
            </section>

            @if(trust != null && trust.getSources() != null && !trust.getSources().isEmpty())
                <section class="mt-8 border-t border-slate-200 pt-6">
                    <p class="text-xs font-black uppercase tracking-wider text-slate-500">Official and primary sources</p>
                    <ul class="mt-3 space-y-2 text-sm text-slate-600">
                        @for(var source : trust.getSources())
                            <li><a class="font-semibold text-indigo-700 hover:underline" href="${source.getUrl()}" target="_blank" rel="noopener nofollow">${source.getName()}</a></li>
                        @endfor
                    </ul>
                </section>
            @endif
        </main>
    `
)
