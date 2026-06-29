@template.layout.main(
    title = "RadonVerdict | Radon Result, Cost, and Next-Step Planner",
    canonicalUrl = "https://radonverdict.com/",
    description = "Use RadonVerdict to turn a radon test result, ZIP code, and buying/selling context into a local action plan.",
    headContent = @`
        <script src="/js/situation-decoder.js"></script>
    `,
    content = @`
        <section class="relative overflow-hidden bg-slate-950 text-white">
            <div class="absolute inset-x-0 top-0 h-px bg-white/10"></div>
            <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-12 sm:py-16 lg:py-20">
                <div class="grid gap-10 lg:grid-cols-[0.9fr_1.1fr] lg:items-center">
                    <div>
                        <p class="text-xs font-bold uppercase tracking-[0.28em] text-emerald-300">Local radon decision engine</p>
                        <h1 class="mt-5 font-display text-5xl font-black tracking-tight text-white sm:text-6xl lg:text-7xl">
                            RadonVerdict
                        </h1>
                        <p class="mt-5 max-w-xl text-xl font-semibold leading-relaxed text-slate-200">
                            Put in the ZIP, result, and situation. Get the local path: test, retest, budget mitigation, or negotiate a credit.
                        </p>
                        <div class="mt-8 flex flex-col gap-3 sm:flex-row">
                            <a href="#home-decision-console"
                               class="inline-flex min-h-[52px] items-center justify-center rounded-xl bg-white px-5 text-sm font-bold text-slate-950 transition-colors hover:bg-slate-100">
                                Start with ZIP
                            </a>
                            <a href="/radon-levels"
                               class="inline-flex min-h-[52px] items-center justify-center rounded-xl border border-white/20 px-5 text-sm font-bold text-white transition-colors hover:bg-white/10">
                                Understand a radon number
                            </a>
                        </div>
                    </div>

                    <div id="home-decision-console"
                         class="rounded-2xl border border-white/10 bg-white p-4 text-slate-900 shadow-2xl sm:p-5"
                         x-data="{
                            reading: '5.5',
                            noTest: false,
                            intent: 'homeowner',
                            get readingNumber() {
                                const value = Number.parseFloat(this.reading);
                                return Number.isFinite(value) ? value : null;
                            },
                            get resultBand() {
                                if (this.noTest || this.readingNumber === null) return 'not_tested';
                                if (this.readingNumber >= 4) return 'above_4';
                                if (this.readingNumber >= 2) return 'between_2_and_4';
                                return 'under_2';
                            },
                            get resultLabel() {
                                if (this.resultBand === 'not_tested') return 'No test yet';
                                if (this.resultBand === 'under_2') return 'Under 2.0 pCi/L';
                                if (this.resultBand === 'between_2_and_4') return '2.0-3.9 pCi/L';
                                return '4.0+ pCi/L';
                            },
                            get verdictLabel() {
                                if (this.resultBand === 'not_tested') return 'Test before pricing';
                                if (this.resultBand === 'under_2') return 'Low reading';
                                if (this.resultBand === 'between_2_and_4') return 'Borderline reading';
                                return 'Action-level reading';
                            },
                            get intentLabel() {
                                if (this.intent === 'buying') return 'Buying';
                                if (this.intent === 'selling') return 'Selling';
                                return 'Living here';
                            },
                            get nextMove() {
                                if (this.resultBand === 'not_tested') return 'Test first. Do not price mitigation from fear alone.';
                                if (this.resultBand === 'under_2') return 'Keep the result, retest on schedule, and avoid panic quotes.';
                                if (this.intent === 'buying' || this.intent === 'selling') return 'Open the local credit range and negotiation plan.';
                                if (this.resultBand === 'between_2_and_4') return 'Retest or monitor before you commit to a mitigation bid.';
                                return 'Open the county cost plan and quote coach.';
                            }
                         }">
                        <div class="flex items-center justify-between gap-3 border-b border-slate-200 pb-4">
                            <div>
                                <p class="text-xs font-bold uppercase tracking-[0.22em] text-slate-500">Decision console</p>
                                <h2 class="mt-1 font-display text-2xl font-bold tracking-tight text-slate-950">Open the right local plan</h2>
                            </div>
                            <div class="hidden rounded-lg bg-slate-950 px-3 py-2 text-xs font-bold text-white sm:block">Live path</div>
                        </div>

                        <form action="/search-zip" method="POST" class="mt-5 space-y-5">
                            <input type="hidden" name="radonResultBand" value="above_4" :value="resultBand">

                            <div class="grid gap-4 md:grid-cols-[1.1fr_0.9fr]">
                                <div class="rounded-xl border border-slate-200 bg-slate-50 p-4">
                                    <div class="flex items-center justify-between gap-3">
                                        <label for="homeRadonReading" class="text-sm font-bold text-slate-800">Radon reading</label>
                                        <button type="button"
                                                @click="noTest = !noTest; if (!noTest && !reading) reading = '5.5'"
                                                class="rounded-lg border border-slate-300 bg-white px-3 py-2 text-xs font-black text-slate-700 transition-colors hover:bg-slate-100"
                                                :aria-pressed="noTest.toString()">
                                            <span x-text="noTest ? 'Enter a result' : 'No test yet'">No test yet</span>
                                        </button>
                                    </div>
                                    <div class="mt-3 flex items-center rounded-xl border border-slate-300 bg-white px-4 shadow-sm focus-within:border-slate-900 focus-within:bg-white">
                                        <input id="homeRadonReading"
                                               x-model="reading"
                                               :disabled="noTest"
                                               type="number"
                                               min="0"
                                               max="999"
                                               step="0.1"
                                               inputmode="decimal"
                                               class="min-h-[58px] min-w-0 flex-1 border-0 bg-transparent p-0 font-display text-4xl font-black tracking-tight text-slate-950 placeholder:text-slate-300 focus:outline-none focus:ring-0 disabled:text-slate-300"
                                               placeholder="5.5">
                                        <span class="ml-3 text-sm font-black text-slate-500">pCi/L</span>
                                    </div>
                                    <p class="mt-3 text-xs font-semibold leading-relaxed text-slate-500">
                                        Enter the lowest-level livable area result. If you have no test, switch to test-first mode.
                                    </p>
                                </div>

                                <div class="rounded-xl border border-slate-900 bg-slate-950 p-4 text-white">
                                    <p class="text-[11px] font-bold uppercase tracking-[0.22em] text-slate-400">Instant verdict</p>
                                    <p class="mt-2 font-display text-2xl font-black tracking-tight" x-text="verdictLabel">Action-level reading</p>
                                    <p class="mt-3 text-sm font-semibold leading-relaxed text-slate-300" x-text="nextMove">
                                        Open the county cost plan and quote coach.
                                    </p>
                                </div>
                            </div>

                            <fieldset>
                                <legend class="text-sm font-bold text-slate-800">Situation</legend>
                                <div class="mt-2 grid grid-cols-3 gap-2">
                                    <label class="cursor-pointer">
                                        <input x-model="intent" type="radio" name="intent" value="homeowner" checked class="peer sr-only">
                                        <span class="flex min-h-[54px] items-center justify-center rounded-lg border border-slate-200 px-2 text-center text-xs font-bold text-slate-600 transition-colors peer-checked:border-sky-500 peer-checked:bg-sky-50 peer-checked:text-sky-800">Living</span>
                                    </label>
                                    <label class="cursor-pointer">
                                        <input x-model="intent" type="radio" name="intent" value="buying" class="peer sr-only">
                                        <span class="flex min-h-[54px] items-center justify-center rounded-lg border border-slate-200 px-2 text-center text-xs font-bold text-slate-600 transition-colors peer-checked:border-sky-500 peer-checked:bg-sky-50 peer-checked:text-sky-800">Buying</span>
                                    </label>
                                    <label class="cursor-pointer">
                                        <input x-model="intent" type="radio" name="intent" value="selling" class="peer sr-only">
                                        <span class="flex min-h-[54px] items-center justify-center rounded-lg border border-slate-200 px-2 text-center text-xs font-bold text-slate-600 transition-colors peer-checked:border-sky-500 peer-checked:bg-sky-50 peer-checked:text-sky-800">Selling</span>
                                    </label>
                                </div>
                            </fieldset>

                            <div>
                                <label for="homeZipCode" class="text-sm font-bold text-slate-800">ZIP code</label>
                                <div class="mt-2 flex flex-col gap-2 sm:flex-row">
                                    <input id="homeZipCode"
                                           name="zipCode"
                                           type="text"
                                           required
                                           pattern="[0-9]{5}"
                                           inputmode="numeric"
                                           placeholder="e.g. 22030"
                                           class="min-h-[52px] min-w-0 flex-1 rounded-xl border border-slate-300 px-4 text-base font-semibold text-slate-950 shadow-sm focus:border-slate-900 focus:outline-none focus:ring-2 focus:ring-slate-900/10">
                                    <button type="submit"
                                            data-track-event="home_console_submit"
                                            data-track-label="zip_to_local_plan"
                                            class="inline-flex min-h-[52px] items-center justify-center rounded-xl bg-slate-950 px-5 text-sm font-bold text-white transition-colors hover:bg-slate-800">
                                        Open local action plan
                                    </button>
                                </div>
                            </div>

                            <div class="rounded-xl border border-slate-200 bg-slate-50 p-4">
                                <div class="grid gap-3 sm:grid-cols-3">
                                    <div>
                                        <p class="text-[11px] font-bold uppercase tracking-widest text-slate-500">Selected result</p>
                                        <p class="mt-1 text-sm font-black text-slate-950" x-text="resultLabel">4.0+ pCi/L</p>
                                    </div>
                                    <div>
                                        <p class="text-[11px] font-bold uppercase tracking-widest text-slate-500">Selected situation</p>
                                        <p class="mt-1 text-sm font-black text-slate-950" x-text="intentLabel">Living here</p>
                                    </div>
                                    <div>
                                        <p class="text-[11px] font-bold uppercase tracking-widest text-slate-500">Route</p>
                                        <p class="mt-1 text-sm font-black text-slate-950">County plan</p>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </section>

        @template.components.situation_decoder()

        <section class="bg-white py-14 sm:py-16">
            <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="grid gap-10 lg:grid-cols-[0.8fr_1.2fr] lg:items-start">
                    <div>
                        <p class="text-xs font-bold uppercase tracking-[0.25em] text-slate-500">Pick the job</p>
                        <h2 class="mt-3 font-display text-3xl font-black tracking-tight text-slate-950 sm:text-4xl">Every path starts from the decision you actually need.</h2>
                    </div>
                    <div class="grid gap-3 md:grid-cols-3">
                        <a href="/radon-mitigation-cost"
                           class="group rounded-xl border border-slate-200 p-5 transition-colors hover:border-slate-900 hover:bg-slate-50">
                            <p class="text-xs font-bold uppercase tracking-widest text-slate-500">Cost</p>
                            <h3 class="mt-3 text-lg font-black text-slate-950">Mitigation budget</h3>
                            <p class="mt-2 text-sm font-medium leading-relaxed text-slate-600">Use foundation type, result band, and county context before quote calls.</p>
                            <span class="mt-4 inline-flex text-sm font-bold text-slate-950">Open cost hub</span>
                        </a>
                        <a href="/radon-levels"
                           class="group rounded-xl border border-slate-200 p-5 transition-colors hover:border-slate-900 hover:bg-slate-50">
                            <p class="text-xs font-bold uppercase tracking-widest text-slate-500">Levels</p>
                            <h3 class="mt-3 text-lg font-black text-slate-950">What the number means</h3>
                            <p class="mt-2 text-sm font-medium leading-relaxed text-slate-600">Translate pCi/L into retest, monitor, mitigate, or negotiate steps.</p>
                            <span class="mt-4 inline-flex text-sm font-bold text-slate-950">Open levels hub</span>
                        </a>
                        <a href="/radon-credit-calculator"
                           class="group rounded-xl border border-slate-200 p-5 transition-colors hover:border-slate-900 hover:bg-slate-50">
                            <p class="text-xs font-bold uppercase tracking-widest text-slate-500">Deal</p>
                            <h3 class="mt-3 text-lg font-black text-slate-950">Buyer/seller credit</h3>
                            <p class="mt-2 text-sm font-medium leading-relaxed text-slate-600">Turn a failed radon inspection into an ask, ceiling, and fallback range.</p>
                            <span class="mt-4 inline-flex text-sm font-bold text-slate-950">Open credit calculator</span>
                        </a>
                    </div>
                </div>
            </div>
        </section>

        <section class="border-y border-slate-200 bg-slate-100 py-14 sm:py-16">
            <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="grid gap-8 lg:grid-cols-4">
                    <div class="lg:col-span-1">
                        <p class="text-xs font-bold uppercase tracking-[0.25em] text-slate-500">Why it feels useful</p>
                        <h2 class="mt-3 font-display text-3xl font-black tracking-tight text-slate-950">Not another radon article.</h2>
                    </div>
                    <div class="grid gap-px overflow-hidden rounded-xl border border-slate-200 bg-slate-200 lg:col-span-3">
                        <div class="grid gap-0 bg-white p-5 md:grid-cols-[0.35fr_0.65fr]">
                            <p class="text-sm font-black text-slate-950">Local first</p>
                            <p class="mt-2 text-sm font-medium leading-relaxed text-slate-600 md:mt-0">ZIP lookup opens the county plan, not a national average pretending to be local.</p>
                        </div>
                        <div class="grid gap-0 bg-white p-5 md:grid-cols-[0.35fr_0.65fr]">
                            <p class="text-sm font-black text-slate-950">Scenario aware</p>
                            <p class="mt-2 text-sm font-medium leading-relaxed text-slate-600 md:mt-0">A 4.0+ buyer, a 2.0-3.9 homeowner, and someone with no test should not see the same next step.</p>
                        </div>
                        <div class="grid gap-0 bg-white p-5 md:grid-cols-[0.35fr_0.65fr]">
                            <p class="text-sm font-black text-slate-950">Quote ready</p>
                            <p class="mt-2 text-sm font-medium leading-relaxed text-slate-600 md:mt-0">County plans include a quote coach, bid checker, and saved-plan handoff so users can act without rebuilding context.</p>
                        </div>
                        <div class="grid gap-0 bg-white p-5 md:grid-cols-[0.35fr_0.65fr]">
                            <p class="text-sm font-black text-slate-950">Source visible</p>
                            <p class="mt-2 text-sm font-medium leading-relaxed text-slate-600 md:mt-0">Methodology and data-source pages explain the public radon, housing, and pricing inputs behind the guidance.</p>
                        </div>
                    </div>
                </div>

                <div class="mt-10 flex flex-col gap-3 sm:flex-row">
                    <a href="/methodology"
                       class="inline-flex min-h-[48px] items-center justify-center rounded-xl bg-slate-950 px-5 text-sm font-bold text-white transition-colors hover:bg-slate-800">
                        Review methodology
                    </a>
                    <a href="/radon-data-sources"
                       class="inline-flex min-h-[48px] items-center justify-center rounded-xl border border-slate-300 bg-white px-5 text-sm font-bold text-slate-950 transition-colors hover:bg-slate-50">
                        See data sources
                    </a>
                </div>
            </div>
        </section>
    `
)
