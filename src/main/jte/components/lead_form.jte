@import com.radonverdict.model.County
@import com.radonverdict.model.dto.CountyPageContent

@param County county
@param CountyPageContent page
@param String successMessage = null
@param String errorMessage = null

<div class="bg-slate-900 rounded-3xl p-8 shadow-2xl mt-12 mb-12 relative overflow-hidden" id="estimate-form">
    <!-- Decorative background elements -->
    <div class="absolute top-0 right-0 -mr-20 -mt-20 w-64 h-64 rounded-full bg-blue-500 opacity-10 blur-3xl"></div>
    <div class="absolute bottom-0 left-0 -ml-20 -mb-20 w-64 h-64 rounded-full bg-indigo-500 opacity-10 blur-3xl"></div>

    <div class="relative z-10">
        <div class="flex flex-col md:flex-row gap-8 items-start">
            
            <!-- Left side: Value Prop -->
            <div class="flex-1 text-white">
                <span class="inline-block py-1 px-3 rounded-full bg-indigo-500/20 text-indigo-300 text-xs font-bold tracking-wider uppercase mb-4">
                    Free 30-Second Action Plan
                </span>
                <h3 class="text-3xl font-display font-bold mb-4 tracking-tight leading-tight">
                    Should I mitigate now<br>in ${county.getAreaDisplayName()}?
                </h3>
                <p class="text-slate-300 text-lg mb-6 leading-relaxed">
                    Tell us a few details and get a personalized plan based on local risk, foundation type, and cost range. No obligation and no auto-enrollment.
                </p>
                <ul class="space-y-3">
                    <li class="flex items-center text-slate-300">
                        <svg class="h-5 w-5 text-indigo-400 mr-3 shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7"></path></svg>
                        Local risk and budget fit summary
                    </li>
                    <li class="flex items-center text-slate-300">
                        <svg class="h-5 w-5 text-indigo-400 mr-3 shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7"></path></svg>
                        Clear next steps for buying, selling, or staying
                    </li>
                    <li class="flex items-center text-slate-300">
                        <svg class="h-5 w-5 text-indigo-400 mr-3 shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7"></path></svg>
                        Follow-up capped to relevant updates only
                    </li>
                </ul>
            </div>

            <!-- Right side: The Form -->
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
                    <p class="mb-4 text-xs text-slate-500 font-semibold">Required now: Email + ZIP. Phone is optional.</p>
                    <form action="/submit-lead" method="POST" class="space-y-4"
                          x-data="{ 
                              hasStartedForm: false,
                              trackFormStart() {
                                  if (!this.hasStartedForm && typeof rvTrack === 'function') {
                                      this.hasStartedForm = true;
                                      rvTrack('lead_form_start', { event_category: 'engagement', event_label: '${county.getCountySlug()}' });
                                  }
                              }
                          }"
                          @submit="if(typeof rvTrack === 'function') rvTrack('lead_form_submit', { event_category: 'conversion', event_label: '${county.getCountySlug()}' });"
                    >
                        
                        <!-- Hidden Tracking Fields -->
                        <input type="hidden" name="countySlug" value="${county.getCountySlug()}">
                        <input type="hidden" name="stateSlug" value="${county.getStateSlug()}">
                        <input type="hidden" name="stateAbbr" value="${county.getStateAbbr()}">
                        <input type="hidden" name="consentVersion" value="v1.0">
                        
                        <!-- Honeypot Field -->
                        <div style="display:none;" aria-hidden="true">
                            <label for="additionalPhone">Additional Phone</label>
                            <input type="text" name="additionalPhone" id="additionalPhone" tabindex="-1" autocomplete="off">
                        </div>

                        <div>
                            <label for="customerEmail" class="block text-sm font-medium text-slate-700">Email</label>
                            <input type="email" name="customerEmail" id="customerEmail" @focus="trackFormStart" required placeholder="you@example.com" class="mt-1 block w-full rounded-lg border-slate-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm py-2 px-3 border">
                        </div>

                        <div class="grid grid-cols-2 gap-4">
                            <div>
                                <label for="zipCode" class="block text-sm font-medium text-slate-700">ZIP Code</label>
                                <input type="text" name="zipCode" id="zipCode" @focus="trackFormStart" required pattern="[0-9]{5}" placeholder="e.g. 90210" class="mt-1 block w-full rounded-lg border-slate-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm py-2 px-3 border">
                            </div>
                            <div>
                                <label for="customerPhone" class="block text-sm font-medium text-slate-700">Phone (optional)</label>
                                <input type="tel" name="customerPhone" id="customerPhone" @focus="trackFormStart" placeholder="(555) 123-4567" class="mt-1 block w-full rounded-lg border-slate-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm py-2 px-3 border">
                            </div>
                        </div>

                        <div>
                            <label for="customerName" class="block text-sm font-medium text-slate-700">Full Name (optional)</label>
                            <input type="text" name="customerName" id="customerName" @focus="trackFormStart" class="mt-1 block w-full rounded-lg border-slate-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm py-2 px-3 border">
                        </div>

                        <div>
                            <label for="foundationType" class="block text-sm font-medium text-slate-700">Foundation Type</label>
                            <select id="foundationType" name="foundationType" @change="trackFormStart" class="mt-1 block w-full rounded-lg border-slate-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 sm:text-sm py-2 px-3 border bg-white">
                                <option value="basement">Basement</option>
                                <option value="crawlspace">Crawl Space</option>
                                <option value="slab">Slab-on-Grade</option>
                                <option value="other">Other / Not Sure</option>
                            </select>
                        </div>

                        <!-- Affiliate Fallback: Has Tested? -->
                        <div x-data="{ tested: 'yes' }">
                            <label class="block text-sm font-medium text-slate-700 mb-2 mt-4">Have you tested your home for radon yet?</label>
                            <div class="flex gap-4 mb-4">
                                <label class="flex items-center">
                                    <input type="radio" name="hasTested" value="true" x-model="tested" class="h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-slate-300">
                                    <span class="ml-2 text-sm text-slate-600">Yes, I have results</span>
                                </label>
                                <label class="flex items-center">
                                    <input type="radio" name="hasTested" value="false" x-model="tested" class="h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-slate-300">
                                    <span class="ml-2 text-sm text-slate-600">No, not yet</span>
                                </label>
                            </div>

                            <!-- Affiliate Box: Shown only if 'No' is selected -->
                            <div x-show="tested === 'false'" x-cloak class="bg-indigo-50 rounded-xl p-4 border border-indigo-100 animate-pulse">
                                <p class="text-xs font-bold text-indigo-800 uppercase tracking-wider mb-1">Recommended First Step</p>
                                <p class="text-[13px] text-indigo-900 leading-relaxed mb-3">
                                    Mitigation pros will need your test results. We recommend this EPA-certified short-term test kit to get started.
                                </p>
                                <a href="https://www.amazon.com/dp/B00002N839?tag=radonverdict-20" 
                                   target="_blank" rel="sponsored nofollow noopener" 
                                   onclick="if(typeof rvTrack === 'function') rvTrack('affiliate_link_click', { event_category: 'monetization', event_label: 'amazon_test_kit' });"
                                   class="inline-flex items-center justify-center w-full py-2 bg-indigo-600 text-white text-xs font-bold rounded-lg hover:bg-indigo-700 transition-colors">
                                    View Top Rated Test Kit on Amazon
                                    <svg class="w-3 h-3 ml-2" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path stroke-linecap="round" stroke-linejoin="round" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" /></svg>
                                </a>
                                <p class="text-[10px] text-indigo-400 mt-2 text-center italic">*As an Amazon Associate we earn from qualifying purchases.</p>
                            </div>
                        </div>
                        
                        <div class="flex items-start mt-4">
                            <div class="flex h-5 items-center">
                                <input id="consent" name="consent" type="checkbox" required class="h-4 w-4 rounded border-slate-300 text-indigo-600 focus:ring-indigo-500" @change="if($event.target.checked && typeof rvTrack === 'function') rvTrack('consent_checked', { event_category: 'engagement' });">
                            </div>
                            <div class="ml-3 text-xs leading-tight text-slate-500">
                                <label for="consent">Prior to submitting, I consent to be contacted regarding my personalized radon action plan and local contractor availability.</label>
                            </div>
                        </div>

                        <button type="submit" class="w-full flex justify-center py-3 px-4 border border-transparent rounded-xl shadow-sm text-sm font-bold text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 transition-colors mt-6">
                            Send My Local Action Plan
                        </button>
                        <p class="text-center text-[10px] text-slate-400 mt-3 flex items-center justify-center">
                            <svg class="w-3 h-3 mr-1" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z" clip-rule="evenodd"></path></svg>
                            Your information is secure.
                        </p>
                        <p class="text-center text-[10px] text-slate-400">
                            We contact only for your local radon plan and availability updates.
                        </p>
                    </form>
                @endif
            </div>
        </div>
    </div>
</div>

