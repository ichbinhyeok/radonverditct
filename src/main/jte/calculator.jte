@import java.util.Map
@import java.util.List
@import com.radonverdict.model.dto.ItemizedReceipt
@import com.radonverdict.model.County

@param String title
@param ItemizedReceipt defaultReceipt
@param Map<String, List<County>> stateMap
@param boolean noindex = false

@template.layout.main(
    title = title,
    canonicalUrl = "https://radonverdict.com/radon-cost-calculator",
    description = "Enter your ZIP code to get a local radon action plan and mitigation cost range for your county.",
    noindex = noindex,
    content = @`
        <!-- Hero Search Section -->
        <div class="bg-slate-900 pt-20 pb-32 border-b border-slate-800 relative overflow-hidden">
            <div class="absolute inset-0 bg-[url('data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNjAiIGhlaWdodD0iNjAiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PHBhdGggZD0iTTMwIDB2NjBtMzAtMzBIMCIgc3Ryb2tlPSJyZ2JhKDI1NSwyNTUsMjU1LDAuMDUpIiBzdHJva2Utd2lkdGg9IjEiIGZpbGw9Im5vbmUiIGZpbGwtcnVsZT0iZXZlbm9kZCIvPjwvc3ZnPg==')] opacity-20"></div>
            
            <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10 text-center">
                <span class="inline-flex items-center gap-2 px-3 py-1 rounded-full text-xs font-bold tracking-wider uppercase bg-slate-800 text-slate-300 border border-slate-700 shadow-sm mb-6">
                    <span class="w-2 h-2 rounded-full bg-emerald-400"></span>
                    ${java.time.LocalDate.now().getYear()} Local Action Data
                </span>
                
                <h1 class="font-display font-black text-3xl sm:text-5xl lg:text-6xl text-white tracking-tighter leading-tight mb-6">
                    Radon Action Plan <br class="hidden sm:block"/><span class="text-slate-400">+ Cost Calculator</span>
                </h1>
                
                <p class="text-slate-300 text-lg sm:text-xl leading-relaxed font-medium mb-12 max-w-2xl mx-auto">
                    See what to do next with your radon result, then compare a realistic local mitigation range before you contact contractors.
                </p>

                <!-- Zip Search Bar -->
                <form action="/search-zip" method="POST" class="max-w-2xl mx-auto">
                    <div class="relative group">
                        <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                            <svg class="h-6 w-6 text-slate-400 group-focus-within:text-brand-500 transition-colors" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                                <path stroke-linecap="round" stroke-linejoin="round" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                            </svg>
                        </div>
                        <input type="text" name="zipCode" pattern="[0-9]{5}" required placeholder="Enter 5-digit ZIP code"
                            class="block w-full pl-12 pr-32 py-4 bg-white rounded-2xl border-0 ring-1 ring-inset ring-slate-200 focus:ring-2 focus:ring-inset focus:ring-brand-500 text-slate-900 text-lg shadow-xl shadow-black/10 placeholder:text-slate-400 font-medium">
                        <button type="submit" class="absolute inset-y-2 right-2 flex items-center bg-slate-900 hover:bg-slate-800 text-white font-bold px-6 rounded-xl transition-colors shadow-sm">
                            Get Local Plan
                        </button>
                    </div>
                    <!-- Small error handling via query param -->
                    <script>
                        if (window.location.search.includes('error=notfound')) {
                            document.write('<p class="mt-3 text-rose-400 text-sm font-medium">ZIP code not found in database.</p>');
                        }
                    </script>

                    <div class="mt-8 rounded-2xl border border-white/10 bg-white/5 p-4 sm:p-5 text-left">
                        <p class="text-xs font-bold uppercase tracking-[0.25em] text-slate-400 mb-4 text-center">Optional Scenario Prefill</p>
                        <div class="grid gap-5 md:grid-cols-2">
                            <div>
                                <p class="text-xs font-bold uppercase tracking-widest text-slate-500 mb-3">Your Result</p>
                                <div class="grid grid-cols-2 gap-2">
                                    <label class="cursor-pointer" data-track-event="calculator_prefill_pick" data-track-label="result-between_2_and_4">
                                        <input type="radio" name="radonResultBand" value="between_2_and_4" class="peer sr-only">
                                        <div class="rounded-xl border border-white/10 bg-slate-950/40 px-3 py-3 text-center text-sm font-semibold text-slate-200 transition-all hover:border-amber-400/50 hover:bg-slate-900 peer-checked:border-amber-400 peer-checked:bg-amber-500/15 peer-checked:text-white">
                                            2.0-3.9
                                        </div>
                                    </label>
                                    <label class="cursor-pointer" data-track-event="calculator_prefill_pick" data-track-label="result-above_4">
                                        <input type="radio" name="radonResultBand" value="above_4" class="peer sr-only">
                                        <div class="rounded-xl border border-white/10 bg-slate-950/40 px-3 py-3 text-center text-sm font-semibold text-slate-200 transition-all hover:border-rose-400/50 hover:bg-slate-900 peer-checked:border-rose-400 peer-checked:bg-rose-500/15 peer-checked:text-white">
                                            4.0+
                                        </div>
                                    </label>
                                    <label class="cursor-pointer col-span-2" data-track-event="calculator_prefill_pick" data-track-label="result-not_tested">
                                        <input type="radio" name="radonResultBand" value="not_tested" class="peer sr-only">
                                        <div class="rounded-xl border border-white/10 bg-slate-950/40 px-3 py-3 text-center text-sm font-semibold text-slate-200 transition-all hover:border-emerald-400/50 hover:bg-slate-900 peer-checked:border-emerald-400 peer-checked:bg-emerald-500/15 peer-checked:text-white">
                                            Not tested yet
                                        </div>
                                    </label>
                                </div>
                            </div>
                            <div>
                                <p class="text-xs font-bold uppercase tracking-widest text-slate-500 mb-3">Your Goal</p>
                                <div class="grid grid-cols-3 gap-2">
                                    <label class="cursor-pointer" data-track-event="calculator_prefill_pick" data-track-label="intent-homeowner">
                                        <input type="radio" name="intent" value="homeowner" class="peer sr-only">
                                        <div class="rounded-xl border border-white/10 bg-slate-950/40 px-3 py-3 text-center text-sm font-semibold text-slate-200 transition-all hover:border-sky-400/50 hover:bg-slate-900 peer-checked:border-sky-400 peer-checked:bg-sky-500/15 peer-checked:text-white">
                                            Living here
                                        </div>
                                    </label>
                                    <label class="cursor-pointer" data-track-event="calculator_prefill_pick" data-track-label="intent-buying">
                                        <input type="radio" name="intent" value="buying" class="peer sr-only">
                                        <div class="rounded-xl border border-white/10 bg-slate-950/40 px-3 py-3 text-center text-sm font-semibold text-slate-200 transition-all hover:border-sky-400/50 hover:bg-slate-900 peer-checked:border-sky-400 peer-checked:bg-sky-500/15 peer-checked:text-white">
                                            Buying
                                        </div>
                                    </label>
                                    <label class="cursor-pointer" data-track-event="calculator_prefill_pick" data-track-label="intent-selling">
                                        <input type="radio" name="intent" value="selling" class="peer sr-only">
                                        <div class="rounded-xl border border-white/10 bg-slate-950/40 px-3 py-3 text-center text-sm font-semibold text-slate-200 transition-all hover:border-sky-400/50 hover:bg-slate-900 peer-checked:border-sky-400 peer-checked:bg-sky-500/15 peer-checked:text-white">
                                            Selling
                                        </div>
                                    </label>
                                </div>
                            </div>
                        </div>
                        <p class="mt-4 text-center text-sm text-slate-400">
                            Pick a scenario to open a county page already tuned for your next step.
                        </p>
                    </div>
                </form>
            </div>
        </div>

        <div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-16 -mt-24 relative z-20">
            <!-- National Average Receipt preview -->
            <div class="max-w-xl mx-auto mb-20">
                @template.components.receipt_card(receipt = defaultReceipt)
                <p class="text-center text-sm text-slate-500 mt-4 font-medium">Showing national budget context. Enter ZIP code for a county-level action plan.</p>
            </div>

            <!-- State Directory Hook -->
            <div class="mt-20">
                <div class="text-center mb-12">
                    <h2 class="font-display font-extrabold text-3xl text-slate-900 tracking-tight">Browse by State</h2>
                    <p class="mt-2 text-slate-500 font-medium">Select your state to find county-level decision pages, pricing context, and next-step guidance.</p>
                </div>
                
                <div class="grid grid-cols-2 sm:grid-cols-4 md:grid-cols-6 lg:grid-cols-8 gap-4 px-1 sm:px-0">
                    @for(String stateAbbr : stateMap.keySet())
                        <a href="/radon-mitigation-cost/${stateMap.get(stateAbbr).get(0).getStateSlug()}" 
                           class="flex min-h-[68px] flex-col items-center justify-center py-4 bg-white rounded-xl shadow-sm border border-slate-200 hover:border-brand-300 hover:shadow-md hover:bg-brand-50 transition-all group">
                            <span class="font-display font-bold text-slate-700 group-hover:text-brand-700 text-lg">${stateAbbr}</span>
                        </a>
                    @endfor
                </div>
            </div>
        </div>
    `
)


