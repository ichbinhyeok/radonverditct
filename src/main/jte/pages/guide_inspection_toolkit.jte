@import com.radonverdict.util.JsonLdUtils

!{
    final String seoTitle = "Radon Failed Inspection Toolkit for Agents and Home Inspectors";
    final String seoDescription = "A practical radon failed inspection toolkit for agents and home inspectors: buyer script, seller response, credit calculator, quote checklist, and retest path.";
}

@template.layout.main(
    title = seoTitle + " | RadonVerdict",
    canonicalUrl = "https://radonverdict.com/guides/radon-inspection-toolkit",
    description = seoDescription,
    headContent = @`
        <script type="application/ld+json">
            {
                "@context": "https://schema.org",
                "@type": "WebPage",
                "name": $unsafe{JsonLdUtils.json(seoTitle)},
                "url": "https://radonverdict.com/guides/radon-inspection-toolkit",
                "description": $unsafe{JsonLdUtils.json(seoDescription)},
                "inLanguage": "en-US",
                "about": [{
                    "@type": "Thing",
                    "name": "Radon failed inspection"
                },{
                    "@type": "Thing",
                    "name": "Real estate inspection contingency"
                },{
                    "@type": "Thing",
                    "name": "Radon seller credit"
                }]
            }
        </script>
        <script type="application/ld+json">
            {
                "@context": "https://schema.org",
                "@type": "HowTo",
                "name": "Radon failed inspection decision path",
                "description": "A practical sequence for explaining a radon failed inspection, pricing the local fix, choosing repair or credit, and adding an anonymized quote signal.",
                "step": [{
                    "@type": "HowToStep",
                    "name": "Confirm the result and test setup"
                },{
                    "@type": "HowToStep",
                    "name": "Open the local cost or seller-credit path"
                },{
                    "@type": "HowToStep",
                    "name": "Choose repair, credit, retest, or buyer-managed mitigation"
                },{
                    "@type": "HowToStep",
                    "name": "Add an anonymized quote or credit signal"
                }]
            }
        </script>
    `,
    content = @`
        <section class="bg-white">
            <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-14 sm:py-20">
                <nav class="text-sm font-medium text-slate-500 mb-8" aria-label="Breadcrumb">
                    <ol class="inline-flex items-center space-x-2">
                        <li><a href="/" class="hover:text-slate-900 transition-colors">Home</a></li>
                        <li><span class="mx-1 text-slate-300">/</span></li>
                        <li><a href="/guides" class="hover:text-slate-900 transition-colors">Guides</a></li>
                        <li><span class="mx-1 text-slate-300">/</span></li>
                        <li class="text-slate-900 font-semibold" aria-current="page">Inspection Toolkit</li>
                    </ol>
                </nav>

                <div class="grid gap-10 lg:grid-cols-[1fr_0.9fr] lg:items-center">
                    <div>
                        <p class="text-xs font-bold uppercase tracking-[0.26em] text-indigo-700">Agent and inspector toolkit</p>
                        <h1 class="mt-5 font-display text-4xl font-black leading-tight tracking-tight text-slate-950 sm:text-6xl">
                            A radon failed inspection needs a decision path, not panic.
                        </h1>
                        <p class="mt-5 max-w-2xl text-lg font-semibold leading-relaxed text-slate-600">
                            Send clients to the same sequence every time: confirm the result, price the local fix, choose repair or credit, then document the next step.
                        </p>
                        <div class="mt-8 flex flex-col gap-3 sm:flex-row">
                            <a href="/radon-credit-calculator"
                               class="inline-flex min-h-[52px] items-center justify-center rounded-xl bg-slate-950 px-5 text-sm font-black text-white transition-colors hover:bg-slate-800">
                                Open credit calculator
                            </a>
                            <a href="/guides/radon-failed-inspection"
                               class="inline-flex min-h-[52px] items-center justify-center rounded-xl border border-slate-200 bg-white px-5 text-sm font-black text-slate-800 transition-colors hover:bg-slate-50">
                                Client-facing guide
                            </a>
                        </div>
                    </div>

                    <div class="rounded-[1.75rem] border border-slate-200 bg-slate-950 p-5 text-white shadow-2xl sm:p-6">
                        <p class="text-xs font-bold uppercase tracking-[0.22em] text-slate-400">Shareable packet</p>
                        <div class="mt-4 space-y-3">
                            <div class="rounded-2xl border border-white/10 bg-white p-4 text-slate-950">
                                <p class="text-sm font-black">1. Result meaning</p>
                                <p class="mt-1 text-sm leading-relaxed text-slate-600">Explain 2.0-3.9, 4.0+, and 8.0+ without making a home-specific medical claim.</p>
                            </div>
                            <div class="rounded-2xl border border-white/10 bg-white/10 p-4">
                                <p class="text-sm font-black text-white">2. Local money number</p>
                                <p class="mt-1 text-sm leading-relaxed text-slate-300">Use county cost or the seller-credit calculator before writing a repair ask.</p>
                            </div>
                            <div class="rounded-2xl border border-white/10 bg-white/10 p-4">
                                <p class="text-sm font-black text-white">3. Quote proof</p>
                                <p class="mt-1 text-sm leading-relaxed text-slate-300">Add anonymized quote data to improve future local benchmarks.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <main class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-14 sm:py-16">
            <section class="grid gap-5 lg:grid-cols-4">
                <a href="/radon-levels" class="rounded-2xl border border-slate-200 bg-white p-5 transition-colors hover:border-slate-400 hover:bg-slate-50">
                    <p class="text-xs font-black uppercase tracking-wider text-slate-500">Explain</p>
                    <h2 class="mt-3 text-xl font-black text-slate-950">Result meaning</h2>
                    <p class="mt-2 text-sm leading-relaxed text-slate-600">Start with test level and county evidence before talking money.</p>
                </a>
                <a href="/radon-cost-calculator" class="rounded-2xl border border-slate-200 bg-white p-5 transition-colors hover:border-slate-400 hover:bg-slate-50">
                    <p class="text-xs font-black uppercase tracking-wider text-slate-500">Price</p>
                    <h2 class="mt-3 text-xl font-black text-slate-950">Local cost path</h2>
                    <p class="mt-2 text-sm leading-relaxed text-slate-600">Use ZIP to open the county action plan and foundation-adjusted range.</p>
                </a>
                <a href="/radon-credit-calculator" class="rounded-2xl border border-slate-200 bg-white p-5 transition-colors hover:border-slate-400 hover:bg-slate-50">
                    <p class="text-xs font-black uppercase tracking-wider text-slate-500">Negotiate</p>
                    <h2 class="mt-3 text-xl font-black text-slate-950">Credit calculator</h2>
                    <p class="mt-2 text-sm leading-relaxed text-slate-600">Convert cost into opening ask, ceiling, or fallback.</p>
                </a>
                <a href="/radon-quote-ledger#quote-checker" class="rounded-2xl border border-slate-200 bg-white p-5 transition-colors hover:border-slate-400 hover:bg-slate-50">
                    <p class="text-xs font-black uppercase tracking-wider text-slate-500">Improve</p>
                    <h2 class="mt-3 text-xl font-black text-slate-950">Quote checker</h2>
                    <p class="mt-2 text-sm leading-relaxed text-slate-600">Check one quote, then add an anonymized quote or seller-credit signal.</p>
                </a>
                <a href="/guides/radon-mitigation-quote-checklist" class="rounded-2xl border border-slate-200 bg-white p-5 transition-colors hover:border-slate-400 hover:bg-slate-50">
                    <p class="text-xs font-black uppercase tracking-wider text-slate-500">Ask</p>
                    <h2 class="mt-3 text-xl font-black text-slate-950">Quote checklist</h2>
                    <p class="mt-2 text-sm leading-relaxed text-slate-600">Use the contractor questions before comparing quotes.</p>
                </a>
            </section>

            <section class="mt-16 grid gap-10 lg:grid-cols-[0.8fr_1.2fr]">
                <div>
                    <p class="text-xs font-bold uppercase tracking-[0.22em] text-slate-500">Client script</p>
                    <h2 class="mt-3 font-display text-3xl font-black tracking-tight text-slate-950">Use one script for the first call.</h2>
                    <p class="mt-3 text-sm leading-relaxed text-slate-600">
                        The goal is to lower confusion, not to replace legal, medical, or contractor advice. Keep the first conversation factual and short.
                    </p>
                </div>
                <div class="rounded-[1.75rem] border border-slate-200 bg-white p-5 sm:p-6">
                    <p class="text-sm leading-relaxed text-slate-700">
                        The radon result needs a structured next step. First we confirm the test setup and reading. Then we use the local county cost range to decide whether repair, seller credit, or buyer-managed mitigation is the cleanest route. If the test was questionable, we can retest, but we should still understand the likely cost before the deadline.
                    </p>
                    <div class="mt-5 flex flex-col gap-3 sm:flex-row">
                        <a href="/guides/radon-failed-inspection"
                           class="inline-flex min-h-[48px] items-center justify-center rounded-xl bg-slate-950 px-4 text-sm font-black text-white transition-colors hover:bg-slate-800">
                            Send client guide
                        </a>
                        <a href="/guides/radon-seller-credit-worksheet"
                           class="inline-flex min-h-[48px] items-center justify-center rounded-xl border border-slate-200 px-4 text-sm font-black text-slate-800 transition-colors hover:bg-slate-50">
                            Open worksheet
                        </a>
                    </div>
                </div>
            </section>

            <section class="mt-16 border-y border-slate-200 py-10">
                <div class="grid gap-8 lg:grid-cols-[0.82fr_1.18fr] lg:items-start">
                    <div>
                        <p class="text-xs font-bold uppercase tracking-[0.22em] text-slate-500">Copy/paste packet</p>
                        <h2 class="mt-3 font-display text-3xl font-black tracking-tight text-slate-950">Send one clean radon note, then collect one quote signal.</h2>
                        <p class="mt-3 text-sm leading-relaxed text-slate-600">
                            This is the resource-page version: short enough for an agent email, specific enough for a buyer or seller to choose the next step, and connected to local cost data.
                        </p>
                    </div>

                    <div class="rounded-[1.75rem] border border-slate-200 bg-white p-5 sm:p-6">
                        <p class="text-xs font-bold uppercase tracking-[0.18em] text-slate-500">Client-ready language</p>
                        <p class="mt-3 text-sm leading-relaxed text-slate-700">
                            The radon result is a decision item, not a panic item. First confirm the test setup and result band. If the reading is 4.0+ pCi/L, use the local cost path before asking for repair or credit. If the quote comes back, remove personal details and add the ZIP, foundation, result band, quote status, and price to the quote ledger so future local estimates get sharper.
                        </p>
                        <div class="mt-5 grid gap-3 sm:grid-cols-2 lg:grid-cols-4">
                            <a href="/radon-cost-calculator"
                               data-track-event="inspection_packet_click"
                               data-track-label="cost_calculator"
                               class="inline-flex min-h-[48px] items-center justify-center rounded-xl bg-slate-950 px-4 text-sm font-black text-white transition-colors hover:bg-slate-800">
                                Local cost
                            </a>
                            <a href="/radon-credit-calculator"
                               data-track-event="inspection_packet_click"
                               data-track-label="credit_calculator"
                               class="inline-flex min-h-[48px] items-center justify-center rounded-xl border border-slate-200 px-4 text-sm font-black text-slate-800 transition-colors hover:bg-slate-50">
                                Seller credit
                            </a>
                            <a href="/radon-quote-ledger#quote-checker"
                               data-track-event="inspection_packet_click"
                               data-track-label="quote_checker"
                               class="inline-flex min-h-[48px] items-center justify-center rounded-xl border border-slate-200 px-4 text-sm font-black text-slate-800 transition-colors hover:bg-slate-50">
                                Check quote
                            </a>
                            <a href="/guides/radon-mitigation-quote-checklist"
                               data-track-event="inspection_packet_click"
                               data-track-label="quote_checklist"
                               class="inline-flex min-h-[48px] items-center justify-center rounded-xl border border-slate-200 px-4 text-sm font-black text-slate-800 transition-colors hover:bg-slate-50">
                                Quote checklist
                            </a>
                        </div>
                    </div>
                </div>

                <div class="mt-8 divide-y divide-slate-200 rounded-[1.75rem] border border-slate-200 bg-slate-50">
                    <div class="grid gap-3 p-5 md:grid-cols-[0.26fr_0.74fr]">
                        <p class="font-display text-xl font-black text-indigo-700">Before call</p>
                        <p class="text-sm leading-relaxed text-slate-700">Collect the reading, test duration, test location, ZIP, foundation clue, and deadline.</p>
                    </div>
                    <div class="grid gap-3 p-5 md:grid-cols-[0.26fr_0.74fr]">
                        <p class="font-display text-xl font-black text-indigo-700">During call</p>
                        <p class="text-sm leading-relaxed text-slate-700">Ask whether the quote is sub-slab, sump seal, crawl-space, fan replacement, commercial, or inspection-deadline driven.</p>
                    </div>
                    <div class="grid gap-3 p-5 md:grid-cols-[0.26fr_0.74fr]">
                        <p class="font-display text-xl font-black text-indigo-700">After call</p>
                        <p class="text-sm leading-relaxed text-slate-700">Add one quote signal after the contractor call: ZIP, result band, foundation, quote status, price, and scope clue only.</p>
                    </div>
                </div>
            </section>

            <section class="mt-16">
                <p class="text-xs font-bold uppercase tracking-[0.22em] text-slate-500">Decision packet</p>
                <h2 class="mt-2 font-display text-3xl font-black tracking-tight text-slate-950">What the client should leave with</h2>
                <div class="mt-6 divide-y divide-slate-200 rounded-[1.75rem] border border-slate-200 bg-white">
                    <div class="grid gap-3 p-5 md:grid-cols-[0.25fr_0.75fr]">
                        <p class="font-display text-2xl font-black text-indigo-700">Result</p>
                        <p class="text-sm leading-relaxed text-slate-700">The number, test context, and whether the result is no-test, borderline, 4.0+, or high.</p>
                    </div>
                    <div class="grid gap-3 p-5 md:grid-cols-[0.25fr_0.75fr]">
                        <p class="font-display text-2xl font-black text-indigo-700">Range</p>
                        <p class="text-sm leading-relaxed text-slate-700">The county cost range adjusted by foundation clue before anyone asks for an arbitrary credit.</p>
                    </div>
                    <div class="grid gap-3 p-5 md:grid-cols-[0.25fr_0.75fr]">
                        <p class="font-display text-2xl font-black text-indigo-700">Mechanism</p>
                        <p class="text-sm leading-relaxed text-slate-700">Repair, closing credit, price concession, escrow, retest, or buyer-managed mitigation after closing.</p>
                    </div>
                    <div class="grid gap-3 p-5 md:grid-cols-[0.25fr_0.75fr]">
                        <p class="font-display text-2xl font-black text-indigo-700">Proof</p>
                        <p class="text-sm leading-relaxed text-slate-700">A quote or seller-credit signal added to the ledger so future local estimates become less generic.</p>
                    </div>
                </div>
            </section>
        </main>
    `
)
