@param String stateName
@param String stateAbbr
@param String stateProgramUrl = null
@param boolean disclosureRequired = false
@param String disclosureSummary = null
@param boolean licenseRequired = false
@param String licenseNote = null
@param String className = "mt-10"

@if((stateProgramUrl != null && !stateProgramUrl.isBlank())
    || (disclosureSummary != null && !disclosureSummary.isBlank())
    || (licenseNote != null && !licenseNote.isBlank()))
<section class="${className} rounded-2xl border border-slate-200 bg-white p-5 sm:p-6">
    <div class="flex flex-col gap-4 md:flex-row md:items-start md:justify-between">
        <div>
            <p class="text-xs font-bold uppercase tracking-wider text-slate-500">Official State Resource</p>
            <h3 class="mt-1 font-display text-xl font-bold text-slate-900">${stateName} radon program and rules</h3>
            <p class="mt-2 max-w-2xl text-sm leading-relaxed text-slate-600">
                Use the state program link to verify local radon guidance, disclosure language, and contractor credential expectations before you act on an estimate.
            </p>
        </div>
        @if(stateProgramUrl != null && !stateProgramUrl.isBlank())
            <a href="${stateProgramUrl}"
               target="_blank"
               rel="noopener"
               class="inline-flex shrink-0 items-center justify-center rounded-xl border border-slate-200 bg-slate-900 px-4 py-2.5 text-sm font-bold text-white transition-colors hover:bg-slate-800">
                Open official ${stateAbbr} resource
            </a>
        @endif
    </div>

    <div class="mt-5 grid grid-cols-1 gap-3 md:grid-cols-2">
        @if(disclosureSummary != null && !disclosureSummary.isBlank())
            <div class="rounded-xl border border-slate-200 bg-slate-50 p-4">
                <p class="text-xs font-bold uppercase tracking-wider ${disclosureRequired ? "text-amber-700" : "text-slate-500"}">
                    ${disclosureRequired ? "Disclosure rule tracked" : "Disclosure note"}
                </p>
                <p class="mt-2 text-sm leading-relaxed text-slate-700">${disclosureSummary}</p>
            </div>
        @endif
        @if(licenseNote != null && !licenseNote.isBlank())
            <div class="rounded-xl border border-slate-200 bg-slate-50 p-4">
                <p class="text-xs font-bold uppercase tracking-wider ${licenseRequired ? "text-amber-700" : "text-slate-500"}">
                    ${licenseRequired ? "State licensing required" : "Credential note"}
                </p>
                <p class="mt-2 text-sm leading-relaxed text-slate-700">${licenseNote}</p>
            </div>
        @endif
    </div>
</section>
@endif
