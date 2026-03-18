@import com.radonverdict.model.dto.CountyPageContent
@param CountyPageContent page

<div class="bg-blue-50/50 rounded-2xl border border-blue-100 p-6 sm:p-8 relative mt-0 top-0 transition-all duration-300 transform group-hover:-translate-y-1"
    data-nosnippet>

    <div class="flex items-start gap-4 mb-4">
        <!-- Action Icon -->
        <div class="w-12 h-12 bg-white rounded-xl shadow-sm border border-blue-100 flex items-center justify-center shrink-0">
            <svg class="w-6 h-6 text-blue-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                <path stroke-linecap="round" stroke-linejoin="round" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
        </div>
        <div>
            <h4 class="font-display font-bold text-slate-900 text-lg mb-1">${page.getIntentSectionTitle()}</h4>
            <p class="text-sm text-slate-600 font-medium leading-relaxed">${page.getIntentIntro()}</p>
        </div>
    </div>

    <!-- Strategy Steps (Checked list) -->
    <ul class="space-y-3 mt-6">
        @for(String step : page.getIntentSteps())
        <li class="flex items-start gap-3">
            <svg class="w-5 h-5 text-blue-500 mt-0.5 shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
                <path stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
            <span class="text-sm text-slate-700 font-medium leading-relaxed">${step}</span>
        </li>
        @endfor
    </ul>

    <!-- Pro Tip (Highlight Box) -->
    <div class="mt-8 bg-blue-100/50 rounded-xl p-4 border border-blue-200">
        <div class="flex items-center gap-2 mb-2">
            <span class="text-xs font-bold uppercase tracking-wider text-blue-800 bg-blue-200 px-2 py-0.5 rounded-full">Pro Tip</span>
        </div>
        <p class="text-[13.5px] text-blue-900 font-semibold leading-relaxed">${page.getIntentProTip()}</p>
    </div>
</div>
