@param String title

@template.layout.main(
    title = title,
    description = "How RadonVerdict creates versioned result-to-action plans, uses local evidence, and states its limits.",
    canonicalUrl = "https://radonverdict.com/methodology",
    content = @`
        <main class="mx-auto max-w-4xl px-4 py-16 sm:px-6 sm:py-24">
            <p class="text-xs font-black uppercase tracking-[0.22em] text-emerald-800">Methodology</p>
            <h1 class="mt-4 font-display text-4xl font-black tracking-tight text-stone-950 sm:text-5xl">Result first. Evidence second. No invented local price.</h1>
            <p class="mt-6 border-b border-stone-300 pb-10 text-xl font-semibold leading-relaxed text-stone-600">The product keeps three things separate: the user's home result, county-level public evidence, and professional judgment that software cannot provide.</p>

            <div class="mt-10 space-y-10">
                <section><h2 class="font-display text-2xl font-black text-stone-950">1. Decision input</h2><p class="mt-3 font-semibold leading-relaxed text-stone-700">The plan accepts a radon reading, a five-digit ZIP, and whether the user is living in, buying, or selling the home. An invalid reading is never coerced into a valid band. The plan does not claim the test protocol was valid because duration, device, placement, weather, and closed-house conditions are not collected.</p></section>
                <section><h2 class="font-display text-2xl font-black text-stone-950">2. Decision rule</h2><p class="mt-3 font-semibold leading-relaxed text-stone-700">Versioned logic assigns the reading to an action band and returns no more than three next steps. EPA guidance is the national baseline. Transaction context changes wording and sequence, not the underlying health threshold.</p></section>
                <section><h2 class="font-display text-2xl font-black text-stone-950">3. Location evidence</h2><p class="mt-3 font-semibold leading-relaxed text-stone-700">ZIP is mapped to a primary county and can be ambiguous near boundaries. Official measured summaries are preferred; official tiers and EPA zones are context only. A county average or zone never substitutes for the entered home result.</p><a href="/radon-data-sources" class="mt-3 inline-block text-sm font-black text-emerald-800 underline">Review the source inventory</a></section>
                <section><h2 class="font-display text-2xl font-black text-stone-950">4. Private snapshot</h2><p class="mt-3 font-semibold leading-relaxed text-stone-700">A share stores the generated answer with schema, decision, and data versions for 30 days. The raw random token is not stored; only its SHA-256 hash is. Shared pages are read-only, noindex, private/no-store, and omit the ZIP from the rendered page.</p></section>
                <section><h2 class="font-display text-2xl font-black text-stone-950">5. Search inclusion</h2><p class="mt-3 font-semibold leading-relaxed text-stone-700">Mass county publication is retired. Five same-path county pages remain as preservation canaries, not proven winners. Other generated county pages and all modeled local-cost surfaces are excluded or returned as gone in production.</p></section>
                <section><h2 class="font-display text-2xl font-black text-stone-950">6. Known limits</h2><ul class="mt-3 list-disc space-y-2 pl-6 font-semibold text-stone-700"><li>No result can be validated without test-protocol details.</li><li>Public datasets vary by period, method, completeness, and geography.</li><li>Rules and credential requirements can change; verify with the official state program.</li><li>The software is informational and is not medical, legal, engineering, measurement, or mitigation advice.</li></ul></section>
            </div>

            <div class="mt-12 rounded-2xl border border-stone-300 bg-white p-6"><h2 class="font-display text-xl font-black text-stone-950">Correction requests</h2><p class="mt-2 font-semibold leading-relaxed text-stone-700">Send a source URL and the affected page through the contact form. Corrections are evaluated against the source semantics, not merely copied into the site.</p><a href="/contact" class="mt-5 inline-flex min-h-[46px] items-center rounded-xl bg-stone-950 px-5 text-sm font-black text-white">Contact RadonVerdict</a></div>
        </main>
    `
)
