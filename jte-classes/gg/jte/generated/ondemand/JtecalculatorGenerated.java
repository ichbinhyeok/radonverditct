package gg.jte.generated.ondemand;
import java.util.Map;
import java.util.List;
import com.radonverdict.model.dto.ItemizedReceipt;
import com.radonverdict.model.County;
@SuppressWarnings("unchecked")
public final class JtecalculatorGenerated {
	public static final String JTE_NAME = "calculator.jte";
	public static final int[] JTE_LINE_INFO = {0,0,1,2,3,5,5,5,5,9,9,13,13,14,32,45,56,58,58,62,70,70,71,71,71,71,73,73,73,75,75,79,79,79,80,80,80,5,6,7,7,7,7};
	public static void render(gg.jte.html.HtmlTemplateOutput jteOutput, gg.jte.html.HtmlInterceptor jteHtmlInterceptor, String title, ItemizedReceipt defaultReceipt, Map<String, List<County>> stateMap) {
		jteOutput.writeContent("\r\n");
		gg.jte.generated.ondemand.layout.JtemainGenerated.render(jteOutput, jteHtmlInterceptor, title, "Estimate radon mitigation costs in your area. Enter your ZIP code to get a customized, itemized receipt for your local county.", new gg.jte.html.HtmlContent() {
			public void writeTo(gg.jte.html.HtmlTemplateOutput jteOutput) {
				jteOutput.writeContent("\r\n        ");
				jteOutput.writeContent("\r\n        <div class=\"bg-slate-900 pt-20 pb-32 border-b border-slate-800 relative overflow-hidden\">\r\n            <div class=\"absolute inset-0 bg-[url('data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNjAiIGhlaWdodD0iNjAiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+PHBhdGggZD0iTTMwIDB2NjBtMzAtMzBIMCIgc3Ryb2tlPSJyZ2JhKDI1NSwyNTUsMjU1LDAuMDUpIiBzdHJva2Utd2lkdGg9IjEiIGZpbGw9Im5vbmUiIGZpbGwtcnVsZT0iZXZlbm9kZCIvPjwvc3ZnPg==')] opacity-20\"></div>\r\n            \r\n            <div class=\"max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10 text-center\">\r\n                <span class=\"inline-flex items-center gap-2 px-3 py-1 rounded-full text-xs font-bold tracking-wider uppercase bg-brand-500/10 text-brand-300 border border-brand-500/20 mb-6\">\r\n                    <span class=\"w-2 h-2 rounded-full bg-brand-400\"></span>\r\n                    2026 Data Updated\r\n                </span>\r\n                \r\n                <h1 class=\"font-display font-black text-4xl sm:text-5xl lg:text-6xl text-white tracking-tighter leading-tight mb-6\">\r\n                    Radon Mitigation Cost <br class=\"hidden sm:block\"/><span class=\"text-slate-400\">Calculator</span>\r\n                </h1>\r\n                \r\n                <p class=\"text-slate-300 text-lg sm:text-xl leading-relaxed font-medium mb-12 max-w-2xl mx-auto\">\r\n                    Get an itemized estimate based on your home's foundation, EPA zone risk, and local contractor labor rates.\r\n                </p>\r\n\r\n                ");
				jteOutput.writeContent("\r\n                <form action=\"/search-zip\" method=\"POST\" class=\"max-w-md mx-auto relative group\">\r\n                    <div class=\"absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none\">\r\n                        <svg class=\"h-6 w-6 text-slate-400 group-focus-within:text-brand-500 transition-colors\" fill=\"none\" viewBox=\"0 0 24 24\" stroke=\"currentColor\" stroke-width=\"2\">\r\n                            <path stroke-linecap=\"round\" stroke-linejoin=\"round\" d=\"M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z\" />\r\n                            <path stroke-linecap=\"round\" stroke-linejoin=\"round\" d=\"M15 11a3 3 0 11-6 0 3 3 0 016 0z\" />\r\n                        </svg>\r\n                    </div>\r\n                    <input type=\"text\" name=\"zipCode\" pattern=\"[0-9]{5}\" required placeholder=\"Enter 5-digit ZIP code\" \r\n                        class=\"block w-full pl-12 pr-32 py-4 bg-white rounded-2xl border-0 ring-1 ring-inset ring-slate-200 focus:ring-2 focus:ring-inset focus:ring-brand-500 text-slate-900 text-lg shadow-xl shadow-black/10 placeholder:text-slate-400 font-medium\">\r\n                    <button type=\"submit\" class=\"absolute inset-y-2 right-2 flex items-center bg-slate-900 hover:bg-slate-800 text-white font-bold px-6 rounded-xl transition-colors shadow-sm\">\r\n                        Get Estimate\r\n                    </button>\r\n                    ");
				jteOutput.writeContent("\r\n                    <script>\r\n                        if (window.location.search.includes('error=notfound')) {\r\n                            document.write('<p class=\"absolute -bottom-8 left-0 right-0 text-rose-400 text-sm font-medium\">ZIP code not found in database.</p>');\r\n                        }\r\n                    </script>\r\n                </form>\r\n            </div>\r\n        </div>\r\n\r\n        <div class=\"max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-16 -mt-24 relative z-20\">\r\n            ");
				jteOutput.writeContent("\r\n            <div class=\"max-w-xl mx-auto mb-20\">\r\n                ");
				gg.jte.generated.ondemand.components.Jtereceipt_cardGenerated.render(jteOutput, jteHtmlInterceptor, defaultReceipt);
				jteOutput.writeContent("\r\n                <p class=\"text-center text-sm text-slate-500 mt-4 font-medium\">Showing National Average. Enter ZIP code for local pricing.</p>\r\n            </div>\r\n\r\n            ");
				jteOutput.writeContent("\r\n            <div class=\"mt-20\">\r\n                <div class=\"text-center mb-12\">\r\n                    <h2 class=\"font-display font-extrabold text-3xl text-slate-900 tracking-tight\">Browse by State</h2>\r\n                    <p class=\"mt-2 text-slate-500 font-medium\">Select your state to find customized mitigation costs for your county.</p>\r\n                </div>\r\n                \r\n                <div class=\"grid grid-cols-2 sm:grid-cols-4 md:grid-cols-6 lg:grid-cols-8 gap-3\">\r\n                    ");
				for (String stateAbbr : stateMap.keySet()) {
					jteOutput.writeContent("\r\n                        <a href=\"/radon-mitigation-cost/");
					jteOutput.setContext("a", "href");
					jteOutput.writeUserContent(stateMap.get(stateAbbr).get(0).getStateSlug());
					jteOutput.setContext("a", null);
					jteOutput.writeContent("\" \r\n                           class=\"flex flex-col items-center justify-center py-4 bg-white rounded-xl shadow-sm border border-slate-200 hover:border-brand-300 hover:shadow-md hover:bg-brand-50 transition-all group\">\r\n                            <span class=\"font-display font-bold text-slate-700 group-hover:text-brand-700 text-lg\">");
					jteOutput.setContext("span", null);
					jteOutput.writeUserContent(stateAbbr);
					jteOutput.writeContent("</span>\r\n                        </a>\r\n                    ");
				}
				jteOutput.writeContent("\r\n                </div>\r\n            </div>\r\n        </div>\r\n    ");
			}
		});
		jteOutput.writeContent("\r\n");
	}
	public static void renderMap(gg.jte.html.HtmlTemplateOutput jteOutput, gg.jte.html.HtmlInterceptor jteHtmlInterceptor, java.util.Map<String, Object> params) {
		String title = (String)params.get("title");
		ItemizedReceipt defaultReceipt = (ItemizedReceipt)params.get("defaultReceipt");
		Map<String, List<County>> stateMap = (Map<String, List<County>>)params.get("stateMap");
		render(jteOutput, jteHtmlInterceptor, title, defaultReceipt, stateMap);
	}
}
