@import com.radonverdict.model.dto.CountyPageContent
@import com.radonverdict.model.County
@import com.radonverdict.model.dto.AeoAnswerBlock
@import com.radonverdict.model.dto.InternalLinkItem
@import com.radonverdict.model.dto.PageQualityResult
@import com.radonverdict.model.dto.QuoteLedgerBenchmarkSnapshot
@import com.radonverdict.model.dto.TrustMetadata
@import com.radonverdict.util.JsonLdUtils
@import java.util.List

@param County county
@param CountyPageContent page
@param String canonicalUrl = null
@param String leadSuccessMessage = null
@param String leadErrorMessage = null
@param AeoAnswerBlock aeo = null
@param List<InternalLinkItem> relatedLinks = null
@param PageQualityResult quality = null
@param TrustMetadata trust = null
@param boolean monetizationHooksEnabled = false
@param boolean showSeoDebug = false
@param String prefilledZip = null
@param List<String> countyZipCodes = null
@param QuoteLedgerBenchmarkSnapshot quoteBenchmark = null

!{
    final String countyDisplay = county.getSeoDisplayName() + ", " + county.getStateAbbr();
    String[] stateSlugParts = county.getStateSlug().split("-");
    StringBuilder stateNameBuilder = new StringBuilder();
    for (int i = 0; i < stateSlugParts.length; i++) {
        String part = stateSlugParts[i];
        if (part == null || part.isBlank()) {
            continue;
        }
        String normalized = part.toLowerCase(java.util.Locale.ROOT);
        String displayPart;
        if (i > 0 && ("of".equals(normalized) || "and".equals(normalized))) {
            displayPart = normalized;
        } else {
            displayPart = normalized.substring(0, 1).toUpperCase(java.util.Locale.ROOT) + normalized.substring(1);
        }
        if (stateNameBuilder.length() > 0) {
            stateNameBuilder.append(" ");
        }
        stateNameBuilder.append(displayPart);
    }
    final String stateName = stateNameBuilder.length() > 0 ? stateNameBuilder.toString() : county.getStateAbbr();
    final int currentYear = java.time.LocalDate.now().getYear();
    final String seoTitle = "How Much Does Radon Mitigation Cost in " + countyDisplay + "? | " + currentYear + " Price Range";
    final String seoDescription = page.getSeoDescription() != null && !page.getSeoDescription().isBlank()
            ? page.getSeoDescription()
            : "See the typical radon mitigation price range in " + countyDisplay + " for basement, slab, and crawl space homes. Built for homeowners who already have a radon test result and need local quote context.";
    final boolean hasCountyZipCodes = countyZipCodes != null && !countyZipCodes.isEmpty();
    final String countyZipDisplay = hasCountyZipCodes ? String.join(", ", countyZipCodes) : "";
    final String primaryCountyZip = prefilledZip != null && prefilledZip.matches("\\d{5}") ? prefilledZip : (hasCountyZipCodes ? countyZipCodes.get(0) : "");
    final boolean loudounCostSearchCounty = "virginia".equals(county.getStateSlug())
            && "loudoun-county".equals(county.getCountySlug());
    final boolean ulsterCostDemandCounty =
            "new-york".equals(county.getStateSlug()) && "ulster-county".equals(county.getCountySlug());
    final boolean losAngelesCommercialCostDemandCounty =
            "california".equals(county.getStateSlug()) && "los-angeles-county".equals(county.getCountySlug());
    final boolean boulderCostDemandCounty =
            "colorado".equals(county.getStateSlug()) && "boulder-county".equals(county.getCountySlug());
    final boolean broomfieldCostDemandCounty =
            "colorado".equals(county.getStateSlug()) && "broomfield-county".equals(county.getCountySlug());
    final boolean stLouisCostDemandCounty =
            "missouri".equals(county.getStateSlug()) && "st-louis-county".equals(county.getCountySlug());
    final boolean calvertCostDemandCounty =
            "maryland".equals(county.getStateSlug()) && "calvert-county".equals(county.getCountySlug());
    final boolean indianaClarkCostDemandCounty =
            "indiana".equals(county.getStateSlug()) && "clark-county".equals(county.getCountySlug());
    final boolean searchDemandCostBridgeCounty =
            loudounCostSearchCounty
                    || ulsterCostDemandCounty
                    || losAngelesCommercialCostDemandCounty
                    || boulderCostDemandCounty
                    || broomfieldCostDemandCounty
                    || stLouisCostDemandCounty
                    || calvertCostDemandCounty
                    || indianaClarkCostDemandCounty;
    final String searchDemandQueryCluster = ulsterCostDemandCounty
            ? "radon gas testing Ulster County NY and radon mitigation services Ulster County NY"
            : losAngelesCommercialCostDemandCounty
            ? "commercial radon Los Angeles CA, commercial radon in Los Angeles, and radon testing Los Angeles"
            : boulderCostDemandCounty
            ? "radon testing Boulder CO, Boulder radon mitigation, and radon mitigation Boulder CO"
            : broomfieldCostDemandCounty
            ? "Broomfield radon mitigation"
            : loudounCostSearchCounty
            ? "20147 radon mitigation cost and radon testing Loudoun County"
            : stLouisCostDemandCounty
            ? "St Louis radon"
            : calvertCostDemandCounty
            ? "Calvert County radon mitigation cost"
            : indianaClarkCostDemandCounty
            ? "radon mitigation system cost Indiana"
            : "local radon testing, mitigation, and cost searches";
    final String searchDemandCostBridgeBody = losAngelesCommercialCostDemandCounty
            ? "Commercial and multifamily searches should not jump straight to a residential average. Use this page for a local budget anchor, then capture building type, test protocol, access, and scope before trusting any quote."
            : ulsterCostDemandCounty
            ? "Ulster search demand is testing and service-heavy, so the cost page needs to keep the pre-call sequence visible: confirm a valid reading, price a 4.0+ result, then compare quote scope."
            : boulderCostDemandCounty || broomfieldCostDemandCounty
            ? "Colorado service searches are close to contractor intent. This page should anchor the conversation before a phone call: result band, foundation, route complexity, warranty, and retest."
            : loudounCostSearchCounty
            ? "Loudoun demand is both ZIP-cost and testing driven. Keep the page focused on the local range, the official county signal, and the quote or seller-credit decision."
            : stLouisCostDemandCounty
            ? "St. Louis users need Missouri evidence and pricing context together; the page should move them from a real reading to scope questions before the contractor call."
            : "This page is in a search-demand lane, so it should convert curiosity into a local result band, a cost range, and a quote comparison step.";
    final boolean minnesotaOfficialCostCounty = "minnesota".equals(county.getStateSlug());
    final boolean indianaOfficialCostCounty = "indiana".equals(county.getStateSlug());
    final boolean officialStateCostCounty = minnesotaOfficialCostCounty || indianaOfficialCostCounty;
    final String officialStateCostRange = minnesotaOfficialCostCounty
            ? "$1,500-$3,000"
            : indianaOfficialCostCounty
            ? "$800-$1,200"
            : "";
    final String officialStateCostSource = minnesotaOfficialCostCounty
            ? "Minnesota Department of Health"
            : indianaOfficialCostCounty
            ? "Indiana Department of Health radon fact sheet"
            : "";
    final String officialStateCostUrl = minnesotaOfficialCostCounty
            ? "https://www.health.state.mn.us/communities/environment/air/radon/mitigationsystem.html"
            : indianaOfficialCostCounty
            ? "https://www.in.gov/health/files/RADON_FACT_SHEET_12-20-17_-_Indiana_focusedrevisedbyIB.pdf"
            : "";
    final String caRadonProgramUrl = "https://www.cdph.ca.gov/Programs/CEH/DRSEM/Pages/EMB/Radon.aspx";
    final String caCertifiedProviderUrl = "https://www.cdph.ca.gov/Programs/CEH/DRSEM/Pages/EMB/Radon/Certified-Radon-Services-Providers.aspx";
    final String boulderMitigationUrl = "https://bouldercounty.gov/environment/healthy-home/radon/mitigation/";
    final String boulderTestingUrl = "https://bouldercounty.gov/environment/healthy-home/radon/testing/";
    final String missouriTestingUrl = "https://health.mo.gov/living/environment/radon/testing.php";
    final String missouriMitigationUrl = "https://health.mo.gov/living/environment/radon/mitigation.php";
}

