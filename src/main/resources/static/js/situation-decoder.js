(function () {
  window.radonSituationDecoder = function () {
    return {
      situation: 'Inspection says 5.8 pCi/L in 22030. I am buying and need a seller credit. Basement home.',
      reading: null,
      zip: '22030',
      intent: 'buying',
      foundation: 'basement',
      noTest: false,
      resultBand: 'above_4',
      resultLabel: '4.0+ pCi/L',
      verdict: 'Action-level reading',
      routeSummary: 'Open the local cost plan and seller-credit path before negotiation starts.',
      toneClass: 'bg-rose-100 text-rose-800',
      get readingDisplay() {
        if (this.noTest) return 'No test found';
        return this.reading === null ? 'Not found yet' : this.reading.toFixed(1).replace(/\.0$/, '') + ' pCi/L';
      },
      get intentLabel() {
        if (this.intent === 'buying') return 'Buying';
        if (this.intent === 'selling') return 'Selling';
        return 'Living here';
      },
      get foundationLabel() {
        if (this.foundation === 'crawlspace') return 'Crawl space';
        if (this.foundation === 'slab') return 'Slab';
        if (this.foundation === 'basement') return 'Basement';
        return 'Unknown';
      },
      get primaryCta() {
        if (this.noTest) return 'Open testing-first plan';
        if (this.needsCreditPath) return 'Open local credit path';
        return 'Open local action plan';
      },
      get needsCreditPath() {
        return (this.intent === 'buying' || this.intent === 'selling')
          && (this.resultBand === 'above_4' || this.resultBand === 'between_2_and_4');
      },
      get targetAction() {
        return this.needsCreditPath ? '/search-zip-credit' : '/search-zip';
      },
      loadExample(type) {
        if (type === 'buyer') {
          this.situation = 'Inspection says 5.8 pCi/L in 22030. I am buying and need a seller credit. Basement home.';
        } else if (type === 'homeowner') {
          this.situation = 'Our long-term monitor shows 2.7 pCi/L in 20147. We live here and have a slab-on-grade home.';
        } else {
          this.situation = 'No radon test yet in 80525. Finished basement, family uses it every day. What should I do first?';
        }
        this.decode();
      },
      decode() {
        const raw = this.situation || '';
        const text = raw.toLowerCase();
        const zipMatch = raw.match(/\b(?!00000)(\d{5})(?:-\d{4})?\b/);
        const unitMatch = raw.match(/\b(\d{1,3}(?:\.\d+)?)\s*(?:p\s*ci\s*\/?\s*l|pci\/?l|picocuries?)\b/i);
        const contextMatch = raw.match(/\b(?:radon|level|result|reading|tested|test(?:ed)? at|came back(?: at)?)\D{0,24}(\d{1,2}(?:\.\d+)?)\b/i);
        const parsedReading = unitMatch ? Number.parseFloat(unitMatch[1]) : contextMatch ? Number.parseFloat(contextMatch[1]) : null;

        this.zip = zipMatch ? zipMatch[1] : '';
        this.reading = Number.isFinite(parsedReading) ? parsedReading : null;
        this.noTest = /\b(no test|no radon test|not tested|untested|without a test|need(?:s)? a test|test kit|how to test)\b/i.test(text);

        if (/\b(buy|buyer|buying|purchase|purchasing|inspection|closing|contract|escrow)\b/i.test(text)) {
          this.intent = 'buying';
        } else if (/\b(sell|seller|selling|listing|listed|realtor|agent)\b/i.test(text)) {
          this.intent = 'selling';
        } else {
          this.intent = 'homeowner';
        }

        if (/crawl[ -]?space|crawlspace/i.test(text)) {
          this.foundation = 'crawlspace';
        } else if (/slab|slab-on-grade|slab on grade/i.test(text)) {
          this.foundation = 'slab';
        } else if (/basement|cellar|lowest level/i.test(text)) {
          this.foundation = 'basement';
        } else {
          this.foundation = 'unknown';
        }

        if (this.noTest || this.reading === null) {
          this.resultBand = 'not_tested';
          this.resultLabel = 'No test';
          this.verdict = 'Test first';
          this.routeSummary = 'Start with a valid test setup before pricing mitigation or negotiating a credit.';
          this.toneClass = 'bg-sky-100 text-sky-800';
          return;
        }

        if (this.reading < 2) {
          this.resultBand = 'under_2';
          this.resultLabel = 'Under 2.0';
          this.verdict = 'Low reading';
          this.routeSummary = 'Keep the result, retest after major home changes, and avoid panic quotes.';
          this.toneClass = 'bg-emerald-100 text-emerald-800';
          return;
        }

        if (this.reading < 4) {
          this.resultBand = 'between_2_and_4';
          this.resultLabel = '2.0-3.9';
          this.verdict = 'Borderline reading';
          this.routeSummary = this.intent === 'homeowner'
            ? 'Retest or monitor before committing to a bid; price mitigation only if the home has compounding risk.'
            : 'Use the borderline result carefully: confirm test validity, then keep local cost context ready for negotiation.';
          this.toneClass = 'bg-amber-100 text-amber-800';
          return;
        }

        this.resultBand = 'above_4';
        this.resultLabel = '4.0+ pCi/L';
        this.verdict = 'Action-level reading';
        this.routeSummary = this.intent === 'homeowner'
          ? 'Open the local cost plan and quote coach before calling contractors.'
          : 'Open the local credit calculator with county cost anchors before negotiation starts.';
        this.toneClass = 'bg-rose-100 text-rose-800';
      }
    };
  };
})();
