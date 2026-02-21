@import com.radonverdict.model.entity.Lead
@import java.util.List
@import java.time.format.DateTimeFormatter

@param String title
@param List<Lead> leads

@template.layout.main(
    title = title,
    description = "Admin Leads Dashboard",
    content = @`
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-10 w-full">
            <div class="flex items-center justify-between mb-8">
                <h1 class="font-display font-bold text-3xl text-slate-900">Leads Dashboard</h1>
                <div class="bg-indigo-50 text-indigo-700 px-4 py-2 rounded-lg font-bold">
                    Total Leads: ${leads.size()}
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
                                <th scope="col" class="px-3 py-3.5 text-left text-sm font-semibold text-slate-900">Status</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-200 bg-white">
                            @if(leads.isEmpty())
                                <tr>
                                    <td colspan="6" class="py-8 text-center text-sm text-slate-500">No leads captured yet. Run some tests!</td>
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
