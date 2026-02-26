@import com.radonverdict.model.County
@param County county

<!-- HTMX Simulator Form: Real-time calculation triggers -->
<div class="bg-white rounded-[2rem] p-6 sm:p-8 shadow-sm border border-slate-200 mb-8 max-w-2xl mx-auto">
    
    <div class="mb-6 text-center">
        <h3 class="font-display font-bold text-slate-900 text-xl tracking-tight">Refine Your Estimate</h3>
        <p class="text-slate-500 text-sm mt-1 font-medium">Adjust parameters to simulate local costs</p>
    </div>

    <!-- The HTMX Form -->
    <!-- hx-post: calls our Spring controller, hx-target: updates the #receipt-container div -->
    <form hx-post="/htmx/calculate-receipt" 
          hx-target="#receipt-container"
          hx-trigger="change"
          hx-swap="innerHTML transition:true"
          @htmx:after-request="
            showToast = false; 
            setTimeout(() => showToast = true, 50); 
            clearTimeout(hideTimeout); 
            hideTimeout = setTimeout(() => showToast = false, 3000);
            if (typeof rvTrack === 'function') {
                rvTrack('estimator_result_viewed', { event_category: 'engagement', event_label: countySlug + ' - ' + foundation + ' - ' + intent });
            }
          "
          class="space-y-8 relative"
          x-data="{ 
              foundation: 'basement', 
              intent: 'buying', 
              sqftCategory: 'under_2000', 
              showToast: false, 
              hideTimeout: null,
              countySlug: '${county.getCountySlug()}',
              hasStarted: false,
              trackStart() {
                  if (!this.hasStarted && typeof rvTrack === 'function') {
                      this.hasStarted = true;
                      rvTrack('estimator_start', { event_category: 'engagement', event_label: this.countySlug });
                  }
              }
          }"
          @change="trackStart(); if(typeof rvTrack === 'function') rvTrack('estimator_step_complete', { event_category: 'engagement', event_label: $event.target.name + ': ' + $event.target.value });">
        
        <!-- Animated Toast Notification (Triggered after HTMX swap) -->
        <div x-show="showToast" 
             x-transition.opacity.duration.300ms
             class="absolute -top-14 left-1/2 -translate-x-1/2 z-50 bg-slate-800 border border-slate-700 text-white px-4 py-2 rounded-full shadow-xl text-xs sm:text-sm font-bold flex items-center gap-2 whitespace-nowrap"
             style="display: none;">
            <svg class="w-4 h-4 text-emerald-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7" /></svg>
            Estimate updated with your inputs
        </div>

        <!-- Hidden required fields -->
        <input type="hidden" name="stateSlug" value="${county.getStateSlug()}">
        <input type="hidden" name="countySlug" value="${county.getCountySlug()}">

        <!-- Axis 1: Foundation Type (Radio Cards) -->
        <div>
            <label class="block text-xs font-bold text-slate-400 uppercase tracking-widest mb-3 text-center">Foundation Type</label>
            <div class="grid grid-cols-3 gap-3">
                <label class="cursor-pointer">
                    <input type="radio" name="foundation" value="basement" x-model="foundation" class="peer sr-only">
                    <div class="text-center rounded-xl p-3 border-2 transition-all duration-200"
                         :class="foundation === 'basement' ? 'border-brand-900 bg-brand-50 text-brand-900 shadow-sm' : 'border-slate-100 bg-white text-slate-500 hover:border-slate-300 hover:bg-slate-50'">
                        <div class="font-semibold text-sm">Basement</div>
                    </div>
                </label>
                <label class="cursor-pointer">
                    <input type="radio" name="foundation" value="slab" x-model="foundation" class="peer sr-only">
                    <div class="text-center rounded-xl p-3 border-2 transition-all duration-200"
                         :class="foundation === 'slab' ? 'border-brand-900 bg-brand-50 text-brand-900 shadow-sm' : 'border-slate-100 bg-white text-slate-500 hover:border-slate-300 hover:bg-slate-50'">
                        <div class="font-semibold text-sm">Slab</div>
                    </div>
                </label>
                <label class="cursor-pointer">
                    <input type="radio" name="foundation" value="crawlspace" x-model="foundation" class="peer sr-only">
                    <div class="text-center rounded-xl p-3 border-2 transition-all duration-200"
                         :class="foundation === 'crawlspace' ? 'border-brand-900 bg-brand-50 text-brand-900 shadow-sm' : 'border-slate-100 bg-white text-slate-500 hover:border-slate-300 hover:bg-slate-50'">
                        <div class="font-semibold text-sm">Crawl</div>
                    </div>
                </label>
            </div>
        </div>

        <!-- Axis 2: User Intent (Radio Segments like iOS) -->
        <div>
            <label class="block text-xs font-bold text-slate-400 uppercase tracking-widest mb-3 text-center">Your Goal</label>
            <div class="bg-slate-100 rounded-xl p-1.5 flex gap-1 relative overflow-hidden ring-1 ring-inset ring-slate-200">
                <label class="flex-1 cursor-pointer relative z-10">
                    <input type="radio" name="intent" value="buying" x-model="intent" class="peer sr-only">
                    <div class="text-center py-2.5 rounded-lg text-sm font-semibold transition-colors duration-200"
                         :class="intent === 'buying' ? 'bg-white text-slate-900 shadow-sm ring-1 ring-black/5' : 'text-slate-500 hover:text-slate-700'">
                        Buying
                    </div>
                </label>
                <label class="flex-1 cursor-pointer relative z-10">
                    <input type="radio" name="intent" value="selling" x-model="intent" class="peer sr-only">
                    <div class="text-center py-2.5 rounded-lg text-sm font-semibold transition-colors duration-200"
                         :class="intent === 'selling' ? 'bg-white text-slate-900 shadow-sm ring-1 ring-black/5' : 'text-slate-500 hover:text-slate-700'">
                        Selling
                    </div>
                </label>
                <label class="flex-1 cursor-pointer relative z-10">
                    <input type="radio" name="intent" value="homeowner" x-model="intent" class="peer sr-only">
                    <div class="text-center py-2.5 rounded-lg text-sm font-semibold transition-colors duration-200"
                         :class="intent === 'homeowner' ? 'bg-white text-slate-900 shadow-sm ring-1 ring-black/5' : 'text-slate-500 hover:text-slate-700'">
                        Living Here
                    </div>
                </label>
            </div>
        </div>
        <!-- Axis 3: Home Size -->
        <div>
            <label class="block text-xs font-bold text-slate-400 uppercase tracking-widest mb-3 text-center">Home Size</label>
            <div class="bg-slate-100 rounded-xl p-1.5 flex gap-1 relative overflow-hidden ring-1 ring-inset ring-slate-200">
                <label class="flex-1 cursor-pointer relative z-10">
                    <input type="radio" name="sqftCategory" value="under_2000" x-model="sqftCategory" class="peer sr-only">
                    <div class="text-center py-2.5 rounded-lg text-sm font-semibold transition-colors duration-200"
                         :class="sqftCategory === 'under_2000' ? 'bg-white text-slate-900 shadow-sm ring-1 ring-black/5' : 'text-slate-500 hover:text-slate-700'">
                        Under 2,000 sq ft
                    </div>
                </label>
                <label class="flex-1 cursor-pointer relative z-10">
                    <input type="radio" name="sqftCategory" value="over_2000" x-model="sqftCategory" class="peer sr-only">
                    <div class="text-center py-2.5 rounded-lg text-sm font-semibold transition-colors duration-200"
                         :class="sqftCategory === 'over_2000' ? 'bg-white text-slate-900 shadow-sm ring-1 ring-black/5' : 'text-slate-500 hover:text-slate-700'">
                        Over 2,000 sq ft
                    </div>
                </label>
            </div>
        </div>
        
        <!-- Loading Indicator (shown only during HTMX req) -->
        <div class="htmx-indicator flex justify-center py-2">
            <svg class="animate-spin h-5 w-5 text-brand-500" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
            </svg>
        </div>

    </form>
</div>

<style>
/* HTMX Loading state transitions */
#receipt-container.htmx-swapping {
  opacity: 0.3;
  transition: opacity 200ms ease-out;
}
.htmx-indicator {
    opacity: 0;
    transition: opacity 150ms ease-in;
    position: absolute;
    pointer-events: none;
}
.htmx-request .htmx-indicator {
    opacity: 1;
}
</style>
