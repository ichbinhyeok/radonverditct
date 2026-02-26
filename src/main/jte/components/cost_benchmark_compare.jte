@import com.radonverdict.model.County
@import com.radonverdict.model.dto.CountyPageContent

@param County county
@param CountyPageContent page

<section class="mt-12 mb-12 rounded-2xl border border-slate-200 bg-white p-6 sm:p-8">
    <div class="flex flex-col sm:flex-row sm:items-end sm:justify-between gap-4 mb-6">
        <div>
            <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Benchmark</p>
            <h3 class="font-display font-bold text-2xl text-slate-900 tracking-tight">${county.getAreaDisplayName()} vs State vs National</h3>
        </div>
        <p class="text-sm text-slate-500">All numbers use the same inputs: ${page.getSelectedFoundationLabel()}, ${page.getSelectedIntentLabel()}, ${page.getSelectedSqftLabel()}.</p>
    </div>

    <div class="grid grid-cols-1 sm:grid-cols-3 gap-3 mb-6">
        <div class="rounded-xl border border-indigo-200 bg-indigo-50 p-4">
            <p class="text-xs font-bold uppercase tracking-wider text-indigo-700">County Estimate</p>
            <p class="mt-2 font-display font-extrabold text-3xl text-indigo-900 tabular-nums">$${page.getReceipt().getTotalAvg()}</p>
        </div>
        <div class="rounded-xl border border-slate-200 bg-slate-50 p-4">
            <p class="text-xs font-bold uppercase tracking-wider text-slate-500">State Avg</p>
            <p class="mt-2 font-display font-extrabold text-3xl text-slate-900 tabular-nums">$${page.getStateAverageTotal()}</p>
            <p class="text-xs mt-1 ${page.getCountyVsStateDeltaPct() >= 0 ? "text-red-700" : "text-emerald-700"}">
                ${page.getCountyVsStateDeltaPct() >= 0 ? "+" : ""}${page.getCountyVsStateDeltaPct()}% vs state
            </p>
        </div>
        <div class="rounded-xl border border-slate-200 bg-slate-50 p-4">
            <p class="text-xs font-bold uppercase tracking-wider text-slate-500">National Avg</p>
            <p class="mt-2 font-display font-extrabold text-3xl text-slate-900 tabular-nums">$${page.getNationalAverageTotal()}</p>
            <p class="text-xs mt-1 ${page.getCountyVsNationalDeltaPct() >= 0 ? "text-red-700" : "text-emerald-700"}">
                ${page.getCountyVsNationalDeltaPct() >= 0 ? "+" : ""}${page.getCountyVsNationalDeltaPct()}% vs national
            </p>
        </div>
    </div>

    <div class="space-y-4">
        <div>
            <div class="flex items-center justify-between mb-1.5">
                <p class="text-sm font-semibold text-slate-800">${county.getAreaDisplayName()}</p>
                <p class="text-sm font-semibold text-slate-900 tabular-nums">$${page.getReceipt().getTotalAvg()}</p>
            </div>
            <div class="h-2 rounded-full bg-slate-100">
                <div class="h-2 rounded-full bg-indigo-600"
                     style="width:${Math.max(8, Math.round((page.getReceipt().getTotalAvg() * 100.0) / Math.max(page.getComparisonMaxTotal(), 1)))}%;"></div>
            </div>
        </div>
        <div>
            <div class="flex items-center justify-between mb-1.5">
                <p class="text-sm font-semibold text-slate-700">${county.getStateAbbr()} state average</p>
                <p class="text-sm font-semibold text-slate-900 tabular-nums">$${page.getStateAverageTotal()}</p>
            </div>
            <div class="h-2 rounded-full bg-slate-100">
                <div class="h-2 rounded-full bg-amber-500"
                     style="width:${Math.max(8, Math.round((page.getStateAverageTotal() * 100.0) / Math.max(page.getComparisonMaxTotal(), 1)))}%;"></div>
            </div>
        </div>
        <div>
            <div class="flex items-center justify-between mb-1.5">
                <p class="text-sm font-semibold text-slate-700">National average</p>
                <p class="text-sm font-semibold text-slate-900 tabular-nums">$${page.getNationalAverageTotal()}</p>
            </div>
            <div class="h-2 rounded-full bg-slate-100">
                <div class="h-2 rounded-full bg-emerald-500"
                     style="width:${Math.max(8, Math.round((page.getNationalAverageTotal() * 100.0) / Math.max(page.getComparisonMaxTotal(), 1)))}%;"></div>
            </div>
        </div>
    </div>
</section>
