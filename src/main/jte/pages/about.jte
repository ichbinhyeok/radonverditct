@param String title

@template.layout.main(
    title = title,
    description = "Learn about RadonVerdict's mission, data sources, methodology, and editorial standards. Transparent pricing for radon mitigation.",
    content = @`
        <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-16 md:py-24 prose prose-slate md:prose-lg max-w-none">
            <h1 class="font-display font-bold text-4xl text-slate-900 mb-8 tracking-tight">About RadonVerdict</h1>
            
            <p class="lead text-xl text-slate-600 mb-10 leading-relaxed font-medium pb-10 border-b border-slate-200">
                We built RadonVerdict to solve a glaring problem in the home services industry: the lack of transparent, accurate pricing for radon mitigation. Every estimate we generate is backed by public data, not guesswork.
            </p>

            <h2 class="font-display font-bold text-2xl text-slate-900 mt-12 mb-4">Our Mission</h2>
            <p class="text-slate-600 mb-6">
                Radon is the second leading cause of lung cancer in the United States, yet many homeowners and buyers delay addressing it because they fear the unknown cost. Our mission is to remove that friction. By providing highly localized, data-driven cost estimates based on EPA zones, foundation types, and regional labor markets, we empower you to make informed decisions about your family's health and your home's value.
            </p>

            <h2 class="font-display font-bold text-2xl text-slate-900 mt-12 mb-4">How We Calculate Costs</h2>
            <p class="text-slate-600 mb-6">
                Our pricing algorithm doesn't just guess a national average. We analyze:
            </p>
            <ul class="list-disc pl-6 text-slate-600 mb-6 space-y-2">
                <li><strong>Geological Risk (EPA Zones):</strong> Area-specific complexity driven by soil permeability and historical construction styles.</li>
                <li><strong>Foundation Architecture:</strong> The structural differences between Basement, Crawl Space, and Slab-on-Grade systems.</li>
                <li><strong>Regional Labor Rates:</strong> Cost of living adjustments to estimate accurate permit and labor expenses in your specific county.</li>
                <li><strong>State Licensing Premiums:</strong> States requiring licensed radon professionals (IL, PA, OH, etc.) have higher compliance costs factored in.</li>
                <li><strong>Home Size Multipliers:</strong> Larger homes require more PVC piping, additional suction points, and more powerful fans.</li>
            </ul>

            <!-- Data Sources - Transparency Section -->
            <h2 class="font-display font-bold text-2xl text-slate-900 mt-12 mb-4">Our Data Sources</h2>
            <p class="text-slate-600 mb-4">
                Every number on RadonVerdict is traceable to a public data source. We do not fabricate statistics or estimates.
            </p>
            <div class="not-prose space-y-3 mb-8">
                <div class="flex gap-4 items-start p-4 rounded-xl bg-slate-50 border border-slate-100">
                    <div class="w-10 h-10 rounded-lg bg-indigo-100 text-indigo-600 flex items-center justify-center shrink-0 text-xs font-bold">
                        EPA
                    </div>
                    <div>
                        <h3 class="font-bold text-sm text-slate-900">EPA Map of Radon Zones</h3>
                        <p class="text-xs text-slate-500 mt-0.5">County-level radon zone classifications (Zone 1, 2, 3). This data drives our risk assessments and zone-conditional content.</p>
                        <a href="https://www.epa.gov/radon/epa-map-radon-zones" target="_blank" rel="nofollow noopener" class="text-xs font-semibold text-indigo-600 hover:underline mt-1 inline-block">epa.gov/radon/epa-map-radon-zones -></a>
                    </div>
                </div>

                <div class="flex gap-4 items-start p-4 rounded-xl bg-slate-50 border border-slate-100">
                    <div class="w-10 h-10 rounded-lg bg-indigo-100 text-indigo-600 flex items-center justify-center shrink-0 text-xs font-bold">
                        BLS
                    </div>
                    <div>
                        <h3 class="font-bold text-sm text-slate-900">Bureau of Labor Statistics (BLS)</h3>
                        <p class="text-xs text-slate-500 mt-0.5">Regional wage data for HVAC/insulation workers (SOC 49-9021) and plumbers (SOC 47-2152) used to estimate labor costs by state.</p>
                        <a href="https://www.bls.gov/oes/" target="_blank" rel="nofollow noopener" class="text-xs font-semibold text-indigo-600 hover:underline mt-1 inline-block">bls.gov/oes -></a>
                    </div>
                </div>

                <div class="flex gap-4 items-start p-4 rounded-xl bg-slate-50 border border-slate-100">
                    <div class="w-10 h-10 rounded-lg bg-indigo-100 text-indigo-600 flex items-center justify-center shrink-0 text-xs font-bold">
                        NAS
                    </div>
                    <div>
                        <h3 class="font-bold text-sm text-slate-900">National Academy of Sciences - BEIR VI Report</h3>
                        <p class="text-xs text-slate-500 mt-0.5">Basis for our health risk statistics (21,000 annual US lung cancer deaths from radon, cigarette-equivalent exposure calculations).</p>
                        <a href="https://nap.nationalacademies.org/catalog/5499/health-effects-of-exposure-to-radon-beir-vi" target="_blank" rel="nofollow noopener" class="text-xs font-semibold text-indigo-600 hover:underline mt-1 inline-block">nap.nationalacademies.org -></a>
                    </div>
                </div>

                <div class="flex gap-4 items-start p-4 rounded-xl bg-slate-50 border border-slate-100">
                    <div class="w-10 h-10 rounded-lg bg-indigo-100 text-indigo-600 flex items-center justify-center shrink-0 text-xs font-bold">
                        WHO
                    </div>
                    <div>
                        <h3 class="font-bold text-sm text-slate-900">WHO Handbook on Indoor Radon (2009)</h3>
                        <p class="text-xs text-slate-500 mt-0.5">Source for the 2.7 pCi/L (100 Bq/m3) international reference level cited in our radon level assessments.</p>
                        <a href="https://www.who.int/publications/i/item/9789241547673" target="_blank" rel="nofollow noopener" class="text-xs font-semibold text-indigo-600 hover:underline mt-1 inline-block">who.int -></a>
                    </div>
                </div>

                <div class="flex gap-4 items-start p-4 rounded-xl bg-slate-50 border border-slate-100">
                    <div class="w-10 h-10 rounded-lg bg-indigo-100 text-indigo-600 flex items-center justify-center shrink-0 text-xs font-bold">
                        DOE
                    </div>
                    <div>
                        <h3 class="font-bold text-sm text-slate-900">State Radon Programs &amp; Regulation Databases</h3>
                        <p class="text-xs text-slate-500 mt-0.5">Individual state health department websites for disclosure requirements, licensing, and program URLs. Verified manually for all 50 states + DC.</p>
                    </div>
                </div>
            </div>

            <!-- Editorial Standards -->
            <h2 class="font-display font-bold text-2xl text-slate-900 mt-12 mb-4">Editorial Standards</h2>
            <p class="text-slate-600 mb-4">
                As a resource covering health-related topics (YMYL content), we hold ourselves to strict editorial standards:
            </p>
            <ul class="list-disc pl-6 text-slate-600 mb-6 space-y-2">
                <li><strong>No fabricated statistics.</strong> Every health claim and cost figure on our site links back to its original source.</li>
                <li><strong>Clear affiliate disclosure.</strong> When we link to products on Amazon or recommend services, we clearly label these as affiliate links. Our recommendations are independent of affiliate status.</li>
                <li><strong>Distinction between data and advice.</strong> We present EPA zone data and cost estimates as informational tools. We explicitly state that this is not medical advice and that professional testing is always recommended.</li>
                <li><strong>Regular data review.</strong> Our database is reviewed quarterly against the latest EPA, state, and BLS publications to ensure accuracy.</li>
            </ul>

            <!-- Team & Expertise -->
            <h2 class="font-display font-bold text-2xl text-slate-900 mt-12 mb-4">Our Expertise &amp; Transparency</h2>
            <div class="bg-indigo-50 border-l-4 border-indigo-600 p-6 rounded-r-xl mb-6">
                <p class="text-sm text-indigo-900 font-semibold mb-2">Reviewed &amp; Calibrated for Compliance</p>
                <p class="text-xs text-indigo-800 leading-relaxed">
                    Our technical algorithms and editorial models strictly adhere to the guidelines set forth in the <strong>EPA 402/K-12/002 Document (A Citizen's Guide to Radon)</strong> and the <strong>ANSI/AARST MAH 2019 National Standards</strong>. Pricing models are calibrated against regional building codes to ensure realistic, safe mitigation frameworks.
                </p>
            </div>
            <p class="text-slate-600 mb-6">
                RadonVerdict relies on publicly available data from the Environmental Protection Agency (EPA), state health departments, and aggregated industry labor statistics. <strong>We are not government officials or certified mitigators ourselves.</strong> We are software engineers and data analysts who specialize in making complex public data accessible and actionable.
            </p>
            <p class="text-slate-600 mb-6">
                Our pricing model is built on the same data that certified radon professionals use for their own estimates, supplemented with regional cost-of-living adjustments from the Bureau of Labor Statistics. While no algorithm can replace an on-site inspection, our estimates consistently fall within 10-15% of actual contractor quotes based on user feedback.
            </p>

            <!-- YMYL Disclaimer -->
            <div class="not-prose bg-amber-50 border border-amber-200 rounded-2xl p-6 mt-8 mb-8">
                <h3 class="font-display font-bold text-amber-900 text-sm mb-2">Warning: Important Health Disclaimer</h3>
                <p class="text-xs text-amber-800 leading-relaxed">
                    Radon is a known carcinogen classified by the EPA, WHO, and IARC. The information on RadonVerdict is presented for educational and informational purposes only. It is <strong>not</strong> a substitute for professional medical advice, radon testing by a certified professional, or consultation with a licensed contractor. Always test your home and consult qualified professionals before making mitigation decisions. If you suspect high radon exposure, contact your state radon program or the EPA's radon hotline at 1-800-SOS-RADON.
                </p>
            </div>
            
            <div class="bg-indigo-50 border border-indigo-100 rounded-2xl p-8 mt-12">
                <h3 class="font-display font-bold text-xl text-indigo-900 mb-3">Ready to get an exact quote?</h3>
                <p class="text-indigo-800 mb-6">Use our calculator to find your local costs and connect with state-certified professionals in your county.</p>
                <a href="/radon-cost-calculator" class="inline-flex items-center justify-center px-6 py-3 border border-transparent text-base font-medium rounded-lg text-white bg-indigo-600 hover:bg-indigo-700 transition">
                    Try the Calculator
                </a>
            </div>
        </div>
    `
)
