package gg.jte.generated.ondemand;
import com.radonverdict.model.dto.CountyPageContent;
import com.radonverdict.model.County;
@SuppressWarnings("unchecked")
public final class Jtecounty_hubGenerated {
	public static final String JTE_NAME = "county_hub.jte";
	public static final int[] JTE_LINE_INFO = {0,0,1,3,3,3,3,6,6,10,10,13,18,18,18,18,18,18,18,20,20,20,24,25,25,27,30,32,32,34,36,36,36,37,37,37,39,39,39,42,44,44,44,44,44,44,47,47,47,47,47,47,53,53,53,53,53,53,56,56,56,56,56,56,57,57,57,59,59,59,59,59,59,59,59,59,60,60,60,60,60,60,68,72,73,73,79,81,81,84,90,90,93,93,93,96,96,96,99,99,99,99,100,100,105,105,105,106,106,106,3,4,4,4,4};
	public static void render(gg.jte.html.HtmlTemplateOutput jteOutput, gg.jte.html.HtmlInterceptor jteHtmlInterceptor, County county, CountyPageContent page) {
		jteOutput.writeContent("\r\n");
		gg.jte.generated.ondemand.layout.JtemainGenerated.render(jteOutput, jteHtmlInterceptor, page.getHeroTitle(), page.getHeroSummary(), new gg.jte.html.HtmlContent() {
			public void writeTo(gg.jte.html.HtmlTemplateOutput jteOutput) {
				jteOutput.writeContent("\r\n        <div class=\"max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-10\">\r\n            \r\n            ");
				jteOutput.writeContent("\r\n            <nav class=\"text-sm font-medium text-slate-500 mb-8\" aria-label=\"Breadcrumb\">\r\n                <ol class=\"inline-flex items-center space-x-2\">\r\n                    <li><a href=\"/\" class=\"hover:text-slate-900 transition-colors\">Home</a></li>\r\n                    <li><span class=\"mx-1 text-slate-300\">/</span></li>\r\n                    <li><a href=\"/radon-mitigation-cost/");
				jteOutput.setContext("a", "href");
				jteOutput.writeUserContent(county.getStateSlug());
				jteOutput.setContext("a", null);
				jteOutput.writeContent("\" class=\"hover:text-slate-900 transition-colors uppercase\">");
				jteOutput.setContext("a", null);
				jteOutput.writeUserContent(county.getStateAbbr());
				jteOutput.writeContent("</a></li>\r\n                    <li><span class=\"mx-1 text-slate-300\">/</span></li>\r\n                    <li class=\"text-slate-900 font-semibold\" aria-current=\"page\">");
				jteOutput.setContext("li", null);
				jteOutput.writeUserContent(county.getCountyName());
				jteOutput.writeContent(" County</li>\r\n                </ol>\r\n            </nav>\r\n\r\n            ");
				jteOutput.writeContent("\r\n            ");
				gg.jte.generated.ondemand.components.Jtehero_sectionGenerated.render(jteOutput, jteHtmlInterceptor, page);
				jteOutput.writeContent("\r\n\r\n            ");
				jteOutput.writeContent("\r\n            <div class=\"grid grid-cols-1 lg:grid-cols-12 gap-10 mt-16 mb-20\">\r\n                \r\n                ");
				jteOutput.writeContent("\r\n                <div class=\"lg:col-span-5 order-2 lg:order-1\">\r\n                    ");
				gg.jte.generated.ondemand.components.Jtesimulator_formGenerated.render(jteOutput, jteHtmlInterceptor, county);
				jteOutput.writeContent("\r\n                    \r\n                    ");
				jteOutput.writeContent("\r\n                    <div class=\"bg-white rounded-2xl p-6 border border-slate-200 mt-6 shadow-sm\">\r\n                        <h4 class=\"font-display font-bold text-slate-900 mb-2\">");
				jteOutput.setContext("h4", null);
				jteOutput.writeUserContent(page.getFoundationLabel());
				jteOutput.writeContent(" Factors</h4>\r\n                        <p class=\"text-sm text-slate-600 leading-relaxed mb-4\">");
				jteOutput.setContext("p", null);
				jteOutput.writeUserContent(page.getFoundationCostContext());
				jteOutput.writeContent("</p>\r\n                        <p class=\"text-xs font-semibold text-amber-600 tracking-wide uppercase\">Negotiation Note</p>\r\n                        <p class=\"text-sm text-slate-600 leading-relaxed mt-1\">");
				jteOutput.setContext("p", null);
				jteOutput.writeUserContent(page.getFoundationNegotiationNote());
				jteOutput.writeContent("</p>\r\n                    </div>\r\n\r\n                    ");
				jteOutput.writeContent("\r\n                    <div class=\"mt-6 rounded-2xl border p-6 flex gap-4 \r\n                        ");
				if (page.isDisclosureRequired()) {
					jteOutput.writeContent(" bg-amber-50 border-amber-200 ");
				} else {
					jteOutput.writeContent(" bg-slate-50 border-slate-200 ");
				}
				jteOutput.writeContent("\r\n                    \">\r\n                        <svg class=\"w-8 h-8 shrink-0 \r\n                            ");
				if (page.isDisclosureRequired()) {
					jteOutput.writeContent(" text-amber-500 ");
				} else {
					jteOutput.writeContent(" text-slate-400 ");
				}
				jteOutput.writeContent("\" \r\n                            fill=\"none\" viewBox=\"0 0 24 24\" stroke=\"currentColor\" stroke-width=\"1.5\">\r\n                            <path stroke-linecap=\"round\" stroke-linejoin=\"round\" d=\"M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z\" />\r\n                        </svg>\r\n                        <div>\r\n                            <h4 class=\"font-bold text-sm mb-1 \r\n                                ");
				if (page.isDisclosureRequired()) {
					jteOutput.writeContent(" text-amber-900 ");
				} else {
					jteOutput.writeContent(" text-slate-700 ");
				}
				jteOutput.writeContent("\r\n                            \">State Regulation Notice</h4>\r\n                            <p class=\"text-sm leading-relaxed mb-3\r\n                                ");
				if (page.isDisclosureRequired()) {
					jteOutput.writeContent(" text-amber-800 ");
				} else {
					jteOutput.writeContent(" text-slate-600 ");
				}
				jteOutput.writeContent("\r\n                            \">");
				jteOutput.setContext("p", null);
				jteOutput.writeUserContent(page.getDisclosureSummary());
				jteOutput.writeContent("</p>\r\n                            \r\n                            <a");
				var __jte_html_attribute_0 = page.getStateProgramUrl();
				if (gg.jte.runtime.TemplateUtils.isAttributeRendered(__jte_html_attribute_0)) {
					jteOutput.writeContent(" href=\"");
					jteOutput.setContext("a", "href");
					jteOutput.writeUserContent(__jte_html_attribute_0);
					jteOutput.setContext("a", null);
					jteOutput.writeContent("\"");
				}
				jteOutput.writeContent(" target=\"_blank\" rel=\"noopener nofollow\" class=\"inline-flex items-center text-xs font-bold uppercase tracking-wider \r\n                                ");
				if (page.isDisclosureRequired()) {
					jteOutput.writeContent(" text-amber-700 hover:text-amber-900 ");
				} else {
					jteOutput.writeContent(" text-slate-500 hover:text-slate-700 ");
				}
				jteOutput.writeContent(" transition-colors\">\r\n                                View official state site \r\n                                <svg class=\"w-3 h-3 ml-1\" fill=\"none\" viewBox=\"0 0 24 24\" stroke=\"currentColor\" stroke-width=\"2\"><path stroke-linecap=\"round\" stroke-linejoin=\"round\" d=\"M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14\" /></svg>\r\n                            </a>\r\n                        </div>\r\n                    </div>\r\n                </div>\r\n\r\n                ");
				jteOutput.writeContent("\r\n                <div class=\"lg:col-span-7 order-1 lg:order-2\">\r\n                    <div class=\"sticky top-24\">\r\n                        <div id=\"receipt-container\" class=\"transition-opacity duration-200\">\r\n                            ");
				jteOutput.writeContent("\r\n                            ");
				gg.jte.generated.ondemand.fragments.JtereceiptGenerated.render(jteOutput, jteHtmlInterceptor, page);
				jteOutput.writeContent("\r\n                        </div>\r\n                    </div>\r\n                </div>\r\n            </div>\r\n\r\n            ");
				jteOutput.writeContent("\r\n            <div class=\"max-w-3xl border-t border-slate-200 mt-20 pt-16\">\r\n                ");
				gg.jte.generated.ondemand.components.Jtefaq_accordionGenerated.render(jteOutput, jteHtmlInterceptor, page);
				jteOutput.writeContent("\r\n            </div>\r\n            \r\n            ");
				jteOutput.writeContent("\r\n            <script type=\"application/ld+json\">\r\n                {\r\n                    \"@context\": \"https://schema.org\",\r\n                    \"@type\": \"FAQPage\",\r\n                    \"mainEntity\": [\r\n                        ");
				for (int i = 0; i < page.getFaqs().size(); i++) {
					jteOutput.writeContent("\r\n                        {\r\n                            \"@type\": \"Question\",\r\n                            \"name\": \"");
					jteOutput.setContext("script", null);
					jteOutput.writeUserContent(page.getFaqs().get(i).getQuestion());
					jteOutput.writeContent("\",\r\n                            \"acceptedAnswer\": {\r\n                                \"@type\": \"Answer\",\r\n                                \"text\": \"");
					jteOutput.setContext("script", null);
					jteOutput.writeUserContent(page.getFaqs().get(i).getAnswer());
					jteOutput.writeContent("\"\r\n                            }\r\n                        }\r\n                        ");
					if (i < page.getFaqs().size() - 1) {
						jteOutput.writeContent(",");
					}
					jteOutput.writeContent("\r\n                        ");
				}
				jteOutput.writeContent("\r\n                    ]\r\n                }\r\n            </script>\r\n        </div>\r\n    ");
			}
		});
		jteOutput.writeContent("\r\n");
	}
	public static void renderMap(gg.jte.html.HtmlTemplateOutput jteOutput, gg.jte.html.HtmlInterceptor jteHtmlInterceptor, java.util.Map<String, Object> params) {
		County county = (County)params.get("county");
		CountyPageContent page = (CountyPageContent)params.get("page");
		render(jteOutput, jteHtmlInterceptor, county, page);
	}
}
