@import com.radonverdict.model.County
@import com.radonverdict.model.dto.CountyPageContent

@param County county
@param CountyPageContent page = null
@param String countySignalSummary = null
@param String measuredPrimaryResultDisplay = null
@param String measuredPercentAbove4Display = null

!{
    final String countyLabel = county.getAreaDisplayName() + ", " + county.getStateAbbr();
    final String baseCostUrl = "/radon-mitigation-cost/" + county.getStateSlug() + "/" + county.getCountySlug();
    final String baseCreditUrl = "/radon-credit-calculator/" + county.getStateSlug() + "/" + county.getCountySlug();
    final String costUrl = baseCostUrl + "?radonResultBand=above_4&intent=homeowner#estimate-form";
    final String creditUrl = baseCreditUrl + "?radonResultBand=above_4&intent=buying";
    final String testingUrl = "/guides/how-to-test-for-radon";
    final boolean hasCostRange = page != null && page.getReceipt() != null;
    final String defaultIntent = page != null && page.getSelectedIntent() != null && !page.getSelectedIntent().isBlank()
            ? page.getSelectedIntent()
            : "homeowner";
    final String defaultFoundation = page != null && page.getSelectedFoundationType() != null && !page.getSelectedFoundationType().isBlank()
            ? page.getSelectedFoundationType()
            : "basement";
    final String defaultBand = page != null && page.getSelectedRadonResultBand() != null && !page.getSelectedRadonResultBand().isBlank()
            ? page.getSelectedRadonResultBand()
            : "not_tested";
    final String signal = countySignalSummary != null && !countySignalSummary.isBlank()
            ? countySignalSummary
            : "Use the county signal as context, then let the home test result decide the next step.";
    final String primaryResult = hasCostRange
            ? "$" + page.getReceipt().getTotalAvg()
            : measuredPrimaryResultDisplay != null && !measuredPrimaryResultDisplay.isBlank()
            ? measuredPrimaryResultDisplay
            : "Not available";
    final String above4 = hasCostRange
            ? "$" + page.getReceipt().getTotalLow() + "-$" + page.getReceipt().getTotalHigh()
            : measuredPercentAbove4Display != null && !measuredPercentAbove4Display.isBlank()
            ? measuredPercentAbove4Display
            : "Not available";
    final String primaryMetricLabel = hasCostRange ? "Local midpoint" : "County signal";
    final String secondaryMetricLabel = hasCostRange ? "Modeled range" : "At or above 4.0";
}

