@import com.radonverdict.model.dto.QuoteLedgerSubmissionRequest
@import com.radonverdict.model.dto.QuoteLedgerBenchmarkSnapshot
@import com.radonverdict.model.dto.QuoteLedgerBenchmarkRow
@import com.radonverdict.util.JsonLdUtils

@param QuoteLedgerSubmissionRequest quoteLedgerForm = null
@param String quoteLedgerSuccessMessage = null
@param String quoteLedgerErrorMessage = null
@param QuoteLedgerBenchmarkSnapshot quoteBenchmark = null

!{
    final String seoTitle = "Observed Radon Quote Ledger";
    final String seoDescription = "Share an anonymized radon mitigation quote, seller credit, or test-result signal so RadonVerdict can benchmark real local pricing against public data.";
    final boolean hasQuoteBenchmark = quoteBenchmark != null && quoteBenchmark.hasRows();
    final QuoteLedgerSubmissionRequest form = quoteLedgerForm == null ? new QuoteLedgerSubmissionRequest() : quoteLedgerForm;
    final String formZipCode = form.getZipCode() == null ? "" : form.getZipCode();
    final String formRadonReadingPciL = form.getRadonReadingPciL() == null ? "" : form.getRadonReadingPciL();
    final String formRole = form.getRole() == null || form.getRole().isBlank() ? "homeowner" : form.getRole();
    final String formResultBand = form.getResultBand() == null || form.getResultBand().isBlank() ? "above_4" : form.getResultBand();
    final String formFoundationType = form.getFoundationType() == null || form.getFoundationType().isBlank() ? "basement" : form.getFoundationType();
    final String formQuoteStatus = form.getQuoteStatus() == null || form.getQuoteStatus().isBlank() ? "quoted" : form.getQuoteStatus();
    final String formQuotedPrice = form.getQuotedPrice() == null ? "" : form.getQuotedPrice();
    final String formFinalPrice = form.getFinalPrice() == null ? "" : form.getFinalPrice();
    final String formSystemScope = form.getSystemScope() == null ? "" : form.getSystemScope();
    final String formTimeline = form.getTimeline() == null ? "" : form.getTimeline();
    final String formEmail = form.getEmail() == null ? "" : form.getEmail();
    final String formNotes = form.getNotes() == null ? "" : form.getNotes();
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
        <script type="application/ld+json">
            {
                "@context": "https://schema.org",
                "@type": "Dataset",
                "name": "RadonVerdict observed radon quote ledger",
                "url": "https://radonverdict.com/radon-quote-ledger",
                "description": "An anonymized intake ledger for radon mitigation quotes, seller credits, result bands, foundation types, and ZIP-routed county benchmarks.",
                "creator": {
                    "@type": "Organization",
                    "name": "RadonVerdict",
                    "url": "https://radonverdict.com/"
                },
                "isAccessibleForFree": true,
                "measurementTechnique": "User-submitted anonymized quote and credit signals validated against ZIP-to-county routing.",
                "distribution": {
                    "@type": "DataDownload",
                    "encodingFormat": "text/csv",
                    "contentUrl": "https://radonverdict.com/radon-quote-ledger/benchmark.csv"
                },
                "variableMeasured": [{
                    "@type": "PropertyValue",
                    "name": "ZIP code"
                },{
                    "@type": "PropertyValue",
                    "name": "Radon reading pCi/L"
                },{
                    "@type": "PropertyValue",
                    "name": "Foundation type"
                },{
                    "@type": "PropertyValue",
                    "name": "Quote status"
                },{
                    "@type": "PropertyValue",
                    "name": "Quoted or final price"
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
                            Add an anonymized quote, seller credit, or test-result signal. RadonVerdict also folds in anonymized lead-planning signals without exposing contact details.
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

                    <form id="quoteLedgerForm" action="/radon-quote-ledger" method="POST"
                          class="rounded-[1.75rem] border border-white/10 bg-white p-5 text-slate-950 shadow-2xl sm:p-6"
                          data-track-impression="quote_ledger_form_view"
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
                                       value="${formZipCode}"
                                       class="mt-2 block w-full rounded-xl border border-slate-300 px-4 py-3 text-base font-semibold text-slate-950 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">
                            </div>
                            <div>
                                <label for="ledgerRadonReading" class="block text-sm font-black text-slate-800">Reading, if known</label>
                                <input id="ledgerRadonReading" name="radonReadingPciL" inputmode="decimal" pattern="[0-9]{1,2}(\.[0-9]{1,2})?"
                                       placeholder="4.2"
                                       value="${formRadonReadingPciL}"
                                       class="mt-2 block w-full rounded-xl border border-slate-300 px-4 py-3 text-base font-semibold text-slate-950 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">
                            </div>
                        </div>

                        <fieldset class="mt-5">
                            <legend class="text-sm font-black text-slate-800">Your role</legend>
                            <div class="mt-2 grid gap-2 sm:grid-cols-3">
                                <label class="cursor-pointer rounded-xl border border-slate-200 bg-slate-50 px-3 py-3 text-sm font-bold text-slate-700 has-[:checked]:border-indigo-500 has-[:checked]:bg-indigo-50 has-[:checked]:text-indigo-800">
                                    <input type="radio" name="role" value="homeowner" checked="${"homeowner".equals(formRole)}" class="sr-only"> Homeowner
                                </label>
                                <label class="cursor-pointer rounded-xl border border-slate-200 bg-slate-50 px-3 py-3 text-sm font-bold text-slate-700 has-[:checked]:border-indigo-500 has-[:checked]:bg-indigo-50 has-[:checked]:text-indigo-800">
                                    <input type="radio" name="role" value="buyer" checked="${"buyer".equals(formRole)}" class="sr-only"> Buyer
                                </label>
                                <label class="cursor-pointer rounded-xl border border-slate-200 bg-slate-50 px-3 py-3 text-sm font-bold text-slate-700 has-[:checked]:border-indigo-500 has-[:checked]:bg-indigo-50 has-[:checked]:text-indigo-800">
                                    <input type="radio" name="role" value="seller" checked="${"seller".equals(formRole)}" class="sr-only"> Seller
                                </label>
                                <label class="cursor-pointer rounded-xl border border-slate-200 bg-slate-50 px-3 py-3 text-sm font-bold text-slate-700 has-[:checked]:border-indigo-500 has-[:checked]:bg-indigo-50 has-[:checked]:text-indigo-800">
                                    <input type="radio" name="role" value="agent" checked="${"agent".equals(formRole)}" class="sr-only"> Agent
                                </label>
                                <label class="cursor-pointer rounded-xl border border-slate-200 bg-slate-50 px-3 py-3 text-sm font-bold text-slate-700 has-[:checked]:border-indigo-500 has-[:checked]:bg-indigo-50 has-[:checked]:text-indigo-800">
                                    <input type="radio" name="role" value="inspector" checked="${"inspector".equals(formRole)}" class="sr-only"> Inspector
                                </label>
                                <label class="cursor-pointer rounded-xl border border-slate-200 bg-slate-50 px-3 py-3 text-sm font-bold text-slate-700 has-[:checked]:border-indigo-500 has-[:checked]:bg-indigo-50 has-[:checked]:text-indigo-800">
                                    <input type="radio" name="role" value="mitigator" checked="${"mitigator".equals(formRole)}" class="sr-only"> Mitigator
                                </label>
                                <label class="cursor-pointer rounded-xl border border-slate-200 bg-slate-50 px-3 py-3 text-sm font-bold text-slate-700 has-[:checked]:border-indigo-500 has-[:checked]:bg-indigo-50 has-[:checked]:text-indigo-800">
                                    <input type="radio" name="role" value="other" checked="${"other".equals(formRole)}" class="sr-only"> Other
                                </label>
                            </div>
                        </fieldset>

                        <div class="mt-5 grid gap-4 sm:grid-cols-2">
                            <div>
                                <label for="ledgerResultBand" class="block text-sm font-black text-slate-800">Result band</label>
                                <select id="ledgerResultBand" name="resultBand" required class="mt-2 block w-full rounded-xl border border-slate-300 px-4 py-3 text-base font-semibold text-slate-950 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">
                                    <option value="above_4" selected="${"above_4".equals(formResultBand)}">4.0+ pCi/L</option>
                                    <option value="above_8" selected="${"above_8".equals(formResultBand)}">8.0+ pCi/L</option>
                                    <option value="between_2_and_4" selected="${"between_2_and_4".equals(formResultBand)}">2.0-3.9 pCi/L</option>
                                    <option value="under_2" selected="${"under_2".equals(formResultBand)}">Under 2.0 pCi/L</option>
                                    <option value="not_tested" selected="${"not_tested".equals(formResultBand)}">Not tested yet</option>
                                    <option value="unknown" selected="${"unknown".equals(formResultBand)}">Unknown</option>
                                </select>
                            </div>
                            <div>
                                <label for="ledgerFoundation" class="block text-sm font-black text-slate-800">Foundation</label>
                                <select id="ledgerFoundation" name="foundationType" required class="mt-2 block w-full rounded-xl border border-slate-300 px-4 py-3 text-base font-semibold text-slate-950 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">
                                    <option value="basement" selected="${"basement".equals(formFoundationType)}">Basement</option>
                                    <option value="slab" selected="${"slab".equals(formFoundationType)}">Slab</option>
                                    <option value="crawlspace" selected="${"crawlspace".equals(formFoundationType)}">Crawl space</option>
                                    <option value="mixed" selected="${"mixed".equals(formFoundationType)}">Mixed</option>
                                    <option value="unknown" selected="${"unknown".equals(formFoundationType)}">Unknown</option>
                                </select>
                            </div>
                        </div>

                        <div class="mt-5 grid gap-4 sm:grid-cols-3">
                            <div>
                                <label for="ledgerQuoteStatus" class="block text-sm font-black text-slate-800">Status</label>
                                <select id="ledgerQuoteStatus" name="quoteStatus" required class="mt-2 block w-full rounded-xl border border-slate-300 px-4 py-3 text-base font-semibold text-slate-950 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">
                                    <option value="quoted" selected="${"quoted".equals(formQuoteStatus)}">Quoted</option>
                                    <option value="paid" selected="${"paid".equals(formQuoteStatus)}">Paid install</option>
                                    <option value="seller_credit" selected="${"seller_credit".equals(formQuoteStatus)}">Seller credit</option>
                                    <option value="declined" selected="${"declined".equals(formQuoteStatus)}">Declined quote</option>
                                    <option value="planning" selected="${"planning".equals(formQuoteStatus)}">Planning only</option>
                                </select>
                            </div>
                            <div>
                                <label for="ledgerQuotedPrice" class="block text-sm font-black text-slate-800">Quoted price</label>
                                <input id="ledgerQuotedPrice" name="quotedPrice" inputmode="numeric" pattern="[0-9]{2,6}" placeholder="1800"
                                       value="${formQuotedPrice}"
                                       class="mt-2 block w-full rounded-xl border border-slate-300 px-4 py-3 text-base font-semibold text-slate-950 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">
                            </div>
                            <div>
                                <label for="ledgerFinalPrice" class="block text-sm font-black text-slate-800">Final price</label>
                                <input id="ledgerFinalPrice" name="finalPrice" inputmode="numeric" pattern="[0-9]{2,6}" placeholder="2000"
                                       value="${formFinalPrice}"
                                       class="mt-2 block w-full rounded-xl border border-slate-300 px-4 py-3 text-base font-semibold text-slate-950 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">
                            </div>
                        </div>

                        <div class="mt-5 grid gap-4 sm:grid-cols-2">
                            <div>
                                <label for="ledgerScope" class="block text-sm font-black text-slate-800">Scope clue</label>
                                <input id="ledgerScope" name="systemScope" maxlength="80" placeholder="sub-slab, sump seal, fan replacement"
                                       value="${formSystemScope}"
                                       class="mt-2 block w-full rounded-xl border border-slate-300 px-4 py-3 text-base font-semibold text-slate-950 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">
                            </div>
                            <div>
                                <label for="ledgerTimeline" class="block text-sm font-black text-slate-800">Timeline clue</label>
                                <input id="ledgerTimeline" name="timeline" maxlength="80" placeholder="inspection deadline, pre-listing, urgent"
                                       value="${formTimeline}"
                                       class="mt-2 block w-full rounded-xl border border-slate-300 px-4 py-3 text-base font-semibold text-slate-950 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">
                            </div>
                        </div>

                        <div class="mt-5">
                            <label for="ledgerNotes" class="block text-sm font-black text-slate-800">Optional notes</label>
                            <textarea id="ledgerNotes" name="notes" maxlength="1200" rows="3" placeholder="Anything that changed the quote: crawl-space access, finished basement, long pipe run, roofline, permit, seller credit, retest result."
                                      class="mt-2 block w-full rounded-xl border border-slate-300 px-4 py-3 text-base font-semibold text-slate-950 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">${formNotes}</textarea>
                        </div>

                        <div class="mt-5">
                            <label for="ledgerEmail" class="block text-sm font-black text-slate-800">Email, optional</label>
                            <input id="ledgerEmail" name="email" type="email" autocomplete="email" placeholder="Only if you want follow-up"
                                   value="${formEmail}"
                                   class="mt-2 block w-full rounded-xl border border-slate-300 px-4 py-3 text-base font-semibold text-slate-950 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">
                        </div>

                        <div class="hidden" aria-hidden="true">
                            <label for="ledgerAdditionalPhone">Additional phone</label>
                            <input id="ledgerAdditionalPhone" name="additionalPhone" tabindex="-1" autocomplete="off">
                        </div>

                        <label class="mt-5 flex gap-3 rounded-xl border border-slate-200 bg-slate-50 p-4 text-sm leading-relaxed text-slate-700">
                            <input type="checkbox" name="consentAccepted" value="true" required class="mt-1 h-5 w-5 shrink-0 rounded border-slate-300 text-indigo-600 focus:ring-indigo-500">
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
            <section class="mb-14 rounded-[1.75rem] border border-indigo-200 bg-indigo-50 p-5 sm:p-6">
                <div class="grid gap-6 lg:grid-cols-[0.82fr_1.18fr] lg:items-start">
                    <div>
                        <p class="text-xs font-bold uppercase tracking-[0.22em] text-indigo-700">Priority collection gaps</p>
                        <h2 class="mt-3 font-display text-3xl font-black tracking-tight text-slate-950">The next useful quote is local, not generic.</h2>
                        <p class="mt-3 text-sm leading-relaxed text-indigo-950">
                            The next useful quote is local, not generic. This ledger prioritizes missing local scope signals so the planning ranges can improve with real quotes.
                        </p>
                    </div>
                    <div class="grid gap-3 sm:grid-cols-2">
                        <a href="/radon-levels/new-york/ulster-county" class="rounded-2xl border border-indigo-200 bg-white p-4 transition-colors hover:bg-indigo-50">
                            <p class="text-sm font-black text-slate-950">Ulster County, NY</p>
                            <p class="mt-1 text-sm leading-relaxed text-slate-600">Testing or mitigation-service quote after a confirmed result.</p>
                        </a>
                        <a href="/radon-levels/california/los-angeles-county" class="rounded-2xl border border-indigo-200 bg-white p-4 transition-colors hover:bg-indigo-50">
                            <p class="text-sm font-black text-slate-950">Los Angeles County, CA</p>
                            <p class="mt-1 text-sm leading-relaxed text-slate-600">Commercial, multifamily, or testing-scope quote signal.</p>
                        </a>
                        <a href="/radon-levels/colorado/boulder-county" class="rounded-2xl border border-indigo-200 bg-white p-4 transition-colors hover:bg-indigo-50">
                            <p class="text-sm font-black text-slate-950">Boulder County, CO</p>
                            <p class="mt-1 text-sm leading-relaxed text-slate-600">Mitigation quote with fan, route, warranty, and retest language.</p>
                        </a>
                        <a href="/radon-levels/virginia/loudoun-county" class="rounded-2xl border border-indigo-200 bg-white p-4 transition-colors hover:bg-indigo-50">
                            <p class="text-sm font-black text-slate-950">Loudoun County, VA</p>
                            <p class="mt-1 text-sm leading-relaxed text-slate-600">ZIP-cost, seller-credit, or failed-inspection quote signal.</p>
                        </a>
                        <a href="/radon-levels/missouri/st-louis-county" class="rounded-2xl border border-indigo-200 bg-white p-4 transition-colors hover:bg-indigo-50 sm:col-span-2">
                            <p class="text-sm font-black text-slate-950">St. Louis County, MO</p>
                            <p class="mt-1 text-sm leading-relaxed text-slate-600">Missouri evidence-backed quote signal, especially 4.0+ basement or mixed-foundation jobs.</p>
                        </a>
                    </div>
                </div>
            </section>

            <section id="quote-checker"
                     class="grid gap-8 lg:grid-cols-[0.92fr_1.08fr] lg:items-start"
                     data-track-impression="quote_checker_view"
                     data-track-label="quote_screening_tool">
                <div>
                    <p class="text-xs font-bold uppercase tracking-[0.22em] text-slate-500">Quote screening tool</p>
                    <h2 class="mt-3 font-display text-3xl font-black tracking-tight text-slate-950">Is this radon quote fair?</h2>
                    <p class="mt-3 text-sm leading-relaxed text-slate-600">
                        Enter the number you were quoted and the scope details the contractor included. This does not replace a local bid review, but it catches the usual reasons a radon quote is hard to compare.
                    </p>
                    <div class="mt-6 grid gap-3 sm:grid-cols-3">
                        <div class="border-l-4 border-slate-950 bg-slate-50 px-4 py-3">
                            <p class="text-2xl font-black text-slate-950">@if(quoteBenchmark != null)${quoteBenchmark.getTotalSignalCount()}@else 0@endif</p>
                            <p class="mt-1 text-xs font-bold uppercase tracking-wider text-slate-500">Total signals</p>
                        </div>
                        <div class="border-l-4 border-indigo-500 bg-indigo-50 px-4 py-3">
                            <p class="text-2xl font-black text-slate-950">@if(quoteBenchmark != null)${quoteBenchmark.getPricedSignalCount()}@else 0@endif</p>
                            <p class="mt-1 text-xs font-bold uppercase tracking-wider text-slate-500">Priced signals</p>
                        </div>
                        <div class="border-l-4 border-emerald-500 bg-emerald-50 px-4 py-3">
                            <p class="text-2xl font-black text-slate-950">@if(quoteBenchmark != null)${quoteBenchmark.getPublicBenchmarkCount()}@else 0@endif</p>
                            <p class="mt-1 text-xs font-bold uppercase tracking-wider text-slate-500">Public ranges</p>
                        </div>
                    </div>
                </div>

                <div data-quote-checker class="rounded-[1.5rem] border border-slate-200 bg-white p-5 shadow-sm">
                    <div class="grid gap-4 sm:grid-cols-3">
                        <div>
                            <label for="quoteCheckerPrice" class="block text-sm font-black text-slate-800">Quoted price</label>
                            <input id="quoteCheckerPrice" type="number" min="0" step="50" inputmode="numeric" placeholder="2100"
                                   class="mt-2 block w-full rounded-xl border border-slate-300 px-4 py-3 text-base font-semibold text-slate-950 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">
                        </div>
                        <div>
                            <label for="quoteCheckerFoundation" class="block text-sm font-black text-slate-800">Foundation</label>
                            <select id="quoteCheckerFoundation" class="mt-2 block w-full rounded-xl border border-slate-300 px-4 py-3 text-base font-semibold text-slate-950 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">
                                <option value="basement" selected>Basement</option>
                                <option value="slab">Slab</option>
                                <option value="crawlspace">Crawl space</option>
                                <option value="mixed">Mixed</option>
                                <option value="unknown">Unknown</option>
                            </select>
                        </div>
                        <div>
                            <label for="quoteCheckerResult" class="block text-sm font-black text-slate-800">Result band</label>
                            <select id="quoteCheckerResult" class="mt-2 block w-full rounded-xl border border-slate-300 px-4 py-3 text-base font-semibold text-slate-950 shadow-sm focus:border-indigo-500 focus:ring-indigo-500">
                                <option value="above_4" selected>4.0+ pCi/L</option>
                                <option value="above_8">8.0+ pCi/L</option>
                                <option value="between_2_and_4">2.0-3.9 pCi/L</option>
                                <option value="not_tested">Not tested yet</option>
                                <option value="unknown">Unknown</option>
                            </select>
                        </div>
                    </div>

                    <fieldset class="mt-5">
                        <legend class="text-sm font-black text-slate-800">Included in the written quote</legend>
                        <div class="mt-3 grid gap-2 sm:grid-cols-2">
                            <label class="flex min-h-[52px] cursor-pointer items-center gap-3 rounded-xl border border-slate-200 bg-slate-50 px-3 py-2 text-sm font-bold text-slate-700 has-[:checked]:border-emerald-500 has-[:checked]:bg-emerald-50 has-[:checked]:text-emerald-900">
                                <input type="checkbox" data-quote-check="retest" class="rounded border-slate-300 text-emerald-600 focus:ring-emerald-500"> Post-mitigation retest
                            </label>
                            <label class="flex min-h-[52px] cursor-pointer items-center gap-3 rounded-xl border border-slate-200 bg-slate-50 px-3 py-2 text-sm font-bold text-slate-700 has-[:checked]:border-emerald-500 has-[:checked]:bg-emerald-50 has-[:checked]:text-emerald-900">
                                <input type="checkbox" data-quote-check="warranty" class="rounded border-slate-300 text-emerald-600 focus:ring-emerald-500"> Fan model and warranty
                            </label>
                            <label class="flex min-h-[52px] cursor-pointer items-center gap-3 rounded-xl border border-slate-200 bg-slate-50 px-3 py-2 text-sm font-bold text-slate-700 has-[:checked]:border-emerald-500 has-[:checked]:bg-emerald-50 has-[:checked]:text-emerald-900">
                                <input type="checkbox" data-quote-check="permit" class="rounded border-slate-300 text-emerald-600 focus:ring-emerald-500"> Permit or electrical scope
                            </label>
                            <label class="flex min-h-[52px] cursor-pointer items-center gap-3 rounded-xl border border-slate-200 bg-slate-50 px-3 py-2 text-sm font-bold text-slate-700 has-[:checked]:border-emerald-500 has-[:checked]:bg-emerald-50 has-[:checked]:text-emerald-900">
                                <input type="checkbox" data-quote-check="seal" class="rounded border-slate-300 text-emerald-600 focus:ring-emerald-500"> Sump, slab, or crawl-space sealing
                            </label>
                        </div>
                    </fieldset>

                    <div class="mt-5 rounded-2xl border border-slate-200 bg-slate-950 p-5 text-white">
                        <p class="text-xs font-bold uppercase tracking-[0.18em] text-cyan-200">Screening verdict</p>
                        <h3 data-quote-verdict-title class="mt-2 text-2xl font-black">Enter a quote to compare the scope.</h3>
                        <ul data-quote-verdict-list class="mt-4 space-y-2 text-sm font-semibold leading-relaxed text-slate-200">
                            <li>Use this to find missing scope before you submit the quote to the ledger.</li>
                        </ul>
                        <div class="mt-5 flex flex-col gap-3 sm:flex-row">
                            <a href="#quoteLedgerForm"
                               data-track-event="quote_checker_submit_signal_click"
                               data-track-label="quote_checker"
                               class="inline-flex min-h-[46px] items-center justify-center rounded-xl bg-white px-4 text-sm font-black text-slate-950 transition-colors hover:bg-slate-100">
                                Add this quote signal
                            </a>
                            <a href="/guides/radon-mitigation-quote-checklist"
                               data-track-event="quote_checker_checklist_click"
                               data-track-label="quote_checker"
                               class="inline-flex min-h-[46px] items-center justify-center rounded-xl border border-white/20 px-4 text-sm font-black text-white transition-colors hover:bg-white/10">
                                Open quote checklist
                            </a>
                        </div>
                    </div>
                </div>
            </section>

            <section id="quote-index" class="mt-16 border-y border-slate-200 py-10">
                <div class="flex flex-col gap-5 lg:flex-row lg:items-end lg:justify-between">
                    <div>
                        <p class="text-xs font-bold uppercase tracking-[0.22em] text-slate-500">Radon Quote Index</p>
                        <h2 class="mt-3 font-display text-3xl font-black tracking-tight text-slate-950">Public aggregate ranges, not private submissions.</h2>
                            <p class="mt-3 max-w-3xl text-sm leading-relaxed text-slate-600">
                            The index groups quote submissions and lead-derived planning signals by county, state, foundation, and result band. Exact ZIPs, names, emails, phones, notes, IP addresses, and user agents stay out of the public export.
                        </p>
                    </div>
                    <a href="/radon-quote-ledger/benchmark.csv"
                       data-track-event="quote_index_csv_click"
                       data-track-label="benchmark_csv"
                       class="inline-flex min-h-[48px] items-center justify-center rounded-xl border border-slate-300 px-4 text-sm font-black text-slate-900 transition-colors hover:bg-slate-50">
                        Download aggregate CSV
                    </a>
                </div>

                <div class="mt-7 grid gap-3 sm:grid-cols-4">
                    <div class="rounded-2xl border border-slate-200 bg-white p-4">
                        <p class="text-2xl font-black text-slate-950">@if(quoteBenchmark != null)${quoteBenchmark.getStateCount()}@else 0@endif</p>
                        <p class="mt-1 text-xs font-bold uppercase tracking-wider text-slate-500">States</p>
                    </div>
                    <div class="rounded-2xl border border-slate-200 bg-white p-4">
                        <p class="text-2xl font-black text-slate-950">@if(quoteBenchmark != null)${quoteBenchmark.getCountyCount()}@else 0@endif</p>
                        <p class="mt-1 text-xs font-bold uppercase tracking-wider text-slate-500">Counties</p>
                    </div>
                    <div class="rounded-2xl border border-slate-200 bg-white p-4">
                        <p class="text-2xl font-black text-slate-950">@if(quoteBenchmark != null)${quoteBenchmark.getLeadDerivedSignalCount()}@else 0@endif</p>
                        <p class="mt-1 text-xs font-bold uppercase tracking-wider text-slate-500">Lead-derived signals</p>
                    </div>
                    <div class="rounded-2xl border border-slate-200 bg-white p-4">
                        <p class="text-base font-black text-slate-950">@if(quoteBenchmark != null)${quoteBenchmark.getFreshnessLabel()}@else No public signals yet@endif</p>
                        <p class="mt-1 text-xs font-bold uppercase tracking-wider text-slate-500">Freshness</p>
                    </div>
                </div>

                @if(hasQuoteBenchmark)
                    <div class="mt-7 overflow-hidden rounded-[1.25rem] border border-slate-200 bg-white">
                        <div class="overflow-x-auto">
                            <table class="min-w-full divide-y divide-slate-200 text-left text-sm">
                                <thead class="bg-slate-50 text-xs font-black uppercase tracking-wider text-slate-500">
                                    <tr>
                                        <th scope="col" class="px-4 py-3">Market</th>
                                        <th scope="col" class="px-4 py-3">Foundation</th>
                                        <th scope="col" class="px-4 py-3">Result</th>
                                        <th scope="col" class="px-4 py-3">Signals</th>
                                        <th scope="col" class="px-4 py-3">Range</th>
                                        <th scope="col" class="px-4 py-3">Median</th>
                                        <th scope="col" class="px-4 py-3">Status</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-slate-100">
                                    @for(QuoteLedgerBenchmarkRow row : quoteBenchmark.getRows())
                                        <tr class="align-top">
                                            <td class="px-4 py-4 font-black text-slate-950">${row.getMarketLabel()}</td>
                                            <td class="px-4 py-4 font-semibold text-slate-700">${row.getFoundationLabel()}</td>
                                            <td class="px-4 py-4 font-semibold text-slate-700">${row.getResultBandLabel()}</td>
                                            <td class="px-4 py-4 font-semibold text-slate-700">${row.getSignalCount()} total, ${row.getPricedSignalCount()} priced</td>
                                            <td class="px-4 py-4 font-black text-slate-950">${row.getPriceRangeDisplay()}</td>
                                            <td class="px-4 py-4 font-black text-slate-950">${row.getMedianPriceDisplay()}</td>
                                            <td class="px-4 py-4 font-semibold text-slate-600">${row.getConfidenceLabel()}</td>
                                        </tr>
                                    @endfor
                                </tbody>
                            </table>
                        </div>
                    </div>
                @else
                    <div class="mt-7 rounded-[1.25rem] border border-dashed border-slate-300 bg-slate-50 p-6">
                        <h3 class="text-xl font-black text-slate-950">No public benchmark yet.</h3>
                        <p class="mt-2 text-sm leading-relaxed text-slate-600">
                            The first 3 priced signals in the same market segment unlock a public range. Until then, RadonVerdict stores the signal privately and shows only collection status.
                        </p>
                    </div>
                @endif
            </section>

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

            <section class="mt-16 border-y border-slate-200 py-10">
                <div class="grid gap-8 lg:grid-cols-[0.9fr_1.1fr] lg:items-start">
                    <div>
                        <p class="text-xs font-bold uppercase tracking-[0.22em] text-slate-500">Shareable benchmark packet</p>
                        <h2 class="mt-3 font-display text-3xl font-black tracking-tight text-slate-950">The best signal is one real local quote.</h2>
                        <p class="mt-3 text-sm leading-relaxed text-slate-600">
                            Agents, inspectors, and homeowners can use this packet after a failed inspection or contractor call. No address is needed; the useful parts are ZIP, result band, foundation, status, price, and scope.
                        </p>
                        <div class="mt-5 flex flex-col gap-3 sm:flex-row">
                            <a href="/guides/radon-mitigation-quote-checklist"
                               data-track-event="quote_ledger_packet_click"
                               data-track-label="quote_checklist"
                               class="inline-flex min-h-[48px] items-center justify-center rounded-xl bg-slate-950 px-4 text-sm font-black text-white transition-colors hover:bg-slate-800">
                                Open quote checklist
                            </a>
                            <a href="/guides/radon-inspection-toolkit"
                               data-track-event="quote_ledger_packet_click"
                               data-track-label="inspection_toolkit"
                               class="inline-flex min-h-[48px] items-center justify-center rounded-xl border border-slate-200 px-4 text-sm font-black text-slate-800 transition-colors hover:bg-slate-50">
                                Open inspection toolkit
                            </a>
                            <a href="/guides/radon-failed-inspection"
                               data-track-event="quote_ledger_packet_click"
                               data-track-label="failed_inspection_guide"
                               class="inline-flex min-h-[48px] items-center justify-center rounded-xl border border-slate-200 px-4 text-sm font-black text-slate-800 transition-colors hover:bg-slate-50">
                                Failed inspection path
                            </a>
                        </div>
                    </div>

                    <div class="divide-y divide-slate-200 rounded-[1.75rem] border border-slate-200 bg-white">
                        <div class="grid gap-3 p-5 sm:grid-cols-[0.32fr_0.68fr]">
                            <p class="text-sm font-black text-slate-950">Failed inspection quote</p>
                            <p class="text-sm leading-relaxed text-slate-600">4.0+ result, inspection deadline, quoted price, final price if installed, and whether the ask became repair or credit.</p>
                        </div>
                        <div class="grid gap-3 p-5 sm:grid-cols-[0.32fr_0.68fr]">
                            <p class="text-sm font-black text-slate-950">Seller credit signal</p>
                            <p class="text-sm leading-relaxed text-slate-600">Credit amount, quote basis, foundation clue, and whether the deal used concession, escrow, repair, or price reduction.</p>
                        </div>
                        <div class="grid gap-3 p-5 sm:grid-cols-[0.32fr_0.68fr]">
                            <p class="text-sm font-black text-slate-950">Paid install quote</p>
                            <p class="text-sm leading-relaxed text-slate-600">Final price, system scope, sump seal or fan replacement, slab or crawl-space complexity, and timeline.</p>
                        </div>
                        <div class="grid gap-3 p-5 sm:grid-cols-[0.32fr_0.68fr]">
                            <p class="text-sm font-black text-slate-950">Commercial or multifamily quote</p>
                            <p class="text-sm leading-relaxed text-slate-600">Building type, result band, testing status, quote status, and any scope clue without business contact details.</p>
                        </div>
                    </div>
                </div>

                <div class="mt-8 rounded-[1.5rem] border border-slate-200 bg-slate-50 p-5">
                    <p class="text-xs font-bold uppercase tracking-[0.18em] text-slate-500">Copy/paste request</p>
                    <p class="mt-2 text-sm leading-relaxed text-slate-700">
                        If you received a radon quote, add the ZIP, reading, foundation type, quoted price, final price if paid, and whether it was a failed inspection, seller credit, or planned install. Remove names, phone numbers, exact addresses, and contractor contact details.
                    </p>
                </div>
            </section>

            <section class="mt-16 grid gap-4 md:grid-cols-2 lg:grid-cols-4">
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
                <a href="/guides/radon-mitigation-quote-checklist" class="rounded-2xl border border-slate-200 bg-white p-5 transition-colors hover:border-slate-400 hover:bg-slate-50">
                    <p class="text-xs font-black uppercase tracking-wider text-slate-500">Before the call?</p>
                    <h3 class="mt-3 text-xl font-black text-slate-950">Use the quote checklist</h3>
                    <p class="mt-2 text-sm leading-relaxed text-slate-600">Ask the contractor for scope, fan, permit, warranty, and retest details.</p>
                </a>
                <a href="/radon-data-sources" class="rounded-2xl border border-slate-200 bg-white p-5 transition-colors hover:border-slate-400 hover:bg-slate-50">
                    <p class="text-xs font-black uppercase tracking-wider text-slate-500">Source policy</p>
                    <h3 class="mt-3 text-xl font-black text-slate-950">See the public data layer</h3>
                    <p class="mt-2 text-sm leading-relaxed text-slate-600">Observed quotes are kept separate from official radon evidence.</p>
                </a>
            </section>
        </main>
        <script>
            (function () {
                function onReady(callback) {
                    if (document.readyState === 'loading') {
                        document.addEventListener('DOMContentLoaded', callback);
                    } else {
                        callback();
                    }
                }

                onReady(function () {
                    var root = document.querySelector('[data-quote-checker]');
                    if (!root) {
                        return;
                    }

                    var priceField = root.querySelector('#quoteCheckerPrice');
                    var foundationField = root.querySelector('#quoteCheckerFoundation');
                    var resultField = root.querySelector('#quoteCheckerResult');
                    var title = root.querySelector('[data-quote-verdict-title]');
                    var list = root.querySelector('[data-quote-verdict-list]');

                    function isChecked(name) {
                        var input = root.querySelector('[data-quote-check="' + name + '"]');
                        return input && input.checked;
                    }

                    function addMessage(messages, text) {
                        messages.push(text);
                    }

                    function render() {
                        var price = Number(priceField.value || 0);
                        var foundation = foundationField.value;
                        var result = resultField.value;
                        var messages = [];

                        if (!price) {
                            title.textContent = 'Enter a quote to compare the scope.';
                            list.innerHTML = '';
                            addMessage(messages, 'Use this to find missing scope before you submit the quote to the ledger.');
                        } else {
                            if (price < 900) {
                                addMessage(messages, 'Price is unusually low. Confirm the fan, pipe route, sealing work, electrical connection, and retest are actually included.');
                            }
                            if (price > 4500) {
                                addMessage(messages, 'Price is high enough to demand a line-item explanation: access difficulty, multiple suction points, crawl-space membrane, or commercial scope.');
                            }
                            if (foundation === 'crawlspace' && price < 1800) {
                                addMessage(messages, 'Crawl-space quotes below this level often omit membrane detail, sealing labor, or access constraints.');
                            }
                            if (foundation === 'mixed' && price < 1800) {
                                addMessage(messages, 'Mixed foundations need more scope detail than a simple basement quote. Ask how each foundation area is handled.');
                            }
                            if (result === 'above_8' && price < 1600) {
                                addMessage(messages, 'For an 8.0+ result, a very cheap quote should explain expected post-mitigation target, retest timing, and warranty path.');
                            }
                            if (!isChecked('retest')) {
                                addMessage(messages, 'Missing retest language. Ask whether post-mitigation testing is included or separate.');
                            }
                            if (!isChecked('warranty')) {
                                addMessage(messages, 'Missing fan or warranty detail. Ask for the fan model, warranty term, and service responsibility.');
                            }
                            if (!isChecked('permit')) {
                                addMessage(messages, 'Missing permit or electrical scope. Ask who handles code, outlet, and permit requirements in your jurisdiction.');
                            }
                            if (!isChecked('seal')) {
                                addMessage(messages, 'Missing sealing scope. Ask whether sump lids, slab cracks, crawl-space membrane, or penetrations are included.');
                            }

                            if (messages.length === 0) {
                                title.textContent = 'Structured enough to compare.';
                                addMessage(messages, 'The quote includes the main comparison fields. Submit it to the ledger so the local benchmark can improve.');
                                addMessage(messages, 'Still compare at least one other bid if access, crawl-space work, or transaction deadlines are involved.');
                            } else {
                                title.textContent = messages.length === 1 ? 'One scope question before you trust it.' : messages.length + ' scope questions before you trust it.';
                            }
                        }

                        list.innerHTML = '';
                        messages.forEach(function (message) {
                            var item = document.createElement('li');
                            item.textContent = message;
                            list.appendChild(item);
                        });
                    }

                    root.querySelectorAll('input, select').forEach(function (field) {
                        field.addEventListener('input', render);
                        field.addEventListener('change', render);
                    });
                    render();
                });
            })();
        </script>
    `
)
