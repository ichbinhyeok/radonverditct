(function () {
    "use strict";

    function text(id, value) {
        var node = document.getElementById(id);
        if (node) node.textContent = value;
    }

    function show(id) {
        var node = document.getElementById(id);
        if (node) node.hidden = false;
    }

    function localDateTime(value) {
        if (!value) return null;
        var date = new Date(value);
        return Number.isNaN(date.getTime()) ? null : date;
    }

    function formatDateTime(date) {
        return new Intl.DateTimeFormat("en-US", {
            dateStyle: "medium",
            timeStyle: "short"
        }).format(date);
    }

    function initProtocolRecord() {
        var form = document.getElementById("protocol-record-form");
        if (!form) return;

        var checks = Array.prototype.slice.call(form.querySelectorAll(".protocol-record-check"));
        var progress = document.getElementById("protocol-record-progress");
        var notes = document.getElementById("protocol-record-notes");
        var output = document.getElementById("protocol-record-output");
        var summary = document.getElementById("protocol-record-summary");
        var build = document.getElementById("protocol-record-build");
        var copy = document.getElementById("protocol-record-copy");

        function checkedItems() {
            return checks.filter(function (item) { return item.checked; });
        }

        function updateProgress() {
            progress.textContent = checkedItems().length + " of " + checks.length + " confirmed";
        }

        checks.forEach(function (item) { item.addEventListener("change", updateProgress); });

        build.addEventListener("click", function () {
            var confirmed = checkedItems().map(function (item) { return "[confirmed] " + item.value; });
            var unresolved = checks.filter(function (item) { return !item.checked; })
                .map(function (item) { return "[verify] " + item.value; });
            var lines = [
                form.dataset.guideTitle,
                "Created: " + new Date().toLocaleString(),
                "",
                "Confirmed (" + confirmed.length + "/" + checks.length + ")",
                confirmed.length ? confirmed.join("\n") : "None confirmed",
                "",
                "Still to verify (" + unresolved.length + ")",
                unresolved.length ? unresolved.join("\n") : "None",
                "",
                "Context",
                notes.value.trim() || "No additional context recorded",
                "",
                "Source page: " + window.location.href
            ];
            summary.textContent = lines.join("\n");
            output.hidden = false;
            copy.textContent = "Copy summary";
        });

        copy.addEventListener("click", function () {
            if (!navigator.clipboard || !navigator.clipboard.writeText) {
                copy.textContent = "Select the summary to copy";
                return;
            }
            navigator.clipboard.writeText(summary.textContent).then(function () {
                copy.textContent = "Copied";
            }).catch(function () {
                copy.textContent = "Select the summary to copy";
            });
        });

        form.addEventListener("reset", function () {
            window.setTimeout(function () {
                updateProgress();
                output.hidden = true;
                summary.textContent = "";
                copy.textContent = "Copy summary";
            }, 0);
        });
    }

    initProtocolRecord();

    var timelineForm = document.getElementById("radon-result-timeline-form");
    if (timelineForm) {
        timelineForm.addEventListener("submit", function (event) {
            event.preventDefault();
            var start = localDateTime(document.getElementById("timeline-start").value);
            var exposureHours = Number(document.getElementById("timeline-exposure-hours").value);
            var transitDays = Number(document.getElementById("timeline-transit-days").value || 0);
            var labDays = Number(document.getElementById("timeline-lab-days").value || 0);
            if (!start || exposureHours <= 0 || transitDays < 0 || labDays < 0) return;

            var exposureEnd = new Date(start.getTime() + exposureHours * 60 * 60 * 1000);
            var resultDate = new Date(exposureEnd.getTime() + (transitDays + labDays) * 24 * 60 * 60 * 1000);
            text("timeline-exposure-result", formatDateTime(exposureEnd));
            text("timeline-report-result", formatDateTime(resultDate));
            text("timeline-total-result", Math.ceil((exposureHours / 24) + transitDays + labDays) + " calendar days from start");
            show("radon-result-timeline-output");
        });
    }

    var manometerForm = document.getElementById("manometer-baseline-form");
    if (manometerForm) {
        manometerForm.addEventListener("submit", function (event) {
            event.preventDefault();
            var baseline = document.getElementById("manometer-baseline").value;
            var current = document.getElementById("manometer-current").value;
            var observed = document.getElementById("manometer-observed-at").value;
            var outcome;

            if (current === "level" || current === "damaged" || current === "alarm") {
                outcome = "Record the change and contact the installer or a qualified mitigator. Do not infer the indoor radon level from this gauge.";
            } else if (baseline === "known" && current === "matches") {
                outcome = "The visual status matches the recorded baseline. Keep the observation and verify indoor performance on the radon retest schedule.";
            } else {
                outcome = "The visual check is inconclusive without the installer's baseline. Preserve a photo and ask the installer to identify the normal mark.";
            }

            text("manometer-record-result", outcome);
            text("manometer-record-time", observed ? "Observed " + observed.replace("T", " ") : "Observation time not entered");
            show("manometer-baseline-output");
        });
    }

    var noiseForm = document.getElementById("fan-noise-observation-form");
    if (noiseForm) {
        noiseForm.addEventListener("submit", function (event) {
            event.preventDefault();
            var sound = document.getElementById("fan-noise-sound").value;
            var indicator = document.getElementById("fan-noise-indicator").value;
            var timing = document.getElementById("fan-noise-timing").value.trim();
            var flags = Array.from(noiseForm.querySelectorAll("input[name='noise-condition']:checked"))
                .map(function (input) { return input.value; });
            var urgent = indicator === "alarm" || indicator === "level" || flags.includes("visible damage") || flags.includes("electrical concern");

            text("fan-noise-summary", "Recorded: " + sound + "; indicator: " + indicator + (timing ? "; timing: " + timing : "") + (flags.length ? "; conditions: " + flags.join(", ") : ""));
            text("fan-noise-next-step", urgent
                ? "Stop remote troubleshooting and contact the installer or an appropriately qualified professional. Use emergency judgment for an immediate electrical, structural, or water hazard."
                : "Keep the record, compare the indicator with its installed baseline, and contact the installer if the sound is new, worsening, or persistent. Verify performance with an indoor radon test after relevant service.");
            show("fan-noise-observation-output");
        });
    }
})();
