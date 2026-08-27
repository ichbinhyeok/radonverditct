@import com.radonverdict.model.dto.SharedPlanSnapshot

@param SharedPlanSnapshot snapshot

@template.layout.main(
    title = "Private Radon Action Plan | RadonVerdict",
    description = "A private, read-only radon next-step plan shared by its creator.",
    canonicalUrl = null,
    noindex = true,
    minimalChrome = true,
    content = @`
        <main class="min-h-screen bg-stone-100 py-8 sm:py-14">
            <div class="mx-auto max-w-3xl px-4 sm:px-6">
                <header class="border-b border-stone-300 pb-7">
                    <a href="/" class="text-sm font-bold text-stone-600 hover:text-stone-950">RadonVerdict</a>
                    <p class="mt-8 text-xs font-bold uppercase tracking-[0.24em] text-emerald-800">Private read-only handoff</p>
                    <h1 class="mt-3 font-display text-4xl font-black tracking-tight text-stone-950 sm:text-5xl">${snapshot.verdictHeadline()}</h1>
                    <p class="mt-4 max-w-2xl text-lg font-semibold leading-relaxed text-stone-650">${snapshot.interpretation()}</p>
                </header>

                <section class="grid gap-px overflow-hidden rounded-2xl border border-stone-300 bg-stone-300 sm:grid-cols-3 mt-7">
                    <div class="bg-white p-5">
                        <p class="text-xs font-bold uppercase tracking-wider text-stone-500">Result</p>
                        <p class="mt-2 text-xl font-black text-stone-950">${snapshot.readingDisplay()}</p>
                    </div>
                    <div class="bg-white p-5">
                        <p class="text-xs font-bold uppercase tracking-wider text-stone-500">Situation</p>
                        <p class="mt-2 text-xl font-black text-stone-950">${snapshot.intentLabel()}</p>
                    </div>
                    <div class="bg-white p-5">
                        <p class="text-xs font-bold uppercase tracking-wider text-stone-500">Local match</p>
                        <p class="mt-2 text-xl font-black text-stone-950">${snapshot.countyName() != null ? snapshot.countyName() + ", " + snapshot.stateAbbr() : "Not resolved"}</p>
                    </div>
                </section>

                <section class="mt-8 rounded-2xl bg-stone-950 p-6 text-white sm:p-8">
                    <p class="text-xs font-bold uppercase tracking-[0.2em] text-emerald-300">What to do next</p>
                    <ol id="handoff-actions" class="mt-5 space-y-4">
                        @for (int i = 0; i < snapshot.actions().size(); i++)
                            <li class="flex gap-4 text-base font-semibold leading-relaxed text-stone-100">
                                <span class="flex h-7 w-7 shrink-0 items-center justify-center rounded-full bg-white text-sm font-black text-stone-950">${i + 1}</span>
                                <span>${snapshot.actions().get(i)}</span>
                            </li>
                        @endfor
                    </ol>
                    <button id="copy-handoff" type="button" class="mt-7 min-h-[48px] rounded-xl bg-white px-5 text-sm font-black text-stone-950">Copy action list</button>
                    <button id="copy-share-link" type="button" class="mt-3 min-h-[48px] rounded-xl border border-stone-600 px-5 text-sm font-black text-white">Copy private link</button>
                    <p id="copy-status" class="mt-3 text-sm font-semibold text-emerald-300" role="status" aria-live="polite"></p>
                </section>

                <section class="mt-8 border-t border-stone-300 pt-7">
                    <h2 class="font-display text-2xl font-black text-stone-950">Local evidence, with limits</h2>
                    @if (snapshot.evidenceSummary() != null)
                        <p class="mt-4 font-semibold leading-relaxed text-stone-700">${snapshot.evidenceSummary()}</p>
                    @else
                        <p class="mt-4 font-semibold leading-relaxed text-stone-700">No county measurement was attached. A county map cannot predict the result in one home.</p>
                    @endif
                    @if (snapshot.evidenceSourceName() != null)
                        <p class="mt-4 text-sm font-semibold text-stone-600">Source: ${snapshot.evidenceSourceName()}${snapshot.evidencePeriod() != null ? " · " + snapshot.evidencePeriod() : ""}</p>
                        @if (snapshot.evidenceSourceUrl() != null)
                            <a class="mt-2 inline-block text-sm font-black text-emerald-800 underline" href="${snapshot.evidenceSourceUrl()}" rel="noopener noreferrer">Open the source</a>
                        @endif
                    @endif
                </section>

                <section class="mt-8 rounded-2xl border border-amber-300 bg-amber-50 p-5 text-sm font-semibold leading-relaxed text-amber-950">
                    This link contains only the result, ZIP-derived county match, situation, and generated plan. It does not contain a name, street address, email, phone number, or inspection report. It expires automatically.
                </section>

                <footer class="mt-8 text-xs font-semibold leading-relaxed text-stone-500">
                    Created ${snapshot.createdAt().toString()} · Expires ${snapshot.expiresAt().toString()} · Decision ${snapshot.decisionVersion()} · Data ${snapshot.dataVersion()}
                </footer>
            </div>
        </main>
        <script>
            window.__rvSuppressGenericPageView = true;
            document.getElementById('copy-handoff')?.addEventListener('click', async function () {
                const text = Array.from(document.querySelectorAll('#handoff-actions li span:last-child'))
                    .map((element, index) => (index + 1) + '. ' + element.textContent.trim())
                    .join('\n');
                const status = document.getElementById('copy-status');
                try {
                    await navigator.clipboard.writeText(text);
                    status.textContent = 'Action list copied.';
                    if (typeof window.rvTrack === 'function') window.rvTrack('handoff_action_copied', { schema_version: 1 });
                } catch (error) {
                    status.textContent = 'Copy was blocked. Select the list and copy it manually.';
                }
            });
            document.getElementById('copy-share-link')?.addEventListener('click', async function () {
                const status = document.getElementById('copy-status');
                try {
                    await navigator.clipboard.writeText(window.location.href);
                    status.textContent = 'Private link copied.';
                    if (typeof window.rvTrack === 'function') window.rvTrack('share_copy_succeeded', { schema_version: 1 });
                } catch (error) {
                    status.textContent = 'Copy was blocked. Copy the address from your browser.';
                }
            });
        </script>
    `
)
