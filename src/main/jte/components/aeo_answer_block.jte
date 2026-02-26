@import com.radonverdict.model.dto.AeoAnswerBlock

@param AeoAnswerBlock block

<section class="bg-white rounded-2xl border border-slate-200 shadow-sm p-6 sm:p-8 mt-8" data-track-section="aeo-answer">
    <p class="text-xs font-bold uppercase tracking-wider text-indigo-600 mb-3">Direct Answer</p>
    <h2 class="font-display font-bold text-xl text-slate-900 mb-3">${block.getQuestion()}</h2>
    <p class="text-slate-700 leading-relaxed">${block.getDirectAnswer()}</p>

    @if(block.getEvidenceRows() != null && !block.getEvidenceRows().isEmpty())
    <div class="mt-6 rounded-xl border border-slate-200 overflow-hidden">
        <table class="w-full text-sm">
            <thead class="bg-slate-50">
                <tr>
                    <th scope="col" class="px-4 py-3 text-left font-semibold text-slate-700">Evidence</th>
                    <th scope="col" class="px-4 py-3 text-left font-semibold text-slate-700">Value</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-slate-100">
                @for(var row : block.getEvidenceRows())
                <tr>
                    <th scope="row" class="px-4 py-3 text-left font-medium text-slate-700">${row.getLabel()}</th>
                    <td class="px-4 py-3 text-slate-900">${row.getValue()}</td>
                </tr>
                @endfor
            </tbody>
        </table>
    </div>
    @endif

    @if(block.getSources() != null && !block.getSources().isEmpty())
    <div class="mt-5">
        <p class="text-xs font-semibold text-slate-500 uppercase tracking-wider mb-2">Sources</p>
        <ul class="space-y-1 text-xs text-slate-600">
            @for(var source : block.getSources())
            <li>
                <a href="${source.getUrl()}" target="_blank" rel="noopener nofollow" class="text-indigo-600 hover:underline">
                    ${source.getName()}
                </a>
            </li>
            @endfor
        </ul>
    </div>
    @endif
</section>
