@import com.radonverdict.model.dto.TestProtocolGuide
@import java.util.List

@param String title
@param List<TestProtocolGuide> guides
@param List<TestProtocolGuide> priorityGuides
@param List<String> guideCategories

@template.layout.main(
    title = title,
    canonicalUrl = "https://radonverdict.com/guides",
    description = "Twenty source-linked radon testing and mitigation-system guides for placement, timing, closed-house conditions, device handling, retesting, and maintenance.",
    content = @`
        <main class="bg-paper-light text-ink">
            <header class="border-b border-paper-rule bg-ink text-white">
                <div class="mx-auto max-w-7xl px-4 py-16 sm:px-6 sm:py-20 lg:px-8">
                    <p class="text-xs font-black uppercase tracking-[0.24em] text-signal">Radon test field manual · 20 guides</p>
                    <h1 class="mt-5 max-w-5xl font-display text-5xl font-bold leading-[.98] tracking-tight sm:text-6xl lg:text-7xl">Solve the exact problem in front of your test.</h1>
                    <p class="mt-6 max-w-3xl text-lg font-semibold leading-8 text-stone-300">Placement, windows, weather, device handling, retesting, manometers, and fan maintenance—each answer is separated by search intent and tied to the official source used.</p>
                    <div class="mt-9 flex flex-col gap-3 sm:flex-row">
                        <a class="inline-flex min-h-[54px] items-center justify-center rounded bg-signal px-6 text-sm font-black text-ink hover:bg-white" href="/radon-test-planner">Check my test procedure →</a>
                        <a class="inline-flex min-h-[54px] items-center justify-center rounded border border-stone-600 px-6 text-sm font-black text-white hover:border-white" href="/guides/how-to-test-for-radon">Read the complete testing guide</a>
                    </div>
                </div>
            </header>

            <div class="mx-auto max-w-7xl px-4 py-14 sm:px-6 sm:py-20 lg:px-8">
                <section class="grid gap-5 border-y-2 border-ink py-6 sm:grid-cols-3" aria-label="Library standards">
                    <div><p class="text-3xl font-display font-bold">${guides.size()}</p><p class="mt-1 text-sm font-bold text-stone-600">indexable problem pages</p></div>
                    <div><p class="text-3xl font-display font-bold">EPA + CDC</p><p class="mt-1 text-sm font-bold text-stone-600">primary-source backbone</p></div>
                    <div><p class="text-3xl font-display font-bold">One workflow</p><p class="mt-1 text-sm font-bold text-stone-600">every guide returns to the planner</p></div>
                </section>

                <section class="border-b-2 border-ink py-14" aria-labelledby="priority-guides-title">
                    <div class="grid gap-6 lg:grid-cols-[minmax(0,1fr)_minmax(0,2fr)] lg:items-end">
                        <div>
                            <p class="text-xs font-black uppercase tracking-[0.2em] text-pine">Start with a specific question</p>
                            <h2 id="priority-guides-title" class="mt-3 font-display text-4xl font-bold leading-tight sm:text-5xl">Five practical answers people need now.</h2>
                        </div>
                        <p class="max-w-2xl font-semibold leading-7 text-stone-600 lg:justify-self-end">These pages answer one task each: test timing, system upkeep, manometer status, a changing fan sound, or fan service life. Start with the symptom or deadline you actually have.</p>
                    </div>
                    <div class="mt-9 grid gap-3 lg:grid-cols-5">
                        @for (int i = 0; i < priorityGuides.size(); i++)
                            !{ final var guide = priorityGuides.get(i); }
                            <a class="group flex min-h-56 flex-col border-2 border-ink bg-white p-5 transition hover:-translate-y-1 hover:bg-ink hover:text-white" href="/guides/${guide.slug()}">
                                <span class="font-display text-3xl font-bold text-pine group-hover:text-signal">0${i + 1}</span>
                                <h3 class="mt-5 font-display text-xl font-bold leading-tight">${guide.title()}</h3>
                                <span class="mt-auto pt-5 text-sm font-black text-pine group-hover:text-signal">Open the field answer →</span>
                            </a>
                        @endfor
                    </div>
                </section>

                @for (var category : guideCategories)
                    <section class="border-b border-paper-rule py-14">
                        <div class="mb-8">
                            <p class="text-xs font-black uppercase tracking-[0.2em] text-pine">Search-intent cluster</p>
                            <h2 class="mt-2 font-display text-4xl font-bold">${category}</h2>
                        </div>
                        <div class="grid gap-px bg-paper-rule sm:grid-cols-2 lg:grid-cols-3">
                            @for (var guide : guides)
                                @if (guide.category().equals(category))
                                    <a class="group flex min-h-64 flex-col bg-white p-6 transition hover:bg-ink hover:text-white" href="/guides/${guide.slug()}">
                                        <p class="text-xs font-black uppercase tracking-[0.18em] text-pine group-hover:text-signal">${guide.eyebrow()}</p>
                                        <h3 class="mt-5 font-display text-2xl font-bold leading-tight">${guide.title()}</h3>
                                        <p class="mt-4 text-sm font-semibold leading-6 text-stone-600 group-hover:text-stone-300">${guide.description()}</p>
                                        <span class="mt-auto pt-6 text-sm font-black text-pine group-hover:text-signal">Read the answer →</span>
                                    </a>
                                @endif
                            @endfor
                        </div>
                    </section>
                @endfor

                <section class="mt-14 bg-pine px-7 py-10 text-white sm:px-10">
                    <p class="text-xs font-black uppercase tracking-[0.2em] text-signal">Do more than read</p>
                    <div class="mt-4 flex flex-col gap-7 lg:flex-row lg:items-end lg:justify-between">
                        <h2 class="max-w-3xl font-display text-4xl font-bold sm:text-5xl">Turn the rules into a test record you can review later.</h2>
                        <a class="inline-flex min-h-[54px] shrink-0 items-center justify-center rounded bg-signal px-6 text-sm font-black text-ink hover:bg-white" href="/radon-test-planner">Start the planner →</a>
                    </div>
                </section>
            </div>
        </main>
    `
)
