@import gg.jte.Content
@import com.radonverdict.util.JsonLdUtils

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

      gtag('config', 'G-7C2TPP3S8N', { send_page_view: false });
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

        function getPageContext() {
          const path = window.location.pathname || '/';
          const segments = path.split('/').filter(Boolean);
          const query = new URLSearchParams(window.location.search || '');
          const context = {
            title: document.title,
            page_path: path
          };

          if (segments.length === 0) {
            context.page_type = 'home';
            return context;
          }

          if (segments[0] === 'radon-levels') {
            context.page_type = segments.length >= 3 ? 'levels_county' : segments.length === 2 ? 'levels_state' : 'levels_index';
          } else if (segments[0] === 'radon-mitigation-cost') {
            context.page_type = segments.length >= 3 ? 'cost_county' : segments.length === 2 ? 'cost_state' : 'cost_index';
          } else if (segments[0] === 'radon-credit-calculator') {
            context.page_type = segments.length >= 3 ? 'credit_county' : 'credit_index';
          } else if (segments[0] === 'guides') {
            context.page_type = segments.length >= 2 ? 'guide_article' : 'guides_index';
            if (segments.length >= 2) {
              context.article_slug = segments[1];
            }
          } else {
            context.page_type = segments[0];
          }

          if ((segments[0] === 'radon-levels' || segments[0] === 'radon-mitigation-cost' || segments[0] === 'radon-credit-calculator') && segments.length >= 2) {
            context.state = segments[1];
          }
          if ((segments[0] === 'radon-levels' || segments[0] === 'radon-mitigation-cost' || segments[0] === 'radon-credit-calculator') && segments.length >= 3) {
            context.county = segments[2];
          }
          if (query.get('radonResultBand')) {
            context.result_band = query.get('radonResultBand');
          }
          if (query.get('intent')) {
            context.intent = query.get('intent');
          }

          return context;
        }

        function getHrefHost(href) {
          if (!href) {
            return '';
          }
          try {
            return new URL(href, window.location.origin).hostname || '';
          } catch (error) {
            return '';
          }
        }

        function getElementText(element) {
          if (!element || !element.textContent) {
            return '';
          }
          return element.textContent.replace(/\s+/g, ' ').trim();
        }

        function normalizeAffiliatePayload(payload) {
          const raw = payload || {};
          const ctaId = raw.cta_id || raw.event_label || raw.label || '';
          const placementId = raw.placement_id || raw.placement || '';
          const offerType = raw.offer_type || raw.product || '';
          const offerBrand = raw.offer_brand || (offerType === 'test_kit' ? 'first_alert' : offerType === 'monitor' ? 'airthings' : '');
          const offerModel = raw.offer_model || (offerType === 'test_kit' ? 'rd1' : offerType === 'monitor' ? 'corentium_home' : '');
          const journeyStage = raw.journey_stage || (offerType === 'test_kit' ? 'first_test' : offerType === 'monitor' ? 'followup_monitor' : '');

          return {
            cta_id: ctaId,
            monetization_channel: raw.monetization_channel || 'affiliate',
            offer_type: offerType,
            offer_brand: offerBrand,
            offer_model: offerModel,
            placement_group: raw.placement_group || '',
            placement_id: placementId,
            journey_stage: journeyStage,
            merchant: raw.merchant || 'amazon',
            destination: raw.destination || 'amazon_product',
            href: raw.href || '',
            destination_host: raw.destination_host || getHrefHost(raw.href || ''),
            cta_text: raw.cta_text || ''
          };
        }

        window.rvTrack = function (eventName, payload, options) {
          const safePayload = Object.assign({}, getPageContext(), payload || {});
          if (typeof gtag === 'function') {
            const gtagPayload = Object.assign({}, safePayload, options || {});
            gtag('event', eventName, gtagPayload);
          }
          sendServerEvent({
            event: eventName,
            payload: safePayload,
            path: window.location.pathname,
            ts: new Date().toISOString()
          });
        };

        window.rvTrackAffiliateClick = function (element, payload) {
          const href = element && typeof element.getAttribute === 'function' ? (element.getAttribute('href') || '') : '';
          const ctaText = getElementText(element);
          const normalizedPayload = normalizeAffiliatePayload(Object.assign({}, payload || {}, {
            href: href,
            destination_host: getHrefHost(href),
            cta_text: ctaText
          }));
          window.rvTrack('affiliate_link_click', normalizedPayload);
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
          window.rvTrack('page_view', getPageContext());

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
            if (link.dataset.rvAffiliateLink === 'true') {
              return;
            }

            const sameHost = href.indexOf(window.location.host) !== -1;
            if (!sameHost) {
              window.rvTrack('outbound_click', {
                href: href,
                destination_host: getHrefHost(href),
                cta_text: getElementText(link)
              });
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
        <meta name="robots" content="noindex, follow">
    @endif
    @if(canonicalUrl != null && canonicalUrl.startsWith("https://radonverdict.com/guides/"))
        <script type="application/ld+json">
            {
                "@context": "https://schema.org",
                "@type": "Article",
                "headline": $unsafe{JsonLdUtils.json(title)},
                "description": $unsafe{JsonLdUtils.json(description)},
                "mainEntityOfPage": {
                    "@type": "WebPage",
                    "@id": $unsafe{JsonLdUtils.json(canonicalUrl)}
                },
                "author": {
                    "@type": "Organization",
                    "name": "RadonVerdict Editorial Team"
                },
                "publisher": {
                    "@type": "Organization",
                    "name": "RadonVerdict"
                },
                "inLanguage": "en-US"
            }
        </script>
    @endif
    @if(headContent != null)
        ${headContent}
    @endif
    
    <!-- Open Graph & Social Cards -->
    <meta property="og:title" content="${title}">
    <meta property="og:description" content="${description}">
    <meta property="og:type" content="website">
    @if(canonicalUrl != null)
        <meta property="og:url" content="${canonicalUrl}">
    @endif
    <meta property="og:site_name" content="RadonVerdict">
    <meta property="og:image" content="https://radonverdict.com/images/default-og.png">
    
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="${title}">
    <meta name="twitter:description" content="${description}">
    <meta name="twitter:image" content="https://radonverdict.com/images/default-og.png">
    
    <!-- Google Fonts: Outfit (Display) & Inter (Numbers/Body) -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Outfit:wght@500;700;800;900&display=swap" rel="stylesheet">
    
    <!-- Pre-built locally hosted Tailwind CSS -->
    <link href="/css/style.css" rel="stylesheet">
    <link href="/css/mobile-overrides.css" rel="stylesheet">
    
    <!-- HTMX & Alpine.js -->
    <script src="https://unpkg.com/htmx.org@1.9.10"></script>
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.13.3/dist/cdn.min.js"></script>
</head>
<body class="bg-slate-50 text-slate-800 font-sans antialiased selection:bg-brand-900 selection:text-white flex flex-col min-h-screen">
    
    <!-- Glassmorphism Navbar -->
    <header x-data="{ mobileNavOpen: false }" class="sticky top-0 z-50 glass-header">
        <div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 min-h-16 flex items-center justify-between gap-3">
            <a href="/" class="tap-target-inline flex items-center gap-2 group rounded-xl">
                <div class="w-8 h-8 rounded-lg bg-slate-900 text-white flex items-center justify-center font-display font-bold text-lg shadow-sm group-hover:bg-slate-700 transition-colors">
                    R
                </div>
                <span class="font-display font-bold text-xl tracking-tight text-slate-900">Radon<span class="text-slate-400">Verdict</span></span>
            </a>
            <nav class="hidden md:flex gap-6 text-sm font-medium text-slate-500">
                <a href="/radon-cost-calculator" class="tap-target-inline hover:text-slate-900 transition-colors">Action Plan</a>
                <a href="/guides/how-to-test-for-radon" class="tap-target-inline hover:text-slate-900 transition-colors">Testing Guide</a>
                <a href="/guides" class="tap-target-inline hover:text-slate-900 transition-colors">Guides</a>
                <a href="/about" class="tap-target-inline hover:text-slate-900 transition-colors">About</a>
            </nav>
            <button type="button"
                    @click="mobileNavOpen = !mobileNavOpen"
                    :aria-expanded="mobileNavOpen.toString()"
                    aria-controls="mobile-nav-panel"
                    aria-label="Toggle navigation"
                    class="tap-target md:hidden inline-flex items-center justify-center rounded-xl border border-slate-200 bg-white/80 text-slate-700 shadow-sm transition-colors hover:bg-white hover:text-slate-900">
                <svg x-show="!mobileNavOpen" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M4 7h16M4 12h16M4 17h16" />
                </svg>
                <svg x-show="mobileNavOpen" x-cloak class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
                </svg>
            </button>
        </div>
        <div id="mobile-nav-panel"
             x-show="mobileNavOpen"
             x-transition.opacity.duration.150ms
             x-cloak
             class="md:hidden border-t border-slate-200/80 bg-white/95 backdrop-blur-sm">
            <nav class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-3 flex flex-col">
                <a href="/radon-cost-calculator" class="tap-target-inline rounded-xl px-3 text-slate-700 hover:bg-slate-100 hover:text-slate-900">Action Plan</a>
                <a href="/guides/how-to-test-for-radon" class="tap-target-inline rounded-xl px-3 text-slate-700 hover:bg-slate-100 hover:text-slate-900">Testing Guide</a>
                <a href="/guides" class="tap-target-inline rounded-xl px-3 text-slate-700 hover:bg-slate-100 hover:text-slate-900">Guides</a>
                <a href="/about" class="tap-target-inline rounded-xl px-3 text-slate-700 hover:bg-slate-100 hover:text-slate-900">About</a>
                <a href="/contact" class="tap-target-inline rounded-xl px-3 text-slate-700 hover:bg-slate-100 hover:text-slate-900">Contact</a>
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
                        <li><a href="/about" class="tap-target-inline hover:text-indigo-600 transition-colors">About Us</a></li>
                        <li><a href="/contact" class="tap-target-inline hover:text-indigo-600 transition-colors">Contact</a></li>
                        <li><a href="/radon-cost-calculator" class="tap-target-inline hover:text-indigo-600 transition-colors">Action Plan</a></li>
                        <li><a href="/guides/how-to-test-for-radon" class="tap-target-inline hover:text-indigo-600 transition-colors">Testing Guide</a></li>
                        <li><a href="/guides" class="tap-target-inline hover:text-indigo-600 transition-colors">Guides</a></li>
                    </ul>
                </div>
                <div>
                    <h4 class="font-bold text-slate-900 mb-4 text-sm uppercase tracking-wider">Legal</h4>
                    <ul class="space-y-3 text-sm font-medium text-slate-500">
                        <li><a href="/privacy" class="tap-target-inline hover:text-indigo-600 transition-colors">Privacy Policy</a></li>
                        <li><a href="/terms" class="tap-target-inline hover:text-indigo-600 transition-colors">Terms of Service</a></li>
                    </ul>
                </div>
            </div>
            <div class="border-t border-slate-100 mt-12 pt-8 flex flex-col md:flex-row justify-between items-center gap-4">
                <div class="text-xs text-slate-400 font-medium">
                    &copy; ${java.time.LocalDate.now().getYear()} RadonVerdict. Not affiliated with the US EPA or any government agency.
                </div>
                <div class="text-xs text-slate-400 font-medium text-center md:text-right">
                    As an Amazon Associate, RadonVerdict earns from qualifying purchases.
                </div>
            </div>
        </div>
    </footer>
</body>
</html>
