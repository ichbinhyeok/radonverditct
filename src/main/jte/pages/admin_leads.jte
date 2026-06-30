@import com.radonverdict.model.entity.Lead
@import java.util.List
@import java.time.format.DateTimeFormatter

@param String title
@param List<Lead> leads

!{
    final long hotLeadCount = leads.stream().filter(lead -> "HOT".equals(lead.getLeadTier())).count();
    final long warmLeadCount = leads.stream().filter(lead -> "WARM".equals(lead.getLeadTier())).count();
    final long urgentLeadCount = leads.stream().filter(lead -> "urgent_24h".equals(lead.getPreferredContactTime())).count();
}

@template.layout.main(
    title = title,
    description = "Admin Leads Dashboard",
    noindex = true,
    content = @`
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 w-full">
            <div class="flex items-center justify-between mb-8">
                <h1 class="font-display font-bold text-3xl text-slate-900">Leads Dashboard</h1>
                <div class="bg-indigo-50 text-indigo-700 px-4 py-2 rounded-lg font-bold">
                    Total Leads: ${leads.size()}
                </div>
            </div>

            <div class="mb-6 grid grid-cols-1 gap-3 sm:grid-cols-3">
                <div class="rounded-xl border border-rose-200 bg-rose-50 p-4">
                    <p class="text-xs font-bold uppercase tracking-wider text-rose-700">Call first</p>
                    <p class="mt-2 font-display text-3xl font-black text-rose-900">${hotLeadCount}</p>
                    <p class="mt-1 text-xs font-semibold text-rose-800">Hot leads with strongest buying signal</p>
                </div>
                <div class="rounded-xl border border-amber-200 bg-amber-50 p-4">
                    <p class="text-xs font-bold uppercase tracking-wider text-amber-700">Work today</p>
                    <p class="mt-2 font-display text-3xl font-black text-amber-900">${warmLeadCount}</p>
                    <p class="mt-1 text-xs font-semibold text-amber-800">Warm leads worth same-day email</p>
                </div>
                <div class="rounded-xl border border-indigo-200 bg-indigo-50 p-4">
                    <p class="text-xs font-bold uppercase tracking-wider text-indigo-700">24h priority</p>
                    <p class="mt-2 font-display text-3xl font-black text-indigo-900">${urgentLeadCount}</p>
                    <p class="mt-1 text-xs font-semibold text-indigo-800">Inspection or quote deadline pressure</p>
                </div>
            </div>

            <div class="bg-white shadow-sm ring-1 ring-slate-200 sm:rounded-xl overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="min-w-full divide-y divide-slate-200">
                        <thead class="bg-slate-50">
                            <tr>
                                <th scope="col" class="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-slate-900 sm:pl-6">Date</th>
                                <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold text-slate-900">Customer</th>
                                <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold text-slate-900">Contact</th>
                                <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold text-slate-900">Location</th>
                                <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold text-slate-900">Foundation</th>
                                <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold text-slate-900">Priority</th>
                                <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold text-slate-900">Score</th>
                                <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold text-slate-900">Next Action</th>
                                <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold text-slate-900">Status</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-200 bg-white">
                            @if(leads.isEmpty())
                                <tr>
                                    <td colspan="9" class="py-8 text-center text-sm text-slate-500">No leads captured yet. Run some tests!</td>
                                </tr>
                            @else
                                @for(Lead lead : leads)
                                <tr>
                                    <td class="whitespace-nowrap py-4 pl-4 pr-3 text-sm text-slate-500 sm:pl-6">
                                        ${lead.getSubmittedAt() != null ? lead.getSubmittedAt().format(DateTimeFormatter.ofPattern("MMM dd, yyyy HH:mm")) : "N/A"}
                                    </td>
                                    <td class="whitespace-nowrap px-3 py-4 text-sm font-medium text-slate-900">
                                        ${lead.getCustomerName()}
                                    </td>
                                    <td class="whitespace-nowrap px-3 py-4 text-sm text-slate-500">
                                        <div>${lead.getCustomerPhone()}</div>
                                        @if(lead.getCustomerEmail() != null)
                                            <div class="text-xs text-slate-400">${lead.getCustomerEmail()}</div>
                                        @endif
                                    </td>
                                    <td class="whitespace-nowrap px-3 py-4 text-sm text-slate-500 uppercase">
                                        <span class="font-bold text-slate-700">${lead.getCountySlug()}</span>, ${lead.getStateAbbr()}
                                        <div class="text-xs text-slate-400">ZIP: ${lead.getZipCode()}</div>
                                    </td>
                                    <td class="whitespace-nowrap px-3 py-4 text-sm text-slate-500 capitalize">
                                        ${lead.getFoundationType()}
                                    </td>
                                    <td class="whitespace-nowrap px-3 py-4 text-sm text-slate-500">
                                        @if(lead.getPreferredContactTime() != null && !lead.getPreferredContactTime().isBlank())
                                            <span class="inline-flex items-center rounded-md bg-indigo-50 px-2 py-1 text-xs font-bold text-indigo-700 ring-1 ring-inset ring-indigo-600/20">
                                                ${lead.getPreferredContactTime()}
                                            </span>
                                        @else
                                            <span class="text-xs text-slate-400">not set</span>
                                        @endif
                                    </td>
                                    <td class="whitespace-nowrap px-3 py-4 text-sm">
                                        @if("HOT".equals(lead.getLeadTier()))
                                            <span class="inline-flex items-center rounded-md bg-rose-50 px-2 py-1 text-xs font-black text-rose-800 ring-1 ring-inset ring-rose-600/20">${lead.getLeadTier()} ${lead.getLeadScore()}</span>
                                        @elseif("WARM".equals(lead.getLeadTier()))
                                            <span class="inline-flex items-center rounded-md bg-amber-50 px-2 py-1 text-xs font-black text-amber-800 ring-1 ring-inset ring-amber-600/20">${lead.getLeadTier()} ${lead.getLeadScore()}</span>
                                        @else
                                            <span class="inline-flex items-center rounded-md bg-slate-50 px-2 py-1 text-xs font-bold text-slate-700 ring-1 ring-inset ring-slate-200">${lead.getLeadTier() != null ? lead.getLeadTier() : "UNSCORED"} ${lead.getLeadScore() != null ? lead.getLeadScore().toString() : ""}</span>
                                        @endif
                                    </td>
                                    <td class="min-w-[260px] max-w-sm px-3 py-4 text-sm text-slate-600">
                                        ${lead.getNextAction() != null ? lead.getNextAction() : "Review lead context."}
                                    </td>
                                    <td class="whitespace-nowrap px-3 py-4 text-sm">
                                        <span class="inline-flex items-center rounded-md bg-yellow-50 px-2 py-1 text-xs font-medium text-yellow-800 ring-1 ring-inset ring-yellow-600/20">
                                            ${lead.getStatus()}
                                        </span>
                                    </td>
                                </tr>
                                @endfor
                            @endif
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    `
)
