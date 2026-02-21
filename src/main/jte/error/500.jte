@param Integer statusCode

@template.layout.main(
    title = "System Overload (500) | Radon Verdict",
    description = "An unexpected server error occurred.",
    noindex = true,
    content = @`
        <div class="min-h-[80vh] flex flex-col items-center justify-center bg-slate-900 px-4 py-20 text-center relative overflow-hidden">
            <!-- Decorative blur elements -->
            <div class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-96 h-96 bg-red-500/10 rounded-full blur-3xl z-0 pointer-events-none"></div>

            <div class="relative z-10 max-w-lg mx-auto">
                <p class="font-display font-black text-[120px] text-red-500/20 leading-none tracking-tighter mb-4">500</p>
                <h1 class="font-display font-black text-3xl sm:text-5xl text-white mb-6">System Overload</h1>
                <p class="text-slate-300 text-lg mb-10 leading-relaxed font-medium">
                    Our servers just encountered an unexpected issue while processing your request. Please try again in a moment.
                </p>
                
                <div class="flex flex-col sm:flex-row items-center justify-center gap-4">
                    <button onclick="window.location.reload()" class="bg-red-600 hover:bg-red-500 text-white font-bold py-3.5 px-8 rounded-xl shadow-lg transition-transform active:scale-95 w-full sm:w-auto">
                        Refresh the Page
                    </button>
                    <a href="/" class="text-slate-300 hover:text-white font-semibold py-3.5 px-8 rounded-xl ring-1 ring-inset ring-slate-700 hover:ring-slate-500 transition-colors w-full sm:w-auto">
                        Back to Home
                    </a>
                </div>
            </div>
        </div>
    `
)
