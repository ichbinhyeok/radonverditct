@import gg.jte.Content
@import com.radonverdict.util.JsonLdUtils

@param String title
@param String description = "National Radon Mitigation Cost Calculator"
@param String canonicalUrl = null
@param boolean noindex = false
@param boolean minimalChrome = false
@param String articlePublished = null
@param String articleModified = null
@param Content headContent = null
@param Content content

<!DOCTYPE html>
<html lang="en" class="scroll-smooth">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="rv-tracking-version" content="2026-04-22-tracking-v2">
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
        const trackingVersion = '2026-04-22-tracking-v2';
        const telemetryEndpoint = '/api/telemetry/events';
        const sentScrollDepth = new Set();

        window.__rvTrackingVersion = trackingVersion;

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
            page_path: path,
            tracking_version: trackingVersion
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
          if (/^[a-z0-9_-]{2,60}$/.test(query.get('source') || '')) {
            context.acquisition_source = query.get('source');
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

        function setupImpressionTracking() {
          const impressionElements = Array.from(document.querySelectorAll('[data-track-impression]'));
          if (!impressionElements.length) {
            return;
          }

          const sendImpression = function (element) {
            if (!element || element.dataset.rvImpressionSent === 'true') {
              return;
            }
            element.dataset.rvImpressionSent = 'true';
            window.rvTrack(element.dataset.trackImpression, {
              label: element.dataset.trackLabel || '',
              element_id: element.id || '',
              cta_text: getElementText(element).slice(0, 120)
            });
          };

          if (!('IntersectionObserver' in window)) {
            impressionElements.forEach(sendImpression);
            return;
          }

          const observer = new IntersectionObserver(function (entries) {
            entries.forEach(function (entry) {
              if (entry.isIntersecting) {
                sendImpression(entry.target);
                observer.unobserve(entry.target);
              }
            });
          }, { threshold: 0.35 });

          impressionElements.forEach(function (element) {
            observer.observe(element);
          });
        }

        document.addEventListener('DOMContentLoaded', function () {
          if (!window.__rvSuppressGenericPageView) {
            window.rvTrack('page_view', getPageContext());
          }

          window.addEventListener('scroll', trackScrollDepth, { passive: true });
          setupImpressionTracking();

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
                    "name": "RadonVerdict Editorial Team",
                    "url": "https://radonverdict.com/about"
                },
                "publisher": {
                    "@type": "Organization",
                    "name": "RadonVerdict"
                },
                "inLanguage": "en-US"@if(articlePublished != null),
                "datePublished": $unsafe{JsonLdUtils.json(articlePublished)}@endif@if(articleModified != null),
                "dateModified": $unsafe{JsonLdUtils.json(articleModified)}@endif
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
    
    <!-- RadonVerdict design system: Fraunces (display) + Source Sans 3 (body/data) -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,600;9..144,700;9..144,800;9..144,900&family=Source+Sans+3:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    
    <!-- Pre-built locally hosted Tailwind CSS -->
    <link href="/css/style.css" rel="stylesheet">
    <link href="/css/mobile-overrides.css" rel="stylesheet">
    
    <!-- HTMX & Alpine.js -->
    <script defer src="https://unpkg.com/htmx.org@1.9.10"></script>
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.13.3/dist/cdn.min.js"></script>
</head>
<body class="bg-paper-light text-ink font-sans antialiased selection:bg-signal selection:text-ink flex flex-col min-h-screen">
    
    @if(!minimalChrome)
    <header x-data="{ mobileNavOpen: false }" class="sticky top-0 z-50 border-b border-paper-rule bg-paper-light/95 backdrop-blur-sm">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 min-h-16 flex items-center justify-between gap-3">
            <a href="/" class="tap-target-inline flex items-center gap-3 group rounded-lg">
                <div class="w-8 h-8 rounded bg-ink text-signal flex items-center justify-center font-sans font-black text-sm transition-colors group-hover:bg-pine">RV</div>
                <span class="font-display font-bold text-xl tracking-tight text-ink">RadonVerdict</span>
            </a>
            <nav class="hidden lg:flex items-center gap-6 text-sm font-bold text-stone-600">
                <a href="/radon-test-planner" class="tap-target-inline text-pine hover:text-ink transition-colors">Test planner</a>
                <a href="/guides" class="tap-target-inline hover:text-ink transition-colors">Guides</a>
                <a href="/radon-levels" class="tap-target-inline hover:text-ink transition-colors">Local evidence</a>
                <a href="/radon-data-sources" class="tap-target-inline hover:text-ink transition-colors">Sources</a>
                <a href="/radon-test-planner" class="inline-flex min-h-10 items-center rounded bg-ink px-4 font-black text-white transition-colors hover:bg-pine">Start a test record</a>
            </nav>
            <button type="button"
                    @click="mobileNavOpen = !mobileNavOpen"
                    :aria-expanded="mobileNavOpen.toString()"
                    aria-controls="mobile-nav-panel"
                    aria-label="Toggle navigation"
                    class="tap-target lg:hidden inline-flex h-12 w-12 shrink-0 items-center justify-center rounded-lg border border-paper-rule bg-paper-light text-ink transition-colors hover:bg-paper">
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
             class="lg:hidden border-t border-paper-rule bg-paper-light">
            <nav class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-3 flex flex-col">
                <a href="/radon-test-planner" class="tap-target-inline rounded-lg px-3 font-black text-pine hover:bg-paper">Start a test record</a>
                <a href="/guides" class="tap-target-inline rounded-lg px-3 text-stone-700 hover:bg-paper">Guide library</a>
                <a href="/radon-levels" class="tap-target-inline rounded-lg px-3 text-stone-700 hover:bg-paper">Local evidence</a>
                <a href="/radon-data-sources" class="tap-target-inline rounded-lg px-3 text-stone-700 hover:bg-paper">Sources</a>
                <a href="/methodology" class="tap-target-inline rounded-lg px-3 text-stone-700 hover:bg-paper">Methodology</a>
                <a href="/about" class="tap-target-inline rounded-lg px-3 text-stone-700 hover:bg-paper">About</a>
            </nav>
        </div>
    </header>
    @endif

    <!-- Main Content Injection -->
    <main class="flex-grow flex flex-col min-w-0 w-full">
        ${content}
    </main>

    @if(!minimalChrome)
    <footer class="bg-ink text-white border-t border-ink mt-20">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
            <div class="grid grid-cols-1 md:grid-cols-4 gap-8">
                <div class="col-span-1 md:col-span-2">
                    <span class="font-display font-bold text-2xl tracking-tight">RadonVerdict</span>
                    <p class="mt-4 text-sm text-stone-300 leading-relaxed max-w-md">
                        Set up, document, and check a home radon test against source-linked guidance. A procedural check is not a property or medical diagnosis.
                    </p>
                </div>
                <div>
                    <h4 class="font-black mb-4 text-sm uppercase tracking-wider text-signal">Test</h4>
                    <ul class="space-y-3 text-sm font-semibold text-stone-300">
                        <li><a href="/radon-test-planner" class="tap-target-inline hover:text-signal transition-colors">Test planner</a></li>
                        <li><a href="/guides" class="tap-target-inline hover:text-signal transition-colors">Guide library</a></li>
                        <li><a href="/radon-test-result-meaning" class="tap-target-inline hover:text-signal transition-colors">Record a result</a></li>
                        <li><a href="/radon-levels" class="tap-target-inline hover:text-signal transition-colors">Local evidence</a></li>
                    </ul>
                </div>
                <div>
                    <h4 class="font-black mb-4 text-sm uppercase tracking-wider text-signal">Evidence</h4>
                    <ul class="space-y-3 text-sm font-semibold text-stone-300">
                        <li><a href="/methodology" class="tap-target-inline hover:text-signal transition-colors">Methodology</a></li>
                        <li><a href="/radon-data-sources" class="tap-target-inline hover:text-signal transition-colors">Data sources</a></li>
                        <li><a href="/about" class="tap-target-inline hover:text-signal transition-colors">About</a></li>
                        <li><a href="/privacy" class="tap-target-inline hover:text-signal transition-colors">Privacy</a></li>
                        <li><a href="/terms" class="tap-target-inline hover:text-signal transition-colors">Terms</a></li>
                    </ul>
                </div>
            </div>
            <div class="border-t border-stone-700 mt-12 pt-8 flex flex-col md:flex-row justify-between items-center gap-4">
                <div class="text-xs text-stone-400 font-medium">
                    &copy; ${java.time.LocalDate.now().getYear()} RadonVerdict. Not affiliated with the US EPA or any government agency.
                </div>
                <div class="text-xs text-stone-400 font-medium text-center md:text-right">
                    As an Amazon Associate, RadonVerdict earns from qualifying purchases.
                </div>
            </div>
        </div>
    </footer>
    @endif
</body>
</html>
