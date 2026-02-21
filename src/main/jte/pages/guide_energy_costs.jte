@param String title

@template.layout.main(
    title = title,
    description = "How much electricity does a radon mitigation fan use? Calculate the running costs of an active sub-slab depressurization system on your monthly power bill.",
    content = @`
        <div class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-16 md:py-24 prose prose-slate md:prose-lg max-w-none">
            <a href="/guides" class="not-prose inline-flex items-center gap-1 text-xs font-bold text-slate-400 hover:text-indigo-600 transition-colors uppercase tracking-wider mb-6"><svg class="w-3 h-3" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3"><path stroke-linecap="round" stroke-linejoin="round" d="M15 19l-7-7 7-7"/></svg> All Guides</a>
            <span class="inline-block py-1 px-3 rounded-full bg-slate-100 text-slate-700 text-xs font-bold tracking-wider uppercase mb-6 ml-3">Maintenance &amp; Repair</span>
            <h1 class="font-display font-bold text-4xl text-slate-900 mb-6 tracking-tight">Radon System Electricity Cost: How Much Power Does the Fan Use?</h1>
            <p class="lead text-xl text-slate-600 mb-10 leading-relaxed font-medium pb-10 border-b border-slate-200">
                You're planning to install an Active Sub-Slab Depressurization (ASD) radon system. Since the National Radon Proficiency Program (NRPP) mandates the fan run 24 hours a day, 365 days a year, the real hidden cost is the electricity bill. Just how much power does a radon fan suck?
            </p>

            <h2 class="font-display font-bold text-2xl text-slate-900 mt-12 mb-4">The Wattage Profile of a Modern Radon Fan</h2>
            <p class="text-slate-600 mb-6 font-bold text-green-600">
                Good news: modern radon mitigation fans are incredibly energy efficient.
            </p>
            <p class="text-slate-600 mb-6">
                Most residential models—such as the popular Fantech RN1 or RadonAway RP145—are engineered with low-draw, continuous-duty motors. Depending on the size of your home and the permeability of the soil beneath your slab, these fans pull anywhere from 40 to 80 watts of electricity per hour. By comparison, leaving a single 60-watt incandescent light bulb on overnight draws nearly the same amount of power.
            </p>

            <h3 class="font-display font-bold text-xl text-slate-800 mt-8 mb-3">Calculating the Exact Monthly Cost</h3>
            <p class="text-slate-600 mb-6">
                Let's do the math on a standard mid-range fan pulling 60 watts continuously:
            </p>
            
            <div class="bg-slate-50 border border-slate-200 rounded-2xl p-6 mb-8 mt-6">
                <ol class="list-decimal pl-6 text-slate-800 space-y-4">
                    <li><strong>Daily Usage:</strong> 60 watts x 24 hours = 1,440 watt-hours (1.44 kilowatt-hours / kWh per day).</li>
                    <li><strong>Monthly Usage:</strong> 1.44 kWh x 30 days = 43.2 kWh per month.</li>
                    <li><strong>Cost Calculation:</strong> If your local utility charges a standard $0.14 per kWh, your fan costs 43.2 x $0.14 = <strong>$6.04 per month.</strong></li>
                </ol>
            </div>

            <p class="text-slate-700 font-semibold mb-8 text-xl text-center shadow-sm p-4 rounded-lg bg-green-50 border border-green-100 italic">
                <strong>Average Annual Electricity Cost: $60 to $85</strong>
            </p>

            <h2 class="font-display font-bold text-2xl text-slate-900 mt-12 mb-4">The High-Suction Exceptions</h2>
            <p class="text-slate-600 mb-6">
                Not all fans pull 60 watts. If your home was built on dense clay, heavily compacted soil, or requires significant pressure drop to pull air through tiny cracks in the bedrock, you will need a High-Suction (HS) fan (e.g., RadonAway GP501).
            </p>
            <p class="text-slate-600 mb-6">
                These aggressive motors can draw 100 to 150 watts continuously, pushing your monthly bill closer to $15 or roughly $180 per year.
            </p>

            <h2 class="font-display font-bold text-2xl text-slate-900 mt-12 mb-4">Can I Just Turn the Fan Off at Night?</h2>
            <p class="text-slate-600 mb-6">
                No. Radon gas exerts constant pressure from the earth. The moment you interrupt power to the fan, the vacuum breaks, and radon levels inside the home return to their massive pre-mitigation natural peak within 4 to 12 hours. The system is designed to run non-stop for the lifespan of the bearings (typically 5-10 years).
            </p>

            <!-- CTA Section -->
            <div class="not-prose bg-gradient-to-br from-slate-900 to-slate-800 rounded-2xl p-8 mt-12 text-white">
                <h3 class="font-display font-bold text-xl text-white mb-3">Need to Install an Efficient System?</h3>
                <p class="text-slate-300 mb-6 text-sm leading-relaxed">Calculate exactly how much a full active radon mitigation system costs to install locally before pricing out the electric bill.</p>
                <a href="/radon-cost-calculator" class="inline-flex items-center justify-center px-6 py-3 border border-transparent text-sm font-bold rounded-xl text-slate-900 bg-white hover:bg-slate-100 transition">
                    View Mitigation Setup Costs →
                </a>
            </div>
        </div>
    `
)
