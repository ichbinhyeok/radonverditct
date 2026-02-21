package gg.jte.generated.ondemand.components;
import com.radonverdict.model.dto.CountyPageContent;
@SuppressWarnings("unchecked")
public final class Jtenegotiation_boxGenerated {
	public static final String JTE_NAME = "components/negotiation_box.jte";
	public static final int[] JTE_LINE_INFO = {0,0,1,1,1,1,7,7,14,14,14,15,15,15,19,21,21,26,26,26,28,28,31,36,36,36,39,39,39,1,1,1,1};
	public static void render(gg.jte.html.HtmlTemplateOutput jteOutput, gg.jte.html.HtmlInterceptor jteHtmlInterceptor, CountyPageContent page) {
		jteOutput.writeContent("\r\n<div class=\"bg-blue-50/50 rounded-2xl border border-blue-100 p-6 sm:p-8 relative mt-0 top-0 \r\n    transition-all duration-300 transform group-hover:-translate-y-1\">\r\n\r\n    <div class=\"flex items-start gap-4 mb-4\">\r\n        ");
		jteOutput.writeContent("\r\n        <div class=\"w-12 h-12 bg-white rounded-xl shadow-sm border border-blue-100 flex items-center justify-center shrink-0\">\r\n            <svg class=\"w-6 h-6 text-blue-600\" fill=\"none\" viewBox=\"0 0 24 24\" stroke=\"currentColor\" stroke-width=\"2\">\r\n                <path stroke-linecap=\"round\" stroke-linejoin=\"round\" d=\"M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z\" />\r\n            </svg>\r\n        </div>\r\n        <div>\r\n            <h4 class=\"font-display font-bold text-slate-900 text-lg mb-1\">");
		jteOutput.setContext("h4", null);
		jteOutput.writeUserContent(page.getIntentSectionTitle());
		jteOutput.writeContent("</h4>\r\n            <p class=\"text-sm text-slate-600 font-medium leading-relaxed\">");
		jteOutput.setContext("p", null);
		jteOutput.writeUserContent(page.getIntentIntro());
		jteOutput.writeContent("</p>\r\n        </div>\r\n    </div>\r\n\r\n    ");
		jteOutput.writeContent("\r\n    <ul class=\"space-y-3 mt-6\">\r\n        ");
		for (String step : page.getIntentSteps()) {
			jteOutput.writeContent("\r\n        <li class=\"flex items-start gap-3\">\r\n            <svg class=\"w-5 h-5 text-blue-500 mt-0.5 shrink-0\" fill=\"none\" viewBox=\"0 0 24 24\" stroke=\"currentColor\" stroke-width=\"2.5\">\r\n                <path stroke-linecap=\"round\" stroke-linejoin=\"round\" d=\"M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z\" />\r\n            </svg>\r\n            <span class=\"text-sm text-slate-700 font-medium leading-relaxed\">");
			jteOutput.setContext("span", null);
			jteOutput.writeUserContent(step);
			jteOutput.writeContent("</span>\r\n        </li>\r\n        ");
		}
		jteOutput.writeContent("\r\n    </ul>\r\n\r\n    ");
		jteOutput.writeContent("\r\n    <div class=\"mt-8 bg-blue-100/50 rounded-xl p-4 border border-blue-200\">\r\n        <div class=\"flex items-center gap-2 mb-2\">\r\n            <span class=\"text-xs font-bold uppercase tracking-wider text-blue-800 bg-blue-200 px-2 py-0.5 rounded-full\">Pro Tip</span>\r\n        </div>\r\n        <p class=\"text-[13.5px] text-blue-900 font-semibold leading-relaxed\">");
		jteOutput.setContext("p", null);
		jteOutput.writeUserContent(page.getIntentProTip());
		jteOutput.writeContent("</p>\r\n    </div>\r\n</div>\r\n");
	}
	public static void renderMap(gg.jte.html.HtmlTemplateOutput jteOutput, gg.jte.html.HtmlInterceptor jteHtmlInterceptor, java.util.Map<String, Object> params) {
		CountyPageContent page = (CountyPageContent)params.get("page");
		render(jteOutput, jteHtmlInterceptor, page);
	}
}
