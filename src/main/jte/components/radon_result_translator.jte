@import com.radonverdict.model.County

@param County county
@param String countySignalSummary = null
@param String measuredPrimaryResultDisplay = null
@param String measuredPercentAbove4Display = null

!{
    final String countyLabel = county.getAreaDisplayName() + ", " + county.getStateAbbr();
    final String costUrl = "/radon-mitigation-cost/" + county.getStateSlug() + "/" + county.getCountySlug() + "?radonResultBand=above_4&intent=homeowner#estimate-form";
    final String creditUrl = "/radon-credit-calculator/" + county.getStateSlug() + "/" + county.getCountySlug() + "?radonResultBand=above_4&intent=buying";
    final String testingUrl = "/guides/how-to-test-for-radon";
    final String signal = countySignalSummary != null && !countySignalSummary.isBlank()
            ? countySignalSummary
            : "Use the county signal as context, then let the home test result decide the next step.";
    final String primaryResult = measuredPrimaryResultDisplay != null && !measuredPrimaryResultDisplay.isBlank()
            ? measuredPrimaryResultDisplay
            : "Not available";
    final String above4 = measuredPercentAbove4Display != null && !measuredPercentAbove4Display.isBlank()
            ? measuredPercentAbove4Display
            : "Not available";
}

<section id="result-translator"
         class="levels-result-tool mt-8 scroll-mt-28 rounded-[1.75rem] border border-slate-200 bg-white p-5 shadow-2xl sm:p-6"
         data-rv-result-tool
         data-county-label="${countyLabel}"
         data-cost-url="${costUrl}"
         data-credit-url="${creditUrl}"
         data-testing-url="${testingUrl}">
    <div class="grid gap-7 lg:grid-cols-[0.82fr_1.18fr] lg:items-start">
        <div>
            <div class="inline-flex items-center gap-2 rounded-full bg-slate-100 px-3 py-1 text-xs font-bold uppercase tracking-wider text-slate-700">
                Home result translator
            </div>
            <h2 class="mt-4 font-display text-2xl font-black leading-tight tracking-tight text-slate-900 sm:text-3xl">
                Enter your radon number. Get the next move.
            </h2>
            <p class="mt-3 text-sm leading-relaxed text-slate-600">
                ${signal}
            </p>
            <div class="mt-5 grid gap-3 text-sm sm:grid-cols-2">
                <div class="border-l-4 border-slate-900 bg-slate-50 px-4 py-3">
                    <p class="text-[11px] font-bold uppercase tracking-wider text-slate-500">County signal</p>
                    <p class="mt-1 font-black text-slate-900">${primaryResult}</p>
                </div>
                <div class="border-l-4 border-red-500 bg-red-50 px-4 py-3">
                    <p class="text-[11px] font-bold uppercase tracking-wider text-red-700">At or above 4.0</p>
                    <p class="mt-1 font-black text-slate-900">${above4}</p>
                </div>
            </div>
        </div>

        <div class="grid gap-4">
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
                No reading yet? Test first. 2.0-3.9 usually means confirm the result. 4.0+ means budget local mitigation before calling contractors.
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
            const costUrl = tool.dataset.costUrl;
            const creditUrl = tool.dataset.creditUrl;
            const testingUrl = tool.dataset.testingUrl;
            let currentNote = output.textContent.trim();

            const setResult = (message, tone, primaryText, primaryHref, secondaryText, secondaryHref) => {
                output.textContent = message;
                output.className = 'rounded-xl border p-4 text-sm font-semibold leading-relaxed ' + tone;
                primary.textContent = primaryText;
                primary.href = primaryHref;
                secondary.textContent = secondaryText;
                secondary.href = secondaryHref;
                currentNote = message;
            };

            const update = () => {
                const raw = String(input.value || '').replace(/[^0-9.]/g, '');
                const value = Number(raw);
                if (!raw || Number.isNaN(value)) {
                    setResult(
                        'No reading yet in ' + countyLabel + ': test first, then return with the number. Do not price mitigation from a county map alone.',
                        'border-slate-200 bg-slate-50 text-slate-700',
                        'Start with testing steps',
                        testingUrl,
                        'See county cost context',
                        costUrl
                    );
                    return;
                }

                if (value < 2) {
                    setResult(
                        value.toFixed(1) + ' pCi/L is below both the EPA 4.0 action level and the 2.0 gray-zone threshold. Usually monitor, retest on schedule, and avoid buying mitigation from fear alone.',
                        'border-emerald-200 bg-emerald-50 text-emerald-900',
                        'Review retesting steps',
                        testingUrl,
                        'Keep cost as context',
                        costUrl
                    );
                    return;
                }

                if (value < 4) {
                    setResult(
                        value.toFixed(1) + ' pCi/L sits in the 2.0-3.9 gray zone. Confirm with a stronger or longer test before spending, unless a purchase, sale, finished basement, or repeat result makes timing matter.',
                        'border-amber-200 bg-amber-50 text-amber-900',
                        'Review retesting steps',
                        testingUrl,
                        'Compare local cost if timing matters',
                        costUrl
                    );
                    return;
                }

                if (value < 8) {
                    setResult(
                        value.toFixed(1) + ' pCi/L is at or above the EPA action level. Confirm the test conditions if needed, then use the local cost plan before you call contractors.',
                        'border-red-200 bg-red-50 text-red-900',
                        'Open local 4.0+ cost plan',
                        costUrl,
                        'Open buyer/seller credit path',
                        creditUrl
                    );
                    return;
                }

                setResult(
                    value.toFixed(1) + ' pCi/L is a high result. Move faster: confirm conditions, limit lower-level exposure where practical, and open the local mitigation plan before comparing bids.',
                    'border-rose-200 bg-rose-50 text-rose-900',
                    'Open local 4.0+ cost plan',
                    costUrl,
                    'Open buyer/seller credit path',
                    creditUrl
                );
            };

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
        });
    })();
</script>
