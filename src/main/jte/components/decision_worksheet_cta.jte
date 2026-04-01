@import com.radonverdict.model.County
@import com.radonverdict.model.dto.CountyPageContent

@param County county
@param CountyPageContent page

!{
    final boolean isHighReading = "above_4".equals(page.getSelectedRadonResultBand());
    final boolean isTransactionIntent = "buying".equals(page.getSelectedIntent()) || "selling".equals(page.getSelectedIntent());
    final boolean showWorksheet = isHighReading || isTransactionIntent;
    final String askRange = "$" + page.getReceipt().getTotalAvg() + " to $" + page.getReceipt().getTotalHigh();
    final String worksheetTitle = isTransactionIntent
            ? "Seller Credit Calculator"
            : "4.0+ Reading Worksheet";
    final String worksheetUrl = isTransactionIntent
            ? "/radon-credit-calculator/" + county.getStateSlug() + "/" + county.getCountySlug()
                + "?intent=" + page.getSelectedIntent()
                + "&radonResultBand=" + page.getSelectedRadonResultBand()
            : "/guides/radon-seller-credit-worksheet";
    final String ctaLabel = isTransactionIntent ? "Open Calculator" : "Open Worksheet";
}

@if(showWorksheet)
<section class="mt-10 rounded-2xl border border-blue-200 bg-gradient-to-br from-blue-50 to-white p-6 sm:p-7">
    <div class="flex flex-col lg:flex-row lg:items-center lg:justify-between gap-6">
        <div class="max-w-2xl">
            <div class="inline-flex items-center gap-2 rounded-full bg-blue-100 px-3 py-1 text-xs font-bold uppercase tracking-wider text-blue-800 mb-3">
                Next leverage move
            </div>
            <h3 class="font-display font-bold text-2xl text-slate-900 mb-2">${worksheetTitle} for ${county.getAreaDisplayName()}</h3>
            <p class="text-sm text-slate-700 leading-relaxed">
                @if(isTransactionIntent)
                    Use your local budget anchor before you ask for repairs or credits. For a typical deal in ${county.getAreaDisplayName()}, a reasonable planning range is <strong>${askRange}</strong> depending on scope, routing, and finish quality.
                @else
                    A confirmed 4.0+ result is a decision moment, not just a price question. Use the worksheet to translate your reading into a quote plan, retest plan, or negotiation ask before you talk to contractors.
                @endif
            </p>
            <ul class="mt-4 space-y-2 text-sm text-slate-600">
                <li class="flex items-start gap-2">
                    <span class="mt-1 h-2 w-2 rounded-full bg-blue-500 shrink-0"></span>
                    <span>Budget anchor based on your county and selected scenario</span>
                </li>
                <li class="flex items-start gap-2">
                    <span class="mt-1 h-2 w-2 rounded-full bg-blue-500 shrink-0"></span>
                    <span>Plain-English credit / quote request framing you can reuse</span>
                </li>
                <li class="flex items-start gap-2">
                    <span class="mt-1 h-2 w-2 rounded-full bg-blue-500 shrink-0"></span>
                    <span>Reminder that this is planning context, not legal advice or a contractor bid</span>
                </li>
            </ul>
        </div>
        <div class="flex flex-col gap-3 shrink-0 lg:w-[280px]">
            <a href="${worksheetUrl}"
               data-track-event="worksheet_cta_click"
               data-track-label="${county.getCountySlug()}-${page.getSelectedIntent()}-${page.getSelectedRadonResultBand()}"
               class="inline-flex items-center justify-center rounded-xl bg-blue-600 px-5 py-3 text-sm font-bold text-white hover:bg-blue-700 transition-colors">
                ${ctaLabel}
            </a>
            <a href="#estimate-form"
               class="inline-flex items-center justify-center rounded-xl border border-slate-200 bg-white px-5 py-3 text-sm font-semibold text-slate-700 hover:bg-slate-50 transition-colors">
                Get My Local Plan
            </a>
        </div>
    </div>
</section>
@endif
