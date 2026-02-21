package gg.jte.generated.ondemand.components;
import com.radonverdict.model.dto.ItemizedReceipt;
@SuppressWarnings("unchecked")
public final class Jtereceipt_cardGenerated {
	public static final String JTE_NAME = "components/receipt_card.jte";
	public static final int[] JTE_LINE_INFO = {0,0,2,2,2,2,4,4,7,11,15,15,15,15,15,15,17,25,27,31,31,31,34,40,40,40,43,47,47,47,51,55,55,55,55,55,55,58,58,58,62,69,69,69,2,2,2,2};
	public static void render(gg.jte.html.HtmlTemplateOutput jteOutput, gg.jte.html.HtmlInterceptor jteHtmlInterceptor, ItemizedReceipt receipt) {
		jteOutput.writeContent("\r\n");
		jteOutput.writeContent("\r\n<div class=\"bg-white rounded-[2rem] shadow-[0_8px_30px_rgb(0,0,0,0.04)] border border-slate-100/50 overflow-hidden relative group\">\r\n    \r\n    ");
		jteOutput.writeContent("\r\n    <div class=\"h-1.5 w-full bg-slate-900\"></div>\r\n    \r\n    <div class=\"p-8 sm:p-10\">\r\n        ");
		jteOutput.writeContent("\r\n        <div class=\"flex items-start justify-between mb-10\">\r\n            <div>\r\n                <h3 class=\"font-display font-extrabold text-slate-900 text-2xl tracking-tight\">Official Estimate</h3>\r\n                <p class=\"text-slate-400 text-sm mt-1 font-medium tracking-wide uppercase\">");
		jteOutput.setContext("p", null);
		jteOutput.writeUserContent(receipt.getCountyName());
		jteOutput.writeContent(" County, ");
		jteOutput.setContext("p", null);
		jteOutput.writeUserContent(receipt.getStateAbbr());
		jteOutput.writeContent("</p>\r\n            </div>\r\n            ");
		jteOutput.writeContent("\r\n            <div class=\"w-10 h-10 bg-emerald-50 rounded-full flex items-center justify-center border border-emerald-100 shadow-sm\">\r\n                <svg class=\"w-5 h-5 text-emerald-500\" fill=\"none\" viewBox=\"0 0 24 24\" stroke=\"currentColor\" stroke-width=\"2.5\">\r\n                    <path stroke-linecap=\"round\" stroke-linejoin=\"round\" d=\"M5 13l4 4L19 7\" />\r\n                </svg>\r\n            </div>\r\n        </div>\r\n\r\n        ");
		jteOutput.writeContent("\r\n        <div class=\"space-y-5 mb-10\">\r\n            ");
		jteOutput.writeContent("\r\n            <div class=\"flex items-baseline justify-between text-slate-600\">\r\n                <span class=\"font-medium\">System Materials</span>\r\n                <div class=\"flex-grow border-b-2 border-dotted border-slate-200 mx-4 relative top-[-6px]\"></div>\r\n                <span class=\"font-semibold tabular-nums text-slate-900 tracking-tight\">$");
		jteOutput.setContext("span", null);
		jteOutput.writeUserContent(receipt.getMaterialsAvg());
		jteOutput.writeContent("</span>\r\n            </div>\r\n            \r\n            ");
		jteOutput.writeContent("\r\n            <div class=\"flex items-baseline justify-between text-slate-600\">\r\n                <div class=\"flex flex-col\">\r\n                    <span class=\"font-medium\">Specialized Labor</span>\r\n                </div>\r\n                <div class=\"flex-grow border-b-2 border-dotted border-slate-200 mx-4 relative top-[-6px]\"></div>\r\n                <span class=\"font-semibold tabular-nums text-slate-900 tracking-tight\">$");
		jteOutput.setContext("span", null);
		jteOutput.writeUserContent(receipt.getLaborAvg());
		jteOutput.writeContent("</span>\r\n            </div>\r\n            \r\n            ");
		jteOutput.writeContent("\r\n            <div class=\"flex items-baseline justify-between text-slate-600\">\r\n                <span class=\"font-medium\">Permits & Setup</span>\r\n                <div class=\"flex-grow border-b-2 border-dotted border-slate-200 mx-4 relative top-[-6px]\"></div>\r\n                <span class=\"font-semibold tabular-nums text-slate-900 tracking-tight\">$");
		jteOutput.setContext("span", null);
		jteOutput.writeUserContent(receipt.getPermitsSetupAvg());
		jteOutput.writeContent("</span>\r\n            </div>\r\n        </div>\r\n\r\n        ");
		jteOutput.writeContent("\r\n        <div class=\"bg-slate-50 rounded-2xl p-6 flex flex-col sm:flex-row items-start sm:items-center justify-between border border-slate-100 gap-4\">\r\n            <div>\r\n                <p class=\"text-xs font-bold text-slate-400 uppercase tracking-widest\">Estimated Total</p>\r\n                <p class=\"text-xs text-slate-400 mt-1 font-medium\">Range: $");
		jteOutput.setContext("p", null);
		jteOutput.writeUserContent(receipt.getTotalLow());
		jteOutput.writeContent(" &ndash; $");
		jteOutput.setContext("p", null);
		jteOutput.writeUserContent(receipt.getTotalHigh());
		jteOutput.writeContent("</p>\r\n            </div>\r\n            <div class=\"font-display font-extrabold text-4xl sm:text-5xl text-slate-900 tracking-tighter tabular-nums drop-shadow-sm\">\r\n                $");
		jteOutput.setContext("div", null);
		jteOutput.writeUserContent(receipt.getTotalAvg());
		jteOutput.writeContent("\r\n            </div>\r\n        </div>\r\n        \r\n        ");
		jteOutput.writeContent("\r\n        <div class=\"mt-6 flex items-start gap-3 p-4 bg-slate-50/50 rounded-xl border border-slate-100\">\r\n            <svg class=\"w-5 h-5 text-slate-400 mt-0.5 shrink-0\" fill=\"currentColor\" viewBox=\"0 0 20 20\"><path fill-rule=\"evenodd\" d=\"M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z\" clip-rule=\"evenodd\"></path></svg>\r\n            <p class=\"text-[13px] text-slate-500 font-medium leading-relaxed\">Prices are dynamically adjusted for local market multipliers and represent standard sub-slab or basement installations. Real contractor pricing may vary based on structural complexity.</p>\r\n        </div>\r\n    </div>\r\n</div>\r\n");
	}
	public static void renderMap(gg.jte.html.HtmlTemplateOutput jteOutput, gg.jte.html.HtmlInterceptor jteHtmlInterceptor, java.util.Map<String, Object> params) {
		ItemizedReceipt receipt = (ItemizedReceipt)params.get("receipt");
		render(jteOutput, jteHtmlInterceptor, receipt);
	}
}
