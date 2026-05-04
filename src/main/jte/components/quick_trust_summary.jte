@import com.radonverdict.model.County
@import com.radonverdict.model.dto.CountyPageContent
@import com.radonverdict.model.dto.TrustMetadata

@param County county
@param CountyPageContent page
@param TrustMetadata trust = null

<section class="mt-8 mb-12 rounded-2xl border border-slate-200 bg-white p-5 sm:p-6">
    <div class="flex flex-col sm:flex-row sm:items-end sm:justify-between gap-4 mb-5">
        <div>
            <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Instant Summary</p>
            <h2 class="font-display font-bold text-2xl text-slate-900 tracking-tight">Your 30-second local estimate snapshot</h2>
        </div>
        <p class="text-sm text-slate-500">For ${county.getAreaDisplayName()}, ${county.getStateAbbr()}</p>
    </div>

    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-3">
        <div class="rounded-xl border border-slate-200 bg-slate-50 p-4">
            <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Average</p>
            <p class="mt-2 font-display font-extrabold text-3xl text-slate-900 tabular-nums">$${page.getReceipt().getTotalAvg()}</p>
        </div>
        <div class="rounded-xl border border-slate-200 bg-slate-50 p-4">
            <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Typical Range</p>
            <p class="mt-2 text-lg font-bold text-slate-900 tabular-nums">$${page.getReceipt().getTotalLow()} - $${page.getReceipt().getTotalHigh()}</p>
        </div>
        <div class="rounded-xl border border-slate-200 bg-slate-50 p-4">
            <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Input Profile</p>
            <p class="mt-2 text-sm font-semibold text-slate-900">${page.getSelectedFoundationLabel()}, ${page.getSelectedSqftLabel()}</p>
            <p class="text-xs text-slate-500 mt-1">Goal: ${page.getSelectedIntentLabel()}</p>
        </div>
        <div class="rounded-xl border border-slate-200 bg-slate-50 p-4">
            <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Data Freshness</p>
            <p class="mt-2 text-sm font-semibold text-slate-900">
                @if(trust != null && trust.getDataRetrievedAt() != null && !trust.getDataRetrievedAt().isBlank())
                    ${trust.getDataRetrievedAt()}
                @else
                    Source-level retrieval dates
                @endif
            </p>
            <p class="text-xs text-slate-500 mt-1">
                @if(trust != null && trust.getLastReviewed() != null && !trust.getLastReviewed().isBlank())
                    Method reviewed ${trust.getLastReviewed()}
                @else
                    Source dates shown below
                @endif
            </p>
        </div>
        <div class="rounded-xl border border-slate-200 bg-slate-50 p-4">
            <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Primary Source</p>
            <p class="mt-2 text-sm font-semibold text-slate-900">
                @if(trust != null && trust.getSources() != null && !trust.getSources().isEmpty())
                    ${trust.getSources().get(0).getName()}
                @else
                    EPA + Census + State sources
                @endif
            </p>
            <p class="text-xs text-slate-500 mt-1">Independent from contractors</p>
        </div>
    </div>

    <div class="mt-5 flex flex-col sm:flex-row gap-3">
        <a href="#estimate-form"
           data-track-event="quick_summary_cta_click"
           data-track-label="${county.getCountySlug()}"
           class="inline-flex items-center justify-center rounded-xl bg-indigo-600 px-5 py-3 text-sm font-bold text-white hover:bg-indigo-700 transition-colors">
            Start 30-second free plan
        </a>
        <a href="#why-price"
           class="inline-flex items-center justify-center rounded-xl border border-slate-200 bg-white px-5 py-3 text-sm font-semibold text-slate-700 hover:bg-slate-50 transition-colors">
            See why this price
        </a>
    </div>
</section>
