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
        <style>
            .inspector-demo-shell { background: #10211e; color: #fff; }
            .inspector-demo-eyebrow { color: #9dd9b9; }
            .inspector-demo-dot { background: #9dd9b9; }
            .inspector-demo-primary { background: #d8f06a; color: #10211e; }
            .inspector-demo-primary:hover { background: #efffa7; }
            .inspector-demo-status { color: #d8f06a; }
            .inspector-demo-rule { border-color: rgba(255, 255, 255, .2); }
            .inspector-demo-browser { background: #f7f8f4; }
            .inspector-demo-client-left { background: #edf2ec; }
            .inspector-demo-client-accent { color: #397857; }
            .inspector-demo-client-button { background: #10211e; }
            .inspector-demo-client-button:hover { background: #24463e; }
        </style>
        <main class="inspector-demo-shell">
            <section class="min-h-[calc(100svh-65px)] overflow-hidden">
                <div class="mx-auto flex min-h-[calc(100svh-65px)] max-w-7xl flex-col px-4 py-6 sm:px-6 sm:py-8 lg:px-8">
                    <div class="inspector-demo-rule flex items-center justify-between border-b pb-4 text-[11px] font-bold uppercase tracking-[0.18em] text-white/70">
                        <span>RadonVerdict / inspector follow-up</span>
                        <span class="hidden sm:inline">A real client-ready link</span>
                    </div>

                    <div class="grid flex-1 gap-8 py-8 lg:grid-cols-[0.8fr_1.2fr] lg:items-center lg:gap-14 lg:py-10">
                        <div class="max-w-xl">
                            <p class="inspector-demo-eyebrow text-xs font-black uppercase tracking-[0.2em]">One result. One useful next step.</p>
                            <h1 class="mt-4 font-display text-4xl font-black leading-[1.02] sm:text-5xl lg:text-6xl">Stop explaining the same radon result twice.</h1>
                            <p class="mt-5 max-w-lg text-base leading-relaxed text-white/75 sm:text-lg">Put this link below the report. Your client sees their result, local context, and the repair-or-credit decision path without you becoming the adviser.</p>

                            <div class="mt-7 flex flex-wrap gap-x-5 gap-y-3 text-sm font-bold text-white/85">
                                <span class="flex items-center gap-2"><i class="inspector-demo-dot h-2 w-2"></i>No login</span>
                                <span class="flex items-center gap-2"><i class="inspector-demo-dot h-2 w-2"></i>No client data</span>
                                <span class="flex items-center gap-2"><i class="inspector-demo-dot h-2 w-2"></i>No contractor recommendation</span>
                            </div>

                            <div class="mt-8 flex flex-wrap gap-3">
                                <a href="${demoUrl}" data-track-event="inspector_demo_open_client" class="inspector-demo-primary inline-flex min-h-[50px] items-center px-5 text-sm font-black transition-colors">Open the live client view <span class="ml-3 text-lg">→</span></a>
                                <button type="button" data-copy-demo-link data-track-event="inspector_demo_copy_link" class="inline-flex min-h-[50px] items-center border border-white/35 px-5 text-sm font-black text-white transition-colors hover:bg-white/10">Copy the client link</button>
                            </div>
                            <p data-demo-status class="inspector-demo-status mt-3 min-h-5 text-sm font-bold" aria-live="polite"></p>
                        </div>

                        <div class="relative mx-auto w-full max-w-2xl lg:max-w-none">
                            <div class="inspector-demo-primary absolute -left-3 top-12 hidden h-[72%] w-px lg:block"></div>
                            <div class="inspector-demo-browser border border-white/25 p-2 shadow-[18px_18px_0_rgba(0,0,0,0.22)] sm:p-3">
                                <div class="flex items-center gap-2 border-b border-slate-200 px-2 py-2 text-[10px] font-bold uppercase tracking-[0.14em] text-slate-500 sm:px-3">
                                    <span class="h-2 w-2 rounded-full bg-[#d9573f]"></span><span class="h-2 w-2 rounded-full bg-[#e7bd54]"></span><span class="h-2 w-2 rounded-full bg-[#7ebd91]"></span>
                                    <span class="ml-2 truncate">radonverdict.com / your-client-plan</span>
                                </div>
                                <div class="grid lg:grid-cols-[0.92fr_1.08fr]">
                                    <div class="inspector-demo-client-left p-5 text-slate-950 sm:p-7">
                                        <div class="flex items-center gap-3">
                                            <span class="grid h-9 w-9 place-items-center bg-[#10211e] text-xs font-black text-white">YI</span>
                                            <div><p class="text-sm font-black">Your Inspection Company</p><p class="text-xs text-slate-500">Shared after your inspection</p></div>
                                        </div>
                                        <p class="inspector-demo-client-accent mt-8 text-xs font-black uppercase tracking-[0.16em]">Your radon result</p>
                                        <p class="mt-2 font-display text-5xl font-black leading-none tracking-normal">5.8 <span class="text-lg">pCi/L</span></p>
                                        <p class="mt-3 max-w-xs text-sm leading-relaxed text-slate-600">This is above the EPA action level. Start with the decision, not a generic search.</p>
                                        <div class="mt-8 border-t border-slate-300 pt-4 text-xs font-bold uppercase tracking-[0.12em] text-slate-500">
                                            Fairfax, VA <span class="mx-2 text-slate-300">/</span> Buying a home
                                        </div>
                                    </div>
                                    <div class="p-5 text-slate-950 sm:p-7">
                                        <p class="inspector-demo-client-accent text-xs font-black uppercase tracking-[0.16em]">Your next-step guide</p>
                                        <h2 class="mt-3 font-display text-3xl font-black leading-[1.08]">What do you need to decide before closing?</h2>
                                        <div class="mt-6 divide-y divide-slate-200 border-y border-slate-200">
                                            <div class="flex gap-3 py-4"><span class="inspector-demo-client-accent text-sm font-black">01</span><div><p class="text-sm font-black">Use a local mitigation range</p><p class="mt-1 text-sm leading-relaxed text-slate-600">Set a credible repair or credit starting point.</p></div></div>
                                            <div class="flex gap-3 py-4"><span class="inspector-demo-client-accent text-sm font-black">02</span><div><p class="text-sm font-black">Choose the transaction path</p><p class="mt-1 text-sm leading-relaxed text-slate-600">Repair, seller credit, or a retest plan.</p></div></div>
                                        </div>
                                        <a href="${demoUrl}" data-track-event="inspector_demo_open_client" class="inspector-demo-client-button mt-6 flex min-h-[48px] items-center justify-between px-4 text-sm font-black text-white transition-colors">Build my local plan <span class="text-lg">→</span></a>
                                        <p class="mt-3 text-xs leading-relaxed text-slate-500">Your inspector is not recommending a contractor or negotiating the transaction.</p>
                                    </div>
                                </div>
                            </div>
                            <div class="mt-4 flex items-center gap-3 text-xs font-bold text-white/60"><span class="inspector-demo-rule h-px flex-1 border-t"></span>This is the actual customer experience<span class="inspector-demo-rule h-px flex-1 border-t"></span></div>
                        </div>
                    </div>

                    <div class="inspector-demo-rule border-t pt-4 text-xs font-medium leading-relaxed text-white/55 sm:flex sm:items-center sm:justify-between sm:gap-6">
                        <span>Try it on one recent elevated result. If it is not useful, you do not need to use it again.</span>
                        <button type="button" data-copy-demo-note data-track-event="inspector_demo_copy_note" class="mt-2 underline decoration-white/40 underline-offset-4 hover:text-white sm:mt-0">Copy the short note for your report</button>
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
                        status.textContent = 'Copy is unavailable in this browser. Open the client view instead.';
                    }
                };
                document.querySelector('[data-copy-demo-link]').addEventListener('click', () => copy(demoUrl, 'Client link copied.'));
                document.querySelector('[data-copy-demo-note]').addEventListener('click', () => copy(demoNote, 'Client note copied.'));
            })();
        </script>
    `
)
