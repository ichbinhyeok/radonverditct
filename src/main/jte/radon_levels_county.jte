@import com.radonverdict.model.County
@import com.radonverdict.model.StateRegulations.StateRule
@import com.radonverdict.model.dto.AeoAnswerBlock
@import com.radonverdict.model.dto.InternalLinkItem
@import com.radonverdict.model.dto.PageQualityResult
@import com.radonverdict.model.dto.TrustMetadata
@import com.radonverdict.util.JsonLdUtils
@import java.util.List

@param County county
@param StateRule stateRule = null
@param List<County> nearbyCounties = null
@param String canonicalUrl = null
@param boolean noindex = false
@param AeoAnswerBlock aeo = null
@param List relatedLinks = null
@param PageQualityResult quality = null
@param TrustMetadata trust = null
@param boolean monetizationHooksEnabled = false
@param boolean showSeoDebug = false
!{
    final String seoCountyDisplay = county.getSeoDisplayName();
    final String seoPlaceLabel = seoCountyDisplay + ", " + county.getStateAbbr();
    final String shortTermKitUrl = "https://www.amazon.com/dp/B00002N83E?tag=radonverdict-20";
    final String digitalMonitorUrl = "https://www.amazon.com/dp/B00H2VOSP8?tag=radonverdict-20";
    final boolean fallsChurchDecisionCounty =
            "virginia".equals(county.getStateSlug()) && "falls-church-city".equals(county.getCountySlug());
    final boolean fremontZoneCounty =
            "idaho".equals(county.getStateSlug()) && "fremont-county".equals(county.getCountySlug());
    final boolean williamsonDecisionCounty =
            "tennessee".equals(county.getStateSlug()) && "williamson-county".equals(county.getCountySlug());
    final boolean santaClaraDecisionCounty =
            "california".equals(county.getStateSlug()) && "santa-clara-county".equals(county.getCountySlug());
    final boolean cherokeeDecisionCounty =
            "georgia".equals(county.getStateSlug()) && "cherokee-county".equals(county.getCountySlug());
    final boolean westchesterDecisionCounty =
            "new-york".equals(county.getStateSlug()) && "westchester-county".equals(county.getCountySlug());
    final boolean polkFloridaDecisionCounty =
            "florida".equals(county.getStateSlug()) && "polk-county".equals(county.getCountySlug());
    final boolean adaDecisionCounty =
            "idaho".equals(county.getStateSlug()) && "ada-county".equals(county.getCountySlug());
    final boolean chesterDecisionCounty =
            "pennsylvania".equals(county.getStateSlug()) && "chester-county".equals(county.getCountySlug());
    final boolean kaneDecisionCounty =
            "illinois".equals(county.getStateSlug()) && "kane-county".equals(county.getCountySlug());
    final boolean madisonAlabamaDecisionCounty =
            "alabama".equals(county.getStateSlug()) && "madison-county".equals(county.getCountySlug());
    final boolean phaseOneCtrLiftCounty =
            fallsChurchDecisionCounty
                    || williamsonDecisionCounty
                    || santaClaraDecisionCounty
                    || cherokeeDecisionCounty;
    final boolean phaseTwoCtrLiftCounty =
            westchesterDecisionCounty
                    || polkFloridaDecisionCounty
                    || adaDecisionCounty;
    final boolean phaseThreeCtrLiftCounty =
            chesterDecisionCounty
                    || kaneDecisionCounty
                    || madisonAlabamaDecisionCounty;
    final boolean nextStepCtrLiftCounty =
            phaseOneCtrLiftCounty || phaseTwoCtrLiftCounty || phaseThreeCtrLiftCounty;
    final boolean priorityCtrCounty =
            ("new-york".equals(county.getStateSlug()) && "schenectady-county".equals(county.getCountySlug()))
                    || ("massachusetts".equals(county.getStateSlug()) && "franklin-county".equals(county.getCountySlug()))
                    || ("virginia".equals(county.getStateSlug()) && "fairfax-city".equals(county.getCountySlug()))
                    || fallsChurchDecisionCounty
                    || ("maryland".equals(county.getStateSlug()) && "howard-county".equals(county.getCountySlug()))
                    || ("florida".equals(county.getStateSlug()) && "miami-dade-county".equals(county.getCountySlug()))
                    || fremontZoneCounty;
    final boolean topCtrPriorityCounty =
            fallsChurchDecisionCounty
                    || ("mississippi".equals(county.getStateSlug()) && "alcorn-county".equals(county.getCountySlug()))
                    || ("new-york".equals(county.getStateSlug()) && "westchester-county".equals(county.getCountySlug()))
                    || ("ohio".equals(county.getStateSlug()) && "licking-county".equals(county.getCountySlug()))
                    || ("iowa".equals(county.getStateSlug()) && "polk-county".equals(county.getCountySlug()))
                    || ("california".equals(county.getStateSlug()) && "santa-clara-county".equals(county.getCountySlug()))
                    || ("missouri".equals(county.getStateSlug()) && "st-louis-county".equals(county.getCountySlug()))
                    || ("tennessee".equals(county.getStateSlug()) && "williamson-county".equals(county.getCountySlug()))
                    || ("pennsylvania".equals(county.getStateSlug()) && "allegheny-county".equals(county.getCountySlug()))
                    || ("florida".equals(county.getStateSlug()) && "hillsborough-county".equals(county.getCountySlug()));

    final String seoTitle = fremontZoneCounty
            ? seoPlaceLabel + " EPA Radon Zone | Basement Levels & 4.0 Guide"
            : nextStepCtrLiftCounty
            ? seoPlaceLabel + " Radon Levels | EPA Zone, 4.0+, and Next Step"
            : topCtrPriorityCounty
            ? seoPlaceLabel + " Basement Radon Levels | EPA Zone & 4.0 Guide"
            : priorityCtrCounty
            ? seoPlaceLabel + " Radon Levels: EPA Zone & Basement Test Guide"
            : seoPlaceLabel + " Radon Levels, Zone Map & Home Testing Guide | EPA 4.0 pCi/L";

    final String seoDescription = fremontZoneCounty
            ? "Check the EPA radon zone for " + seoPlaceLabel
            + ", see what that zone means for basement radon levels, and know when 2.0-3.9 versus 4.0+ changes the next step."
            : nextStepCtrLiftCounty
            ? "Check radon levels in " + seoPlaceLabel
            + ", see the EPA zone, and know whether to test, retest, or budget mitigation after a 4.0+ result."
            : topCtrPriorityCounty
            ? "Check basement radon levels in " + seoPlaceLabel
            + ", see the EPA zone, and understand what 2.0 vs 4.0+ pCi/L means before you retest or compare mitigation quotes."
            : priorityCtrCounty
            ? "Check the EPA radon zone for " + seoPlaceLabel
            + ", what a basement test means at 2.0 vs 4.0+ pCi/L, and when to retest or compare mitigation quotes."
            : seoPlaceLabel + " radon guide for basement and lowest-level home tests. See EPA zone data, what 2.0, 4.0, and 8.0+ pCi/L mean, and when mitigation quotes are worth comparing.";

    final String heroTitle = fremontZoneCounty
            ? "EPA Radon Zone & Basement Testing in " + seoPlaceLabel
            : nextStepCtrLiftCounty
            ? seoPlaceLabel + " Radon Levels, EPA Zone & Next Step"
            : topCtrPriorityCounty
            ? "Basement Radon Levels, EPA Zone & Test Meaning in " + seoPlaceLabel
            : priorityCtrCounty
            ? "Radon Levels, EPA Zone & Basement Testing in " + seoPlaceLabel
            : "Radon Levels & Zone Map in " + seoPlaceLabel;

    final String directAnswerLead = fremontZoneCounty
            ? "EPA zone answer first: "
            : nextStepCtrLiftCounty
            ? "Fast local answer: "
            : topCtrPriorityCounty
            ? "Basement test answer: "
            : priorityCtrCounty
            ? "Short answer for homeowners, buyers, and sellers: "
            : "Direct Answer for basement and lowest-level tests: ";

    final String introIntentLead = fallsChurchDecisionCounty
            ? "If you are checking radon levels in a " + county.getAreaDisplayName()
                    + " basement, use the EPA zone as context first, then decide whether a 2.0-3.9 result needs a retest or a 4.0+ result needs mitigation planning."
            : phaseOneCtrLiftCounty
            ? "Use the " + county.getAreaDisplayName()
                    + " quick path to decide between first testing, retesting, or budgeting mitigation instead of starting with a generic radon guide."
            : phaseTwoCtrLiftCounty
            ? "If you already have a reading in " + county.getAreaDisplayName()
                    + ", start with the local next-step answer before opening a longer guide."
            : phaseThreeCtrLiftCounty
            ? "Start with the short local verdict for " + county.getAreaDisplayName()
                    + ", then go deeper only if you still need context."
            : fremontZoneCounty
            ? "If you are trying to confirm the EPA radon zone for " + county.getAreaDisplayName()
                    + ", use this page for the quick zone answer first, then map that zone to what a basement or lowest-level test result actually means."
            : null;

    final String decisionFlowIntro = fallsChurchDecisionCounty
            ? "Open the " + county.getAreaDisplayName()
                    + " action plan from the basement result you already have, instead of starting from a generic cost page."
            : phaseOneCtrLiftCounty
            ? "Open the " + county.getAreaDisplayName()
                    + " action plan from the result you already have, instead of reading a longer general guide first."
            : phaseTwoCtrLiftCounty
            ? "Jump into the " + county.getAreaDisplayName()
                    + " action plan from your current result, instead of backing into it from a generic cost page."
            : phaseThreeCtrLiftCounty
            ? "Use the " + county.getAreaDisplayName()
                    + " quick path first, then open the deeper reference only if you still need it."
            : fremontZoneCounty
            ? "Open the " + county.getAreaDisplayName()
                    + " action plan from the EPA zone or reading you already have, instead of starting from a generic cost page."
            : "Jump into a prefilled " + county.getAreaDisplayName()
                    + " action plan based on the result you already have, instead of starting from a generic cost page.";

    final String borderlineResultCta = fallsChurchDecisionCounty
            ? "See what a " + county.getAreaDisplayName() + " basement result means for pricing"
            : fremontZoneCounty
            ? "See what a " + county.getAreaDisplayName() + " borderline result means for pricing"
            : nextStepCtrLiftCounty
            ? "See what a " + county.getAreaDisplayName() + " 2.0-3.9 result changes"
            : "Should I retest or get quotes?";

    final String highResultCta = fallsChurchDecisionCounty
            ? "See " + county.getAreaDisplayName() + " mitigation cost before calling contractors"
            : fremontZoneCounty
            ? "Open the " + county.getAreaDisplayName() + " 4.0+ mitigation plan"
            : nextStepCtrLiftCounty
            ? "Open the " + county.getAreaDisplayName() + " 4.0+ action plan"
            : "Budget mitigation before you call contractors";

    final String buyerSellerResultCta = fallsChurchDecisionCounty || fremontZoneCounty
            ? "Turn a " + county.getAreaDisplayName() + " result into seller-credit numbers"
            : nextStepCtrLiftCounty
            ? "Turn a " + county.getAreaDisplayName() + " result into a credit plan"
            : "Turn the result into a seller-credit plan";

    final String heroQuickVerdict = phaseOneCtrLiftCounty
            ? county.getAreaDisplayName()
            + " searchers usually need the practical next move fast. The first useful split is simple: no test yet, 2.0-3.9, or 4.0+."
            : phaseTwoCtrLiftCounty
            ? county.getAreaDisplayName()
            + " works best as a reading-to-decision page. The county average is context, but your result is what changes the next move."
            : phaseThreeCtrLiftCounty
            ? "Start with the quick local verdict for " + county.getAreaDisplayName()
            + ". If you still need more detail after that, the longer reference is below."
            : county.getEpaZone() == 1
            ? county.getAreaDisplayName() + " is a strong county-level radon signal. You still need a home test, but this is not a county where skipping the first test makes sense."
            : county.getEpaZone() == 2
            ? county.getAreaDisplayName() + " sits in the gray zone. The map helps, but your own reading matters more than the county average."
            : county.getEpaZone() == 3
            ? county.getAreaDisplayName() + " has a lower countywide signal, but that does not clear an individual home. A real test still beats the map."
            : county.getAreaDisplayName() + " has no published county zone in our dataset, so the useful answer starts with a direct home test.";

    final String quickDecisionHeading = phaseOneCtrLiftCounty
            ? "Pick the lane fast"
            : phaseTwoCtrLiftCounty
            ? "Use the reading to choose the lane"
            : phaseThreeCtrLiftCounty
            ? "Take the quick verdict first"
            : county.getEpaZone() == 1
            ? "Do not guess in a higher-risk county"
            : county.getEpaZone() == 2
            ? "Treat the map as a hint, not the answer"
            : county.getEpaZone() == 3
            ? "Low county risk is not a home-level clear signal"
            : "No map answer here";

    final String quickDecisionBody = phaseOneCtrLiftCounty
            ? "No test yet, 2.0-3.9, and 4.0+ each point to a different next move. This page is built to get you there without extra reading."
            : phaseTwoCtrLiftCounty
            ? "The county average matters less than the result in your home. Use the number to decide whether you test, retest, or price mitigation."
            : phaseThreeCtrLiftCounty
            ? "If your goal is just the next practical step, start with the local verdict and save the long explanation for later."
            : county.getEpaZone() == 1
            ? "Most users should either get a first test or move a 4.0+ result straight into mitigation pricing."
            : county.getEpaZone() == 2
            ? "Zone 2 is the gray area. A real reading is what decides whether you retest, track, or price mitigation."
            : county.getEpaZone() == 3
            ? "Do not let a Zone 3 label talk you out of the first test. House-by-house differences still matter."
            : "With no county signal, direct testing is the first decision that matters.";

    final String countySignalSummary = nextStepCtrLiftCounty
            ? "County map context helps, but your own result is what changes the decision."
            : county.getEpaZone() == 1
            ? "Higher-than-average chance of 4.0+ readings across the county."
            : county.getEpaZone() == 2
            ? "Gray-zone county average. Some homes stay low, others cross the EPA line."
            : county.getEpaZone() == 3
            ? "Lower county average, but house-by-house spikes still happen."
            : "No county average published. Treat direct testing as the only reliable input.";

    final String thresholdSummary = nextStepCtrLiftCounty
            ? "No reading yet means test first. 2.0-3.9 usually means retest or track. 4.0+ means local budget planning starts."
            : "2.0-3.9 pCi/L usually means retest or track. 4.0+ is where EPA action and quote planning start to matter.";

    final String fastMoveSummary = nextStepCtrLiftCounty
            ? "No reading: test first. 2.0-3.9: retest or track. 4.0+: budget local mitigation."
            : county.getEpaZone() == 1
            ? "No reading: test now. Reading at 4.0+: move into mitigation planning."
            : county.getEpaZone() == 2
            ? "No reading: test first. Borderline results often need retest or long-term tracking."
            : county.getEpaZone() == 3
            ? "Low zone is not a free pass. Use a kit before you rule radon out."
            : "Start with a test kit, then let the result decide whether pricing or credit planning matters.";

    String averageLevelAnswerBase;
    if (county.getEpaZone() == 1) {
        averageLevelAnswerBase = county.getAreaDisplayName() + " is classified as EPA Zone 1 (High Risk). The predicted average indoor radon screening level exceeds 4.0 pCi/L, which is above the EPA action level.";
    } else if (county.getEpaZone() == 2) {
        averageLevelAnswerBase = county.getAreaDisplayName() + " is classified as EPA Zone 2 (Moderate Risk). The predicted average indoor screening level is between 2.0 and 4.0 pCi/L.";
    } else if (county.getEpaZone() == 3) {
        averageLevelAnswerBase = county.getAreaDisplayName() + " is classified as EPA Zone 3 (Low Risk). The predicted average indoor screening level is below 2.0 pCi/L.";
    } else {
        averageLevelAnswerBase = county.getAreaDisplayName() + " is classified as an unclassified EPA zone (Data Pending). The EPA zone for this county is currently unclassified in our source data. Please rely on direct home testing to determine risk.";
    }
    final String averageLevelAnswer = averageLevelAnswerBase + " The EPA recommends testing all homes regardless of zone.";

    final String isProblemAnswer;
    if (county.getEpaZone() == 1) {
        isProblemAnswer = "Yes, " + county.getAreaDisplayName() + " is in EPA Zone 1 (High Risk). Most homes should be tested and many will need mitigation.";
    } else if (county.getEpaZone() == 2) {
        isProblemAnswer = county.getAreaDisplayName() + " is in EPA Zone 2 (Moderate Risk). Many individual homes can still have elevated levels above the EPA action threshold.";
    } else if (county.getEpaZone() == 3) {
        isProblemAnswer = county.getAreaDisplayName() + " is in EPA Zone 3 (Low Risk), but elevated radon has been found in homes in every zone. Testing is always recommended.";
    } else {
        isProblemAnswer = county.getAreaDisplayName() + " does not currently have a published EPA zone assignment in our dataset. Because radon risk can vary significantly by home, testing is strongly recommended.";
    }

    final String testAnswer = "Purchase a short-term radon test kit ($15-$30) from a hardware store or online as your first step. Place it in the lowest livable level of your home for 2-7 days with closed-house conditions, then mail it to the lab. If you have already tested once and want ongoing tracking, consider a digital radon monitor ($150-$200).";
}

