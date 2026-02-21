@param Integer statusCode

@template.layout.main(
    title = "Something Went Wrong | Radon Verdict",
    description = "An error occurred.",
    noindex = true,
    content = @`
        <div class="min-h-[80vh] flex flex-col items-center justify-center bg-slate-900 px-4 py-20 text-center relative overflow-hidden">
            <div class="relative z-10 max-w-lg mx-auto">
                <p class="font-display font-black text-[100px] text-slate-700 leading-none tracking-tighter mb-4">${statusCode != null ? String.valueOf(statusCode) : "Oops"}</p>
                <h1 class="font-display font-black text-3xl sm:text-5xl text-white mb-6">An Error Occurred</h1>
                <p class="text-slate-300 text-lg mb-10 leading-relaxed font-medium">
                    Sorry, something unexpected happened while trying to reach this page.
                </p>
                <a href="/" class="bg-brand-500 hover:bg-brand-400 text-white font-bold py-3.5 px-8 rounded-xl shadow-lg transition-transform active:scale-95 inline-block">
                    Return to Home
                </a>
            </div>
        </div>
    `
)
