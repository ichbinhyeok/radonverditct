@import com.radonverdict.model.County
@import com.radonverdict.model.StateRegulations.StateRule
@import com.radonverdict.model.dto.AeoAnswerBlock
@import com.radonverdict.model.dto.InternalLinkItem
@import com.radonverdict.model.dto.PageQualityResult
@import com.radonverdict.model.dto.TrustMetadata
@import java.util.List

@param County county
@param StateRule stateRule = null
@param List<County> nearbyCounties = null
@param String canonicalUrl = null
@param boolean noindex = false
@param AeoAnswerBlock aeo = null
@param List<InternalLinkItem> relatedLinks = null
@param PageQualityResult quality = null
@param TrustMetadata trust = null
@param boolean monetizationHooksEnabled = false

@template.layout.main(
    title = "Radon Levels in " + county.getCountyName() + " County, " + county.getStateAbbr() + " — " + java.time.LocalDate.now().getYear() + " EPA Data",
    description = "Current radon levels and EPA zone data for " + county.getCountyName() + " County, " + county.getStateAbbr() + ". Understand your risk, learn testing options, and see what action to take based on your reading.",
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
                        "name": "What is the average radon level in ${county.getCountyName()} County, ${county.getStateAbbr()}?",
                        "acceptedAnswer": {
                            "@type": "Answer",
                            "text": "${county.getCountyName()} County is classified as @if(county.getEpaZone() == 1)EPA Zone 1 (High Risk). The predicted average indoor radon screening level exceeds 4.0 pCi/L, which is above the EPA action level.@elseif(county.getEpaZone() == 2)EPA Zone 2 (Moderate Risk). The predicted average indoor screening level is between 2.0 and 4.0 pCi/L.@elseif(county.getEpaZone() == 3)EPA Zone 3 (Low Risk). The predicted average indoor screening level is below 2.0 pCi/L.@else an unclassified EPA zone (Data Pending). The EPA zone for this county is currently unclassified in our source data. Please rely on direct home testing to determine risk.@endif The EPA recommends testing all homes regardless of zone."
                        }
                    },
                    {
                        "@type": "Question",
                        "name": "Is radon a problem in ${county.getCountyName()} County?",
                        "acceptedAnswer": {
                            "@type": "Answer",
                            "text": "@if(county.getEpaZone() == 1)Yes, ${county.getCountyName()} County is in EPA Zone 1 (High Risk). Most homes should be tested and many will need mitigation.@elseif(county.getEpaZone() == 2)${county.getCountyName()} County is in EPA Zone 2 (Moderate Risk). Many individual homes can still have elevated levels above the EPA action threshold.@elseif(county.getEpaZone() == 3)${county.getCountyName()} County is in EPA Zone 3 (Low Risk), but elevated radon has been found in homes in every zone. Testing is always recommended.@else ${county.getCountyName()} County does not currently have a published EPA zone assignment in our dataset. Because radon risk can vary significantly by home, testing is strongly recommended.@endif"
                        }
                    },
                    {
                        "@type": "Question",
                        "name": "How do I test for radon in ${county.getCountyName()} County?",
                        "acceptedAnswer": {
                            "@type": "Answer",
                            "text": "Purchase a short-term radon test kit ($15–$30) from a hardware store or online. Place it in the lowest livable level of your home for 2–7 days with closed-house conditions, then mail it to the lab. For continuous monitoring, consider a digital radon detector ($150–$200)."
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
                    "name": "${county.getStateAbbr()} Radon Levels",
                    "item": "https://radonverdict.com/radon-levels/${county.getStateSlug()}"
                },{
                    "@type": "ListItem",
                    "position": 3,
                    "name": "${county.getCountyName()} County",
                    "item": "https://radonverdict.com/radon-levels/${county.getStateSlug()}/${county.getCountySlug()}"
                }]
            }
        </script>
    `,
    content = @`
        <div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-10">

            <!-- Breadcrumb -->
            <nav class="text-sm font-medium text-slate-500 mb-8" aria-label="Breadcrumb">
                <ol class="inline-flex items-center space-x-2">
                    <li><a href="/" class="hover:text-slate-900 transition-colors">Home</a></li>
                    <li><span class="mx-1 text-slate-300">/</span></li>
                    <li><a href="/radon-levels/${county.getStateSlug()}" class="hover:text-slate-900 transition-colors uppercase">${county.getStateAbbr()}</a></li>
                    <li><span class="mx-1 text-slate-300">/</span></li>
                    <li class="text-slate-900 font-semibold" aria-current="page">${county.getCountyName()} County</li>
                </ol>
            </nav>

            <!-- Hero Section -->
            <div class="rounded-3xl bg-gradient-to-br from-slate-900 via-slate-800 to-slate-900 p-8 sm:p-12 mb-12 relative overflow-hidden">
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
                        EPA Zone ${county.getEpaZone() > 0 ? Integer.toString(county.getEpaZone()) : "Unclassified"} —
                        @if(county.getEpaZone() == 1) High Risk
                        @elseif(county.getEpaZone() == 2) Moderate Risk
                        @elseif(county.getEpaZone() == 3) Low Risk
                        @else Data Pending
                        @endif
                    </div>

                    <h1 class="font-display font-black text-3xl sm:text-4xl md:text-5xl text-white leading-tight mb-6">
                        Radon Levels in<br>${county.getCountyName()} County, ${county.getStateAbbr()}
                    </h1>

                    <p class="text-lg text-slate-300 leading-relaxed max-w-3xl" itemscope itemtype="https://schema.org/Answer" itemprop="text">
                        <strong class="text-white">Direct Answer:</strong> 
                        @if(county.getEpaZone() == 1)
                            ${county.getCountyName()} County is classified as <strong class="text-white">EPA Zone 1 (High Risk)</strong>.
                            The predicted average indoor radon screening level exceeds 4.0 pCi/L — the EPA's recommended action threshold.
                            <strong class="text-red-300">Testing is strongly recommended for every home in this county.</strong>
                        @elseif(county.getEpaZone() == 2)
                            ${county.getCountyName()} County is classified as <strong class="text-white">EPA Zone 2 (Moderate Risk)</strong>.
                            Predicted average indoor screening levels fall between 2.0 and 4.0 pCi/L.
                            While below the EPA action level, many individual homes still test above 4.0 due to local soil conditions and foundation type.
                        @elseif(county.getEpaZone() == 3)
                            ${county.getCountyName()} County is classified as <strong class="text-white">EPA Zone 3 (Low Risk)</strong>.
                            Predicted average indoor screening levels are below 2.0 pCi/L.
                            However, the EPA recommends testing all homes regardless of zone — elevated readings have been found in every state.
                        @else
                            ${county.getCountyName()} County currently has <strong class="text-white">no published EPA zone assignment</strong> in our source dataset.
                            Because zone data is unavailable for this county, the safest approach is direct home testing.
                            <strong class="text-slate-200">Use a short-term kit first, then follow up with mitigation planning if results are elevated.</strong>
                        @endif
                    </p>
                </div>
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

                    <!-- What the Numbers Mean — Educational Section -->
                    <div class="bg-white rounded-[2rem] p-6 sm:p-8 shadow-sm border border-slate-200 mt-6">
                        <h2 class="font-display font-bold text-xl text-slate-900 mb-6">Understanding Radon Levels: Complete Reference</h2>

                        <div class="space-y-4">
                            <!-- Tier 1: Below 2.0 -->
                            <div class="flex gap-4 items-start p-4 rounded-xl bg-emerald-50 border border-emerald-100">
                                <div class="w-12 h-12 rounded-xl bg-emerald-500 text-white flex items-center justify-center shrink-0 font-display font-bold text-xs px-1">
                                    &lt;2.0
                                </div>
                                <div>
                                    <h3 class="font-bold text-emerald-900 text-sm">Below 2.0 pCi/L — Acceptable Range</h3>
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
                                    2.0<br>–4.0
                                </div>
                                <div>
                                    <h3 class="font-bold text-amber-900 text-sm">2.0 – 4.0 pCi/L — Elevated, Consider Action</h3>
                                    <p class="text-xs text-amber-800 leading-relaxed mt-1">
                                        Exceeds the World Health Organization's reference level of 2.7 pCi/L but falls below the US EPA action threshold.
                                        The EPA states that homeowners should <em>"consider fixing"</em> homes in this range, especially if the home has a basement
                                        used as living space, if children are present, or in connection with a real estate transaction.
                                        Health equivalent: approximately 2–8 cigarettes per day in exposure.
                                    </p>
                                </div>
                            </div>

                            <!-- Tier 3: 4.0 - 8.0 -->
                            <div class="flex gap-4 items-start p-4 rounded-xl bg-red-50 border border-red-100">
                                <div class="w-12 h-12 rounded-xl bg-red-500 text-white flex items-center justify-center shrink-0 font-display font-bold text-xs px-1 text-center leading-tight">
                                    4.0<br>–8.0
                                </div>
                                <div>
                                    <h3 class="font-bold text-red-900 text-sm">4.0 – 8.0 pCi/L — Action Recommended</h3>
                                    <p class="text-xs text-red-800 leading-relaxed mt-1">
                                        Exceeds the EPA action level of 4.0 pCi/L. The EPA and Surgeon General strongly recommend mitigation within a few months.
                                        At 4.0 pCi/L, a person spending significant time in the home has a lung cancer risk roughly equivalent to smoking
                                        half a pack of cigarettes daily. Standard sub-slab depressurization systems typically reduce levels by 80–99%.
                                    </p>
                                </div>
                            </div>

                            <!-- Tier 4: Above 8.0 -->
                            <div class="flex gap-4 items-start p-4 rounded-xl bg-red-100 border border-red-200">
                                <div class="w-12 h-12 rounded-xl bg-red-700 text-white flex items-center justify-center shrink-0 font-display font-bold text-xs px-1">
                                    8.0+
                                </div>
                                <div>
                                    <h3 class="font-bold text-red-900 text-sm">Above 8.0 pCi/L — Urgent Action Required</h3>
                                    <p class="text-xs text-red-800 leading-relaxed mt-1">
                                        At these levels, the EPA recommends expedited mitigation — ideally within weeks, not months.
                                        Occupants should minimize time in lower-level rooms until the system is installed.
                                        At 8.0 pCi/L, the lung cancer risk is roughly equivalent to smoking a pack a day.
                                        Many mitigators offer priority scheduling for homes above 8.0 pCi/L.
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Geological Context — Zone-Specific Unique Content -->
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
                            in ${county.getCountyName()} County
                        </h2>

                        @if(county.getEpaZone() == 1)
                            <p class="text-sm text-slate-700 leading-relaxed mb-4">
                                ${county.getCountyName()} County sits in a geological region with elevated uranium concentrations in the underlying bedrock and soil.
                                As uranium naturally decays, it produces radium, which further decays into radon gas. This gas migrates upward through soil
                                and enters homes through foundation cracks, gaps around pipes, and sump pits.
                            </p>
                            <p class="text-sm text-slate-700 leading-relaxed mb-4">
                                In Zone 1 counties like ${county.getCountyName()}, the EPA predicts that the average home will have a screening level
                                above 4.0 pCi/L. However, individual homes can vary dramatically — even neighboring houses can differ by a factor of 10 or more.
                                This is why <strong>every home needs its own test</strong>, regardless of what a neighbor's reading shows.
                            </p>
                            <p class="text-sm text-slate-700 leading-relaxed">
                                Factors that amplify radon entry include: basement foundations (more soil contact area), granitic or shale bedrock,
                                tight energy-efficient construction (less natural ventilation), and negative indoor air pressure from HVAC systems,
                                exhaust fans, and dryers.
                            </p>
                        @elseif(county.getEpaZone() == 2)
                            <p class="text-sm text-slate-700 leading-relaxed mb-4">
                                ${county.getCountyName()} County falls in EPA Zone 2, where predicted average indoor screening levels
                                range between 2.0 and 4.0 pCi/L. While the county average may fall below the EPA action level,
                                geological variability means that a significant percentage of individual homes will still test above 4.0 pCi/L.
                            </p>
                            <p class="text-sm text-slate-700 leading-relaxed mb-4">
                                The soil composition in this area typically includes a mix of sedimentary formations that can contain moderate
                                uranium deposits. Homes with basement or crawlspace foundations are particularly susceptible, as they provide
                                more pathways for soil gas entry.
                            </p>
                            <p class="text-sm text-slate-700 leading-relaxed">
                                The World Health Organization recommends action at 2.7 pCi/L — well below the US EPA threshold.
                                If you have children, spend significant time in below-grade rooms, or are buying/selling a home,
                                testing is essential even in a Zone 2 area.
                            </p>
                        @elseif(county.getEpaZone() == 3)
                            <p class="text-sm text-slate-700 leading-relaxed mb-4">
                                ${county.getCountyName()} County is classified as EPA Zone 3, with predicted average indoor screening levels below 2.0 pCi/L.
                                This does <strong>not</strong> mean radon is absent — it means the statistical average is low.
                            </p>
                            <p class="text-sm text-slate-700 leading-relaxed mb-4">
                                The EPA has documented elevated radon readings in every state and in homes in every zone classification.
                                Local geological anomalies — pockets of granite, shale intrusions, or fractured bedrock — can create
                                localized high-radon areas even within an otherwise low-risk county.
                            </p>
                            <p class="text-sm text-slate-700 leading-relaxed">
                                The Surgeon General and EPA recommend testing all homes, regardless of geographic zone.
                                A simple short-term test kit ($15–$30) provides results within a few days and can give you peace of mind.
                            </p>
                        @else
                            <p class="text-sm text-slate-700 leading-relaxed mb-4">
                                ${county.getCountyName()} County currently has no published EPA zone assignment in our source dataset.
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
                            Radon is a Class A carcinogen — the same classification as asbestos and tobacco smoke.
                            The National Academy of Sciences estimates that radon causes approximately 21,000 lung cancer deaths
                            annually in the United States, making it the leading environmental cause of cancer death.
                        </p>
                        <p class="text-sm text-slate-700 leading-relaxed">
                            Unlike smoking, radon exposure is involuntary and often invisible. There is no safe level of radon —
                            risk increases linearly with exposure. The good news: radon mitigation systems are highly effective,
                            typically reducing indoor levels by 80–99% within hours of activation.
                        </p>

                        <div class="mt-6 p-4 rounded-xl bg-indigo-50 border border-indigo-100">
                            <p class="text-xs text-indigo-800 font-semibold">
                                📊 Source: US Environmental Protection Agency, "A Citizen's Guide to Radon" (EPA 402/K-12/002).
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
                                but your home could be significantly higher or lower than the county average.
                            </p>

                            <div class="space-y-3">
                                <a href="https://www.amazon.com/s?k=radon+test+kit+charcoal" target="_blank" rel="noopener nofollow"
                                   class="flex items-center justify-between w-full px-4 py-3 rounded-xl bg-slate-900 text-white hover:bg-slate-800 transition-colors group">
                                    <div>
                                        <div class="text-sm font-bold">Short-Term Test Kit</div>
                                        <div class="text-xs text-slate-400">Results in 2–7 days · $15–$30</div>
                                    </div>
                                    <svg class="w-4 h-4 text-slate-400 group-hover:translate-x-1 transition-transform" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                                        <path stroke-linecap="round" stroke-linejoin="round" d="M17.25 8.25L21 12m0 0l-3.75 3.75M21 12H3" />
                                    </svg>
                                </a>
                                <a href="https://www.amazon.com/s?k=digital+radon+detector+monitor" target="_blank" rel="noopener nofollow"
                                   class="flex items-center justify-between w-full px-4 py-3 rounded-xl bg-white border-2 border-slate-200 text-slate-900 hover:border-indigo-300 hover:shadow-md transition-all group">
                                    <div>
                                        <div class="text-sm font-bold">Digital Radon Monitor</div>
                                        <div class="text-xs text-slate-500">Continuous real-time monitoring · $150–$200</div>
                                    </div>
                                    <svg class="w-4 h-4 text-slate-400 group-hover:translate-x-1 transition-transform" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                                        <path stroke-linecap="round" stroke-linejoin="round" d="M17.25 8.25L21 12m0 0l-3.75 3.75M21 12H3" />
                                    </svg>
                                </a>
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
                                ${county.getCountyName()} County — including regional labor rates and permit requirements.
                            </p>
                            <a href="/radon-mitigation-cost/${county.getStateSlug()}/${county.getCountySlug()}"
                               class="flex items-center justify-center gap-2 w-full py-3.5 rounded-xl bg-white text-indigo-700 font-bold text-sm hover:bg-indigo-50 transition-colors shadow-sm">
                                <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
                                    <path stroke-linecap="round" stroke-linejoin="round" d="M9 7h6m0 10v-3m-3 3h.01M9 17h.01M9 14h.01M12 14h.01M15 11h.01M12 11h.01M9 11h.01M7 21h10a2 2 0 002-2V5a2 2 0 00-2-2H7a2 2 0 00-2 2v14a2 2 0 002 2z" />
                                </svg>
                                Get Mitigation Cost Estimate →
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
                                        ${stateRule.isDisclosureRequired() ? "!" : "—"}
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
                                        ${stateRule.isLicenseRequired() ? "✓" : "—"}
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
                <h2 class="font-display font-bold text-2xl text-slate-900 mb-8 text-center">How to Test for Radon in ${county.getCountyName()} County</h2>

                <div class="grid grid-cols-1 md:grid-cols-3 gap-6 max-w-4xl mx-auto">
                    <div class="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm text-center">
                        <div class="w-12 h-12 rounded-xl bg-indigo-100 text-indigo-600 flex items-center justify-center mx-auto mb-4">
                            <span class="font-display font-bold">1</span>
                        </div>
                        <h3 class="font-bold text-slate-900 mb-2">Buy a Test Kit</h3>
                        <p class="text-sm text-slate-600 leading-relaxed">
                            Purchase a short-term charcoal test kit online or from a local hardware store.
                            Cost: $15–$30. Place it in the lowest livable level of your home.
                        </p>
                    </div>
                    <div class="bg-white rounded-2xl p-6 border border-slate-200 shadow-sm text-center">
                        <div class="w-12 h-12 rounded-xl bg-indigo-100 text-indigo-600 flex items-center justify-center mx-auto mb-4">
                            <span class="font-display font-bold">2</span>
                        </div>
                        <h3 class="font-bold text-slate-900 mb-2">Wait 2–7 Days</h3>
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
                            If results are <strong>below 4.0 pCi/L</strong>, re-test every 2 years.
                            If <strong>above 4.0</strong>, use our
                            <a href="/radon-mitigation-cost/${county.getStateSlug()}/${county.getCountySlug()}"
                               class="text-indigo-600 font-semibold hover:underline">cost calculator</a>
                            to see mitigation options.
                        </p>
                    </div>
                </div>
            </div>

            @template.components.related_links(
                title = "Related Radon Resources for " + county.getCountyName() + " County",
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
                            <span class="text-xs text-slate-500 mt-1">Zone ${nearby.getEpaZone() > 0 ? Integer.toString(nearby.getEpaZone()) : "Unclassified"} ·
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
                    Radon zone classifications for ${county.getCountyName()} County are sourced from the EPA's Map of Radon Zones,
                    which uses geological surveys, indoor radon measurements, and soil permeability data to assign each county a risk tier.
                </p>
                <ul class="space-y-2 pl-4 mb-6">
                    <li class="relative before:content-['•'] before:absolute before:-left-4 before:text-slate-300">
                        <a href="https://www.epa.gov/radon/epa-map-radon-zones" target="_blank" rel="nofollow noopener" class="text-indigo-600 hover:underline">EPA Map of Radon Zones</a>
                    </li>
                    <li class="relative before:content-['•'] before:absolute before:-left-4 before:text-slate-300">
                        <a href="https://www.epa.gov/radon" target="_blank" rel="nofollow noopener" class="text-indigo-600 hover:underline">EPA Radon Home Page</a>
                    </li>
                    <li class="relative before:content-['•'] before:absolute before:-left-4 before:text-slate-300">
                        <a href="https://www.who.int/publications/i/item/9789241547673" target="_blank" rel="nofollow noopener" class="text-indigo-600 hover:underline">WHO Handbook on Indoor Radon</a>
                    </li>
                </ul>
                <p class="text-xs text-slate-400">
                    <strong>Disclaimer:</strong> Zone data represents county-level averages and cannot predict the radon level in any specific home.
                    Testing is the only reliable method to determine your home's radon concentration. This content is for informational purposes
                    and is not medical advice.
                </p>
                <p class="mt-4 text-xs text-slate-400 font-medium">Page Content Last Reviewed: February 2026</p>
            </div>
            @if(trust != null)
                @template.components.trust_metadata(trust = trust, quality = quality)
            @endif

        </div>
    `
)
