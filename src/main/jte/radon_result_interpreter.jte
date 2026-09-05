@import com.radonverdict.util.JsonLdUtils

!{
    final String seoTitle = "What Does My Radon Test Result Mean? 2.0, 4.0 & 8.0 pCi/L";
    final String seoDescription = "Interpret a radon result using the reading, test type, second-test average, procedure conditions, and official EPA and CDC next-step guidance.";
}

@template.layout.main(
    title = seoTitle,
    description = seoDescription,
    canonicalUrl = "https://radonverdict.com/radon-test-result-meaning",
    articlePublished = "2026-08-27",
    articleModified = "2026-09-05",
    headContent = @`
        <script src="/js/radon-result-interpreter.js" defer></script>
        <script type="application/ld+json">
        {"@context":"https://schema.org","@type":"WebApplication","name":$unsafe{JsonLdUtils.json(seoTitle)},"url":"https://radonverdict.com/radon-test-result-meaning","description":$unsafe{JsonLdUtils.json(seoDescription)},"applicationCategory":"HealthApplication","operatingSystem":"Any","browserRequirements":"Requires JavaScript"}
        </script>
        <script type="application/ld+json">
        {"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[{"@type":"ListItem","position":1,"name":"Home","item":"https://radonverdict.com/"},{"@type":"ListItem","position":2,"name":"Radon test result meaning","item":"https://radonverdict.com/radon-test-result-meaning"}]}
        </script>
        <script type="application/ld+json">
        {"@context":"https://schema.org","@type":"FAQPage","mainEntity":[
          {"@type":"Question","name":"What does a 4.0 pCi/L radon result mean?","acceptedAnswer":{"@type":"Answer","text":"It reaches EPA's action level. A first short-term result needs a follow-up test; an average of two short-term tests or a long-term result at or above 4.0 pCi/L supports contacting a licensed radon-reduction professional."}},
          {"@type":"Question","name":"What does a radon result between 2.0 and 4.0 pCi/L mean?","acceptedAnswer":{"@type":"Answer","text":"EPA and CDC say homeowners should consider reducing radon in this range. Keep the test type and procedure with the reading because a short snapshot and a long-term result provide different context."}},
          {"@type":"Question","name":"Can I average two short-term radon tests?","acceptedAnswer":{"@type":"Answer","text":"CDC says to calculate the average when the follow-up is a second short-term test. If that average is at or above 4.0 pCi/L, contact a licensed professional about reduction."}},
          {"@type":"Question","name":"Does a low county average override my home result?","acceptedAnswer":{"@type":"Answer","text":"No. County and zone data are context only. Testing is the only way to know the radon level measured in a particular home."}}
        ]}
        </script>
        <style>
            .result-marker { transition: left .45s cubic-bezier(.2,.75,.25,1); }
            .result-reveal { animation: result-reveal .35s cubic-bezier(.2,.75,.25,1) both; }
            @keyframes result-reveal { from { opacity: 0; transform: translateY(8px); } to { opacity: 1; transform: none; } }
            @media (prefers-reduced-motion: reduce) { .result-marker { transition: none; } .result-reveal { animation: none; } }
        </style>
    `,
    content = @`
        <main class="bg-paper-light text-ink">
            <header class="border-b-2 border-ink bg-ink text-white">
                <div class="mx-auto max-w-7xl px-4 py-12 sm:px-6 sm:py-16 lg:px-8">
                    <nav class="text-sm font-bold text-stone-300" aria-label="Breadcrumb"><a class="hover:text-signal" href="/">Home</a><span class="mx-2">/</span><span class="text-white">Result interpreter</span></nav>
                    <p class="mt-8 text-xs font-black uppercase tracking-[0.24em] text-signal">Report-first decision tool</p>
                    <h1 class="mt-4 max-w-4xl font-display text-5xl font-bold leading-[.98] tracking-tight sm:text-6xl">What does my radon test result mean?</h1>
                    <p class="mt-6 max-w-2xl text-lg font-semibold leading-8 text-stone-200">The number matters. The test type and procedure determine what that number can support next.</p>
                </div>
            </header>

            <section class="mx-auto max-w-7xl px-4 py-10 sm:px-6 sm:py-14 lg:px-8" aria-labelledby="interpreter-title">
                <div class="grid gap-10 lg:grid-cols-[minmax(0,1.1fr)_minmax(0,.9fr)] lg:items-start">
                    <form id="result-interpreter-form" class="border-y-2 border-ink bg-white" novalidate>
                        <div class="border-b-2 border-ink px-5 py-6 sm:px-7">
                            <p class="text-xs font-black uppercase tracking-[0.2em] text-pine">Your test record</p>
                            <h2 id="interpreter-title" class="mt-2 font-display text-3xl font-bold">Enter what the report actually says</h2>
                            <p class="mt-3 max-w-2xl font-semibold leading-7 text-stone-600">Nothing is uploaded or saved. Unknown is a valid answer; the tool will keep the missing fact visible.</p>
                        </div>

                        <div class="divide-y divide-paper-rule">
                            <fieldset class="px-5 py-6 sm:px-7">
                                <legend class="font-display text-xl font-bold">1. Reported result</legend>
                                <label class="mt-4 block max-w-sm text-sm font-black" for="result-reading">Radon reading, pCi/L</label>
                                <input id="result-reading" class="mt-2 min-h-[52px] w-full max-w-sm border-2 border-ink bg-white px-4 text-lg font-bold" type="number" inputmode="decimal" min="0" max="999" step="0.1" placeholder="Example: 4.2" required>
                                <p id="result-reading-error" class="mt-2 text-sm font-bold text-red-700" role="alert"></p>
                            </fieldset>

                            <fieldset class="px-5 py-6 sm:px-7">
                                <legend class="font-display text-xl font-bold">2. Test type</legend>
                                <div class="mt-4 grid gap-px bg-paper-rule sm:grid-cols-2">
                                    <label class="cursor-pointer bg-white p-4"><input class="mr-3 accent-pine" type="radio" name="result-test-type" value="first-short" checked><strong>First short-term test</strong><span class="mt-1 block pl-7 text-sm font-semibold text-stone-600">2–90 day measurement; follow-up may be needed.</span></label>
                                    <label class="cursor-pointer bg-white p-4"><input class="mr-3 accent-pine" type="radio" name="result-test-type" value="second-short"><strong>Two short-term tests</strong><span class="mt-1 block pl-7 text-sm font-semibold text-stone-600">The tool will calculate their average.</span></label>
                                    <label class="cursor-pointer bg-white p-4"><input class="mr-3 accent-pine" type="radio" name="result-test-type" value="long"><strong>Long-term test</strong><span class="mt-1 block pl-7 text-sm font-semibold text-stone-600">More than 90 days.</span></label>
                                    <label class="cursor-pointer bg-white p-4"><input class="mr-3 accent-pine" type="radio" name="result-test-type" value="post-mitigation"><strong>After mitigation</strong><span class="mt-1 block pl-7 text-sm font-semibold text-stone-600">Checks an installed system.</span></label>
                                    <label class="cursor-pointer bg-white p-4 sm:col-span-2"><input class="mr-3 accent-pine" type="radio" name="result-test-type" value="unknown"><strong>I cannot identify the test type</strong><span class="mt-1 block pl-7 text-sm font-semibold text-stone-600">The report, laboratory, or tester may identify it.</span></label>
                                </div>
                                <div id="second-reading-field" class="mt-5 border-l-8 border-signal bg-paper-light p-4" hidden>
                                    <label class="block text-sm font-black" for="result-second-reading">Second short-term result, pCi/L</label>
                                    <input id="result-second-reading" class="mt-2 min-h-[52px] w-full max-w-sm border-2 border-ink bg-white px-4 text-lg font-bold" type="number" inputmode="decimal" min="0" max="999" step="0.1" placeholder="Example: 3.8">
                                </div>
                            </fieldset>

                            <fieldset class="px-5 py-6 sm:px-7">
                                <legend class="font-display text-xl font-bold">3. Procedure record</legend>
                                <select id="result-procedure" class="mt-4 min-h-[52px] w-full border-2 border-ink bg-white px-4 font-bold">
                                    <option value="clear">Placement, duration, conditions, and handling are documented</option>
                                    <option value="unknown">One or more procedure details are unknown</option>
                                    <option value="concern">A condition may conflict with the device or test protocol</option>
                                </select>
                                <label class="mt-5 block text-sm font-black" for="result-context">Decision context</label>
                                <select id="result-context" class="mt-2 min-h-[52px] w-full border-2 border-ink bg-white px-4 font-bold">
                                    <option value="living">Living in the home</option>
                                    <option value="buying">Buying or selling</option>
                                    <option value="renovation">Planning or completing renovation</option>
                                </select>
                            </fieldset>
                        </div>

                        <div class="px-5 py-6 sm:px-7"><button class="min-h-[54px] w-full bg-ink px-6 text-sm font-black text-white transition hover:bg-pine" type="submit">Interpret this record</button></div>
                    </form>

                    <div class="lg:sticky lg:top-28">
                        <section id="result-interpreter-output" class="border-2 border-ink bg-white" aria-live="polite" aria-labelledby="result-output-title">
                            <div class="border-b-2 border-ink px-5 py-5">
                                <p class="text-xs font-black uppercase tracking-[0.2em] text-pine">Recorded interpretation</p>
                                <h2 id="result-output-title" class="mt-2 font-display text-3xl font-bold">Complete the record</h2>
                            </div>
                            <div class="p-5 sm:p-7">
                                <div class="relative pt-8" aria-label="Result position on a zero to eight-plus pCi/L reference line">
                                    <div class="grid h-3 grid-cols-2 overflow-hidden bg-stone-200"><span class="bg-stone-300"></span><span class="bg-signal"></span></div>
                                    <span class="absolute left-1/2 top-3 h-8 border-l-2 border-ink"></span>
                                    <span id="result-marker" class="result-marker absolute left-0 top-2 h-10 w-1 bg-pine"></span>
                                    <div class="mt-2 flex justify-between text-xs font-black text-stone-500"><span>0</span><span>4.0 EPA action level</span><span>8+</span></div>
                                </div>
                                <strong id="result-value-summary" class="mt-7 block font-display text-3xl">No reading entered</strong>
                                <p id="result-procedure-summary" class="mt-3 border-l-4 border-stone-400 pl-4 font-bold leading-7 text-stone-600">The procedure check comes before the next-step guidance.</p>
                                <div id="result-next-step" class="mt-6 result-reveal" hidden>
                                    <p class="text-xs font-black uppercase tracking-[0.2em] text-pine">What this record supports</p>
                                    <p id="result-interpretation" class="mt-3 text-lg font-bold leading-8"></p>
                                    <p id="result-action" class="mt-4 font-semibold leading-7 text-stone-700"></p>
                                    <p id="result-context-note" class="mt-4 text-sm font-bold leading-6 text-stone-500"></p>
                                    <div class="mt-6 flex flex-col gap-3 sm:flex-row">
                                        <a id="result-primary-link" class="inline-flex min-h-[50px] items-center justify-center bg-ink px-5 text-sm font-black text-white hover:bg-pine" href="/guides/when-to-retest-for-radon">Review the next step</a>
                                        <button id="result-copy" class="min-h-[50px] border-2 border-ink bg-white px-5 text-sm font-black" type="button">Copy record</button>
                                    </div>
                                    <p id="result-copy-status" class="mt-3 text-sm font-bold text-pine" aria-live="polite"></p>
                                </div>
                            </div>
                        </section>
                    </div>
                </div>
            </section>

            <section class="border-y-2 border-ink bg-white">
                <div class="mx-auto max-w-5xl px-4 py-12 sm:px-6 lg:px-8">
                    <p class="text-xs font-black uppercase tracking-[0.2em] text-pine">Read the sequence, not only the band</p>
                    <h2 class="mt-3 font-display text-4xl font-bold">What the national guidance says</h2>
                    <dl class="mt-8 divide-y divide-paper-rule border-y-2 border-ink">
                        <div class="grid gap-3 py-6 sm:grid-cols-[190px_1fr]"><dt class="font-display text-xl font-bold">Below 2.0 pCi/L</dt><dd class="font-semibold leading-7 text-stone-700">CDC lists no immediate action, while EPA says no radon level is risk-free. Keep the report and retest when lower-level occupancy or major building changes alter the question.</dd></div>
                        <div class="grid gap-3 py-6 sm:grid-cols-[190px_1fr]"><dt class="font-display text-xl font-bold">2.0–3.9 pCi/L</dt><dd class="font-semibold leading-7 text-stone-700">EPA and CDC say to consider reducing radon. Test type, time coverage, and procedure still belong with the number.</dd></div>
                        <div class="grid gap-3 py-6 sm:grid-cols-[190px_1fr]"><dt class="font-display text-xl font-bold">First short-term ≥4.0</dt><dd class="font-semibold leading-7 text-stone-700">Take a second short- or long-term test. When the second is short-term, calculate the average of both results.</dd></div>
                        <div class="grid gap-3 py-6 sm:grid-cols-[190px_1fr]"><dt class="font-display text-xl font-bold">Confirmed or long-term ≥4.0</dt><dd class="font-semibold leading-7 text-stone-700">An average of two short-term tests or a long-term result at or above 4.0 supports contacting a licensed radon-reduction professional.</dd></div>
                    </dl>
                </div>
            </section>

            <section class="mx-auto max-w-5xl px-4 py-12 sm:px-6 lg:px-8">
                <div class="grid gap-10 lg:grid-cols-2">
                    <div><p class="text-xs font-black uppercase tracking-[0.2em] text-pine">Important boundary</p><h2 class="mt-3 font-display text-3xl font-bold">A county average cannot validate this result</h2><p class="mt-4 font-semibold leading-7 text-stone-700">County measurements and EPA zones can show why testing matters locally. They cannot replace the device report, prove the procedure was followed, or overturn a result from the home.</p><a class="mt-4 inline-flex font-black text-pine underline decoration-2 underline-offset-4" href="/radon-levels">Use local data as context →</a></div>
                    <div><p class="text-xs font-black uppercase tracking-[0.2em] text-pine">Transaction boundary</p><h2 class="mt-3 font-display text-3xl font-bold">Do not turn one result into a price claim</h2><p class="mt-4 font-semibold leading-7 text-stone-700">For a purchase or sale, preserve the report, protocol, deadline, and written scope separately. A radon number does not determine a universal repair cost or seller credit.</p><a class="mt-4 inline-flex font-black text-pine underline decoration-2 underline-offset-4" href="/guides/radon-failed-inspection">Open the transaction decision guide →</a></div>
                </div>
            </section>

            <section class="border-t-2 border-ink bg-white">
                <div class="mx-auto max-w-5xl px-4 py-12 sm:px-6 lg:px-8">
                    <p class="text-xs font-black uppercase tracking-[0.2em] text-pine">Primary guidance</p>
                    <h2 class="mt-3 font-display text-4xl font-bold">Sources used by the interpreter</h2>
                    <div class="mt-7 divide-y divide-paper-rule border-y border-paper-rule">
                        <a class="grid gap-2 py-5 sm:grid-cols-[1fr_auto] sm:items-center" href="https://www.cdc.gov/radon/testing/index.html" rel="noopener" target="_blank"><span><strong class="block text-lg">Testing for Radon in Your Home</strong><small class="mt-1 block font-semibold text-stone-500">CDC · test types, result bands, follow-up tests, and reduction decisions</small></span><span class="text-xl font-black text-pine" aria-hidden="true">↗</span></a>
                        <a class="grid gap-2 py-5 sm:grid-cols-[1fr_auto] sm:items-center" href="https://www.epa.gov/radon/what-epas-action-level-radon-and-what-does-it-mean" rel="noopener" target="_blank"><span><strong class="block text-lg">EPA action level and what it means</strong><small class="mt-1 block font-semibold text-stone-500">U.S. EPA · 4.0 pCi/L action level and reduction below it</small></span><span class="text-xl font-black text-pine" aria-hidden="true">↗</span></a>
                        <a class="grid gap-2 py-5 sm:grid-cols-[1fr_auto] sm:items-center" href="https://www.epa.gov/radon/how-often-should-i-testretest-my-home-radon" rel="noopener" target="_blank"><span><strong class="block text-lg">How often should I retest?</strong><small class="mt-1 block font-semibold text-stone-500">U.S. EPA · future testing, transactions, renovation, and lower-level occupancy</small></span><span class="text-xl font-black text-pine" aria-hidden="true">↗</span></a>
                    </div>
                    <p class="mt-6 text-sm font-semibold leading-7 text-stone-500">Reviewed September 5, 2026. This tool organizes published federal guidance; it does not diagnose health effects, validate a laboratory report, or replace state requirements and qualified professional judgment.</p>
                </div>
            </section>
        </main>
    `
)
