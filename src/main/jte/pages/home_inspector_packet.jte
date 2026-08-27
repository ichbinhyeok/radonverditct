@param String packetSource = "home-inspector-packet"
@param String inspectorPreviewName = null
@param boolean salesDemo = false
@param String pageTitle = "Radon Client Handoff for Home Inspectors | RadonVerdict"
@param String canonicalUrl = "https://radonverdict.com/for-home-inspectors"

@template.layout.main(
    title = pageTitle,
    canonicalUrl = canonicalUrl,
    description = "Create a private radon next-step link for a client without uploading their name, address, email, phone number, or inspection report.",
    noindex = true,
    content = @`
        <section class="bg-stone-950 text-white">
            <div class="mx-auto grid max-w-6xl gap-12 px-4 py-14 sm:px-6 sm:py-20 lg:grid-cols-[0.9fr_1.1fr] lg:items-center">
                <div>
                    <p class="text-xs font-black uppercase tracking-[0.24em] text-emerald-300">Inspector handoff</p>
                    <h1 class="mt-5 font-display text-5xl font-black leading-[1.02] tracking-tight sm:text-6xl">Give the client a next step, not another wall of text.</h1>
                    <p class="mt-6 max-w-xl text-lg font-semibold leading-relaxed text-stone-300">Enter the reading, ZIP, and transaction context. RadonVerdict creates a private plan the client can open after the inspection conversation.</p>
                    <ul class="mt-7 space-y-3 text-sm font-bold text-stone-200">
                        <li>✓ No contractor recommendation or referral fee</li>
                        <li>✓ No client identity or inspection report required</li>
                        <li>✓ Result, evidence, and decision versions stay fixed</li>
                    </ul>
                </div>

                <div class="rounded-3xl bg-white p-5 text-stone-950 shadow-2xl sm:p-8">
                    <p class="text-xs font-black uppercase tracking-[0.22em] text-stone-500">Create the plan</p>
                    <h2 class="mt-2 font-display text-2xl font-black">Use only what is already in the report</h2>
                    <form action="/plan" method="get" class="mt-6 space-y-5">
                        <input type="hidden" name="source" value="${packetSource}">
                        <div class="grid gap-4 sm:grid-cols-2">
                            <div>
                                <label for="inspector-reading" class="text-sm font-black">Radon result</label>
                                <div class="mt-2 flex items-center rounded-xl border border-stone-300 px-4">
                                    <input id="inspector-reading" name="radonReading" required type="number" min="0" max="999" step="0.01" inputmode="decimal" placeholder="5.8" class="min-h-[56px] min-w-0 flex-1 border-0 bg-transparent text-2xl font-black outline-none">
                                    <span class="ml-2 text-xs font-black text-stone-500">pCi/L</span>
                                </div>
                            </div>
                            <div>
                                <label for="inspector-zip" class="text-sm font-black">Property ZIP</label>
                                <input id="inspector-zip" name="zipCode" required inputmode="numeric" pattern="[0-9]{5}" maxlength="5" placeholder="22030" class="mt-2 min-h-[56px] w-full rounded-xl border border-stone-300 px-4 text-lg font-black outline-none">
                            </div>
                        </div>
                        <div>
                            <label for="inspector-intent" class="text-sm font-black">Client situation</label>
                            <select id="inspector-intent" name="intent" class="mt-2 min-h-[56px] w-full rounded-xl border border-stone-300 bg-white px-4 font-bold">
                                <option value="buying">Buying</option>
                                <option value="selling">Selling</option>
                                <option value="homeowner">Living here</option>
                            </select>
                        </div>
                        <button type="submit" class="min-h-[56px] w-full rounded-xl bg-emerald-800 px-6 font-black text-white hover:bg-emerald-900">Preview the client plan</button>
                    </form>
                    <p class="mt-4 text-xs font-semibold leading-relaxed text-stone-500">The next screen lets you create a random, expiring share link. The URL does not expose the reading or ZIP.</p>
                </div>
            </div>
        </section>

        <section class="bg-stone-100">
            <div class="mx-auto max-w-5xl px-4 py-14 sm:px-6 sm:py-20">
                <div class="grid gap-10 lg:grid-cols-[0.8fr_1.2fr]">
                    <div>
                        <p class="text-xs font-black uppercase tracking-[0.22em] text-emerald-800">Fits beside your report</p>
                        <h2 class="mt-3 font-display text-3xl font-black text-stone-950">This is not inspection software.</h2>
                        <p class="mt-4 font-semibold leading-relaxed text-stone-700">Keep scheduling, report writing, agreements, and delivery in your existing system. RadonVerdict handles one narrow moment: translating a result into a calm client handoff.</p>
                    </div>
                    <div class="rounded-2xl border border-stone-300 bg-white p-6 sm:p-8">
                        <p class="text-xs font-black uppercase tracking-[0.2em] text-stone-500">Suggested note</p>
                        <blockquote id="inspector-note" class="mt-4 text-lg font-semibold leading-relaxed text-stone-800">“Here is a private next-step plan based on the radon result and ZIP. It explains what the reading means, separates county evidence from the home result, and lists the next actions. It does not recommend a contractor or replace your report.”</blockquote>
                        <button id="copy-inspector-note" type="button" class="mt-6 min-h-[46px] rounded-xl border border-stone-300 px-5 text-sm font-black text-stone-900">Copy note</button>
                        <p id="inspector-copy-status" class="mt-3 text-sm font-bold text-emerald-800" role="status" aria-live="polite"></p>
                    </div>
                </div>
            </div>
        </section>
        <script>
            if (typeof window.rvTrack === 'function') {
                window.rvTrack('inspector_landing_view', { schema_version: 1 });
            }
            document.getElementById('copy-inspector-note')?.addEventListener('click', async function () {
                const status = document.getElementById('inspector-copy-status');
                try {
                    await navigator.clipboard.writeText(document.getElementById('inspector-note').textContent.trim());
                    status.textContent = 'Client note copied.';
                } catch (error) {
                    status.textContent = 'Copy was blocked. Select the note and copy it manually.';
                }
            });
        </script>
    `
)