@template.layout.main(
    title = seoTitle,
    description = seoDescription,
    canonicalUrl = canonicalUrl,
    noindex = noindex,
    headContent = @`
        <script type="application/ld+json">
            {
                "@context": "https://schema.org",
                "@type": "FAQPage",
                "mainEntity": [
                    {
                        "@type": "Question",
                        "name": $unsafe{JsonLdUtils.json("What is the average radon level in " + seoPlaceLabel + "?")},
                        "acceptedAnswer": {
                            "@type": "Answer",
                            "text": $unsafe{JsonLdUtils.json(averageLevelAnswer)}
                        }
                    },
                    {
                        "@type": "Question",
                        "name": $unsafe{JsonLdUtils.json("Is radon a problem in " + seoPlaceLabel + "?")},
                        "acceptedAnswer": {
                            "@type": "Answer",
                            "text": $unsafe{JsonLdUtils.json(isProblemAnswer)}
                        }
                    },
                    {
                        "@type": "Question",
                        "name": $unsafe{JsonLdUtils.json("How do I test for radon in " + seoPlaceLabel + "?")},
                        "acceptedAnswer": {
                            "@type": "Answer",
                            "text": $unsafe{JsonLdUtils.json(testAnswer)}
                        }
                    }
                ]
            }
        </script>
        <script type="application/ld+json">
            {
                "@context": "https://schema.org",
                "@type": "BreadcrumbList",
                "itemListElement": [{
                    "@type": "ListItem",
                    "position": 1,
                    "name": "Home",
                    "item": "https://radonverdict.com/"
                },{
                    "@type": "ListItem",
                    "position": 2,
                    "name": $unsafe{JsonLdUtils.json(county.getStateAbbr() + " Radon Levels")},
                    "item": $unsafe{JsonLdUtils.json("https://radonverdict.com/radon-levels/" + county.getStateSlug())}
                },{
                    "@type": "ListItem",
                    "position": 3,
                    "name": $unsafe{JsonLdUtils.json(seoCountyDisplay)},
                    "item": $unsafe{JsonLdUtils.json("https://radonverdict.com/radon-levels/" + county.getStateSlug() + "/" + county.getCountySlug())}
                }]
            }
        </script>
    `,
    content = @`
        <div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 pt-10 pb-24 lg:pb-10">

            <!-- Breadcrumb -->
            <nav class="text-sm font-medium text-slate-500 mb-8" aria-label="Breadcrumb">
                <ol class="inline-flex items-center space-x-2">
                    <li><a href="/" class="hover:text-slate-900 transition-colors">Home</a></li>
                    <li><span class="mx-1 text-slate-300">/</span></li>
                    <li><a href="/radon-levels/${county.getStateSlug()}" class="hover:text-slate-900 transition-colors uppercase">${county.getStateAbbr()}</a></li>
                    <li><span class="mx-1 text-slate-300">/</span></li>
                    <li class="text-slate-900 font-semibold" aria-current="page">${county.getAreaDisplayName()}</li>
                </ol>
            </nav>

            <!-- Hero Section -->
            <div class="rounded-3xl bg-gradient-to-br from-slate-900 via-slate-800 to-slate-900 p-6 sm:p-10 mb-10 relative overflow-hidden">
                <div class="absolute inset-0 opacity-5" style="background-image: url('data:image/svg+xml,%3Csvg width=&quot;60&quot; height=&quot;60&quot; viewBox=&quot;0 0 60 60&quot; xmlns=&quot;http://www.w3.org/2000/svg&quot;%3E%3Cg fill=&quot;none&quot; fill-rule=&quot;evenodd&quot;%3E%3Cg fill=&quot;%23ffffff&quot; fill-opacity=&quot;1&quot;%3E%3Cpath d=&quot;M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z&quot;/%3E%3C/g%3E%3C/g%3E%3C/svg%3E');"></div>

                <div class="relative z-10">
                    <div class="inline-flex items-center gap-2 px-3 py-1.5 rounded-full text-xs font-bold uppercase tracking-wider mb-6
                        @if(county.getEpaZone() == 1) bg-red-500/20 text-red-300
                        @elseif(county.getEpaZone() == 2) bg-amber-500/20 text-amber-300
                        @elseif(county.getEpaZone() == 3) bg-emerald-500/20 text-emerald-300
                        @else bg-slate-500/20 text-slate-200
                        @endif
                    ">
                        <span class="w-2 h-2 rounded-full
                            @if(county.getEpaZone() == 1) bg-red-400
                            @elseif(county.getEpaZone() == 2) bg-amber-400
                            @elseif(county.getEpaZone() == 3) bg-emerald-400
                            @else bg-slate-300
                            @endif
                        "></span>
                        EPA Zone ${county.getEpaZone() > 0 ? Integer.toString(county.getEpaZone()) : "Unclassified"} -
                        @if(county.getEpaZone() == 1) High Risk
                        @elseif(county.getEpaZone() == 2) Moderate Risk
                        @elseif(county.getEpaZone() == 3) Low Risk
                        @else Data Pending
                        @endif
                    </div>

                    <div class="grid grid-cols-1 lg:grid-cols-[minmax(0,1.1fr)_minmax(0,0.9fr)] gap-6 items-start">
                        <div class="min-w-0">
                            <h1 class="font-display font-black text-white leading-[0.98] mb-5 break-words" style="font-size: clamp(2rem, 10vw, 3.5rem);">${heroTitle}</h1>

                            <p class="text-base sm:text-lg text-slate-300 leading-relaxed max-w-3xl" itemscope itemtype="https://schema.org/Answer" itemprop="text">
                                <strong class="text-white">${directAnswerLead}</strong>
                                @if(introIntentLead != null)
                                    ${introIntentLead}
                                @endif
                                ${heroQuickVerdict}
                            </p>

                            <div class="mt-6 flex flex-col sm:flex-row gap-3">
                                <a href="#situation-picker"
                                   data-track-event="levels_primary_jump_click"
                                   data-track-label="hero_jump"
                                   class="inline-flex items-center justify-center gap-2 px-5 py-3 rounded-2xl bg-white text-slate-900 text-sm font-black hover:bg-slate-100 transition-colors shadow-lg">
                                    Pick My Next Step
                                </a>
                                <a href="/guides/how-to-test-for-radon"
                                   data-track-event="levels_test_guide_click"
                                   data-track-label="hero_primary"
                                   class="inline-flex items-center justify-center gap-2 px-5 py-3 rounded-2xl border border-white/20 text-white text-sm font-bold hover:bg-white/10 transition-colors">
                                    I Need to Test First
                                </a>
                            </div>
                        </div>

                        <div class="min-w-0 rounded-[1.75rem] border border-white/15 bg-white/10 backdrop-blur-sm p-5 sm:p-6 shadow-2xl">
                            <div class="text-xs font-bold uppercase tracking-[0.18em] text-sky-200 mb-3">Quick Read</div>
                            <h2 class="font-display font-black text-2xl text-white leading-tight mb-3">${quickDecisionHeading}</h2>
                            <p class="text-sm sm:text-base text-slate-200 leading-relaxed">${quickDecisionBody}</p>

                            <div class="mt-5 space-y-3">
                                <div class="rounded-2xl border border-white/10 bg-slate-950/20 p-3">
                                    <div class="text-[11px] font-bold uppercase tracking-[0.18em] text-slate-300">County signal</div>
                                    <p class="mt-1 text-sm font-semibold text-white leading-snug">${countySignalSummary}</p>
                                </div>
                                <div class="rounded-2xl border border-white/10 bg-slate-950/20 p-3">
                                    <div class="text-[11px] font-bold uppercase tracking-[0.18em] text-slate-300">What the number changes</div>
                                    <p class="mt-1 text-sm font-semibold text-white leading-snug">${thresholdSummary}</p>
                                </div>
                                <div class="rounded-2xl border border-white/10 bg-slate-950/20 p-3">
                                    <div class="text-[11px] font-bold uppercase tracking-[0.18em] text-slate-300">Fastest next move</div>
                                    <p class="mt-1 text-sm font-semibold text-white leading-snug">${fastMoveSummary}</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div id="situation-picker" class="mt-8 rounded-[1.75rem] bg-white p-5 sm:p-6 shadow-2xl border border-white/10">
                        <div class="flex flex-col gap-2 sm:flex-row sm:items-end sm:justify-between mb-5">
                            <div>
                                <div class="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-slate-100 text-slate-700 text-xs font-bold tracking-wider uppercase mb-3">
                                    Fastest Path
                                </div>
                                <h2 class="font-display font-black text-2xl text-slate-900 leading-tight">Pick the situation that matches you</h2>
                                <p class="mt-2 text-sm text-slate-600 leading-relaxed max-w-2xl">
                                    You should not need to read the whole guide before clicking one of these. Start with the lane that matches your current stage, then come back for the deeper reference only if you still need it.
                                </p>
                            </div>
                            <p class="text-sm text-slate-500 leading-relaxed max-w-sm">${decisionFlowIntro}</p>
                        </div>

                        <div class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-3">
                            <div class="rounded-2xl border border-emerald-200 bg-emerald-50 p-4 flex flex-col">
                                <div class="text-xs font-bold uppercase tracking-wider text-emerald-700">No reading yet</div>
                                <h3 class="mt-2 font-display font-bold text-lg text-slate-900">I have not tested yet</h3>
                                <p class="mt-2 text-sm text-slate-700 leading-relaxed">
                                    Do not price mitigation blind. Get the first number, then decide whether you need monitoring, quotes, or nothing at all.
                                </p>
                                <div class="mt-4 flex flex-col gap-2">
                                    <a href="${shortTermKitUrl}"
                                       data-rv-affiliate-link="true"
                                       onclick="if(window.rvTrackAffiliateClick) window.rvTrackAffiliateClick(this, { cta_id: 'levels_situation_test_kit', offer_type: 'test_kit', offer_brand: 'first_alert', offer_model: 'rd1', placement_group: 'levels', placement_id: 'situation_not_tested_primary', journey_stage: 'first_test' });"
                                       target="_blank"
                                       rel="noopener sponsored nofollow"
                                       class="inline-flex items-center justify-center gap-2 px-4 py-3 rounded-xl bg-emerald-600 text-white text-sm font-bold hover:bg-emerald-700 transition-colors">
                                        Start with a Short-Term Test Kit
                                    </a>
                                    <a href="/guides/how-to-test-for-radon"
                                       data-track-event="levels_test_guide_click"
                                       data-track-label="hero_not_tested"
                                       class="inline-flex items-center justify-center gap-2 px-4 py-3 rounded-xl border border-emerald-200 text-emerald-800 text-sm font-bold hover:bg-emerald-100 transition-colors">
                                        Read the 3-minute testing guide
                                    </a>
                                </div>
                            </div>

                            <a href="/radon-mitigation-cost/${county.getStateSlug()}/${county.getCountySlug()}?radonResultBand=between_2_and_4&intent=homeowner#estimate-form"
                               data-track-event="levels_result_path_click"
                               data-track-label="borderline_result"
                               class="rounded-2xl border border-amber-200 bg-amber-50 p-4 hover:border-amber-300 hover:bg-amber-100 transition-colors flex flex-col">
                                <div class="text-xs font-bold uppercase tracking-wider text-amber-700">2.0-3.9 pCi/L</div>
                                <h3 class="mt-2 font-display font-bold text-lg text-slate-900">My result is 2.0-3.9</h3>
                                <p class="mt-2 text-sm text-slate-700 leading-relaxed flex-1">
                                    Usually retest or track first. If the reading keeps showing up, use the local action plan to decide whether pricing makes sense.
                                </p>
                                <div class="mt-4 inline-flex items-center justify-between gap-3 text-sm font-semibold text-slate-900">
                                    <span>${borderlineResultCta}</span>
                                    <svg class="w-4 h-4 text-amber-700 shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                                        <path stroke-linecap="round" stroke-linejoin="round" d="M9 5l7 7-7 7" />
                                    </svg>
                                </div>
                            </a>

                            <a href="/radon-mitigation-cost/${county.getStateSlug()}/${county.getCountySlug()}?radonResultBand=above_4&intent=homeowner#estimate-form"
                               data-track-event="levels_result_path_click"
                               data-track-label="high_result"
                               class="rounded-2xl border border-red-200 bg-red-50 p-4 hover:border-red-300 hover:bg-red-100 transition-colors flex flex-col">
                                <div class="text-xs font-bold uppercase tracking-wider text-red-700">4.0+ pCi/L</div>
                                <h3 class="mt-2 font-display font-bold text-lg text-slate-900">My result is 4.0+</h3>
                                <p class="mt-2 text-sm text-slate-700 leading-relaxed flex-1">
                                    This is the EPA action line. Use the local cost page before calling contractors so you know the likely scope, timing, and budget.
                                </p>
                                <div class="mt-4 inline-flex items-center justify-between gap-3 text-sm font-semibold text-slate-900">
                                    <span>${highResultCta}</span>
                                    <svg class="w-4 h-4 text-red-700 shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                                        <path stroke-linecap="round" stroke-linejoin="round" d="M9 5l7 7-7 7" />
                                    </svg>
                                </div>
                            </a>

                            <a href="/radon-credit-calculator/${county.getStateSlug()}/${county.getCountySlug()}?radonResultBand=above_4&intent=buying"
                               data-track-event="levels_result_path_click"
                               data-track-label="buyer_seller_path"
                               class="rounded-2xl border border-blue-200 bg-blue-50 p-4 hover:border-blue-300 hover:bg-blue-100 transition-colors flex flex-col">
                                <div class="text-xs font-bold uppercase tracking-wider text-blue-700">Buying or selling</div>
                                <h3 class="mt-2 font-display font-bold text-lg text-slate-900">I am buying or selling</h3>
                                <p class="mt-2 text-sm text-slate-700 leading-relaxed flex-1">
                                    Turn the reading into a credit or repair number before negotiation starts. This is the faster path than arguing from a generic article.
                                </p>
                                <div class="mt-4 inline-flex items-center justify-between gap-3 text-sm font-semibold text-slate-900">
                                    <span>${buyerSellerResultCta}</span>
                                    <svg class="w-4 h-4 text-blue-700 shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                                        <path stroke-linecap="round" stroke-linejoin="round" d="M9 5l7 7-7 7" />
                                    </svg>
                                </div>
                            </a>
                        </div>

                        <div class="mt-5 pt-4 border-t border-slate-200 flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
                            <p class="text-xs text-slate-500 leading-relaxed">Already tested once and just want to watch the number trend?</p>
                            <a href="${digitalMonitorUrl}"
                               data-rv-affiliate-link="true"
                               onclick="if(window.rvTrackAffiliateClick) window.rvTrackAffiliateClick(this, { cta_id: 'levels_situation_monitor_followup', offer_type: 'monitor', offer_brand: 'airthings', offer_model: 'corentium_home', placement_group: 'levels', placement_id: 'situation_followup_link', journey_stage: 'followup_monitor' });"
                               target="_blank"
                               rel="noopener sponsored nofollow"
                               class="inline-flex items-center gap-2 text-sm font-bold text-indigo-700 hover:text-indigo-900 transition-colors">
                                View Airthings Corentium Home
                                <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                                    <path stroke-linecap="round" stroke-linejoin="round" d="M17.25 8.25L21 12m0 0l-3.75 3.75M21 12H3" />
                                </svg>
                            </a>
                        </div>
                        <p class="mt-3 text-[11px] text-slate-400">Affiliate disclosure: we may earn a commission if you buy through these links.</p>
                    </div>
                </div>
            </div>

            <div class="mobile-sticky-cta fixed bottom-4 right-4 z-40 lg:hidden" data-nosnippet>
                <a href="#situation-picker"
                   data-track-event="levels_mobile_jump_click"
                   data-track-label="sticky_picker"
                   class="inline-flex items-center gap-2 rounded-full border border-slate-800 bg-slate-950/95 px-4 py-3 text-sm font-black text-white shadow-2xl backdrop-blur transition-transform active:scale-95">
                    Pick My Next Step
                    <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M13.5 4.5L21 12m0 0l-7.5 7.5M21 12H3" />
                    </svg>
                </a>
            </div>

            @if(aeo != null)
                @template.components.aeo_answer_block(block = aeo)
            @endif

            <!-- Main Two-Column Layout -->
            <div class="grid grid-cols-1 lg:grid-cols-12 gap-10 mb-20">

                <!-- LEFT: Interactive Radon Level Checker + Info -->
                <div class="lg:col-span-7">

                    <!-- Radon Level Analyzer (Reused component with enhanced context) -->
                    @template.components.radon_level_advisor(county = county)

                    <!-- What the Numbers Mean - Educational Section -->
                    <div class="bg-white rounded-[2rem] p-6 sm:p-8 shadow-sm border border-slate-200 mt-6">
                        <h2 class="font-display font-bold text-xl text-slate-900 mb-6">Understanding Radon Levels: Complete Reference</h2>

                        <div class="space-y-4">
                            <!-- Tier 1: Below 2.0 -->
                            <div class="flex gap-4 items-start p-4 rounded-xl bg-emerald-50 border border-emerald-100">
                                <div class="w-12 h-12 rounded-xl bg-emerald-500 text-white flex items-center justify-center shrink-0 font-display font-bold text-xs px-1">
                                    &lt;2.0
                                </div>
                                <div>
                                    <h3 class="font-bold text-emerald-900 text-sm">Below 2.0 pCi/L - Acceptable Range</h3>
                                    <p class="text-xs text-emerald-800 leading-relaxed mt-1">
                                        Below both the EPA (4.0) and WHO (2.7) action levels. No mitigation needed. The average outdoor radon level
                                        is approximately 0.4 pCi/L. Periodic monitoring is still recommended, as levels can change over time due to
                                        seasonal variations, changes in home ventilation, or foundation settling.
                                    </p>
                                </div>
                            </div>

                            <!-- Tier 2: 2.0 - 4.0 -->
                            <div class="flex gap-4 items-start p-4 rounded-xl bg-amber-50 border border-amber-100">
                                <div class="w-12 h-12 rounded-xl bg-amber-500 text-white flex items-center justify-center shrink-0 font-display font-bold text-xs px-1 text-center leading-tight">
                                    2.0<br>-4.0
                                </div>
                                <div>
                                    <h3 class="font-bold text-amber-900 text-sm">2.0 - 4.0 pCi/L - Elevated, Consider Action</h3>
                                    <p class="text-xs text-amber-800 leading-relaxed mt-1">
                                        Exceeds the World Health Organization's reference level of 2.7 pCi/L but falls below the US EPA action threshold.
                                        The EPA states that homeowners should <em>"consider fixing"</em> homes in this range, especially if the home has a basement
                                        used as living space, if children are present, or in connection with a real estate transaction.
                                        Practical next step: run a confirmatory long-term test, then compare mitigation quotes if levels remain elevated.
                                    </p>
                                </div>
                            </div>

                            <!-- Tier 3: 4.0 - 8.0 -->
                            <div class="flex gap-4 items-start p-4 rounded-xl bg-red-50 border border-red-100">
                                <div class="w-12 h-12 rounded-xl bg-red-500 text-white flex items-center justify-center shrink-0 font-display font-bold text-xs px-1 text-center leading-tight">
                                    4.0<br>-8.0
                                </div>
                                <div>
                                    <h3 class="font-bold text-red-900 text-sm">4.0 - 8.0 pCi/L - Action Recommended</h3>
                                    <p class="text-xs text-red-800 leading-relaxed mt-1">
                                        Exceeds the EPA action level of 4.0 pCi/L. The EPA and Surgeon General strongly recommend mitigation within a few months.
                                        At this level, prioritize confirmatory testing and contractor planning. Standard sub-slab depressurization
                                        systems typically reduce indoor levels by 80-99%.
                                    </p>
                                </div>
                            </div>

                            <!-- Tier 4: Above 8.0 -->
                            <div class="flex gap-4 items-start p-4 rounded-xl bg-red-100 border border-red-200">
                                <div class="w-12 h-12 rounded-xl bg-red-700 text-white flex items-center justify-center shrink-0 font-display font-bold text-xs px-1">
                                    8.0+
                                </div>
                                <div>
                                    <h3 class="font-bold text-red-900 text-sm">Above 8.0 pCi/L - Urgent Action Required</h3>
                                    <p class="text-xs text-red-800 leading-relaxed mt-1">
                                        At these levels, the EPA recommends expedited mitigation - ideally within weeks, not months.
                                        Occupants should minimize time in lower-level rooms until the system is installed.
                                        Use a certified mitigator and request priority scheduling to shorten high-exposure time.
                                        Many mitigators offer priority scheduling for homes above 8.0 pCi/L.
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Geological Context - Zone-Specific Unique Content -->
                    <div class="bg-white rounded-[2rem] p-6 sm:p-8 shadow-sm border border-slate-200 mt-6">
                        <h2 class="font-display font-bold text-xl text-slate-900 mb-4">Why Radon is
                            @if(county.getEpaZone() == 1)
                                a Serious Concern
                            @elseif(county.getEpaZone() == 2)
                                Worth Monitoring
                            @elseif(county.getEpaZone() == 3)
                                Still Relevant
                            @else
                                Worth Testing
                            @endif
                            in ${county.getAreaDisplayName()}
                        </h2>

                        @if(county.getEpaZone() == 1)
                            <p class="text-sm text-slate-700 leading-relaxed mb-4">
                                ${county.getAreaDisplayName()} sits in a geological region with elevated uranium concentrations in the underlying bedrock and soil.
                                As uranium naturally decays, it produces radium, which further decays into radon gas. This gas migrates upward through soil
                                and enters homes through foundation cracks, gaps around pipes, and sump pits.
                            </p>
                            <p class="text-sm text-slate-700 leading-relaxed mb-4">
                                In Zone 1 counties like ${county.getCountyName()}, the EPA predicts that the average home will have a screening level
                                above 4.0 pCi/L. However, individual homes can vary dramatically - even neighboring houses can differ by a factor of 10 or more.
                                This is why <strong>every home needs its own test</strong>, regardless of what a neighbor's reading shows.
                            </p>
                            <p class="text-sm text-slate-700 leading-relaxed">
                                Factors that amplify radon entry include: basement foundations (more soil contact area), granitic or shale bedrock,
                                tight energy-efficient construction (less natural ventilation), and negative indoor air pressure from HVAC systems,
                                exhaust fans, and dryers.
                            </p>
                        @elseif(county.getEpaZone() == 2)
                            <p class="text-sm text-slate-700 leading-relaxed mb-4">
                                ${county.getAreaDisplayName()} falls in EPA Zone 2, where predicted average indoor screening levels
                                range between 2.0 and 4.0 pCi/L. While the county average may fall below the EPA action level,
                                geological variability means that a significant percentage of individual homes will still test above 4.0 pCi/L.
                            </p>
                            <p class="text-sm text-slate-700 leading-relaxed mb-4">
                                The soil composition in this area typically includes a mix of sedimentary formations that can contain moderate
                                uranium deposits. Homes with basement or crawlspace foundations are particularly susceptible, as they provide
                                more pathways for soil gas entry.
                            </p>
                            <p class="text-sm text-slate-700 leading-relaxed">
                                The World Health Organization recommends action at 2.7 pCi/L - well below the US EPA threshold.
                                If you have children, spend significant time in below-grade rooms, or are buying/selling a home,
                                testing is essential even in a Zone 2 area.
                            </p>
                        @elseif(county.getEpaZone() == 3)
                            <p class="text-sm text-slate-700 leading-relaxed mb-4">
                                ${county.getAreaDisplayName()} is classified as EPA Zone 3, with predicted average indoor screening levels below 2.0 pCi/L.
                                This does <strong>not</strong> mean radon is absent - it means the statistical average is low.
                            </p>
                            <p class="text-sm text-slate-700 leading-relaxed mb-4">
                                The EPA has documented elevated radon readings in every state and in homes in every zone classification.
                                Local geological anomalies - pockets of granite, shale intrusions, or fractured bedrock - can create
                                localized high-radon areas even within an otherwise low-risk county.
                            </p>
                            <p class="text-sm text-slate-700 leading-relaxed">
                                The Surgeon General and EPA recommend testing all homes, regardless of geographic zone.
                                A simple short-term test kit ($15-$30) provides results within a few days and can give you peace of mind.
                            </p>
                        @else
                            <p class="text-sm text-slate-700 leading-relaxed mb-4">
                                ${county.getAreaDisplayName()} currently has no published EPA zone assignment in our source dataset.
                                This does <strong>not</strong> mean the county is low risk or radon free.
                            </p>
                            <p class="text-sm text-slate-700 leading-relaxed mb-4">
                                Missing classification can happen due to source-data gaps, mapping updates, or jurisdiction edge cases.
                                Radon risk is still home specific and can vary significantly by foundation type, ventilation, and underlying geology.
                            </p>
                            <p class="text-sm text-slate-700 leading-relaxed">
                                The EPA and Surgeon General recommend testing all homes regardless of county zone status.
                                Start with a short-term test kit and follow up with confirmatory testing if your result is elevated.
                            </p>
                        @endif
                    </div>

                    <!-- Health Impact Section -->
                    <div class="bg-white rounded-[2rem] p-6 sm:p-8 shadow-sm border border-slate-200 mt-6">
                        <h2 class="font-display font-bold text-xl text-slate-900 mb-4">Radon & Health: What the Science Says</h2>

                        <div class="grid grid-cols-1 sm:grid-cols-3 gap-4 mb-6">
                            <div class="text-center p-4 rounded-xl bg-slate-50 border border-slate-100">
                                <div class="font-display font-black text-3xl text-slate-900">#2</div>
                                <div class="text-xs text-slate-500 font-semibold mt-1">Leading cause of<br>lung cancer</div>
                            </div>
                            <div class="text-center p-4 rounded-xl bg-slate-50 border border-slate-100">
                                <div class="font-display font-black text-3xl text-slate-900">21K</div>
                                <div class="text-xs text-slate-500 font-semibold mt-1">US deaths per year<br>from radon</div>
                            </div>
                            <div class="text-center p-4 rounded-xl bg-slate-50 border border-slate-100">
                                <div class="font-display font-black text-3xl text-slate-900">1 in 15</div>
                                <div class="text-xs text-slate-500 font-semibold mt-1">US homes above<br>4.0 pCi/L</div>
                            </div>
                        </div>

                        <p class="text-sm text-slate-700 leading-relaxed mb-4">
                            Radon is a Class A carcinogen - the same classification as asbestos and tobacco smoke.
                            The National Academy of Sciences estimates that radon causes approximately 21,000 lung cancer deaths
                            annually in the United States, making it the leading environmental cause of cancer death.
                        </p>
                        <p class="text-sm text-slate-700 leading-relaxed">
                            Unlike smoking, radon exposure is involuntary and often invisible. There is no safe level of radon -
                            risk increases linearly with exposure. The good news: radon mitigation systems are highly effective,
                            typically reducing indoor levels by 80-99% within hours of activation.
                        </p>

                        <div class="mt-6 p-4 rounded-xl bg-indigo-50 border border-indigo-100">
                            <p class="text-xs text-indigo-800 font-semibold">
                                Source: US Environmental Protection Agency, "A Citizen's Guide to Radon" (EPA 402/K-12/002).
                                National Academy of Sciences, Biological Effects of Ionizing Radiation (BEIR VI) Report, 1999.
                            </p>
                        </div>
                    </div>
                </div>

                <!-- RIGHT: Sticky Action Panel -->
                <div class="lg:col-span-5">
                    <div class="sticky top-24 space-y-6">

                        <!-- CTA Card 1: Test Your Home -->
                        <div class="bg-white rounded-[2rem] p-6 sm:p-8 shadow-sm border border-slate-200">
                            <div class="flex items-center gap-3 mb-4">
                                <div class="w-10 h-10 rounded-xl bg-indigo-600 text-white flex items-center justify-center">
                                    <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                                        <path stroke-linecap="round" stroke-linejoin="round" d="M9.75 17L9 20l-1 1h8l-1-1-.75-3M3 13h18M5 17h14a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                                    </svg>
                                </div>
                                <h3 class="font-display font-bold text-lg text-slate-900">Step 1: Test Your Home</h3>
                            </div>

                            <p class="text-sm text-slate-600 leading-relaxed mb-5">
                                Testing is the <strong>only</strong> way to know your home's radon level. Zone data tells you the regional risk,
                                but your home could be significantly higher or lower than the county average. For most homeowners, the right first purchase is a low-cost short-term test kit.
                            </p>

                            <div class="space-y-4">
                                <a href="${shortTermKitUrl}"
                                   data-rv-affiliate-link="true"
                                   target="_blank" rel="sponsored nofollow noopener"
                                   onclick="if(window.rvTrackAffiliateClick) window.rvTrackAffiliateClick(this, { cta_id: 'levels_sticky_test_kit', offer_type: 'test_kit', offer_brand: 'first_alert', offer_model: 'rd1', placement_group: 'levels', placement_id: 'sticky_primary_card', journey_stage: 'first_test' });"
                                   class="flex items-center justify-between w-full px-4 py-3 rounded-xl bg-slate-900 text-white hover:bg-slate-800 transition-colors group">
                                    <div>
                                        <div class="text-xs font-bold uppercase tracking-wider text-slate-400">Recommended first step</div>
                                        <div class="mt-1 text-sm font-bold">Recommended Short-Term Test Kit</div>
                                        <div class="text-xs text-slate-400">Results in 2-7 days - $15-$30</div>
                                    </div>
                                    <svg class="w-4 h-4 text-slate-400 group-hover:translate-x-1 transition-transform" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                                        <path stroke-linecap="round" stroke-linejoin="round" d="M17.25 8.25L21 12m0 0l-3.75 3.75M21 12H3" />
                                    </svg>
                                </a>
                                <div class="rounded-xl border border-slate-200 bg-slate-50 p-4">
                                    <div class="text-xs font-bold uppercase tracking-wider text-slate-500">Already tested once?</div>
                                    <p class="mt-1 text-sm text-slate-600 leading-relaxed">
                                        A digital monitor is a better fit after your first result, for seasonal re-checks, or to keep tracking levels after mitigation.
                                    </p>
                                    <a href="${digitalMonitorUrl}"
                                       data-rv-affiliate-link="true"
                                       target="_blank" rel="sponsored nofollow noopener"
                                       onclick="if(window.rvTrackAffiliateClick) window.rvTrackAffiliateClick(this, { cta_id: 'levels_sticky_monitor_followup', offer_type: 'monitor', offer_brand: 'airthings', offer_model: 'corentium_home', placement_group: 'levels', placement_id: 'sticky_followup_card', journey_stage: 'followup_monitor' });"
                                       class="inline-flex items-center gap-2 mt-3 text-sm font-bold text-indigo-700 hover:text-indigo-900 transition-colors">
                                        View Airthings Corentium Home
                                        <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                                            <path stroke-linecap="round" stroke-linejoin="round" d="M17.25 8.25L21 12m0 0l-3.75 3.75M21 12H3" />
                                        </svg>
                                    </a>
                                </div>
                            </div>

                            <p class="text-[10px] text-slate-400 mt-3 text-center">
                                As an Amazon Associate, RadonVerdict earns from qualifying purchases.
                            </p>
                        </div>

                        <!-- CTA Card 2: Already Have Results? Go to Cost Calculator -->
                        <div class="bg-gradient-to-br from-indigo-600 to-indigo-700 rounded-[2rem] p-6 sm:p-8 shadow-lg text-white">
                            <h3 class="font-display font-bold text-lg mb-3">Already Know Your Level?</h3>
                            <p class="text-sm text-indigo-100 leading-relaxed mb-5">
                                If your test shows 4.0 pCi/L or higher, get an itemized cost estimate specific to
                                ${county.getAreaDisplayName()} - including regional labor rates and permit requirements.
                            </p>
                            <a href="/radon-mitigation-cost/${county.getStateSlug()}/${county.getCountySlug()}"
                               class="flex items-center justify-center gap-2 w-full py-3.5 rounded-xl bg-white text-indigo-700 font-bold text-sm hover:bg-indigo-50 transition-colors shadow-sm">
                                <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
                                    <path stroke-linecap="round" stroke-linejoin="round" d="M9 7h6m0 10v-3m-3 3h.01M9 17h.01M9 14h.01M12 14h.01M15 11h.01M12 11h.01M9 11h.01M7 21h10a2 2 0 002-2V5a2 2 0 00-2-2H7a2 2 0 00-2 2v14a2 2 0 002 2z" />
                                </svg>
                                Get Mitigation Cost Estimate ->
                            </a>
                        </div>

                        <!-- State Regulation Box -->
                        @if(stateRule != null)
                        <div class="bg-white rounded-[2rem] p-6 shadow-sm border border-slate-200">
                            <h3 class="font-display font-bold text-sm text-slate-900 mb-3">${county.getStateAbbr()} Radon Regulations</h3>

                            <div class="space-y-3">
                                <div class="flex items-start gap-3">
                                    <div class="w-6 h-6 rounded-full shrink-0 flex items-center justify-center text-xs
                                        ${stateRule.isDisclosureRequired() ? "bg-amber-100 text-amber-600" : "bg-slate-100 text-slate-400"}">
                                        ${stateRule.isDisclosureRequired() ? "!" : "-"}
                                    </div>
                                    <div>
                                        <div class="text-xs font-bold text-slate-700">Seller Disclosure</div>
                                        <p class="text-xs text-slate-500 leading-relaxed mt-0.5">
                                            ${stateRule.getDisclosureSummary()}
                                        </p>
                                    </div>
                                </div>

                                <div class="flex items-start gap-3">
                                    <div class="w-6 h-6 rounded-full shrink-0 flex items-center justify-center text-xs
                                        ${stateRule.isLicenseRequired() ? "bg-indigo-100 text-indigo-600" : "bg-slate-100 text-slate-400"}">
                                        ${stateRule.isLicenseRequired() ? "yes" : "-"}
                                    </div>
                                    <div>
                                        <div class="text-xs font-bold text-slate-700">Professional Licensing</div>
                                        <p class="text-xs text-slate-500 leading-relaxed mt-0.5">
                                            ${stateRule.getLicenseNote()}
                                        </p>
                                    </div>
                                </div>
                            </div>

                            <a href="${stateRule.getStateProgramUrl()}" target="_blank" rel="noopener nofollow"
                               class="inline-flex items-center text-xs font-bold text-indigo-600 hover:text-indigo-800 mt-4 uppercase tracking-wider transition-colors">
                                Official state radon program
                                <svg class="w-3 h-3 ml-1" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" /></svg>
                            </a>
                        </div>
                        @endif

                    </div>
                </div>
            </div>
            @if(monetizationHooksEnabled)
                @template.components.monetization_hooks(countyName = county.getCountyName(), stateAbbr = county.getStateAbbr())
            @endif

            <!-- How to Test Section -->
            <div class="border-t border-slate-200 pt-16 mb-20">
                <h2 class="font-display font-bold text-2xl text-slate-900 mb-8 text-center">How to Test for Radon in ${county.getAreaDisplayName()}</h2>

                <div class="grid grid-cols-1 md:grid-cols-3 gap-6 max-w-4xl mx-auto">
                    <div class="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm text-center">
                        <div class="w-12 h-12 rounded-xl bg-indigo-100 text-indigo-600 flex items-center justify-center mx-auto mb-4">
                            <span class="font-display font-bold">1</span>
                        </div>
                        <h3 class="font-bold text-slate-900 mb-2">Buy a Test Kit</h3>
                        <p class="text-sm text-slate-600 leading-relaxed">
                            Purchase a short-term charcoal test kit online or from a local hardware store.
                            Cost: $15-$30. Place it in the lowest livable level of your home.
                        </p>
                    </div>
                    <div class="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm text-center">
                        <div class="w-12 h-12 rounded-xl bg-indigo-100 text-indigo-600 flex items-center justify-center mx-auto mb-4">
                            <span class="font-display font-bold">2</span>
                        </div>
                        <h3 class="font-bold text-slate-900 mb-2">Wait 2-7 Days</h3>
                        <p class="text-sm text-slate-600 leading-relaxed">
                            Keep doors and windows closed (except normal entry/exit) during the test period.
                            Avoid running whole-house fans. Mail the kit to the lab provided.
                        </p>
                    </div>
                    <div class="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm text-center">
                        <div class="w-12 h-12 rounded-xl bg-indigo-100 text-indigo-600 flex items-center justify-center mx-auto mb-4">
                            <span class="font-display font-bold">3</span>
                        </div>
                        <h3 class="font-bold text-slate-900 mb-2">Read Your Results</h3>
                        <p class="text-sm text-slate-600 leading-relaxed">
                            If results are <strong>below 4.0 pCi/L</strong>, re-test every 2 years or use a monitor for ongoing tracking.
                            If <strong>above 4.0</strong>, use our
                            <a href="/radon-mitigation-cost/${county.getStateSlug()}/${county.getCountySlug()}"
                               class="text-indigo-600 font-semibold hover:underline">cost calculator</a>
                            to see mitigation options.
                        </p>
                    </div>
                </div>
            </div>

            @template.components.related_links(
                title = "Related Radon Resources for " + county.getAreaDisplayName(),
                links = relatedLinks
            )

            <!-- Explore Other Counties -->
            @if(nearbyCounties != null && !nearbyCounties.isEmpty())
            <div class="border-t border-slate-200 pt-16 mb-10">
                <h3 class="font-display font-bold text-2xl text-slate-900 mb-6">Explore Other ${county.getStateAbbr()} Counties</h3>
                <div class="grid grid-cols-2 md:grid-cols-3 gap-4">
                    @for(var nearby : nearbyCounties)
                        <a href="/radon-levels/${nearby.getStateSlug()}/${nearby.getCountySlug()}"
                           class="block p-4 rounded-xl border border-slate-200 bg-white hover:border-indigo-300 hover:shadow-md transition-all group">
                            <span class="block font-bold text-slate-800 group-hover:text-indigo-600 transition-colors">${nearby.getCountyName()}</span>
                            <span class="text-xs text-slate-500 mt-1">Zone ${nearby.getEpaZone() > 0 ? Integer.toString(nearby.getEpaZone()) : "Unclassified"} -
                                @if(nearby.getEpaZone() == 1) High Risk
                                @elseif(nearby.getEpaZone() == 2) Moderate
                                @elseif(nearby.getEpaZone() == 3) Low Risk
                                @else Data Pending
                                @endif
                            </span>
                        </a>
                    @endfor
                </div>
            </div>
            @endif

            <!-- Sources & Disclaimers -->
            <div class="border-t border-slate-200 pt-16 mb-10 text-sm text-slate-500">
                <h3 class="font-display font-bold text-xl text-slate-900 mb-4">Sources & Methodology</h3>
                <p class="mb-4">
                    Radon zone classifications for ${county.getAreaDisplayName()} are sourced from the EPA's Map of Radon Zones,
                    which uses geological surveys, indoor radon measurements, and soil permeability data to assign each county a risk tier.
                </p>
                <ul class="space-y-2 pl-4 mb-6">
                    <li class="relative before:content-['*'] before:absolute before:-left-4 before:text-slate-300">
                        <a href="https://www.epa.gov/radon/epa-map-radon-zones" target="_blank" rel="nofollow noopener" class="text-indigo-600 hover:underline">EPA Map of Radon Zones</a>
                    </li>
                    <li class="relative before:content-['*'] before:absolute before:-left-4 before:text-slate-300">
                        <a href="https://www.epa.gov/radon" target="_blank" rel="nofollow noopener" class="text-indigo-600 hover:underline">EPA Radon Home Page</a>
                    </li>
                    <li class="relative before:content-['*'] before:absolute before:-left-4 before:text-slate-300">
                        <a href="https://www.who.int/publications/i/item/9789241547673" target="_blank" rel="nofollow noopener" class="text-indigo-600 hover:underline">WHO Handbook on Indoor Radon</a>
                    </li>
                </ul>
                <p class="text-xs text-slate-400">
                    <strong>Disclaimer:</strong> Zone data represents county-level averages and cannot predict the radon level in any specific home.
                    Testing is the only reliable method to determine your home's radon concentration. This content is for informational purposes
                    and is not medical advice.
                </p>
                <p class="mt-4 text-xs text-slate-400 font-medium">
                    Page Content Last Reviewed:
                    ${trust != null && trust.getLastReviewed() != null && !trust.getLastReviewed().isBlank() ? trust.getLastReviewed() : "Source-level retrieval dates"}
                </p>
            </div>
            @if(trust != null)
                @template.components.trust_metadata(trust = trust, quality = quality, showDebug = showSeoDebug)
            @endif

        </div>
    `
)

