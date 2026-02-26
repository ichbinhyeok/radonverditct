@import gg.jte.Content

@param String title
@param String description = "National Radon Mitigation Cost Calculator"
@param String canonicalUrl = null
@param boolean noindex = false
@param Content headContent = null
@param Content content

<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${title}</title>
    
    <!-- Google tag (gtag.js) -->
    <script async src="https://www.googletagmanager.com/gtag/js?id=G-7C2TPP3S8N"></script>
    <script>
      window.dataLayer = window.dataLayer || [];
      function gtag(){dataLayer.push(arguments);}
      gtag('js', new Date());

      gtag('config', 'G-7C2TPP3S8N');
    </script>
    <script>
      (function () {
        const telemetryEndpoint = '/api/telemetry/events';
        const sentScrollDepth = new Set();

        function sendServerEvent(payload) {
          const body = JSON.stringify(payload);
          if (navigator.sendBeacon) {
            const blob = new Blob([body], { type: 'application/json' });
            navigator.sendBeacon(telemetryEndpoint, blob);
            return;
          }
          fetch(telemetryEndpoint, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: body,
            keepalive: true
          }).catch(function () {});
        }

        window.rvTrack = function (eventName, payload) {
          const safePayload = payload || {};
          if (typeof gtag === 'function') {
            gtag('event', eventName, safePayload);
          }
          sendServerEvent({
            event: eventName,
            payload: safePayload,
            path: window.location.pathname,
            ts: new Date().toISOString()
          });
        };

        function trackScrollDepth() {
          const doc = document.documentElement;
          const scrollable = Math.max(doc.scrollHeight - window.innerHeight, 1);
          const depth = Math.round((window.scrollY / scrollable) * 100);
          [25, 50, 75, 90].forEach(function (threshold) {
            if (depth >= threshold && !sentScrollDepth.has(threshold)) {
              sentScrollDepth.add(threshold);
              window.rvTrack('scroll_depth', { percent: threshold });
            }
          });
        }

        document.addEventListener('DOMContentLoaded', function () {
          window.rvTrack('page_view', { title: document.title });

          window.addEventListener('scroll', trackScrollDepth, { passive: true });

          document.addEventListener('click', function (event) {
            const trackedElement = event.target.closest('[data-track-event]');
            if (trackedElement) {
              window.rvTrack(trackedElement.dataset.trackEvent, {
                label: trackedElement.dataset.trackLabel || '',
                href: trackedElement.getAttribute('href') || ''
              });
              return;
            }

            const link = event.target.closest('a[href]');
            if (!link) {
              return;
            }

            const href = link.getAttribute('href');
            if (!href || href.startsWith('/') || href.startsWith('#')) {
              return;
            }

            const sameHost = href.indexOf(window.location.host) !== -1;
            if (!sameHost) {
              window.rvTrack('outbound_click', { href: href, text: (link.textContent || '').trim() });
            }
          }, true);
        });
      })();
    </script>
    <meta name="description" content="${description}">
    <link rel="icon" type="image/svg+xml" href="/favicon.svg">
    @if(canonicalUrl != null)
        <link rel="canonical" href="${canonicalUrl}">
    @endif
    @if(noindex)
        <meta name="robots" content="noindex, nofollow">
    @endif
    @if(headContent != null)
        ${headContent}
    @endif
    
    <!-- Google Fonts: Outfit (Display) & Inter (Numbers/Body) -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Outfit:wght@500;700;800;900&display=swap" rel="stylesheet">
    
    <!-- Tailwind CSS CDN (Configured for startup look) -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    fontFamily: {
                        sans: ['Inter', 'sans-serif'],
                        display: ['Outfit', 'sans-serif'],
                    },
                    colors: {
                        brand: {
                            50: '#f8fafc',
                            100: '#f1f5f9',
                            400: '#94a3b8',
                            500: '#64748b',
                            600: '#475569',
                            900: '#0f172a', /* Deep slate navy for premium feel */
                        }
                    }
                }
            }
        }
    </script>
    
    <!-- HTMX & Alpine.js -->
    <script src="https://unpkg.com/htmx.org@1.9.10"></script>
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.13.3/dist/cdn.min.js"></script>
    
    <style>
        .glass-header {
            background: rgba(255, 255, 255, 0.85);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border-bottom: 1px solid rgba(226, 232, 240, 0.8);
        }
        .tabular-nums {
            font-variant-numeric: tabular-nums;
        }
        [x-cloak] { display: none !important; }
    </style>
