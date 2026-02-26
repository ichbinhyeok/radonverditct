@import com.radonverdict.model.dto.InternalLinkItem
@import java.util.List

@param String title = "Related Resources"
@param List<InternalLinkItem> links

@if(links != null && !links.isEmpty())
<section class="border-t border-slate-200 mt-16 pt-12 mb-8">
    <h3 class="font-display font-bold text-xl text-slate-900 mb-5">${title}</h3>
    <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
        @for(var item : links)
        <a href="${item.getUrl()}" class="block p-4 rounded-xl bg-white border border-slate-200 hover:border-indigo-300 hover:shadow-sm transition-all group" data-track-event="internal_link_click" data-track-label="${item.getBucket()}">
            <span class="block font-semibold text-slate-900 group-hover:text-indigo-600 transition-colors">${item.getTitle()}</span>
            <span class="block text-xs text-slate-500 mt-1">${item.getDescription()}</span>
        </a>
        @endfor
    </div>
</section>
@endif
