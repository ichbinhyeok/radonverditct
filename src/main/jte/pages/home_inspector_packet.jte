@import com.radonverdict.util.JsonLdUtils

@param String packetSource = "home-inspector-packet"
@param String inspectorPreviewName = null
@param boolean salesDemo = false
@param String pageTitle = "Radon Decision Packet for Home Inspectors | RadonVerdict"
@param String canonicalUrl = "https://radonverdict.com/for-home-inspectors"

!{
    final String clientNote = "A radon result is a decision item, not a panic item. This free guide explains what the number means, how to check the local cost path, and when a repair, credit, retest, or quote checklist makes sense.";
}

@template.layout.main(
    title = pageTitle,
    canonicalUrl = canonicalUrl,
    description = "A free client-ready radon decision packet for home inspectors: result meaning, local cost path, seller-credit route, and quote checklist.",
    headContent = @`
        <script type="application/ld+json">
            {
                "@context": "https://schema.org",
                "@type": "WebPage",
                "name": "Radon Decision Packet for Home Inspectors",
                "url": "https://radonverdict.com/for-home-inspectors",
                "description": "A client-ready radon decision packet with result explanation, local cost path, seller-credit route, and quote checklist.",
                "audience": {"@type": "Audience", "audienceType": "Home inspectors"}
            }
        </script>
    `,
    content = @`
        <section class="bg-slate-950 text-white">
            <div class="mx-auto grid max-w-6xl gap-12 px-4 py-16 sm:px-6 sm:py-20 lg:grid-cols-[0.9fr_1.1fr] lg:items-center lg:px-8">
                <div>
                    <p class="text-xs font-black uppercase tracking-[0.24em] text-cyan-200">RadonVerdict for home inspectors</p>
                    @if(salesDemo)
                        <h1 class="mt-5 max-w-xl font-display text-4xl font-black leading-[1.02] text-white sm:text-6xl">A client follow-up link with your name on it.</h1>
                        <p class="mt-6 max-w-lg text-lg font-semibold leading-relaxed text-slate-300">This is a working demo for ${inspectorPreviewName}. The client sees who shared it, then gets the result explanation and next step without making you the mitigation or negotiation expert.</p>
                    @else
                        <h1 class="mt-5 max-w-xl font-display text-4xl font-black leading-[1.02] text-white sm:text-6xl">Give every radon result a clear next step.</h1>
                        <p class="mt-6 max-w-lg text-lg font-semibold leading-relaxed text-slate-300">One client-ready link for result meaning, local cost context, seller-credit math, and a contractor quote checklist.</p>
                    @endif
                    <div class="mt-8 flex flex-col gap-3 sm:flex-row">
                        <button type="button" data-copy-client-link data-track-event="inspector_packet_copy_link" data-track-label="hero"
                                class="inline-flex min-h-[52px] items-center justify-center rounded-xl bg-white px-5 text-sm font-black text-slate-950 transition-colors hover:bg-cyan-100">
                            Copy client link
                        </button>
                        <a href="/guides/radon-failed-inspection?source=${packetSource}" data-client-preview-link class="inline-flex min-h-[52px] items-center justify-center rounded-xl border border-white/20 px-5 text-sm font-black text-white transition-colors hover:bg-white/10">
                            Preview client page
                        </a>
                    </div>
                    <p data-copy-status class="mt-4 min-h-5 text-sm font-bold text-cyan-200" aria-live="polite"></p>
                    <div class="mt-8 flex flex-wrap gap-x-5 gap-y-3 text-sm font-semibold text-slate-300">
                        <span>No client signup</span><span>•</span><span>No address required</span><span>•</span><span>Free to share</span>
                    </div>
                </div>

                <div class="border border-white/10 bg-slate-900 p-5 shadow-2xl sm:p-7">
                    <p class="text-xs font-black uppercase tracking-[0.2em] text-slate-400">What your client receives</p>
                    <div class="mt-6 space-y-4">
                        <div class="border-l-2 border-cyan-300 bg-white px-5 py-4 text-slate-950">
                            <p class="text-xs font-black uppercase tracking-wider text-slate-500">First</p>
                            <h2 class="mt-1 text-xl font-black">What the result means</h2>
                            <p class="mt-1 text-sm leading-relaxed text-slate-600">A factual explanation of the reading, test context, and retest decision.</p>
                        </div>
                        <div class="border-l-2 border-white/30 bg-white/5 px-5 py-4">
                            <p class="text-xs font-black uppercase tracking-wider text-slate-400">Then</p>
                            <h2 class="mt-1 text-xl font-black">A local money path</h2>
                            <p class="mt-1 text-sm leading-relaxed text-slate-300">ZIP-based cost context before anyone picks an arbitrary repair or credit number.</p>
                        </div>
                        <div class="border-l-2 border-white/30 bg-white/5 px-5 py-4">
                            <p class="text-xs font-black uppercase tracking-wider text-slate-400">Finally</p>
                            <h2 class="mt-1 text-xl font-black">A clean next action</h2>
                            <p class="mt-1 text-sm leading-relaxed text-slate-300">Repair, credit, retest, or quote questions without replacing legal or contractor advice.</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <main class="mx-auto max-w-6xl px-4 py-14 sm:px-6 sm:py-20 lg:px-8">
            <section class="grid gap-10 border-b border-slate-200 pb-14 lg:grid-cols-[0.75fr_1.25fr] lg:items-start">
                <div>
                    <p class="text-xs font-black uppercase tracking-[0.22em] text-indigo-700">Send this after an inspection</p>
                    <h2 class="mt-3 font-display text-3xl font-black tracking-tight text-slate-950">A short client note, ready to paste.</h2>
                    <p class="mt-3 text-sm leading-relaxed text-slate-600">It keeps the conversation factual and gives the client a route without making you the mitigation expert.</p>
                </div>
                <div class="border border-slate-200 bg-slate-50 p-5 sm:p-6">
                    <p class="text-sm leading-relaxed text-slate-800">${clientNote}</p>
                    <div class="mt-5 flex flex-col gap-3 sm:flex-row">
                        <button type="button" data-copy-client-note data-track-event="inspector_packet_copy_note" data-track-label="client_note"
                                class="inline-flex min-h-[48px] items-center justify-center rounded-xl bg-slate-950 px-4 text-sm font-black text-white transition-colors hover:bg-slate-800">
                            Copy client note
                        </button>
                        <button type="button" data-copy-client-link data-track-event="inspector_packet_copy_link" data-track-label="client_note"
                                class="inline-flex min-h-[48px] items-center justify-center rounded-xl border border-slate-300 bg-white px-4 text-sm font-black text-slate-900 transition-colors hover:bg-slate-100">
                            Copy client link
                        </button>
                    </div>
                </div>
            </section>

            <section class="grid gap-8 border-b border-slate-200 py-14 lg:grid-cols-[0.8fr_1.2fr] lg:items-start">
                <div>
                    <p class="text-xs font-black uppercase tracking-[0.22em] text-indigo-700">Make the follow-up specific</p>
                    <h2 class="mt-3 font-display text-3xl font-black tracking-tight text-slate-950">Send the client a link that starts with their result.</h2>
                    <p class="mt-3 text-sm leading-relaxed text-slate-600">Use only the result, property ZIP, and situation already in the inspection conversation. Nothing is saved from this form.</p>
                </div>
                <div class="border border-slate-200 bg-slate-50 p-5 sm:p-6" data-client-link-builder>
                    <div class="grid gap-4 sm:grid-cols-3">
                        <label class="block text-sm font-black text-slate-800">Result (pCi/L)
                            <input type="text" inputmode="decimal" pattern="[0-9]{1,2}(\\.[0-9]{1,2})?" placeholder="e.g. 5.8" data-client-reading class="mt-2 block min-h-[48px] w-full border border-slate-300 bg-white px-3 text-base font-bold text-slate-950 focus:border-slate-950 focus:outline-none">
                        </label>
                        <label class="block text-sm font-black text-slate-800">Property ZIP
                            <input type="text" inputmode="numeric" pattern="[0-9]{5}" maxlength="5" placeholder="e.g. 22030" data-client-zip class="mt-2 block min-h-[48px] w-full border border-slate-300 bg-white px-3 text-base font-bold text-slate-950 focus:border-slate-950 focus:outline-none">
                        </label>
                        <label class="block text-sm font-black text-slate-800">Situation
                            <select data-client-intent class="mt-2 block min-h-[48px] w-full border border-slate-300 bg-white px-3 text-base font-bold text-slate-950 focus:border-slate-950 focus:outline-none">
                                <option value="buying">Buying</option>
                                <option value="selling">Selling</option>
                                <option value="homeowner">Living here</option>
                            </select>
                        </label>
                    </div>
                    <div class="mt-5 flex flex-col gap-3 sm:flex-row sm:items-center">
                        <button type="button" data-copy-prepared-link data-track-event="inspector_packet_copy_prepared_link" data-track-label="client_context"
                                class="inline-flex min-h-[52px] items-center justify-center rounded-xl bg-slate-950 px-5 text-sm font-black text-white transition-colors hover:bg-slate-800">
                            Copy client follow-up link
                        </button>
                        <p data-prepared-link-status class="text-sm font-bold text-slate-600" aria-live="polite">The client will see the result context before choosing a local path.</p>
                    </div>
                </div>
            </section>

            <section class="grid gap-8 py-14 lg:grid-cols-3">
                <div class="border-t-2 border-slate-950 pt-5">
                    <p class="text-xs font-black uppercase tracking-wider text-slate-500">1. Explain</p>
                    <h2 class="mt-2 text-xl font-black text-slate-950">Keep the result in context.</h2>
                    <p class="mt-2 text-sm leading-relaxed text-slate-600">The client sees 2.0-3.9, 4.0+, and high-result next steps without a home-specific medical claim.</p>
                </div>
                <div class="border-t-2 border-slate-950 pt-5">
                    <p class="text-xs font-black uppercase tracking-wider text-slate-500">2. Price</p>
                    <h2 class="mt-2 text-xl font-black text-slate-950">Move from reading to money.</h2>
                    <p class="mt-2 text-sm leading-relaxed text-slate-600">They enter ZIP and foundation context before discussing a repair ask or seller credit.</p>
                </div>
                <div class="border-t-2 border-slate-950 pt-5">
                    <p class="text-xs font-black uppercase tracking-wider text-slate-500">3. Decide</p>
                    <h2 class="mt-2 text-xl font-black text-slate-950">Give the report a next step.</h2>
                    <p class="mt-2 text-sm leading-relaxed text-slate-600">The client can open a quote checklist or seller-credit worksheet without sending personal inspection documents.</p>
                </div>
            </section>

            <section class="border-y border-slate-200 py-12">
                <div class="grid gap-8 lg:grid-cols-[0.85fr_1.15fr] lg:items-center">
                    <div>
                        <p class="text-xs font-black uppercase tracking-[0.22em] text-slate-500">Why clients can trust the packet</p>
                        <h2 class="mt-3 font-display text-3xl font-black tracking-tight text-slate-950">Useful before a contractor call. Clear about its limits.</h2>
                    </div>
                    <div class="grid gap-4 sm:grid-cols-2">
                        <p class="border-l-2 border-indigo-500 pl-4 text-sm leading-relaxed text-slate-700"><strong class="text-slate-950">Public-source context.</strong> County, state, EPA zone, housing, and cost-reference inputs are documented.</p>
                        <p class="border-l-2 border-indigo-500 pl-4 text-sm leading-relaxed text-slate-700"><strong class="text-slate-950">No hidden handoff.</strong> The client can use the guide without creating an account or uploading an inspection report.</p>
                        <p class="border-l-2 border-indigo-500 pl-4 text-sm leading-relaxed text-slate-700"><strong class="text-slate-950">No arbitrary local price claim.</strong> Local public quote ranges appear only after enough current priced signals exist.</p>
                        <p class="border-l-2 border-indigo-500 pl-4 text-sm leading-relaxed text-slate-700"><strong class="text-slate-950">Inspector stays in role.</strong> The packet helps clients understand options; it does not replace legal, medical, or contractor advice.</p>
                    </div>
                </div>
            </section>

            <section class="py-14 text-center">
                <p class="text-xs font-black uppercase tracking-[0.22em] text-indigo-700">Free client resource</p>
                <h2 class="mx-auto mt-3 max-w-2xl font-display text-3xl font-black tracking-tight text-slate-950">Send a next step, not another generic article.</h2>
                <div class="mt-7 flex justify-center">
                    <button type="button" data-copy-client-link data-track-event="inspector_packet_copy_link" data-track-label="final_cta"
                            class="inline-flex min-h-[52px] items-center justify-center rounded-xl bg-slate-950 px-6 text-sm font-black text-white transition-colors hover:bg-slate-800">
                        Copy client link
                    </button>
                </div>
            </section>
        </main>

        <script>
            (() => {
                const defaultSource = $unsafe{JsonLdUtils.json(packetSource)};
                const rawSource = new URLSearchParams(window.location.search).get('source') || defaultSource;
                const outreachSource = /^[a-z0-9_-]{2,60}$/i.test(rawSource)
                    ? rawSource.toLowerCase()
                    : defaultSource;
                const clientUrl = window.location.origin + '/guides/radon-failed-inspection?source=' + encodeURIComponent(outreachSource);
                const clientNote = $unsafe{JsonLdUtils.json(clientNote + "\n\n" + "Link: ")} + clientUrl;
                document.querySelectorAll('[data-client-preview-link]').forEach((link) => link.href = clientUrl);
                const setStatus = (message) => document.querySelectorAll('[data-copy-status]').forEach((node) => node.textContent = message);
                const legacyCopy = (value) => {
                    const input = document.createElement('textarea');
                    input.value = value;
                    input.setAttribute('readonly', '');
                    input.style.position = 'fixed';
                    input.style.opacity = '0';
                    document.body.appendChild(input);
                    input.select();
                    const copied = document.execCommand('copy');
                    input.remove();
                    return copied;
                };
                const copy = async (value, message) => {
                    let copied = false;
                    try {
                        if (navigator.clipboard) {
                            await navigator.clipboard.writeText(value);
                            copied = true;
                        }
                    } catch (error) {
                        copied = false;
                    }
                    if (!copied) copied = legacyCopy(value);
                    setStatus(copied ? message : 'Copy is unavailable in this browser. Use the preview link instead.');
                };
                document.querySelectorAll('[data-copy-client-link]').forEach((button) => button.addEventListener('click', () => copy(clientUrl, 'Client link copied.')));
                document.querySelectorAll('[data-copy-client-note]').forEach((button) => button.addEventListener('click', () => copy(clientNote, 'Client note copied.')));
                const builder = document.querySelector('[data-client-link-builder]');
                if (builder) {
                    const reading = builder.querySelector('[data-client-reading]');
                    const zip = builder.querySelector('[data-client-zip]');
                    const intent = builder.querySelector('[data-client-intent]');
                    const preparedStatus = builder.querySelector('[data-prepared-link-status]');
                    const preparedButton = builder.querySelector('[data-copy-prepared-link]');
                    preparedButton.addEventListener('click', () => {
                        const zipValue = zip.value.trim();
                        const readingValue = reading.value.trim();
                        if (!/^\d{5}$/.test(zipValue) || !/^\d{1,2}(?:\.\d{1,2})?$/.test(readingValue)) {
                            preparedStatus.textContent = 'Add a valid result and 5-digit property ZIP first.';
                            return;
                        }
                        const params = new URLSearchParams({
                            source: outreachSource,
                            zipCode: zipValue,
                            radonReading: readingValue,
                            intent: intent.value
                        });
                        const preparedUrl = window.location.origin + '/guides/radon-failed-inspection?' + params.toString();
                        copy(preparedUrl, 'Client follow-up link copied.');
                        preparedStatus.textContent = 'Prepared link copied: result, ZIP, and situation are included.';
                    });
                }
            })();
        </script>
    `
)
