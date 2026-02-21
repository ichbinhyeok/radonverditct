package gg.jte.generated.ondemand.layout;
import gg.jte.Content;
@SuppressWarnings("unchecked")
public final class JtemainGenerated {
	public static final String JTE_NAME = "layout/main.jte";
	public static final int[] JTE_LINE_INFO = {0,0,2,2,2,2,11,11,11,11,12,12,12,12,12,12,12,12,12,14,19,36,44,63,78,80,80,80,83,101,101,101,2,3,4,4,4,4};
	public static void render(gg.jte.html.HtmlTemplateOutput jteOutput, gg.jte.html.HtmlInterceptor jteHtmlInterceptor, String title, String description, Content content) {
		jteOutput.writeContent("\r\n<!DOCTYPE html>\r\n<html lang=\"en\" class=\"scroll-smooth\">\r\n<head>\r\n    <meta charset=\"UTF-8\">\r\n    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\r\n    <title>");
		jteOutput.setContext("title", null);
		jteOutput.writeUserContent(title);
		jteOutput.writeContent("</title>\r\n    <meta name=\"description\"");
		var __jte_html_attribute_0 = description;
		if (gg.jte.runtime.TemplateUtils.isAttributeRendered(__jte_html_attribute_0)) {
			jteOutput.writeContent(" content=\"");
			jteOutput.setContext("meta", "content");
			jteOutput.writeUserContent(__jte_html_attribute_0);
			jteOutput.setContext("meta", null);
			jteOutput.writeContent("\"");
		}
		jteOutput.writeContent(">\r\n    \r\n    ");
		jteOutput.writeContent("\r\n    <link rel=\"preconnect\" href=\"https://fonts.googleapis.com\">\r\n    <link rel=\"preconnect\" href=\"https://fonts.gstatic.com\" crossorigin>\r\n    <link href=\"https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Outfit:wght@500;700;800;900&display=swap\" rel=\"stylesheet\">\r\n    \r\n    ");
		jteOutput.writeContent("\r\n    <script src=\"https://cdn.tailwindcss.com\"></script>\r\n    <script>\r\n        tailwind.config = {\r\n            theme: {\r\n                extend: {\r\n                    fontFamily: {\r\n                        sans: ['Inter', 'sans-serif'],\r\n                        display: ['Outfit', 'sans-serif'],\r\n                    },\r\n                    colors: {\r\n                        brand: {\r\n                            50: '#f8fafc',\r\n                            100: '#f1f5f9',\r\n                            400: '#94a3b8',\r\n                            500: '#64748b',\r\n                            600: '#475569',\r\n                            900: '#0f172a', ");
		jteOutput.writeContent("\r\n                        }\r\n                    }\r\n                }\r\n            }\r\n        }\r\n    </script>\r\n    \r\n    ");
		jteOutput.writeContent("\r\n    <script src=\"https://unpkg.com/htmx.org@1.9.10\"></script>\r\n    <script defer src=\"https://cdn.jsdelivr.net/npm/alpinejs@3.13.3/dist/cdn.min.js\"></script>\r\n    \r\n    <style>\r\n        .glass-header {\r\n            background: rgba(255, 255, 255, 0.85);\r\n            backdrop-filter: blur(12px);\r\n            -webkit-backdrop-filter: blur(12px);\r\n            border-bottom: 1px solid rgba(226, 232, 240, 0.8);\r\n        }\r\n        .tabular-nums {\r\n            font-variant-numeric: tabular-nums;\r\n        }\r\n        [x-cloak] { display: none !important; }\r\n    </style>\r\n</head>\r\n<body class=\"bg-slate-50 text-slate-800 font-sans antialiased selection:bg-brand-900 selection:text-white flex flex-col min-h-screen\">\r\n    \r\n    ");
		jteOutput.writeContent("\r\n    <header class=\"sticky top-0 z-50 glass-header\">\r\n        <div class=\"max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between\">\r\n            <a href=\"/radon-cost-calculator\" class=\"flex items-center gap-2 group\">\r\n                <div class=\"w-8 h-8 rounded-lg bg-slate-900 text-white flex items-center justify-center font-display font-bold text-lg shadow-sm group-hover:bg-slate-700 transition-colors\">\r\n                    R\r\n                </div>\r\n                <span class=\"font-display font-bold text-xl tracking-tight text-slate-900\">Radon<span class=\"text-slate-400\">Verdict</span></span>\r\n            </a>\r\n            <nav class=\"hidden md:flex gap-6 text-sm font-medium text-slate-500\">\r\n                <a href=\"/radon-cost-calculator\" class=\"hover:text-slate-900 transition-colors\">Cost Calculator</a>\r\n            </nav>\r\n        </div>\r\n    </header>\r\n\r\n    ");
		jteOutput.writeContent("\r\n    <main class=\"flex-grow flex flex-col\">\r\n        ");
		jteOutput.setContext("main", null);
		jteOutput.writeUserContent(content);
		jteOutput.writeContent("\r\n    </main>\r\n\r\n    ");
		jteOutput.writeContent("\r\n    <footer class=\"bg-white border-t border-slate-100 mt-20\">\r\n        <div class=\"max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-12\">\r\n            <div class=\"flex flex-col md:flex-row justify-between items-start md:items-center gap-6\">\r\n                <div>\r\n                    <span class=\"font-display font-bold text-lg tracking-tight text-slate-900\">RadonVerdict</span>\r\n                    <p class=\"mt-2 text-sm text-slate-400\">\r\n                        Empowering homeowners with localized mitigation data.\r\n                    </p>\r\n                </div>\r\n                <div class=\"text-xs text-slate-400 font-medium\">\r\n                    &copy; 2026 RadonVerdict. Not affiliated with the US EPA.\r\n                </div>\r\n            </div>\r\n        </div>\r\n    </footer>\r\n</body>\r\n</html>\r\n");
	}
	public static void renderMap(gg.jte.html.HtmlTemplateOutput jteOutput, gg.jte.html.HtmlInterceptor jteHtmlInterceptor, java.util.Map<String, Object> params) {
		String title = (String)params.get("title");
		String description = (String)params.getOrDefault("description", "National Radon Mitigation Cost Calculator");
		Content content = (Content)params.get("content");
		render(jteOutput, jteHtmlInterceptor, title, description, content);
	}
}
