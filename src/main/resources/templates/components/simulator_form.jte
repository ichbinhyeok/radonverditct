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
          hx-swap="innerHTML transition:true"
          class="space-y-8"
          x-data="{ foundation: 'basement', intent: 'buying' }">
        
        <!-- Hidden required fields -->
        <input type="hidden" name="stateSlug" value="${county.getStateSlug()}">
        <input type="hidden" name="countySlug" value="${county.getCountySlug()}">

        <!-- Axis 1: Foundation Type (Radio Cards) -->
        <div>
            <label class="block text-xs font-bold text-slate-400 uppercase tracking-widest mb-3 text-center">Foundation Type</label>
            <div class="grid grid-cols-3 gap-3">
                <label class="cursor-pointer">
                    <input type="radio" name="foundation" value="basement" x-model="foundation" class="peer sr-only" @change="$dispatch('submit')">
                    <div class="text-center rounded-xl p-3 border-2 transition-all duration-200"
                         :class="foundation === 'basement' ? 'border-brand-900 bg-brand-50 text-brand-900 shadow-sm' : 'border-slate-100 bg-white text-slate-500 hover:border-slate-300 hover:bg-slate-50'">
                        <div class="font-semibold text-sm">Basement</div>
                    </div>
                </label>
                <label class="cursor-pointer">
                    <input type="radio" name="foundation" value="slab" x-model="foundation" class="peer sr-only" @change="$dispatch('submit')">
                    <div class="text-center rounded-xl p-3 border-2 transition-all duration-200"
                         :class="foundation === 'slab' ? 'border-brand-900 bg-brand-50 text-brand-900 shadow-sm' : 'border-slate-100 bg-white text-slate-500 hover:border-slate-300 hover:bg-slate-50'">
                        <div class="font-semibold text-sm">Slab</div>
                    </div>
                </label>
                <label class="cursor-pointer">
                    <input type="radio" name="foundation" value="crawlspace" x-model="foundation" class="peer sr-only" @change="$dispatch('submit')">
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
                    <input type="radio" name="intent" value="buying" x-model="intent" class="peer sr-only" @change="$dispatch('submit')">
                    <div class="text-center py-2.5 rounded-lg text-sm font-semibold transition-colors duration-200"
                         :class="intent === 'buying' ? 'bg-white text-slate-900 shadow-sm ring-1 ring-black/5' : 'text-slate-500 hover:text-slate-700'">
                        Buying
                    </div>
                </label>
                <label class="flex-1 cursor-pointer relative z-10">
                    <input type="radio" name="intent" value="selling" x-model="intent" class="peer sr-only" @change="$dispatch('submit')">
                    <div class="text-center py-2.5 rounded-lg text-sm font-semibold transition-colors duration-200"
                         :class="intent === 'selling' ? 'bg-white text-slate-900 shadow-sm ring-1 ring-black/5' : 'text-slate-500 hover:text-slate-700'">
                        Selling
                    </div>
                </label>
                <label class="flex-1 cursor-pointer relative z-10">
                    <input type="radio" name="intent" value="homeowner" x-model="intent" class="peer sr-only" @change="$dispatch('submit')">
                    <div class="text-center py-2.5 rounded-lg text-sm font-semibold transition-colors duration-200"
                         :class="intent === 'homeowner' ? 'bg-white text-slate-900 shadow-sm ring-1 ring-black/5' : 'text-slate-500 hover:text-slate-700'">
                        Living Here
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
