@param String title

@template.layout.main(
    title = title,
    canonicalUrl = "https://radonverdict.com/guides/radon-fan-noise-troubleshooting",
    description = "Why is my radon fan making a loud buzzing or humming noise? Learn how to troubleshoot radon fan vibration, diagnose bearing failure, and know when to replace it.",
    content = @`
        <div class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-16 md:py-24 prose prose-slate md:prose-lg max-w-none">
            <a href="/guides" class="not-prose inline-flex items-center gap-1 text-xs font-bold text-slate-400 hover:text-indigo-600 transition-colors uppercase tracking-wider mb-6"><svg class="w-3 h-3" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3"><path stroke-linecap="round" stroke-linejoin="round" d="M15 19l-7-7 7-7"/></svg> All Guides</a>
            <span class="inline-block py-1 px-3 rounded-full bg-slate-100 text-slate-700 text-xs font-bold tracking-wider uppercase mb-6 ml-3">Maintenance &amp; Repair</span>
            <h1 class="font-display font-bold text-4xl text-slate-900 mb-6 tracking-tight">Radon Fan Noise Troubleshooting: Is It Normal?</h1>
            <p class="lead text-xl text-slate-600 mb-10 leading-relaxed font-medium pb-10 border-b border-slate-200">
                A properly installed radon fan should hum quietly in the background, like a high-end bathroom exhaust fan. If you can hear it screeching, rattling, or loudly buzzing through the drywall, you have a problem.
            </p>

            <h2 class="font-display font-bold text-2xl text-slate-900 mt-12 mb-4">Diagnosis 1: The High-Pitched Squeal or Metal Grinding</h2>
            <p class="text-slate-600 mb-6">
                <strong>The Cause:</strong> Bearing failure. Radon fans run 24 hours a day, 7 days a week, 365 days a year. Over time, the sealed ball bearings inside the motor dry out, especially in extreme heat (attics) or freezing temperatures (exterior mounts).
            </p>
            <p class="text-slate-600 mb-6 font-bold text-red-600">
                <strong>The Fix:</strong> Replace the fan immediately. 
            </p>
            <p class="text-slate-600 mb-6">
                You cannot lubricate sealed motor bearings. Once a fan starts screaming, it is drawing excess electrical current and will soon seize completely, meaning your home is no longer protected from radon gas. Check the manufacturing date sticker on the casing; most high-quality fans (like Fantech or RadonAway) have a 5-year warranty.
            </p>

            <h2 class="font-display font-bold text-2xl text-slate-900 mt-12 mb-4">Diagnosis 2: Deep Rattling or Wall Vibration</h2>
            <p class="text-slate-600 mb-6">
                <strong>The Cause:</strong> Rigid pipe mounting. If the fan was strapped tightly to a stud wall or floor joist without anti-vibration rubber isolation mounts, the motor's natural harmonic oscillation transfers directly into the home's framing. This turns your wall into a giant speaker.
            </p>
            <p class="text-slate-600 mb-6">
                <strong>The Fix:</strong> Soft-mounting the PVC pipe. An easy DIY fix is to cut the rigid plastic strapping and insert thick foam padding between the pipe and the wooden stud. The actual fan should also be connected to the PVC pipe using rubber fernco couplings, not hard-glued, to absorb vibration. 
            </p>

            <div class="bg-amber-50 border border-amber-200 rounded-2xl p-6 mb-8 mt-6">
                <h3 class="font-display font-bold text-amber-900 mb-2">Note: Diagnosis 3: Gurgling Water Sounds (Winter Only)</h3>
                <p class="text-sm text-amber-800 space-y-3">
                    If your fan sounds like a bong or a bubbling fish tank, congratulations: your system is successfully pulling hundreds of gallons of moisture out of the earth. But the condensation is running back down the pipe, pooling above the engine impellers, and possibly freezing. The fan must be re-pitched or bypassed so water can drain back to the sub-slab pit.
                </p>
            </div>

            <h2 class="font-display font-bold text-2xl text-slate-900 mt-12 mb-4">How Much Does a Fan Replacement Cost?</h2>
            <ul class="list-disc pl-6 text-slate-600 space-y-3 mb-8">
                <li><strong>DIY Replacement:</strong> $150 to $250. You must order the exact same model to match the CFM (cubic feet per minute) required for your house's footprint.</li>
                <li><strong>Professional Replacement:</strong> $350 to $600. A licensed electrician or mitigator will swap the fan, check the system pressure on the manometer, and sometimes run a free clearance test to ensure the vacuum seal didn't break.</li>
            </ul>

            <!-- CTA Section -->
            <div class="not-prose bg-gradient-to-br from-slate-900 to-slate-800 rounded-2xl p-8 mt-12 text-white">
                <h3 class="font-display font-bold text-xl text-white mb-3">Time for a Replacement?</h3>
                <p class="text-slate-300 mb-6 text-sm leading-relaxed">Don't try to wire a powerful 120V fan in a cramped attic if you aren't comfortable. Find a local pro to swap your fan today.</p>
                <a href="/radon-cost-calculator" class="inline-flex items-center justify-center px-6 py-3 border border-transparent text-sm font-bold rounded-xl text-slate-900 bg-white hover:bg-slate-100 transition">
                    Find Mitigation Repairs ->
                </a>
            </div>
        </div>
    `
)

