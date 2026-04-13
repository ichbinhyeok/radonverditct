@import com.radonverdict.model.County
@import com.radonverdict.model.dto.CountyPageContent

@param County county
@param CountyPageContent page
@param String successMessage = null
@param String errorMessage = null
@param String prefilledZip = null

!{
    final String resultBand = page.getSelectedRadonResultBand();
    final String intent = page.getSelectedIntent();
    final boolean transactionIntent = "buying".equals(intent) || "selling".equals(intent);
    final boolean highReading = "above_4".equals(resultBand);
    final boolean notTested = "not_tested".equals(resultBand);
    final boolean hasPrefilledZip = prefilledZip != null && prefilledZip.matches("\\d{5}");
    final boolean defaultHasTested = !notTested;
    final String selectedFoundationType = page.getSelectedFoundationType() != null
            ? page.getSelectedFoundationType()
            : "other";
    final String actionBadge = transactionIntent
            ? "Local credit range"
            : highReading
                    ? "4.0+ next-step plan"
                    : notTested
                            ? "Test-first plan"
                            : "Local next-step plan";
    final String actionHeadline = transactionIntent
            ? "Get the local credit range for " + county.getAreaDisplayName()
            : highReading
                    ? "Get the 4.0+ plan for " + county.getAreaDisplayName()
                    : notTested
                            ? "Get the test-first plan for " + county.getAreaDisplayName()
                            : "Get the local next-step plan for " + county.getAreaDisplayName();
    final String actionIntro = transactionIntent
            ? "Use this to follow up on the opening ask, ceiling, and fallback range that fit this county and this deal stage."
            : highReading
                    ? "Use this to follow up on the local price anchor, the immediate next move, and the range you can take into quote conversations."
                    : notTested
                            ? "Use this to follow up on what to test with, what to ignore for now, and when it is actually time to price mitigation."
                            : "Use this to follow up on whether to retest, hold, or move toward local quote planning with the scenario you already selected.";
    final String submitLabel = transactionIntent
            ? "Send My Credit Strategy"
            : highReading
                    ? "Send My 4.0+ Action Plan"
                    : notTested
                            ? "Send My Test + Action Plan"
                            : "Send My Local Action Plan";
    final String footerCopy = transactionIntent
            ? "We contact only about this local range, this scenario, and contractor availability updates."
            : "We contact only about this local plan and contractor availability updates.";
}

