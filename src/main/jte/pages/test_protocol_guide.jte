@import com.radonverdict.model.dto.TestProtocolGuide
@import com.radonverdict.util.JsonLdUtils

@param TestProtocolGuide guide

!{ final String canonicalUrl = "https://radonverdict.com/guides/" + guide.slug(); }

@template.layout.main(
    title = guide.seoTitle(),
    canonicalUrl = canonicalUrl,
    description = guide.description(),
    articlePublished = "2026-09-05",
    articleModified = "2026-09-05",
    headContent = @`
        <script src="/js/seo-decision-tools.js" defer></script>
        <script type="application/ld+json">
        {
          "@context":"https://schema.org",
          "@type":"FAQPage",
          "mainEntity":[
            @for (int i = 0; i < guide.faqs().size(); i++)
              !{ final var faq = guide.faqs().get(i); }
              {"@type":"Question","name":$unsafe{JsonLdUtils.json(faq.question())},"acceptedAnswer":{"@type":"Answer","text":$unsafe{JsonLdUtils.json(faq.answer())}}}@if(i < guide.faqs().size() - 1),@endif
            @endfor
          ]
        }
        </script>
        <script type="application/ld+json">
        {"@context":"https://schema.org","@type":"BreadcrumbList","itemListElement":[
          {"@type":"ListItem","position":1,"name":"Home","item":"https://radonverdict.com/"},
          {"@type":"ListItem","position":2,"name":"Radon testing guide","item":"https://radonverdict.com/guides/how-to-test-for-radon"},
          {"@type":"ListItem","position":3,"name":$unsafe{JsonLdUtils.json(guide.title())},"item":$unsafe{JsonLdUtils.json(canonicalUrl)}}
        ]}
        </script>
        <script type="application/ld+json">
        {
          "@context":"https://schema.org",
          "@type":"Article",
          "headline":$unsafe{JsonLdUtils.json(guide.title())},
          "description":$unsafe{JsonLdUtils.json(guide.description())},
          "datePublished":"2026-09-05",
          "dateModified":"2026-09-05",
          "mainEntityOfPage":$unsafe{JsonLdUtils.json(canonicalUrl)},
          "author":{"@type":"Organization","name":"RadonVerdict","url":"https://radonverdict.com/about"},
          "publisher":{"@type":"Organization","name":"RadonVerdict","url":"https://radonverdict.com/"}
        }
        </script>
        <style>
            .protocol-hero { min-height: 440px; }
            .protocol-hero-image { animation: protocol-image-in .8s cubic-bezier(.2,.75,.25,1) both; }
            .protocol-hero-copy > * { animation: protocol-copy-in .55s cubic-bezier(.2,.75,.25,1) both; }
            .protocol-hero-copy > *:nth-child(2) { animation-delay: .08s; }
            .protocol-hero-copy > *:nth-child(3) { animation-delay: .16s; }
            .protocol-source:hover .protocol-source-arrow { transform: translate(3px,-3px); }
            .manometer-tube { fill: none; stroke: currentColor; stroke-linecap: round; stroke-linejoin: round; stroke-width: 12; }
            .manometer-fluid { fill: none; stroke: #ef5b35; stroke-linecap: round; stroke-linejoin: round; stroke-width: 8; }
            @keyframes protocol-image-in { from { opacity: 0; transform: scale(1.035); } to { opacity: 1; transform: none; } }
            @keyframes protocol-copy-in { from { opacity: 0; transform: translateY(14px); } to { opacity: 1; transform: none; } }
            @media (prefers-reduced-motion: reduce) { .protocol-hero-image, .protocol-hero-copy > * { animation: none; } }
        </style>
    `,
    content = @`
        <article class="bg-paper-light text-ink">
            <header class="protocol-hero relative isolate flex items-end overflow-hidden bg-ink">
                <img class="protocol-hero-image absolute inset-0 -z-20 h-full w-full object-cover opacity-40" src="/images/radon-test-editorial-hero-v1.webp" alt="A radon testing device placed inside a home" width="1600" height="1000">
                <div class="absolute inset-0 -z-10 bg-gradient-to-r from-ink via-ink/90 to-ink/20"></div>
                <div class="protocol-hero-copy mx-auto w-full max-w-7xl px-4 pb-12 pt-20 sm:px-6 sm:pb-16 lg:px-8">
                    <p class="text-xs font-black uppercase tracking-[0.24em] text-signal">${guide.eyebrow()} · source-linked</p>
                    <h1 class="mt-5 max-w-4xl font-display text-5xl font-bold leading-[.98] tracking-tight text-white sm:text-6xl lg:text-7xl">${guide.title()}</h1>
                    <p class="mt-6 max-w-2xl text-lg font-semibold leading-relaxed text-stone-200">${guide.description()}</p>
                </div>
            </header>

            <div class="mx-auto grid max-w-7xl gap-12 px-4 py-12 sm:px-6 sm:py-16 lg:grid-cols-[230px_minmax(0,760px)] lg:px-8">
                <aside class="hidden lg:block">
                    <div class="sticky top-28 border-t-2 border-ink pt-5">
                        <p class="text-xs font-black uppercase tracking-[0.2em] text-pine">On this page</p>
                        <nav class="mt-5" aria-label="Article sections">
                            <ol class="space-y-4 text-sm font-bold leading-snug text-stone-600">
                                @for (var section : guide.sections())
                                    <li><a class="border-b border-transparent hover:border-pine hover:text-pine" href="#${section.id()}">${section.heading()}</a></li>
                                @endfor
                                <li><a class="border-b border-transparent hover:border-pine hover:text-pine" href="#checklist">Build a procedure record</a></li>
                                <li><a class="border-b border-transparent hover:border-pine hover:text-pine" href="#sources">Official sources</a></li>
                            </ol>
                        </nav>
                    </div>
                </aside>

                <div>
                    <section class="border-l-8 border-signal bg-ink px-6 py-7 text-white sm:px-8">
                        <p class="text-xs font-black uppercase tracking-[0.2em] text-signal">Direct answer</p>
                        <p class="mt-4 font-display text-2xl font-bold leading-snug sm:text-3xl">${guide.directAnswer()}</p>
                    </section>

                    <p class="mt-6 text-sm font-semibold leading-relaxed text-stone-500">Reviewed September 5, 2026. United States federal guidance. Device instructions and applicable state requirements take precedence.</p>

                    <section class="mt-8 grid gap-5 border-y border-paper-rule py-5 text-sm sm:grid-cols-2" aria-label="Evidence standard">
                        <div><p class="font-black uppercase tracking-wider text-pine">Evidence standard</p><p class="mt-1 font-semibold text-stone-600">Built from the official primary guidance linked on this page.</p></div>
                        <div><p class="font-black uppercase tracking-wider text-pine">Source check</p><p class="mt-1 font-semibold text-stone-600">Reviewed September 5, 2026 · maintained by <a class="underline" href="/about">RadonVerdict</a>.</p></div>
                    </section>

                    @if ("short-term-vs-long-term-radon-test".equals(guide.slug()))
                        <section class="mt-10 border-2 border-ink bg-white" aria-labelledby="duration-timeline-title">
                            <div class="border-b-2 border-ink px-6 py-5">
                                <p class="text-xs font-black uppercase tracking-[0.2em] text-pine">Start-to-result timeline</p>
                                <h2 id="duration-timeline-title" class="mt-2 font-display text-3xl font-bold">Count every stage—not only the hours in the room</h2>
                            </div>
                            <ol class="grid gap-px bg-paper-rule sm:grid-cols-2 lg:grid-cols-4">
                                <li class="bg-white p-5"><span class="font-display text-3xl font-bold text-pine">01</span><h3 class="mt-3 font-display text-xl font-bold">Choose</h3><p class="mt-2 text-sm font-semibold leading-6 text-stone-600">Match the device to the decision deadline and read its allowed exposure window.</p></li>
                                <li class="bg-white p-5"><span class="font-display text-3xl font-bold text-pine">02</span><h3 class="mt-3 font-display text-xl font-bold">Measure</h3><p class="mt-2 text-sm font-semibold leading-6 text-stone-600">Short-term: 2–90 days. Long-term: more than 90 days. The device sets the exact time.</p></li>
                                <li class="bg-white p-5"><span class="font-display text-3xl font-bold text-pine">03</span><h3 class="mt-3 font-display text-xl font-bold">Return</h3><p class="mt-2 text-sm font-semibold leading-6 text-stone-600">A passive kit may need sealing and prompt mailing; a tester may retrieve a monitor.</p></li>
                                <li class="bg-white p-5"><span class="font-display text-3xl font-bold text-pine">04</span><h3 class="mt-3 font-display text-xl font-bold">Receive</h3><p class="mt-2 text-sm font-semibold leading-6 text-stone-600">Add the laboratory or reporting turnaround before promising a decision date.</p></li>
                            </ol>
                            <form id="radon-result-timeline-form" class="border-t-2 border-ink p-6" aria-labelledby="timeline-form-title">
                                <h3 id="timeline-form-title" class="font-display text-2xl font-bold">Estimate when the report can be ready</h3>
                                <p class="mt-2 text-sm font-semibold leading-6 text-stone-600">Enter the exposure required by your device and the return times supplied by the laboratory. This calculator does not choose a protocol for you.</p>
                                <div class="mt-5 grid gap-4 sm:grid-cols-2">
                                    <label class="text-sm font-black">Test starts<input id="timeline-start" class="mt-2 min-h-12 w-full border-2 border-ink bg-white px-3" type="datetime-local" required></label>
                                    <label class="text-sm font-black">Required exposure, hours<input id="timeline-exposure-hours" class="mt-2 min-h-12 w-full border-2 border-ink bg-white px-3" type="number" min="1" max="8760" inputmode="numeric" required></label>
                                    <label class="text-sm font-black">Return or pickup, days<input id="timeline-transit-days" class="mt-2 min-h-12 w-full border-2 border-ink bg-white px-3" type="number" min="0" max="60" value="0" inputmode="numeric"></label>
                                    <label class="text-sm font-black">Laboratory/reporting, days<input id="timeline-lab-days" class="mt-2 min-h-12 w-full border-2 border-ink bg-white px-3" type="number" min="0" max="60" value="0" inputmode="numeric"></label>
                                </div>
                                <button class="mt-5 min-h-12 bg-ink px-5 text-sm font-black text-white hover:bg-pine" type="submit">Calculate the timeline</button>
                                <output id="radon-result-timeline-output" class="mt-5 block border-l-8 border-signal bg-paper-light p-5" hidden>
                                    <span class="block text-xs font-black uppercase tracking-wider text-pine">Recorded estimate</span>
                                    <strong class="mt-2 block text-lg">Exposure ends: <span id="timeline-exposure-result"></span></strong>
                                    <strong class="mt-1 block text-lg">Report estimate: <span id="timeline-report-result"></span></strong>
                                    <span id="timeline-total-result" class="mt-2 block text-sm font-bold text-stone-600"></span>
                                </output>
                            </form>
                        </section>
                    @endif

                    @if ("radon-manometer-reading".equals(guide.slug()))
                        <section class="mt-10 border-2 border-ink bg-white" aria-labelledby="manometer-visual-title">
                            <div class="border-b-2 border-ink px-6 py-5">
                                <p class="text-xs font-black uppercase tracking-[0.2em] text-pine">Ten-second visual check</p>
                                <h2 id="manometer-visual-title" class="mt-2 font-display text-3xl font-bold">Read the shape, then compare the baseline</h2>
                                <p class="mt-3 max-w-2xl font-semibold leading-7 text-stone-600">The drawing is a status guide, not a target pressure chart. Your installer's mark and an indoor radon test are the controlling evidence.</p>
                            </div>
                            <div class="grid gap-px bg-paper-rule sm:grid-cols-3">
                                <div class="bg-white p-6">
                                    <svg class="mx-auto h-32 w-32 text-ink" viewBox="0 0 120 120" role="img" aria-label="Uneven manometer columns near the installer baseline"><path class="manometer-tube" d="M28 18v58a32 32 0 0 0 64 0V18"/><path class="manometer-fluid" d="M32 48v28a28 28 0 0 0 56 0V72"/><path d="M18 48h20M82 72h20" stroke="#1e6b55" stroke-width="3"/></svg>
                                    <h3 class="mt-4 font-display text-xl font-bold">Uneven, near the mark</h3><p class="mt-2 text-sm font-semibold leading-6 text-stone-600">The system is showing a pressure difference. Record it, but do not treat it as a radon concentration.</p>
                                </div>
                                <div class="bg-white p-6">
                                    <svg class="mx-auto h-32 w-32 text-ink" viewBox="0 0 120 120" role="img" aria-label="Level manometer columns showing no measured pressure difference"><path class="manometer-tube" d="M28 18v58a32 32 0 0 0 64 0V18"/><path class="manometer-fluid" d="M32 66v10a28 28 0 0 0 56 0V66"/><path d="M18 66h84" stroke="#1e6b55" stroke-width="3"/></svg>
                                    <h3 class="mt-4 font-display text-xl font-bold">Equal or zero</h3><p class="mt-2 text-sm font-semibold leading-6 text-stone-600">No pressure difference is being displayed. Check the system record and contact the installer or a qualified mitigator.</p>
                                </div>
                                <div class="bg-white p-6">
                                    <svg class="mx-auto h-32 w-32 text-ink" viewBox="0 0 120 120" role="img" aria-label="Changed manometer reading compared with the installer baseline"><path class="manometer-tube" d="M28 18v58a32 32 0 0 0 64 0V18"/><path class="manometer-fluid" d="M32 34v42a28 28 0 0 0 56 0V86"/><path d="M18 56h20M82 64h20" stroke="#1e6b55" stroke-width="3" stroke-dasharray="5 4"/></svg>
                                    <h3 class="mt-4 font-display text-xl font-bold">Changed or damaged</h3><p class="mt-2 text-sm font-semibold leading-6 text-stone-600">A material change, missing fluid, loose tube, or alarm is a service signal—not a diagnosis to repair from a web page.</p>
                                </div>
                            </div>
                            <form id="manometer-baseline-form" class="border-t-2 border-ink p-6" aria-labelledby="manometer-form-title">
                                <h3 id="manometer-form-title" class="font-display text-2xl font-bold">Compare this observation with the installed baseline</h3>
                                <div class="mt-5 grid gap-4 sm:grid-cols-3">
                                    <label class="text-sm font-black">Baseline record<select id="manometer-baseline" class="mt-2 min-h-12 w-full border-2 border-ink bg-white px-3"><option value="known">Installer mark is available</option><option value="unknown">No baseline found</option></select></label>
                                    <label class="text-sm font-black">Current observation<select id="manometer-current" class="mt-2 min-h-12 w-full border-2 border-ink bg-white px-3"><option value="matches">Uneven and near the mark</option><option value="changed">Uneven but changed</option><option value="level">Columns level or zero</option><option value="damaged">Fluid or tube damaged</option><option value="alarm">Warning alarm active</option></select></label>
                                    <label class="text-sm font-black">Observed at<input id="manometer-observed-at" class="mt-2 min-h-12 w-full border-2 border-ink bg-white px-3" type="datetime-local"></label>
                                </div>
                                <button class="mt-5 min-h-12 bg-ink px-5 text-sm font-black text-white hover:bg-pine" type="submit">Create the observation record</button>
                                <output id="manometer-baseline-output" class="mt-5 block border-l-8 border-signal bg-paper-light p-5" hidden><strong id="manometer-record-result" class="block text-lg leading-7"></strong><span id="manometer-record-time" class="mt-2 block text-sm font-bold text-stone-600"></span></output>
                            </form>
                        </section>
                    @endif

                    @if ("radon-mitigation-system-maintenance".equals(guide.slug()))
                        <section class="mt-10 border-2 border-ink bg-white" aria-labelledby="maintenance-calendar-title">
                            <div class="border-b-2 border-ink px-6 py-5">
                                <p class="text-xs font-black uppercase tracking-[0.2em] text-pine">Owner maintenance calendar</p>
                                <h2 id="maintenance-calendar-title" class="mt-2 font-display text-3xl font-bold">Three moments that should already be on the record</h2>
                            </div>
                            <div class="divide-y divide-paper-rule">
                                <div class="grid gap-2 p-6 sm:grid-cols-[170px_1fr]"><h3 class="font-display text-xl font-bold text-pine">Regularly</h3><p class="font-semibold leading-7 text-stone-700">Check the warning device against the installer mark or instructions. EPA says to check it regularly; use the interval in your system documentation rather than inventing a universal schedule.</p></div>
                                <div class="grid gap-2 p-6 sm:grid-cols-[170px_1fr]"><h3 class="font-display text-xl font-bold text-pine">After a change</h3><p class="font-semibold leading-7 text-stone-700">Record alarms, new noise, vibration, visible damage, repairs, fan service, renovations, and the new warning-device baseline.</p></div>
                                <div class="grid gap-2 p-6 sm:grid-cols-[170px_1fr]"><h3 class="font-display text-xl font-bold text-pine">At least every 2 years</h3><p class="font-semibold leading-7 text-stone-700">Retest indoor radon as EPA advises. A moving manometer or audible fan cannot verify the radon concentration in the room.</p></div>
                            </div>
                        </section>
                    @endif

                    @if ("radon-fan-noise".equals(guide.slug()))
                        <section class="mt-10 border-2 border-ink bg-white" aria-labelledby="fan-noise-record-title">
                            <div class="border-b-2 border-ink px-6 py-5">
                                <p class="text-xs font-black uppercase tracking-[0.2em] text-pine">Two-minute observation record</p>
                                <h2 id="fan-noise-record-title" class="mt-2 font-display text-3xl font-bold">Describe the change without guessing the repair</h2>
                                <p class="mt-3 max-w-2xl font-semibold leading-7 text-stone-600">Use these observations when you contact the installer. Sound alone cannot identify a failed component.</p>
                            </div>
                            <dl class="grid gap-px bg-paper-rule sm:grid-cols-2">
                                <div class="bg-white p-6"><dt class="font-display text-xl font-bold">Sound pattern</dt><dd class="mt-2 text-sm font-semibold leading-6 text-stone-600">Hum, rattle, vibration, gurgle, silence, or intermittent change—and when it began.</dd></div>
                                <div class="bg-white p-6"><dt class="font-display text-xl font-bold">System indicator</dt><dd class="mt-2 text-sm font-semibold leading-6 text-stone-600">Current manometer or alarm status compared with the installer-marked baseline.</dd></div>
                                <div class="bg-white p-6"><dt class="font-display text-xl font-bold">Conditions</dt><dd class="mt-2 text-sm font-semibold leading-6 text-stone-600">Rain, freezing weather, visible vibration, recent work, or another repeatable trigger.</dd></div>
                                <div class="bg-white p-6"><dt class="font-display text-xl font-bold">Identification</dt><dd class="mt-2 text-sm font-semibold leading-6 text-stone-600">Fan model, approximate install date, warranty record, and installer's contact details.</dd></div>
                            </dl>
                            <p class="border-t-2 border-ink bg-signal/25 px-6 py-4 text-sm font-black leading-6">Keep the system running unless qualified guidance or an immediate electrical, structural, or water hazard requires otherwise.</p>
                            <form id="fan-noise-observation-form" class="border-t-2 border-ink p-6" aria-labelledby="fan-noise-form-title">
                                <h3 id="fan-noise-form-title" class="font-display text-2xl font-bold">Build a service-call note</h3>
                                <div class="mt-5 grid gap-4 sm:grid-cols-2">
                                    <label class="text-sm font-black">What changed?<select id="fan-noise-sound" class="mt-2 min-h-12 w-full border-2 border-ink bg-white px-3"><option>new humming</option><option>rattle or vibration</option><option>gurgling</option><option>intermittent sound</option><option>fan became silent</option><option>other change</option></select></label>
                                    <label class="text-sm font-black">Indicator status<select id="fan-noise-indicator" class="mt-2 min-h-12 w-full border-2 border-ink bg-white px-3"><option value="baseline">near installed baseline</option><option value="changed">changed from baseline</option><option value="level">level or zero</option><option value="alarm">alarm active</option><option value="unknown">unknown</option></select></label>
                                    <label class="text-sm font-black sm:col-span-2">When does it happen?<input id="fan-noise-timing" class="mt-2 min-h-12 w-full border-2 border-ink bg-white px-3" type="text" maxlength="160" placeholder="Example: after heavy rain, began Friday evening"></label>
                                </div>
                                <fieldset class="mt-5"><legend class="text-sm font-black">Conditions observed</legend><div class="mt-3 grid gap-3 text-sm font-bold sm:grid-cols-2"><label><input type="checkbox" name="noise-condition" value="recent rain or freezing"> Recent rain or freezing</label><label><input type="checkbox" name="noise-condition" value="visible vibration"> Visible vibration</label><label><input type="checkbox" name="noise-condition" value="visible damage"> Visible damage</label><label><input type="checkbox" name="noise-condition" value="electrical concern"> Electrical concern</label></div></fieldset>
                                <button class="mt-5 min-h-12 bg-ink px-5 text-sm font-black text-white hover:bg-pine" type="submit">Create the service note</button>
                                <output id="fan-noise-observation-output" class="mt-5 block border-l-8 border-signal bg-paper-light p-5" hidden><strong id="fan-noise-summary" class="block text-lg leading-7"></strong><span id="fan-noise-next-step" class="mt-3 block text-sm font-bold leading-6 text-stone-700"></span></output>
                            </form>
                        </section>
                    @endif

                    @if ("how-long-do-radon-fans-last".equals(guide.slug()))
                        <section class="mt-10 border-2 border-ink bg-white" aria-labelledby="fan-life-record-title">
                            <div class="border-b-2 border-ink px-6 py-5">
                                <p class="text-xs font-black uppercase tracking-[0.2em] text-pine">Service-life record</p>
                                <h2 id="fan-life-record-title" class="mt-2 font-display text-3xl font-bold">Age is one fact—not the diagnosis</h2>
                            </div>
                            <div class="grid gap-px bg-paper-rule sm:grid-cols-2 lg:grid-cols-4">
                                <div class="bg-white p-5"><span class="font-display text-3xl font-bold text-pine">01</span><h3 class="mt-3 font-display text-lg font-bold">Identify</h3><p class="mt-2 text-sm font-semibold leading-6 text-stone-600">Record model, install date, installer, and warranty.</p></div>
                                <div class="bg-white p-5"><span class="font-display text-3xl font-bold text-pine">02</span><h3 class="mt-3 font-display text-lg font-bold">Compare</h3><p class="mt-2 text-sm font-semibold leading-6 text-stone-600">Check the warning device against its normal mark.</p></div>
                                <div class="bg-white p-5"><span class="font-display text-3xl font-bold text-pine">03</span><h3 class="mt-3 font-display text-lg font-bold">Service</h3><p class="mt-2 text-sm font-semibold leading-6 text-stone-600">Refer changed operation for system-specific inspection.</p></div>
                                <div class="bg-white p-5"><span class="font-display text-3xl font-bold text-pine">04</span><h3 class="mt-3 font-display text-lg font-bold">Verify</h3><p class="mt-2 text-sm font-semibold leading-6 text-stone-600">Use an indoor radon test after relevant service.</p></div>
                            </div>
                        </section>
                    @endif

                    @for (int i = 0; i < guide.sections().size(); i++)
                        !{ final var section = guide.sections().get(i); }
                        <section id="${section.id()}" class="scroll-mt-28 border-b border-paper-rule py-11">
                            <div class="grid gap-4 sm:grid-cols-[52px_1fr]">
                                <span class="font-display text-3xl font-bold text-pine">0${i + 1}</span>
                                <div>
                                    <h2 class="font-display text-3xl font-bold leading-tight sm:text-4xl">${section.heading()}</h2>
                                    @for (var paragraph : section.paragraphs())
                                        <p class="mt-5 text-lg font-semibold leading-8 text-stone-700">${paragraph}</p>
                                    @endfor
                                </div>
                            </div>
                        </section>
                    @endfor

                    <section id="checklist" class="scroll-mt-28 py-12">
                        <p class="text-xs font-black uppercase tracking-[0.2em] text-pine">Turn this page into evidence</p>
                        <h2 class="mt-3 font-display text-4xl font-bold">Build a procedure record</h2>
                        <p class="mt-4 max-w-2xl font-semibold leading-7 text-stone-600">Check only what you can confirm. The summary keeps unresolved items visible instead of converting uncertainty into a pass.</p>
                        <form id="protocol-record-form" class="mt-7 border-y-2 border-ink" data-guide-title="${guide.title()}">
                            <fieldset>
                                <legend class="sr-only">${guide.title()} record items</legend>
                                @for (int checklistIndex = 0; checklistIndex < guide.checklist().size(); checklistIndex++)
                                    !{ final var item = guide.checklist().get(checklistIndex); }
                                    <label class="grid cursor-pointer grid-cols-[28px_1fr] gap-3 border-b border-paper-rule py-4 last:border-b-0">
                                        <input class="protocol-record-check mt-1 h-5 w-5 accent-pine" type="checkbox" value="${item}">
                                        <span class="font-bold text-stone-700">${item}</span>
                                    </label>
                                @endfor
                            </fieldset>
                            <div class="border-t-2 border-ink bg-white px-5 py-5">
                                <div class="flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between">
                                    <strong id="protocol-record-progress" class="text-sm text-pine" aria-live="polite">0 of ${guide.checklist().size()} confirmed</strong>
                                    <span class="text-xs font-bold text-stone-500">Nothing is uploaded or saved by this page.</span>
                                </div>
                                <label class="mt-5 block text-sm font-black" for="protocol-record-notes">Context to keep with the record <span class="font-semibold text-stone-500">(optional)</span></label>
                                <textarea id="protocol-record-notes" class="mt-2 min-h-[96px] w-full border-2 border-ink bg-white p-3 font-semibold" maxlength="1000" placeholder="Device, room, date, change observed, or item that still needs verification"></textarea>
                                <div class="mt-4 flex flex-col gap-3 sm:flex-row">
                                    <button id="protocol-record-build" class="min-h-[50px] bg-ink px-5 text-sm font-black text-white transition hover:bg-pine" type="button">Create a copyable summary</button>
                                    <button id="protocol-record-reset" class="min-h-[50px] border-2 border-ink bg-white px-5 text-sm font-black text-ink transition hover:bg-paper" type="reset">Clear record</button>
                                </div>
                                <output id="protocol-record-output" class="mt-5 block border-l-8 border-signal bg-paper-light p-5" hidden>
                                    <span class="block text-xs font-black uppercase tracking-wider text-pine">Reviewable summary</span>
                                    <pre id="protocol-record-summary" class="mt-3 whitespace-pre-wrap font-sans text-sm font-semibold leading-6 text-stone-700"></pre>
                                    <button id="protocol-record-copy" class="mt-4 min-h-[46px] border-2 border-ink bg-white px-4 text-sm font-black" type="button">Copy summary</button>
                                </output>
                            </div>
                        </form>
                        <a href="/radon-test-planner" class="mt-7 inline-flex min-h-[54px] items-center justify-center rounded bg-ink px-6 text-sm font-black text-white transition hover:bg-pine focus:outline-none focus:ring-4 focus:ring-pine/20">Open the full test planner <span class="ml-3" aria-hidden="true">→</span></a>
                    </section>

                    <section class="border-t border-paper-rule py-12">
                        <p class="text-xs font-black uppercase tracking-[0.2em] text-pine">Common questions</p>
                        <h2 class="mt-3 font-display text-4xl font-bold">Quick answers</h2>
                        <div class="mt-7 divide-y divide-stone-300 border-y border-stone-300">
                            @for (var faq : guide.faqs())
                                <details class="group py-5">
                                    <summary class="flex cursor-pointer list-none items-center justify-between gap-5 font-display text-xl font-bold"><span>${faq.question()}</span><span class="text-pine transition group-open:rotate-45" aria-hidden="true">+</span></summary>
                                    <p class="mt-4 max-w-2xl font-semibold leading-7 text-stone-700">${faq.answer()}</p>
                                </details>
                            @endfor
                        </div>
                    </section>

                    <section id="sources" class="scroll-mt-28 border-t-2 border-ink py-12">
                        <p class="text-xs font-black uppercase tracking-[0.2em] text-pine">Evidence boundary</p>
                        <h2 class="mt-3 font-display text-4xl font-bold">Official sources used</h2>
                        <div class="mt-7 divide-y divide-stone-300 border-y border-stone-300">
                            @for (var source : guide.sources())
                                <a class="protocol-source grid gap-2 py-5 sm:grid-cols-[1fr_auto] sm:items-center" href="${source.url()}" rel="noopener" target="_blank">
                                    <span><strong class="block text-lg">${source.label()}</strong><small class="mt-1 block font-semibold text-stone-500">${source.publisher()} · ${source.scope()}</small></span>
                                    <span class="protocol-source-arrow text-xl font-black text-pine transition" aria-hidden="true">↗</span>
                                </a>
                            @endfor
                        </div>
                    </section>

                    <nav class="border-t border-paper-rule py-12" aria-label="Related radon test guides">
                        <p class="text-xs font-black uppercase tracking-[0.2em] text-pine">Continue the test workflow</p>
                        <div class="mt-5 grid gap-px bg-paper-rule sm:grid-cols-2">
                            @for (var link : guide.related())
                                <a class="group bg-paper-light p-5 font-display text-xl font-bold leading-tight transition hover:bg-white" href="${link.url()}">${link.title()} <span class="ml-1 text-pine transition group-hover:ml-2" aria-hidden="true">→</span></a>
                            @endfor
                        </div>
                    </nav>
                </div>
            </div>

            <section class="bg-pine text-white">
                <div class="mx-auto flex max-w-7xl flex-col gap-7 px-4 py-12 sm:px-6 lg:flex-row lg:items-end lg:justify-between lg:px-8">
                    <div><p class="text-xs font-black uppercase tracking-[0.22em] text-signal">Turn guidance into a record</p><h2 class="mt-3 max-w-3xl font-display text-4xl font-bold sm:text-5xl">Check the procedure before trusting the number.</h2></div>
                    <a href="/radon-test-planner" class="inline-flex min-h-[54px] shrink-0 items-center justify-center rounded bg-signal px-6 text-sm font-black text-ink transition hover:-translate-y-0.5 hover:bg-white">Start the test planner →</a>
                </div>
            </section>
        </article>
    `
)
