@import com.radonverdict.util.JsonLdUtils

!{
    final String seoTitle = "Radon Test Result Meaning & County Data | RadonVerdict";
    final String seoDescription = "Interpret a radon test result against EPA guidance, then review source-linked county evidence without treating a local average as your home's reading.";
}

@template.layout.main(
    title = seoTitle,
    canonicalUrl = "https://radonverdict.com/",
    description = seoDescription,
    headContent = @`
        <script type="application/ld+json">
        {"@context":"https://schema.org","@type":"WebSite","name":"RadonVerdict","url":"https://radonverdict.com/","description":$unsafe{JsonLdUtils.json(seoDescription)}}
        </script>
        <style>
            .rv-hero-copy { animation: rv-rise .7s cubic-bezier(.2,.75,.25,1) both; }
            .rv-hero-visual { animation: rv-settle .9s .08s cubic-bezier(.2,.75,.25,1) both; }
            .rv-reveal { opacity: 0; transform: translateY(18px); transition: opacity .55s ease, transform .55s ease; }
            .rv-reveal.is-visible { opacity: 1; transform: none; }
            @keyframes rv-rise { from { opacity: 0; transform: translateY(16px); } to { opacity: 1; transform: none; } }
            @keyframes rv-settle { from { opacity: 0; transform: scale(1.02); } to { opacity: 1; transform: none; } }
            @media (prefers-reduced-motion: reduce) {
                .rv-hero-copy, .rv-hero-visual { animation: none; }
                .rv-reveal { opacity: 1; transform: none; transition: none; }
            }
        </style>
    `,
    content = @`
        <section class="overflow-hidden border-b border-stone-200 bg-[#f3efe7]">
            <div class="mx-auto grid max-w-7xl lg:min-h-[680px] lg:grid-cols-[0.95fr_1.05fr]">
                <div class="rv-hero-copy flex items-center px-4 py-14 sm:px-8 sm:py-20 lg:px-12 lg:py-24">
                    <div class="max-w-xl">
                        <p class="text-xs font-black uppercase tracking-[0.24em] text-emerald-900">Independent radon evidence desk</p>
                        <h1 class="mt-5 font-display text-5xl font-black leading-[0.96] tracking-[-0.045em] text-stone-950 sm:text-6xl">Understand the number before you decide what comes next.</h1>
                        <p class="mt-6 text-lg font-semibold leading-relaxed text-stone-700">Interpret your test result against official guidance, then keep county data in its proper place: useful context, never a substitute for testing the home.</p>
                        <div class="mt-8 flex flex-col gap-3 sm:flex-row">
                            <a href="/radon-test-result-meaning" class="inline-flex min-h-[54px] items-center justify-center rounded-xl bg-stone-950 px-6 text-sm font-black text-white transition hover:bg-emerald-950">Interpret a radon result</a>
                            <a href="/radon-levels" class="inline-flex min-h-[54px] items-center justify-center rounded-xl border border-stone-400 bg-white/70 px-6 text-sm font-black text-stone-900 transition hover:bg-white">Browse county evidence</a>
                        </div>
                        <p class="mt-5 text-sm font-semibold leading-relaxed text-stone-600">EPA recommends fixing at 4.0 pCi/L or higher and considering action between 2.0 and 4.0 pCi/L.</p>
                    </div>
                </div>
                <figure class="rv-hero-visual relative min-h-[360px] overflow-hidden lg:min-h-full">
                    <img src="/images/radon-test-editorial-hero-v1.webp" alt="A generic radon monitor on a shelf in a residential basement" width="1536" height="1024" fetchpriority="high" class="absolute inset-0 h-full w-full object-cover">
                    <div class="absolute inset-x-5 bottom-5 max-w-sm rounded-xl border border-white/40 bg-stone-950/85 p-4 text-white shadow-xl backdrop-blur-sm">
                        <p class="text-[11px] font-black uppercase tracking-[0.2em] text-emerald-300">The essential distinction</p>
                        <p class="mt-2 text-sm font-semibold leading-relaxed">A map estimates regional potential. A properly placed test measures this home.</p>
                    </div>
                </figure>
            </div>
        </section>

        <section class="border-b border-stone-200 bg-white">
            <div class="mx-auto max-w-6xl px-4 py-14 sm:px-6 sm:py-20">
                <div class="grid gap-10 lg:grid-cols-[0.78fr_1.22fr] lg:items-start">
                    <div class="rv-reveal lg:sticky lg:top-28">
                        <p class="text-xs font-black uppercase tracking-[0.22em] text-emerald-800">The national reference point</p>
                        <p class="mt-4 font-display text-7xl font-black tracking-[-0.06em] text-stone-950 sm:text-8xl">4.0</p>
                        <p class="mt-1 text-sm font-black uppercase tracking-[0.16em] text-stone-500">pCi/L · EPA action level</p>
                    </div>
                    <div class="rv-reveal">
                        <h2 class="font-display text-3xl font-black tracking-tight text-stone-950 sm:text-4xl">Start with the result, not the ZIP code.</h2>
                        <p class="mt-4 text-lg font-semibold leading-relaxed text-stone-700">A county average cannot tell you whether one basement is safe. Enter the result exactly as it appears on the report; the plan preserves the threshold, test limitations, and next action separately from local context.</p>
                        <form action="/plan" method="get" class="mt-8 rounded-2xl border border-stone-300 bg-stone-50 p-5 sm:p-6" x-data="{ noTest: false }">
                            <input type="hidden" name="source" value="home-seo">
                            <input type="hidden" name="noTest" :value="noTest">
                            <div class="grid gap-4 sm:grid-cols-[1fr_0.62fr]">
                                <div>
                                    <div class="flex items-center justify-between gap-3">
                                        <label for="home-reading" class="text-sm font-black text-stone-950">Radon result</label>
                                        <button type="button" @click="noTest = !noTest" :aria-pressed="noTest.toString()" class="rounded-lg border border-stone-300 bg-white px-3 py-2 text-xs font-black text-stone-700"><span x-text="noTest ? 'Enter a result' : 'No test yet'">No test yet</span></button>
                                    </div>
                                    <div class="mt-2 flex items-center rounded-xl border border-stone-300 bg-white px-4 focus-within:border-emerald-800 focus-within:ring-2 focus-within:ring-emerald-100">
                                        <input id="home-reading" name="radonReading" type="number" min="0" max="999" step="0.01" inputmode="decimal" :disabled="noTest" placeholder="4.2" class="min-h-[62px] min-w-0 flex-1 border-0 bg-transparent font-display text-4xl font-black text-stone-950 outline-none disabled:text-stone-300">
                                        <span class="ml-3 text-sm font-black text-stone-500">pCi/L</span>
                                    </div>
                                </div>
                                <div>
                                    <label for="home-zip" class="text-sm font-black text-stone-950">ZIP code <span class="font-semibold text-stone-500">(optional)</span></label>
                                    <input id="home-zip" name="zipCode" inputmode="numeric" pattern="[0-9]{5}" maxlength="5" placeholder="12345" class="mt-2 min-h-[64px] w-full rounded-xl border border-stone-300 bg-white px-4 font-bold text-stone-950 outline-none focus:border-emerald-800 focus:ring-2 focus:ring-emerald-100">
                                </div>
                            </div>
                            <input type="hidden" name="intent" value="homeowner">
                            <button type="submit" class="mt-4 min-h-[54px] w-full rounded-xl bg-emerald-900 px-6 text-sm font-black text-white transition hover:bg-stone-950">Build my next step</button>
                            <p class="mt-3 text-xs font-semibold leading-relaxed text-stone-500">No account required. ZIP is used only to look up a primary county and may be ambiguous near county boundaries.</p>
                        </form>
                    </div>
                </div>
            </div>
        </section>

        <section class="bg-stone-950 text-white">
            <div class="mx-auto max-w-6xl px-4 py-14 sm:px-6 sm:py-20">
                <div class="rv-reveal max-w-3xl">
                    <p class="text-xs font-black uppercase tracking-[0.22em] text-emerald-300">How to read the evidence</p>
                    <h2 class="mt-3 font-display text-3xl font-black tracking-tight sm:text-4xl">Three layers. Three different questions.</h2>
                </div>
                <div class="mt-9 grid gap-px overflow-hidden rounded-2xl border border-stone-700 bg-stone-700 md:grid-cols-3">
                    <article class="rv-reveal bg-stone-900 p-6"><span class="text-sm font-black text-emerald-300">01 · HOME</span><h3 class="mt-3 text-xl font-black">What did this test measure?</h3><p class="mt-3 text-sm font-semibold leading-relaxed text-stone-300">The result, unit, test duration, placement, and dates determine how the number should be interpreted.</p></article>
                    <article class="rv-reveal bg-stone-900 p-6"><span class="text-sm font-black text-emerald-300">02 · GUIDANCE</span><h3 class="mt-3 text-xl font-black">What does EPA recommend?</h3><p class="mt-3 text-sm font-semibold leading-relaxed text-stone-300">Official thresholds and follow-up guidance define the decision boundary—not an estimated local price.</p></article>
                    <article class="rv-reveal bg-stone-900 p-6"><span class="text-sm font-black text-emerald-300">03 · COUNTY</span><h3 class="mt-3 text-xl font-black">What is the local context?</h3><p class="mt-3 text-sm font-semibold leading-relaxed text-stone-300">Official county records can show aggregate patterns and source limits, but cannot diagnose an address.</p></article>
                </div>
            </div>
        </section>

        <section class="border-b border-stone-200 bg-[#faf9f6]">
            <div class="mx-auto max-w-6xl px-4 py-14 sm:px-6 sm:py-20">
                <div class="grid gap-10 lg:grid-cols-[0.82fr_1.18fr]">
                    <div class="rv-reveal">
                        <p class="text-xs font-black uppercase tracking-[0.22em] text-emerald-800">Focused local evidence</p>
                        <h2 class="mt-3 font-display text-3xl font-black tracking-tight text-stone-950 sm:text-4xl">Pages kept because there is a real query and a source-backed answer.</h2>
                        <p class="mt-4 font-semibold leading-relaxed text-stone-700">We are not reopening thousands of county pages. This small cohort preserves locations with observed search demand or historical clicks and enough official evidence to state the limits honestly.</p>
                    </div>
                    <div class="rv-reveal divide-y divide-stone-300 border-y border-stone-300">
                        <a href="/radon-levels/new-york/schenectady-county" class="group grid gap-2 py-5 sm:grid-cols-[1fr_auto] sm:items-center"><span><strong class="block text-lg text-stone-950 group-hover:text-emerald-900">Schenectady County, New York</strong><span class="text-sm font-semibold text-stone-600">EPA zone and NYSDOH submitted-test context</span></span><span class="text-sm font-black text-stone-500">View evidence →</span></a>
                        <a href="/radon-levels/idaho/fremont-county" class="group grid gap-2 py-5 sm:grid-cols-[1fr_auto] sm:items-center"><span><strong class="block text-lg text-stone-950 group-hover:text-emerald-900">Fremont County, Idaho</strong><span class="text-sm font-semibold text-stone-600">EPA radon-zone context and its property-level limit</span></span><span class="text-sm font-black text-stone-500">View evidence →</span></a>
                        <a href="/radon-levels/virginia/falls-church-city" class="group grid gap-2 py-5 sm:grid-cols-[1fr_auto] sm:items-center"><span><strong class="block text-lg text-stone-950 group-hover:text-emerald-900">Falls Church, Virginia</strong><span class="text-sm font-semibold text-stone-600">Official reported-test record with basement caveat</span></span><span class="text-sm font-black text-stone-500">View evidence →</span></a>
                        <a href="/radon-testing/new-york/ulster-county" class="group grid gap-2 py-5 sm:grid-cols-[1fr_auto] sm:items-center"><span><strong class="block text-lg text-stone-950 group-hover:text-emerald-900">Radon testing in Ulster County</strong><span class="text-sm font-semibold text-stone-600">Test method, official local context, and next step</span></span><span class="text-sm font-black text-stone-500">Open guide →</span></a>
                    </div>
                </div>
            </div>
        </section>

        <section class="bg-white">
            <div class="mx-auto grid max-w-6xl gap-8 px-4 py-14 sm:px-6 sm:py-20 lg:grid-cols-[1fr_auto] lg:items-center">
                <div class="rv-reveal"><p class="text-xs font-black uppercase tracking-[0.22em] text-emerald-800">Reusable evidence</p><h2 class="mt-3 font-display text-3xl font-black tracking-tight text-stone-950 sm:text-4xl">Inspect the data, source, period, and caveat yourself.</h2><p class="mt-4 max-w-3xl font-semibold leading-relaxed text-stone-700">The downloadable county dataset keeps source URLs and claim boundaries attached to each normalized record. It is context for research—not a property-level diagnosis.</p></div>
                <div class="rv-reveal flex flex-col gap-3 sm:flex-row lg:flex-col"><a href="/radon-data-sources" class="inline-flex min-h-[52px] items-center justify-center rounded-xl bg-stone-950 px-6 text-sm font-black text-white hover:bg-emerald-950">Review sources and methods</a><a href="/datasets/us-county-radon-evidence.csv" class="inline-flex min-h-[52px] items-center justify-center rounded-xl border border-stone-300 px-6 text-sm font-black text-stone-900 hover:bg-stone-50">Download county CSV</a></div>
            </div>
        </section>

        <script>
        (function () {
            var nodes = document.querySelectorAll('.rv-reveal');
            if (!('IntersectionObserver' in window) || window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
                nodes.forEach(function (node) { node.classList.add('is-visible'); });
                return;
            }
            var observer = new IntersectionObserver(function (entries) {
                entries.forEach(function (entry) {
                    if (entry.isIntersecting) { entry.target.classList.add('is-visible'); observer.unobserve(entry.target); }
                });
            }, { threshold: 0.12 });
            nodes.forEach(function (node) { observer.observe(node); });
        })();
        </script>
    `
)
