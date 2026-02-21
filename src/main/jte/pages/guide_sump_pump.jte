@param String title

@template.layout.main(
    title = title,
    description = "Sump pumps and radon systems interact directly. Learn why sealing your sump pump pit is mandatory for an active sub-slab depressurization system.",
    content = @`
        <div class="max-w-3xl mx-auto px-4 sm:px-6 lg:px-8 py-16 md:py-24 prose prose-slate md:prose-lg max-w-none">
            <a href="/guides" class="not-prose inline-flex items-center gap-1 text-xs font-bold text-slate-400 hover:text-indigo-600 transition-colors uppercase tracking-wider mb-6"><svg class="w-3 h-3" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3"><path stroke-linecap="round" stroke-linejoin="round" d="M15 19l-7-7 7-7"/></svg> All Guides</a>
            <span class="inline-block py-1 px-3 rounded-full bg-indigo-50 text-indigo-700 text-xs font-bold tracking-wider uppercase mb-6 ml-3">System Engineering</span>
            <h1 class="font-display font-bold text-4xl text-slate-900 mb-6 tracking-tight">Sump Pumps &amp; Radon Mitigation: The Unsealed Pit Problem</h1>
            <p class="lead text-xl text-slate-600 mb-10 leading-relaxed font-medium pb-10 border-b border-slate-200">
                You hire a contractor to install a radon system. The first thing they do? They walk straight past the foundation walls and stare at your basement sump pump pit. Why? Because an open sump pit is the fast lane for soil gas.
            </p>

            <h2 class="font-display font-bold text-2xl text-slate-900 mt-12 mb-4">The Sump Pit is a Direct Highway into the Soil</h2>
            <p class="text-slate-600 mb-6">
                Most basements are constructed with a concrete slab resting over a bed of crushed gravel and dirt. To manage groundwater, contractors dig a deep hole (the sump pit) directly into that dirt, installing a pump to push water out. 
            </p>
            <p class="text-slate-600 mb-6 font-bold text-red-600">
                If the homeowner leaves the pit open or covers it with a cheap, unsealed plastic lid, thousands of cubic feet of soil gas—including toxic radon—free-flows directly into the basement air.
            </p>

            <h3 class="font-display font-bold text-xl text-slate-800 mt-8 mb-3">Why You Cannot Install a Radon System Without Sealing It</h3>
            <p class="text-slate-600 mb-6">
                A standard Active Sub-Slab Depressurization (ASD) system works by drilling a 4-inch hole in the concrete, dropping a PVC pipe in, and using a roof-level fan to aggressively suck the radon out of the gravel bed underneath your floor. 
            </p>
            <p class="text-slate-600 mb-6">
                But vacuum physics dictate that suction follows the path of least resistance. Provide an open sump pit nearby, and the radon fan will simply suck the conditioned air from your basement, down the pit, under the concrete, and out the exhaust pipe. You will lose hundreds of dollars in heating and cooling energy, and you will not depressurize the soil gas. <strong>You must seal the pit to "close the loop" of the vacuum under the house.</strong>
            </p>

            <div class="bg-indigo-50 border border-indigo-200 rounded-2xl p-6 mb-8 mt-6">
                <h3 class="font-display font-bold text-indigo-900 mb-2">The Solution: Air-Tight Sump Domes</h3>
                <ul class="text-sm text-indigo-800 space-y-3">
                    <li><strong>Bolted Lids:</strong> Mitigators replace cheap corrugated plastic covers with heavy-duty polycarbonate domes, bolted directly to the concrete surrounding the pit.</li>
                    <li><strong>Silicone Seals:</strong> The perimeter of the dome is sealed with 100% silicone or polyurethane caulk.</li>
                    <li><strong>Rubber Grommets:</strong> The water discharge pipe and electrical cords passing through the lid are sealed using thick rubber grommets.</li>
                    <li><strong>Bonus: Using the Pit for Suction.</strong> Sometimes, the mitigator will run the 4-inch radon PVC pipe directly into the sealed sump cover itself, using the massive pit as an incredible suction point for the whole house!</li>
                </ul>
            </div>

            <h2 class="font-display font-bold text-2xl text-slate-900 mt-12 mb-4">How Much Does Sump Pump Sealing Cost?</h2>
            <p class="text-slate-600 mb-6">
                If done simultaneously with a radon mitigation system installation, sealing a standard sump pit typically adds <strong>$150 to $250</strong> to the total invoice. This covers the cost of the heavy-duty clear dome cover, grommets, caulk, and a half hour of labor.
            </p>

            <!-- CTA Section -->
            <div class="not-prose bg-gradient-to-br from-slate-900 to-slate-800 rounded-2xl p-8 mt-12 text-white">
                <h3 class="font-display font-bold text-xl text-white mb-3">Does your basement layout include a sump pump?</h3>
                <p class="text-slate-300 mb-6 text-sm leading-relaxed">Factoring in sump pumps and foundation cracks alters the final installation cost. Get an itemized breakdown.</p>
                <a href="/radon-cost-calculator" class="inline-flex items-center justify-center px-6 py-3 border border-transparent text-sm font-bold rounded-xl text-slate-900 bg-white hover:bg-slate-100 transition">
                    Get an Itemized Quote →
                </a>
            </div>
        </div>
    `
)
