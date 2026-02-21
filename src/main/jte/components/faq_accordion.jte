@import com.radonverdict.model.dto.CountyPageContent
@param CountyPageContent page

<div class="space-y-4">
    <h3 class="font-display font-extrabold text-slate-900 text-2xl tracking-tight mb-8">Frequently Asked Questions</h3>
    
    <div x-data="{ active: null }" class="divide-y divide-slate-100 border-t border-slate-100">
        @for(int i = 0; i < page.getFaqs().size(); i++)
            <div class="py-5" x-data="{ id: ${i}, get isOpen() { return this.active === this.id } }">
                <button 
                    @click="active = isOpen ? null : id"
                    class="flex w-full items-center justify-between text-left focus:outline-none group">
                    <span class="font-medium text-slate-900 group-hover:text-amber-600 transition-colors duration-200">
                        ${page.getFaqs().get(i).getQuestion()}
                    </span>
                    <span class="ml-6 flex h-7 w-7 items-center justify-center rounded-full border border-slate-200 bg-white group-hover:border-amber-200 group-hover:bg-amber-50">
                        <!-- Plus icon (when closed) -->
                        <svg x-show="!isOpen" class="h-4 w-4 text-slate-400 group-hover:text-amber-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M12 4v16m8-8H4" />
                        </svg>
                        <!-- Minus icon (when open) -->
                        <svg x-show="isOpen" style="display: none;" class="h-4 w-4 text-amber-600" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M20 12H4" />
                        </svg>
                    </span>
                </button>
                <div x-show="isOpen" 
                    x-collapse 
                    x-cloak
                    class="prose prose-slate prose-sm mt-4 text-slate-600 leading-relaxed font-medium">
                    <p>${page.getFaqs().get(i).getAnswer()}</p>
                </div>
            </div>
        @endfor
    </div>
</div>