</head>
<body class="bg-slate-50 text-slate-800 font-sans antialiased selection:bg-brand-900 selection:text-white flex flex-col min-h-screen">
    
    <!-- Glassmorphism Navbar -->
    <header class="sticky top-0 z-50 glass-header">
        <div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between">
            <a href="/" class="flex items-center gap-2 group">
                <div class="w-8 h-8 rounded-lg bg-slate-900 text-white flex items-center justify-center font-display font-bold text-lg shadow-sm group-hover:bg-slate-700 transition-colors">
                    R
                </div>
                <span class="font-display font-bold text-xl tracking-tight text-slate-900">Radon<span class="text-slate-400">Verdict</span></span>
            </a>
            <nav class="hidden md:flex gap-6 text-sm font-medium text-slate-500">
                <a href="/radon-cost-calculator" class="hover:text-slate-900 transition-colors">Cost Calculator</a>
                <a href="/guides" class="hover:text-slate-900 transition-colors">Guides</a>
                <a href="/about" class="hover:text-slate-900 transition-colors">About</a>
            </nav>
        </div>
    </header>

    <!-- Main Content Injection -->
    <main class="flex-grow flex flex-col">
        ${content}
    </main>

    <!-- ${java.time.LocalDate.now().getYear()} SaaS Style Minimal Footer -->
    <footer class="bg-white border-t border-slate-100 mt-20">
        <div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
            <div class="grid grid-cols-1 md:grid-cols-4 gap-8">
                <div class="col-span-1 md:col-span-2">
                    <span class="font-display font-bold text-lg tracking-tight text-slate-900">Radon<span class="text-slate-400">Verdict</span></span>
                    <p class="mt-4 text-sm text-slate-500 leading-relaxed max-w-sm">
                        Empowering homeowners with localized data. We analyze EPA zone risks, structure types, and local labor rates to provide precise estimates.
                    </p>
                </div>
                <div>
                    <h4 class="font-bold text-slate-900 mb-4 text-sm uppercase tracking-wider">Company</h4>
                    <ul class="space-y-3 text-sm font-medium text-slate-500">
                        <li><a href="/about" class="hover:text-indigo-600 transition-colors">About Us</a></li>
                        <li><a href="/contact" class="hover:text-indigo-600 transition-colors">Contact</a></li>
                        <li><a href="/radon-cost-calculator" class="hover:text-indigo-600 transition-colors">Cost Calculator</a></li>
                        <li><a href="/guides" class="hover:text-indigo-600 transition-colors">Guides</a></li>
                        <li><a href="/guides/how-to-test-for-radon" class="hover:text-indigo-600 transition-colors">How to Test for Radon</a></li>
                    </ul>
                </div>
                <div>
                    <h4 class="font-bold text-slate-900 mb-4 text-sm uppercase tracking-wider">Legal</h4>
                    <ul class="space-y-3 text-sm font-medium text-slate-500">
                        <li><a href="/privacy" class="hover:text-indigo-600 transition-colors">Privacy Policy</a></li>
                        <li><a href="/terms" class="hover:text-indigo-600 transition-colors">Terms of Service</a></li>
                    </ul>
                </div>
            </div>
            <div class="border-t border-slate-100 mt-12 pt-8 flex flex-col md:flex-row justify-between items-center gap-4">
                <div class="text-xs text-slate-400 font-medium">
                    &copy; ${java.time.LocalDate.now().getYear()} RadonVerdict. Not affiliated with the US EPA or any government agency.
                </div>
            </div>
        </div>
    </footer>
</body>
</html>
