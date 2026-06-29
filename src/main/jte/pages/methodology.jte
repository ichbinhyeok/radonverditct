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

            <div class="rounded-2xl border border-slate-200 bg-white p-6">
                <h2 class="font-display font-bold text-xl text-slate-900 mb-3">Evidence before calculators</h2>
                <p class="text-slate-600 mb-5 leading-relaxed">
                    RadonVerdict separates measured radon evidence, EPA zone context, state rules, housing assumptions, and cost references. The full source inventory is published so users can see which evidence type supports each decision layer.
                </p>
                <a href="/radon-data-sources" class="inline-flex items-center justify-center rounded-xl border border-slate-200 bg-slate-50 px-5 py-3 text-sm font-bold text-slate-900 hover:bg-white transition-colors">
                    Review radon data sources
                </a>
            </div>

            <h2 class="font-display font-bold text-2xl text-slate-900 mt-12 mb-4">1. Evidence Hierarchy</h2>
            <p class="text-slate-600 mb-4 leading-relaxed">
                We trust sources in this order when building county pages:
            </p>
            <ol class="list-decimal pl-6 text-slate-600 mb-6 space-y-2">
                <li>official measured radon summaries from state health departments, public tracking systems, or county-level public datasets</li>
                <li>official radon-potential tiers, such as New Jersey DEP tier data, when measured county averages are not available</li>
                <li>EPA zone context and state radon-program guidance</li>
                <li>Census housing context, ZIP-to-county mapping, and cost references used for planning ranges</li>
            </ol>
            <p class="text-slate-600 mb-6 leading-relaxed">
                Measured data can support stronger local radon-level copy. Tier and zone data can support testing urgency, but they cannot be presented as a home-specific result.
            </p>

            <h2 class="font-display font-bold text-2xl text-slate-900 mt-12 mb-4">2. EPA Zone Context</h2>
            <p class="text-slate-600 mb-6 leading-relaxed">
                We use the EPA Map of Radon Zones as county-level context. Zone 1 means the EPA predicts higher average indoor radon potential, Zone 2 means moderate potential, and Zone 3 means lower predicted average potential. This is not a home-specific test result. A Zone 3 home can still test high, and a Zone 1 home can test low.
            </p>

            <h2 class="font-display font-bold text-2xl text-slate-900 mt-12 mb-4">3. Local Cost Estimate Inputs</h2>
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

            <h2 class="font-display font-bold text-2xl text-slate-900 mt-12 mb-4">4. State Rules and Official Links</h2>
            <p class="text-slate-600 mb-6 leading-relaxed">
                State rules differ. Some states have radon disclosure language, some require certified radon professionals, and some point users to national certification programs. Where we show state-rule context, we also link to the official state radon program so users can verify current requirements.
            </p>

            <h2 class="font-display font-bold text-2xl text-slate-900 mt-12 mb-4">5. Data Freshness</h2>
            <p class="text-slate-600 mb-6 leading-relaxed">
                County pages show source-level retrieval dates where available. We do not automatically label every page as reviewed today. If a page has a separate editorial review date, it is shown explicitly; otherwise the source dates are the more honest freshness signal.
            </p>

            <h2 class="font-display font-bold text-2xl text-slate-900 mt-12 mb-4">6. Search Inclusion Policy</h2>
            <p class="text-slate-600 mb-6 leading-relaxed">
                We do not send every generated county page to search engines. Pages with official evidence, distinct local context, and clear user demand can be eligible for search. Pages that are too thin, too repetitive, missing a reliable local signal, or useful only after a direct user lookup can remain available on-site without being submitted for search.
            </p>

            <h2 class="font-display font-bold text-2xl text-slate-900 mt-12 mb-4">7. Limits</h2>
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
