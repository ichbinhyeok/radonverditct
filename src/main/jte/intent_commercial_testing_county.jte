@import com.radonverdict.model.County
@import com.radonverdict.model.dto.CountyRadonEvidence
@import com.radonverdict.model.dto.TrustMetadata
@import com.radonverdict.util.JsonLdUtils

@param County county
@param CountyRadonEvidence evidence
@param TrustMetadata trust = null
@param String canonicalUrl

!{
    final String placeLabel = county.getAreaDisplayName() + ", " + county.getStateAbbr();
    final String levelsPath = "/radon-levels/" + county.getStateSlug() + "/" + county.getCountySlug();
    final String seoTitle = "Commercial Radon Testing in " + placeLabel + " | Building Protocol";
    final String seoDescription = "Commercial and multifamily radon testing in " + placeLabel + ": building scope, ground-contact locations, California provider verification, result handling, and mitigation bid checklist.";
    final String cdphProviders = "https://www.cdph.ca.gov/Programs/CEH/DRSEM/Pages/EMB/Radon/Certified-Radon-Services-Providers.aspx";
    final String cdphStandards = "https://www.cdph.ca.gov/Programs/CEH/DRSEM/Pages/EMB/Radon/Radon-Regulations-and-Standards.aspx";
    final String epaStandards = "https://www.epa.gov/radon/radon-standards-practice";
}

