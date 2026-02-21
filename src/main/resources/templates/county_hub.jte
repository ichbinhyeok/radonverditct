@import com.radonverdict.model.dto.CountyPageContent
@import com.radonverdict.model.County

@param County county
@param CountyPageContent page

@template.layout.main(
    title = page.getHeroTitle(),
    description = page.getHeroSummary(),
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

            <!-- 3. Dynamic FAQs -->
            <div class="max-w-3xl border-t border-slate-200 mt-20 pt-16">
                @template.components.faq_accordion(page = page)
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
        </div>
    `
)
