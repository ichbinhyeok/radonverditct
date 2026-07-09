@import com.radonverdict.model.dto.QuoteLedgerSubmissionRequest
@import com.radonverdict.util.JsonLdUtils

@param QuoteLedgerSubmissionRequest quoteLedgerForm = null
@param String quoteLedgerSuccessMessage = null
@param String quoteLedgerErrorMessage = null

!{
    final String seoTitle = "Observed Radon Quote Ledger";
    final String seoDescription = "Share an anonymized radon mitigation quote, seller credit, or test-result signal so RadonVerdict can benchmark real local pricing against public data.";
}

@template.layout.main(
    title = seoTitle + " | RadonVerdict",
    canonicalUrl = "https://radonverdict.com/radon-quote-ledger",
    description = seoDescription,
    headContent = @`
        <script type="application/ld+json">
            {
                "@context": "https://schema.org",
                "@type": "WebPage",
                "name": $unsafe{JsonLdUtils.json(seoTitle)},
                "url": "https://radonverdict.com/radon-quote-ledger",
                "description": $unsafe{JsonLdUtils.json(seoDescription)},
                "inLanguage": "en-US",
                "about": [{
                    "@type": "Thing",
                    "name": "Radon mitigation quote benchmark"
                },{
                    "@type": "Thing",
                    "name": "Radon mitigation cost"
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
                        <li class="text-white font-semibold" aria-current="page">Quote Ledger</li>
                    </ol>
                </nav>

                <div class="grid gap-10 lg:grid-cols-[0.88fr_1.12fr] lg:items-start">
                    <div>
                        <p class="text-xs font-bold uppercase tracking-[0.26em] text-cyan-200">Observed quote ledger</p>
                        <h1 class="mt-5 font-display text-4xl font-black leading-tight tracking-tight text-white sm:text-6xl">
                            Real radon quotes beat generic averages.
                        </h1>
                        <p class="mt-5 max-w-2xl text-lg font-semibold leading-relaxed text-slate-300">
                            Add an anonymized quote, seller credit, or test-result signal. RadonVerdict uses these signals to compare model ranges against real county pricing.
                        </p>
                        <div class="mt-8 grid gap-3 sm:grid-cols-3">
                            <div class="border-t border-cyan-300 pt-3">
                                <p class="font-display text-3xl font-black text-white">ZIP</p>
                                <p class="mt-1 text-xs font-semibold uppercase tracking-wider text-slate-400">Routes to county</p>
                            </div>
                            <div class="border-t border-cyan-300 pt-3">
                                <p class="font-display text-3xl font-black text-white">Quote</p>
                                <p class="mt-1 text-xs font-semibold uppercase tracking-wider text-slate-400">Benchmarks price</p>
                            </div>
                            <div class="border-t border-cyan-300 pt-3">
                                <p class="font-display text-3xl font-black text-white">Result</p>
                                <p class="mt-1 text-xs font-semibold uppercase tracking-wider text-slate-400">Explains urgency</p>
                            </div>
                        </div>
                    </div>

                    <form action="/radon-quote-ledger" method="POST"
                          class="rounded-[1.75rem] border border-white/10 bg-white p-5 text-slate-950 shadow-2xl sm:p-6"
                          data-track-event="quote_ledger_form_view"
                          data-track-label="observed_quote_ledger">
                        <div class="flex flex-col gap-3 sm:flex-row sm:items-start sm:justify-between">
                            <div>
                                <p class="text-xs font-bold uppercase tracking-[0.22em] text-slate-500">Add one signal</p>
                                <h2 class="mt-2 font-display text-2xl font-black tracking-tight text-slate-950">Anonymized quote or credit</h2>
                            </div>
                            <a href="/methodology" class="text-sm font-bold text-indigo-700 hover:underline">How data is used</a>
                        </div>

                        @if(quoteLedgerSuccessMessage != null)
                            <div class="mt-5 rounded-xl border border-emerald-200 bg-emerald-50 px-4 py-3 text-sm font-bold text-emerald-800">
                                ${quoteLedgerSuccessMessage}
                            </div>
                        @endif
                        @if(quoteLedgerErrorMessage != null)
                            <div class="mt-5 rounded-xl border border-rose-200 bg-rose-50 px-4 py-3 text-sm font-bold text-rose-800">
                                ${quoteLedgerErrorMessage}
                            </div>
                        @endif

                        <div class="mt-6 grid gap-4 sm:grid-cols-2">
                            <div>
                                <label for="ledgerZipCode" class="block text-sm font-black text-slate-800">Property ZIP</label>
                                <input id="ledgerZipCode" name="zipCode" required pattern="[0-9]{5}" inputmode="numeric" autocomplete="postal-code"
                                       placeholder="22030"
                                       class="mt-2 block w-full rounded-xl border border-slate-300 px-4 py-3 text-base font-semibold text-slate-950 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">
                            </div>
                            <div>
                                <label for="ledgerRadonReading" class="block text-sm font-black text-slate-800">Reading, if known</label>
                                <input id="ledgerRadonReading" name="radonReadingPciL" inputmode="decimal" pattern="[0-9]{1,2}(\\.[0-9]{1,2})?"
                                       placeholder="4.2"
                                       class="mt-2 block w-full rounded-xl border border-slate-300 px-4 py-3 text-base font-semibold text-slate-950 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">
                            </div>
                        </div>

                        <fieldset class="mt-5">
                            <legend class="text-sm font-black text-slate-800">Your role</legend>
                            <div class="mt-2 grid gap-2 sm:grid-cols-3">
                                <label class="cursor-pointer rounded-xl border border-slate-200 bg-slate-50 px-3 py-3 text-sm font-bold text-slate-700 has-[:checked]:border-indigo-500 has-[:checked]:bg-indigo-50 has-[:checked]:text-indigo-800">
                                    <input type="radio" name="role" value="homeowner" checked class="sr-only"> Homeowner
                                </label>
                                <label class="cursor-pointer rounded-xl border border-slate-200 bg-slate-50 px-3 py-3 text-sm font-bold text-slate-700 has-[:checked]:border-indigo-500 has-[:checked]:bg-indigo-50 has-[:checked]:text-indigo-800">
                                    <input type="radio" name="role" value="buyer" class="sr-only"> Buyer
                                </label>
                                <label class="cursor-pointer rounded-xl border border-slate-200 bg-slate-50 px-3 py-3 text-sm font-bold text-slate-700 has-[:checked]:border-indigo-500 has-[:checked]:bg-indigo-50 has-[:checked]:text-indigo-800">
                                    <input type="radio" name="role" value="seller" class="sr-only"> Seller
                                </label>
                                <label class="cursor-pointer rounded-xl border border-slate-200 bg-slate-50 px-3 py-3 text-sm font-bold text-slate-700 has-[:checked]:border-indigo-500 has-[:checked]:bg-indigo-50 has-[:checked]:text-indigo-800">
                                    <input type="radio" name="role" value="agent" class="sr-only"> Agent
                                </label>
                                <label class="cursor-pointer rounded-xl border border-slate-200 bg-slate-50 px-3 py-3 text-sm font-bold text-slate-700 has-[:checked]:border-indigo-500 has-[:checked]:bg-indigo-50 has-[:checked]:text-indigo-800">
                                    <input type="radio" name="role" value="inspector" class="sr-only"> Inspector
                                </label>
                                <label class="cursor-pointer rounded-xl border border-slate-200 bg-slate-50 px-3 py-3 text-sm font-bold text-slate-700 has-[:checked]:border-indigo-500 has-[:checked]:bg-indigo-50 has-[:checked]:text-indigo-800">
                                    <input type="radio" name="role" value="other" class="sr-only"> Other
                                </label>
                            </div>
                        </fieldset>

                        <div class="mt-5 grid gap-4 sm:grid-cols-2">
                            <div>
                                <label for="ledgerResultBand" class="block text-sm font-black text-slate-800">Result band</label>
                                <select id="ledgerResultBand" name="resultBand" required class="mt-2 block w-full rounded-xl border border-slate-300 px-4 py-3 text-base font-semibold text-slate-950 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">
                                    <option value="above_4" selected>4.0+ pCi/L</option>
                                    <option value="above_8">8.0+ pCi/L</option>
                                    <option value="between_2_and_4">2.0-3.9 pCi/L</option>
                                    <option value="under_2">Under 2.0 pCi/L</option>
                                    <option value="not_tested">Not tested yet</option>
                                    <option value="unknown">Unknown</option>
                                </select>
                            </div>
                            <div>
                                <label for="ledgerFoundation" class="block text-sm font-black text-slate-800">Foundation</label>
                                <select id="ledgerFoundation" name="foundationType" required class="mt-2 block w-full rounded-xl border border-slate-300 px-4 py-3 text-base font-semibold text-slate-950 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">
                                    <option value="basement" selected>Basement</option>
                                    <option value="slab">Slab</option>
                                    <option value="crawlspace">Crawl space</option>
                                    <option value="mixed">Mixed</option>
                                    <option value="unknown">Unknown</option>
                                </select>
                            </div>
                        </div>

                        <div class="mt-5 grid gap-4 sm:grid-cols-3">
                            <div>
                                <label for="ledgerQuoteStatus" class="block text-sm font-black text-slate-800">Status</label>
                                <select id="ledgerQuoteStatus" name="quoteStatus" required class="mt-2 block w-full rounded-xl border border-slate-300 px-4 py-3 text-base font-semibold text-slate-950 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">
                                    <option value="quoted" selected>Quoted</option>
                                    <option value="paid">Paid install</option>
                                    <option value="seller_credit">Seller credit</option>
                                    <option value="declined">Declined quote</option>
                                    <option value="planning">Planning only</option>
                                </select>
                            </div>
                            <div>
                                <label for="ledgerQuotedPrice" class="block text-sm font-black text-slate-800">Quoted price</label>
                                <input id="ledgerQuotedPrice" name="quotedPrice" inputmode="numeric" pattern="[0-9]{2,6}" placeholder="1800"
                                       class="mt-2 block w-full rounded-xl border border-slate-300 px-4 py-3 text-base font-semibold text-slate-950 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">
                            </div>
                            <div>
                                <label for="ledgerFinalPrice" class="block text-sm font-black text-slate-800">Final price</label>
                                <input id="ledgerFinalPrice" name="finalPrice" inputmode="numeric" pattern="[0-9]{2,6}" placeholder="2000"
                                       class="mt-2 block w-full rounded-xl border border-slate-300 px-4 py-3 text-base font-semibold text-slate-950 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">
                            </div>
                        </div>

                        <div class="mt-5 grid gap-4 sm:grid-cols-2">
                            <div>
                                <label for="ledgerScope" class="block text-sm font-black text-slate-800">Scope clue</label>
                                <input id="ledgerScope" name="systemScope" maxlength="80" placeholder="sub-slab, sump seal, fan replacement"
                                       class="mt-2 block w-full rounded-xl border border-slate-300 px-4 py-3 text-base font-semibold text-slate-950 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">
                            </div>
                            <div>
                                <label for="ledgerTimeline" class="block text-sm font-black text-slate-800">Timeline clue</label>
                                <input id="ledgerTimeline" name="timeline" maxlength="80" placeholder="inspection deadline, pre-listing, urgent"
                                       class="mt-2 block w-full rounded-xl border border-slate-300 px-4 py-3 text-base font-semibold text-slate-950 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">
                            </div>
                        </div>

                        <div class="mt-5">
                            <label for="ledgerNotes" class="block text-sm font-black text-slate-800">Optional notes</label>
                            <textarea id="ledgerNotes" name="notes" maxlength="1200" rows="3" placeholder="Anything that changed the quote: crawl-space access, finished basement, long pipe run, roofline, permit, seller credit, retest result."
                                      class="mt-2 block w-full rounded-xl border border-slate-300 px-4 py-3 text-base font-semibold text-slate-950 shadow-sm focus:border-indigo-500 focus:ring-indigo-500"></textarea>
                        </div>

                        <div class="mt-5">
                            <label for="ledgerEmail" class="block text-sm font-black text-slate-800">Email, optional</label>
                            <input id="ledgerEmail" name="email" type="email" autocomplete="email" placeholder="Only if you want follow-up"
                                   class="mt-2 block w-full rounded-xl border border-slate-300 px-4 py-3 text-base font-semibold text-slate-950 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">
                        </div>

                        <div class="hidden" aria-hidden="true">
                            <label for="ledgerAdditionalPhone">Additional phone</label>
                            <input id="ledgerAdditionalPhone" name="additionalPhone" tabindex="-1" autocomplete="off">
                        </div>

                        <label class="mt-5 flex gap-3 rounded-xl border border-slate-200 bg-slate-50 p-4 text-sm leading-relaxed text-slate-700">
                            <input type="checkbox" name="consentAccepted" value="true" required class="mt-1 rounded border-slate-300 text-indigo-600 focus:ring-indigo-500">
                            <span>I understand this is not medical, legal, or contractor advice. I am sharing anonymized pricing context so RadonVerdict can improve local benchmarks.</span>
                        </label>

                        <button type="submit"
                                data-track-event="quote_ledger_submit_click"
                                data-track-label="observed_quote_ledger"
                                class="mt-5 inline-flex min-h-[52px] w-full items-center justify-center rounded-xl bg-slate-950 px-5 text-sm font-black text-white transition-colors hover:bg-slate-800">
                            Add quote signal
                        </button>
                    </form>
                </div>
            </div>
        </section>

        <main class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-14 sm:py-16">
            <section class="grid gap-8 lg:grid-cols-[0.8fr_1.2fr]">
                <div>
                    <p class="text-xs font-bold uppercase tracking-[0.22em] text-slate-500">Why this matters</p>
                    <h2 class="mt-3 font-display text-3xl font-black tracking-tight text-slate-950">The model gets stronger when real quotes arrive.</h2>
                    <p class="mt-3 text-sm leading-relaxed text-slate-600">
                        Public radon data explains risk. Housing and cost inputs explain the estimate. Observed quotes tell us where real projects are above, below, or outside the model range.
                    </p>
                </div>
                <div class="divide-y divide-slate-200 rounded-[1.75rem] border border-slate-200 bg-white">
                    <div class="grid gap-3 p-5 md:grid-cols-[0.28fr_0.72fr]">
                        <p class="font-display text-2xl font-black text-indigo-700">01</p>
                        <div>
                            <h3 class="text-lg font-black text-slate-950">County benchmark</h3>
                            <p class="mt-1 text-sm leading-relaxed text-slate-600">ZIP routes the quote to the county so local cost ranges can learn from real projects without exposing a full address.</p>
                        </div>
                    </div>
                    <div class="grid gap-3 p-5 md:grid-cols-[0.28fr_0.72fr]">
                        <p class="font-display text-2xl font-black text-indigo-700">02</p>
                        <div>
                            <h3 class="text-lg font-black text-slate-950">Foundation context</h3>
                            <p class="mt-1 text-sm leading-relaxed text-slate-600">Basement, slab, crawl-space, sump sealing, and fan replacement are separated because they do not price the same.</p>
                        </div>
                    </div>
                    <div class="grid gap-3 p-5 md:grid-cols-[0.28fr_0.72fr]">
                        <p class="font-display text-2xl font-black text-indigo-700">03</p>
                        <div>
                            <h3 class="text-lg font-black text-slate-950">Deal pressure</h3>
                            <p class="mt-1 text-sm leading-relaxed text-slate-600">A failed inspection quote, a seller credit, and a planned homeowner install are different decisions. The ledger keeps that difference visible.</p>
                        </div>
                    </div>
                </div>
            </section>

            <section class="mt-16 grid gap-4 md:grid-cols-3">
                <a href="/radon-cost-calculator" class="rounded-2xl border border-slate-200 bg-white p-5 transition-colors hover:border-slate-400 hover:bg-slate-50">
                    <p class="text-xs font-black uppercase tracking-wider text-slate-500">Need your estimate?</p>
                    <h3 class="mt-3 text-xl font-black text-slate-950">Open the ZIP cost path</h3>
                    <p class="mt-2 text-sm leading-relaxed text-slate-600">Use the current model before comparing contractor quotes.</p>
                </a>
                <a href="/guides/radon-inspection-toolkit" class="rounded-2xl border border-slate-200 bg-white p-5 transition-colors hover:border-slate-400 hover:bg-slate-50">
                    <p class="text-xs font-black uppercase tracking-wider text-slate-500">Agent or inspector?</p>
                    <h3 class="mt-3 text-xl font-black text-slate-950">Use the failed inspection toolkit</h3>
                    <p class="mt-2 text-sm leading-relaxed text-slate-600">Share a clean decision path with buyers and sellers.</p>
                </a>
                <a href="/radon-data-sources" class="rounded-2xl border border-slate-200 bg-white p-5 transition-colors hover:border-slate-400 hover:bg-slate-50">
                    <p class="text-xs font-black uppercase tracking-wider text-slate-500">Source policy</p>
                    <h3 class="mt-3 text-xl font-black text-slate-950">See the public data layer</h3>
                    <p class="mt-2 text-sm leading-relaxed text-slate-600">Observed quotes are kept separate from official radon evidence.</p>
                </a>
            </section>
        </main>
    `
)
