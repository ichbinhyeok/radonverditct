@param String countyName = null
@param String stateAbbr = null

<section class="mt-10 rounded-2xl border border-dashed border-slate-300 bg-slate-50 p-5 sm:p-6" data-track-section="monetization-hooks">
    <h3 class="font-display font-bold text-slate-900 text-lg mb-2">Monetization Hooks (Feature Flag)</h3>
    <p class="text-sm text-slate-600 mb-5">
        Placeholder modules for ads, affiliate blocks, and lead handoff.
        @if(countyName != null && stateAbbr != null)
            Context: ${countyName} County, ${stateAbbr}.
        @endif
    </p>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-3 text-sm">
        <div class="rounded-xl border border-slate-200 bg-white p-4">
            <p class="text-xs font-semibold uppercase tracking-wider text-slate-500 mb-1">Ad Slot</p>
            <p class="text-slate-700">`county_inline_1`</p>
        </div>
        <div class="rounded-xl border border-slate-200 bg-white p-4">
            <p class="text-xs font-semibold uppercase tracking-wider text-slate-500 mb-1">Affiliate Block</p>
            <p class="text-slate-700">Test kit / monitor placement</p>
        </div>
        <div class="rounded-xl border border-slate-200 bg-white p-4">
            <p class="text-xs font-semibold uppercase tracking-wider text-slate-500 mb-1">Lead Handoff</p>
            <p class="text-slate-700">Pre-qualified local partner hook</p>
        </div>
    </div>
</section>
