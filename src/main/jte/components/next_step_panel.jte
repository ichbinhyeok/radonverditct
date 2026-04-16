@import com.radonverdict.model.County
@import com.radonverdict.model.dto.CountyPageContent

@param County county
@param CountyPageContent page

!{
    final String shortTermKitUrl = "https://www.amazon.com/dp/B00002N83E?tag=radonverdict-20";
    final String digitalMonitorUrl = "https://www.amazon.com/dp/B00H2VOSP8?tag=radonverdict-20";
    final boolean notTested = "not_tested".equals(page.getSelectedRadonResultBand());
    final boolean lowReading = "under_2".equals(page.getSelectedRadonResultBand());
    final String badge = notTested ? "Test First" : "Low Reading Plan";
    final String heading = notTested
            ? "Start with a confirmed radon test in " + county.getAreaDisplayName()
            : "Low reading in " + county.getAreaDisplayName() + ": monitor and retest before you chase quotes";
    final String intro = notTested
            ? "This page should stay in planning mode until you have a real reading. Use the testing guide first, then come back to the local action plan if the result lands near or above the action range."
            : "A reading under 2.0 pCi/L is usually a monitoring decision, not a contractor decision. Keep the local budget context, but use a retest or monitor plan before you move toward quotes.";
    final String primaryHref = "/guides/how-to-test-for-radon";
    final String primaryLabel = notTested ? "Open Testing Guide" : "Open Retest Guide";
    final String secondaryHref = notTested ? shortTermKitUrl : digitalMonitorUrl;
    final String secondaryLabel = notTested ? "View Recommended Short-Term Kit" : "View Digital Monitor";
    final String affiliateOfferType = notTested ? "test_kit" : "monitor";
    final String affiliateOfferBrand = notTested ? "first_alert" : "airthings";
    final String affiliateOfferModel = notTested ? "rd1" : "corentium_home";
    final String affiliateJourneyStage = notTested ? "first_test" : "followup_monitor";
    final String affiliateCtaId = notTested ? "next_step_not_tested_kit" : "next_step_under_2_monitor";
}

<section id="estimate-form" class="mt-12 mb-12 rounded-3xl border border-slate-200 bg-white p-8 shadow-sm" data-nosnippet>
    <div class="flex flex-col gap-6 lg:flex-row lg:items-center lg:justify-between">
        <div class="max-w-2xl">
            <div class="inline-flex items-center gap-2 rounded-full bg-emerald-50 px-3 py-1 text-xs font-bold uppercase tracking-wider text-emerald-700">
                ${badge}
            </div>
            <h3 class="mt-4 font-display text-3xl font-bold tracking-tight text-slate-900">${heading}</h3>
            <p class="mt-3 text-base leading-relaxed text-slate-600">
                ${intro}
            </p>
            <ul class="mt-5 space-y-3 text-sm text-slate-600">
                <li class="flex items-start gap-3">
                    <span class="mt-1 h-2 w-2 rounded-full bg-emerald-500 shrink-0"></span>
                    <span>Use the local range here as context, not as a request for contractor outreach yet.</span>
                </li>
                <li class="flex items-start gap-3">
                    <span class="mt-1 h-2 w-2 rounded-full bg-emerald-500 shrink-0"></span>
                    <span>
                        @if(notTested)
                            Come back with a real result so the county action plan can switch into a true decision mode.
                        @else
                            If a follow-up test rises into the action range, reopen this county page with the new reading and compare local next steps.
                        @endif
                    </span>
                </li>
            </ul>
        </div>

        <div class="flex w-full flex-col gap-3 lg:w-[320px]">
            <a href="${primaryHref}"
               class="inline-flex items-center justify-center rounded-xl bg-slate-900 px-5 py-3 text-sm font-bold text-white transition-colors hover:bg-slate-800">
                ${primaryLabel}
            </a>
            <a href="${secondaryHref}"
               data-rv-affiliate-link="true"
               onclick="if(window.rvTrackAffiliateClick) window.rvTrackAffiliateClick(this, { cta_id: '${affiliateCtaId}', offer_type: '${affiliateOfferType}', offer_brand: '${affiliateOfferBrand}', offer_model: '${affiliateOfferModel}', placement_group: 'county_next_step', placement_id: 'next_step_panel', journey_stage: '${affiliateJourneyStage}' });"
               target="_blank"
               rel="sponsored nofollow noopener"
               class="inline-flex items-center justify-center rounded-xl border border-slate-200 bg-white px-5 py-3 text-sm font-semibold text-slate-700 transition-colors hover:bg-slate-50">
                ${secondaryLabel}
            </a>
        </div>
    </div>
</section>
