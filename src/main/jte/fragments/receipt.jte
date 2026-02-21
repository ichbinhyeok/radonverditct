@import com.radonverdict.model.dto.CountyPageContent
@param CountyPageContent page

<!-- This div gets swapped entirely by HTMX when the form changes -->
<div id="receipt-container" class="space-y-6 animate-[fadeIn_0.5s_ease-out]">
    
    <!-- Component 1: The Receipt Card -->
    @template.components.receipt_card(receipt = page.getReceipt())
    
    <!-- Component 2: The Strategy Box -->
    @template.components.negotiation_box(page = page)

    <!-- Component 3: Mobile Sticky Floating Action Bar (Updated via HTMX) -->
    <div class="fixed bottom-0 left-0 right-0 bg-slate-900 border-t border-slate-700 p-4 z-50 lg:hidden shadow-[0_-15px_40px_rgba(0,0,0,0.3)]">
        <div class="flex items-center justify-between max-w-lg mx-auto px-2">
            <div class="flex flex-col">
                <p class="text-[10px] font-bold text-slate-400 uppercase tracking-widest leading-none mb-1.5">Est. Total</p>
                <p class="font-display font-extrabold text-2xl text-white tabular-nums leading-none">$${page.getReceipt().getTotalAvg()}</p>
            </div>
            <a href="#estimate-form" onclick="event.preventDefault(); document.getElementById('estimate-form').scrollIntoView({behavior: 'smooth'})" class="bg-indigo-600 hover:bg-indigo-500 text-white text-sm font-bold py-2.5 px-6 rounded-xl shadow-md whitespace-nowrap transition-transform active:scale-95 flex items-center gap-2">
                Get Quotes
                <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path stroke-linecap="round" stroke-linejoin="round" d="M14 5l7 7m0 0l-7 7m7-7H3"/></svg>
            </a>
        </div>
    </div>

</div>

<style>
@keyframes fadeIn {
    from { opacity: 0; transform: translateY(10px); }
    to { opacity: 1; transform: translateY(0); }
}
</style>
