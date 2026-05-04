@import com.radonverdict.model.County

@param County county
@param boolean costMode = false
@param String selectedResultBand = null

!{
    final double initialLevelValue;
    final boolean unconfirmedCostMode = costMode && (selectedResultBand == null || selectedResultBand.isBlank() || "not_tested".equals(selectedResultBand));
    if ("under_2".equals(selectedResultBand)) {
        initialLevelValue = 1.5;
    } else if ("between_2_and_4".equals(selectedResultBand)) {
        initialLevelValue = 3.0;
    } else if ("above_4".equals(selectedResultBand)) {
        initialLevelValue = 5.5;
    } else if (unconfirmedCostMode) {
        initialLevelValue = 3.0;
    } else {
        initialLevelValue = county.getEpaZone() == 1 ? 5.5 : county.getEpaZone() == 2 ? 3.0 : 1.5;
    }
    final String initialStatus = initialLevelValue >= 4.0 ? "danger" : initialLevelValue >= 2.0 ? "caution" : "safe";
    final String initialLevel = String.format(java.util.Locale.US, "%.1f", initialLevelValue);
    final String initialPostMitigationLow = String.format(java.util.Locale.US, "%.1f", Math.max(0.3, initialLevelValue * 0.05));
    final String initialPostMitigationHigh = String.format(java.util.Locale.US, "%.1f", Math.max(0.8, initialLevelValue * 0.15));
    final String safeInitialStyle = "safe".equals(initialStatus) ? null : "display:none";
    final String cautionInitialStyle = "caution".equals(initialStatus) ? null : "display:none";
    final String dangerInitialStyle = "danger".equals(initialStatus) ? null : "display:none";
    final int initialBarWidth = (int) Math.min((initialLevelValue / 20.0) * 100.0, 100.0);
    final String initialBarColor = initialLevelValue >= 4.0 ? "bg-red-500" : initialLevelValue >= 2.0 ? "bg-amber-400" : "bg-emerald-500";
    final String shortTermKitUrl = "https://www.amazon.com/dp/B00002N83E?tag=radonverdict-20";
    final String digitalMonitorUrl = "https://www.amazon.com/dp/B00H2VOSP8?tag=radonverdict-20";
}

