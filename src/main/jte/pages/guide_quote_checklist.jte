@import com.radonverdict.util.JsonLdUtils

!{
    final String seoTitle = "Radon Mitigation Quote Checklist: Questions Before You Hire";
    final String seoDescription = "Use this radon mitigation quote checklist before hiring a contractor: result band, foundation, system scope, fan, permit, warranty, retest, and quote red flags.";
}

@template.layout.main(
    title = seoTitle + " | RadonVerdict",
    canonicalUrl = "https://radonverdict.com/guides/radon-mitigation-quote-checklist",
    description = seoDescription,
    headContent = @`
        <script type="application/ld+json">
            {
                "@context": "https://schema.org",
                "@type": "WebPage",
                "name": $unsafe{JsonLdUtils.json(seoTitle)},
                "url": "https://radonverdict.com/guides/radon-mitigation-quote-checklist",
                "description": $unsafe{JsonLdUtils.json(seoDescription)},
                "inLanguage": "en-US",
                "about": [{
                    "@type": "Thing",
                    "name": "Radon mitigation quote"
                },{
                    "@type": "Thing",
                    "name": "Radon contractor questions"
                },{
                    "@type": "Thing",
                    "name": "Radon mitigation cost"
                }]
            }
        </script>
        <script type="application/ld+json">
            {
                "@context": "https://schema.org",
                "@type": "HowTo",
                "name": "How to compare radon mitigation quotes",
                "description": "A practical checklist for comparing radon mitigation quotes before hiring a contractor.",
                "step": [{
                    "@type": "HowToStep",
                    "name": "Confirm the reading and result band"
                },{
                    "@type": "HowToStep",
                    "name": "Identify foundation type and system scope"
                },{
                    "@type": "HowToStep",
                    "name": "Ask about fan, warranty, permit, and retest"
                },{
                    "@type": "HowToStep",
                    "name": "Compare final price against local cost context"
                },{
                    "@type": "HowToStep",
                    "name": "Add an anonymized quote signal"
                }]
            }
        </script>
        <script type="application/ld+json">
            {
                "@context": "https://schema.org",
                "@type": "FAQPage",
                "mainEntity": [{
                    "@type": "Question",
                    "name": "What should I ask before hiring a radon mitigation contractor?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "Ask what test result triggered the quote, what foundation type and suction method the quote assumes, what fan and warranty are included, whether permits or electrical work are included, and how the post-mitigation retest will be handled."
                    }
                },{
                    "@type": "Question",
                    "name": "What is a red flag in a radon mitigation quote?",
                    "acceptedAnswer": {
                        "@type": "Answer",
                        "text": "A quote is weak if it does not name the system scope, ignores foundation type, excludes obvious sump or crawl-space work, promises a result without a retest plan, or gives a price without explaining what is included."
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
                        <li class="text-white font-semibold" aria-current="page">Quote Checklist</li>
                    </ol>
                </nav>

                <div class="grid gap-10 lg:grid-cols-[1fr_0.88fr] lg:items-center">
                    <div>
                        <p class="text-xs font-bold uppercase tracking-[0.26em] text-cyan-200">Contractor quote checklist</p>
                        <h1 class="mt-5 font-display text-4xl font-black leading-tight tracking-tight text-white sm:text-6xl">
                            Ask better radon quote questions before you hire.
                        </h1>
                        <p class="mt-5 max-w-2xl text-lg font-semibold leading-relaxed text-slate-300">
                            Use this call script to compare radon mitigation quotes by result, foundation, scope, fan, permit, warranty, and retest plan.
                        </p>
                        <div class="mt-8 flex flex-col gap-3 sm:flex-row">
                            <a href="/radon-cost-calculator"
                               data-track-event="quote_checklist_cta_click"
                               data-track-label="local_cost"
                               class="inline-flex min-h-[52px] items-center justify-center rounded-xl bg-white px-5 text-sm font-black text-slate-950 transition-colors hover:bg-slate-100">
                                Open local cost first
                            </a>
                            <a href="/radon-quote-ledger#quote-checker"
                               data-track-event="quote_checklist_cta_click"
                               data-track-label="quote_checker"
                               class="inline-flex min-h-[52px] items-center justify-center rounded-xl border border-white/20 px-5 text-sm font-black text-white transition-colors hover:bg-white/10">
                                Check quote after the call
                            </a>
                        </div>
                    </div>

                    <div class="rounded-[1.75rem] border border-white/10 bg-white/10 p-5 shadow-2xl sm:p-6">
                        <p class="text-xs font-bold uppercase tracking-[0.22em] text-slate-400">Phone script</p>
                        <p class="mt-4 rounded-2xl bg-white p-4 text-sm font-semibold leading-relaxed text-slate-800">
                            I have a radon result of ___ pCi/L in ZIP _____. Before I compare prices, can you tell me what system scope your quote assumes, whether sump sealing or crawl-space work is included, what fan and warranty are included, and how the retest will be documented?
                        </p>
                        <div class="mt-4 grid gap-2 sm:grid-cols-2">
                            <span class="rounded-xl border border-white/10 bg-white/10 px-3 py-3 text-xs font-black text-white">Result band</span>
                            <span class="rounded-xl border border-white/10 bg-white/10 px-3 py-3 text-xs font-black text-white">Foundation</span>
                            <span class="rounded-xl border border-white/10 bg-white/10 px-3 py-3 text-xs font-black text-white">Scope</span>
                            <span class="rounded-xl border border-white/10 bg-white/10 px-3 py-3 text-xs font-black text-white">Retest proof</span>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <main class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-14 sm:py-16">
            <section class="grid gap-10 lg:grid-cols-[0.78fr_1.22fr]">
                <div>
                    <p class="text-xs font-bold uppercase tracking-[0.22em] text-slate-500">Seven checks</p>
                    <h2 class="mt-3 font-display text-3xl font-black tracking-tight text-slate-950">A strong quote names what it includes.</h2>
                    <p class="mt-3 text-sm leading-relaxed text-slate-600">
                        A cheap quote can be fine. A vague quote is the problem. Compare the scope before you compare the price.
                    </p>
                </div>
                <div class="divide-y divide-slate-200 rounded-[1.75rem] border border-slate-200 bg-white">
                    <div class="grid gap-3 p-5 md:grid-cols-[0.24fr_0.76fr]">
                        <p class="font-display text-2xl font-black text-cyan-700">01</p>
                        <p class="text-sm leading-relaxed text-slate-700"><span class="font-black text-slate-950">Result and test type:</span> short-term, long-term, continuous monitor, real estate test, and exact pCi/L result.</p>
                    </div>
                    <div class="grid gap-3 p-5 md:grid-cols-[0.24fr_0.76fr]">
                        <p class="font-display text-2xl font-black text-cyan-700">02</p>
                        <p class="text-sm leading-relaxed text-slate-700"><span class="font-black text-slate-950">Foundation:</span> basement, slab, crawl space, mixed foundation, sump pit, drain tile, or finished lower level.</p>
                    </div>
                    <div class="grid gap-3 p-5 md:grid-cols-[0.24fr_0.76fr]">
                        <p class="font-display text-2xl font-black text-cyan-700">03</p>
                        <p class="text-sm leading-relaxed text-slate-700"><span class="font-black text-slate-950">Suction method:</span> sub-slab, sub-membrane, drain-tile tie-in, multiple suction points, or passive-system activation.</p>
                    </div>
                    <div class="grid gap-3 p-5 md:grid-cols-[0.24fr_0.76fr]">
                        <p class="font-display text-2xl font-black text-cyan-700">04</p>
                        <p class="text-sm leading-relaxed text-slate-700"><span class="font-black text-slate-950">Fan and warranty:</span> fan model, expected noise, location, warranty length, and who handles a failed fan.</p>
                    </div>
                    <div class="grid gap-3 p-5 md:grid-cols-[0.24fr_0.76fr]">
                        <p class="font-display text-2xl font-black text-cyan-700">05</p>
                        <p class="text-sm leading-relaxed text-slate-700"><span class="font-black text-slate-950">Electrical and permit scope:</span> outlet, dedicated circuit, permit, exterior routing, roofline, and weatherproofing.</p>
                    </div>
                    <div class="grid gap-3 p-5 md:grid-cols-[0.24fr_0.76fr]">
                        <p class="font-display text-2xl font-black text-cyan-700">06</p>
                        <p class="text-sm leading-relaxed text-slate-700"><span class="font-black text-slate-950">Post-mitigation retest:</span> who retests, when it happens, what number is expected, and how the result is documented.</p>
                    </div>
                    <div class="grid gap-3 p-5 md:grid-cols-[0.24fr_0.76fr]">
                        <p class="font-display text-2xl font-black text-cyan-700">07</p>
                        <p class="text-sm leading-relaxed text-slate-700"><span class="font-black text-slate-950">Final price:</span> quoted price, final price if installed, exclusions, deposit, deadline, and payment trigger.</p>
                    </div>
                </div>
            </section>

            <section class="mt-16 border-y border-slate-200 py-10">
                <div class="grid gap-8 lg:grid-cols-[1fr_1fr]">
                    <div>
                        <p class="text-xs font-bold uppercase tracking-[0.22em] text-slate-500">Red flags</p>
                        <h2 class="mt-3 font-display text-3xl font-black tracking-tight text-slate-950">Do not compare quotes that describe different jobs.</h2>
                        <p class="mt-3 text-sm leading-relaxed text-slate-600">
                            One contractor may be pricing a simple sub-slab system. Another may be including sump sealing, electrical work, and a documented retest.
                        </p>
                    </div>
                    <div class="divide-y divide-slate-200 rounded-[1.75rem] border border-slate-200 bg-slate-50">
                        <p class="p-5 text-sm leading-relaxed text-slate-700"><span class="font-black text-slate-950">Vague scope:</span> "radon system" with no suction method, fan, routing, or sealing details.</p>
                        <p class="p-5 text-sm leading-relaxed text-slate-700"><span class="font-black text-slate-950">Missing retest plan:</span> no timeline for proving the system lowered the reading.</p>
                        <p class="p-5 text-sm leading-relaxed text-slate-700"><span class="font-black text-slate-950">Foundation ignored:</span> crawl-space or sump work treated like a standard basement job.</p>
                        <p class="p-5 text-sm leading-relaxed text-slate-700"><span class="font-black text-slate-950">Unclear exclusions:</span> electrical, permit, patching, fan warranty, or exterior routing left out.</p>
                    </div>
                </div>
            </section>

            <section class="mt-16 rounded-[1.75rem] border border-slate-200 bg-slate-950 p-5 text-white sm:p-6">
                <div class="grid gap-6 lg:grid-cols-[0.9fr_1.1fr] lg:items-center">
                    <div>
                        <p class="text-xs font-bold uppercase tracking-[0.22em] text-slate-400">After the call</p>
                        <h2 class="mt-3 font-display text-3xl font-black tracking-tight">Turn the quote into a local benchmark.</h2>
                        <p class="mt-3 text-sm leading-relaxed text-slate-300">
                            Remove names, phone numbers, exact addresses, and contractor contact details. The useful signal is ZIP, reading, foundation, scope clue, quote status, and price.
                        </p>
                    </div>
                    <div class="grid gap-3 sm:grid-cols-2">
                        <a href="/radon-quote-ledger#quote-checker"
                           data-track-event="quote_checklist_after_call_click"
                           data-track-label="quote_checker"
                           class="inline-flex min-h-[52px] items-center justify-center rounded-xl bg-white px-5 text-sm font-black text-slate-950 transition-colors hover:bg-slate-100">
                            Check and add quote
                        </a>
                        <a href="/guides/radon-inspection-toolkit"
                           data-track-event="quote_checklist_after_call_click"
                           data-track-label="inspection_toolkit"
                           class="inline-flex min-h-[52px] items-center justify-center rounded-xl border border-white/20 px-5 text-sm font-black text-white transition-colors hover:bg-white/10">
                            Open inspection toolkit
                        </a>
                    </div>
                </div>
            </section>
        </main>
    `
)
