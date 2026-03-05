@import com.radonverdict.model.County
@import java.util.List

@param String stateSlug
@param String stateAbbr
@param List<County> counties
@param long zone1Count = 0
@param long zone2Count = 0
@param long zone3Count = 0
@param boolean noindex = false

!{
    String[] stateSlugParts = stateSlug.split("-");
    StringBuilder stateNameBuilder = new StringBuilder();
    for (int i = 0; i < stateSlugParts.length; i++) {
        String part = stateSlugParts[i];
        if (part == null || part.isBlank()) {
            continue;
        }
        String normalized = part.toLowerCase(java.util.Locale.ROOT);
        String displayPart;
        if (i > 0 && ("of".equals(normalized) || "and".equals(normalized))) {
            displayPart = normalized;
        } else {
            displayPart = normalized.substring(0, 1).toUpperCase(java.util.Locale.ROOT) + normalized.substring(1);
        }
        if (stateNameBuilder.length() > 0) {
            stateNameBuilder.append(" ");
        }
        stateNameBuilder.append(displayPart);
    }
    final String stateName = stateNameBuilder.length() > 0 ? stateNameBuilder.toString() : stateAbbr;
}

@template.layout.main(
    title = stateName + " Radon Zone Map by County (" + java.time.LocalDate.now().getYear() + ") | EPA 4.0 pCi/L Guide",
    description = "Interactive " + stateName + " radon zone map with county-level EPA data. Check risk tier, understand the 4.0 pCi/L action threshold, and see testing and mitigation next steps.",
    canonicalUrl = "https://radonverdict.com/radon-levels/" + stateSlug,
    noindex = noindex,
    content = @`
        <div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-10">

            <!-- Breadcrumb -->
            <nav class="text-sm font-medium text-slate-500 mb-8" aria-label="Breadcrumb">
                <ol class="inline-flex items-center space-x-2">
                    <li><a href="/" class="hover:text-slate-900 transition-colors">Home</a></li>
                    <li><span class="mx-1 text-slate-300">/</span></li>
                    <li class="text-slate-900 font-semibold" aria-current="page">${stateName} Radon Levels</li>
                </ol>
            </nav>

            <!-- Hero -->
            <div class="text-center mb-12">
                <div class="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-slate-100 text-xs font-bold text-slate-600 uppercase tracking-widest mb-6">
                    <span class="w-2 h-2 rounded-full bg-indigo-500"></span>
                    EPA Zone Data ${java.time.LocalDate.now().getYear()}
                </div>

                <h1 class="font-display font-black text-4xl sm:text-5xl text-slate-900 mb-4">${stateName} Radon Levels</h1>
                <p class="text-lg text-slate-600 max-w-2xl mx-auto">
                    View EPA radon zone classifications for every county in ${stateName}. Select your county to see detailed risk data, testing recommendations, and mitigation cost estimates.
                </p>
            </div>

            <!-- Zone Breakdown Stats -->
            <div class="grid grid-cols-3 gap-4 max-w-xl mx-auto mb-12">
                <div class="text-center p-4 rounded-2xl bg-red-50 border border-red-100">
                    <div class="font-display font-black text-2xl text-red-600">${zone1Count}</div>
                    <div class="text-xs font-bold text-red-500 uppercase tracking-wider mt-1">Zone 1<br>High Risk</div>
                </div>
                <div class="text-center p-4 rounded-2xl bg-amber-50 border border-amber-100">
                    <div class="font-display font-black text-2xl text-amber-600">${zone2Count}</div>
                    <div class="text-xs font-bold text-amber-500 uppercase tracking-wider mt-1">Zone 2<br>Moderate</div>
                </div>
                <div class="text-center p-4 rounded-2xl bg-emerald-50 border border-emerald-100">
                    <div class="font-display font-black text-2xl text-emerald-600">${zone3Count}</div>
                    <div class="text-xs font-bold text-emerald-500 uppercase tracking-wider mt-1">Zone 3<br>Low Risk</div>
                </div>
            </div>

            <!-- County Directory -->
            <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-3">
                @for(var c : counties)
                    <a href="/radon-levels/${c.getStateSlug()}/${c.getCountySlug()}"
                       class="flex items-center justify-between p-4 rounded-xl bg-white border border-slate-200 hover:border-indigo-300 hover:shadow-md transition-all group">
                        <div>
                            <span class="block font-semibold text-sm text-slate-800 group-hover:text-indigo-600 transition-colors">${c.getAreaDisplayName()}</span>
                            <span class="text-xs
                                @if(c.getEpaZone() == 1) text-red-500
                                @elseif(c.getEpaZone() == 2) text-amber-500
                                @else text-emerald-500
                                @endif
                            ">Zone ${c.getEpaZone()}</span>
                        </div>
                        <span class="w-2.5 h-2.5 rounded-full shrink-0
                            @if(c.getEpaZone() == 1) bg-red-400
                            @elseif(c.getEpaZone() == 2) bg-amber-400
                            @else bg-emerald-400
                            @endif
                        "></span>
                    </a>
                @endfor
            </div>

            <!-- CTA at the bottom -->
            <div class="mt-16 text-center">
                <p class="text-sm text-slate-500 mb-4">Already tested? Get your itemized mitigation cost estimate.</p>
                <a href="/radon-mitigation-cost/${stateSlug}"
                   class="inline-flex items-center gap-2 px-6 py-3.5 rounded-xl bg-slate-900 text-white font-bold text-sm hover:bg-slate-800 transition-colors shadow-sm">
                    <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M9 7h6m0 10v-3m-3 3h.01M9 17h.01M9 14h.01M12 14h.01M15 11h.01M12 11h.01M9 11h.01M7 21h10a2 2 0 002-2V5a2 2 0 00-2-2H7a2 2 0 00-2 2v14a2 2 0 002 2z" />
                    </svg>
                    View ${stateName} Mitigation Cost Estimates ->
                </a>
            </div>
        </div>
    `
)

