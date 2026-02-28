@param String title

@template.layout.main(
    title = title,
    description = "Terms of Service and Disclaimers for RadonVerdict. Please read carefully before using our estimation tools.",
    canonicalUrl = "https://radonverdict.com/terms",
    content = @`
        <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-16 md:py-24 prose prose-slate">
            <h1 class="font-display font-bold text-4xl text-slate-900 mb-8 tracking-tight">Terms of Service & Disclaimer</h1>
            <p class="text-sm text-slate-500 mb-10">Effective Date: ${java.time.LocalDate.now().getMonth().getDisplayName(java.time.format.TextStyle.FULL, java.util.Locale.US)} ${java.time.LocalDate.now().getYear()}</p>

            <h2 class="font-display font-bold text-2xl text-slate-900 mt-10 mb-4">1. Acceptance of Terms</h2>
            <p class="text-slate-600 mb-6">
                By accessing and using RadonVerdict.com (the "Site"), you agree to abide by these Terms of Service. If you do not agree to these terms, please do not use our services.
            </p>

            <h2 class="font-display font-bold text-2xl text-slate-900 mt-10 mb-4">2. Estimation Disclaimer</h2>
            <p class="text-slate-600 mb-6">
                <strong>Our estimates are informational, not binding quotes.</strong> 
                The cost projections provided on RadonVerdict are calculated using a proprietary algorithm that aggregates historical cost data, local labor indexes, and EPA zone classifications. While we strive to present the most accurate and localized figures possible, these are strictly estimates. Your actual mitigation cost may vary due to structural specifics, hidden architectural complexities (e.g., hidden crawl spaces, HVAC interactions), and the specific contractor you hire. Only a licensed contractor who has inspected your property can provide a binding quote.
            </p>

            <h2 class="font-display font-bold text-2xl text-slate-900 mt-10 mb-4">3. Not Affiliated with the EPA</h2>
            <p class="text-slate-600 mb-6">
                <strong>We are an independent organization.</strong> 
                RadonVerdict relies on data from the Environmental Protection Agency (EPA) to determine risk zones, but we are not affiliated with, endorsed by, or sponsored by the EPA, the US Government, or any State Department of Health. The responsibility for addressing radon hazards lies entirely with the homeowner.
            </p>

            <h2 class="font-display font-bold text-2xl text-slate-900 mt-10 mb-4">4. Waitlist and Notifications</h2>
            <p class="text-slate-600 mb-6">
                When you submit a request for an action plan or join our waitlist, you authorize us to notify you when trusted local mitigation professionals become available in your area. We do not perform the mitigation services ourselves. We do not guarantee the quality of work, pricing, or licensing status of the third-party providers. It is your responsibility to verify the credentials, insurance, and state certifications of any contractor you hire.
            </p>

            <h2 class="font-display font-bold text-2xl text-slate-900 mt-10 mb-4">5. Contact Consent</h2>
            <p class="text-slate-600 mb-6">
                By providing your contact information, you consent to receive direct communications (emails and/or text messages if provided) from RadonVerdict regarding your personalized radon action plan, educational materials, and availability alerts for local contractors. You may opt out of these communications at any time.
            </p>
            
            <h2 class="font-display font-bold text-2xl text-slate-900 mt-10 mb-4">6. Limitation of Liability</h2>
            <p class="text-slate-600 mb-6">
                In no event shall RadonVerdict or its directors, employees, or agents be liable to you or any third party for any direct, indirect, consequential, exemplary, incidental, special, or punitive damages, including lost profit, lost revenue, or property damage arising from your use of the Site or the services provided by third-party contractors found through our Site.
            </p>
        </div>
    `
)
