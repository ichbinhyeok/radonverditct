@import com.radonverdict.util.JsonLdUtils

!{
    final String seoTitle = "Radon Test Planner: Setup, Placement & Validity | RadonVerdict";
    final String seoDescription = "Plan and document a home radon test. Check the test method, placement, timing, and conditions against source-linked guidance before relying on the result.";
}

@template.layout.main(
    title = seoTitle,
    canonicalUrl = "https://radonverdict.com/",
    description = seoDescription,
    headContent = @`
        <script type="application/ld+json">
        {"@@context":"https://schema.org","@@type":"WebSite","name":"RadonVerdict","url":"https://radonverdict.com/","description":$unsafe{JsonLdUtils.json(seoDescription)}}
        </script>
        <style>
            .rv-home-hero { min-height: calc(100svh - 4rem); }
            .rv-home-hero__image { transform: scale(1.025); animation: rv-home-settle 1.2s cubic-bezier(.2,.75,.25,1) both; }
            .rv-home-hero__copy > * { opacity: 0; transform: translateY(18px); animation: rv-home-rise .65s cubic-bezier(.2,.75,.25,1) forwards; }
            .rv-home-hero__copy > :nth-child(2) { animation-delay: .08s; }
            .rv-home-hero__copy > :nth-child(3) { animation-delay: .16s; }
            .rv-home-hero__copy > :nth-child(4) { animation-delay: .24s; }
            .rv-home-rule { transform-origin: left; animation: rv-home-rule .8s .32s cubic-bezier(.2,.75,.25,1) both; }
            .rv-home-reveal { opacity: 0; transform: translateY(20px); transition: opacity .55s ease, transform .55s ease; }
            .rv-home-reveal.is-visible { opacity: 1; transform: none; }
            @keyframes rv-home-settle { from { opacity: .2; transform: scale(1.06); } to { opacity: 1; transform: scale(1.025); } }
            @keyframes rv-home-rise { to { opacity: 1; transform: none; } }
            @keyframes rv-home-rule { from { transform: scaleX(0); } to { transform: scaleX(1); } }
            @media (prefers-reduced-motion: reduce) {
                .rv-home-hero__image, .rv-home-hero__copy > *, .rv-home-rule { animation: none; opacity: 1; transform: none; }
                .rv-home-reveal { opacity: 1; transform: none; transition: none; }
            }
        </style>
    `,
    content = @`
        <section class="rv-home-hero relative isolate flex overflow-hidden bg-ink text-white">
            <img class="rv-home-hero__image absolute inset-0 -z-20 h-full w-full object-cover" src="/images/radon-test-editorial-hero-v1.webp" alt="A radon monitor positioned on a shelf in a residential basement" width="1536" height="1024" fetchpriority="high">
            <div class="absolute inset-0 -z-10 bg-gradient-to-r from-ink via-ink/90 to-ink/20"></div>
            <div class="absolute inset-0 -z-10 bg-gradient-to-t from-ink/80 via-transparent to-transparent"></div>
            <div class="mx-auto flex w-full max-w-7xl items-end px-4 py-12 sm:px-6 sm:py-16 lg:px-8 lg:py-20">
                <div class="rv-home-hero__copy max-w-3xl">
                    <p class="text-xs font-black uppercase tracking-[0.24em] text-signal">Home radon test workspace</p>
                    <h1 class="mt-5 max-w-4xl font-display text-5xl font-black leading-[0.88] tracking-[-0.055em] sm:text-8xl lg:text-9xl">Radon test planner</h1>
                    <div class="rv-home-rule mt-6 h-px w-full max-w-xl bg-white/45"></div>
                    <div class="mt-6 max-w-2xl">
                        <p class="font-display text-3xl font-bold leading-tight sm:text-5xl">Run a test you can trust.</p>
                        <p class="mt-4 max-w-xl text-base font-semibold leading-relaxed text-stone-200 sm:text-lg">Choose the right test, place it correctly, record what happened, and check the procedure before you rely on the number.</p>
                        <div class="mt-7 flex flex-col gap-3 sm:flex-row">
                            <a href="/radon-test-planner" class="inline-flex min-h-[54px] items-center justify-center rounded bg-signal px-6 text-sm font-black text-ink transition hover:bg-white focus:outline-none focus:ring-4 focus:ring-signal/30">Start a test record <span class="ml-3" aria-hidden="true">→</span></a>
                            <a href="/radon-test-result-meaning" class="inline-flex min-h-[54px] items-center justify-center border-b border-white/60 px-2 text-sm font-bold text-white transition hover:border-signal hover:text-signal">I already have a result</a>
                        </div>
                        <p class="mt-5 text-xs font-semibold text-stone-300">No account required. Your unfinished record stays in this browser.</p>
                    </div>
                </div>
            </div>
        </section>

        <section class="border-b border-paper-rule bg-paper">
            <div class="mx-auto max-w-7xl px-4 py-16 sm:px-6 sm:py-24 lg:px-8">
                <div class="grid gap-12 lg:grid-cols-12 lg:items-end">
                    <div class="rv-home-reveal lg:col-span-8">
                        <p class="text-xs font-black uppercase tracking-[0.22em] text-pine">Before the result</p>
                        <h2 class="mt-4 max-w-4xl font-display text-4xl font-bold leading-[1.02] tracking-[-0.035em] text-ink sm:text-6xl">The number is useful only when the test conditions make sense.</h2>
                    </div>
                    <p class="rv-home-reveal border-l border-paper-rule pl-5 text-base font-semibold leading-relaxed text-stone-600 lg:col-span-4">A county average cannot validate your device, room, timing, or closed-house conditions. This workspace records those facts first.</p>
                </div>
                <dl class="rv-home-reveal mt-14 grid border-y border-paper-rule sm:grid-cols-3">
                    <div class="py-6 sm:pr-8"><dt class="text-xs font-black uppercase tracking-wider text-pine">01 · Method</dt><dd class="mt-2 text-lg font-bold text-ink">Short-term, long-term, or continuous</dd></div>
                    <div class="border-paper-rule py-6 sm:border-x sm:px-8"><dt class="text-xs font-black uppercase tracking-wider text-pine">02 · Placement</dt><dd class="mt-2 text-lg font-bold text-ink">Level, room, height, and interference</dd></div>
                    <div class="py-6 sm:pl-8"><dt class="text-xs font-black uppercase tracking-wider text-pine">03 · Conditions</dt><dd class="mt-2 text-lg font-bold text-ink">Duration, doors, windows, and disruptions</dd></div>
                </dl>
                <a class="rv-home-reveal mt-6 inline-flex border-b-2 border-pine pb-1 text-sm font-black text-pine hover:border-ink hover:text-ink" href="/guides/short-term-vs-long-term-radon-test">How long does a radon test take? →</a>
            </div>
        </section>

        <section class="bg-ink text-white">
            <div class="mx-auto grid max-w-7xl gap-12 px-4 py-16 sm:px-6 sm:py-24 lg:grid-cols-12 lg:px-8">
                <div class="rv-home-reveal lg:col-span-5 lg:sticky lg:top-28 lg:self-start">
                    <p class="text-xs font-black uppercase tracking-[0.22em] text-signal">One question at a time</p>
                    <h2 class="mt-4 font-display text-4xl font-bold leading-tight sm:text-5xl">From unopened kit to a usable record.</h2>
                    <p class="mt-5 max-w-md font-semibold leading-relaxed text-stone-300">The planner adapts to whether you are preparing, currently testing, or checking a completed test.</p>
                </div>
                <ol class="rv-home-reveal border-t border-stone-700 lg:col-span-7">
                    <li class="grid grid-cols-[42px_1fr] gap-4 border-b border-stone-700 py-6"><span class="font-black text-signal">01</span><div><h3 class="text-xl font-black">Name the testing situation</h3><p class="mt-2 text-sm font-semibold leading-relaxed text-stone-400">First test, property transaction, or post-mitigation check.</p></div></li>
                    <li class="grid grid-cols-[42px_1fr] gap-4 border-b border-stone-700 py-6"><span class="font-black text-signal">02</span><div><h3 class="text-xl font-black">Set the procedure</h3><p class="mt-2 text-sm font-semibold leading-relaxed text-stone-400">Record device type, placement, dates, and test conditions.</p></div></li>
                    <li class="grid grid-cols-[42px_1fr] gap-4 border-b border-stone-700 py-6"><span class="font-black text-signal">03</span><div><h3 class="text-xl font-black">Check what may affect validity</h3><p class="mt-2 text-sm font-semibold leading-relaxed text-stone-400">See what is consistent, what is uncertain, and what should be checked against the device instructions.</p></div></li>
                    <li class="grid grid-cols-[42px_1fr] gap-4 border-b border-stone-700 py-6"><span class="font-black text-signal">04</span><div><h3 class="text-xl font-black">Keep the evidence</h3><p class="mt-2 text-sm font-semibold leading-relaxed text-stone-400">Print a clear record of the procedure, result, limitations, and source links.</p></div></li>
                </ol>
            </div>
        </section>

        <section class="bg-paper-light">
            <div class="mx-auto max-w-7xl px-4 py-16 sm:px-6 sm:py-24 lg:px-8">
                <div class="rv-home-reveal grid gap-10 lg:grid-cols-12 lg:items-start">
                    <div class="lg:col-span-7">
                        <p class="text-xs font-black uppercase tracking-[0.22em] text-pine">A procedural check, not a diagnosis</p>
                        <h2 class="mt-4 font-display text-4xl font-bold leading-tight tracking-[-0.025em] sm:text-5xl">Official guidance stays attached to the answer.</h2>
                    </div>
                    <div class="border-l border-paper-rule pl-5 lg:col-span-5">
                        <p class="font-semibold leading-relaxed text-stone-700">State and device instructions can be more specific than general national guidance. RadonVerdict shows the source and tells you when to defer to those instructions.</p>
                        <div class="mt-6 flex flex-wrap gap-x-6 gap-y-3 text-sm font-black text-pine">
                            <a class="border-b border-pine/40 hover:border-pine" href="https://www.cdc.gov/radon/testing/index.html" rel="noopener">CDC testing guidance ↗</a>
                            <a class="border-b border-pine/40 hover:border-pine" href="https://www.epa.gov/radon" rel="noopener">US EPA radon guidance ↗</a>
                            <a class="border-b border-pine/40 hover:border-pine" href="/methodology">Our method →</a>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section class="border-y-2 border-ink bg-white" aria-labelledby="system-answers-title">
            <div class="mx-auto max-w-7xl px-4 py-14 sm:px-6 sm:py-20 lg:px-8">
                <div class="grid gap-8 lg:grid-cols-[minmax(0,1fr)_minmax(0,2fr)] lg:items-end">
                    <div>
                        <p class="text-xs font-black uppercase tracking-[0.22em] text-pine">Already have a mitigation system?</p>
                        <h2 id="system-answers-title" class="mt-3 font-display text-4xl font-bold leading-tight">Check the indicator, noise, maintenance, or fan age.</h2>
                    </div>
                    <div class="grid gap-px bg-paper-rule sm:grid-cols-2">
                        <a class="bg-paper-light p-5 font-display text-xl font-bold hover:bg-ink hover:text-white" href="/guides/radon-mitigation-system-maintenance">System maintenance checklist →</a>
                        <a class="bg-paper-light p-5 font-display text-xl font-bold hover:bg-ink hover:text-white" href="/guides/radon-manometer-reading">Read a radon manometer →</a>
                        <a class="bg-paper-light p-5 font-display text-xl font-bold hover:bg-ink hover:text-white" href="/guides/radon-fan-noise">Triage a changing fan sound →</a>
                        <a class="bg-paper-light p-5 font-display text-xl font-bold hover:bg-ink hover:text-white" href="/guides/how-long-do-radon-fans-last">Understand radon fan service life →</a>
                    </div>
                </div>
            </div>
        </section>

        <section class="bg-signal text-ink">
            <div class="mx-auto flex max-w-7xl flex-col gap-7 px-4 py-14 sm:px-6 sm:py-16 lg:flex-row lg:items-center lg:justify-between lg:px-8">
                <div class="rv-home-reveal"><p class="text-xs font-black uppercase tracking-[0.22em]">Start with the procedure</p><h2 class="mt-2 font-display text-4xl font-bold tracking-tight sm:text-5xl">Make the test record before the result.</h2></div>
                <a href="/radon-test-planner" class="rv-home-reveal inline-flex min-h-[54px] shrink-0 items-center justify-center rounded bg-ink px-7 text-sm font-black text-white transition hover:bg-pine focus:outline-none focus:ring-4 focus:ring-ink/20">Open the planner <span class="ml-3" aria-hidden="true">→</span></a>
            </div>
        </section>

        <script>
        (function () {
            var nodes = document.querySelectorAll('.rv-home-reveal');
            if (!('IntersectionObserver' in window) || window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
                nodes.forEach(function (node) { node.classList.add('is-visible'); });
                return;
            }
            var observer = new IntersectionObserver(function (entries) {
                entries.forEach(function (entry) {
                    if (entry.isIntersecting) { entry.target.classList.add('is-visible'); observer.unobserve(entry.target); }
                });
            }, { threshold: 0.14 });
            nodes.forEach(function (node) { observer.observe(node); });
        })();
        </script>
    `
)
