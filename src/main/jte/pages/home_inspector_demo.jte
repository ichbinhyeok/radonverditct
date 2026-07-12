@import com.radonverdict.util.JsonLdUtils

!{
    final String demoUrl = "/guides/radon-failed-inspection?source=inspector-demo&zipCode=22030&radonReading=5.8&intent=buying";
    final String clientNote = "Your radon result was 5.8 pCi/L. This independent next-step guide explains the result, shows local decision context, and helps you prepare for the repair or credit conversation.\n\nLink: ";
}

@template.layout.main(
    title = "Inspector Client Follow-Up Link Demo | RadonVerdict",
    canonicalUrl = "https://radonverdict.com/for-home-inspectors/demo",
    description = "A working demo of a client-ready radon follow-up link for home inspectors.",
    minimalChrome = true,
    content = @`
        <style>
            .inspector-demo { min-height: 100svh; background: #f7f7f4; color: #18211d; padding: 22px; }
            .inspector-demo__frame { width: min(1280px, 100%); min-height: calc(100svh - 44px); margin: 0 auto; display: flex; flex-direction: column; }
            .inspector-demo__nav { display: flex; align-items: center; justify-content: space-between; min-height: 40px; color: #59635d; font-size: 13px; }
            .inspector-demo__brand { display: inline-flex; align-items: center; gap: 9px; color: #18211d; font-family: Outfit, Inter, sans-serif; font-size: 16px; font-weight: 700; letter-spacing: -0.02em; }
            .inspector-demo__mark { display: grid; width: 24px; height: 24px; place-items: center; border-radius: 7px; background: #1d3930; color: #fff; font: 700 12px/1 Inter, sans-serif; }
            .inspector-demo__nav-note { display: flex; align-items: center; gap: 8px; }
            .inspector-demo__nav-note::before { width: 6px; height: 6px; border-radius: 50%; background: #4c8b6a; content: ""; }
            .inspector-demo__hero { display: grid; flex: 1; grid-template-columns: minmax(260px, .62fr) minmax(0, 1.38fr); align-items: center; gap: clamp(34px, 6vw, 96px); padding: clamp(42px, 7vh, 84px) 0; }
            .inspector-demo__intro { max-width: 365px; }
            .inspector-demo__eyebrow { margin: 0 0 16px; color: #4c8b6a; font-size: 12px; font-weight: 700; letter-spacing: .08em; text-transform: uppercase; }
            .inspector-demo h1 { max-width: 350px; margin: 0; color: #18211d; font-family: Outfit, Inter, sans-serif; font-size: clamp(38px, 4.15vw, 59px); font-weight: 700; letter-spacing: -0.035em; line-height: .99; }
            .inspector-demo__lede { max-width: 340px; margin: 20px 0 0; color: #657069; font-size: 15px; line-height: 1.6; }
            .inspector-demo__meta { display: flex; flex-wrap: wrap; gap: 8px 14px; margin-top: 27px; color: #53605a; font-size: 12px; }
            .inspector-demo__meta span { display: inline-flex; align-items: center; gap: 6px; }
            .inspector-demo__meta span::before { width: 5px; height: 5px; border-radius: 50%; background: #a9b4ad; content: ""; }
            .inspector-demo__tools { display: flex; align-items: center; gap: 14px; margin-top: 30px; }
            .inspector-demo__copy { border: 0; border-bottom: 1px solid #aeb6b0; padding: 0 0 3px; background: transparent; color: #29342e; font-size: 13px; font-weight: 600; }
            .inspector-demo__copy:hover { border-color: #29342e; }
            .inspector-demo__status { min-height: 18px; margin: 10px 0 0; color: #397857; font-size: 12px; font-weight: 600; }
            .inspector-demo__sample { min-width: 0; }
            .inspector-demo__sample-label { display: flex; align-items: center; justify-content: space-between; margin-bottom: 12px; color: #78827c; font-size: 12px; }
            .inspector-demo__sample-label strong { color: #3b4740; font-weight: 600; }
            .inspector-demo__client { overflow: hidden; border: 1px solid #dde1dc; border-radius: 8px; background: #fff; }
            .inspector-demo__client-top { display: flex; align-items: center; justify-content: space-between; height: 58px; padding: 0 25px; border-bottom: 1px solid #e7e9e5; }
            .inspector-demo__client-brand { display: flex; align-items: center; gap: 10px; min-width: 0; }
            .inspector-demo__client-avatar { display: grid; flex: 0 0 auto; width: 29px; height: 29px; place-items: center; border-radius: 50%; background: #edf4ed; color: #397857; font-size: 11px; font-weight: 700; }
            .inspector-demo__client-brand b { display: block; color: #27322c; font-size: 13px; font-weight: 650; }
            .inspector-demo__client-brand span { display: block; margin-top: 2px; color: #89918b; font-size: 11px; }
            .inspector-demo__shared { color: #6e7771; font-size: 11px; }
            .inspector-demo__client-body { display: grid; grid-template-columns: 255px minmax(0, 1fr); }
            .inspector-demo__result { padding: 31px 27px; background: #f2f5f1; }
            .inspector-demo__result-label, .inspector-demo__plan-label { margin: 0; color: #718077; font-size: 11px; font-weight: 600; letter-spacing: .04em; text-transform: uppercase; }
            .inspector-demo__reading { display: flex; align-items: baseline; gap: 7px; margin: 16px 0 12px; color: #1c2821; font-family: Outfit, Inter, sans-serif; font-size: 47px; font-weight: 700; letter-spacing: -0.05em; line-height: 1; }
            .inspector-demo__reading small { color: #637069; font-family: Inter, sans-serif; font-size: 13px; font-weight: 600; letter-spacing: 0; }
            .inspector-demo__alert { margin: 0; color: #4c5c53; font-size: 13px; line-height: 1.55; }
            .inspector-demo__context { margin-top: 30px; padding-top: 16px; border-top: 1px solid #dce3dc; color: #64716a; font-size: 12px; line-height: 1.55; }
            .inspector-demo__context b { display: block; margin-bottom: 4px; color: #2f3d35; font-size: 12px; font-weight: 650; }
            .inspector-demo__plan { padding: 31px 32px 27px; }
            .inspector-demo__plan h2 { max-width: 390px; margin: 10px 0 21px; color: #1d2821; font-family: Outfit, Inter, sans-serif; font-size: clamp(22px, 2.15vw, 29px); font-weight: 650; letter-spacing: -0.025em; line-height: 1.15; }
            .inspector-demo__choices { display: grid; border-top: 1px solid #e6e9e5; }
            .inspector-demo__choice { display: grid; grid-template-columns: 26px minmax(0, 1fr); gap: 12px; padding: 14px 0; border-bottom: 1px solid #e6e9e5; }
            .inspector-demo__choice-number { display: grid; width: 22px; height: 22px; place-items: center; border-radius: 50%; background: #edf4ed; color: #397857; font-size: 10px; font-weight: 700; }
            .inspector-demo__choice b { display: block; color: #26332b; font-size: 13px; font-weight: 650; }
            .inspector-demo__choice span { display: block; margin-top: 3px; color: #78837c; font-size: 12px; line-height: 1.45; }
            .inspector-demo__action { display: flex; align-items: center; justify-content: space-between; min-height: 44px; margin-top: 21px; padding: 0 15px; border-radius: 5px; background: #1d3930; color: #fff; font-size: 13px; font-weight: 650; transition: background .15s ease; }
            .inspector-demo__action:hover { background: #295342; }
            .inspector-demo__client-foot { display: flex; align-items: center; justify-content: space-between; gap: 18px; padding: 13px 25px; border-top: 1px solid #e7e9e5; color: #8a938d; font-size: 11px; line-height: 1.4; }
            .inspector-demo__client-foot a { flex: 0 0 auto; color: #397857; font-weight: 650; }
            .inspector-demo__footer { display: flex; align-items: center; justify-content: space-between; min-height: 38px; border-top: 1px solid #dedfda; color: #89918b; font-size: 11px; }
            @media (max-width: 800px) {
                .inspector-demo { padding: 15px; }
                .inspector-demo__frame { min-height: calc(100svh - 30px); }
                .inspector-demo__nav-note { font-size: 11px; }
                .inspector-demo__hero { grid-template-columns: 1fr; gap: 36px; padding: 42px 0; }
                .inspector-demo__intro { max-width: 100%; }
                .inspector-demo h1 { max-width: 350px; font-size: 42px; }
                .inspector-demo__lede { max-width: 350px; }
                .inspector-demo__client-top { height: auto; min-height: 57px; padding: 13px 16px; }
                .inspector-demo__shared { display: none; }
                .inspector-demo__client-body { grid-template-columns: 1fr; }
                .inspector-demo__result, .inspector-demo__plan { padding: 24px 20px; }
                .inspector-demo__context { margin-top: 23px; }
                .inspector-demo__client-foot { align-items: flex-start; padding: 12px 16px; }
                .inspector-demo__footer { padding-top: 12px; }
                .inspector-demo__footer span:last-child { display: none; }
            }
        </style>

        <main class="inspector-demo">
            <div class="inspector-demo__frame">
                <nav class="inspector-demo__nav" aria-label="Demo navigation">
                    <a class="inspector-demo__brand" href="/"><span class="inspector-demo__mark">R</span>RadonVerdict</a>
                    <span class="inspector-demo__nav-note">For home inspectors</span>
                </nav>

                <section class="inspector-demo__hero">
                    <div class="inspector-demo__intro">
                        <p class="inspector-demo__eyebrow">Client follow-up link</p>
                        <h1>Send the decision, not another explanation.</h1>
                        <p class="inspector-demo__lede">Add one link below a radon result. The client gets a calm, local next-step guide while your inspection stays independent.</p>
                        <div class="inspector-demo__meta"><span>No login</span><span>No client data</span><span>No contractor referral</span></div>
                        <div class="inspector-demo__tools">
                            <button type="button" class="inspector-demo__copy" data-copy-demo-note data-track-event="inspector_demo_copy_note">Copy ready note</button>
                            <button type="button" class="inspector-demo__copy" data-copy-demo-link data-track-event="inspector_demo_copy_link">Copy link</button>
                        </div>
                        <p class="inspector-demo__status" data-demo-status aria-live="polite"></p>
                    </div>

                    <div class="inspector-demo__sample">
                        <div class="inspector-demo__sample-label"><span>What your client receives</span><strong>Live example</strong></div>
                        <article class="inspector-demo__client" aria-label="Client follow-up guide example">
                            <header class="inspector-demo__client-top">
                                <div class="inspector-demo__client-brand"><span class="inspector-demo__client-avatar">YI</span><div><b>Your Inspection Company</b><span>Independent inspection follow-up</span></div></div>
                                <span class="inspector-demo__shared">Shared with your client</span>
                            </header>
                            <div class="inspector-demo__client-body">
                                <section class="inspector-demo__result">
                                    <p class="inspector-demo__result-label">Radon result</p>
                                    <div class="inspector-demo__reading">5.8 <small>pCi/L</small></div>
                                    <p class="inspector-demo__alert">Above the EPA action level. This guide turns the result into a clear decision path.</p>
                                    <div class="inspector-demo__context"><b>Fairfax, Virginia</b>Buying a home &middot; ZIP 22030</div>
                                </section>
                                <section class="inspector-demo__plan">
                                    <p class="inspector-demo__plan-label">Your local next-step guide</p>
                                    <h2>What should you decide before closing?</h2>
                                    <div class="inspector-demo__choices">
                                        <div class="inspector-demo__choice"><span class="inspector-demo__choice-number">1</span><div><b>Use a local mitigation range</b><span>Set a credible starting point for a repair or credit conversation.</span></div></div>
                                        <div class="inspector-demo__choice"><span class="inspector-demo__choice-number">2</span><div><b>Choose the transaction path</b><span>Compare repair, seller credit, or a retest plan before the deadline.</span></div></div>
                                    </div>
                                    <a class="inspector-demo__action" href="${demoUrl}" data-track-event="inspector_demo_open_client">Build my local plan <span>&rarr;</span></a>
                                </section>
                            </div>
                            <footer class="inspector-demo__client-foot"><span>Your inspector is not recommending a contractor or negotiating the transaction.</span><a href="${demoUrl}" data-track-event="inspector_demo_open_client">Open live guide &rarr;</a></footer>
                        </article>
                    </div>
                </section>

                <footer class="inspector-demo__footer"><span>RadonVerdict &middot; Client decision support</span><span>Try it on one recent elevated result.</span></footer>
            </div>
        </main>

        <script>
            (() => {
                const demoUrl = window.location.origin + '${demoUrl}';
                const demoNote = $unsafe{JsonLdUtils.json(clientNote)} + demoUrl;
                const status = document.querySelector('[data-demo-status]');
                const copy = async (value, message) => {
                    try {
                        await navigator.clipboard.writeText(value);
                        status.textContent = message;
                    } catch (error) {
                        status.textContent = 'Copy is unavailable in this browser. Open the live guide instead.';
                    }
                };
                document.querySelector('[data-copy-demo-link]').addEventListener('click', () => copy(demoUrl, 'Client link copied.'));
                document.querySelector('[data-copy-demo-note]').addEventListener('click', () => copy(demoNote, 'Client note copied.'));
            })();
        </script>
    `
)
