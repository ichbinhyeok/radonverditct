package gg.jte.generated.ondemand.components;
import com.radonverdict.model.dto.CountyPageContent;
@SuppressWarnings("unchecked")
public final class Jtefaq_accordionGenerated {
	public static final String JTE_NAME = "components/faq_accordion.jte";
	public static final int[] JTE_LINE_INFO = {0,0,1,1,1,1,7,7,7,8,8,8,8,13,13,13,16,20,30,30,30,33,33,36,36,36,1,1,1,1};
	public static void render(gg.jte.html.HtmlTemplateOutput jteOutput, gg.jte.html.HtmlInterceptor jteHtmlInterceptor, CountyPageContent page) {
		jteOutput.writeContent("\r\n<div class=\"space-y-4\">\r\n    <h3 class=\"font-display font-extrabold text-slate-900 text-2xl tracking-tight mb-8\">Frequently Asked Questions</h3>\r\n    \r\n    <div x-data=\"{ active: null }\" class=\"divide-y divide-slate-100 border-t border-slate-100\">\r\n        ");
		for (int i = 0; i < page.getFaqs().size(); i++) {
			jteOutput.writeContent("\r\n            <div class=\"py-5\" x-data=\"{ id: ");
			jteOutput.setContext("div", "x-data");
			jteOutput.writeUserContent(i);
			jteOutput.setContext("div", null);
			jteOutput.writeContent(", get isOpen() { return this.active === this.id } }\">\r\n                <button \r\n                    @click=\"active = isOpen ? null : id\"\r\n                    class=\"flex w-full items-center justify-between text-left focus:outline-none group\">\r\n                    <span class=\"font-medium text-slate-900 group-hover:text-amber-600 transition-colors duration-200\">\r\n                        ");
			jteOutput.setContext("span", null);
			jteOutput.writeUserContent(page.getFaqs().get(i).getQuestion());
			jteOutput.writeContent("\r\n                    </span>\r\n                    <span class=\"ml-6 flex h-7 w-7 items-center justify-center rounded-full border border-slate-200 bg-white group-hover:border-amber-200 group-hover:bg-amber-50\">\r\n                        ");
			jteOutput.writeContent("\r\n                        <svg x-show=\"!isOpen\" class=\"h-4 w-4 text-slate-400 group-hover:text-amber-600\" fill=\"none\" viewBox=\"0 0 24 24\" stroke=\"currentColor\" stroke-width=\"2\">\r\n                            <path stroke-linecap=\"round\" stroke-linejoin=\"round\" d=\"M12 4v16m8-8H4\" />\r\n                        </svg>\r\n                        ");
			jteOutput.writeContent("\r\n                        <svg x-show=\"isOpen\" style=\"display: none;\" class=\"h-4 w-4 text-amber-600\" fill=\"none\" viewBox=\"0 0 24 24\" stroke=\"currentColor\" stroke-width=\"2\">\r\n                            <path stroke-linecap=\"round\" stroke-linejoin=\"round\" d=\"M20 12H4\" />\r\n                        </svg>\r\n                    </span>\r\n                </button>\r\n                <div x-show=\"isOpen\" \r\n                    x-collapse \r\n                    x-cloak\r\n                    class=\"prose prose-slate prose-sm mt-4 text-slate-600 leading-relaxed font-medium\">\r\n                    <p>");
			jteOutput.setContext("p", null);
			jteOutput.writeUserContent(page.getFaqs().get(i).getAnswer());
			jteOutput.writeContent("</p>\r\n                </div>\r\n            </div>\r\n        ");
		}
		jteOutput.writeContent("\r\n    </div>\r\n</div>\r\n");
	}
	public static void renderMap(gg.jte.html.HtmlTemplateOutput jteOutput, gg.jte.html.HtmlInterceptor jteHtmlInterceptor, java.util.Map<String, Object> params) {
		CountyPageContent page = (CountyPageContent)params.get("page");
		render(jteOutput, jteHtmlInterceptor, page);
	}
}
