@param String title

@template.layout.main(
    title = title,
    description = "Privacy policy for RadonVerdict. Read how we collect, use, and protect your information.",
    content = @`
        <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-16 md:py-24 prose prose-slate">
            <h1 class="font-display font-bold text-4xl text-slate-900 mb-8 tracking-tight">Privacy Policy</h1>
            <p class="text-sm text-slate-500 mb-10">Last Updated: ${java.time.LocalDate.now().getMonth().getDisplayName(java.time.format.TextStyle.FULL, java.util.Locale.US)} ${java.time.LocalDate.now().getYear()}</p>

            <h2 class="font-display font-bold text-2xl text-slate-900 mt-10 mb-4">1. Introduction</h2>
            <p class="text-slate-600 mb-6">
                Welcome to RadonVerdict ("we", "our", or "us"). We respect your privacy and are committed to protecting your personal data. This privacy policy will inform you as to how we look after your personal data when you visit our website (regardless of where you visit it from) and tell you about your privacy rights and how the law protects you.
            </p>

            <h2 class="font-display font-bold text-2xl text-slate-900 mt-10 mb-4">2. The Data We Collect About You</h2>
            <p class="text-slate-600 mb-6">
                When you use our cost calculator or request a local estimate, we may collect:
            </p>
            <ul class="list-disc pl-6 text-slate-600 mb-6 space-y-2">
                <li><strong>Identity Data:</strong> First name and last name.</li>
                <li><strong>Contact Data:</strong> Phone number and email address.</li>
                <li><strong>Location Data:</strong> ZIP code, county, and state.</li>
                <li><strong>Property Data:</strong> Information about your home, such as foundation type and previous test results.</li>
                <li><strong>Consent Metadata:</strong> IP address, browser user-agent, and the exact consent language agreed to at the time of submission.</li>
            </ul>

            <h2 class="font-display font-bold text-2xl text-slate-900 mt-10 mb-4">3. How We Use Your Data</h2>
            <p class="text-slate-600 mb-6">
                We will only use your personal data when the law allows us to. Most commonly, we will use your personal data in the following circumstances:
            </p>
            <ul class="list-disc pl-6 text-slate-600 mb-6 space-y-2">
                <li>Where we need to provide your personalized radon action plan and add you to our waitlist.</li>
                <li>Where we contact you to notify you of local contractor availability in your area.</li>
                <li>Where it is necessary for our legitimate interests (or those of a third party) and your interests and fundamental rights do not override those interests.</li>
                <li>Where we need to comply with a legal or regulatory obligation.</li>
            </ul>

            <h2 class="font-display font-bold text-2xl text-slate-900 mt-10 mb-4">4. Disclosures of Your Personal Data</h2>
            <p class="text-slate-600 mb-6">
                By submitting a request, you explicitly consent to your information being used to provide an action plan and to notify you when trusted local mitigation professionals become available in your geographical area. We securely store this data and do not sell it to unauthorized data brokers. 
            </p>
            
            <h2 class="font-display font-bold text-2xl text-slate-900 mt-10 mb-4">5. Data Security & Analytics</h2>
            <p class="text-slate-600 mb-6">
                We have put in place appropriate security measures to prevent your personal data from being accidentally lost, used, or accessed in an unauthorized way, altered, or disclosed. Access to your personal data is limited to those employees, agents, contractors, and other third parties who have a business need to know.
            </p>
            
            <h2 class="font-display font-bold text-xl text-slate-900 mt-8 mb-4">Contact Us</h2>
            <p class="text-slate-600">
                If you have any questions about this privacy policy, including any requests to exercise your legal rights, please contact us via our <a href="/contact" class="text-indigo-600 hover:text-indigo-800">Contact Page</a>.
            </p>
        </div>
    `
)