<!-- Radon Level Decision Advisor: Pure Alpine.js (no server calls) -->
<div class="bg-white rounded-[2rem] p-6 sm:p-8 shadow-sm border border-slate-200 mb-6 max-w-2xl mx-auto"
     data-nosnippet
     x-data="{
        level: ${initialLevel},
        get status() {
            if (this.level >= 4.0) return 'danger';
            if (this.level >= 2.0) return 'caution';
            return 'safe';
        },
        get postMitigationLow() {
            return Math.max(0.3, this.level * 0.05).toFixed(1);
        },
        get postMitigationHigh() {
            return Math.max(0.8, this.level * 0.15).toFixed(1);
        },
        get barWidth() {
            return Math.min(this.level / 20 * 100, 100);
        },
        get barColor() {
            if (this.level >= 4.0) return 'bg-red-500';
            if (this.level >= 2.0) return 'bg-amber-400';
            return 'bg-emerald-500';
        }
     }">

    <div class="text-center mb-6">
        <h3 class="font-display font-bold text-slate-900 text-xl tracking-tight">
            @if(costMode)
                @if(unconfirmedCostMode)
                Try a Sample Radon Reading
                @else
                Use Your Confirmed Radon Reading
                @endif
            @else
                Your Radon Reading
            @endif
        </h3>
        <p class="text-slate-500 text-sm mt-1 font-medium">
            @if(costMode)
                @if(unconfirmedCostMode)
                You have not tested yet. Use a sample reading here to see how the action plan changes, then replace it with your real number later.
                @else
                Adjust the level to match your latest result and compare likely mitigation outcomes before pricing local quotes.
                @endif
            @else
                Enter your home's measured level or use the ${county.getAreaDisplayName()} average
            @endif
        </p>
    </div>

    <!-- The Big Number Display -->
    <div class="text-center mb-6">
        <div class="inline-flex items-baseline gap-1 tabular-nums">
            <span class="font-display font-black text-5xl sm:text-6xl tracking-tighter"
                  :class="status === 'danger' ? 'text-red-600' : status === 'caution' ? 'text-amber-600' : 'text-emerald-600'"
                  x-text="parseFloat(level).toFixed(1)">${initialLevel}</span>
            <span class="text-lg font-semibold text-slate-400">pCi/L</span>
        </div>
    </div>

    <!-- Range Slider -->
    <div class="px-2 mb-6">
        <input type="range" min="0.0" max="20.0" step="0.1"
               x-model="level"
               value="${initialLevel}"
               class="w-full h-2 rounded-full appearance-none cursor-pointer radon-slider"
               :class="status === 'danger' ? 'accent-red-500' : status === 'caution' ? 'accent-amber-500' : 'accent-emerald-500'">
        <div class="flex justify-between text-[10px] font-bold text-slate-300 mt-1 px-1 uppercase tracking-widest">
            <span>0</span>
            <span class="text-amber-400">2.7 WHO</span>
            <span class="text-red-400">4.0 EPA</span>
            <span>10</span>
            <span>20+</span>
        </div>
    </div>

    <!-- Risk Gauge Bar -->
    <div class="w-full bg-slate-100 rounded-full h-3 mb-6 overflow-hidden">
        <div class="h-3 rounded-full transition-all duration-500 ease-out"
             class="${initialBarColor}"
             :class="barColor"
             style="width:${initialBarWidth}%"
             :style="'width: ' + barWidth + '%'"></div>
    </div>

    <!-- Dynamic Decision Cards (Alpine.js reactive) -->

    <!-- SAFE -->
    <div x-show="status === 'safe'" x-transition.opacity.duration.300ms
         style="${safeInitialStyle}"
         class="rounded-2xl border-2 border-emerald-200 bg-emerald-50 p-5">
        <div class="flex items-start gap-4">
            <div class="w-10 h-10 rounded-full bg-emerald-500 text-white flex items-center justify-center shrink-0 shadow-sm">
                <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7" />
                </svg>
            </div>
            <div>
                <h4 class="font-display font-bold text-emerald-900 text-lg">Safe Range</h4>
                <p class="text-sm text-emerald-800 leading-relaxed mt-1">
                    @if(costMode)
                        @if(unconfirmedCostMode)
                        This sample reading is within the safe range. Both the EPA (4.0) and WHO (2.7) thresholds are not exceeded.
                        <strong>If your real result lands here, most homeowners monitor and retest instead of pricing mitigation right away.</strong>
                        @else
                        Your reading is within the safe range. Both the EPA (4.0) and WHO (2.7) thresholds are not exceeded.
                        <strong>Most homeowners would monitor and retest rather than install a mitigation system right now.</strong>
                        @endif
                    @else
                        Your reading is within the safe range. Both the EPA (4.0) and WHO (2.7) thresholds are not exceeded.
                        <strong>Mitigation is not needed right now.</strong> If you have never tested your home, start with a short-term kit first. If this is already a confirmed low reading, a digital monitor can help you keep an eye on seasonal changes.
                    @endif
                </p>
                @if(costMode)
                <p class="text-sm text-emerald-800 leading-relaxed mt-2">
                    Use the estimate below only as future planning context. If a follow-up test stays low, you can usually defer mitigation spending.
                </p>
                @else
                <div class="mt-4 flex flex-col sm:flex-row sm:flex-wrap gap-3">
                    <a href="${shortTermKitUrl}"
                       data-rv-affiliate-link="true"
                       target="_blank" rel="sponsored nofollow noopener"
                       onclick="if(window.rvTrackAffiliateClick) window.rvTrackAffiliateClick(this, { cta_id: 'advisor_safe_test_kit', offer_type: 'test_kit', offer_brand: 'first_alert', offer_model: 'rd1', placement_group: 'advisor', placement_id: 'safe_primary', journey_stage: 'first_test' });"
                       class="inline-flex items-center justify-center gap-2 px-4 py-2.5 rounded-xl bg-emerald-600 text-white text-sm font-bold hover:bg-emerald-700 transition-colors shadow-sm">
                        <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                        </svg>
                        Start with a Short-Term Test Kit
                    </a>
                    <a href="${digitalMonitorUrl}"
                       data-rv-affiliate-link="true"
                       target="_blank" rel="sponsored nofollow noopener"
                       onclick="if(window.rvTrackAffiliateClick) window.rvTrackAffiliateClick(this, { cta_id: 'advisor_safe_monitor_followup', offer_type: 'monitor', offer_brand: 'airthings', offer_model: 'corentium_home', placement_group: 'advisor', placement_id: 'safe_followup', journey_stage: 'followup_monitor' });"
                       class="inline-flex items-center justify-center gap-2 px-4 py-2.5 rounded-xl border border-emerald-300 text-emerald-800 text-sm font-bold hover:bg-emerald-100 transition-colors">
                        Already tested once? View Airthings Corentium Home
                    </a>
                </div>
                @endif
            </div>
        </div>
    </div>

    <!-- CAUTION -->
    <div x-show="status === 'caution'" x-transition.opacity.duration.300ms
         style="${cautionInitialStyle}"
         class="rounded-2xl border-2 border-amber-200 bg-amber-50 p-5">
        <div class="flex items-start gap-4">
            <div class="w-10 h-10 rounded-full bg-amber-500 text-white flex items-center justify-center shrink-0 shadow-sm">
                <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                </svg>
            </div>
            <div>
                <h4 class="font-display font-bold text-amber-900 text-lg">
                    @if(unconfirmedCostMode)
                        Sample Borderline Reading
                    @else
                        Elevated - Consider Action
                    @endif
                </h4>
                <p class="text-sm text-amber-800 leading-relaxed mt-1">
                    @if(costMode)
                        @if(unconfirmedCostMode)
                        This sample sits below the US EPA action level (4.0 pCi/L), but inside the range where many homeowners start planning what a next step could cost.
                        The World Health Organization uses <strong>2.7 pCi/L as a tighter reference point</strong>.
                        @else
                        Your reading is below the US EPA action level (4.0 pCi/L), but this range can still justify quote planning.
                        The World Health Organization uses <strong>2.7 pCi/L as a tighter reference point</strong>.
                        @endif
                    @else
                        Your reading is below the US EPA action level (4.0 pCi/L), but this range still warrants follow-up testing.
                        The World Health Organization uses <strong>2.7 pCi/L as a tighter reference point</strong>.
                    @endif
                </p>
                <p class="text-sm text-amber-800 leading-relaxed mt-2">
                    @if(costMode)
                        @if(unconfirmedCostMode)
                        Use the estimate below as planning context only. The smart move is still to get a real first result, then return here if the reading stays borderline.
                        <strong>This is a budgeting preview, not a mitigation recommendation.</strong>
                        @else
                        Use the estimate below as planning context for homes with frequent basement use, repeated borderline readings,
                        children, or an active real-estate transaction. <strong>Confirmatory or long-term testing should still drive the final spend decision.</strong>
                        @endif
                    @else
                        If this was just a one-time snapshot, confirm it with another test or with longer tracking. If this level persists, planning mitigation is reasonable,
                        especially for homes with frequent basement use, children, or pending real-estate transactions.
                        <strong>Scroll down to see your estimated cost.</strong>
                    @endif
                </p>
                @if(!costMode)
                <div class="mt-4 flex flex-col sm:flex-row sm:flex-wrap gap-3">
                    <a href="${digitalMonitorUrl}"
                       data-rv-affiliate-link="true"
                       target="_blank" rel="sponsored nofollow noopener"
                       onclick="if(window.rvTrackAffiliateClick) window.rvTrackAffiliateClick(this, { cta_id: 'advisor_caution_monitor_primary', offer_type: 'monitor', offer_brand: 'airthings', offer_model: 'corentium_home', placement_group: 'advisor', placement_id: 'caution_primary', journey_stage: 'followup_monitor' });"
                       class="inline-flex items-center justify-center gap-2 px-4 py-2.5 rounded-xl bg-amber-600 text-white text-sm font-bold hover:bg-amber-700 transition-colors shadow-sm">
                        <svg class="w-4 h-4" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                        </svg>
                        Track it with Airthings Corentium Home
                    </a>
                    <a href="${shortTermKitUrl}"
                       data-rv-affiliate-link="true"
                       target="_blank" rel="sponsored nofollow noopener"
                       onclick="if(window.rvTrackAffiliateClick) window.rvTrackAffiliateClick(this, { cta_id: 'advisor_caution_test_kit_secondary', offer_type: 'test_kit', offer_brand: 'first_alert', offer_model: 'rd1', placement_group: 'advisor', placement_id: 'caution_secondary', journey_stage: 'first_test' });"
                       class="inline-flex items-center justify-center gap-2 px-4 py-2.5 rounded-xl border border-amber-300 text-amber-800 text-sm font-bold hover:bg-amber-100 transition-colors">
                        Need a first test instead?
                    </a>
                </div>
                @endif
            </div>
        </div>
    </div>

    <!-- DANGER -->
    <div x-show="status === 'danger'" x-transition.opacity.duration.300ms
         style="${dangerInitialStyle}"
         class="rounded-2xl border-2 border-red-200 bg-red-50 p-5">
        <div class="flex items-start gap-4">
            <div class="w-10 h-10 rounded-full bg-red-600 text-white flex items-center justify-center shrink-0 shadow-sm animate-pulse">
                <svg class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                </svg>
            </div>
            <div>
                <h4 class="font-display font-bold text-red-900 text-lg">Warning: Action Required - EPA Threshold Exceeded</h4>
                <p class="text-sm text-red-800 leading-relaxed mt-1">
                    @if(unconfirmedCostMode)
                        This sample shows what an EPA-threshold result would mean. At <strong x-text="parseFloat(level).toFixed(1)">${initialLevel}</strong> pCi/L, the reading would be above the EPA action level.
                    @else
                        At <strong x-text="parseFloat(level).toFixed(1)">${initialLevel}</strong> pCi/L, this reading is above the
                        EPA action level.
                    @endif
                    @if(costMode)
                        <strong>Use the local pricing below to budget your next step after confirming the result.</strong>
                    @else
                        Prompt mitigation planning is recommended after confirmatory testing.
                    @endif
                </p>

                <!-- Before / After Promise -->
                <div class="mt-4 flex items-center justify-between gap-2 sm:gap-4 bg-white/70 rounded-xl p-3 sm:p-4 border border-red-100">
                    <div class="text-center">
                        <div class="text-[10px] sm:text-xs font-bold text-red-400 uppercase tracking-widest">Now</div>
                        <div class="font-display font-black text-xl sm:text-2xl text-red-600 tabular-nums whitespace-nowrap" x-text="parseFloat(level).toFixed(1)">${initialLevel}</div>
                    </div>
                    <div class="flex shrink-0 items-center justify-center">
                        <svg class="w-5 h-5 sm:w-8 sm:h-8 text-slate-300" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M17.25 8.25L21 12m0 0l-3.75 3.75M21 12H3" />
                        </svg>
                    </div>
                    <div class="text-center">
                        <div class="text-[10px] sm:text-xs font-bold text-emerald-500 uppercase tracking-widest">After</div>
                        <div class="font-display font-black text-xl sm:text-2xl text-emerald-600 tabular-nums whitespace-nowrap" x-text="postMitigationLow + '-' + postMitigationHigh">${initialPostMitigationLow}-${initialPostMitigationHigh}</div>
                    </div>
                </div>

                <p class="text-xs text-red-600 mt-3 font-semibold">
                    Typical mitigation systems reduce radon by 80-99%.
                    <strong>
                        @if(costMode)
                            Compare the local line items below before requesting quotes.
                        @else
                            See your itemized cost estimate below.
                        @endif
                    </strong>
                </p>
            </div>
        </div>
    </div>

    <!-- Manual Input (small, under the slider) -->
    <div class="mt-5 flex items-center justify-center gap-3" data-nosnippet>
        <label class="text-xs font-bold text-slate-400 uppercase tracking-wider">
            @if(costMode)
                @if(unconfirmedCostMode)
                Try a sample reading:
                @else
                Enter confirmed reading:
                @endif
            @else
                Enter exact reading:
            @endif
        </label>
        <input type="number" min="0" max="99" step="0.1"
               x-model.debounce.300ms="level"
               value="${initialLevel}"
               class="w-24 text-center text-sm font-bold text-slate-900 border border-slate-200 rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-slate-900 focus:border-transparent tabular-nums">
        <span class="text-xs text-slate-400 font-semibold">pCi/L</span>
    </div>
</div>

<style>
/* Custom Slider Styling */
.radon-slider {
    background: linear-gradient(to right, #10b981 0%, #10b981 10%, #f59e0b 20%, #f59e0b 30%, #ef4444 40%, #ef4444 100%);
}
.radon-slider::-webkit-slider-thumb {
    -webkit-appearance: none;
    appearance: none;
    width: 24px;
    height: 24px;
    background: white;
    border: 3px solid currentColor;
    border-radius: 50%;
    cursor: pointer;
    box-shadow: 0 2px 6px rgba(0,0,0,0.15);
    transition: transform 0.15s ease;
}
.radon-slider::-webkit-slider-thumb:hover {
    transform: scale(1.15);
}
.radon-slider::-moz-range-thumb {
    width: 24px;
    height: 24px;
    background: white;
    border: 3px solid currentColor;
    border-radius: 50%;
    cursor: pointer;
    box-shadow: 0 2px 6px rgba(0,0,0,0.15);
}
</style>
