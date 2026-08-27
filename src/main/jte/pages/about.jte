@param String title

@template.layout.main(
    title = title,
    description = "About RadonVerdict, an independent result-to-action radon handoff tool and its limits.",
    canonicalUrl = "https://radonverdict.com/about",
    content = @`
        <main class="mx-auto max-w-4xl px-4 py-16 sm:px-6 sm:py-24">
            <p class="text-xs font-black uppercase tracking-[0.22em] text-emerald-800">About RadonVerdict</p>
            <h1 class="mt-4 font-display text-4xl font-black tracking-tight text-stone-950 sm:text-5xl">A small tool for the moment after a radon result.</h1>
            <p class="mt-6 border-b border-stone-300 pb-10 text-xl font-semibold leading-relaxed text-stone-600">RadonVerdict turns a result, ZIP, and situation into a short action plan that can be handed to a homeowner, buyer, or seller without uploading their identity or inspection report.</p>

            <section class="mt-10 grid gap-4 sm:grid-cols-3">
                <div class="rounded-2xl border border-stone-300 bg-white p-5"><p class="text-xs font-black uppercase tracking-wider text-stone-500">Operator</p><p class="mt-3 text-sm font-semibold leading-relaxed text-stone-700">An independent software and public-data project.</p></div>
                <div class="rounded-2xl border border-stone-300 bg-white p-5"><p class="text-xs font-black uppercase tracking-wider text-stone-500">Business model</p><p class="mt-3 text-sm font-semibold leading-relaxed text-stone-700">No contractor ranking, referral fee, or pay-to-play recommendation.</p></div>
                <div class="rounded-2xl border border-stone-300 bg-white p-5"><p class="text-xs font-black uppercase tracking-wider text-stone-500">Privacy</p><p class="mt-3 text-sm font-semibold leading-relaxed text-stone-700">No client name, street address, email, phone, or inspection report is required.</p></div>
            </section>

            <section class="mt-12 space-y-8 text-stone-700">
                <div><h2 class="font-display text-2xl font-black text-stone-950">What it does</h2><p class="mt-3 font-semibold leading-relaxed">It applies a versioned decision rule to the entered result, resolves ZIP to a primary county, and attaches official county evidence when the project has a source with clear measurement semantics. A private share freezes that answer so it does not silently change when data or logic changes later.</p></div>
                <div><h2 class="font-display text-2xl font-black text-stone-950">What it does not do</h2><ul class="mt-3 list-disc space-y-2 pl-6 font-semibold"><li>It does not certify that a test was placed or run correctly.</li><li>It does not predict one home's level from a county map.</li><li>It does not produce a local mitigation price from ZIP and reading alone.</li><li>It does not replace a state radon program, qualified measurement professional, mitigator, doctor, lawyer, or engineer.</li></ul></div>
                <div class="rounded-2xl border border-amber-300 bg-amber-50 p-6"><h2 class="font-display text-xl font-black text-amber-950">Authority limitation</h2><p class="mt-2 text-sm font-semibold leading-relaxed text-amber-950">RadonVerdict does not currently claim review by a credentialed radon measurement or mitigation professional. When professional judgment is required, use your state radon program or a recognized proficiency program.</p></div>
            </section>

            <a href="/methodology" class="mt-10 inline-flex min-h-[48px] items-center rounded-xl bg-stone-950 px-5 text-sm font-black text-white">Read the methodology</a>
        </main>
    `
)
