@import com.radonverdict.model.dto.CountyPageContent
@import com.radonverdict.model.County

@param County county
@param CountyPageContent page
@param String canonicalUrl = null
@param String leadSuccessMessage = null
@param String leadErrorMessage = null

@template.layout.main(
    title = page.getHeroTitle(),
    description = page.getHeroSummary(),
    canonicalUrl = canonicalUrl,
    content = @`
        <div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-10">
            
            <!-- Breadcrumbs -->
            <nav class="text-sm font-medium text-slate-500 mb-8" aria-label="Breadcrumb">
                <ol class="inline-flex items-center space-x-2">
                    <li><a href="/" class="hover:text-slate-900 transition-colors">Home</a></li>
                    <li><span class="mx-1 text-slate-300">/</span></li>
                    <li><a href="/radon-mitigation-cost/${county.getStateSlug()}" class="hover:text-slate-900 transition-colors uppercase">${county.getStateAbbr()}</a></li>
                    <li><span class="mx-1 text-slate-300">/</span></li>
                    <li class="text-slate-900 font-semibold" aria-current="page">${county.getCountyName()} County</li>
                </ol>
            </nav>

            <!-- 1. Above the Fold: Hero Section -->
            @template.components.hero_section(page = page)

            <!-- 2. Grid Layout for Simulator and Receipt -->
            <div class="grid grid-cols-1 lg:grid-cols-12 gap-10 mt-16 mb-20">
                
                <!-- Left Column (Simulator + Details) -->
                <div class="lg:col-span-5 order-2 lg:order-1">
                    @template.components.radon_level_advisor(county = county)
                    @template.components.simulator_form(county = county)
                    
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
                <div class="lg:col-span-7 order-1 lg:order-2">
                    <div class="sticky top-24">
                        <div id="receipt-container" class="transition-opacity duration-200">
                            <!-- Included via JTE fragment so it matches the HTMX return exactly -->
                            @template.fragments.receipt(page = page)
                        </div>
                    </div>
                </div>
            </div>

            <!-- Lead Capture CTA (Injected) -->
            @template.components.lead_form(county = county, page = page, successMessage = leadSuccessMessage, errorMessage = leadErrorMessage)

            <!-- 3. Dynamic FAQs -->
            <div class="max-w-3xl border-t border-slate-200 mt-20 pt-16">
                @template.components.faq_accordion(page = page)
            </div>

            <!-- Cross-Silo: Radon Level Data & Guides -->
            <div class="border-t border-slate-200 mt-20 pt-12 mb-10">
                <h3 class="font-display font-bold text-lg text-slate-900 mb-4">More About Radon in ${county.getCountyName()} County</h3>
                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <a href="/radon-levels/${county.getStateSlug()}/${county.getCountySlug()}"
                       class="flex items-center gap-3 p-4 rounded-xl border border-slate-200 bg-white hover:border-indigo-300 hover:shadow-md transition-all group">
                        <div class="w-10 h-10 rounded-lg bg-indigo-50 text-indigo-600 flex items-center justify-center shrink-0">
                            <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" /></svg>
                        </div>
                        <div>
                            <span class="block font-bold text-sm text-slate-800 group-hover:text-indigo-600 transition-colors">${county.getCountyName()} County Radon Levels</span>
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
                            <span class="text-xs text-slate-500">Complete testing guide — kits, placement, results</span>
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
                            <span class="block font-bold text-slate-800 group-hover:text-indigo-600 transition-colors">${nearby.getCountyName()}</span>
                            <span class="text-xs text-slate-500 mt-1">Zone ${nearby.getEpaZone()}</span>
                        </a>
                    @endfor
                </div>
            </div>
            @endif

            <!-- 5. Sources & Methodology / YMYL Disclaimers -->
            <div class="border-t border-slate-200 mt-20 pt-16 mb-10 text-sm text-slate-500">
                <h3 class="font-display font-bold text-xl text-slate-900 mb-4">Sources & Methodology</h3>
                <p class="mb-6">The radon mitigation cost estimates presented on this page are dynamically calculated using baseline national material averages combined with localized labor multipliers for ${county.getCountyName()} County. </p>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                    <div>
                        <h4 class="font-bold text-slate-700 mb-2">Important Disclaimers</h4>
                        <ul class="space-y-3 pl-4">
                            <li class="relative before:content-['•'] before:absolute before:-left-4 before:text-slate-300"><strong class="text-slate-700">Health & Safety:</strong> Information on this site is for educational purposes and is not medical advice. For health concerns, consult qualified professionals.</li>
                            <li class="relative before:content-['•'] before:absolute before:-left-4 before:text-slate-300"><strong class="text-slate-700">Estimates:</strong> Estimates are general ranges based on typical projects. Actual quotes vary by home conditions and local labor.</li>
                            <li class="relative before:content-['•'] before:absolute before:-left-4 before:text-slate-300"><strong class="text-slate-700">Zone Data:</strong> Radon zone classifications describe regional potential for elevated indoor radon. They do not predict the radon level in a specific home. Testing is recommended for all homes.</li>
                        </ul>
                    </div>
                    <div>
                        <h4 class="font-bold text-slate-700 mb-2">Data Sources</h4>
                        <ul class="space-y-3 pl-4">
                            <li class="relative before:content-['•'] before:absolute before:-left-4 before:text-slate-300"><a href="https://www.epa.gov/radon" target="_blank" rel="nofollow noopener" class="text-indigo-600 hover:text-indigo-800 hover:underline transition-colors">US Environmental Protection Agency (EPA) - Action Level</a></li>
                            <li class="relative before:content-['•'] before:absolute before:-left-4 before:text-slate-300"><a href="https://www.epa.gov/radon/epa-map-radon-zones" target="_blank" rel="nofollow noopener" class="text-indigo-600 hover:text-indigo-800 hover:underline transition-colors">EPA Map of Radon Zones</a></li>
                            <li class="relative before:content-['•'] before:absolute before:-left-4 before:text-slate-300">National contractor cost guides and local labor indices.</li>
                        </ul>
                    </div>
                </div>
                <p class="mt-8 text-xs text-slate-400 font-medium">Page Content Last Updated: February 2026</p>
            </div>
            
            <!-- Generate JSON-LD schema for FAQPage -->
            <script type="application/ld+json">
                {
                    "@context": "https://schema.org",
                    "@type": "FAQPage",
                    "mainEntity": [
                        @for(int i = 0; i < page.getFaqs().size(); i++)
                        {
                            "@type": "Question",
                            "name": "${page.getFaqs().get(i).getQuestion()}",
                            "acceptedAnswer": {
                                "@type": "Answer",
                                "text": "${page.getFaqs().get(i).getAnswer()}"
                            }
                        }
                        @if(i < page.getFaqs().size() - 1),@endif
                        @endfor
                    ]
                }
            </script>
            
            <!-- Generate JSON-LD schema for BreadcrumbList -->
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
                        "name": "${county.getStateAbbr()}",
                        "item": "https://radonverdict.com/radon-mitigation-cost/${county.getStateSlug()}"
                    },{
                        "@type": "ListItem",
                        "position": 3,
                        "name": "${county.getCountyName()} County",
                        "item": "https://radonverdict.com/radon-mitigation-cost/${county.getStateSlug()}/${county.getCountySlug()}"
                    }]
                }
            </script>
        </div>
    `
)
