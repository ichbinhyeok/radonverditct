@import com.radonverdict.model.dto.SearchConsoleCohortReport
@import com.radonverdict.model.dto.SearchDemandProfile
@import com.radonverdict.model.dto.SeoRecoveryReport
@import com.radonverdict.model.dto.OrganicTrafficGoalReport
@import java.util.List

@param String title
@param SearchConsoleCohortReport report = null
@param boolean demandExportAvailable = false
@param List<SearchDemandProfile> demandProfiles = null
@param SeoRecoveryReport recoveryReport = null
@param OrganicTrafficGoalReport organicTrafficGoalReport = null

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

            @if(organicTrafficGoalReport != null)
                <section class="mb-8 rounded-xl border border-slate-950 bg-slate-950 p-5 text-white shadow-sm">
                    <div class="flex flex-col gap-4 lg:flex-row lg:items-end lg:justify-between">
                        <div>
                            <p class="text-xs font-bold uppercase tracking-wider ${organicTrafficGoalReport.isDailyExportAvailable() ? "text-emerald-300" : "text-amber-300"}">100 daily organic-click portfolio</p>
                            <h2 class="mt-1 font-display text-2xl font-black">${organicTrafficGoalReport.getSummary()}</h2>
                        </div>
                        <div class="rounded-xl bg-white/10 px-5 py-4 text-right">
                            <p class="text-xs font-bold uppercase tracking-wider text-slate-300">Observed daily clicks</p>
                            <p class="mt-1 font-display text-4xl font-black">${String.format(java.util.Locale.US, "%.1f", organicTrafficGoalReport.getObservedDailyClicks())}<span class="ml-1 text-lg text-slate-300">/ ${organicTrafficGoalReport.getDailyClickGoal()}</span></p>
                            @if(organicTrafficGoalReport.isDailyExportAvailable())
                                <p class="mt-1 text-xs text-slate-300">${organicTrafficGoalReport.getFirstDate()} to ${organicTrafficGoalReport.getLastDate()} · ${organicTrafficGoalReport.getDaysObserved()} days</p>
                            @endif
                        </div>
                    </div>
                    <p class="mt-4 text-sm leading-relaxed text-slate-300">Expected file: <span class="font-mono text-white">data/search-console/daily-query-page.csv</span> with Date, Query, Page, and Clicks. A 28-day aggregate must not be used here because it cannot prove daily clicks.</p>
                    <div class="mt-5 grid gap-3 md:grid-cols-2 xl:grid-cols-4">
                        @for(var cluster : organicTrafficGoalReport.getClusters())
                            <div class="rounded-xl border border-white/10 bg-white/5 p-4">
                                <p class="text-sm font-black text-white">${cluster.getName()}</p>
                                <p class="mt-2 text-2xl font-black">${String.format(java.util.Locale.US, "%.1f", cluster.getObservedDailyClicks())}<span class="text-sm font-semibold text-slate-300"> / ${cluster.getDailyClickTarget()}</span></p>
                                <p class="mt-1 text-xs leading-relaxed text-slate-300">Shortfall ${String.format(java.util.Locale.US, "%.1f", cluster.getDailyClickShortfall())} daily clicks</p>
                                <p class="mt-3 break-all text-xs leading-relaxed text-slate-400">${String.join(" · ", cluster.getPaths())}</p>
                            </div>
                        @endfor
                    </div>
                </section>
            @endif

            @if(report == null)
                <div class="rounded-xl border border-rose-200 bg-rose-50 p-5 text-sm font-semibold text-rose-800">
                    Search Console report service is unavailable.
                </div>
            @else
                <section class="mb-8 rounded-xl border border-slate-200 bg-white p-5 shadow-sm">
                    <div class="flex flex-col gap-3 md:flex-row md:items-end md:justify-between">
                        <div>
                            <p class="text-xs font-bold uppercase tracking-wider ${recoveryReport != null && recoveryReport.isSnapshotsAvailable() ? "text-emerald-700" : "text-amber-700"}">SEO recovery engine</p>
                            <h2 class="mt-1 font-display text-2xl font-black text-slate-950">${recoveryReport != null ? recoveryReport.getSummary() : "Recovery engine unavailable."}</h2>
                        </div>
                        @if(recoveryReport != null)
                            <div class="rounded-xl bg-slate-950 px-4 py-3 text-sm font-bold text-white">
                                ${recoveryReport.getSnapshotCount()} dated exports
                                @if(recoveryReport.getLatestSnapshotDate() != null)
                                    <span class="ml-2 text-slate-300">latest ${recoveryReport.getLatestSnapshotDate()}</span>
                                @endif
                            </div>
                        @endif
                    </div>
                    <p class="mt-4 text-sm leading-relaxed text-slate-600">Drop comparable query/page exports into <span class="font-mono text-slate-900">data/search-console/snapshots/query-page-YYYY-MM-DD.csv</span>. Columns: Query, Page, Clicks, Impressions, Position; add Date only when one file contains multiple days.</p>
                    @if(recoveryReport != null && recoveryReport.getActions() != null && !recoveryReport.getActions().isEmpty())
                        <div class="mt-5 overflow-x-auto rounded-xl border border-slate-200">
                            <table class="min-w-full divide-y divide-slate-200 text-left text-sm">
                                <thead class="bg-slate-50 text-xs font-black uppercase tracking-wider text-slate-500">
                                    <tr><th class="px-4 py-3">Decision</th><th class="px-4 py-3">URL / query</th><th class="px-4 py-3">Current signal</th><th class="px-4 py-3">Why this action</th></tr>
                                </thead>
                                <tbody class="divide-y divide-slate-100">
                                    @for(var action : recoveryReport.getActions())
                                        <tr>
                                            <td class="px-4 py-4"><span class="rounded-md bg-slate-950 px-2 py-1 text-xs font-black text-white">${action.getDecision()}</span><div class="mt-2 text-xs font-bold text-slate-500">${action.getCohort()} · ${action.getIndexingStatus()}</div></td>
                                            <td class="max-w-sm px-4 py-4"><a class="break-all font-bold text-indigo-700 hover:underline" href="${action.getPath()}">${action.getPath()}</a><div class="mt-2 text-xs text-slate-600">${action.getPrimaryQuery()}</div></td>
                                            <td class="px-4 py-4 text-slate-700">${String.format(java.util.Locale.US, "%.0f", action.getLatestImpressions())} impressions<br>position ${String.format(java.util.Locale.US, "%.1f", action.getLatestPosition())}<br>CTR ${String.format(java.util.Locale.US, "%.1f%%", action.getLatestCtr() * 100)}</td>
                                            <td class="min-w-[340px] px-4 py-4 leading-relaxed text-slate-600">${action.getReason()}</td>
                                        </tr>
                                    @endfor
                                </tbody>
                            </table>
                        </div>
                    @endif
                </section>
                @if(recoveryReport != null && recoveryReport.getActivationBriefs() != null && !recoveryReport.getActivationBriefs().isEmpty())
                    <section class="mb-8 rounded-xl border border-indigo-200 bg-indigo-50 p-5 shadow-sm">
                        <div class="flex flex-col gap-2 md:flex-row md:items-end md:justify-between">
                            <div>
                                <p class="text-xs font-bold uppercase tracking-wider text-indigo-700">Re-ignition release queue</p>
                                <h2 class="mt-1 font-display text-2xl font-black text-slate-950">Citation packets for the pages that can earn discovery</h2>
                            </div>
                            <p class="max-w-md text-sm leading-relaxed text-indigo-900">This creates a narrowly targeted editor packet; it never sends email automatically. Release is blocked when Search Console evidence or indexability is not ready.</p>
                        </div>
                        <div class="mt-5 space-y-4">
                            @for(var brief : recoveryReport.getActivationBriefs())
                                <article class="rounded-xl border border-indigo-200 bg-white p-5">
                                    <div class="flex flex-col gap-3 lg:flex-row lg:items-start lg:justify-between">
                                        <div>
                                            <p class="text-xs font-black uppercase tracking-wider ${"READY_TO_PITCH".equals(brief.getStatus()) ? "text-emerald-700" : "text-amber-700"}">${brief.getStatus()}</p>
                                            <h3 class="mt-1 font-display text-xl font-black text-slate-950">${brief.getPrimaryQuery()}</h3>
                                            <a href="${brief.getPath()}" class="mt-2 inline-block break-all text-sm font-bold text-indigo-700 hover:underline">${brief.getPath()}</a>
                                        </div>
                                        <a href="${brief.getPublicCitationUrl()}" class="inline-flex shrink-0 items-center justify-center rounded-lg bg-slate-950 px-4 py-2.5 text-sm font-black text-white hover:bg-slate-800">Open public citation record</a>
                                    </div>
                                    <p class="mt-4 text-sm leading-relaxed text-slate-700">${brief.getReleaseReason()}</p>
                                    <div class="mt-4 grid gap-4 lg:grid-cols-2">
                                        <div class="rounded-lg border border-slate-200 bg-slate-50 p-4">
                                            <p class="text-xs font-black uppercase tracking-wider text-slate-500">Citable claim</p>
                                            <p class="mt-2 text-sm leading-relaxed text-slate-800">${brief.getEvidenceClaim()}</p>
                                            <p class="mt-3 text-sm leading-relaxed text-slate-600"><strong>Boundary:</strong> ${brief.getClaimBoundary()}</p>
                                            <p class="mt-3 text-xs leading-relaxed text-slate-500"><strong>Pitch only to:</strong> ${brief.getTargetEditors()}</p>
                                        </div>
                                        <div class="rounded-lg border border-slate-200 bg-slate-50 p-4">
                                            <p class="text-xs font-black uppercase tracking-wider text-slate-500">Editor draft</p>
                                            <p class="mt-2 text-sm font-bold text-slate-900">${brief.getOutreachSubject()}</p>
                                            <pre class="mt-3 whitespace-pre-wrap break-words font-sans text-sm leading-relaxed text-slate-700">${brief.getOutreachBody()}</pre>
                                        </div>
                                    </div>
                                </article>
                            @endfor
                        </div>
                    </section>
                @endif
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
                            <h2 class="mt-1 font-display text-xl font-black text-slate-950">Static watchlist retired</h2>
                        </div>
                        <p class="max-w-md text-sm leading-relaxed text-emerald-900">
                            The dated recovery engine above is the authority for query decisions. Do not use old cost-page examples to choose a target URL.
                        </p>
                    </div>
                    <div class="mt-5 overflow-hidden rounded-xl border border-emerald-200 bg-white">
                        <div class="overflow-x-auto">
                            <p class="p-4 text-sm leading-relaxed text-slate-600">The target must be indexable and match one canonical intent. A quarantined cost URL is never an SEO recovery target.</p>
                        </div>
                    </div>
                </section>

                <section class="mb-8 rounded-xl border border-amber-200 bg-amber-50 p-5">
                    <div class="flex flex-col gap-2 md:flex-row md:items-end md:justify-between">
                        <div>
                            <p class="text-xs font-bold uppercase tracking-wider text-amber-700">Demand opportunity loop</p>
                            <h2 class="mt-1 font-display text-xl font-black text-slate-950">Pages to improve before creating more URLs</h2>
                        </div>
                        <p class="max-w-md text-sm leading-relaxed text-amber-900">
                            ${demandExportAvailable ? "Legacy single-window view only. Use the dated recovery engine above for a change decision." : "No current single-window export is loaded; the dated recovery engine remains the source of truth."}
                        </p>
                    </div>
                    @if(demandExportAvailable && demandProfiles != null && !demandProfiles.isEmpty())
                        <div class="mt-5 overflow-x-auto rounded-xl border border-amber-200 bg-white">
                            <table class="min-w-full divide-y divide-slate-200 text-left text-sm">
                                <thead class="bg-amber-100 text-xs font-black uppercase tracking-wider text-amber-800">
                                    <tr>
                                        <th class="px-4 py-3">Query</th>
                                        <th class="px-4 py-3">Page</th>
                                        <th class="px-4 py-3">Intent</th>
                                        <th class="px-4 py-3">Impressions</th>
                                        <th class="px-4 py-3">Position</th>
                                        <th class="px-4 py-3">Opportunity</th>
                                        <th class="px-4 py-3">Next move</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-slate-100">
                                    @for(var profile : demandProfiles)
                                        <tr>
                                            <td class="max-w-xs px-4 py-4 font-black text-slate-950">${profile.getPrimaryQuery().isBlank() ? "No query export yet" : profile.getPrimaryQuery()}</td>
                                            <td class="max-w-sm px-4 py-4 break-all"><a href="${profile.getPath()}" class="font-bold text-indigo-700 hover:underline">${profile.getPath()}</a></td>
                                            <td class="px-4 py-4 font-bold text-slate-700">${profile.getIntent()}</td>
                                            <td class="px-4 py-4 text-slate-700">${String.format(java.util.Locale.US, "%,.0f", profile.getImpressions())}</td>
                                            <td class="px-4 py-4 text-slate-700">${String.format(java.util.Locale.US, "%.1f", profile.getAveragePosition())}</td>
                                            <td class="px-4 py-4 font-black text-amber-700">${String.format(java.util.Locale.US, "%.0f", profile.getOpportunityScore())}</td>
                                            <td class="min-w-[280px] px-4 py-4 text-slate-600">${profile.getRecommendedAction()}</td>
                                        </tr>
                                    @endfor
                                </tbody>
                            </table>
                        </div>
                    @else
                        <div class="mt-5 rounded-xl border border-amber-200 bg-white p-4 text-sm leading-relaxed text-slate-600">
                            No page/query rows are available yet. The site keeps its current recovery and growth fallback until the export is present.
                        </div>
                    @endif
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
