@import com.radonverdict.model.dto.CountyPageContent

@param CountyPageContent page

<section id="why-price" class="mt-12 mb-12 rounded-2xl border border-slate-200 bg-white p-6 sm:p-8">
    <div class="flex flex-col sm:flex-row sm:items-end sm:justify-between gap-4 mb-6">
        <div>
            <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Price Drivers</p>
            <h3 class="font-display font-bold text-2xl text-slate-900 tracking-tight">Why this estimate looks like this</h3>
        </div>
        <p class="text-sm text-slate-500">Weights are model contributions, not exact line-item billing.</p>
    </div>

    <div class="space-y-5">
        <div>
            <div class="flex items-center justify-between mb-1.5">
                <p class="text-sm font-semibold text-slate-800">Local labor market pressure</p>
                <p class="text-sm font-bold text-slate-900">
                    ${(int) Math.max(20, Math.min(55, Math.round((page.getReceipt().getLaborAvg() * 100.0) / Math.max(page.getReceipt().getTotalAvg(), 1))))}%
                </p>
            </div>
            <div class="h-2 rounded-full bg-slate-100">
                <div class="h-2 rounded-full bg-indigo-600"
                     style="width:${Math.max(20, Math.min(55, Math.round((page.getReceipt().getLaborAvg() * 100.0) / Math.max(page.getReceipt().getTotalAvg(), 1))))}%;"></div>
            </div>
            <p class="text-xs text-slate-500 mt-1">Labor usually drives the biggest spread in county-level pricing.</p>
        </div>

        <div>
            <div class="flex items-center justify-between mb-1.5">
                <p class="text-sm font-semibold text-slate-800">Foundation complexity (${page.getSelectedFoundationLabel()})</p>
                <p class="text-sm font-bold text-slate-900">
                    ${"basement".equalsIgnoreCase(page.getSelectedFoundationType()) ? 34 : ("crawlspace".equalsIgnoreCase(page.getSelectedFoundationType()) ? 28 : ("slab".equalsIgnoreCase(page.getSelectedFoundationType()) ? 22 : 25))}%
                </p>
            </div>
            <div class="h-2 rounded-full bg-slate-100">
                <div class="h-2 rounded-full bg-emerald-500"
                     style="width:${"basement".equalsIgnoreCase(page.getSelectedFoundationType()) ? 34 : ("crawlspace".equalsIgnoreCase(page.getSelectedFoundationType()) ? 28 : ("slab".equalsIgnoreCase(page.getSelectedFoundationType()) ? 22 : 25))}%;"></div>
            </div>
            <p class="text-xs text-slate-500 mt-1">Routing and sealing complexity changes by foundation type.</p>
        </div>

        <div>
            <div class="flex items-center justify-between mb-1.5">
                <p class="text-sm font-semibold text-slate-800">Permits and compliance</p>
                <p class="text-sm font-bold text-slate-900">
                    ${(int) Math.max(8, Math.min(30, Math.round((page.getReceipt().getPermitsSetupAvg() * 100.0) / Math.max(page.getReceipt().getTotalAvg(), 1)) + (page.isLicenseRequired() ? 6 : 0)))}%
                </p>
            </div>
            <div class="h-2 rounded-full bg-slate-100">
                <div class="h-2 rounded-full bg-amber-500"
                     style="width:${Math.max(8, Math.min(30, Math.round((page.getReceipt().getPermitsSetupAvg() * 100.0) / Math.max(page.getReceipt().getTotalAvg(), 1)) + (page.isLicenseRequired() ? 6 : 0)))}%;"></div>
            </div>
            <p class="text-xs text-slate-500 mt-1">State disclosure/license rules can add setup overhead.</p>
        </div>

        <div>
            <div class="flex items-center justify-between mb-1.5">
                <p class="text-sm font-semibold text-slate-800">Home size factor (${page.getSelectedSqftLabel()})</p>
                <p class="text-sm font-bold text-slate-900">${"over_2000".equalsIgnoreCase(page.getSelectedSqftCategory()) ? 26 : 14}%</p>
            </div>
            <div class="h-2 rounded-full bg-slate-100">
                <div class="h-2 rounded-full bg-blue-500"
                     style="width:${"over_2000".equalsIgnoreCase(page.getSelectedSqftCategory()) ? 26 : 14}%;"></div>
            </div>
            <p class="text-xs text-slate-500 mt-1">Larger footprints often need longer runs and additional sealing points.</p>
        </div>
    </div>
</section>
