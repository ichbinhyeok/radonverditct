@import com.radonverdict.model.dto.AeoAnswerBlock
@import com.radonverdict.model.dto.TrustMetadata

@param String title
@param AeoAnswerBlock aeo = null
@param TrustMetadata trust = null

@template.layout.main(
    title = title,
    canonicalUrl = "https://radonverdict.com/guides/how-to-test-for-radon",
    description = "Test a home for radon with a source-linked workflow for choosing a device, placing it, maintaining test conditions, returning it, and reviewing the record.",
    articlePublished = "2026-02-26",
    articleModified = "2026-09-05",
    headContent = @`
        <script type="application/ld+json">
        {
          "@context":"https://schema.org",
          "@type": "Article",
          "headline":"How to Test for Radon at Home",
          "description":"A source-linked workflow for choosing, placing, running, returning, and reviewing a home radon test.",
          "datePublished":"2026-02-26",
          "dateModified":"2026-09-05",
          "mainEntityOfPage":"https://radonverdict.com/guides/how-to-test-for-radon",
          "author":{"@type":"Organization","name":"RadonVerdict","url":"https://radonverdict.com/about"},
          "publisher":{"@type":"Organization","name":"RadonVerdict","url":"https://radonverdict.com/"}
        }
        </script>
        <script type="application/ld+json">
        {
          "@context":"https://schema.org",
          "@type":"HowTo",
          "name":"How to Test a Home for Radon",
          "step":[
            {"@type":"HowToStep","name":"Define the decision","text":"Identify whether this is routine screening, a real-estate transaction, or verification after mitigation."},
            {"@type":"HowToStep","name":"Choose the test","text":"Select a device whose instructions and exposure window fit the decision."},
            {"@type":"HowToStep","name":"Place and document it","text":"Use the lowest regularly occupied level and follow the device-specific placement instructions."},
            {"@type":"HowToStep","name":"Maintain the required conditions","text":"Record start and stop times and any event that could affect the procedure."},
            {"@type":"HowToStep","name":"Close and review the record","text":"Return or retrieve the device as instructed, then review procedure context before interpreting the number."}
          ]
        }
        </script>
        <style>
            .testing-hero-image { animation: testing-image-in .8s cubic-bezier(.2,.75,.25,1) both; }
            .testing-hero-copy > * { animation: testing-copy-in .55s cubic-bezier(.2,.75,.25,1) both; }
            .testing-hero-copy > *:nth-child(2) { animation-delay: .08s; }
            .testing-hero-copy > *:nth-child(3) { animation-delay: .16s; }
            @keyframes testing-image-in { from { opacity: 0; transform: scale(1.035); } to { opacity: 1; transform: none; } }
            @keyframes testing-copy-in { from { opacity: 0; transform: translateY(14px); } to { opacity: 1; transform: none; } }
            @media (prefers-reduced-motion: reduce) { .testing-hero-image, .testing-hero-copy > * { animation: none; } }
        </style>
    `,
    content = @`
        <article class="bg-paper-light text-ink">
            <header class="relative isolate flex min-h-[500px] items-end overflow-hidden bg-ink">
                <img class="testing-hero-image absolute inset-0 -z-20 h-full w-full object-cover opacity-40" src="/images/radon-test-editorial-hero-v1.webp" alt="A radon test device placed in a lived-in room" width="1600" height="1000">
                <div class="absolute inset-0 -z-10 bg-gradient-to-r from-ink via-ink/90 to-ink/20"></div>
                <div class="testing-hero-copy mx-auto w-full max-w-7xl px-4 pb-12 pt-24 sm:px-6 sm:pb-16 lg:px-8">
                    <p class="text-xs font-black uppercase tracking-[0.24em] text-signal">Radon test field manual · source-linked</p>
                    <h1 class="mt-5 max-w-4xl font-display text-5xl font-bold leading-[.98] tracking-tight text-white sm:text-6xl lg:text-7xl">How to test for radon at home</h1>
                    <p class="mt-6 max-w-2xl text-lg font-semibold leading-relaxed text-stone-200">Choose the test, preserve the conditions, and keep a record that still makes sense when the result arrives.</p>
                </div>
            </header>

            <div class="mx-auto max-w-5xl px-4 py-12 sm:px-6 sm:py-16 lg:px-8">
                <section class="border-l-8 border-signal bg-ink px-6 py-7 text-white sm:px-8">
                    <p class="text-xs font-black uppercase tracking-[0.2em] text-signal">Direct answer</p>
                    <p class="mt-4 font-display text-2xl font-bold leading-snug sm:text-3xl">Define why you are testing, choose a device that fits that decision, place it on the lowest regularly occupied level, follow its exact timing and condition instructions, then preserve the procedure record with the result.</p>
                </section>

                <p class="mt-6 text-sm font-semibold leading-relaxed text-stone-500">Reviewed September 5, 2026. United States federal guidance. The device instructions, laboratory directions, transaction protocol, and applicable state requirements take precedence.</p>

                @if(aeo != null)
                    <div class="mt-8">@template.components.aeo_answer_block(block = aeo)</div>
                @endif

                <section class="mt-12 border-y-2 border-ink py-8">
                    <p class="text-xs font-black uppercase tracking-[0.2em] text-pine">Start with the decision</p>
                    <h2 class="mt-3 font-display text-4xl font-bold">One test does not serve every context</h2>
                    <div class="mt-7 divide-y divide-paper-rule border-y border-paper-rule">
                        <div class="grid gap-2 py-5 sm:grid-cols-[180px_1fr]"><h3 class="font-display text-xl font-bold text-pine">Routine screening</h3><p class="font-semibold leading-7 text-stone-700">Choose between a faster short-term answer and a longer measurement that better represents variation over time.</p></div>
                        <div class="grid gap-2 py-5 sm:grid-cols-[180px_1fr]"><h3 class="font-display text-xl font-bold text-pine">Home transaction</h3><p class="font-semibold leading-7 text-stone-700">Use the applicable transaction protocol. Timing, closed-house conditions, tamper controls, and who performs the test can matter.</p></div>
                        <div class="grid gap-2 py-5 sm:grid-cols-[180px_1fr]"><h3 class="font-display text-xl font-bold text-pine">After mitigation</h3><p class="font-semibold leading-7 text-stone-700">Verify the installed system with an indoor measurement and retain the post-mitigation report with the system record.</p></div>
                    </div>
                </section>

                <section class="py-12">
                    <p class="text-xs font-black uppercase tracking-[0.2em] text-pine">Five-step workflow</p>
                    <h2 class="mt-3 font-display text-4xl font-bold">Run a test someone else can review</h2>
                    <ol class="mt-8 divide-y divide-paper-rule border-y-2 border-ink">
                        <li class="grid gap-4 py-7 sm:grid-cols-[64px_1fr]"><span class="font-display text-4xl font-bold text-pine">01</span><div><h3 class="font-display text-2xl font-bold">Choose the time horizon</h3><p class="mt-3 font-semibold leading-7 text-stone-700">CDC defines short-term tests as 2–90 days and long-term tests as more than 90 days. The exact allowed exposure still comes from the selected device. A continuous monitor is not automatically the right answer merely because it displays more readings.</p><a class="mt-3 inline-flex font-black text-pine underline decoration-2 underline-offset-4" href="/guides/short-term-vs-long-term-radon-test">Compare duration and total turnaround →</a></div></li>
                        <li class="grid gap-4 py-7 sm:grid-cols-[64px_1fr]"><span class="font-display text-4xl font-bold text-pine">02</span><div><h3 class="font-display text-2xl font-bold">Place the device deliberately</h3><p class="mt-3 font-semibold leading-7 text-stone-700">Use the lowest level people occupy regularly and select a normal living area. Avoid improvising universal height or clearance numbers: record the kit or monitor model and follow its supplied instructions.</p><a class="mt-3 inline-flex font-black text-pine underline decoration-2 underline-offset-4" href="/guides/where-to-place-radon-test">Choose the floor, room, and position →</a></div></li>
                        <li class="grid gap-4 py-7 sm:grid-cols-[64px_1fr]"><span class="font-display text-4xl font-bold text-pine">03</span><div><h3 class="font-display text-2xl font-bold">Preserve the required conditions</h3><p class="mt-3 font-semibold leading-7 text-stone-700">Record windows, exterior doors, outdoor-air equipment, HVAC state, weather, and occupancy when the protocol makes them relevant. EPA's 12-hour closed-house rule cited here belongs to short real-estate testing; it is not a substitute for every device's instructions.</p><a class="mt-3 inline-flex font-black text-pine underline decoration-2 underline-offset-4" href="/guides/radon-closed-house-conditions">Review closed-house conditions →</a></div></li>
                        <li class="grid gap-4 py-7 sm:grid-cols-[64px_1fr]"><span class="font-display text-4xl font-bold text-pine">04</span><div><h3 class="font-display text-2xl font-bold">Record exact time and incidents</h3><p class="mt-3 font-semibold leading-7 text-stone-700">Keep start and stop timestamps, not just dates. Note movement, covering, unplugging, a power outage, an opened window, severe weather, or any other event without trying to erase the uncertainty.</p><a class="mt-3 inline-flex font-black text-pine underline decoration-2 underline-offset-4" href="/guides/is-my-radon-test-valid">Check the procedure record →</a></div></li>
                        <li class="grid gap-4 py-7 sm:grid-cols-[64px_1fr]"><span class="font-display text-4xl font-bold text-pine">05</span><div><h3 class="font-display text-2xl font-bold">Close, return, and interpret in order</h3><p class="mt-3 font-semibold leading-7 text-stone-700">Seal and return a passive kit by the laboratory deadline, or save the monitor/tester report. Review test type, duration, placement, and conditions before treating the number as a complete decision.</p><a class="mt-3 inline-flex font-black text-pine underline decoration-2 underline-offset-4" href="/radon-test-result-meaning">Review a radon test result →</a></div></li>
                    </ol>
                </section>

                <section class="border-y-2 border-ink py-10">
                    <div class="grid gap-7 lg:grid-cols-[1fr_auto] lg:items-end">
                        <div><p class="text-xs font-black uppercase tracking-[0.2em] text-pine">Interactive record</p><h2 class="mt-3 font-display text-4xl font-bold">Do not reconstruct the test from memory</h2><p class="mt-4 max-w-2xl font-semibold leading-7 text-stone-700">The planner records device, purpose, timestamps, placement, conditions, and incidents, then shows which facts need verification against published rules.</p></div>
                        <a href="/radon-test-planner" class="inline-flex min-h-[54px] items-center justify-center bg-ink px-6 text-sm font-black text-white transition hover:bg-pine">Build the test record →</a>
                    </div>
                </section>

                <section class="py-12">
                    <p class="text-xs font-black uppercase tracking-[0.2em] text-pine">Resolve one problem at a time</p>
                    <h2 class="mt-3 font-display text-4xl font-bold">Testing procedure library</h2>
                    <div class="mt-7 grid gap-px bg-paper-rule sm:grid-cols-2">
                        <a class="bg-white p-5 font-bold hover:bg-paper" href="/guides/can-you-open-windows-during-radon-test">A window was opened →</a>
                        <a class="bg-white p-5 font-bold hover:bg-paper" href="/guides/can-you-live-in-house-during-radon-test">People or pets stayed home →</a>
                        <a class="bg-white p-5 font-bold hover:bg-paper" href="/guides/radon-test-during-rain-or-storm">Rain, wind, or a storm occurred →</a>
                        <a class="bg-white p-5 font-bold hover:bg-paper" href="/guides/radon-test-moved-or-tampered">The device moved or lost power →</a>
                        <a class="bg-white p-5 font-bold hover:bg-paper" href="/guides/expired-radon-test-kit">The kit may be expired →</a>
                        <a class="bg-white p-5 font-bold hover:bg-paper" href="/guides/how-to-mail-radon-test-kit">The kit must reach a laboratory →</a>
                        <a class="bg-white p-5 font-bold hover:bg-paper" href="/guides/radon-testing-in-apartments">The home is an apartment or condo →</a>
                        <a class="bg-white p-5 font-bold hover:bg-paper" href="/guides/radon-test-after-renovation">The building recently changed →</a>
                        <a class="bg-white p-5 font-bold hover:bg-paper" href="/guides/when-to-retest-for-radon">A new test may be needed →</a>
                        <a class="bg-white p-5 font-bold hover:bg-paper" href="/guides/charcoal-vs-digital-radon-test">Choose passive kit or monitor →</a>
                    </div>
                    <a class="mt-6 inline-flex font-black text-pine underline decoration-2 underline-offset-4" href="/guides">Browse all testing and system guides →</a>
                </section>

                <section class="border-t-2 border-ink py-12">
                    <p class="text-xs font-black uppercase tracking-[0.2em] text-pine">Primary guidance</p>
                    <h2 class="mt-3 font-display text-4xl font-bold">Sources used for this workflow</h2>
                    <div class="mt-7 divide-y divide-paper-rule border-y border-paper-rule">
                        <a class="grid gap-2 py-5 sm:grid-cols-[1fr_auto] sm:items-center" href="https://www.cdc.gov/radon/testing/index.html" rel="noopener" target="_blank"><span><strong class="block text-lg">Testing for Radon in Your Home</strong><small class="mt-1 block font-semibold text-stone-500">Centers for Disease Control and Prevention · test types, duration, placement, and retesting</small></span><span class="text-xl font-black text-pine" aria-hidden="true">↗</span></a>
                        <a class="grid gap-2 py-5 sm:grid-cols-[1fr_auto] sm:items-center" href="https://www.epa.gov/sites/default/files/2016-12/documents/2016_a_citizens_guide_to_radon.pdf" rel="noopener" target="_blank"><span><strong class="block text-lg">A Citizen's Guide to Radon</strong><small class="mt-1 block font-semibold text-stone-500">U.S. Environmental Protection Agency · residential testing and follow-up</small></span><span class="text-xl font-black text-pine" aria-hidden="true">↗</span></a>
                        <a class="grid gap-2 py-5 sm:grid-cols-[1fr_auto] sm:items-center" href="https://www.epa.gov/sites/default/files/2015-05/documents/hmbuygud.pdf" rel="noopener" target="_blank"><span><strong class="block text-lg">Home Buyer's and Seller's Guide to Radon</strong><small class="mt-1 block font-semibold text-stone-500">U.S. Environmental Protection Agency · transaction testing and closed-house conditions</small></span><span class="text-xl font-black text-pine" aria-hidden="true">↗</span></a>
                    </div>
                </section>

                @if(trust != null)
                    @template.components.trust_metadata(trust = trust)
                @endif
            </div>
        </article>
    `
)
