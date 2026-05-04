@param String title

@template.layout.main(
    title = title,
    description = "About RadonVerdict: a public-data radon cost and action-plan tool, including sources, limits, editorial standards, and how to contact the operator.",
    canonicalUrl = "https://radonverdict.com/about",
    content = @`
        <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-16 md:py-24">
            <p class="text-xs font-bold uppercase tracking-wider text-slate-500 mb-4">About RadonVerdict</p>
            <h1 class="font-display font-bold text-4xl text-slate-900 mb-6 tracking-tight">A public-data tool for radon decisions, not a contractor directory pretending to be advice.</h1>

            <p class="text-xl text-slate-600 mb-10 leading-relaxed font-medium pb-10 border-b border-slate-200">
                RadonVerdict helps homeowners, buyers, sellers, and agents turn public radon data into a practical next step: test first, retest, budget mitigation, or compare a seller-credit number.
            </p>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-12">
                <div class="rounded-2xl border border-slate-200 bg-white p-5">
                    <p class="text-xs font-bold uppercase tracking-wider text-slate-500 mb-2">Operator</p>
                    <p class="text-sm leading-relaxed text-slate-700">RadonVerdict is operated as an independent software and public-data project.</p>
                </div>
                <div class="rounded-2xl border border-slate-200 bg-white p-5">
                    <p class="text-xs font-bold uppercase tracking-wider text-slate-500 mb-2">Editorial Owner</p>
                    <p class="text-sm leading-relaxed text-slate-700">RadonVerdict Data Team, focused on public data, cost modeling, and homeowner decision flows.</p>
                </div>
                <div class="rounded-2xl border border-slate-200 bg-white p-5">
                    <p class="text-xs font-bold uppercase tracking-wider text-slate-500 mb-2">Contact</p>
                    <p class="text-sm leading-relaxed text-slate-700">Questions, corrections, and partnership inquiries go through the <a href="/contact" class="font-semibold text-indigo-600 hover:underline">contact page</a>.</p>
                </div>
            </div>

            <h2 class="font-display font-bold text-2xl text-slate-900 mt-12 mb-4">What We Do</h2>
            <p class="text-slate-600 mb-6 leading-relaxed">
                We combine EPA county radon zones, state radon program information, Census housing data, ZIP-to-county mapping, and public cost references to create local radon action pages. The goal is to reduce uncertainty before a homeowner buys a test kit, calls contractors, or negotiates a real-estate credit.
            </p>

            <h2 class="font-display font-bold text-2xl text-slate-900 mt-12 mb-4">What We Do Not Do</h2>
            <ul class="list-disc pl-6 text-slate-600 mb-6 space-y-2">
                <li>We do not perform radon testing or mitigation work.</li>
                <li>We are not a medical provider, law firm, government agency, or certified radon laboratory.</li>
                <li>We do not know the radon level inside a specific home unless the user enters a test result.</li>
                <li>We do not guarantee contractor pricing, licensing status, or availability.</li>
            </ul>

            <h2 class="font-display font-bold text-2xl text-slate-900 mt-12 mb-4">Data Sources We Rely On</h2>
            <div class="space-y-3 mb-8">
                <div class="flex gap-4 items-start p-4 rounded-xl bg-white border border-slate-200">
                    <div class="w-10 h-10 rounded-lg bg-indigo-100 text-indigo-600 flex items-center justify-center shrink-0 text-xs font-bold">EPA</div>
                    <div>
                        <h3 class="font-bold text-sm text-slate-900">EPA Map of Radon Zones</h3>
                        <p class="text-sm text-slate-600 mt-1">County-level Zone 1, 2, and 3 classifications. Zone data is useful for regional risk context, but it cannot predict one home's actual radon level.</p>
                        <a href="https://www.epa.gov/radon/epa-map-radon-zones" target="_blank" rel="noopener" class="text-sm font-semibold text-indigo-600 hover:underline mt-1 inline-block">Open EPA radon zones</a>
                    </div>
                </div>
                <div class="flex gap-4 items-start p-4 rounded-xl bg-white border border-slate-200">
                    <div class="w-10 h-10 rounded-lg bg-indigo-100 text-indigo-600 flex items-center justify-center shrink-0 text-xs font-bold">STATE</div>
                    <div>
                        <h3 class="font-bold text-sm text-slate-900">State Radon Programs</h3>
                        <p class="text-sm text-slate-600 mt-1">State health and environmental agencies are used for official radon program links, disclosure notes, and contractor credential expectations.</p>
                    </div>
                </div>
                <div class="flex gap-4 items-start p-4 rounded-xl bg-white border border-slate-200">
                    <div class="w-10 h-10 rounded-lg bg-indigo-100 text-indigo-600 flex items-center justify-center shrink-0 text-xs font-bold">COST</div>
                    <div>
                        <h3 class="font-bold text-sm text-slate-900">Public Cost References and Local Adjustments</h3>
                        <p class="text-sm text-slate-600 mt-1">Cost ranges are estimates, not quotes. We use public cost references, foundation type, home-size assumptions, and regional cost factors to produce a practical planning range.</p>
                    </div>
                </div>
            </div>

            <h2 class="font-display font-bold text-2xl text-slate-900 mt-12 mb-4">Editorial Standards</h2>
            <ul class="list-disc pl-6 text-slate-600 mb-6 space-y-2">
                <li>Health and action-level claims are tied to EPA, WHO, NAS, or similar public-health sources.</li>
                <li>County pages show source dates where available instead of implying that every page is manually reviewed every day.</li>
                <li>Affiliate links are labeled where they appear. Affiliate status does not change the radon thresholds or cost logic.</li>
                <li>When a page discusses state rules, we link users back to the official state resource for verification.</li>
            </ul>

            <div class="rounded-2xl border border-amber-200 bg-amber-50 p-6 mt-10">
                <h2 class="font-display font-bold text-xl text-amber-950 mb-2">Important limitation</h2>
                <p class="text-sm leading-relaxed text-amber-900">
                    Radon is a health risk, but RadonVerdict is an informational tool. The only reliable way to know a home's radon concentration is to test that home under valid conditions. For medical questions, contact a qualified health professional. For mitigation work, verify local licensing and certification requirements before hiring.
                </p>
            </div>

            <div class="rounded-2xl border border-slate-200 bg-white p-6 mt-10">
                <h2 class="font-display font-bold text-xl text-slate-900 mb-3">How the method works</h2>
                <p class="text-slate-600 mb-5 leading-relaxed">
                    The methodology page explains the data inputs, cost-estimate limits, and why county-level zone data should be treated as a starting point rather than a home-specific result.
                </p>
                <a href="/methodology" class="inline-flex items-center justify-center rounded-xl bg-slate-900 px-5 py-3 text-sm font-bold text-white hover:bg-slate-800 transition-colors">
                    Read the methodology
                </a>
            </div>
        </div>
    `
)
