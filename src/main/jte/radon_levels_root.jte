@import com.radonverdict.model.County
@import com.radonverdict.model.dto.AeoAnswerBlock
@import com.radonverdict.model.dto.RadonEvidenceCoverageSummary
@import com.radonverdict.model.dto.RadonNationalEvidenceInsight
@import com.radonverdict.model.dto.TrustMetadata
@import java.util.List
@import java.util.Map

@param Map<String, List<County>> stateMap
@param long zone1Count = 0
@param long zone2Count = 0
@param long zone3Count = 0
@param int visibleCountyCount = 0
@param AeoAnswerBlock aeo = null
@param RadonEvidenceCoverageSummary evidenceCoverage = null
@param RadonNationalEvidenceInsight nationalEvidenceInsight = null
@param TrustMetadata trust = null

@template.layout.main(
    title = "County Radon Evidence and Its Limits | RadonVerdict",
    description = "A small set of source-backed county radon evidence notes. County data is context and never a home result.",
    canonicalUrl = "https://radonverdict.com/radon-levels",
    content = @`
        <main class="mx-auto max-w-5xl px-4 py-14 sm:px-6 sm:py-20">
            <p class="text-xs font-black uppercase tracking-[0.22em] text-emerald-800">County evidence</p>
            <h1 class="mt-4 max-w-4xl font-display text-4xl font-black tracking-tight text-stone-950 sm:text-6xl">A county record can explain context. It cannot clear a house.</h1>
            <p class="mt-6 max-w-3xl text-xl font-semibold leading-relaxed text-stone-600">RadonVerdict does not publish a mass directory of generated county answers. The pages below are a controlled evidence cohort selected from actual Search Console demand, historic clicks, or a source-backed local testing query.</p>

            <section class="mt-10 divide-y divide-stone-300 border-y border-stone-300">
                @for (var entry : stateMap.entrySet())
                    @for (var county : entry.getValue())
                        <a href="/radon-levels/${county.getStateSlug()}/${county.getCountySlug()}" class="group grid gap-2 py-5 sm:grid-cols-[1fr_auto] sm:items-center">
                            <span class="text-lg font-black text-stone-950 group-hover:text-emerald-800">${county.getAreaDisplayName()}, ${county.getStateAbbr()}</span>
                            <span class="text-sm font-semibold text-stone-600">EPA Zone ${county.getEpaZone()} · source-backed evidence &rarr;</span>
                        </a>
                    @endfor
                @endfor
            </section>

            <section class="mt-12 grid gap-6 rounded-3xl bg-stone-950 p-6 text-white sm:grid-cols-[1fr_auto] sm:items-center sm:p-9">
                <div><p class="text-xs font-black uppercase tracking-[0.2em] text-emerald-300">Have a home result?</p><h2 class="mt-3 font-display text-3xl font-black">Use the number from the home, not the county average.</h2><p class="mt-3 max-w-2xl font-semibold leading-relaxed text-stone-300">The planner separates your result from local context and gives no more than three next steps.</p></div>
                <a href="/plan" class="inline-flex min-h-[52px] items-center justify-center rounded-xl bg-white px-6 text-sm font-black text-stone-950">Build a plan</a>
            </section>

            <section class="mt-12 border-t border-stone-300 pt-8"><h2 class="font-display text-2xl font-black text-stone-950">Evidence rules</h2><ul class="mt-4 list-disc space-y-2 pl-6 font-semibold leading-relaxed text-stone-700"><li>Official measured summaries outrank potential maps.</li><li>Period, retrieval date, and source semantics stay visible.</li><li>A ZIP primary-county match may be wrong near a boundary.</li><li>Every home still needs its own valid test.</li></ul><a href="/radon-data-sources" class="mt-5 inline-block text-sm font-black text-emerald-800 underline">Review the source inventory</a></section>
        </main>
    `
)