<div class="bg-slate-900 rounded-3xl p-8 shadow-2xl mt-12 mb-12" id="estimate-form" data-nosnippet>
    <div class="flex flex-col md:flex-row gap-8 items-start">
        <div class="flex-1 text-white">
            <span class="inline-block py-1 px-3 rounded-full bg-indigo-500/20 text-indigo-300 text-xs font-bold tracking-wider uppercase mb-4">
                ${actionBadge}
            </span>
            <h3 class="text-3xl font-display font-bold mb-4 tracking-tight leading-tight">
                ${actionHeadline}
            </h3>
            <p class="text-slate-300 text-lg mb-6 leading-relaxed">
                ${actionIntro} No obligation and no auto-enrollment.
            </p>
            <ul class="space-y-3">
                <li class="flex items-center text-slate-300">
                    <svg class="h-5 w-5 text-indigo-400 mr-3 shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7"></path></svg>
                    Scenario-aware next move, not a generic contractor push
                </li>
                <li class="flex items-center text-slate-300">
                    <svg class="h-5 w-5 text-indigo-400 mr-3 shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7"></path></svg>
                    Local number and decision framing tied to this county
                </li>
                <li class="flex items-center text-slate-300">
                    <svg class="h-5 w-5 text-indigo-400 mr-3 shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7"></path></svg>
                    Clear next steps for buying, selling, or staying
                </li>
            </ul>
        </div>

        <div class="w-full md:w-[450px] shrink-0 bg-white rounded-2xl p-6 shadow-xl">
            @if(successMessage != null && !successMessage.isEmpty())
                <div class="bg-green-50 border border-green-200 rounded-xl p-4 mb-6">
                    <div class="flex">
                        <svg class="h-5 w-5 text-green-400 mt-0.5 shrink-0" viewBox="0 0 20 20" fill="currentColor">
                            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                        </svg>
                        <div class="ml-3">
                            <h3 class="text-sm font-medium text-green-800">Success</h3>
                            <div class="mt-1 text-sm text-green-700">
                                <p>${successMessage}</p>
                            </div>
                        </div>
                    </div>
                </div>
                <script>
                  document.addEventListener('DOMContentLoaded', function () {
                    if (typeof rvTrack === 'function') {
                      rvTrack('generate_lead', {
                        event_category: 'conversion',
                        event_label: '${county.getCountySlug()}' + ' - ${page.getSelectedIntent()}' + ' - ${page.getSelectedRadonResultBand()}',
                        lead_source: 'county_action_plan_form'
                      });
                    }
                  });
                </script>
            @elseif(errorMessage != null && !errorMessage.isEmpty())
                <div class="bg-red-50 border border-red-200 rounded-xl p-4 mb-6">
                    <div class="flex">
                        <svg class="h-5 w-5 text-red-400 mt-0.5 shrink-0" viewBox="0 0 20 20" fill="currentColor">
                            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
                        </svg>
                        <div class="ml-3">
                            <h3 class="text-sm font-medium text-red-800">Error</h3>
                            <div class="mt-1 text-sm text-red-700">
                                <p>${errorMessage}</p>
                            </div>
                        </div>
                    </div>
                </div>
            @else
                <div class="mb-5 grid grid-cols-1 sm:grid-cols-3 gap-2">
                    <div class="rounded-lg border border-slate-200 bg-slate-50 px-3 py-2 text-xs text-slate-600 font-medium">Reply window: typically within 24 hours</div>
                    <div class="rounded-lg border border-slate-200 bg-slate-50 px-3 py-2 text-xs text-slate-600 font-medium">No obligation to hire anyone</div>
                    <div class="rounded-lg border border-slate-200 bg-slate-50 px-3 py-2 text-xs text-slate-600 font-medium">No call blasts or list selling</div>
                </div>
                <p class="mb-4 text-xs text-slate-500 font-semibold">
                    @if(hasPrefilledZip)
                        Required now: Email. ZIP is already locked from your county lookup. Phone is optional.
                    @else
                        Required now: Email + ZIP. Phone is optional.
                    @endif
                </p>
                <form action="/submit-lead" method="POST" class="space-y-4"
                      x-data="{
                          hasStartedForm: false,
                          isSubmitting: false,
                          pageIntent: '${page.getSelectedIntent()}',
                          pageResultBand: '${page.getSelectedRadonResultBand()}',
                          trackFormStart() {
                              if (!this.hasStartedForm && typeof rvTrack === 'function') {
                                  this.hasStartedForm = true;
                                  rvTrack('lead_form_start', { event_category: 'engagement', event_label: '${county.getCountySlug()}' + ' - ' + this.pageIntent + ' - ' + this.pageResultBand });
                              }
                          },
                          submitAfterTracking(event) {
                              if (this.isSubmitting) {
                                  return;
                              }

                              this.isSubmitting = true;
                              const form = event.target;
                              const submitForm = () => {
                                  if (form.dataset.trackingSubmitted === 'true') {
                                      return;
                                  }
                                  form.dataset.trackingSubmitted = 'true';
                                  HTMLFormElement.prototype.submit.call(form);
                              };

                              if (typeof rvTrack !== 'function') {
                                  submitForm();
                                  return;
                              }

                              const trackingPayload = {
                                  event_category: 'conversion',
                                  event_label: '${county.getCountySlug()}' + ' - ' + this.pageIntent + ' - ' + this.pageResultBand
                              };
                              const trackingOptions = {
                                  transport_type: 'beacon',
                                  event_timeout: 800,
                                  event_callback: submitForm
                              };

                              rvTrack('lead_form_submit', trackingPayload, trackingOptions);
                              window.setTimeout(submitForm, 800);
                          }
                      }"
                      @submit.prevent="submitAfterTracking($event)"
                >
                    <input type="hidden" name="countySlug" value="${county.getCountySlug()}">
                    <input type="hidden" name="stateSlug" value="${county.getStateSlug()}">
                    <input type="hidden" name="stateAbbr" value="${county.getStateAbbr()}">
                    <input type="hidden" name="consentVersion" value="v1.0">
                    <input type="hidden" name="selectedIntent" value="${page.getSelectedIntent()}">
                    <input type="hidden" name="selectedRadonResultBand" value="${page.getSelectedRadonResultBand()}">
                    <input type="hidden" name="foundationType" value="${selectedFoundationType}">
                    <input type="hidden" name="hasTested" value="${defaultHasTested ? "true" : "false"}">

                    <div style="display:none;" aria-hidden="true">
                        <label for="additionalPhone">Additional Phone</label>
                        <input type="text" name="additionalPhone" id="additionalPhone" tabindex="-1" autocomplete="off">
                    </div>

                    <div>
                        <label for="customerEmail" class="block text-sm font-medium text-slate-700">Email</label>
                        <input type="email" name="customerEmail" id="customerEmail" @focus="trackFormStart" required placeholder="you@example.com" class="mt-1 block w-full rounded-lg border-slate-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm py-2 px-3 border">
                    </div>

                    <div class="rounded-xl border border-indigo-100 bg-indigo-50 px-4 py-3">
                        <p class="text-xs font-bold uppercase tracking-wider text-indigo-700">Current scenario</p>
                        <div class="mt-3 flex flex-wrap gap-2">
                            <span class="inline-flex items-center rounded-full bg-white px-3 py-1 text-xs font-semibold text-slate-700 ring-1 ring-inset ring-slate-200">${page.getSelectedRadonResultBandLabel()}</span>
                            <span class="inline-flex items-center rounded-full bg-white px-3 py-1 text-xs font-semibold text-slate-700 ring-1 ring-inset ring-slate-200">${page.getSelectedIntentLabel()}</span>
                            <span class="inline-flex items-center rounded-full bg-white px-3 py-1 text-xs font-semibold text-slate-700 ring-1 ring-inset ring-slate-200">${page.getSelectedFoundationLabel()}</span>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                        @if(hasPrefilledZip)
                            <div>
                                <label class="block text-sm font-medium text-slate-700">ZIP Code</label>
                                <input type="hidden" name="zipCode" value="${prefilledZip}">
                                <div class="mt-1 flex min-h-[42px] items-center rounded-lg border border-slate-200 bg-slate-50 px-3 text-sm font-semibold text-slate-700">
                                    ${prefilledZip}
                                    <span class="ml-2 text-xs font-medium text-slate-500">from your county lookup</span>
                                </div>
                            </div>
                        @else
                            <div>
                                <label for="zipCode" class="block text-sm font-medium text-slate-700">ZIP Code</label>
                                <input type="text" name="zipCode" id="zipCode" @focus="trackFormStart" required pattern="[0-9]{5}" placeholder="e.g. 90210" class="mt-1 block w-full rounded-lg border-slate-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm py-2 px-3 border">
                            </div>
                        @endif
                        <div>
                            <label for="customerName" class="block text-sm font-medium text-slate-700">Full Name (optional)</label>
                            <input type="text" name="customerName" id="customerName" @focus="trackFormStart" class="mt-1 block w-full rounded-lg border-slate-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm py-2 px-3 border">
                        </div>
                    </div>

                    <div>
                        <label for="customerPhone" class="block text-sm font-medium text-slate-700">Phone (optional)</label>
                        <input type="tel" name="customerPhone" id="customerPhone" @focus="trackFormStart" placeholder="(555) 123-4567" class="mt-1 block w-full rounded-lg border-slate-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm py-2 px-3 border">
                        <p class="mt-2 rounded-lg border border-slate-200 bg-slate-50 px-3 py-2 text-xs leading-relaxed text-slate-600">
                            Using ${page.getSelectedFoundationLabel()} from the plan above. Change it in the scenario tool if needed.
                        </p>
                    </div>

                    @if(notTested)
                        <div class="bg-indigo-50 rounded-xl p-4 border border-indigo-100">
                            <p class="text-xs font-bold text-indigo-800 uppercase tracking-wider mb-1">Recommended First Step</p>
                            <p class="text-[13px] text-indigo-900 leading-relaxed mb-3">
                                Mitigation pros will need your test results. We recommend this EPA-certified short-term test kit to get started.
                            </p>
                            <a href="https://www.amazon.com/dp/B00002N83E?tag=radonverdict-20"
                               data-rv-affiliate-link="true"
                               target="_blank" rel="sponsored nofollow noopener"
                               onclick="if(window.rvTrackAffiliateClick) window.rvTrackAffiliateClick(this, { cta_id: 'lead_form_not_tested_test_kit', offer_type: 'test_kit', offer_brand: 'first_alert', offer_model: 'rd1', placement_group: 'lead_form', placement_id: 'not_tested', journey_stage: 'first_test' });"
                               class="inline-flex items-center justify-center w-full py-2 bg-indigo-600 text-white text-xs font-bold rounded-lg hover:bg-indigo-700 transition-colors">
                                View Recommended Short-Term Kit on Amazon
                                <svg class="w-3 h-3 ml-2" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path stroke-linecap="round" stroke-linejoin="round" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" /></svg>
                            </a>
                            <p class="text-[10px] text-indigo-400 mt-2 text-center italic">*As an Amazon Associate we earn from qualifying purchases.</p>
                        </div>
                    @endif

                    <div class="flex items-start mt-4">
                        <div class="flex h-5 items-center">
                            <input id="consent" name="consent" type="checkbox" required class="h-4 w-4 rounded border-slate-300 text-indigo-600 focus:ring-indigo-500" @change="if($event.target.checked && typeof rvTrack === 'function') rvTrack('consent_checked', { event_category: 'engagement' });">
                        </div>
                        <div class="ml-3 text-xs leading-tight text-slate-500">
                            <label for="consent">Prior to submitting, I consent to be contacted regarding my personalized radon action plan and local contractor availability.</label>
                        </div>
                    </div>

                    <button type="submit" class="w-full flex justify-center py-3 px-4 border border-transparent rounded-xl shadow-sm text-sm font-bold text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 transition-colors mt-6">
                        ${submitLabel}
                    </button>
                    <p class="text-center text-[10px] text-slate-400 mt-3 flex items-center justify-center">
                        <svg class="w-3 h-3 mr-1" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z" clip-rule="evenodd"></path></svg>
                        Your information is secure.
                    </p>
                    <p class="text-center text-[10px] text-slate-400">
                        ${footerCopy}
                    </p>
                </form>
            @endif
        </div>
    </div>
</div>
