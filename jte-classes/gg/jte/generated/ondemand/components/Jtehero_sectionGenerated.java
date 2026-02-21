package gg.jte.generated.ondemand.components;
import com.radonverdict.model.dto.CountyPageContent;
@SuppressWarnings("unchecked")
public final class Jtehero_sectionGenerated {
	public static final String JTE_NAME = "components/hero_section.jte";
	public static final int[] JTE_LINE_INFO = {0,0,2,2,2,2,5,5,7,7,7,7,7,7,7,7,11,14,14,14,14,14,14,14,14,16,16,16,19,21,21,21,24,26,26,26,29,31,31,31,35,35,35,2,2,2,2};
	public static void render(gg.jte.html.HtmlTemplateOutput jteOutput, gg.jte.html.HtmlInterceptor jteHtmlInterceptor, CountyPageContent page) {
		jteOutput.writeContent("\r\n<div class=\"mb-12 relative overflow-hidden rounded-[2.5rem] bg-slate-900 border border-slate-800 p-8 sm:p-12 shadow-2xl\">\r\n    ");
		jteOutput.writeContent("\r\n    <div class=\"absolute top-0 right-0 -mr-20 -mt-20 w-64 h-64 rounded-full mix-blend-multiply filter blur-3xl opacity-20 pointer-events-none \r\n        ");
		if ("red".equals(page.getBadgeColor())) {
			jteOutput.writeContent(" bg-rose-500 ");
		} else if ("yellow".equals(page.getBadgeColor())) {
			jteOutput.writeContent(" bg-amber-500 ");
		} else {
			jteOutput.writeContent(" bg-emerald-500 ");
		}
		jteOutput.writeContent("\">\r\n    </div>\r\n\r\n    <div class=\"relative z-10 max-w-3xl\">\r\n        ");
		jteOutput.writeContent("\r\n        <span class=\"inline-flex items-center gap-2 px-3 py-1 rounded-full text-xs font-bold tracking-wider uppercase bg-white/10 text-white backdrop-blur-md border border-white/20 mb-6 shadow-sm\">\r\n            <span class=\"w-2 h-2 rounded-full shadow-sm shadow-current \r\n                ");
		if ("red".equals(page.getBadgeColor())) {
			jteOutput.writeContent(" bg-rose-400 ");
		} else if ("yellow".equals(page.getBadgeColor())) {
			jteOutput.writeContent(" bg-amber-400 ");
		} else {
			jteOutput.writeContent(" bg-emerald-400 ");
		}
		jteOutput.writeContent("\r\n            \"></span>\r\n            EPA Zone ");
		jteOutput.setContext("span", null);
		jteOutput.writeUserContent(page.getRiskLevel());
		jteOutput.writeContent(" Risk\r\n        </span>\r\n\r\n        ");
		jteOutput.writeContent("\r\n        <h1 class=\"font-display font-black text-4xl sm:text-5xl lg:text-6xl text-white tracking-tighter leading-tight mb-6\">\r\n            ");
		jteOutput.setContext("h1", null);
		jteOutput.writeUserContent(page.getHeroTitle());
		jteOutput.writeContent("\r\n        </h1>\r\n\r\n        ");
		jteOutput.writeContent("\r\n        <p class=\"text-slate-300 text-lg sm:text-xl leading-relaxed font-medium mb-6\">\r\n            ");
		jteOutput.setContext("p", null);
		jteOutput.writeUserContent(page.getHeroSummary());
		jteOutput.writeContent("\r\n        </p>\r\n\r\n        ");
		jteOutput.writeContent("\r\n        <div class=\"bg-white/5 backdrop-blur-sm border border-white/10 rounded-2xl p-5 sm:p-6 text-sm text-slate-300 leading-relaxed font-medium\">\r\n            <p>");
		jteOutput.setContext("p", null);
		jteOutput.writeUserContent(page.getRiskNarrative());
		jteOutput.writeContent("</p>\r\n        </div>\r\n    </div>\r\n</div>\r\n");
	}
	public static void renderMap(gg.jte.html.HtmlTemplateOutput jteOutput, gg.jte.html.HtmlInterceptor jteHtmlInterceptor, java.util.Map<String, Object> params) {
		CountyPageContent page = (CountyPageContent)params.get("page");
		render(jteOutput, jteHtmlInterceptor, page);
	}
}
