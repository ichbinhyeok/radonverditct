package gg.jte.generated.ondemand.components;
import com.radonverdict.model.County;
@SuppressWarnings("unchecked")
public final class Jtesimulator_formGenerated {
	public static final String JTE_NAME = "components/simulator_form.jte";
	public static final int[] JTE_LINE_INFO = {0,0,1,1,1,1,3,3,11,12,19,20,20,20,20,20,20,20,20,20,21,21,21,21,21,21,21,21,21,23,51,79,91,106,106,106,1,1,1,1};
	public static void render(gg.jte.html.HtmlTemplateOutput jteOutput, gg.jte.html.HtmlInterceptor jteHtmlInterceptor, County county) {
		jteOutput.writeContent("\r\n");
		jteOutput.writeContent("\r\n<div class=\"bg-white rounded-[2rem] p-6 sm:p-8 shadow-sm border border-slate-200 mb-8 max-w-2xl mx-auto\">\r\n    \r\n    <div class=\"mb-6 text-center\">\r\n        <h3 class=\"font-display font-bold text-slate-900 text-xl tracking-tight\">Refine Your Estimate</h3>\r\n        <p class=\"text-slate-500 text-sm mt-1 font-medium\">Adjust parameters to simulate local costs</p>\r\n    </div>\r\n\r\n    ");
		jteOutput.writeContent("\r\n    ");
		jteOutput.writeContent("\r\n    <form hx-post=\"/htmx/calculate-receipt\" \r\n          hx-target=\"#receipt-container\"\r\n          hx-swap=\"innerHTML transition:true\"\r\n          class=\"space-y-8\"\r\n          x-data=\"{ foundation: 'basement', intent: 'buying' }\">\r\n        \r\n        ");
		jteOutput.writeContent("\r\n        <input type=\"hidden\" name=\"stateSlug\"");
		var __jte_html_attribute_0 = county.getStateSlug();
		if (gg.jte.runtime.TemplateUtils.isAttributeRendered(__jte_html_attribute_0)) {
			jteOutput.writeContent(" value=\"");
			jteOutput.setContext("input", "value");
			jteOutput.writeUserContent(__jte_html_attribute_0);
			jteOutput.setContext("input", null);
			jteOutput.writeContent("\"");
		}
		jteOutput.writeContent(">\r\n        <input type=\"hidden\" name=\"countySlug\"");
		var __jte_html_attribute_1 = county.getCountySlug();
		if (gg.jte.runtime.TemplateUtils.isAttributeRendered(__jte_html_attribute_1)) {
			jteOutput.writeContent(" value=\"");
			jteOutput.setContext("input", "value");
			jteOutput.writeUserContent(__jte_html_attribute_1);
			jteOutput.setContext("input", null);
			jteOutput.writeContent("\"");
		}
		jteOutput.writeContent(">\r\n\r\n        ");
		jteOutput.writeContent("\r\n        <div>\r\n            <label class=\"block text-xs font-bold text-slate-400 uppercase tracking-widest mb-3 text-center\">Foundation Type</label>\r\n            <div class=\"grid grid-cols-3 gap-3\">\r\n                <label class=\"cursor-pointer\">\r\n                    <input type=\"radio\" name=\"foundation\" value=\"basement\" x-model=\"foundation\" class=\"peer sr-only\" @change=\"$dispatch('submit')\">\r\n                    <div class=\"text-center rounded-xl p-3 border-2 transition-all duration-200\"\r\n                         :class=\"foundation === 'basement' ? 'border-brand-900 bg-brand-50 text-brand-900 shadow-sm' : 'border-slate-100 bg-white text-slate-500 hover:border-slate-300 hover:bg-slate-50'\">\r\n                        <div class=\"font-semibold text-sm\">Basement</div>\r\n                    </div>\r\n                </label>\r\n                <label class=\"cursor-pointer\">\r\n                    <input type=\"radio\" name=\"foundation\" value=\"slab\" x-model=\"foundation\" class=\"peer sr-only\" @change=\"$dispatch('submit')\">\r\n                    <div class=\"text-center rounded-xl p-3 border-2 transition-all duration-200\"\r\n                         :class=\"foundation === 'slab' ? 'border-brand-900 bg-brand-50 text-brand-900 shadow-sm' : 'border-slate-100 bg-white text-slate-500 hover:border-slate-300 hover:bg-slate-50'\">\r\n                        <div class=\"font-semibold text-sm\">Slab</div>\r\n                    </div>\r\n                </label>\r\n                <label class=\"cursor-pointer\">\r\n                    <input type=\"radio\" name=\"foundation\" value=\"crawlspace\" x-model=\"foundation\" class=\"peer sr-only\" @change=\"$dispatch('submit')\">\r\n                    <div class=\"text-center rounded-xl p-3 border-2 transition-all duration-200\"\r\n                         :class=\"foundation === 'crawlspace' ? 'border-brand-900 bg-brand-50 text-brand-900 shadow-sm' : 'border-slate-100 bg-white text-slate-500 hover:border-slate-300 hover:bg-slate-50'\">\r\n                        <div class=\"font-semibold text-sm\">Crawl</div>\r\n                    </div>\r\n                </label>\r\n            </div>\r\n        </div>\r\n\r\n        ");
		jteOutput.writeContent("\r\n        <div>\r\n            <label class=\"block text-xs font-bold text-slate-400 uppercase tracking-widest mb-3 text-center\">Your Goal</label>\r\n            <div class=\"bg-slate-100 rounded-xl p-1.5 flex gap-1 relative overflow-hidden ring-1 ring-inset ring-slate-200\">\r\n                <label class=\"flex-1 cursor-pointer relative z-10\">\r\n                    <input type=\"radio\" name=\"intent\" value=\"buying\" x-model=\"intent\" class=\"peer sr-only\" @change=\"$dispatch('submit')\">\r\n                    <div class=\"text-center py-2.5 rounded-lg text-sm font-semibold transition-colors duration-200\"\r\n                         :class=\"intent === 'buying' ? 'bg-white text-slate-900 shadow-sm ring-1 ring-black/5' : 'text-slate-500 hover:text-slate-700'\">\r\n                        Buying\r\n                    </div>\r\n                </label>\r\n                <label class=\"flex-1 cursor-pointer relative z-10\">\r\n                    <input type=\"radio\" name=\"intent\" value=\"selling\" x-model=\"intent\" class=\"peer sr-only\" @change=\"$dispatch('submit')\">\r\n                    <div class=\"text-center py-2.5 rounded-lg text-sm font-semibold transition-colors duration-200\"\r\n                         :class=\"intent === 'selling' ? 'bg-white text-slate-900 shadow-sm ring-1 ring-black/5' : 'text-slate-500 hover:text-slate-700'\">\r\n                        Selling\r\n                    </div>\r\n                </label>\r\n                <label class=\"flex-1 cursor-pointer relative z-10\">\r\n                    <input type=\"radio\" name=\"intent\" value=\"homeowner\" x-model=\"intent\" class=\"peer sr-only\" @change=\"$dispatch('submit')\">\r\n                    <div class=\"text-center py-2.5 rounded-lg text-sm font-semibold transition-colors duration-200\"\r\n                         :class=\"intent === 'homeowner' ? 'bg-white text-slate-900 shadow-sm ring-1 ring-black/5' : 'text-slate-500 hover:text-slate-700'\">\r\n                        Living Here\r\n                    </div>\r\n                </label>\r\n            </div>\r\n        </div>\r\n        \r\n        ");
		jteOutput.writeContent("\r\n        <div class=\"htmx-indicator flex justify-center py-2\">\r\n            <svg class=\"animate-spin h-5 w-5 text-brand-500\" xmlns=\"http://www.w3.org/2000/svg\" fill=\"none\" viewBox=\"0 0 24 24\">\r\n                <circle class=\"opacity-25\" cx=\"12\" cy=\"12\" r=\"10\" stroke=\"currentColor\" stroke-width=\"4\"></circle>\r\n                <path class=\"opacity-75\" fill=\"currentColor\" d=\"M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z\"></path>\r\n            </svg>\r\n        </div>\r\n\r\n    </form>\r\n</div>\r\n\r\n<style>\r\n");
		jteOutput.writeContent("\r\n#receipt-container.htmx-swapping {\r\n  opacity: 0.3;\r\n  transition: opacity 200ms ease-out;\r\n}\r\n.htmx-indicator {\r\n    opacity: 0;\r\n    transition: opacity 150ms ease-in;\r\n    position: absolute;\r\n    pointer-events: none;\r\n}\r\n.htmx-request .htmx-indicator {\r\n    opacity: 1;\r\n}\r\n</style>\r\n");
	}
	public static void renderMap(gg.jte.html.HtmlTemplateOutput jteOutput, gg.jte.html.HtmlInterceptor jteHtmlInterceptor, java.util.Map<String, Object> params) {
		County county = (County)params.get("county");
		render(jteOutput, jteHtmlInterceptor, county);
	}
}
