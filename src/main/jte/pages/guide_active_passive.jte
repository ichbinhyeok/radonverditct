@param String title

@template.layout.main(
    title = title,
    description = "What's the difference between an active and a passive radon mitigation system? Can a passive system be upgraded with a fan later? Learn the pros and cons.",
    content = @`
        <div class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-16 md:py-24 prose prose-slate md:prose-lg max-w-none">
            <a href="/guides" class="not-prose inline-flex items-center gap-1 text-xs font-bold text-slate-400 hover:text-indigo-600 transition-colors uppercase tracking-wider mb-6"><svg class="w-3 h-3" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3"><path stroke-linecap="round" stroke-linejoin="round" d="M15 19l-7-7 7-7"/></svg> All Guides</a>
            <span class="inline-block py-1 px-3 rounded-full bg-indigo-50 text-indigo-700 text-xs font-bold tracking-wider uppercase mb-6 ml-3">System Engineering</span>
            <h1 class="font-display font-bold text-4xl text-slate-900 mb-6 tracking-tight">Active vs. Passive Radon Mitigation Systems</h1>
            <p class="lead text-xl text-slate-600 mb-10 leading-relaxed font-medium pb-10 border-b border-slate-200">
                If you are buying new construction or upgrading a home in EPA Zone 1, you might hear the term "passive radon system." But what actually makes a system active vs passive, and why does one cost so much more to run?
            </p>

            <h2 class="font-display font-bold text-2xl text-slate-900 mt-12 mb-4">The Passive Radon System (RRNC)</h2>
            <p class="text-slate-600 mb-6">
                A "passive system," more accurately known as Radon-Resistant New Construction (RRNC), is a PVC vent pipe routed naturally from beneath your basement floor slab directly up through the walls and out of your roof. 
            </p>
            <p class="text-slate-600 mb-6">
                <strong>How it works:</strong> Passive systems rely entirely on the "stack effect." Warm air naturally rises up through the home, theoretically carrying the radon gas up through the pipe from the gravel pit below and safely discharging it above the roofline.
            </p>

            <h3 class="font-display font-bold text-xl text-slate-800 mt-8 mb-3">Does a passive system work?</h3>
            <p class="text-slate-600 mb-6">
                Sometimes. If soil permeability is high and the natural draft is strong, it can reduce levels by up to 50%. However, the EPA strongly advises that passive systems frequently fail to drop levels below 4.0 pCi/L in highly concentrated areas, particularly during the winter when house stack drafts alter.
            </p>

            <h2 class="font-display font-bold text-2xl text-slate-900 mt-12 mb-4">The Active Radon System (ASD)</h2>
            <p class="text-slate-600 mb-6">
                An "active system," known as Active Sub-Slab Depressurization (ASD), takes the exact same PVC pipe network but aggressively powers it with an inline radon mitigation fan (typically mounted in the attic or exterior). 
            </p>
            <p class="text-slate-600 mb-6">
                <strong>How it works:</strong> The fan creates a permanent negative pressure vacuum under the concrete slab. Instead of relying on a weak natural draft, the fan aggressively sucks the radon out of the dirt and blasts it out the roof. Active systems are highly reliable and regularly reduce toxic indoor air levels by 80-99%, pulling readings down to 1.5 pCi/L or lower.
            </p>

            <div class="bg-indigo-50 border border-indigo-200 rounded-2xl p-6 mb-8 mt-6">
                <h3 class="font-display font-bold text-indigo-900 mb-2">Can you upgrade passive to active?</h3>
                <p class="text-sm text-indigo-800 space-y-3">
                    Yes! The brilliance of modern new construction building codes is the "Activating a Passive System" process. If you test your new home and the passive pipe isn't cutting it, a certified mitigator simply cuts a section of the existing PVC in the attic, glues in a $200 radon fan, wires it to a junction box, and places a u-tube manometer in your basement. Boom-your system is now active for a few hundred dollars.
                </p>
            </div>

            <h2 class="font-display font-bold text-2xl text-slate-900 mt-12 mb-4">Cost Comparison</h2>
            <ul class="list-disc pl-6 text-slate-600 space-y-3 mb-8">
                <li><strong>Passive Installation (During Building):</strong> $300 - $600. It's incredibly cheap during the drywall stage before walls are painted.</li>
                <li><strong>Active Installation (Retrofit on existing home):</strong> $1,200 - $1,800. Labor-intensive because they must core concrete and hide pipes.</li>
                <li><strong>Activating a Passive System:</strong> $250 - $450. Adding the fan to an existing stack.</li>
                <li><strong>Annual Electricity:</strong> The fan draws 40-80 watts, costing about $40 to $70 per year on your electric bill. Passive is $0.</li>
            </ul>

            <!-- CTA Section -->
            <div class="not-prose bg-gradient-to-br from-slate-900 to-slate-800 rounded-2xl p-8 mt-12 text-white">
                <h3 class="font-display font-bold text-xl text-white mb-3">Needs a fan added to your system?</h3>
                <p class="text-slate-300 mb-6 text-sm leading-relaxed">Calculate exactly how much an active system retrofit costs in your local county.</p>
                <a href="/radon-cost-calculator" class="inline-flex items-center justify-center px-6 py-3 border border-transparent text-sm font-bold rounded-xl text-slate-900 bg-white hover:bg-slate-100 transition">
                    Get Active System Estimate ->
                </a>
            </div>
        </div>
    `
)
