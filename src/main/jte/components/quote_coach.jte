@import com.radonverdict.model.County
@import com.radonverdict.model.dto.CountyPageContent

@param County county
@param CountyPageContent page
@param String defaultZip = ""

!{
    final int low = page.getReceipt().getTotalLow();
    final int avg = page.getReceipt().getTotalAvg();
    final int high = page.getReceipt().getTotalHigh();
    final String countyLabel = county.getAreaDisplayName() + ", " + county.getStateAbbr();
    final String selectedFoundation = page.getSelectedFoundationType() != null && !page.getSelectedFoundationType().isBlank()
            ? page.getSelectedFoundationType()
            : "unknown";
    final String selectedResultBand = page.getSelectedRadonResultBand() != null && !page.getSelectedRadonResultBand().isBlank()
            ? page.getSelectedRadonResultBand()
            : "above_4";
    final String defaultZipValue = defaultZip == null ? "" : defaultZip;
}

<section id="quote-coach" class="mt-10 scroll-mt-28 border-y border-slate-200 py-10">
    <div class="grid gap-8 lg:grid-cols-[0.9fr_1.1fr] lg:items-start">
        <div>
            <p class="text-xs font-bold uppercase tracking-[0.18em] text-slate-500">Quote coach</p>
            <h2 class="mt-3 font-display text-3xl font-black tracking-tight text-slate-900 sm:text-4xl">
                Use this page like a quote coach, not just a calculator.
            </h2>
            <p class="mt-4 text-base leading-relaxed text-slate-600">
                In ${countyLabel}, the useful move is not memorizing one price. It is knowing when to test, when to quote, what number to anchor on, and which contractor answers should make you slow down.
            </p>
            <div class="mt-6 grid gap-3 sm:grid-cols-3">
                <div class="border-l-4 border-emerald-500 bg-emerald-50 px-4 py-3">
                    <p class="text-[11px] font-bold uppercase tracking-wider text-emerald-800">Low anchor</p>
                    <p class="mt-1 text-2xl font-black tabular-nums text-slate-900">$${low}</p>
                </div>
                <div class="border-l-4 border-slate-900 bg-slate-50 px-4 py-3">
                    <p class="text-[11px] font-bold uppercase tracking-wider text-slate-600">Quote target</p>
                    <p class="mt-1 text-2xl font-black tabular-nums text-slate-900">$${avg}</p>
                </div>
                <div class="border-l-4 border-amber-500 bg-amber-50 px-4 py-3">
                    <p class="text-[11px] font-bold uppercase tracking-wider text-amber-800">Hard ceiling</p>
                    <p class="mt-1 text-2xl font-black tabular-nums text-slate-900">$${high}</p>
                </div>
            </div>
        </div>

        <div class="divide-y divide-slate-200 rounded-2xl border border-slate-200 bg-white">
            <div class="grid gap-3 p-5 sm:grid-cols-[150px_1fr]">
                <div>
                    <p class="text-sm font-black text-slate-900">No test yet</p>
                    <p class="mt-1 text-xs font-semibold uppercase tracking-wider text-slate-500">Do not quote first</p>
                </div>
                <p class="text-sm leading-relaxed text-slate-700">
                    Buy a short-term test or confirm an old result before calling installers. Use the $${low}-$${high} range as planning context, not a reason to buy a system early.
                </p>
            </div>
            <div class="grid gap-3 p-5 sm:grid-cols-[150px_1fr]">
                <div>
                    <p class="text-sm font-black text-slate-900">2.0-3.9 pCi/L</p>
                    <p class="mt-1 text-xs font-semibold uppercase tracking-wider text-slate-500">Retest or plan</p>
                </div>
                <p class="text-sm leading-relaxed text-slate-700">
                    If this is a normal homeowner decision, retest under better conditions first. If you are buying, selling, or finishing a basement, keep the local average ready so the conversation does not drift.
                </p>
            </div>
            <div class="grid gap-3 p-5 sm:grid-cols-[150px_1fr]">
                <div>
                    <p class="text-sm font-black text-slate-900">4.0+ pCi/L</p>
                    <p class="mt-1 text-xs font-semibold uppercase tracking-wider text-slate-500">Get real bids</p>
                </div>
                <p class="text-sm leading-relaxed text-slate-700">
                    Get two or three quotes and compare them against $${avg}. A bid near $${high} needs a clear reason: crawl space membrane, difficult pipe route, sump sealing, electrical work, or finish repair.
                </p>
            </div>
            <div class="grid gap-3 p-5 sm:grid-cols-[150px_1fr]">
                <div>
                    <p class="text-sm font-black text-slate-900">Buying or selling</p>
                    <p class="mt-1 text-xs font-semibold uppercase tracking-wider text-slate-500">Negotiate cleanly</p>
                </div>
                <p class="text-sm leading-relaxed text-slate-700">
                    Start the repair or credit conversation around the local average and keep $${high} as the defensible ceiling. Do not let the deal anchor on a generic national average.
                </p>
            </div>
        </div>
    </div>

    <div class="mt-8 grid gap-6 lg:grid-cols-[1fr_0.85fr]">
        <div class="rounded-2xl bg-slate-950 p-6 text-white sm:p-7">
            <div class="flex flex-col gap-4 sm:flex-row sm:items-start sm:justify-between">
                <div>
                    <p class="text-xs font-bold uppercase tracking-[0.18em] text-slate-400">Copy this call script</p>
                    <h3 class="mt-2 font-display text-2xl font-black tracking-tight">Sound like you already know the job.</h3>
                </div>
                <div class="flex flex-col gap-2 sm:min-w-[160px]">
                    <button type="button"
                            data-rv-copy-script
                            data-rv-copy-target="quote-call-script"
                            class="inline-flex shrink-0 items-center justify-center rounded-xl bg-white px-4 py-2 text-sm font-bold text-slate-950 transition-colors hover:bg-slate-100">
                        Copy script
                    </button>
                    <button type="button"
                            data-rv-print-quote-coach
                            class="inline-flex shrink-0 items-center justify-center rounded-xl border border-white/15 px-4 py-2 text-sm font-bold text-white transition-colors hover:bg-white/10">
                        Print worksheet
                    </button>
                </div>
            </div>
            <div id="quote-call-script" class="mt-5 rounded-xl border border-white/10 bg-white/5 p-4 text-sm leading-relaxed text-slate-100">
                <p>My lowest-level radon test was ___ pCi/L in ${countyLabel}. Before you give me a number, can you tell me whether this needs sub-slab suction, crawl space membrane work, sump sealing, or a combination system?</p>
                <p class="mt-3">I am comparing the quote against a local planning range of $${low}-$${high}, with $${avg} as the target. Please break out anything that pushes the price above that target.</p>
            </div>
            <p data-rv-copy-status class="mt-3 min-h-[20px] text-xs font-semibold text-emerald-300" aria-live="polite"></p>
            <div class="mt-5">
                <p class="text-sm font-bold text-white">Ask these six questions:</p>
                <ol class="mt-3 grid gap-3 text-sm leading-relaxed text-slate-200 sm:grid-cols-2">
                    <li><span class="font-bold text-white">1.</span> What foundation condition is driving the price?</li>
                    <li><span class="font-bold text-white">2.</span> Where will the pipe route and fan sit?</li>
                    <li><span class="font-bold text-white">3.</span> Is sump cover, slab sealing, or membrane work included?</li>
                    <li><span class="font-bold text-white">4.</span> Who handles electrical, permit, and exterior finish details?</li>
                    <li><span class="font-bold text-white">5.</span> What post-mitigation retest proves the system worked?</li>
                    <li><span class="font-bold text-white">6.</span> What warranty covers the fan, labor, and follow-up adjustment?</li>
                </ol>
            </div>
        </div>

        <div class="rounded-2xl border border-rose-200 bg-rose-50 p-6 sm:p-7">
            <p class="text-xs font-bold uppercase tracking-[0.18em] text-rose-700">Red flags</p>
            <h3 class="mt-2 font-display text-2xl font-black tracking-tight text-slate-900">Slow down before you say yes.</h3>
            <ul class="mt-5 space-y-3 text-sm leading-relaxed text-slate-700">
                <li class="flex gap-3">
                    <span class="mt-1 h-2 w-2 shrink-0 rounded-full bg-rose-500"></span>
                    <span>A quote that never asks for your reading, lowest level, foundation, sump, or crawl space details.</span>
                </li>
                <li class="flex gap-3">
                    <span class="mt-1 h-2 w-2 shrink-0 rounded-full bg-rose-500"></span>
                    <span>A high price with no reason tied to route difficulty, sealing, membrane work, electrical, or finish repair.</span>
                </li>
                <li class="flex gap-3">
                    <span class="mt-1 h-2 w-2 shrink-0 rounded-full bg-rose-500"></span>
                    <span>No post-install retest plan. The goal is lower radon, not just a fan on the wall.</span>
                </li>
                <li class="flex gap-3">
                    <span class="mt-1 h-2 w-2 shrink-0 rounded-full bg-rose-500"></span>
                    <span>Vague warranty language or no clear follow-up path if the result stays elevated.</span>
                </li>
            </ul>
        </div>
    </div>

    <div id="quote-bid-checker"
         class="mt-8 rounded-2xl border border-slate-200 bg-white p-6 sm:p-7"
         data-rv-quote-checker
         data-low="${low}"
         data-avg="${avg}"
         data-high="${high}"
         data-county-label="${countyLabel}"
         data-default-zip="${defaultZipValue}"
         data-default-foundation="${selectedFoundation}"
         data-default-result="${selectedResultBand}"
         data-ledger-base="/radon-quote-ledger">
        <div class="grid gap-6 lg:grid-cols-[0.85fr_1.15fr] lg:items-start">
            <div>
                <p class="text-xs font-bold uppercase tracking-[0.18em] text-slate-500">Bid checker</p>
                <h3 class="mt-2 font-display text-2xl font-black tracking-tight text-slate-900">
                    Is this quote fair enough to trust?
                </h3>
                <p class="mt-3 text-sm leading-relaxed text-slate-600">
                    Enter the number you were quoted, mark what the written bid includes, then send the anonymized signal into the ledger without retyping it.
                </p>
                <div class="mt-5 grid gap-2 text-xs font-bold uppercase tracking-wider text-slate-500 sm:grid-cols-2">
                    <p class="border-l-4 border-slate-300 bg-slate-50 px-3 py-2">Foundation: <span class="text-slate-900">${page.getFoundationLabel()}</span></p>
                    <p class="border-l-4 border-slate-300 bg-slate-50 px-3 py-2">Result: <span class="text-slate-900">${page.getSelectedRadonResultBandLabel()}</span></p>
                </div>
            </div>

            <div class="grid gap-4">
                <div class="grid gap-3 sm:grid-cols-[1fr_0.75fr_auto] sm:items-end">
                    <label for="quote-check-amount" class="block">
                        <span class="text-xs font-bold uppercase tracking-wider text-slate-500">Contractor quote</span>
                        <span class="mt-2 flex items-center rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 focus-within:border-slate-900 focus-within:bg-white">
                            <span class="mr-2 text-lg font-black text-slate-400">$</span>
                            <input id="quote-check-amount"
                                   data-rv-quote-input
                                   inputmode="numeric"
                                   autocomplete="off"
                                   placeholder="${avg}"
                                   class="w-full bg-transparent text-2xl font-black tabular-nums text-slate-900 outline-none placeholder:text-slate-300">
                        </span>
                    </label>
                    <label for="quote-check-zip" class="block">
                        <span class="text-xs font-bold uppercase tracking-wider text-slate-500">Property ZIP</span>
                        <input id="quote-check-zip"
                               name="quoteZip"
                               data-rv-quote-zip
                               pattern="[0-9]{5}"
                               inputmode="numeric"
                               autocomplete="postal-code"
                               placeholder="ZIP"
                               value="${defaultZipValue}"
                               class="mt-2 block min-h-[52px] w-full rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 text-base font-black tabular-nums text-slate-900 outline-none focus:border-slate-900 focus:bg-white">
                    </label>
                    <button type="button"
                            data-rv-check-quote
                            class="inline-flex min-h-[52px] items-center justify-center rounded-xl bg-slate-900 px-5 text-sm font-bold text-white transition-colors hover:bg-slate-800">
                        Check quote
                    </button>
                </div>

                <fieldset>
                    <legend class="text-xs font-bold uppercase tracking-wider text-slate-500">Written quote includes</legend>
                    <div class="mt-2 grid gap-2 sm:grid-cols-2">
                        <label class="flex min-h-[48px] cursor-pointer items-center gap-3 rounded-xl border border-slate-200 bg-slate-50 px-3 py-2 text-sm font-bold text-slate-700 has-[:checked]:border-emerald-500 has-[:checked]:bg-emerald-50 has-[:checked]:text-emerald-900">
                            <input type="checkbox" data-rv-quote-scope="retest" data-scope-label="post-mitigation retest" class="rounded border-slate-300 text-emerald-600 focus:ring-emerald-500"> Post-mitigation retest
                        </label>
                        <label class="flex min-h-[48px] cursor-pointer items-center gap-3 rounded-xl border border-slate-200 bg-slate-50 px-3 py-2 text-sm font-bold text-slate-700 has-[:checked]:border-emerald-500 has-[:checked]:bg-emerald-50 has-[:checked]:text-emerald-900">
                            <input type="checkbox" data-rv-quote-scope="warranty" data-scope-label="fan model and warranty" class="rounded border-slate-300 text-emerald-600 focus:ring-emerald-500"> Fan model and warranty
                        </label>
                        <label class="flex min-h-[48px] cursor-pointer items-center gap-3 rounded-xl border border-slate-200 bg-slate-50 px-3 py-2 text-sm font-bold text-slate-700 has-[:checked]:border-emerald-500 has-[:checked]:bg-emerald-50 has-[:checked]:text-emerald-900">
                            <input type="checkbox" data-rv-quote-scope="permit" data-scope-label="permit or electrical scope" class="rounded border-slate-300 text-emerald-600 focus:ring-emerald-500"> Permit or electrical scope
                        </label>
                        <label class="flex min-h-[48px] cursor-pointer items-center gap-3 rounded-xl border border-slate-200 bg-slate-50 px-3 py-2 text-sm font-bold text-slate-700 has-[:checked]:border-emerald-500 has-[:checked]:bg-emerald-50 has-[:checked]:text-emerald-900">
                            <input type="checkbox" data-rv-quote-scope="seal" data-scope-label="sump, slab, or crawl-space sealing" class="rounded border-slate-300 text-emerald-600 focus:ring-emerald-500"> Sump, slab, or crawl-space sealing
                        </label>
                    </div>
                </fieldset>

                <div data-rv-quote-result
                     class="rounded-xl border border-slate-200 bg-slate-50 p-4 text-sm leading-relaxed text-slate-700"
                     aria-live="polite">
                    Enter a quote above to compare it with the $${low} low anchor, $${avg} target, and $${high} hard ceiling.
                </div>

                <div class="border-t border-slate-200 pt-4">
                    <div class="flex flex-col gap-3 sm:flex-row">
                        <a data-rv-quote-ledger-link
                           href="/radon-quote-ledger#quoteLedgerForm"
                           data-track-event="quote_ledger_cta_click"
                           data-track-label="county_cost_bid_checker"
                           class="inline-flex min-h-[48px] items-center justify-center rounded-xl bg-slate-950 px-4 text-sm font-black text-white transition-colors hover:bg-slate-800">
                            Add to quote ledger
                        </a>
                        <button type="button"
                                data-rv-copy-quote-verdict
                                class="inline-flex min-h-[48px] items-center justify-center rounded-xl border border-slate-300 px-4 text-sm font-black text-slate-800 transition-colors hover:bg-slate-50">
                            Copy verdict
                        </button>
                    </div>
                    <p data-rv-quote-handoff-status class="mt-2 min-h-[20px] text-xs font-semibold text-slate-500" aria-live="polite">
                        The ledger handoff will carry ZIP, price, scope, foundation, and result band.
                    </p>
                    <p data-rv-quote-copy-status class="min-h-[20px] text-xs font-semibold text-emerald-700" aria-live="polite"></p>
                </div>

                <div class="grid gap-3 text-sm sm:grid-cols-3">
                    <div class="border-l-4 border-emerald-500 bg-emerald-50 px-4 py-3">
                        <p class="font-bold text-slate-900">Below $${low}</p>
                        <p class="mt-1 text-xs leading-relaxed text-slate-600">Only good if scope, retest, and warranty are still complete.</p>
                    </div>
                    <div class="border-l-4 border-slate-900 bg-slate-50 px-4 py-3">
                        <p class="font-bold text-slate-900">$${low}-$${high}</p>
                        <p class="mt-1 text-xs leading-relaxed text-slate-600">Normal zone. Compare inclusions, not just price.</p>
                    </div>
                    <div class="border-l-4 border-rose-500 bg-rose-50 px-4 py-3">
                        <p class="font-bold text-slate-900">Above $${high}</p>
                        <p class="mt-1 text-xs leading-relaxed text-slate-600">Ask for the scope reason before accepting.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<script>
    (() => {
        const fallbackCopy = (text) => {
            const textarea = document.createElement('textarea');
            textarea.value = text;
            textarea.setAttribute('readonly', '');
            textarea.style.position = 'fixed';
            textarea.style.left = '-9999px';
            document.body.appendChild(textarea);
            textarea.select();
            document.execCommand('copy');
            textarea.remove();
            return Promise.resolve();
        };

        const copyText = (text) => {
            if (navigator.clipboard && window.isSecureContext) {
                return navigator.clipboard.writeText(text).catch(() => fallbackCopy(text));
            }
            return fallbackCopy(text);
        };

        document.querySelectorAll('[data-rv-copy-script]').forEach((button) => {
            button.addEventListener('click', () => {
                const target = document.getElementById(button.dataset.rvCopyTarget);
                const status = document.querySelector('[data-rv-copy-status]');
                if (!target) {
                    return;
                }
                copyText(target.innerText.trim())
                    .then(() => {
                        if (status) {
                            status.textContent = 'Copied. Paste it into a contractor call, text, or email.';
                        }
                    })
                    .catch(() => {
                        if (status) {
                            status.textContent = 'Select the script text and copy it manually.';
                        }
                    });
            });
        });

        document.querySelectorAll('[data-rv-print-quote-coach]').forEach((button) => {
            button.addEventListener('click', () => window.print());
        });

        document.querySelectorAll('[data-rv-quote-checker]').forEach((checker) => {
            const input = checker.querySelector('[data-rv-quote-input]');
            const zipInput = checker.querySelector('[data-rv-quote-zip]');
            const result = checker.querySelector('[data-rv-quote-result]');
            const ledgerLink = checker.querySelector('[data-rv-quote-ledger-link]');
            const handoffStatus = checker.querySelector('[data-rv-quote-handoff-status]');
            const copyButton = checker.querySelector('[data-rv-copy-quote-verdict]');
            const copyStatus = checker.querySelector('[data-rv-quote-copy-status]');
            const scopeFields = Array.from(checker.querySelectorAll('[data-rv-quote-scope]'));
            const lowValue = Number(checker.dataset.low);
            const avgValue = Number(checker.dataset.avg);
            const highValue = Number(checker.dataset.high);
            const countyLabel = checker.dataset.countyLabel || 'this county';
            const defaultFoundation = checker.dataset.defaultFoundation || 'unknown';
            const defaultResult = checker.dataset.defaultResult || 'above_4';

            const formatDollars = (amount) => '$' + Math.round(amount).toLocaleString('en-US');

            const scopeChecked = (name) => {
                const field = checker.querySelector('[data-rv-quote-scope="' + name + '"]');
                return field && field.checked;
            };

            const selectedScopeLabels = () => scopeFields
                .filter((field) => field.checked)
                .map((field) => field.dataset.scopeLabel || field.value || 'included scope');

            const missingScopeMessages = () => {
                const messages = [];
                if (!scopeChecked('retest')) {
                    messages.push('Missing retest language.');
                }
                if (!scopeChecked('warranty')) {
                    messages.push('Missing fan model or warranty detail.');
                }
                if (!scopeChecked('permit')) {
                    messages.push('Missing permit or electrical responsibility.');
                }
                if (!scopeChecked('seal')) {
                    messages.push('Missing sealing detail for sump, slab, or crawl-space openings.');
                }
                return messages;
            };

            const buildLedgerUrl = (quoteValue, verdictText) => {
                const url = new URL(checker.dataset.ledgerBase || '/radon-quote-ledger', window.location.origin);
                const zip = String(zipInput && zipInput.value ? zipInput.value : '').replace(/[^0-9]/g, '').slice(0, 5);
                const scopes = selectedScopeLabels();
                if (/^[0-9]{5}$/.test(zip)) {
                    url.searchParams.set('zipCode', zip);
                }
                if (quoteValue) {
                    url.searchParams.set('quotedPrice', String(Math.round(quoteValue)));
                }
                url.searchParams.set('role', 'homeowner');
                url.searchParams.set('foundationType', defaultFoundation);
                url.searchParams.set('resultBand', defaultResult);
                url.searchParams.set('quoteStatus', 'quoted');
                url.searchParams.set('systemScope', (scopes.length ? scopes.join(', ') : 'scope details not written yet').slice(0, 80));
                url.searchParams.set('timeline', 'county cost page quote check');
                if (verdictText) {
                    url.searchParams.set('notes', (countyLabel + ' bid checker: ' + verdictText).slice(0, 1200));
                }
                return url.pathname + url.search + '#quoteLedgerForm';
            };

            const setHandoff = (quoteValue, verdictText) => {
                if (!ledgerLink) {
                    return;
                }
                ledgerLink.href = buildLedgerUrl(quoteValue, verdictText);
                if (handoffStatus) {
                    const hasZip = zipInput && /^[0-9]{5}$/.test(String(zipInput.value || '').replace(/[^0-9]/g, ''));
                    handoffStatus.textContent = hasZip
                        ? 'Ready: ledger form will open with ZIP, price, scope, foundation, and result band prefilled.'
                        : 'Add the property ZIP if you want the ledger form prefilled with the local market.';
                }
            };

            const update = () => {
                const quoteValue = Number(String(input.value || '').replace(/[^0-9.]/g, ''));
                const missing = missingScopeMessages();
                let verdictText;
                let className;

                if (!quoteValue) {
                    verdictText = 'Enter a quote above to compare it with the ' + formatDollars(lowValue) + ' low anchor, ' + formatDollars(avgValue) + ' target, and ' + formatDollars(highValue) + ' hard ceiling.';
                    className = 'rounded-xl border border-slate-200 bg-slate-50 p-4 text-sm leading-relaxed text-slate-700';
                    result.textContent = verdictText;
                    result.className = className;
                    result.dataset.copyText = verdictText;
                    setHandoff(null, '');
                    return;
                }

                if (quoteValue < lowValue) {
                    verdictText = formatDollars(quoteValue) + ' is below the local low anchor. Treat it as attractive only if the bid still includes sealing, fan, pipe route, electrical, post-mitigation retest, and warranty.';
                    className = 'rounded-xl border border-emerald-200 bg-emerald-50 p-4 text-sm font-semibold leading-relaxed text-emerald-900';
                } else if (quoteValue <= Math.round(avgValue * 1.08)) {
                    verdictText = formatDollars(quoteValue) + ' is near the local quote target. Compare warranty, retest plan, routing, and sealing details before you choose.';
                    className = 'rounded-xl border border-slate-300 bg-slate-50 p-4 text-sm font-semibold leading-relaxed text-slate-900';
                } else if (quoteValue <= highValue) {
                    verdictText = formatDollars(quoteValue) + ' is above the target but still inside the local range. Ask what specific scope pushes it higher: crawl membrane, sump sealing, difficult route, electrical, or finish repair.';
                    className = 'rounded-xl border border-amber-200 bg-amber-50 p-4 text-sm font-semibold leading-relaxed text-amber-900';
                } else {
                    verdictText = formatDollars(quoteValue) + ' is above the hard ceiling. Get another bid unless the contractor can show a clear scope reason and a post-mitigation retest plan.';
                    className = 'rounded-xl border border-rose-200 bg-rose-50 p-4 text-sm font-semibold leading-relaxed text-rose-900';
                }

                if (missing.length) {
                    verdictText += ' Before trusting it: ' + missing.join(' ');
                } else {
                    verdictText += ' Scope looks complete enough to compare against another bid.';
                }

                result.textContent = verdictText;
                result.className = className;
                result.dataset.copyText = verdictText;
                setHandoff(quoteValue, verdictText);
            };

            input.addEventListener('input', update);
            if (zipInput) {
                zipInput.addEventListener('input', update);
            }
            scopeFields.forEach((field) => field.addEventListener('change', update));
            checker.querySelector('[data-rv-check-quote]').addEventListener('click', update);
            if (copyButton) {
                copyButton.addEventListener('click', () => {
                    const text = result.dataset.copyText || result.textContent.trim();
                    copyText(text)
                        .then(() => {
                            if (copyStatus) {
                                copyStatus.textContent = 'Copied. Paste this verdict into a note, email, or contractor follow-up.';
                            }
                        })
                        .catch(() => {
                            if (copyStatus) {
                                copyStatus.textContent = 'Select the verdict text and copy it manually.';
                            }
                        });
                });
            }
            update();
        });
    })();
</script>
