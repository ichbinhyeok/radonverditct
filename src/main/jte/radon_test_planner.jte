@import com.radonverdict.util.JsonLdUtils

!{
    final String seoTitle = "Radon Test Planner & Validity Check | RadonVerdict";
    final String seoDescription = "Create a home radon test record and check the method, placement, timing, and conditions against source-linked testing guidance.";
}

@template.layout.main(
    title = seoTitle,
    canonicalUrl = "https://radonverdict.com/radon-test-planner",
    description = seoDescription,
    headContent = @`
        <script type="application/ld+json">
        {"@@context":"https://schema.org","@@type":"WebApplication","name":"Radon Test Planner","url":"https://radonverdict.com/radon-test-planner","applicationCategory":"HealthApplication","operatingSystem":"Any","description":$unsafe{JsonLdUtils.json(seoDescription)}}
        </script>
        <style>
            .rv-planner-step { display: none; }
            .rv-planner-step.is-active { display: block; animation: rv-step-in .28s cubic-bezier(.2,.75,.25,1) both; }
            .rv-choice input:checked + span { border-color: #245542; background: #eef2e8; box-shadow: inset 5px 0 0 #245542; }
            .rv-choice input:focus-visible + span { outline: 3px solid rgba(36,85,66,.25); outline-offset: 3px; }
            .rv-record-row { display: grid; grid-template-columns: minmax(120px,.35fr) 1fr; gap: 20px; padding: 13px 0; border-bottom: 1px solid #d9d3c7; }
            @keyframes rv-step-in { from { opacity: 0; transform: translateX(14px); } to { opacity: 1; transform: none; } }
            @media (max-width: 639px) { .rv-record-row { grid-template-columns: 1fr; gap: 3px; } }
            @media (prefers-reduced-motion: reduce) { .rv-planner-step.is-active { animation: none; } }
            @media print {
                body { background: white !important; }
                body > header, body > footer, .rv-planner-shell, .rv-record-actions { display: none !important; }
                #rv-record { display: block !important; margin: 0; padding: 0; color: #142019; }
                #rv-record .rv-record-paper { border: 0; box-shadow: none; }
            }
        </style>
    `,
    content = @`
        <section class="border-b border-paper-rule bg-paper">
            <div class="mx-auto max-w-7xl px-4 py-8 sm:px-6 lg:px-8">
                <div class="flex flex-col gap-4 sm:flex-row sm:items-end sm:justify-between">
                    <div>
                        <p class="text-xs font-black uppercase tracking-[0.22em] text-pine">Test workspace</p>
                        <h1 class="mt-2 font-display text-4xl font-bold tracking-tight text-ink sm:text-5xl">Radon test record</h1>
                    </div>
                    <p class="max-w-lg text-sm font-semibold leading-relaxed text-stone-600">A procedural check based on the details you enter. It does not certify a test or diagnose a property.</p>
                </div>
            </div>
        </section>

        <div id="rv-test-planner" class="rv-planner-shell bg-paper-light" data-storage-key="rv-test-record-v1">
            <div class="mx-auto grid max-w-7xl gap-10 px-4 py-10 sm:px-6 sm:py-14 lg:grid-cols-[220px_minmax(0,760px)] lg:px-8">
                <aside aria-label="Test record progress" class="lg:sticky lg:top-28 lg:self-start">
                    <div class="flex items-center justify-between text-xs font-black uppercase tracking-wider text-stone-500">
                        <span id="rv-step-label">Step 1 of 6</span><span id="rv-save-status" role="status">Saved locally</span>
                    </div>
                    <div class="mt-3 h-1 overflow-hidden bg-paper-rule"><div id="rv-progress" class="h-full bg-pine transition-all duration-300" style="width:16.67%"></div></div>
                    <p id="rv-rule-version" class="mt-3 text-xs font-semibold leading-relaxed text-stone-500">Loading official-source checks…</p>
                    <ol class="mt-7 hidden space-y-4 text-sm font-bold lg:block" id="rv-step-list">
                        <li data-step-marker="0" class="text-pine">01 · Test stage</li>
                        <li data-step-marker="1" class="text-stone-400">02 · Reason</li>
                        <li data-step-marker="2" class="text-stone-400">03 · Device</li>
                        <li data-step-marker="3" class="text-stone-400">04 · Placement</li>
                        <li data-step-marker="4" class="text-stone-400">05 · Conditions</li>
                        <li data-step-marker="5" class="text-stone-400">06 · Result</li>
                    </ol>
                    <button id="rv-reset" type="button" class="mt-8 hidden border-b border-stone-400 text-xs font-bold text-stone-500 hover:border-ink hover:text-ink lg:inline-block">Clear this record</button>
                </aside>

                <div>
                    <form id="rv-planner-form" novalidate>
                        <section class="rv-planner-step is-active" data-step="0" aria-labelledby="rv-question-0">
                            <p class="text-xs font-black uppercase tracking-[0.2em] text-pine">First, orient the record</p>
                            <h2 id="rv-question-0" class="mt-3 font-display text-4xl font-bold leading-tight text-ink sm:text-5xl">Where are you in the test?</h2>
                            <p class="mt-4 max-w-2xl font-semibold leading-relaxed text-stone-600">The planner changes its wording depending on whether the device has been placed yet.</p>
                            <fieldset class="mt-9 space-y-3">
                                <legend class="sr-only">Current test stage</legend>
                                <label class="rv-choice block cursor-pointer"><input class="sr-only" type="radio" name="stage" value="planning"><span class="block rounded-lg border border-paper-rule bg-white p-5 transition"><strong class="block text-lg text-ink">I am preparing a test</strong><small class="mt-1 block text-sm font-semibold text-stone-500">Build a setup checklist before opening or activating the device.</small></span></label>
                                <label class="rv-choice block cursor-pointer"><input class="sr-only" type="radio" name="stage" value="running"><span class="block rounded-lg border border-paper-rule bg-white p-5 transition"><strong class="block text-lg text-ink">A test is running now</strong><small class="mt-1 block text-sm font-semibold text-stone-500">Record the placement and anything that may affect the test.</small></span></label>
                                <label class="rv-choice block cursor-pointer"><input class="sr-only" type="radio" name="stage" value="finished"><span class="block rounded-lg border border-paper-rule bg-white p-5 transition"><strong class="block text-lg text-ink">The test is finished</strong><small class="mt-1 block text-sm font-semibold text-stone-500">Check the procedure before relying on the reported number.</small></span></label>
                            </fieldset>
                        </section>

                        <section class="rv-planner-step" data-step="1" aria-labelledby="rv-question-1">
                            <p class="text-xs font-black uppercase tracking-[0.2em] text-pine">Testing situation</p>
                            <h2 id="rv-question-1" class="mt-3 font-display text-4xl font-bold leading-tight text-ink sm:text-5xl">Why is this home being tested?</h2>
                            <fieldset class="mt-9 space-y-3">
                                <legend class="sr-only">Reason for testing</legend>
                                <label class="rv-choice block cursor-pointer"><input class="sr-only" type="radio" name="purpose" value="first"><span class="block rounded-lg border border-paper-rule bg-white p-5 transition"><strong class="block text-lg">First or routine home test</strong><small class="mt-1 block text-sm font-semibold text-stone-500">No known recent elevated result or mitigation work.</small></span></label>
                                <label class="rv-choice block cursor-pointer"><input class="sr-only" type="radio" name="purpose" value="transaction"><span class="block rounded-lg border border-paper-rule bg-white p-5 transition"><strong class="block text-lg">Buying or selling a home</strong><small class="mt-1 block text-sm font-semibold text-stone-500">Transaction tests may require a qualified tester or a specific protocol.</small></span></label>
                                <label class="rv-choice block cursor-pointer"><input class="sr-only" type="radio" name="purpose" value="confirm"><span class="block rounded-lg border border-paper-rule bg-white p-5 transition"><strong class="block text-lg">Confirming an earlier result</strong><small class="mt-1 block text-sm font-semibold text-stone-500">A follow-up short-term or longer-term test.</small></span></label>
                                <label class="rv-choice block cursor-pointer"><input class="sr-only" type="radio" name="purpose" value="post-mitigation"><span class="block rounded-lg border border-paper-rule bg-white p-5 transition"><strong class="block text-lg">Checking after mitigation</strong><small class="mt-1 block text-sm font-semibold text-stone-500">Verify that a reduction system is still reducing the measured level.</small></span></label>
                            </fieldset>
                        </section>

                        <section class="rv-planner-step" data-step="2" aria-labelledby="rv-question-2">
                            <p class="text-xs font-black uppercase tracking-[0.2em] text-pine">Measurement method</p>
                            <h2 id="rv-question-2" class="mt-3 font-display text-4xl font-bold leading-tight text-ink sm:text-5xl">What kind of device are you using?</h2>
                            <p class="mt-4 max-w-2xl font-semibold leading-relaxed text-stone-600">Use the label or instructions that came with the device. The exact device instructions override this general planner.</p>
                            <a class="mt-3 inline-flex text-sm font-black text-pine underline" href="/guides/short-term-vs-long-term-radon-test">See how long each radon test takes →</a>
                            <fieldset class="mt-9 space-y-3">
                                <legend class="sr-only">Radon test device type</legend>
                                <label class="rv-choice block cursor-pointer"><input class="sr-only" type="radio" name="device" value="short"><span class="block rounded-lg border border-paper-rule bg-white p-5 transition"><strong class="block text-lg">Short-term passive kit</strong><small class="mt-1 block text-sm font-semibold text-stone-500">Usually left in place for 2–90 days, depending on the kit.</small></span></label>
                                <label class="rv-choice block cursor-pointer"><input class="sr-only" type="radio" name="device" value="long"><span class="block rounded-lg border border-paper-rule bg-white p-5 transition"><strong class="block text-lg">Long-term passive kit</strong><small class="mt-1 block text-sm font-semibold text-stone-500">Measures for more than 90 days.</small></span></label>
                                <label class="rv-choice block cursor-pointer"><input class="sr-only" type="radio" name="device" value="continuous"><span class="block rounded-lg border border-paper-rule bg-white p-5 transition"><strong class="block text-lg">Continuous electronic monitor</strong><small class="mt-1 block text-sm font-semibold text-stone-500">A reusable device that records readings over time.</small></span></label>
                                <label class="rv-choice block cursor-pointer"><input class="sr-only" type="radio" name="device" value="unknown"><span class="block rounded-lg border border-paper-rule bg-white p-5 transition"><strong class="block text-lg">I am not sure</strong><small class="mt-1 block text-sm font-semibold text-stone-500">Keep the package or report available before assessing the procedure.</small></span></label>
                            </fieldset>
                        </section>

                        <section class="rv-planner-step" data-step="3" aria-labelledby="rv-question-3">
                            <p class="text-xs font-black uppercase tracking-[0.2em] text-pine">Placement record</p>
                            <h2 id="rv-question-3" class="mt-3 font-display text-4xl font-bold leading-tight text-ink sm:text-5xl">Where was the device placed?</h2>
                            <a class="mt-3 inline-flex text-sm font-black text-pine underline" href="/guides/where-to-place-radon-test">Check the best room, floor, and height →</a>
                            <div class="mt-8 grid gap-6 sm:grid-cols-2">
                                <label class="block"><span class="text-sm font-black text-ink">Level</span><select name="level" class="mt-2 min-h-[52px] w-full rounded-lg border border-paper-rule bg-white px-4 font-semibold outline-none focus:border-pine focus:ring-2 focus:ring-pine/20"><option value="">Choose one</option><option value="basement">Basement</option><option value="first">First floor</option><option value="upper">Upper floor</option><option value="unit-lowest">Lowest level inside my unit</option></select></label>
                                <label class="block"><span class="text-sm font-black text-ink">Room</span><select name="room" class="mt-2 min-h-[52px] w-full rounded-lg border border-paper-rule bg-white px-4 font-semibold outline-none focus:border-pine focus:ring-2 focus:ring-pine/20"><option value="">Choose one</option><option value="living">Living room / family room</option><option value="bedroom">Bedroom</option><option value="office">Office / den</option><option value="open-basement">Open basement area</option><option value="kitchen-bath">Kitchen or bathroom</option><option value="storage">Closet or storage area</option><option value="other">Other</option></select></label>
                                <label class="block"><span class="text-sm font-black text-ink">ZIP code <small class="font-semibold text-stone-500">optional</small></span><input name="zip" type="text" inputmode="numeric" pattern="[0-9]{5}" maxlength="5" placeholder="12345" class="mt-2 min-h-[52px] w-full rounded-lg border border-paper-rule bg-white px-4 font-semibold outline-none focus:border-pine focus:ring-2 focus:ring-pine/20"></label>
                                <label class="block"><span class="text-sm font-black text-ink">Device / kit name <small class="font-semibold text-stone-500">optional</small></span><input name="deviceName" type="text" maxlength="80" placeholder="Name on the package" class="mt-2 min-h-[52px] w-full rounded-lg border border-paper-rule bg-white px-4 font-semibold outline-none focus:border-pine focus:ring-2 focus:ring-pine/20"></label>
                            </div>
                            <fieldset class="mt-7"><legend class="text-sm font-black text-ink">Did the placement follow the device instructions?</legend><div class="mt-3 grid gap-3 sm:grid-cols-3"><label class="rv-choice cursor-pointer"><input class="sr-only" type="radio" name="placementInstructions" value="yes"><span class="block rounded-lg border border-paper-rule bg-white p-4 font-bold">Yes</span></label><label class="rv-choice cursor-pointer"><input class="sr-only" type="radio" name="placementInstructions" value="no"><span class="block rounded-lg border border-paper-rule bg-white p-4 font-bold">No</span></label><label class="rv-choice cursor-pointer"><input class="sr-only" type="radio" name="placementInstructions" value="unsure"><span class="block rounded-lg border border-paper-rule bg-white p-4 font-bold">Not sure</span></label></div></fieldset>
                        </section>

                        <section class="rv-planner-step" data-step="4" aria-labelledby="rv-question-4">
                            <p class="text-xs font-black uppercase tracking-[0.2em] text-pine">Timing and disruptions</p>
                            <h2 id="rv-question-4" class="mt-3 font-display text-4xl font-bold leading-tight text-ink sm:text-5xl">What happened during the test?</h2>
                            <div class="mt-3 flex flex-wrap gap-x-5 gap-y-2 text-sm font-black text-pine"><a class="underline" href="/guides/radon-closed-house-conditions">12-hour closed-house checklist →</a><a class="underline" href="/guides/is-my-radon-test-valid">6 validity problems →</a></div>
                            <div class="mt-8 grid gap-6 sm:grid-cols-2">
                                <label class="block"><span class="text-sm font-black text-ink">Start date and time <small class="font-semibold text-stone-500">optional</small></span><input name="startDate" type="datetime-local" class="mt-2 min-h-[52px] w-full rounded-lg border border-paper-rule bg-white px-4 font-semibold outline-none focus:border-pine focus:ring-2 focus:ring-pine/20"></label>
                                <label class="block"><span class="text-sm font-black text-ink">End date and time <small class="font-semibold text-stone-500">optional</small></span><input name="endDate" type="datetime-local" class="mt-2 min-h-[52px] w-full rounded-lg border border-paper-rule bg-white px-4 font-semibold outline-none focus:border-pine focus:ring-2 focus:ring-pine/20"></label>
                                <label class="block"><span class="text-sm font-black text-ink">Duration in hours</span><input name="durationHours" type="number" min="0.1" max="87600" step="0.1" placeholder="48" class="mt-2 min-h-[52px] w-full rounded-lg border border-paper-rule bg-white px-4 font-semibold tabular-nums outline-none focus:border-pine focus:ring-2 focus:ring-pine/20"><small id="rv-duration-note" class="mt-2 block font-semibold leading-relaxed text-stone-500">Calculated automatically when both times are entered, or enter the kit's exposure time.</small></label>
                            </div>
                            <div class="mt-8 space-y-7">
                                <fieldset><legend class="text-sm font-black text-ink">For a short-term test, were closed-house conditions followed?</legend><div class="mt-3 grid gap-3 sm:grid-cols-3"><label class="rv-choice cursor-pointer"><input class="sr-only" type="radio" name="closedHouse" value="yes"><span class="block rounded-lg border border-paper-rule bg-white p-4 font-bold">Yes</span></label><label class="rv-choice cursor-pointer"><input class="sr-only" type="radio" name="closedHouse" value="no"><span class="block rounded-lg border border-paper-rule bg-white p-4 font-bold">No</span></label><label class="rv-choice cursor-pointer"><input class="sr-only" type="radio" name="closedHouse" value="unsure"><span class="block rounded-lg border border-paper-rule bg-white p-4 font-bold">Not sure / not applicable</span></label></div></fieldset>
                                <fieldset><legend class="text-sm font-black text-ink">Was the device moved, covered, unplugged, or disturbed?</legend><div class="mt-3 grid gap-3 sm:grid-cols-3"><label class="rv-choice cursor-pointer"><input class="sr-only" type="radio" name="disturbed" value="no"><span class="block rounded-lg border border-paper-rule bg-white p-4 font-bold">No</span></label><label class="rv-choice cursor-pointer"><input class="sr-only" type="radio" name="disturbed" value="yes"><span class="block rounded-lg border border-paper-rule bg-white p-4 font-bold">Yes</span></label><label class="rv-choice cursor-pointer"><input class="sr-only" type="radio" name="disturbed" value="unsure"><span class="block rounded-lg border border-paper-rule bg-white p-4 font-bold">Not sure</span></label></div></fieldset>
                            </div>
                        </section>

                        <section class="rv-planner-step" data-step="5" aria-labelledby="rv-question-5">
                            <p class="text-xs font-black uppercase tracking-[0.2em] text-pine">Complete the record</p>
                            <h2 id="rv-question-5" class="mt-3 font-display text-4xl font-bold leading-tight text-ink sm:text-5xl">Do you have a result to record?</h2>
                            <p class="mt-4 max-w-2xl font-semibold leading-relaxed text-stone-600">The procedural assessment does not change based on whether the number is high or low.</p>
                            <div class="mt-8 grid gap-6 sm:grid-cols-[1fr_.6fr]">
                                <label class="block"><span class="text-sm font-black text-ink">Reported result <small class="font-semibold text-stone-500">optional</small></span><input name="result" type="number" min="0" max="999" step="0.01" inputmode="decimal" placeholder="4.2" class="mt-2 min-h-[62px] w-full rounded-lg border border-paper-rule bg-white px-4 font-display text-3xl font-bold tabular-nums outline-none focus:border-pine focus:ring-2 focus:ring-pine/20"></label>
                                <label class="block"><span class="text-sm font-black text-ink">Unit</span><select name="unit" class="mt-2 min-h-[62px] w-full rounded-lg border border-paper-rule bg-white px-4 font-semibold outline-none focus:border-pine focus:ring-2 focus:ring-pine/20"><option value="pCi/L">pCi/L</option><option value="Bq/m³">Bq/m³</option></select></label>
                            </div>
                            <label class="mt-6 block"><span class="text-sm font-black text-ink">Notes <small class="font-semibold text-stone-500">optional</small></span><textarea name="notes" maxlength="600" rows="4" placeholder="Weather, open windows, device messages, or anything else worth keeping with the record." class="mt-2 w-full rounded-lg border border-paper-rule bg-white p-4 font-semibold outline-none focus:border-pine focus:ring-2 focus:ring-pine/20"></textarea></label>
                        </section>

                        <p id="rv-form-error" class="mt-6 hidden border-l-4 border-[#A43D32] bg-red-50 p-4 text-sm font-bold text-[#7f2d26]" role="alert"></p>
                        <div class="mt-9 flex items-center justify-between border-t border-paper-rule pt-5">
                            <button id="rv-back" type="button" class="invisible min-h-12 border-b border-stone-400 px-1 text-sm font-black text-stone-600 hover:border-ink hover:text-ink">← Back</button>
                            <button id="rv-next" type="button" class="inline-flex min-h-[52px] items-center justify-center rounded bg-ink px-6 text-sm font-black text-white transition hover:bg-pine focus:outline-none focus:ring-4 focus:ring-pine/20">Continue <span class="ml-3" aria-hidden="true">→</span></button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <section id="rv-record" class="hidden bg-paper py-10 sm:py-16" aria-live="polite">
            <div class="mx-auto max-w-4xl px-4 sm:px-6">
                <article class="rv-record-paper border border-paper-rule bg-paper-light p-6 sm:p-10">
                    <header class="flex flex-col gap-5 border-b-2 border-ink pb-7 sm:flex-row sm:items-end sm:justify-between">
                        <div><p class="text-xs font-black uppercase tracking-[0.22em] text-pine">RadonVerdict / test record</p><h2 class="mt-2 font-display text-4xl font-bold text-ink">Procedure check</h2></div>
                        <p id="rv-record-date" class="text-sm font-bold text-stone-500"></p>
                    </header>
                    <div id="rv-assessment" class="mt-7 border-l-8 p-5"></div>
                    <dl id="rv-record-details" class="mt-8"></dl>
                    <section class="mt-9 border-t-2 border-ink pt-6"><h3 class="text-sm font-black uppercase tracking-[0.18em] text-pine">What to do next</h3><ul id="rv-next-actions" class="mt-4 space-y-3 font-semibold leading-relaxed text-stone-700"></ul></section>
                    <footer class="mt-10 border-t border-paper-rule pt-6 text-xs font-semibold leading-relaxed text-stone-500">
                        <p>This record is based only on the answers entered. It does not certify a test, diagnose a property, or replace the device instructions, state requirements, a qualified tester, or medical advice.</p>
                        <p class="mt-3">Rule set: <span class="font-black">2026.09.05-1</span>. Each flagged finding links to its evidence. Core sources: <a class="font-black text-pine underline" href="https://www.cdc.gov/radon/testing/index.html" rel="noopener">CDC home testing guidance</a> · <a class="font-black text-pine underline" href="https://www.epa.gov/sites/default/files/2016-12/documents/2016_a_citizens_guide_to_radon.pdf" rel="noopener">EPA Citizen's Guide</a> · <a class="font-black text-pine underline" href="https://www.epa.gov/sites/default/files/2015-05/documents/hmbuygud.pdf" rel="noopener">EPA real-estate guide</a> · reviewed 2026-09-05.</p>
                    </footer>
                </article>
                <div class="rv-record-actions mt-6 flex flex-col gap-3 sm:flex-row">
                    <button id="rv-print" type="button" class="inline-flex min-h-[52px] items-center justify-center rounded bg-ink px-6 text-sm font-black text-white hover:bg-pine">Print or save as PDF</button>
                    <button id="rv-edit" type="button" class="inline-flex min-h-[52px] items-center justify-center rounded border border-paper-rule bg-white px-6 text-sm font-black text-ink hover:border-pine">Edit this record</button>
                    <a href="https://www.epa.gov/radon/how-do-i-get-radon-test-kit-are-they-free" rel="noopener" class="inline-flex min-h-[52px] items-center justify-center border-b border-pine px-3 text-sm font-black text-pine">Find free or discounted kits ↗</a>
                </div>
            </div>
        </section>

        <script src="/js/radon-test-planner.js" defer></script>
    `
)
