<section class="border-b border-slate-200 bg-white py-14 sm:py-16">
    <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="grid gap-8 lg:grid-cols-[0.82fr_1.18fr] lg:items-start">
            <div>
                <p class="text-xs font-bold uppercase tracking-[0.25em] text-slate-500">Situation decoder</p>
                <h2 class="mt-3 font-display text-3xl font-black tracking-tight text-slate-950 sm:text-4xl">
                    Paste the messy inspection sentence.
                </h2>
                <p class="mt-4 max-w-md text-base font-medium leading-relaxed text-slate-600">
                    RadonVerdict extracts the number, ZIP, deal context, and foundation clue, then turns it into the next route.
                </p>
            </div>

            <div class="rounded-2xl border border-slate-200 bg-slate-950 p-4 text-white shadow-sm sm:p-5"
                 x-data="radonSituationDecoder()"
                 x-init="decode()">
                <div class="grid gap-4 lg:grid-cols-[1fr_0.92fr]">
                    <div>
                        <label for="radonSituationText" class="text-sm font-black text-white">Inspection note or homeowner question</label>
                        <textarea id="radonSituationText"
                                  x-model="situation"
                                  @input.debounce.120ms="decode()"
                                  rows="8"
                                  class="mt-3 min-h-[210px] w-full resize-y rounded-xl border border-white/10 bg-white/10 p-4 text-base font-semibold leading-relaxed text-white placeholder:text-slate-400 focus:border-cyan-200 focus:outline-none focus:ring-2 focus:ring-cyan-200/20"
                                  placeholder="Example: Inspection says 5.8 pCi/L in 22030. I am buying and need a seller credit. Basement home."></textarea>

                        <div class="mt-3 flex flex-wrap gap-2">
                            <button type="button"
                                    @click="loadExample('buyer')"
                                    class="rounded-full border border-white/10 bg-white/10 px-3 py-2 text-xs font-black text-slate-100 transition-colors hover:bg-white/15">
                                Buyer inspection
                            </button>
                            <button type="button"
                                    @click="loadExample('homeowner')"
                                    class="rounded-full border border-white/10 bg-white/10 px-3 py-2 text-xs font-black text-slate-100 transition-colors hover:bg-white/15">
                                Homeowner result
                            </button>
                            <button type="button"
                                    @click="loadExample('untested')"
                                    class="rounded-full border border-white/10 bg-white/10 px-3 py-2 text-xs font-black text-slate-100 transition-colors hover:bg-white/15">
                                No test yet
                            </button>
                        </div>
                    </div>

                    <div class="rounded-xl border border-white/10 bg-white p-4 text-slate-950">
                        <div class="flex items-start justify-between gap-3">
                            <div>
                                <p class="text-[11px] font-black uppercase tracking-[0.22em] text-slate-400">Live verdict</p>
                                <p class="mt-2 font-display text-2xl font-black tracking-tight" x-text="verdict">Action-level reading</p>
                            </div>
                            <span class="shrink-0 rounded-full px-3 py-1 text-xs font-black"
                                  :class="toneClass"
                                  x-text="resultLabel">4.0+ pCi/L</span>
                        </div>

                        <p class="mt-4 text-sm font-semibold leading-relaxed text-slate-600" x-text="routeSummary">
                            Open the local cost plan and quote coach.
                        </p>

                        <div class="mt-5 grid gap-2">
                            <div class="rounded-lg border border-slate-200 bg-slate-50 px-3 py-2">
                                <p class="text-[10px] font-black uppercase tracking-widest text-slate-400">Radon result</p>
                                <p class="mt-1 text-sm font-black text-slate-950" x-text="readingDisplay">5.8 pCi/L</p>
                            </div>
                            <div class="rounded-lg border border-slate-200 bg-slate-50 px-3 py-2">
                                <p class="text-[10px] font-black uppercase tracking-widest text-slate-400">ZIP</p>
                                <p class="mt-1 text-sm font-black text-slate-950" x-text="zip || 'Not found yet'">22030</p>
                            </div>
                            <div class="grid grid-cols-2 gap-2">
                                <div class="rounded-lg border border-slate-200 bg-slate-50 px-3 py-2">
                                    <p class="text-[10px] font-black uppercase tracking-widest text-slate-400">Situation</p>
                                    <p class="mt-1 text-sm font-black text-slate-950" x-text="intentLabel">Buying</p>
                                </div>
                                <div class="rounded-lg border border-slate-200 bg-slate-50 px-3 py-2">
                                    <p class="text-[10px] font-black uppercase tracking-widest text-slate-400">Foundation</p>
                                    <p class="mt-1 text-sm font-black text-slate-950" x-text="foundationLabel">Basement</p>
                                </div>
                            </div>
                        </div>

                        <form action="/search-zip" method="POST" class="mt-5">
                            <input type="hidden" name="zipCode" :value="zip">
                            <input type="hidden" name="intent" :value="intent">
                            <input type="hidden" name="radonResultBand" :value="resultBand">
                            <button type="submit"
                                    :disabled="!zip"
                                    data-track-event="situation_decoder_submit"
                                    data-track-label="parsed_text_to_local_plan"
                                    class="inline-flex min-h-[52px] w-full items-center justify-center rounded-xl bg-slate-950 px-4 text-sm font-black text-white transition-colors hover:bg-slate-800 disabled:cursor-not-allowed disabled:bg-slate-300 disabled:text-slate-500">
                                <span x-text="zip ? primaryCta : 'Add ZIP to open local plan'">Open local action plan</span>
                            </button>
                        </form>

                        <div class="mt-3 grid grid-cols-2 gap-2">
                            <a href="/radon-levels#level-meaning"
                               class="inline-flex min-h-[44px] items-center justify-center rounded-lg border border-slate-200 px-3 text-center text-xs font-black text-slate-700 transition-colors hover:bg-slate-50">
                                Interpret number
                            </a>
                            <a href="/radon-credit-calculator"
                               class="inline-flex min-h-[44px] items-center justify-center rounded-lg border border-slate-200 px-3 text-center text-xs font-black text-slate-700 transition-colors hover:bg-slate-50">
                                Credit math
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</section>