@template.layout.main(
    title = seoTitle,
    description = seoDescription,
    canonicalUrl = canonicalUrl,
    noindex = !page.isIndexable(),
    headContent = @`
        <script type="application/ld+json">
            {
                "@context": "https://schema.org",
                "@type": "FAQPage",
                "mainEntity": [
                    @for(int i = 0; i < page.getFaqs().size(); i++)
                    {
                        "@type": "Question",
                        "name": $unsafe{JsonLdUtils.json(page.getFaqs().get(i).getQuestion())},
                        "acceptedAnswer": {
                            "@type": "Answer",
                            "text": $unsafe{JsonLdUtils.json(page.getFaqs().get(i).getAnswer())}
                        }
                    }
                    @if(i < page.getFaqs().size() - 1),@endif
                    @endfor
                ]
            }
        </script>
        <script type="application/ld+json">
            {
                "@context": "https://schema.org",
                "@type": "WebPage",
                "name": $unsafe{JsonLdUtils.json(seoTitle)},
                "url": $unsafe{JsonLdUtils.json(canonicalUrl != null ? canonicalUrl : "https://radonverdict.com/radon-mitigation-cost/" + county.getStateSlug() + "/" + county.getCountySlug())},
                "description": $unsafe{JsonLdUtils.json(seoDescription)}
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
                    "name": $unsafe{JsonLdUtils.json(county.getStateAbbr())},
                    "item": $unsafe{JsonLdUtils.json("https://radonverdict.com/radon-mitigation-cost/" + county.getStateSlug())}
                },{
                    "@type": "ListItem",
                    "position": 3,
                    "name": $unsafe{JsonLdUtils.json(county.getSeoDisplayName())},
                    "item": $unsafe{JsonLdUtils.json("https://radonverdict.com/radon-mitigation-cost/" + county.getStateSlug() + "/" + county.getCountySlug())}
                }]
            }
        </script>
    `,
    content = @`
        <div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-10 pb-36 lg:pb-10">
            
            <!-- Breadcrumbs -->
            <nav class="text-sm font-medium text-slate-500 mb-8" aria-label="Breadcrumb">
                <ol class="inline-flex items-center space-x-2">
                    <li><a href="/" class="hover:text-slate-900 transition-colors">Home</a></li>
                    <li><span class="mx-1 text-slate-300">/</span></li>
                    <li><a href="/radon-mitigation-cost/${county.getStateSlug()}" class="hover:text-slate-900 transition-colors uppercase">${county.getStateAbbr()}</a></li>
                    <li><span class="mx-1 text-slate-300">/</span></li>
                    <li class="text-slate-900 font-semibold" aria-current="page">${county.getAreaDisplayName()}</li>
                </ol>
            </nav>

            <!-- 1. Above the Fold: Hero Section -->
            @template.components.hero_section(page = page)
            @template.components.negotiation_snapshot(county = county, page = page)
            @template.components.radon_result_translator(
                county = county,
                page = page,
                countySignalSummary = "Use this as the local decision console: set the reading, deal side, and foundation clue before you compare quotes or seller-credit numbers."
            )
            @template.components.search_intent_router(county = county, className = "mt-8")

            @if(searchDemandCostBridgeCounty)
            <section class="mt-8 rounded-3xl border border-indigo-200 bg-indigo-50 p-5 sm:p-7">
                <div class="grid gap-5 lg:grid-cols-[0.78fr_1.22fr] lg:items-start">
                    <div>
                        <p class="text-xs font-bold uppercase tracking-[0.18em] text-indigo-700">Search demand cost bridge</p>
                        <h2 class="mt-2 font-display text-2xl font-black tracking-tight text-slate-950">
                            Came from ${searchDemandQueryCluster}?
                        </h2>
                        <p class="mt-3 text-sm leading-relaxed text-indigo-950">
                            ${searchDemandCostBridgeBody}
                        </p>
                    </div>
                    <div class="divide-y divide-indigo-100 overflow-hidden rounded-2xl border border-indigo-200 bg-white">
                        <a href="/radon-levels/${county.getStateSlug()}/${county.getCountySlug()}"
                           data-track-event="cost_demand_bridge_click"
                           data-track-label="levels_evidence"
                           class="grid gap-2 p-4 transition-colors hover:bg-indigo-50 sm:grid-cols-[0.26fr_0.74fr]">
                            <span class="text-xs font-black uppercase tracking-wider text-indigo-700">No result?</span>
                            <span>
                                <span class="block text-sm font-black text-slate-950">Check the county testing and levels page first</span>
                                <span class="mt-1 block text-sm leading-relaxed text-slate-600">Use this if the search started as testing, map, service, or provider research instead of a confirmed 4.0+ result.</span>
                            </span>
                        </a>
                        <a href="#estimate-form"
                           data-track-event="cost_demand_bridge_click"
                           data-track-label="estimate_form"
                           class="grid gap-2 p-4 transition-colors hover:bg-indigo-50 sm:grid-cols-[0.26fr_0.74fr]">
                            <span class="text-xs font-black uppercase tracking-wider text-red-700">4.0+</span>
                            <span>
                                <span class="block text-sm font-black text-slate-950">Turn the reading into a local budget</span>
                                <span class="mt-1 block text-sm leading-relaxed text-slate-600">Change foundation, role, and result band before you compare any contractor number.</span>
                            </span>
                        </a>
                        <a href="/radon-quote-ledger#quote-checker"
                           data-track-event="cost_demand_bridge_click"
                           data-track-label="quote_ledger"
                           class="grid gap-2 p-4 transition-colors hover:bg-indigo-50 sm:grid-cols-[0.26fr_0.74fr]">
                            <span class="text-xs font-black uppercase tracking-wider text-slate-700">Quote</span>
                            <span>
                                <span class="block text-sm font-black text-slate-950">Screen the quote before you trust it</span>
                                <span class="mt-1 block text-sm leading-relaxed text-slate-600">Check fan, route, sump or crawl-space sealing, permit, warranty, and post-mitigation retest language.</span>
                            </span>
                        </a>
                    </div>
                </div>
            </section>
            @endif

            @if(losAngelesCommercialCostDemandCounty)
                <section class="mt-8 rounded-3xl border border-cyan-200 bg-cyan-50 p-5 sm:p-7">
                    <div class="grid gap-5 lg:grid-cols-[0.78fr_1.22fr] lg:items-start">
                        <div>
                            <p class="text-xs font-bold uppercase tracking-[0.18em] text-cyan-700">Commercial radon quote screen</p>
                            <h2 class="mt-2 font-display text-2xl font-black tracking-tight text-slate-950">
                                Los Angeles commercial quotes need protocol first, price second.
                            </h2>
                            <p class="mt-3 text-sm leading-relaxed text-cyan-950">
                                A commercial or multifamily quote should name the building type, test coverage, occupied lower levels, access constraints, mitigation method, fan/electrical scope, and post-mitigation retest. If the quote only gives a residential average, it is not enough for this search.
                            </p>
                            <div class="mt-4 flex flex-col gap-2 sm:flex-row">
                                <a href="${caRadonProgramUrl}" target="_blank" rel="noopener" class="inline-flex items-center justify-center rounded-xl border border-cyan-300 bg-white px-4 py-3 text-xs font-black uppercase tracking-wider text-cyan-800 hover:bg-cyan-100">CDPH radon rules</a>
                                <a href="${caCertifiedProviderUrl}" target="_blank" rel="noopener" class="inline-flex items-center justify-center rounded-xl border border-cyan-300 bg-white px-4 py-3 text-xs font-black uppercase tracking-wider text-cyan-800 hover:bg-cyan-100">Verify CA provider</a>
                            </div>
                        </div>
                        <div class="grid gap-3 sm:grid-cols-2">
                            <div class="rounded-2xl border border-cyan-200 bg-white p-4">
                                <p class="text-xs font-black uppercase tracking-wider text-cyan-700">Testing deliverable</p>
                                <p class="mt-2 text-sm leading-relaxed text-slate-700">Ask whether the scope is owner screening, transaction documentation, multifamily protocol testing, or post-mitigation clearance.</p>
                            </div>
                            <div class="rounded-2xl border border-cyan-200 bg-white p-4">
                                <p class="text-xs font-black uppercase tracking-wider text-cyan-700">Mitigation deliverable</p>
                                <p class="mt-2 text-sm leading-relaxed text-slate-700">Separate design, installation, electrical, roofline, tenant access, sealing, and retest costs before comparing totals.</p>
                            </div>
                        </div>
                    </div>
                </section>
            @endif

            @if(boulderCostDemandCounty)
                <section class="mt-8 rounded-3xl border border-emerald-200 bg-emerald-50 p-5 sm:p-7">
                    <div class="grid gap-5 lg:grid-cols-[0.82fr_1.18fr] lg:items-start">
                        <div>
                            <p class="text-xs font-bold uppercase tracking-[0.18em] text-emerald-700">Boulder official calibration</p>
                            <h2 class="mt-2 font-display text-2xl font-black tracking-tight text-slate-950">
                                Compare the quote against Boulder County guidance.
                            </h2>
                            <p class="mt-3 text-sm leading-relaxed text-emerald-950">
                                Boulder County publishes local testing and mitigation resources. Use the RadonVerdict range as a planning anchor, then check the official Boulder pages when a quote looks unusually high, unusually low, or vague about retesting.
                            </p>
                        </div>
                        <div class="grid gap-3 sm:grid-cols-2">
                            <a href="${boulderTestingUrl}" target="_blank" rel="noopener" class="rounded-2xl border border-emerald-200 bg-white p-4 hover:bg-emerald-100 transition-colors">
                                <p class="text-xs font-black uppercase tracking-wider text-emerald-700">Testing first</p>
                                <p class="mt-2 text-sm leading-relaxed text-slate-700">Open Boulder County testing instructions and local kit guidance.</p>
                            </a>
                            <a href="${boulderMitigationUrl}" target="_blank" rel="noopener" class="rounded-2xl border border-emerald-200 bg-white p-4 hover:bg-emerald-100 transition-colors">
                                <p class="text-xs font-black uppercase tracking-wider text-emerald-700">Mitigation check</p>
                                <p class="mt-2 text-sm leading-relaxed text-slate-700">Use Boulder County mitigation context before accepting the contractor's scope.</p>
                            </a>
                        </div>
                    </div>
                </section>
            @endif

            @if(stLouisCostDemandCounty)
                <section class="mt-8 rounded-3xl border border-amber-200 bg-amber-50 p-5 sm:p-7">
                    <div class="grid gap-5 lg:grid-cols-[0.78fr_1.22fr] lg:items-start">
                        <div>
                            <p class="text-xs font-bold uppercase tracking-[0.18em] text-amber-700">St. Louis route check</p>
                            <h2 class="mt-2 font-display text-2xl font-black tracking-tight text-slate-950">
                                Confirm County vs City before pricing a St. Louis quote.
                            </h2>
                            <p class="mt-3 text-sm leading-relaxed text-amber-950">
                                St. Louis search intent is ambiguous. Use this page for St. Louis County; use the city page for the independent city boundary. Then check Missouri testing and mitigation guidance before comparing bids.
                            </p>
                        </div>
                        <div class="grid gap-3 sm:grid-cols-2">
                            <a href="/radon-levels/missouri/st-louis-city" class="rounded-2xl border border-amber-200 bg-white p-4 hover:bg-amber-100 transition-colors">
                                <p class="text-xs font-black uppercase tracking-wider text-amber-700">City page</p>
                                <p class="mt-2 text-sm leading-relaxed text-slate-700">Open St. Louis City if the property is inside the independent city.</p>
                            </a>
                            <a href="${missouriTestingUrl}" target="_blank" rel="noopener" class="rounded-2xl border border-amber-200 bg-white p-4 hover:bg-amber-100 transition-colors">
                                <p class="text-xs font-black uppercase tracking-wider text-amber-700">DHSS testing</p>
                                <p class="mt-2 text-sm leading-relaxed text-slate-700">Use Missouri DHSS testing guidance when there is no valid result yet.</p>
                            </a>
                            <a href="${missouriMitigationUrl}" target="_blank" rel="noopener" class="rounded-2xl border border-amber-200 bg-white p-4 hover:bg-amber-100 transition-colors sm:col-span-2">
                                <p class="text-xs font-black uppercase tracking-wider text-amber-700">DHSS mitigation</p>
                                <p class="mt-2 text-sm leading-relaxed text-slate-700">Ask more than one contractor for estimates and compare scope, references, warranty, and retest language.</p>
                            </a>
                        </div>
                    </div>
                </section>
            @endif

            @if(officialStateCostCounty)
                <section class="mt-8 rounded-3xl border border-sky-200 bg-sky-50 p-5 sm:p-7">
                    <div class="grid gap-5 lg:grid-cols-[0.82fr_1.18fr] lg:items-start">
                        <div>
                            <p class="text-xs font-bold uppercase tracking-[0.18em] text-sky-700">Official state cost anchor</p>
                            <h2 class="mt-2 font-display text-2xl font-black tracking-tight text-slate-950">
                                Compare ${county.getAreaDisplayName()} against ${officialStateCostSource}.
                            </h2>
                            <p class="mt-3 text-sm leading-relaxed text-sky-950">
                                The county model is built for quote screening, but state guidance gives a useful public anchor. Use both before assuming a bid is fair.
                            </p>
                        </div>
                        <div class="grid gap-3 sm:grid-cols-3">
                            <div class="rounded-2xl border border-sky-200 bg-white p-4">
                                <p class="text-xs font-black uppercase tracking-wider text-sky-700">Official range</p>
                                <p class="mt-2 font-display text-3xl font-black text-slate-950">${officialStateCostRange}</p>
                            </div>
                            <div class="rounded-2xl border border-sky-200 bg-white p-4">
                                <p class="text-xs font-black uppercase tracking-wider text-sky-700">County model</p>
                                <p class="mt-2 font-display text-3xl font-black text-slate-950">$${page.getReceipt().getTotalLow()}-$${page.getReceipt().getTotalHigh()}</p>
                            </div>
                            <a href="${officialStateCostUrl}" target="_blank" rel="noopener" class="rounded-2xl border border-sky-200 bg-white p-4 hover:bg-sky-100 transition-colors">
                                <p class="text-xs font-black uppercase tracking-wider text-sky-700">Source</p>
                                <p class="mt-2 text-sm font-semibold leading-relaxed text-slate-800">Open the official state cost guidance.</p>
                            </a>
                        </div>
                    </div>
                </section>
            @endif

            @if(hasCountyZipCodes)
            <section class="mt-8 rounded-3xl border border-slate-200 bg-slate-50 p-5 sm:p-7">
                <div class="grid gap-5 lg:grid-cols-[minmax(0,1fr)_auto] lg:items-center">
                    <div>
                        <p class="text-xs font-bold uppercase tracking-[0.18em] text-slate-500">ZIP cost search</p>
                        <h2 class="mt-2 font-display text-2xl font-black tracking-tight text-slate-900">
                            Searching by ZIP? Use the ${county.getAreaDisplayName()} range first.
                        </h2>
                        <p class="mt-3 text-sm leading-relaxed text-slate-600">
                            @if(loudounCostSearchCounty)
                                If you searched for <strong>20147 radon mitigation cost</strong>, this is the matching county page: ZIP 20147 maps to Loudoun County, VA. Start with the range above, then adjust the form for your foundation type and actual radon result.
                            @else
                                ZIP-level contractor quotes still depend on the property, but the county range is the cleanest first budget anchor before you request bids or negotiate a credit.
                            @endif
                        </p>
                    </div>
                    <div class="rounded-2xl border border-slate-200 bg-white p-4 lg:min-w-[260px]">
                        <p class="text-[11px] font-bold uppercase tracking-widest text-slate-500">ZIP anchors on this page</p>
                        <p class="mt-2 text-sm font-black leading-relaxed text-slate-900">${countyZipDisplay}</p>
                    </div>
                </div>
            </section>
            @endif

            @template.components.quote_coach(county = county, page = page, defaultZip = primaryCountyZip)

            <section class="mt-8 rounded-3xl border border-cyan-200 bg-cyan-50 p-5 sm:p-7">
                <div class="grid gap-5 lg:grid-cols-[1fr_0.5fr] lg:items-center">
                    <div>
                        <p class="text-xs font-bold uppercase tracking-wider text-cyan-700">Observed quote layer</p>
                        <h2 class="mt-2 font-display text-2xl font-black tracking-tight text-slate-950">Already have a ${county.getAreaDisplayName()} quote?</h2>
                        <p class="mt-2 text-sm leading-relaxed text-slate-700">
                            Add one anonymized quote, paid install, or seller-credit number. It helps compare the model range against real local pricing without exposing a street address.
                        </p>
                    </div>
                    <a href="/radon-quote-ledger#quote-checker"
                       data-track-event="quote_ledger_cta_click"
                       data-track-label="county_cost_page"
                       class="inline-flex min-h-[52px] items-center justify-center rounded-xl bg-slate-950 px-5 text-sm font-black text-white transition-colors hover:bg-slate-800">
                        Check my quote
                    </a>
                </div>
            </section>

            <!-- 2. Grid Layout for Simulator and Receipt -->
            <div class="grid grid-cols-1 lg:grid-cols-12 gap-10 mt-16 mb-20">
                
                <!-- Left Column (Simulator + Details) -->
                <div class="lg:col-span-5 order-1">
                    @template.components.simulator_form(county = county, page = page)
                    @template.components.radon_level_advisor(county = county, costMode = true, selectedResultBand = page.getSelectedRadonResultBand())
                    
                    <!-- Foundation Context (Updates dynamically if we made this HTMX too, but for now static default) -->
                    <div class="bg-white rounded-2xl p-6 border border-slate-200 mt-6 shadow-sm">
                        <h4 class="font-display font-bold text-slate-900 mb-2">${page.getFoundationLabel()} Factors</h4>
                        <p class="text-sm text-slate-600 leading-relaxed mb-4">${page.getFoundationCostContext()}</p>
                        <p class="text-xs font-semibold text-amber-600 tracking-wide uppercase">Negotiation Note</p>
                        <p class="text-sm text-slate-600 leading-relaxed mt-1">${page.getFoundationNegotiationNote()}</p>
                    </div>

                    <!-- State Regulation Banner -->
                    <div class="mt-6 rounded-2xl border p-6 flex gap-4 
                        @if(page.isDisclosureRequired()) bg-amber-50 border-amber-200 @else bg-slate-50 border-slate-200 @endif
                    ">
                        <svg class="w-8 h-8 shrink-0 
                            @if(page.isDisclosureRequired()) text-amber-500 @else text-slate-400 @endif" 
                            fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                        </svg>
                        <div>
                            <h4 class="font-bold text-sm mb-1 
                                @if(page.isDisclosureRequired()) text-amber-900 @else text-slate-700 @endif
                            ">State Regulation Notice</h4>
                            <p class="text-sm leading-relaxed mb-3
                                @if(page.isDisclosureRequired()) text-amber-800 @else text-slate-600 @endif
                            ">${page.getDisclosureSummary()}</p>
                            
                            <a href="${page.getStateProgramUrl()}" target="_blank" rel="noopener nofollow" class="inline-flex items-center text-xs font-bold uppercase tracking-wider 
                                @if(page.isDisclosureRequired()) text-amber-700 hover:text-amber-900 @else text-slate-500 hover:text-slate-700 @endif transition-colors">
                                View official state site 
                                <svg class="w-3 h-3 ml-1" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" /></svg>
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Right Column (The Live Receipt & Strategy) -->
                <div class="lg:col-span-7 order-2">
                    <div class="sticky top-24">
                        <div id="receipt-container" class="transition-opacity duration-200">
                            <!-- Included via JTE fragment so it matches the HTMX return exactly -->
                            @template.fragments.receipt(page = page)
                        </div>
                    </div>
                </div>
            </div>

            <!-- Lead Capture CTA (Injected) -->
            @template.components.lead_form(county = county, page = page, successMessage = leadSuccessMessage, errorMessage = leadErrorMessage, prefilledZip = prefilledZip)
            @if(monetizationHooksEnabled)
                @template.components.monetization_hooks(countyName = county.getCountyName(), stateAbbr = county.getStateAbbr())
            @endif
            @if(aeo != null)
                @template.components.aeo_answer_block(block = aeo)
            @endif
            @template.components.quick_trust_summary(county = county, page = page, trust = trust)
            @template.components.why_price_breakdown(page = page)
            @template.components.cost_benchmark_compare(county = county, page = page, quoteBenchmark = quoteBenchmark)
            @template.components.decision_worksheet_cta(county = county, page = page)

            <!-- Local housing context -->
            @if(county.getStats() != null && county.getStats().getMetrics() != null && county.getStats().getMetrics().getTotalHousingUnits() > 0)
            <div class="border-t border-slate-200 mt-20 pt-16 mb-10">
                <h3 class="font-display font-bold text-2xl text-slate-900 mb-6">${county.getAreaDisplayName()} Housing Statistics</h3>
                <p class="text-slate-600 mb-6">Housing characteristics like age and foundation type can heavily influence radon risks and mitigation costs. Here is a snapshot of ${county.getAreaDisplayName()} real estate data.</p>
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                    <div class="bg-indigo-50 border border-indigo-100 rounded-2xl p-6 shadow-sm">
                        <span class="block text-indigo-900 text-sm font-semibold uppercase tracking-wider mb-2">Total Housing Units</span>
                        <span class="block text-3xl font-display font-bold text-indigo-700">${String.format("%,d", county.getStats().getMetrics().getTotalHousingUnits())}</span>
                    </div>
                    <div class="bg-emerald-50 border border-emerald-100 rounded-2xl p-6 shadow-sm">
                        <span class="block text-emerald-900 text-sm font-semibold uppercase tracking-wider mb-2">Built Before 1980</span>
                        <span class="block text-3xl font-display font-bold text-emerald-700">${county.getStats().getMetrics().getBuiltBefore1980Pct()}%</span>
                        <p class="text-xs text-emerald-800 mt-2">Older homes often require different sub-slab depressurization techniques.</p>
                    </div>
                    <div class="bg-amber-50 border border-amber-100 rounded-2xl p-6 shadow-sm">
                        <span class="block text-amber-900 text-sm font-semibold uppercase tracking-wider mb-2">Median Home Value</span>
                        <span class="block text-3xl font-display font-bold text-amber-700">$${String.format("%,d", county.getStats().getMetrics().getMedianHomeValue())}</span>
                    </div>
                </div>
                <div class="mt-4 flex items-center gap-2 text-xs text-slate-500">
                    <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
                    <span>Source: US Census Bureau, American Community Survey (Data retrieved ${county.getStats().getRetrievedAt()})</span>
                </div>
                
                <!-- Local radon insight synthesis -->
                <div class="mt-8 bg-indigo-50/50 border border-indigo-100 rounded-2xl p-6 sm:p-8 flex items-start gap-4">
                    <div class="flex-shrink-0 w-12 h-12 bg-indigo-100 text-indigo-600 rounded-full flex items-center justify-center">
                        <svg class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
                    </div>
                    <div>
                        <h4 class="font-display font-bold text-lg text-indigo-900 mb-2">Local Insight: ${county.getAreaDisplayName()}</h4>
                        <ul class="space-y-3 text-sm text-indigo-800 leading-relaxed font-medium">
                            @if(page.getLocalInsights() != null && !page.getLocalInsights().isEmpty())
                                @for(var insight : page.getLocalInsights())
                                    <li class="relative pl-5 before:content-['*'] before:absolute before:left-0 before:text-indigo-500">${insight}</li>
                                @endfor
                            @endif
                        </ul>
                    </div>
                </div>

            </div>
            @endif

            <!-- 3. Dynamic FAQs -->
            <div class="max-w-3xl border-t border-slate-200 mt-20 pt-16">
                @template.components.faq_accordion(page = page)
            </div>

            @template.components.related_links(
                title = "Related Radon Resources for " + county.getAreaDisplayName(),
                links = relatedLinks
            )

            <!-- Cross-Silo: Radon Level Data & Guides -->
            <div class="border-t border-slate-200 mt-20 pt-12 mb-10">
                <h3 class="font-display font-bold text-lg text-slate-900 mb-4">More About Radon in ${county.getAreaDisplayName()}</h3>
                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <a href="/radon-levels/${county.getStateSlug()}/${county.getCountySlug()}"
                       class="flex items-center gap-3 p-4 rounded-xl border border-slate-200 bg-white hover:border-indigo-300 hover:shadow-md transition-all group">
                        <div class="w-10 h-10 rounded-lg bg-indigo-50 text-indigo-600 flex items-center justify-center shrink-0">
                            <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" /></svg>
                        </div>
                        <div>
                            <span class="block font-bold text-sm text-slate-800 group-hover:text-indigo-600 transition-colors">${county.getAreaDisplayName()} Radon Levels</span>
                            <span class="text-xs text-slate-500">EPA zone data, health risks, and testing guidance</span>
                        </div>
                    </a>
                    <a href="/guides/how-to-test-for-radon"
                       class="flex items-center gap-3 p-4 rounded-xl border border-slate-200 bg-white hover:border-indigo-300 hover:shadow-md transition-all group">
                        <div class="w-10 h-10 rounded-lg bg-emerald-50 text-emerald-600 flex items-center justify-center shrink-0">
                            <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" /></svg>
                        </div>
                        <div>
                            <span class="block font-bold text-sm text-slate-800 group-hover:text-indigo-600 transition-colors">How to Test for Radon</span>
                            <span class="text-xs text-slate-500">Complete testing guide - kits, placement, results</span>
                        </div>
                    </a>
                </div>
            </div>

            <!-- 4. SEO Silo: Nearby Counties -->
            @if(page.getNearbyCounties() != null && !page.getNearbyCounties().isEmpty())
            <div class="border-t border-slate-200 mt-20 pt-16 mb-10">
                <h3 class="font-display font-bold text-2xl text-slate-900 mb-6">Explore Radon Mitigation Costs in Nearby ${county.getStateAbbr()} Counties</h3>
                <div class="grid grid-cols-2 md:grid-cols-3 gap-4">
                    @for(var nearby : page.getNearbyCounties())
                        <a href="/radon-mitigation-cost/${nearby.getStateSlug()}/${nearby.getCountySlug()}" 
                           class="block p-4 rounded-xl border border-slate-200 bg-white hover:border-indigo-300 hover:shadow-md transition-all group">
                            <span class="block font-bold text-slate-800 group-hover:text-indigo-600 transition-colors">${nearby.getAreaDisplayName()}</span>
                            <span class="text-xs text-slate-500 mt-1">Zone ${nearby.getEpaZone()}</span>
                        </a>
                    @endfor
                </div>
            </div>
            @endif

            @template.components.state_radon_resources(
                stateName = stateName,
                stateAbbr = county.getStateAbbr(),
                stateProgramUrl = page.getStateProgramUrl(),
                disclosureRequired = page.isDisclosureRequired(),
                disclosureSummary = page.getDisclosureSummary(),
                licenseRequired = page.isLicenseRequired(),
                licenseNote = page.getLicenseNote(),
                className = "mt-20 mb-10"
            )

            <!-- 5. Sources & Methodology / YMYL Disclaimers -->
            <div class="border-t border-slate-200 mt-20 pt-16 mb-10 text-sm text-slate-500">
                <h3 class="font-display font-bold text-xl text-slate-900 mb-4">Sources & Methodology</h3>
                <p class="mb-6">The radon mitigation cost estimates presented on this page are dynamically calculated using baseline national material averages combined with localized labor multipliers for ${county.getAreaDisplayName()}. </p>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                    <div>
                        <h4 class="font-bold text-slate-700 mb-2">Important Disclaimers</h4>
                        <ul class="space-y-3 pl-4">
                            <li class="relative before:content-['*'] before:absolute before:-left-4 before:text-slate-300"><strong class="text-slate-700">Health & Safety:</strong> Information on this site is for educational purposes and is not medical advice. For health concerns, consult qualified professionals.</li>
                            <li class="relative before:content-['*'] before:absolute before:-left-4 before:text-slate-300"><strong class="text-slate-700">Estimates:</strong> Estimates are general ranges based on typical projects. Actual quotes vary by home conditions and local labor.</li>
                            <li class="relative before:content-['*'] before:absolute before:-left-4 before:text-slate-300"><strong class="text-slate-700">Zone Data:</strong> Radon zone classifications describe regional potential for elevated indoor radon. They do not predict the radon level in a specific home. Testing is recommended for all homes.</li>
                        </ul>
                    </div>
                    <div>
                        <h4 class="font-bold text-slate-700 mb-2">Data Sources</h4>
                        <ul class="space-y-3 pl-4">
                            <li class="relative before:content-['*'] before:absolute before:-left-4 before:text-slate-300"><a href="https://www.epa.gov/radon" target="_blank" rel="nofollow noopener" class="text-indigo-600 hover:text-indigo-800 hover:underline transition-colors">US Environmental Protection Agency (EPA) - Action Level</a></li>
                            <li class="relative before:content-['*'] before:absolute before:-left-4 before:text-slate-300"><a href="https://www.epa.gov/radon/epa-map-radon-zones" target="_blank" rel="nofollow noopener" class="text-indigo-600 hover:text-indigo-800 hover:underline transition-colors">EPA Map of Radon Zones</a></li>
                            <li class="relative before:content-['*'] before:absolute before:-left-4 before:text-slate-300">National contractor cost guides and local labor indices.</li>
                        </ul>
                    </div>
                </div>
                <p class="mt-8 text-xs text-slate-400 font-medium">Content review: ${trust != null && trust.getLastReviewed() != null && !trust.getLastReviewed().isBlank() ? trust.getLastReviewed() : "Source-level retrieval dates"}</p>
            </div>
            @if(trust != null)
                @template.components.trust_metadata(trust = trust, quality = quality, showDebug = showSeoDebug)
            @endif
            
        </div>
    `
)

