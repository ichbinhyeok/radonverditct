@param String title

@template.layout.main(
    title = title,
    description = "How RadonVerdict estimates radon mitigation costs, uses EPA radon zone data, handles state rules, and communicates the limits of public-data guidance.",
    canonicalUrl = "https://radonverdict.com/methodology",
    content = @`
        <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-16 md:py-24">
            <p class="text-xs font-bold uppercase tracking-wider text-slate-500 mb-4">Methodology</p>
            <h1 class="font-display font-bold text-4xl text-slate-900 mb-6 tracking-tight">How RadonVerdict turns public radon data into local action guidance</h1>
            <p class="text-xl text-slate-600 mb-10 leading-relaxed font-medium pb-10 border-b border-slate-200">
                Our pages are designed to answer one practical question: based on public data and the user's situation, what should someone do next?
            </p>

            <h2 class="font-display font-bold text-2xl text-slate-900 mt-12 mb-4">1. EPA Zone Context</h2>
            <p class="text-slate-600 mb-6 leading-relaxed">
                We use the EPA Map of Radon Zones as county-level context. Zone 1 means the EPA predicts higher average indoor radon potential, Zone 2 means moderate potential, and Zone 3 means lower predicted average potential. This is not a home-specific test result. A Zone 3 home can still test high, and a Zone 1 home can test low.
            </p>

            <h2 class="font-display font-bold text-2xl text-slate-900 mt-12 mb-4">2. Local Cost Estimate Inputs</h2>
            <p class="text-slate-600 mb-4 leading-relaxed">
                Cost estimates are planning ranges. They combine several inputs:
            </p>
            <ul class="list-disc pl-6 text-slate-600 mb-6 space-y-2">
                <li>foundation type, such as basement, slab-on-grade, crawl space, or unknown</li>
                <li>home-size category</li>
                <li>state and county context</li>
                <li>public cost references for typical radon mitigation work</li>
                <li>regional labor and complexity adjustments</li>
            </ul>

            <h2 class="font-display font-bold text-2xl text-slate-900 mt-12 mb-4">3. State Rules and Official Links</h2>
            <p class="text-slate-600 mb-6 leading-relaxed">
                State rules differ. Some states have radon disclosure language, some require certified radon professionals, and some point users to national certification programs. Where we show state-rule context, we also link to the official state radon program so users can verify current requirements.
            </p>

            <h2 class="font-display font-bold text-2xl text-slate-900 mt-12 mb-4">4. Data Freshness</h2>
            <p class="text-slate-600 mb-6 leading-relaxed">
                County pages show source-level retrieval dates where available. We do not automatically label every page as reviewed today. If a page has a separate editorial review date, it is shown explicitly; otherwise the source dates are the more honest freshness signal.
            </p>

            <h2 class="font-display font-bold text-2xl text-slate-900 mt-12 mb-4">5. Limits</h2>
            <ul class="list-disc pl-6 text-slate-600 mb-6 space-y-2">
                <li>We cannot know the radon level inside a specific home without a valid test.</li>
                <li>We cannot replace an on-site contractor inspection.</li>
                <li>We cannot guarantee local licensing rules or disclosure rules have not changed after our last source refresh.</li>
                <li>We do not provide medical, legal, or engineering advice.</li>
            </ul>

            <div class="rounded-2xl border border-slate-200 bg-white p-6 mt-10">
                <h2 class="font-display font-bold text-xl text-slate-900 mb-3">Correction requests</h2>
                <p class="text-slate-600 mb-5 leading-relaxed">
                    If you find a stale state link, a wrong rule summary, or a cost assumption that looks off for a local market, send the source and county through the contact page.
                </p>
                <a href="/contact" class="inline-flex items-center justify-center rounded-xl bg-slate-900 px-5 py-3 text-sm font-bold text-white hover:bg-slate-800 transition-colors">
                    Contact RadonVerdict
                </a>
            </div>
        </div>
    `
)
