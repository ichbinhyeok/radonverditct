@import com.radonverdict.model.dto.PageQualityResult
@import com.radonverdict.model.dto.TrustMetadata

@param TrustMetadata trust
@param PageQualityResult quality = null
@param boolean showDebug = false

<section class="mt-10 rounded-2xl border border-slate-200 bg-white p-5 sm:p-6">
    <h3 class="font-display font-bold text-lg text-slate-900 mb-4">Editorial and Data Transparency</h3>
    <dl class="grid grid-cols-1 sm:grid-cols-2 gap-3 text-sm">
        <div>
            <dt class="text-slate-500">Author</dt>
            <dd class="text-slate-900 font-medium">${trust.getAuthorName()} (${trust.getAuthorRole()})</dd>
        </div>
        <div>
            <dt class="text-slate-500">Content Review</dt>
            <dd class="text-slate-900 font-medium">
                @if(trust.getLastReviewed() != null && !trust.getLastReviewed().isBlank())
                    ${trust.getLastReviewed()}
                @else
                    Source-level dates shown below
                @endif
            </dd>
        </div>
        <div>
            <dt class="text-slate-500">Data Retrieved At</dt>
            <dd class="text-slate-900 font-medium">
                @if(trust.getDataRetrievedAt() != null && !trust.getDataRetrievedAt().isBlank())
                    ${trust.getDataRetrievedAt()}
                @else
                    Source-level dates below
                @endif
            </dd>
        </div>
        @if(showDebug && quality != null)
        <div>
            <dt class="text-slate-500">Page Quality Score</dt>
            <dd class="text-slate-900 font-medium">${quality.getScore()} / 100</dd>
        </div>
        <div>
            <dt class="text-slate-500">Indexing Status</dt>
            <dd class="text-slate-900 font-medium">@if(quality.isIndexable()) Indexable @else Noindex @endif</dd>
        </div>
        <div>
            <dt class="text-slate-500">Uniqueness Score</dt>
            <dd class="text-slate-900 font-medium">${quality.getSimilarityScore()} / 100</dd>
        </div>
        <div>
            <dt class="text-slate-500">Similarity Cohort</dt>
            <dd class="text-slate-900 font-medium">${quality.getSimilarityCohortSize()} pages</dd>
        </div>
        @endif
    </dl>

    @if(trust.getSources() != null && !trust.getSources().isEmpty())
    <div class="mt-5">
        <p class="text-xs font-semibold text-slate-500 uppercase tracking-wider mb-2">Primary Sources</p>
        <ul class="space-y-1 text-sm text-slate-600">
            @for(var source : trust.getSources())
            <li>
                <a href="${source.getUrl()}" target="_blank" rel="noopener nofollow" class="text-indigo-600 hover:underline">
                    ${source.getName()}
                </a>
                @if(source.getRetrievedAt() != null && !source.getRetrievedAt().isBlank())
                    <span class="text-slate-500"> (retrieved ${source.getRetrievedAt()})</span>
                @endif
            </li>
            @endfor
        </ul>
    </div>
    @endif

    @if(showDebug && quality != null && quality.getReasons() != null && !quality.getReasons().isEmpty())
    <p class="mt-4 text-xs text-slate-500">
        Automated quality checks: ${String.join(", ", quality.getReasons())}
        @if(quality.getSimilarityFingerprint() != null && !quality.getSimilarityFingerprint().isBlank())
            (fingerprint: ${quality.getSimilarityFingerprint()})
        @endif
    </p>
    @endif
</section>
