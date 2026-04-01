@import com.radonverdict.model.County
@import com.radonverdict.model.dto.CountyPageContent

@param County county
@param CountyPageContent page

!{
    final String intent = page.getSelectedIntent() != null ? page.getSelectedIntent() : "homeowner";
    final String resultBand = page.getSelectedRadonResultBand() != null ? page.getSelectedRadonResultBand() : "not_tested";
    final boolean isBuying = "buying".equals(intent);
    final boolean isSelling = "selling".equals(intent);
    final boolean isHighReading = "above_4".equals(resultBand);
    final boolean isBorderline = "between_2_and_4".equals(resultBand);
    final boolean showSnapshot = isBuying || isSelling || isHighReading || isBorderline;

    final int startAnchor = page.getReceipt().getTotalAvg();
    final int ceilingAnchor = page.getReceipt().getTotalHigh();
    final String label = isBuying || isSelling ? "Negotiation Snapshot"
            : isHighReading ? "4.0+ Fast Path"
            : "Borderline Result Playbook";
    final String title = isBuying
            ? "Seller Credit Starting Point"
            : isSelling
                    ? "Closing-Credit Reserve"
                    : isHighReading
                            ? "High Reading Budget Snapshot"
                            : "2.0-3.9 Result Decision Snapshot";
    final String primaryValueLabel = isBuying
            ? "Start ask"
            : isSelling
                    ? "Reserve target"
                    : isHighReading
                            ? "Likely center"
                            : "Retest or act?";
    final String primaryValue = isBorderline
            ? "Retest first"
            : "$" + startAnchor;
    final String secondaryValueLabel = isBuying
            ? "Ceiling ask"
            : isSelling
                    ? "Safe ceiling"
                    : isHighReading
                            ? "No-surprise ceiling"
                            : "Escalate when";
    final String secondaryValue = isBorderline
            ? "4.0+ or rising"
            : "$" + ceilingAnchor;
    final String description = isBuying
            ? "If you want a clean close in " + county.getAreaDisplayName() + ", start the repair-or-credit conversation around the local average and keep the local high range as your defensible ceiling."
            : isSelling
                    ? "If you prefer a faster closing, budget the local average first and treat the county high range as your reserve so you are not negotiating off a vague national number."
                    : isHighReading
                            ? "A confirmed 4.0+ result is usually a move-now situation. Use the local average as your quote target and keep the county high range in reserve before you contact installers."
                            : "A 2.0-3.9 result is often a judgment call. Retest if conditions were weak, but if you are buying, selling, or seeing repeat elevated readings, move toward the action-plan flow instead of waiting blindly.";
    final String creditCalculatorUrl = "/radon-credit-calculator/" + county.getStateSlug() + "/" + county.getCountySlug()
            + "?intent=" + page.getSelectedIntent()
            + "&radonResultBand=" + page.getSelectedRadonResultBand();
    final String primaryCtaHref = (isBuying || isSelling)
            ? creditCalculatorUrl
            : isHighReading
                    ? "/guides/radon-seller-credit-worksheet"
            : "#estimate-form";
    final String primaryCtaLabel = (isBuying || isSelling)
            ? "Open Credit Calculator"
            : isHighReading
                    ? "Open 4.0+ Worksheet"
                    : "Jump to Action Plan";
    final String primaryTrackLabel = county.getCountySlug() + "-" + intent + "-" + resultBand + "-primary";
    final String secondaryTrackLabel = county.getCountySlug() + "-" + intent + "-" + resultBand + "-secondary";
}

@if(showSnapshot)
<section class="mt-8 rounded-3xl border border-slate-200 bg-white p-6 sm:p-8 shadow-sm">
    <div class="flex flex-col gap-6 lg:flex-row lg:items-start lg:justify-between">
        <div class="max-w-2xl">
            <div class="inline-flex items-center gap-2 rounded-full bg-slate-100 px-3 py-1 text-xs font-bold uppercase tracking-wider text-slate-700">
                ${label}
            </div>
            <h2 class="mt-4 font-display text-2xl font-bold tracking-tight text-slate-900 sm:text-3xl">${title}</h2>
            <p class="mt-3 text-sm leading-relaxed text-slate-600 sm:text-base">${description}</p>
        </div>

        <div class="grid min-w-[280px] gap-3 sm:grid-cols-2 lg:grid-cols-1 lg:w-[300px]">
            <div class="rounded-2xl border border-slate-200 bg-slate-50 p-4">
                <p class="text-[11px] font-bold uppercase tracking-widest text-slate-500">${primaryValueLabel}</p>
                <p class="mt-2 text-2xl font-black tracking-tight text-slate-900">${primaryValue}</p>
            </div>
            <div class="rounded-2xl border border-slate-200 bg-slate-50 p-4">
                <p class="text-[11px] font-bold uppercase tracking-widest text-slate-500">${secondaryValueLabel}</p>
                <p class="mt-2 text-2xl font-black tracking-tight text-slate-900">${secondaryValue}</p>
            </div>
        </div>
    </div>

    <div class="mt-6 grid gap-3 sm:grid-cols-3">
        <div class="rounded-2xl border border-slate-200 p-4">
            <p class="text-xs font-bold uppercase tracking-widest text-slate-500">Use when</p>
            <p class="mt-2 text-sm leading-relaxed text-slate-700">
                @if(isBuying)
                    You want a seller-paid repair or a cleaner closing credit.
                @elseif(isSelling)
                    You want to cap the surprise before the buyer starts naming numbers.
                @elseif(isHighReading)
                    You already have a reading that is clearly above the EPA action level.
                @else
                    You are trying to decide whether borderline readings justify acting now.
                @endif
            </p>
        </div>
        <div class="rounded-2xl border border-slate-200 p-4">
            <p class="text-xs font-bold uppercase tracking-widest text-slate-500">Avoid</p>
            <p class="mt-2 text-sm leading-relaxed text-slate-700">
                Negotiating from a generic national average. The county-specific range is the number that keeps the conversation grounded.
            </p>
        </div>
        <div class="rounded-2xl border border-slate-200 p-4">
            <p class="text-xs font-bold uppercase tracking-widest text-slate-500">Next move</p>
            <p class="mt-2 text-sm leading-relaxed text-slate-700">
                Use the worksheet if this is a deal conversation. Use the full action plan if you still need the quote path, timing, and next-step logic.
            </p>
        </div>
    </div>

    <div class="mt-6 flex flex-col gap-3 sm:flex-row">
        <a href="${primaryCtaHref}"
           data-track-event="negotiation_snapshot_click"
           data-track-label="${primaryTrackLabel}"
           class="inline-flex items-center justify-center rounded-xl bg-slate-900 px-5 py-3 text-sm font-bold text-white transition-colors hover:bg-slate-800">
            ${primaryCtaLabel}
        </a>
        <a href="#estimate-form"
           data-track-event="negotiation_snapshot_click"
           data-track-label="${secondaryTrackLabel}"
           class="inline-flex items-center justify-center rounded-xl border border-slate-200 bg-white px-5 py-3 text-sm font-semibold text-slate-700 transition-colors hover:bg-slate-50">
            Get Full Local Plan
        </a>
    </div>
</section>
@endif
