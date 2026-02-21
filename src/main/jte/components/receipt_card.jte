@import com.radonverdict.model.dto.ItemizedReceipt

@param ItemizedReceipt receipt

<!-- The Receipt Card: Pure Silicon Valley Fintech Aesthetic -->
<div class="bg-white rounded-[2rem] shadow-[0_8px_30px_rgb(0,0,0,0.04)] border border-slate-100/50 overflow-hidden relative group">
    
    <!-- Top Decorative Line (Minimalist) -->
    <div class="h-1.5 w-full bg-slate-900"></div>
    
    <div class="p-8 sm:p-10">
        <!-- Header -->
        <div class="flex items-start justify-between mb-10">
            <div>
                <h3 class="font-display font-extrabold text-slate-900 text-2xl tracking-tight">Official Estimate</h3>
                <p class="text-slate-400 text-sm mt-1 font-medium tracking-wide uppercase">${receipt.getCountyName()} County, ${receipt.getStateAbbr()}</p>
            </div>
            <!-- Trust Seal -->
            <div class="w-10 h-10 bg-emerald-50 rounded-full flex items-center justify-center border border-emerald-100 shadow-sm">
                <svg class="w-5 h-5 text-emerald-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7" />
                </svg>
            </div>
        </div>

        <!-- Itemized Breakdown (Using flex to align dots) -->
        <div class="space-y-5 mb-10">
            <!-- Materials -->
            <div class="flex items-baseline justify-between text-slate-600">
                <span class="font-medium">System Materials</span>
                <div class="flex-grow border-b-2 border-dotted border-slate-200 mx-4 relative top-[-6px]"></div>
                <span class="font-semibold tabular-nums text-slate-900 tracking-tight">$${receipt.getMaterialsAvg()}</span>
            </div>
            
            <!-- Labor -->
            <div class="flex items-baseline justify-between text-slate-600">
                <div class="flex flex-col">
                    <span class="font-medium">Specialized Labor</span>
                </div>
                <div class="flex-grow border-b-2 border-dotted border-slate-200 mx-4 relative top-[-6px]"></div>
                <span class="font-semibold tabular-nums text-slate-900 tracking-tight">$${receipt.getLaborAvg()}</span>
            </div>
            
            <!-- Permits -->
            <div class="flex items-baseline justify-between text-slate-600">
                <span class="font-medium">Permits & Setup</span>
                <div class="flex-grow border-b-2 border-dotted border-slate-200 mx-4 relative top-[-6px]"></div>
                <span class="font-semibold tabular-nums text-slate-900 tracking-tight">$${receipt.getPermitsSetupAvg()}</span>
            </div>
        </div>

        <!-- Total Box -->
        <div class="bg-slate-50 rounded-2xl p-6 flex flex-col sm:flex-row items-start sm:items-center justify-between border border-slate-100 gap-4">
            <div>
                <p class="text-xs font-bold text-slate-400 uppercase tracking-widest">Estimated Total</p>
                <p class="text-xs text-slate-400 mt-1 font-medium">Range: $${receipt.getTotalLow()} &ndash; $${receipt.getTotalHigh()}</p>
            </div>
            <div class="font-display font-extrabold text-4xl sm:text-5xl text-slate-900 tracking-tighter tabular-nums drop-shadow-sm">
                $${receipt.getTotalAvg()}
            </div>
        </div>
        
        <!-- Semantic Table for AI / AEO Crawlers (Visually Hidden) -->
        <table class="sr-only">
            <caption>Average Local Radon Mitigation Cost Breakdown for ${receipt.getCountyName()} County</caption>
            <thead>
                <tr>
                    <th scope="col">Component</th>
                    <th scope="col">Average Cost</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>System Materials</td>
                    <td>$${receipt.getMaterialsAvg()}</td>
                </tr>
                <tr>
                    <td>Specialized Labor</td>
                    <td>$${receipt.getLaborAvg()}</td>
                </tr>
                <tr>
                    <td>Permits & Setup</td>
                    <td>$${receipt.getPermitsSetupAvg()}</td>
                </tr>
            </tbody>
            <tfoot>
                <tr>
                    <th scope="row">Estimated Total Range</th>
                    <td>$${receipt.getTotalLow()} - $${receipt.getTotalHigh()}</td>
                </tr>
                <tr>
                    <th scope="row">Average Total</th>
                    <td>$${receipt.getTotalAvg()}</td>
                </tr>
            </tfoot>
        </table>

        <!-- Context Note -->
        <div class="mt-8 flex items-start gap-3 p-4 bg-slate-50/50 rounded-xl border border-slate-100">
            <svg class="w-5 h-5 text-slate-400 mt-0.5 shrink-0" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clip-rule="evenodd"></path></svg>
            <p class="text-[13px] text-slate-500 font-medium leading-relaxed">Prices are dynamically adjusted for local market multipliers and represent standard sub-slab or basement installations. Real contractor pricing may vary based on structural complexity.</p>
        </div>
    </div>
</div>
