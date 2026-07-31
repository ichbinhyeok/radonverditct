@import com.radonverdict.util.JsonLdUtils

!{
    final String seoTitle = "What Does My Radon Test Result Mean? 2.0, 4.0 & 8.0 pCi/L";
    final String seoDescription = "Understand a radon test result: what 2.0, 4.0, and 8.0 pCi/L mean, what to record from the report, and the next sensible step.";
}

@template.layout.main(
    title = seoTitle,
    description = seoDescription,
    canonicalUrl = "https://radonverdict.com/radon-test-result-meaning",
    headContent = @`
        <script type="application/ld+json">
        {"@context":"https://schema.org","@type":"WebPage","name":$unsafe{JsonLdUtils.json(seoTitle)},"url":"https://radonverdict.com/radon-test-result-meaning","description":$unsafe{JsonLdUtils.json(seoDescription)},"inLanguage":"en-US"}
        </script>
    `,
    content = @`
        <main class="bg-white">
            <section class="border-b border-slate-200 bg-slate-50">
                <div class="mx-auto max-w-4xl px-4 py-14 sm:px-6 md:py-20 lg:px-8">
                    <nav class="mb-8 text-sm font-medium text-slate-500" aria-label="Breadcrumb"><a href="/" class="hover:text-slate-950">Home</a><span class="mx-2 text-slate-300">/</span><span class="text-slate-900">Radon test result meaning</span></nav>
                    <p class="mb-4 text-xs font-bold uppercase tracking-wider text-indigo-700">Report-first answer</p>
                    <h1 class="font-display text-4xl font-black leading-tight tracking-tight text-slate-950 sm:text-5xl">What Does My Radon Test Result Mean?</h1>
                    <p class="mt-6 max-w-3xl text-lg font-medium leading-relaxed text-slate-600">Use the number from your report to choose the next step. This page explains the national threshold; it does not turn a county average into a verdict about your home.</p>
                    <form action="/plan" method="get" class="mt-8 rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
                        <input type="hidden" name="intent" value="homeowner"><input type="hidden" name="source" value="result-interpreter">
                        <label for="radon-reading" class="block text-sm font-black text-slate-950">Radon result (pCi/L)</label>
                        <div class="mt-3 flex flex-col gap-3 sm:flex-row"><input id="radon-reading" name="radonReading" type="number" inputmode="decimal" min="0" max="999" step="0.1" required placeholder="Example: 4.2" class="min-h-12 w-full rounded-xl border border-slate-300 px-4 font-bold text-slate-950 outline-none focus:border-indigo-600 focus:ring-2 focus:ring-indigo-100"><button type="submit" class="min-h-12 rounded-xl bg-slate-950 px-6 text-sm font-black text-white hover:bg-slate-800">See my next step</button></div>
                        <p class="mt-3 text-sm text-slate-600">No number yet? <a href="/guides/how-to-test-for-radon" class="font-bold text-indigo-700 hover:underline">Start with a home test.</a></p>
                    </form>
                </div>
            </section>
            <section class="mx-auto max-w-4xl px-4 py-14 sm:px-6 lg:px-8">
                <h2 class="font-display text-3xl font-black tracking-tight text-slate-950">The short answer</h2>
                <p class="mt-4 text-lg leading-relaxed text-slate-700">EPA recommends fixing a home when the radon level is 4.0 pCi/L or higher. A result below 4.0 is not an all-clear: keep the report and decide whether follow-up or long-term testing would reduce uncertainty for your home and situation.</p>
                <div class="mt-8 grid gap-4 sm:grid-cols-2">
                    <article class="rounded-2xl border border-emerald-200 bg-emerald-50 p-5"><h3 class="font-black text-emerald-950">Under 2.0 pCi/L</h3><p class="mt-2 text-sm leading-relaxed text-slate-700">Keep the report. Retest at a sensible interval and after major changes to the home.</p></article>
                    <article class="rounded-2xl border border-amber-200 bg-amber-50 p-5"><h3 class="font-black text-amber-950">2.0–3.9 pCi/L</h3><p class="mt-2 text-sm leading-relaxed text-slate-700">Below the main action threshold, but not zero risk. A follow-up or long-term test can make the decision clearer.</p></article>
                    <article class="rounded-2xl border border-orange-200 bg-orange-50 p-5"><h3 class="font-black text-orange-950">4.0–7.9 pCi/L</h3><p class="mt-2 text-sm leading-relaxed text-slate-700">This reaches EPA’s action threshold. If it came from a short-term test, CDC says to take a second short- or long-term test; use the average if both tests are short-term.</p></article>
                    <article class="rounded-2xl border border-rose-200 bg-rose-50 p-5"><h3 class="font-black text-rose-950">8.0 pCi/L or higher</h3><p class="mt-2 text-sm leading-relaxed text-slate-700">Treat this as a high reading. Preserve the report and prioritize the next test or reduction decision, especially when a home transaction has a deadline.</p></article>
                </div>
                <section class="mt-10 rounded-2xl border border-slate-200 bg-white p-6 shadow-sm">
                    <h2 class="font-display text-2xl font-black tracking-tight text-slate-950">One number is not the whole instruction</h2>
                    <dl class="mt-5 divide-y divide-slate-200 text-sm leading-relaxed">
                        <div class="py-4"><dt class="font-black text-slate-950">A short-term result at or above 4.0</dt><dd class="mt-1 text-slate-700">Take a second short- or long-term test. If both are short-term, use their average for the decision.</dd></div>
                        <div class="py-4"><dt class="font-black text-slate-950">A long-term result at or above 4.0</dt><dd class="mt-1 text-slate-700">CDC says this supports contacting a licensed professional for a radon reduction system.</dd></div>
                        <div class="py-4"><dt class="font-black text-slate-950">After a home is fixed</dt><dd class="mt-1 text-slate-700">Retest a few months later to check whether the level was reduced.</dd></div>
                    </dl>
                    <p class="mt-4 text-xs leading-relaxed text-slate-500">This summary follows CDC’s homeowner testing guidance. Your report instructions and applicable state or local requirements still control.</p>
                </section>
                <h2 class="mt-14 font-display text-3xl font-black tracking-tight text-slate-950">Before you act, keep the details that change the answer</h2>
                <ul class="mt-5 space-y-3 text-slate-700"><li><strong>The number and unit:</strong> record the pCi/L exactly as reported.</li><li><strong>Test type and duration:</strong> short-term and long-term tests answer different uncertainty questions.</li><li><strong>Location:</strong> note the lowest lived-in level and where the device was placed.</li><li><strong>Dates and test conditions:</strong> retain the complete report rather than a screenshot of the number alone.</li></ul>
                <div class="mt-12 rounded-2xl border border-indigo-200 bg-indigo-50 p-6"><h2 class="font-display text-2xl font-black text-indigo-950">Buying or selling a home?</h2><p class="mt-2 leading-relaxed text-slate-700">Do not jump from one number to a price claim. Build a documented repair, credit, or retest decision around the inspection report and the transaction deadline.</p><a href="/guides/radon-failed-inspection" class="mt-4 inline-flex font-black text-indigo-800 hover:underline">Use the failed-inspection decision guide →</a></div>
                <section class="mt-14" aria-labelledby="result-questions">
                    <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Result questions</p>
                    <h2 id="result-questions" class="mt-2 font-display text-3xl font-black tracking-tight text-slate-950">Common questions about a radon number</h2>
                    <div class="mt-6 divide-y divide-slate-200 rounded-2xl border border-slate-200 bg-white">
                        <article class="p-5"><h3 class="font-black text-slate-950">What does a 4.0 pCi/L radon result mean?</h3><p class="mt-2 leading-relaxed text-slate-700">It reaches EPA’s recommended action level. The next step depends on the test type: CDC advises a second test after a short-term result, while a long-term result at or above 4.0 supports contacting a licensed reduction professional.</p></article>
                        <article class="p-5"><h3 class="font-black text-slate-950">Is a 2.5 pCi/L radon result bad?</h3><p class="mt-2 leading-relaxed text-slate-700">It is below the main 4.0 pCi/L action level, but it is not a promise that no action is ever appropriate. EPA says homeowners may consider fixing a home between 2.0 and 4.0 pCi/L; a long-term test can make the home’s average clearer.</p></article>
                        <article class="p-5"><h3 class="font-black text-slate-950">What should I do with an 8.0 pCi/L radon result?</h3><p class="mt-2 leading-relaxed text-slate-700">Preserve the full report and act promptly on the test or reduction path. If it was a short-term test, follow the confirmation guidance; if the result is part of a transaction, document the deadline and the agreed repair, credit, or retest path.</p></article>
                        <article class="p-5"><h3 class="font-black text-slate-950">Can an EPA radon zone or county average explain my result?</h3><p class="mt-2 leading-relaxed text-slate-700">No. Maps and county records are useful local context, but testing is the only way to know the level in a specific home. <a href="/radon-levels" class="font-bold text-indigo-700 hover:underline">Browse local context separately.</a></p></article>
                    </div>
                </section>
                <h2 class="mt-14 font-display text-3xl font-black tracking-tight text-slate-950">Sources</h2>
                <p class="mt-4 leading-relaxed text-slate-700">The 4.0 pCi/L action threshold comes from EPA guidance. CDC explains why testing the individual home matters; a local zone or county record cannot replace it.</p>
                <ul class="mt-4 space-y-2"><li><a class="font-bold text-indigo-700 hover:underline" href="https://www.epa.gov/radon/explain-working-levels-wl-and-picocuries-liter-air-pcil" rel="noopener">EPA: pCi/L and the action threshold</a></li><li><a class="font-bold text-indigo-700 hover:underline" href="https://www.cdc.gov/radon/testing/index.html" rel="noopener">CDC: testing your home for radon</a></li><li><a class="font-bold text-indigo-700 hover:underline" href="/radon-levels">Browse county and state radon context</a></li></ul>
            </section>
        </main>
    `
)
