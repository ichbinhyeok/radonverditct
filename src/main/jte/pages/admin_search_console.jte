@import com.radonverdict.model.dto.SearchConsoleCohortReport

@param String title
@param SearchConsoleCohortReport report = null

@template.layout.main(
    title = title,
    description = "Admin Search Console cohort report",
    noindex = true,
    content = @`
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 w-full">
            <div class="mb-8 flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
                <div>
                    <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Indexing operations</p>
                    <h1 class="mt-1 font-display text-3xl font-black text-slate-950">Search Console Cohorts</h1>
                    <p class="mt-2 max-w-3xl text-sm leading-relaxed text-slate-600">
                        Compare the URLs we expect in each sitemap cohort against a Search Console Page indexing CSV export.
                    </p>
                </div>
                <a href="/admin/leads" class="inline-flex items-center justify-center rounded-lg border border-slate-200 bg-white px-4 py-2 text-sm font-bold text-slate-700 hover:bg-slate-50">
                    Leads dashboard
                </a>
            </div>

            @if(report == null)
                <div class="rounded-xl border border-rose-200 bg-rose-50 p-5 text-sm font-semibold text-rose-800">
                    Search Console report service is unavailable.
                </div>
            @else
                <section class="mb-6 rounded-xl border border-slate-200 bg-white p-5 shadow-sm">
                    <div class="grid gap-4 lg:grid-cols-[1fr_0.45fr] lg:items-center">
                        <div>
                            <p class="text-xs font-bold uppercase tracking-wider ${report.isExportAvailable() ? "text-emerald-700" : "text-amber-700"}">
                                ${report.isExportAvailable() ? "GSC export loaded" : "GSC export missing"}
                            </p>
                            <h2 class="mt-2 font-display text-2xl font-black text-slate-950">${report.getSummary()}</h2>
                            <p class="mt-2 text-sm leading-relaxed text-slate-600">
                                Expected path: <span class="font-mono text-slate-900">${report.getExportPath()}</span>
                            </p>
                        </div>
                        <div class="rounded-xl bg-slate-950 p-4 text-white">
                            <p class="text-xs font-bold uppercase tracking-wider text-slate-300">Exported URLs matched</p>
                            <p class="mt-2 font-display text-4xl font-black">${report.getExportedUrlCount()}</p>
                            <p class="mt-1 text-xs leading-relaxed text-slate-300">Use GSC Page indexing export, not the noisy site: operator.</p>
                        </div>
                    </div>
                </section>

                <section class="mb-8 overflow-hidden rounded-xl border border-slate-200 bg-white shadow-sm">
                    <div class="border-b border-slate-200 bg-slate-50 px-5 py-4">
                        <h2 class="font-display text-xl font-black text-slate-950">Sitemap cohort status</h2>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="min-w-full divide-y divide-slate-200">
                            <thead class="bg-white">
                                <tr>
                                    <th class="px-4 py-3 text-left text-xs font-black uppercase tracking-wider text-slate-500">Cohort</th>
                                    <th class="px-4 py-3 text-left text-xs font-black uppercase tracking-wider text-slate-500">Expected</th>
                                    <th class="px-4 py-3 text-left text-xs font-black uppercase tracking-wider text-slate-500">Seen</th>
                                    <th class="px-4 py-3 text-left text-xs font-black uppercase tracking-wider text-slate-500">Indexed</th>
                                    <th class="px-4 py-3 text-left text-xs font-black uppercase tracking-wider text-slate-500">Crawled not indexed</th>
                                    <th class="px-4 py-3 text-left text-xs font-black uppercase tracking-wider text-slate-500">Discovered not indexed</th>
                                    <th class="px-4 py-3 text-left text-xs font-black uppercase tracking-wider text-slate-500">Action</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-slate-100">
                                @for(var row : report.getCohortRows())
                                    <tr>
                                        <td class="px-4 py-4 text-sm font-black text-slate-950">
                                            ${row.getCohort()}
                                            <div class="mt-1 text-xs font-normal text-slate-500">${row.getSitemapUrl()}</div>
                                        </td>
                                        <td class="px-4 py-4 text-sm text-slate-700">${row.getExpectedUrlCount()}</td>
                                        <td class="px-4 py-4 text-sm text-slate-700">${row.getSeenInExportCount()}</td>
                                        <td class="px-4 py-4 text-sm font-bold text-emerald-700">${row.getIndexedCount()}</td>
                                        <td class="px-4 py-4 text-sm font-bold text-amber-700">${row.getCrawledNotIndexedCount()}</td>
                                        <td class="px-4 py-4 text-sm font-bold text-rose-700">${row.getDiscoveredNotIndexedCount()}</td>
                                        <td class="min-w-[280px] px-4 py-4 text-sm leading-relaxed text-slate-600">${row.getAction()}</td>
                                    </tr>
                                @endfor
                            </tbody>
                        </table>
                    </div>
                </section>

                <section class="mb-8 rounded-xl border border-indigo-200 bg-indigo-50 p-5">
                    <div class="flex flex-col gap-2 md:flex-row md:items-end md:justify-between">
                        <div>
                            <p class="text-xs font-bold uppercase tracking-wider text-indigo-700">Submit or refresh in GSC</p>
                            <h2 class="mt-1 font-display text-xl font-black text-slate-950">Use these sitemap URLs as the control panel</h2>
                        </div>
                        <p class="max-w-md text-sm leading-relaxed text-indigo-900">
                            Submit the sitemap, wait for crawl data, export Page indexing URLs, then reload this dashboard.
                        </p>
                    </div>
                    <div class="mt-5 grid gap-3 md:grid-cols-2">
                        @for(var row : report.getCohortRows())
                            <div class="rounded-xl border border-indigo-200 bg-white p-4">
                                <p class="text-xs font-black uppercase tracking-wider text-slate-500">${row.getCohort()}</p>
                                <p class="mt-2 break-all font-mono text-sm text-slate-900">${row.getSitemapUrl()}</p>
                                <p class="mt-2 text-xs leading-relaxed text-slate-500">${row.getAction()}</p>
                            </div>
                        @endfor
                    </div>
                </section>

                <section class="mb-8 rounded-xl border border-emerald-200 bg-emerald-50 p-5">
                    <div class="flex flex-col gap-2 md:flex-row md:items-end md:justify-between">
                        <div>
                            <p class="text-xs font-bold uppercase tracking-wider text-emerald-700">Query watchlist</p>
                            <h2 class="mt-1 font-display text-xl font-black text-slate-950">Patch titles and inspect the page that matches the query</h2>
                        </div>
                        <p class="max-w-md text-sm leading-relaxed text-emerald-900">
                            Use this after the sitemap check: query intent first, target URL second, cost or ledger action third.
                        </p>
                    </div>
                    <div class="mt-5 overflow-hidden rounded-xl border border-emerald-200 bg-white">
                        <div class="overflow-x-auto">
                            <table class="min-w-full divide-y divide-slate-200 text-left text-sm">
                                <thead class="bg-emerald-50 text-xs font-black uppercase tracking-wider text-emerald-700">
                                    <tr>
                                        <th class="px-4 py-3">Query family</th>
                                        <th class="px-4 py-3">Target URL</th>
                                        <th class="px-4 py-3">Page job</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-slate-100">
                                    <tr>
                                        <td class="px-4 py-4 font-black text-slate-950">radon gas testing Ulster County NY</td>
                                        <td class="px-4 py-4"><a href="/radon-levels/new-york/ulster-county" class="font-bold text-indigo-700 hover:underline">/radon-levels/new-york/ulster-county</a></td>
                                        <td class="px-4 py-4 text-slate-600">Testing answer first, then 4.0+ cost and quote ledger.</td>
                                    </tr>
                                    <tr>
                                        <td class="px-4 py-4 font-black text-slate-950">commercial radon Los Angeles CA</td>
                                        <td class="px-4 py-4"><a href="/radon-levels/california/los-angeles-county" class="font-bold text-indigo-700 hover:underline">/radon-levels/california/los-angeles-county</a></td>
                                        <td class="px-4 py-4 text-slate-600">Commercial scope, provider lookup, then cost/quote screen.</td>
                                    </tr>
                                    <tr>
                                        <td class="px-4 py-4 font-black text-slate-950">radon testing Boulder CO</td>
                                        <td class="px-4 py-4"><a href="/radon-levels/colorado/boulder-county" class="font-bold text-indigo-700 hover:underline">/radon-levels/colorado/boulder-county</a></td>
                                        <td class="px-4 py-4 text-slate-600">Testing-to-mitigation bridge and contractor quote checklist.</td>
                                    </tr>
                                    <tr>
                                        <td class="px-4 py-4 font-black text-slate-950">radon testing Loudoun County</td>
                                        <td class="px-4 py-4"><a href="/radon-levels/virginia/loudoun-county" class="font-bold text-indigo-700 hover:underline">/radon-levels/virginia/loudoun-county</a></td>
                                        <td class="px-4 py-4 text-slate-600">Official VA signal, testing answer, ZIP-cost bridge.</td>
                                    </tr>
                                    <tr>
                                        <td class="px-4 py-4 font-black text-slate-950">St Louis radon</td>
                                        <td class="px-4 py-4"><a href="/radon-levels/missouri/st-louis-county" class="font-bold text-indigo-700 hover:underline">/radon-levels/missouri/st-louis-county</a></td>
                                        <td class="px-4 py-4 text-slate-600">Missouri DHSS evidence, result-band explanation, cost path.</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </section>

                <section class="rounded-xl border border-slate-200 bg-white p-5 shadow-sm">
                    <div class="flex flex-col gap-2 md:flex-row md:items-end md:justify-between">
                        <div>
                            <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Manual URL inspection queue</p>
                            <h2 class="mt-1 font-display text-xl font-black text-slate-950">Inspect these before expanding volume</h2>
                        </div>
                        <p class="text-sm text-slate-500">Prioritized recovery, growth, then cost evidence.</p>
                    </div>
                    <div class="mt-5 grid grid-cols-1 gap-3 lg:grid-cols-2">
                        @for(var row : report.getRecommendedInspectionRows())
                            <div class="rounded-xl border border-slate-200 bg-slate-50 p-4">
                                <div class="flex items-start justify-between gap-3">
                                    <p class="min-w-0 break-all text-sm font-bold text-slate-950">${row.getUrl()}</p>
                                    <span class="shrink-0 rounded-md bg-white px-2 py-1 text-xs font-black uppercase tracking-wider text-slate-600">${row.getCohort()}</span>
                                </div>
                                <p class="mt-2 text-xs font-bold text-slate-500">${row.getStatus()}</p>
                                <p class="mt-1 text-sm leading-relaxed text-slate-600">${row.getReason()}</p>
                            </div>
                        @endfor
                    </div>
                </section>
            @endif
        </div>
    `
)
