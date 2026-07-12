@import com.radonverdict.util.JsonLdUtils

!{
    final String demoUrl = "/guides/radon-failed-inspection?source=inspector-demo&zipCode=22030&radonReading=5.8&intent=buying";
    final String clientNote = "Your radon result was 5.8 pCi/L. This independent next-step guide explains the result, shows local decision context, and helps you prepare for the repair or credit conversation.\n\nLink: ";
}

@template.layout.main(
    title = "Inspector Client Follow-Up Link Demo | RadonVerdict",
    canonicalUrl = "https://radonverdict.com/for-home-inspectors/demo",
    description = "A working demo of a client-ready radon follow-up link for home inspectors.",
    content = @`
        <main class="bg-[#f5f7f6] text-slate-950">
            <section class="border-b border-slate-200 bg-white">
                <div class="mx-auto flex max-w-6xl items-center justify-between gap-5 px-4 py-4 sm:px-6 lg:px-8">
                    <div class="flex items-center gap-3">
                        <span class="grid h-9 w-9 place-items-center bg-[#0d5c4e] text-sm font-black text-white">YI</span>
                        <div>
                            <p class="text-sm font-black">Your Inspection Company</p>
                            <p class="text-xs font-semibold text-slate-500">Client follow-up link preview</p>
                        </div>
                    </div>
                    <span class="hidden border border-[#0d5c4e]/25 bg-[#e4f3ee] px-3 py-1.5 text-xs font-black text-[#0d5c4e] sm:inline-flex">Working demo</span>
                </div>
            </section>

            <section class="mx-auto grid max-w-6xl gap-10 px-4 py-12 sm:px-6 sm:py-16 lg:grid-cols-[0.75fr_1.25fr] lg:items-start lg:px-8">
                <div class="pt-2">
                    <p class="text-xs font-black uppercase tracking-[0.2em] text-[#0d5c4e]">After the report</p>
                    <h1 class="mt-4 max-w-md font-display text-4xl font-black leading-[1.04] text-slate-950 sm:text-5xl">Give clients the next step without writing it again.</h1>
                    <p class="mt-5 max-w-md text-base font-medium leading-relaxed text-slate-600">This is the page a customer receives after an elevated radon result. It explains the decision without making the inspector a mitigation company or negotiation adviser.</p>
                    <dl class="mt-8 space-y-4 border-t border-slate-300 pt-6">
                        <div class="grid grid-cols-[26px_1fr] gap-3">
                            <dt class="grid h-6 w-6 place-items-center bg-[#0d5c4e] text-xs font-black text-white">1</dt>
                            <dd><strong class="text-sm">Paste one link below the report.</strong><p class="mt-1 text-sm leading-relaxed text-slate-600">No client account, report upload, or address required.</p></dd>
                        </div>
                        <div class="grid grid-cols-[26px_1fr] gap-3">
                            <dt class="grid h-6 w-6 place-items-center bg-[#d9573f] text-xs font-black text-white">2</dt>
                            <dd><strong class="text-sm">Keep your role clear.</strong><p class="mt-1 text-sm leading-relaxed text-slate-600">The client gets facts and decision paths, not a contractor recommendation from you.</p></dd>
                        </div>
                    </dl>
                </div>

                <div class="border border-slate-300 bg-white shadow-[0_18px_45px_rgba(15,23,42,0.10)]">
                    <div class="flex items-center justify-between border-b border-slate-200 px-5 py-4 sm:px-6">
                        <div>
                            <p class="text-xs font-black uppercase tracking-[0.16em] text-slate-500">Client view</p>
                            <p class="mt-1 text-sm font-bold text-slate-900">Shared by Your Inspection Company</p>
                        </div>
                        <span class="border border-slate-200 px-2.5 py-1 text-xs font-black text-slate-600">No login</span>
                    </div>

                    <div class="grid gap-0 lg:grid-cols-[1.05fr_0.95fr]">
                        <div class="p-5 sm:p-7">
                            <p class="text-xs font-black uppercase tracking-[0.18em] text-[#0d5c4e]">Your inspection context</p>
                            <h2 class="mt-3 font-display text-3xl font-black leading-tight text-slate-950">Your result deserves a clear decision.</h2>
                            <div class="mt-6 grid grid-cols-3 border-y border-slate-200">
                                <div class="py-3 pr-3"><p class="text-xs font-bold text-slate-500">RESULT</p><p class="mt-1 text-lg font-black">5.8 <span class="text-xs">pCi/L</span></p></div>
                                <div class="border-l border-slate-200 px-3 py-3"><p class="text-xs font-bold text-slate-500">ZIP</p><p class="mt-1 text-lg font-black">22030</p></div>
                                <div class="border-l border-slate-200 px-3 py-3"><p class="text-xs font-bold text-slate-500">SITUATION</p><p class="mt-1 text-lg font-black">Buying</p></div>
                            </div>
                            <p class="mt-5 text-sm leading-relaxed text-slate-600">Start with the valid test result, then compare a local mitigation range with the repair or credit decision before your deadline.</p>
                            <a href="${demoUrl}" data-track-event="inspector_demo_open_client" class="mt-6 inline-flex min-h-[48px] items-center justify-center bg-[#0d5c4e] px-5 text-sm font-black text-white transition-colors hover:bg-[#08453a]">Open the working client page</a>
                        </div>

                        <aside class="border-t border-slate-200 bg-[#eaf3f0] p-5 sm:p-7 lg:border-l lg:border-t-0">
                            <p class="text-xs font-black uppercase tracking-[0.18em] text-[#0d5c4e]">What it answers</p>
                            <ol class="mt-5 space-y-5">
                                <li><p class="text-sm font-black">What does this result mean?</p><p class="mt-1 text-sm leading-relaxed text-slate-600">A factual explanation before the client searches through generic advice.</p></li>
                                <li><p class="text-sm font-black">What could the next step cost?</p><p class="mt-1 text-sm leading-relaxed text-slate-600">Local context before anyone picks an arbitrary repair or credit number.</p></li>
                                <li><p class="text-sm font-black">Who decides what happens next?</p><p class="mt-1 text-sm leading-relaxed text-slate-600">The client chooses a path; the inspection remains an inspection.</p></li>
                            </ol>
                        </aside>
                    </div>

                    <div class="border-t border-slate-200 bg-slate-50 p-5 sm:p-6">
                        <div class="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
                            <div>
                                <p class="text-sm font-black text-slate-950">What you paste below the report</p>
                                <p class="mt-1 text-sm leading-relaxed text-slate-600">A short factual note. The customer can open it when they are ready.</p>
                            </div>
                            <div class="flex shrink-0 gap-2">
                                <button type="button" data-copy-demo-note data-track-event="inspector_demo_copy_note" class="inline-flex min-h-[44px] items-center justify-center border border-slate-300 bg-white px-4 text-sm font-black text-slate-900 hover:bg-slate-100">Copy note</button>
                                <button type="button" data-copy-demo-link data-track-event="inspector_demo_copy_link" class="inline-flex min-h-[44px] items-center justify-center bg-slate-950 px-4 text-sm font-black text-white hover:bg-slate-800">Copy link</button>
                            </div>
                        </div>
                        <p data-demo-status class="mt-3 min-h-5 text-sm font-bold text-[#0d5c4e]" aria-live="polite"></p>
                    </div>
                </div>
            </section>
        </main>

        <script>
            (() => {
                const demoUrl = window.location.origin + '${demoUrl}';
                const demoNote = $unsafe{JsonLdUtils.json(clientNote)} + demoUrl;
                const status = document.querySelector('[data-demo-status]');
                const copy = async (value, message) => {
                    try {
                        await navigator.clipboard.writeText(value);
                        status.textContent = message;
                    } catch (error) {
                        status.textContent = 'Copy is unavailable in this browser. Open the client page instead.';
                    }
                };
                document.querySelector('[data-copy-demo-link]').addEventListener('click', () => copy(demoUrl, 'Client follow-up link copied.'));
                document.querySelector('[data-copy-demo-note]').addEventListener('click', () => copy(demoNote, 'Client note copied.'));
            })();
        </script>
    `
)