<section id="result-translator"
         class="levels-result-tool mt-8 scroll-mt-28 rounded-[1.75rem] border border-slate-200 bg-white p-5 shadow-2xl sm:p-6"
         data-rv-result-tool
         data-county-label="${countyLabel}"
         data-base-cost-url="${baseCostUrl}"
         data-base-credit-url="${baseCreditUrl}"
         data-cost-url="${costUrl}"
         data-credit-url="${creditUrl}"
         data-testing-url="${testingUrl}"
         data-default-intent="${defaultIntent}"
         data-default-foundation="${defaultFoundation}"
         data-default-result-band="${defaultBand}">
    <div class="grid gap-7 lg:grid-cols-[0.82fr_1.18fr] lg:items-start">
        <div>
            <div class="inline-flex items-center gap-2 rounded-full bg-slate-100 px-3 py-1 text-xs font-bold uppercase tracking-wider text-slate-700">
                Home result translator
            </div>
            <h2 class="mt-4 font-display text-2xl font-black leading-tight tracking-tight text-slate-900 sm:text-3xl">
                Enter the result. Pick the deal side. Get the route.
            </h2>
            <p class="mt-3 text-sm leading-relaxed text-slate-600">
                ${signal}
            </p>
            <div class="mt-5 grid gap-3 text-sm sm:grid-cols-2">
                <div class="border-l-4 border-slate-900 bg-slate-50 px-4 py-3">
                    <p class="text-[11px] font-bold uppercase tracking-wider text-slate-500">${primaryMetricLabel}</p>
                    <p class="mt-1 font-black text-slate-900">${primaryResult}</p>
                </div>
                <div class="border-l-4 border-red-500 bg-red-50 px-4 py-3">
                    <p class="text-[11px] font-bold uppercase tracking-wider text-red-700">${secondaryMetricLabel}</p>
                    <p class="mt-1 font-black text-slate-900">${above4}</p>
                </div>
            </div>
        </div>

        <div class="grid gap-4">
            <div class="grid gap-3">
                <div>
                    <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Decision side</p>
                    <div class="mt-2 grid grid-cols-3 gap-2">
                        <button type="button" data-rv-intent="homeowner" class="rounded-xl border border-slate-200 px-3 py-2 text-xs font-black text-slate-700 transition-colors hover:bg-slate-50">Living here</button>
                        <button type="button" data-rv-intent="buying" class="rounded-xl border border-slate-200 px-3 py-2 text-xs font-black text-slate-700 transition-colors hover:bg-slate-50">Buying</button>
                        <button type="button" data-rv-intent="selling" class="rounded-xl border border-slate-200 px-3 py-2 text-xs font-black text-slate-700 transition-colors hover:bg-slate-50">Selling</button>
                    </div>
                </div>

                <div>
                    <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Foundation clue</p>
                    <div class="mt-2 grid grid-cols-2 gap-2 sm:grid-cols-4">
                        <button type="button" data-rv-foundation="basement" class="rounded-xl border border-slate-200 px-3 py-2 text-xs font-black text-slate-700 transition-colors hover:bg-slate-50">Basement</button>
                        <button type="button" data-rv-foundation="slab" class="rounded-xl border border-slate-200 px-3 py-2 text-xs font-black text-slate-700 transition-colors hover:bg-slate-50">Slab</button>
                        <button type="button" data-rv-foundation="crawlspace" class="rounded-xl border border-slate-200 px-3 py-2 text-xs font-black text-slate-700 transition-colors hover:bg-slate-50">Crawlspace</button>
                        <button type="button" data-rv-foundation="other" class="rounded-xl border border-slate-200 px-3 py-2 text-xs font-black text-slate-700 transition-colors hover:bg-slate-50">Not sure</button>
                    </div>
                </div>
            </div>

            <div class="grid gap-3 sm:grid-cols-[1fr_auto] sm:items-end">
                <label for="home-radon-result" class="block">
                    <span class="text-xs font-bold uppercase tracking-wider text-slate-500">Your home result</span>
                    <span class="mt-2 flex items-center rounded-xl border border-slate-200 bg-slate-50 px-4 py-3 focus-within:border-slate-900 focus-within:bg-white">
                        <input id="home-radon-result"
                               data-rv-result-input
                               inputmode="decimal"
                               autocomplete="off"
                               placeholder="3.0"
                               class="w-full bg-transparent text-3xl font-black tabular-nums text-slate-900 outline-none placeholder:text-slate-300">
                        <span class="ml-2 text-sm font-bold text-slate-500">pCi/L</span>
                    </span>
                </label>
                <button type="button"
                        data-rv-check-result
                        class="inline-flex min-h-[54px] items-center justify-center rounded-xl bg-slate-900 px-5 text-sm font-bold text-white transition-colors hover:bg-slate-800">
                    Check my result
                </button>
            </div>

            <div class="grid gap-2 sm:grid-cols-4">
                <button type="button" data-rv-result-preset="" class="rounded-xl border border-slate-200 px-3 py-2 text-xs font-bold text-slate-700 transition-colors hover:bg-slate-50">No reading</button>
                <button type="button" data-rv-result-preset="1.8" class="rounded-xl border border-emerald-200 bg-emerald-50 px-3 py-2 text-xs font-bold text-emerald-900 transition-colors hover:bg-emerald-100">Under 2.0</button>
                <button type="button" data-rv-result-preset="3.2" class="rounded-xl border border-amber-200 bg-amber-50 px-3 py-2 text-xs font-bold text-amber-900 transition-colors hover:bg-amber-100">2.0-3.9</button>
                <button type="button" data-rv-result-preset="5.1" class="rounded-xl border border-red-200 bg-red-50 px-3 py-2 text-xs font-bold text-red-900 transition-colors hover:bg-red-100">4.0+</button>
            </div>

            <div data-rv-result-output
                 class="rounded-xl border border-slate-200 bg-slate-50 p-4 text-sm leading-relaxed text-slate-700"
                 aria-live="polite">
                No reading yet? Test first. 2.0-3.9 usually means confirm the result. 4.0+ means budget local mitigation or seller-credit math before the conversation starts.
            </div>

            <div class="flex flex-col gap-3 sm:flex-row">
                <a href="${testingUrl}"
                   data-rv-result-primary
                   data-track-event="levels_result_tool_click"
                   data-track-label="${county.getCountySlug()}-primary"
                   class="inline-flex items-center justify-center rounded-xl bg-indigo-600 px-5 py-3 text-sm font-bold text-white transition-colors hover:bg-indigo-700">
                    Start with testing steps
                </a>
                <a href="${costUrl}"
                   data-rv-result-secondary
                   data-track-event="levels_result_tool_click"
                   data-track-label="${county.getCountySlug()}-cost"
                   class="inline-flex items-center justify-center rounded-xl border border-slate-200 bg-white px-5 py-3 text-sm font-semibold text-slate-700 transition-colors hover:bg-slate-50">
                    Open local cost plan
                </a>
                <button type="button"
                        data-rv-copy-result-note
                        class="inline-flex items-center justify-center rounded-xl border border-slate-200 bg-white px-5 py-3 text-sm font-semibold text-slate-700 transition-colors hover:bg-slate-50">
                    Copy next-step note
                </button>
            </div>
            <p data-rv-result-copy-status class="min-h-[20px] text-xs font-semibold text-emerald-700" aria-live="polite"></p>
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

        document.querySelectorAll('[data-rv-result-tool]').forEach((tool) => {
            const input = tool.querySelector('[data-rv-result-input]');
            const output = tool.querySelector('[data-rv-result-output]');
            const primary = tool.querySelector('[data-rv-result-primary]');
            const secondary = tool.querySelector('[data-rv-result-secondary]');
            const copyButton = tool.querySelector('[data-rv-copy-result-note]');
            const copyStatus = tool.querySelector('[data-rv-result-copy-status]');
            const countyLabel = tool.dataset.countyLabel;
            const baseCostUrl = tool.dataset.baseCostUrl;
            const baseCreditUrl = tool.dataset.baseCreditUrl;
            const testingUrl = tool.dataset.testingUrl;
            let intent = tool.dataset.defaultIntent || 'homeowner';
            let foundation = tool.dataset.defaultFoundation || 'basement';
            let currentBand = tool.dataset.defaultResultBand || 'not_tested';
            let currentNote = output.textContent.trim();

            const labelForIntent = () => {
                if (intent === 'buying') return 'buyer';
                if (intent === 'selling') return 'seller';
                return 'homeowner';
            };

            const labelForFoundation = () => {
                if (foundation === 'crawlspace') return 'crawlspace';
                if (foundation === 'slab') return 'slab';
                if (foundation === 'basement') return 'basement';
                return 'unsure foundation';
            };

            const scenarioUrl = (baseUrl, band, target) => {
                const params = new URLSearchParams();
                params.set('radonResultBand', band);
                params.set('intent', intent);
                if (foundation && foundation !== 'other') {
                    params.set('foundation', foundation);
                }
                return baseUrl + '?' + params.toString() + (target === 'cost' ? '#estimate-form' : '');
            };

            const setActiveButtons = () => {
                tool.querySelectorAll('[data-rv-intent]').forEach((button) => {
                    const active = button.dataset.rvIntent === intent;
                    button.setAttribute('aria-pressed', active ? 'true' : 'false');
                    button.className = active
                        ? 'rounded-xl border border-slate-900 bg-slate-900 px-3 py-2 text-xs font-black text-white transition-colors'
                        : 'rounded-xl border border-slate-200 px-3 py-2 text-xs font-black text-slate-700 transition-colors hover:bg-slate-50';
                });
                tool.querySelectorAll('[data-rv-foundation]').forEach((button) => {
                    const active = button.dataset.rvFoundation === foundation;
                    button.setAttribute('aria-pressed', active ? 'true' : 'false');
                    button.className = active
                        ? 'rounded-xl border border-indigo-900 bg-indigo-50 px-3 py-2 text-xs font-black text-indigo-950 transition-colors'
                        : 'rounded-xl border border-slate-200 px-3 py-2 text-xs font-black text-slate-700 transition-colors hover:bg-slate-50';
                });
            };

            const setResult = (message, tone, primaryText, primaryHref, secondaryText, secondaryHref, band) => {
                output.textContent = message;
                output.className = 'rounded-xl border p-4 text-sm font-semibold leading-relaxed ' + tone;
                primary.textContent = primaryText;
                primary.href = primaryHref;
                secondary.textContent = secondaryText;
                secondary.href = secondaryHref;
                currentBand = band;
                currentNote = message;
            };

            const update = () => {
                const raw = String(input.value || '').replace(/[^0-9.]/g, '');
                const value = Number(raw);
                const dealMode = intent === 'buying' || intent === 'selling';
                const costPlanUrl = scenarioUrl(baseCostUrl, 'above_4', 'cost');
                const borderlineCostUrl = scenarioUrl(baseCostUrl, 'between_2_and_4', 'cost');
                const creditPlanUrl = scenarioUrl(baseCreditUrl, 'above_4', 'credit');
                const borderlineCreditUrl = scenarioUrl(baseCreditUrl, 'between_2_and_4', 'credit');

                if (!raw || Number.isNaN(value)) {
                    setResult(
                        'No reading yet in ' + countyLabel + ': test first, then return with the number. Do not price mitigation or ask for a credit from a county map alone.',
                        'border-slate-200 bg-slate-50 text-slate-700',
                        'Start with testing steps',
                        testingUrl,
                        'See county cost context',
                        scenarioUrl(baseCostUrl, 'not_tested', 'cost'),
                        'not_tested'
                    );
                    return;
                }

                if (value < 2) {
                    setResult(
                        value.toFixed(1) + ' pCi/L for a ' + labelForIntent() + ' with a ' + labelForFoundation() + ' signal is below the common action range. Usually monitor, retest on schedule, and avoid buying mitigation from fear alone.',
                        'border-emerald-200 bg-emerald-50 text-emerald-900',
                        'Review retesting steps',
                        testingUrl,
                        'Keep cost as context',
                        scenarioUrl(baseCostUrl, 'under_2', 'cost'),
                        'under_2'
                    );
                    return;
                }

                if (value < 4) {
                    const primaryText = dealMode ? 'Open negotiation context' : 'Review retesting steps';
                    const primaryHref = dealMode ? borderlineCreditUrl : testingUrl;
                    const secondaryText = dealMode ? 'Compare local cost if challenged' : 'Compare local cost if timing matters';
                    const secondaryHref = borderlineCostUrl;
                    setResult(
                        value.toFixed(1) + ' pCi/L sits in the 2.0-3.9 gray zone. For a ' + labelForIntent() + ', confirm test quality first; if timing matters, keep the local cost and credit numbers ready instead of arguing from a generic article.',
                        'border-amber-200 bg-amber-50 text-amber-900',
                        primaryText,
                        primaryHref,
                        secondaryText,
                        secondaryHref,
                        'between_2_and_4'
                    );
                    return;
                }

                if (value < 8) {
                    const primaryText = dealMode ? 'Open buyer/seller credit path' : 'Open local 4.0+ cost plan';
                    const primaryHref = dealMode ? creditPlanUrl : costPlanUrl;
                    const secondaryText = dealMode ? 'Compare mitigation cost range' : 'Open buyer/seller credit path';
                    const secondaryHref = dealMode ? costPlanUrl : creditPlanUrl;
                    setResult(
                        value.toFixed(1) + ' pCi/L is at or above the EPA action level. For this ' + labelForFoundation() + ' scenario, use the local mitigation plan and credit path before the quote or negotiation conversation starts.',
                        'border-red-200 bg-red-50 text-red-900',
                        primaryText,
                        primaryHref,
                        secondaryText,
                        secondaryHref,
                        'above_4'
                    );
                    return;
                }

                const urgentPrimaryText = dealMode ? 'Open urgent credit path' : 'Open urgent cost plan';
                const urgentPrimaryHref = dealMode ? creditPlanUrl : costPlanUrl;
                const urgentSecondaryText = dealMode ? 'Compare mitigation cost range' : 'Open buyer/seller credit path';
                const urgentSecondaryHref = dealMode ? costPlanUrl : creditPlanUrl;
                setResult(
                    value.toFixed(1) + ' pCi/L is a high result. Move faster: confirm conditions, limit lower-level exposure where practical, and use the local plan before comparing bids or credit numbers.',
                    'border-rose-200 bg-rose-50 text-rose-900',
                    urgentPrimaryText,
                    urgentPrimaryHref,
                    urgentSecondaryText,
                    urgentSecondaryHref,
                    'above_4'
                );
            };

            tool.querySelectorAll('[data-rv-intent]').forEach((button) => {
                button.addEventListener('click', () => {
                    intent = button.dataset.rvIntent;
                    setActiveButtons();
                    update();
                });
            });
            tool.querySelectorAll('[data-rv-foundation]').forEach((button) => {
                button.addEventListener('click', () => {
                    foundation = button.dataset.rvFoundation;
                    setActiveButtons();
                    update();
                });
            });
            input.addEventListener('input', update);
            tool.querySelector('[data-rv-check-result]').addEventListener('click', update);
            tool.querySelectorAll('[data-rv-result-preset]').forEach((button) => {
                button.addEventListener('click', () => {
                    input.value = button.dataset.rvResultPreset;
                    update();
                });
            });
            copyButton.addEventListener('click', () => {
                copyText(currentNote).then(() => {
                    copyStatus.textContent = 'Copied. Paste it into your notes, agent thread, or contractor message.';
                }).catch(() => {
                    copyStatus.textContent = 'Select the result text and copy it manually.';
                });
            });
            setActiveButtons();
            update();
        });
    })();
</script>
