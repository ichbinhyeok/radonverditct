package gg.jte.generated.ondemand.fragments;
import com.radonverdict.model.dto.CountyPageContent;
@SuppressWarnings("unchecked")
public final class JtereceiptGenerated {
	public static final String JTE_NAME = "fragments/receipt.jte";
	public static final int[] JTE_LINE_INFO = {0,0,1,1,1,1,3,3,6,7,7,9,10,10,20,20,20,1,1,1,1};
	public static void render(gg.jte.html.HtmlTemplateOutput jteOutput, gg.jte.html.HtmlInterceptor jteHtmlInterceptor, CountyPageContent page) {
		jteOutput.writeContent("\r\n");
		jteOutput.writeContent("\r\n<div id=\"receipt-container\" class=\"space-y-6 animate-[fadeIn_0.5s_ease-out]\">\r\n    \r\n    ");
		jteOutput.writeContent("\r\n    ");
		gg.jte.generated.ondemand.components.Jtereceipt_cardGenerated.render(jteOutput, jteHtmlInterceptor, page.getReceipt());
		jteOutput.writeContent("\r\n    \r\n    ");
		jteOutput.writeContent("\r\n    ");
		gg.jte.generated.ondemand.components.Jtenegotiation_boxGenerated.render(jteOutput, jteHtmlInterceptor, page);
		jteOutput.writeContent("\r\n\r\n</div>\r\n\r\n<style>\r\n@keyframes fadeIn {\r\n    from { opacity: 0; transform: translateY(10px); }\r\n    to { opacity: 1; transform: translateY(0); }\r\n}\r\n</style>\r\n");
	}
	public static void renderMap(gg.jte.html.HtmlTemplateOutput jteOutput, gg.jte.html.HtmlInterceptor jteHtmlInterceptor, java.util.Map<String, Object> params) {
		CountyPageContent page = (CountyPageContent)params.get("page");
		render(jteOutput, jteHtmlInterceptor, page);
	}
}