@template.layout.main(
    title = seoTitle,
    description = seoDescription,
    canonicalUrl = canonicalUrl,
    headContent = @`
        <script type="application/ld+json">
        {
          "@context":"https://schema.org",
          "@type":"WebPage",
          "name":$unsafe{JsonLdUtils.json(seoTitle)},
          "url":$unsafe{JsonLdUtils.json(canonicalUrl)},
          "description":$unsafe{JsonLdUtils.json(seoDescription)},
          "inLanguage":"en-US",
          "about":[{"@type":"Thing","name":"Commercial radon testing"},{"@type":"Place","name":$unsafe{JsonLdUtils.json(placeLabel)}}]
        }
        </script>
        <script type="application/ld+json">
        {
          "@context":"https://schema.org",
          "@type":"FAQPage",
          "mainEntity":[{
            "@type":"Question",
            "name":"How is commercial radon testing different from a home test?",
            "acceptedAnswer":{"@type":"Answer","text":"A commercial, multifamily, school, or mixed-use building needs a building-wide measurement plan. The plan should identify ground-contact areas, occupied lower levels, upper-floor sampling, device controls, access constraints, and location-by-location reporting before devices are placed."}
          },{
            "@type":"Question",
            "name":"How do I verify a commercial radon tester in California?",
            "acceptedAnswer":{"@type":"Answer","text":"Check the California Department of Public Health certified-provider list and confirm the provider's current certification. Ask which ANSI/AARST standard the written measurement plan follows."}
          }]
        }
        </script>
    `,
    content = @`
      <main class="mx-auto w-full max-w-6xl px-4 py-10 sm:px-6 lg:px-8">
        <nav class="mb-8 text-sm font-semibold text-slate-500" aria-label="Breadcrumb">
          <a href="/" class="hover:text-slate-900">Home</a><span class="mx-2 text-slate-300">/</span>
          <a href="${levelsPath}" class="hover:text-slate-900">Los Angeles County radon</a><span class="mx-2 text-slate-300">/</span>
          <span class="text-slate-900">Commercial testing</span>
        </nav>

        <header class="grid gap-8 lg:grid-cols-[1.12fr_0.88fr] lg:items-start">
          <div>
            <p class="text-xs font-black uppercase tracking-[0.2em] text-cyan-700">Commercial · multifamily · mixed-use</p>
            <h1 class="mt-3 font-display text-4xl font-black tracking-tight text-slate-950 sm:text-5xl">Commercial Radon Testing in ${placeLabel}</h1>
            <p class="mt-5 max-w-3xl text-lg leading-relaxed text-slate-700">Do not buy a one-room test and call the building cleared. Start with a written measurement plan that identifies every ground-contact occupancy, the required upper-floor sample, quality-control devices, access windows, and the report each location will receive.</p>
            <div class="mt-7 flex flex-col gap-3 sm:flex-row">
              <a href="#scope" class="inline-flex min-h-12 items-center justify-center rounded-xl bg-slate-950 px-5 text-sm font-black text-white hover:bg-slate-800">Build the testing scope</a>
              <a href="${cdphProviders}" target="_blank" rel="noopener" class="inline-flex min-h-12 items-center justify-center rounded-xl border border-slate-300 bg-white px-5 text-sm font-black text-slate-800 hover:bg-slate-50">Verify a California provider</a>
            </div>
          </div>
          <aside class="rounded-2xl border border-cyan-200 bg-cyan-50 p-6">
            <p class="text-xs font-black uppercase tracking-wider text-cyan-700">The first deliverable</p>
            <h2 class="mt-2 font-display text-2xl font-black text-slate-950">A location map, not a price quote</h2>
            <p class="mt-4 leading-relaxed text-slate-700">Ask the tester to mark sampled and unsampled rooms by floor, explain the applicable building protocol, and report results by location. Do not average separate units or floors into one reassuring building number.</p>
          </aside>
        </header>

        <section id="scope" class="mt-10 rounded-2xl border border-slate-200 bg-white p-6 shadow-sm sm:p-8">
          <p class="text-xs font-black uppercase tracking-wider text-indigo-700">Scope before devices</p>
          <h2 class="mt-2 font-display text-3xl font-black text-slate-950">What the proposal must define</h2>
          <div class="mt-7 grid gap-4 md:grid-cols-2">
            <article class="rounded-2xl border border-slate-200 bg-slate-50 p-5"><p class="text-xs font-black uppercase tracking-wider text-indigo-700">1. Building inventory</p><h3 class="mt-2 text-lg font-black text-slate-950">Every ground-contact space</h3><p class="mt-2 text-sm leading-relaxed text-slate-600">Count units, offices, classrooms, retail, storage, maintenance, mechanical, crawl-space, and slab areas that are occupied or communicate with occupied space.</p></article>
            <article class="rounded-2xl border border-slate-200 bg-slate-50 p-5"><p class="text-xs font-black uppercase tracking-wider text-indigo-700">2. Measurement protocol</p><h3 class="mt-2 text-lg font-black text-slate-950">The standard and sample plan</h3><p class="mt-2 text-sm leading-relaxed text-slate-600">Name the current ANSI/AARST standard, test duration, closed-building conditions, upper-floor sampling, duplicates, blanks, spikes, and device custody.</p></article>
            <article class="rounded-2xl border border-slate-200 bg-slate-50 p-5"><p class="text-xs font-black uppercase tracking-wider text-indigo-700">3. Occupant operations</p><h3 class="mt-2 text-lg font-black text-slate-950">Access and tamper control</h3><p class="mt-2 text-sm leading-relaxed text-slate-600">Define tenant notices, room access, HVAC operation, device protection, after-hours entry, invalid-test handling, and who documents deviations.</p></article>
            <article class="rounded-2xl border border-slate-200 bg-slate-50 p-5"><p class="text-xs font-black uppercase tracking-wider text-indigo-700">4. Report and next bid</p><h3 class="mt-2 text-lg font-black text-slate-950">Results by location</h3><p class="mt-2 text-sm leading-relaxed text-slate-600">Require a floor plan, device log, location result, QA record, retest rule, and a separation between measurement findings and any mitigation proposal.</p></article>
          </div>
        </section>

        <section class="mt-8 grid gap-6 lg:grid-cols-[0.92fr_1.08fr]">
          <div class="rounded-2xl border border-amber-200 bg-amber-50 p-6">
            <p class="text-xs font-black uppercase tracking-wider text-amber-700">California verification</p>
            <h2 class="mt-2 font-display text-2xl font-black text-slate-950">Certification is part of the scope</h2>
            <p class="mt-4 text-sm leading-relaxed text-slate-700">CDPH states that radon service providers operating in California must be approved through the recognized national certification programs. Confirm the tester and the expiration date before relying on transaction, school, multifamily, or non-residential results.</p>
            <div class="mt-5 flex flex-col gap-2"><a href="${cdphProviders}" target="_blank" rel="noopener" class="font-black text-amber-900 hover:underline">CDPH certified provider list →</a><a href="${cdphStandards}" target="_blank" rel="noopener" class="font-black text-amber-900 hover:underline">California radon standards →</a><a href="${epaStandards}" target="_blank" rel="noopener" class="font-black text-amber-900 hover:underline">EPA standards of practice →</a></div>
          </div>
          <div class="rounded-2xl border border-slate-200 bg-white p-6">
            <p class="text-xs font-black uppercase tracking-wider text-slate-500">County context</p>
            <h2 class="mt-2 font-display text-2xl font-black text-slate-950">Use local data to justify testing—not to clear the building</h2>
            <p class="mt-4 text-sm leading-relaxed text-slate-700">${evidence.getMeasuredBurdenSummary()}</p>
            <div class="mt-5 rounded-xl bg-slate-50 p-4"><p class="text-xs font-bold uppercase tracking-wider text-slate-500">Official signal</p><p class="mt-2 font-bold text-slate-950">${evidence.getPrimaryAverageDisplay()}</p></div>
            <p class="mt-4 text-sm leading-relaxed text-slate-600">County or ZIP evidence cannot predict a specific office, school, apartment, warehouse, or retail space. The building measurement plan controls the decision.</p>
            <a href="${levelsPath}" class="mt-5 inline-flex font-black text-indigo-700 hover:underline">Open Los Angeles County evidence →</a>
          </div>
        </section>

        <section class="mt-8 rounded-2xl bg-slate-950 p-6 text-white sm:p-8">
          <p class="text-xs font-black uppercase tracking-[0.18em] text-cyan-300">Copy this into the request for proposal</p>
          <p class="mt-3 rounded-xl border border-white/15 bg-white/5 p-5 text-sm font-semibold leading-relaxed text-slate-200">Please provide a commercial radon measurement plan for our Los Angeles County property. Identify the applicable standard, every ground-contact and upper-floor test location, device and QA counts, closed-building requirements, access assumptions, invalid-test handling, reporting by location, current California certification, and a separate price for any follow-up diagnostics or mitigation design.</p>
        </section>
      </main>
    `
)
