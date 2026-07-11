@import com.radonverdict.util.JsonLdUtils

@param String clientZip = null
@param String clientReading = null
@param String clientIntent = null

!{
    final String seoTitle = "Radon Failed Inspection: Seller Credit, Cost, and Retest Plan";
    final String seoDescription = "Failed a radon inspection? See when to retest, when to ask for repairs or a seller credit, and how to use local mitigation cost before the deal deadline.";
    final boolean hasClientContext = clientZip != null || clientReading != null || clientIntent != null;
    final String clientActionUrl = clientZip == null
            ? "/radon-cost-calculator"
            : "/client-action-plan?zipCode=" + clientZip
                    + (clientReading != null ? "&radonReading=" + clientReading : "")
                    + (clientIntent != null ? "&intent=" + clientIntent : "")
                    + "&source=home-inspector-packet";
}

@template.layout.main(
    title = seoTitle + " | RadonVerdict",
    canonicalUrl = "https://radonverdict.com/guides/radon-failed-inspection",
    description = seoDescription,
    headContent = @`
        <script type="application/ld+json">
            {
                "@context": "https://schema.org",
                "@type": "WebPage",
                "name": $unsafe{JsonLdUtils.json(seoTitle)},
                "url": "https://radonverdict.com/guides/radon-failed-inspection",
                "description": $unsafe{JsonLdUtils.json(seoDescription)},
                "inLanguage": "en-US",
                "about": [{
                    "@type": "Thing",
                    "name": "Radon failed inspection"
                },{
                    "@type": "Thing",
                    "name": "Radon seller credit"
                },{
                    "@type": "Thing",
                    "name": "Radon mitigation cost"
                }]
            }
        </script>
        <script type="application/ld+json">
            {
                "@context": "https://schema.org",
                "@type": "FAQPage",
                "mainEntity": [{
                    "@type": "Question",
                    "name": "What happens if a home fails a radon inspection?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "A failed radon inspection usually means the buyer and seller need to confirm the test was valid, price local mitigation, and decide between seller repair, closing credit, price concession, or buyer-managed mitigation after closing."
                    }
                },{
                    "@type": "Question",
                    "name": "Should a buyer ask for radon mitigation or a seller credit?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "The cleaner ask depends on deadline, trust, and scope. Seller repair can work when closing has time and the buyer can verify the contractor. A credit can work when the buyer wants control after closing."
                    }
                },{
                    "@type": "Question",
                    "name": "Do you retest after a 4.0 pCi/L radon result?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "Retesting can be reasonable if the original test setup was questionable or the result is borderline. A clear 4.0+ result during a deal should also trigger local cost and credit planning before deadlines pass."
                    }
                }]
            }
        </script>
    `,
    content = @`
        <section class="bg-slate-950 text-white">
            <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-14 sm:py-20">
                <nav class="text-sm font-medium text-slate-400 mb-8" aria-label="Breadcrumb">
                    <ol class="inline-flex items-center space-x-2">
                        <li><a href="/" class="hover:text-white transition-colors">Home</a></li>
                        <li><span class="mx-1 text-slate-600">/</span></li>
                        <li><a href="/guides" class="hover:text-white transition-colors">Guides</a></li>
                        <li><span class="mx-1 text-slate-600">/</span></li>
                        <li class="text-white font-semibold" aria-current="page">Failed Inspection</li>
                    </ol>
                </nav>

                <div class="grid gap-10 lg:grid-cols-[1fr_0.86fr] lg:items-center">
                    <div>
                        <p class="text-xs font-bold uppercase tracking-[0.26em] text-rose-300">Failed inspection decision hub</p>
                        <h1 class="mt-5 font-display text-4xl font-black leading-tight tracking-tight text-white sm:text-6xl">
                            Radon failed inspection: credit, repair, or retest?
                        </h1>
                        <p class="mt-5 max-w-2xl text-lg font-semibold leading-relaxed text-slate-300">
                            Use the test number, deadline, and local mitigation range to choose the next move before the deal conversation turns into guesswork.
                        </p>
                        @if(hasClientContext)
                            <div class="mt-6 border-l-2 border-cyan-300 bg-white/10 px-4 py-3">
                                <p class="text-xs font-black uppercase tracking-wider text-cyan-200">Your inspection context</p>
                                <p class="mt-1 text-sm font-bold text-white">
                                    @if(clientReading != null)${clientReading} pCi/L@endif
                                    @if(clientReading != null && (clientZip != null || clientIntent != null)) <span class="text-slate-400">|</span> @endif
                                    @if(clientZip != null)ZIP ${clientZip}@endif
                                    @if(clientZip != null && clientIntent != null) <span class="text-slate-400">|</span> @endif
                                    @if(clientIntent != null)${clientIntent.equals("buying") ? "Buying" : clientIntent.equals("selling") ? "Selling" : "Living here"}@endif
                                </p>
                            </div>
                        @endif
                        <div class="mt-8 flex flex-col gap-3 sm:flex-row">
                            <a href="${clientActionUrl}"
                               class="inline-flex min-h-[52px] items-center justify-center rounded-xl bg-white px-5 text-sm font-black text-slate-950 transition-colors hover:bg-slate-100">
                                Calculate seller credit
                            </a>
                            <a href="${clientActionUrl}"
                               class="inline-flex min-h-[52px] items-center justify-center rounded-xl border border-white/20 px-5 text-sm font-black text-white transition-colors hover:bg-white/10">
                                Open local cost path
                            </a>
                        </div>
                    </div>

                    <div class="rounded-[1.75rem] border border-white/10 bg-white/10 p-5 shadow-2xl">
                        <p class="text-xs font-bold uppercase tracking-[0.22em] text-slate-400">Fast answer</p>
                        <div class="mt-4 space-y-3">
                            <div class="rounded-2xl border border-white/10 bg-white p-4 text-slate-950">
                                <p class="text-sm font-black">4.0+ pCi/L with a valid test</p>
                                <p class="mt-1 text-sm leading-relaxed text-slate-600">Price mitigation now and turn the local range into a repair or credit ask.</p>
                            </div>
                            <div class="rounded-2xl border border-white/10 bg-white/10 p-4">
                                <p class="text-sm font-black text-white">Questionable setup or borderline result</p>
                                <p class="mt-1 text-sm leading-relaxed text-slate-300">Retest quickly, but do not let retesting delay the cost/credit plan.</p>
                            </div>
                            <div class="rounded-2xl border border-white/10 bg-white/10 p-4">
                                <p class="text-sm font-black text-white">Seller wants a clean close</p>
                                <p class="mt-1 text-sm leading-relaxed text-slate-300">Use a credit or escrow framing instead of promising a vague contractor fix.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <main class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-14 sm:py-16">
            <section class="grid gap-5 lg:grid-cols-4">
                <a href="/radon-credit-calculator"
                   class="rounded-2xl border border-rose-200 bg-rose-50 p-5 transition-colors hover:border-rose-300 hover:bg-rose-100">
                    <p class="text-xs font-black uppercase tracking-wider text-rose-700">Buyer ask</p>
                    <h2 class="mt-3 text-xl font-black text-slate-950">Turn the result into a credit number</h2>
                    <p class="mt-2 text-sm leading-relaxed text-slate-700">Use county cost as the anchor, not a random national average.</p>
                </a>
                <a href="/guides/radon-seller-credit-worksheet"
                   class="rounded-2xl border border-blue-200 bg-blue-50 p-5 transition-colors hover:border-blue-300 hover:bg-blue-100">
                    <p class="text-xs font-black uppercase tracking-wider text-blue-700">Seller response</p>
                    <h2 class="mt-3 text-xl font-black text-slate-950">Choose repair, credit, or concession</h2>
                    <p class="mt-2 text-sm leading-relaxed text-slate-700">Keep the negotiation specific without overpromising contractor scope.</p>
                </a>
                <a href="/radon-cost-calculator"
                   class="rounded-2xl border border-slate-200 bg-slate-50 p-5 transition-colors hover:border-slate-400 hover:bg-slate-100">
                    <p class="text-xs font-black uppercase tracking-wider text-slate-500">Local cost</p>
                    <h2 class="mt-3 text-xl font-black text-slate-950">Open the county mitigation range</h2>
                    <p class="mt-2 text-sm leading-relaxed text-slate-700">Foundation type, county context, and result band change the budget.</p>
                </a>
                <a href="/guides/how-to-test-for-radon"
                   class="rounded-2xl border border-emerald-200 bg-emerald-50 p-5 transition-colors hover:border-emerald-300 hover:bg-emerald-100">
                    <p class="text-xs font-black uppercase tracking-wider text-emerald-700">Retest</p>
                    <h2 class="mt-3 text-xl font-black text-slate-950">Check whether the test is defensible</h2>
                    <p class="mt-2 text-sm leading-relaxed text-slate-700">Invalid placement or timing can change the conversation.</p>
                </a>
            </section>

            <section class="mt-16 grid gap-10 lg:grid-cols-[0.8fr_1.2fr]">
                <div>
                    <p class="text-xs font-bold uppercase tracking-[0.22em] text-slate-500">Decision order</p>
                    <h2 class="mt-3 font-display text-3xl font-black tracking-tight text-slate-950">Do these in the right order.</h2>
                    <p class="mt-3 text-sm leading-relaxed text-slate-600">
                        Most bad radon negotiations fail because the parties jump from a scary number to a random ask. This order keeps the ask grounded.
                    </p>
                </div>
                <div class="divide-y divide-slate-200 rounded-[1.75rem] border border-slate-200 bg-white">
                    <div class="grid gap-3 p-5 md:grid-cols-[0.25fr_0.75fr]">
                        <p class="font-display text-2xl font-black text-rose-700">01</p>
                        <div>
                            <h3 class="text-lg font-black text-slate-950">Confirm the test context</h3>
                            <p class="mt-1 text-sm leading-relaxed text-slate-600">Was it the lowest livable level, closed-house conditions, and a valid test window? If not, plan a fast retest while still preparing the cost range.</p>
                        </div>
                    </div>
                    <div class="grid gap-3 p-5 md:grid-cols-[0.25fr_0.75fr]">
                        <p class="font-display text-2xl font-black text-rose-700">02</p>
                        <div>
                            <h3 class="text-lg font-black text-slate-950">Price the local fix</h3>
                            <p class="mt-1 text-sm leading-relaxed text-slate-600">A basement, slab, and crawl-space home do not create the same bid. Open the local cost path before choosing the ask.</p>
                        </div>
                    </div>
                    <div class="grid gap-3 p-5 md:grid-cols-[0.25fr_0.75fr]">
                        <p class="font-display text-2xl font-black text-rose-700">03</p>
                        <div>
                            <h3 class="text-lg font-black text-slate-950">Pick the deal mechanism</h3>
                            <p class="mt-1 text-sm leading-relaxed text-slate-600">Seller repair works when there is time and trust. A closing credit works when the buyer wants control or the deadline is tight.</p>
                        </div>
                    </div>
                    <div class="grid gap-3 p-5 md:grid-cols-[0.25fr_0.75fr]">
                        <p class="font-display text-2xl font-black text-rose-700">04</p>
                        <div>
                            <h3 class="text-lg font-black text-slate-950">Write the ask in plain numbers</h3>
                            <p class="mt-1 text-sm leading-relaxed text-slate-600">Use a range with a ceiling and fallback. Avoid vague language like “seller to remediate” without scope, retest, deadline, and contractor expectations.</p>
                        </div>
                    </div>
                </div>
            </section>

            <section class="mt-16 rounded-[1.75rem] border border-slate-200 bg-slate-950 p-5 text-white sm:p-6">
                <div class="grid gap-6 lg:grid-cols-[1fr_1fr] lg:items-center">
                    <div>
                        <p class="text-xs font-bold uppercase tracking-[0.22em] text-slate-400">Deal language</p>
                        <h2 class="mt-3 font-display text-3xl font-black tracking-tight">The ask should name the path, not just the fear.</h2>
                        <p class="mt-3 text-sm leading-relaxed text-slate-300">
                            “The radon test failed” is not enough. The stronger version says what result triggered action, what local mitigation may cost, and whether the buyer wants repair, credit, or post-close control.
                        </p>
                    </div>
                    <div class="rounded-2xl border border-white/10 bg-white p-5 text-slate-950">
                        <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Reusable framing</p>
                        <p class="mt-3 text-sm leading-relaxed text-slate-700">
                            The radon result was at or above the EPA action level. We want the issue resolved using a local mitigation cost range, with either seller-paid repair before closing or a closing credit that lets the buyer manage contractor scope after closing.
                        </p>
                    </div>
                </div>
            </section>

            <section class="mt-16">
                <div class="flex flex-col gap-3 md:flex-row md:items-end md:justify-between">
                    <div>
                        <p class="text-xs font-bold uppercase tracking-[0.22em] text-slate-500">Common failed-inspection searches</p>
                        <h2 class="mt-2 font-display text-3xl font-black tracking-tight text-slate-950">Use the exact next page for the exact problem.</h2>
                    </div>
                </div>
                <div class="mt-6 grid gap-3 md:grid-cols-2">
                    <a href="/guides/who-pays-radon-mitigation-buyer-or-seller" class="rounded-2xl border border-slate-200 bg-white p-4 transition-colors hover:border-slate-400 hover:bg-slate-50">
                        <h3 class="font-black text-slate-950">Who pays after a failed radon inspection?</h3>
                        <p class="mt-1 text-sm leading-relaxed text-slate-600">Use this when the fight is buyer vs seller responsibility.</p>
                    </a>
                    <a href="/radon-credit-calculator" class="rounded-2xl border border-slate-200 bg-white p-4 transition-colors hover:border-slate-400 hover:bg-slate-50">
                        <h3 class="font-black text-slate-950">How much seller credit should I ask for?</h3>
                        <p class="mt-1 text-sm leading-relaxed text-slate-600">Use this when the deal needs a number, not another article.</p>
                    </a>
                    <a href="/radon-mitigation-cost" class="rounded-2xl border border-slate-200 bg-white p-4 transition-colors hover:border-slate-400 hover:bg-slate-50">
                        <h3 class="font-black text-slate-950">How much does radon mitigation cost?</h3>
                        <p class="mt-1 text-sm leading-relaxed text-slate-600">Use this when the contractor budget is the missing piece.</p>
                    </a>
                    <a href="/guides/radon-mitigation-quote-checklist" class="rounded-2xl border border-slate-200 bg-white p-4 transition-colors hover:border-slate-400 hover:bg-slate-50">
                        <h3 class="font-black text-slate-950">What should I ask a radon contractor?</h3>
                        <p class="mt-1 text-sm leading-relaxed text-slate-600">Use this before comparing quotes, especially when scope and retest proof matter.</p>
                    </a>
                    <a href="/radon-levels" class="rounded-2xl border border-slate-200 bg-white p-4 transition-colors hover:border-slate-400 hover:bg-slate-50">
                        <h3 class="font-black text-slate-950">What does the radon number mean?</h3>
                        <p class="mt-1 text-sm leading-relaxed text-slate-600">Use this when the buyer, seller, or agent does not understand 2.0 vs 4.0+.</p>
                    </a>
                    <a href="/guides/radon-inspection-toolkit" class="rounded-2xl border border-indigo-200 bg-indigo-50 p-4 transition-colors hover:border-indigo-300 hover:bg-indigo-100">
                        <h3 class="font-black text-slate-950">Need a client-sendable inspection packet?</h3>
                        <p class="mt-1 text-sm leading-relaxed text-slate-600">Use the agent and inspector toolkit when this decision needs to be shared cleanly.</p>
                    </a>
                    <a href="/radon-quote-ledger#quote-checker" class="rounded-2xl border border-cyan-200 bg-cyan-50 p-4 transition-colors hover:border-cyan-300 hover:bg-cyan-100">
                        <h3 class="font-black text-slate-950">Have a real quote or credit number?</h3>
                        <p class="mt-1 text-sm leading-relaxed text-slate-600">Check whether the number is scoped well, then add an anonymized signal.</p>
                    </a>
                </div>
            </section>
        </main>
    `
)
