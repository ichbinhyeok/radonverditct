(function () {
    "use strict";

    var form = document.getElementById("result-interpreter-form");
    if (!form) return;

    var readingInput = document.getElementById("result-reading");
    var secondReadingInput = document.getElementById("result-second-reading");
    var secondReadingField = document.getElementById("second-reading-field");
    var procedureInput = document.getElementById("result-procedure");
    var contextInput = document.getElementById("result-context");
    var error = document.getElementById("result-reading-error");
    var marker = document.getElementById("result-marker");
    var outputTitle = document.getElementById("result-output-title");
    var valueSummary = document.getElementById("result-value-summary");
    var procedureSummary = document.getElementById("result-procedure-summary");
    var nextStep = document.getElementById("result-next-step");
    var interpretation = document.getElementById("result-interpretation");
    var action = document.getElementById("result-action");
    var contextNote = document.getElementById("result-context-note");
    var primaryLink = document.getElementById("result-primary-link");
    var copyButton = document.getElementById("result-copy");
    var copyStatus = document.getElementById("result-copy-status");
    var currentRecord = "";

    function selectedType() {
        var selected = form.querySelector("input[name='result-test-type']:checked");
        return selected ? selected.value : "unknown";
    }

    function typeLabel(type) {
        return {
            "first-short": "first short-term test",
            "second-short": "two short-term tests",
            "long": "long-term test",
            "post-mitigation": "post-mitigation test",
            "unknown": "unknown test type"
        }[type];
    }

    function validReading(input) {
        var raw = input.value.trim();
        if (!raw) return null;
        var value = Number(raw);
        return Number.isFinite(value) && value >= 0 && value <= 999 ? value : null;
    }

    function positionMarker(value) {
        marker.style.left = Math.min(Math.max(value / 8 * 100, 0), 100) + "%";
    }

    function setLink(label, href) {
        primaryLink.textContent = label;
        primaryLink.href = href;
    }

    function contextText(context) {
        if (context === "buying") {
            return "For a purchase or sale, preserve the complete report and applicable transaction protocol. Do not turn this reading into a universal repair price or credit.";
        }
        if (context === "renovation") {
            return "Keep the before/after dates and the changed building conditions with this record. Renovation can change the question and is a reason to test again.";
        }
        return "Keep this interpretation with the laboratory or tester report. Retest when occupancy of a lower level or major building changes alter the original question.";
    }

    function buildRecord(reading, secondReading, type, procedure, context) {
        var lines = [
            "Radon test result record",
            "Created: " + new Date().toLocaleString(),
            "Reported reading: " + reading.toFixed(1) + " pCi/L",
            "Test type: " + typeLabel(type)
        ];
        if (secondReading !== null) lines.push("Second short-term reading: " + secondReading.toFixed(1) + " pCi/L");
        lines.push("Procedure record: " + procedure);
        lines.push("Decision context: " + context);
        lines.push("");
        lines.push("Interpretation: " + interpretation.textContent);
        lines.push("Next step: " + action.textContent);
        lines.push("Context: " + contextNote.textContent);
        lines.push("");
        lines.push("Source page: " + window.location.href);
        return lines.join("\n");
    }

    function render() {
        error.textContent = "";
        copyStatus.textContent = "";
        var reading = validReading(readingInput);
        var type = selectedType();
        var procedure = procedureInput.value;
        var context = contextInput.value;
        var secondReading = type === "second-short" ? validReading(secondReadingInput) : null;

        if (reading === null) {
            error.textContent = "Enter the non-negative pCi/L value shown on the report.";
            readingInput.focus();
            return;
        }
        if (type === "second-short" && secondReading === null) {
            error.textContent = "Enter both short-term results before calculating their average.";
            secondReadingInput.focus();
            return;
        }

        positionMarker(type === "second-short" ? (reading + secondReading) / 2 : reading);
        outputTitle.textContent = "Review this record";
        nextStep.hidden = false;
        nextStep.classList.remove("result-reveal");
        void nextStep.offsetWidth;
        nextStep.classList.add("result-reveal");
        contextNote.textContent = contextText(context);

        if (procedure !== "clear") {
            valueSummary.textContent = reading.toFixed(1) + " pCi/L · " + typeLabel(type);
            procedureSummary.textContent = procedure === "concern"
                ? "A documented condition may conflict with the device or protocol."
                : "One or more procedure details are still unknown.";
            interpretation.textContent = "This record does not support a clean next-step classification yet.";
            action.textContent = "Preserve the reported number, identify the missing or conflicting procedure fact, and ask the laboratory or tester whether the sample can be relied on or should be repeated.";
            setLink("Check test validity", "/guides/is-my-radon-test-valid");
        } else if (type === "unknown") {
            valueSummary.textContent = reading.toFixed(1) + " pCi/L · test type unknown";
            procedureSummary.textContent = "The conditions are documented, but the measurement period is not identified.";
            interpretation.textContent = "The number cannot choose between the short-term and long-term follow-up paths by itself.";
            action.textContent = "Find the device, exposure dates, laboratory report, or tester record before using this tool's test-specific guidance.";
            setLink("Identify the test record", "/guides/is-my-radon-test-valid");
        } else if (type === "second-short") {
            var average = (reading + secondReading) / 2;
            valueSummary.textContent = average.toFixed(1) + " pCi/L average · two short-term tests";
            procedureSummary.textContent = "Both readings are present and the procedure was recorded as documented.";
            if (average >= 4) {
                interpretation.textContent = "The two-test average is at or above EPA's 4.0 pCi/L action level.";
                action.textContent = "CDC guidance supports contacting a licensed radon-reduction professional. Keep both reports and the calculated average together.";
                setLink("Review mitigation-system decisions", "/guides/radon-mitigation-system-maintenance");
            } else if (average >= 2) {
                interpretation.textContent = "The two-test average is between 2.0 and 4.0 pCi/L.";
                action.textContent = "EPA and CDC say to consider reducing radon in this range. Use both complete reports—not only this average—when discussing the decision.";
                setLink("Review when to retest", "/guides/when-to-retest-for-radon");
            } else {
                interpretation.textContent = "The two-test average is below 2.0 pCi/L.";
                action.textContent = "CDC lists no immediate action for this band. Keep both reports and retest when lower-level occupancy or major home changes alter the question.";
                setLink("Review future retesting", "/guides/when-to-retest-for-radon");
            }
        } else if (type === "first-short") {
            valueSummary.textContent = reading.toFixed(1) + " pCi/L · first short-term test";
            procedureSummary.textContent = "The procedure was recorded as documented; this remains a short-period measurement.";
            if (reading >= 4) {
                interpretation.textContent = "This first short-term result reaches EPA's 4.0 pCi/L action level.";
                action.textContent = "Take a second short- or long-term test. If the follow-up is another short-term test, CDC says to calculate the average of the two results.";
                setLink("Plan the follow-up test", "/guides/when-to-retest-for-radon");
            } else if (reading >= 2) {
                interpretation.textContent = "This short-term result is between 2.0 and 4.0 pCi/L.";
                action.textContent = "EPA and CDC say to consider reducing radon in this range. A longer measurement can add time coverage when the decision is not urgent.";
                setLink("Compare test durations", "/guides/short-term-vs-long-term-radon-test");
            } else {
                interpretation.textContent = "This short-term result is below 2.0 pCi/L.";
                action.textContent = "CDC lists no immediate action for this band. Keep the report; this short measurement is not a permanent guarantee about future conditions.";
                setLink("Review future retesting", "/guides/when-to-retest-for-radon");
            }
        } else if (type === "long") {
            valueSummary.textContent = reading.toFixed(1) + " pCi/L · long-term test";
            procedureSummary.textContent = "The result covers more than 90 days and the procedure was recorded as documented.";
            if (reading >= 4) {
                interpretation.textContent = "This long-term result is at or above EPA's 4.0 pCi/L action level.";
                action.textContent = "CDC guidance supports contacting a licensed radon-reduction professional and preserving this complete report for the scope discussion.";
                setLink("Review mitigation-system decisions", "/guides/radon-mitigation-system-maintenance");
            } else if (reading >= 2) {
                interpretation.textContent = "This long-term result is between 2.0 and 4.0 pCi/L.";
                action.textContent = "EPA and CDC say to consider reducing radon in this range. The long-term result provides year-round context for that decision.";
                setLink("Review reduction context", "/guides/when-to-retest-for-radon");
            } else {
                interpretation.textContent = "This long-term result is below 2.0 pCi/L.";
                action.textContent = "CDC lists no immediate action for this band. Keep the report and retest after relevant occupancy or building changes.";
                setLink("Review future retesting", "/guides/when-to-retest-for-radon");
            }
        } else {
            valueSummary.textContent = reading.toFixed(1) + " pCi/L · post-mitigation test";
            procedureSummary.textContent = "This result is being used to verify an installed reduction system.";
            if (reading >= 4) {
                interpretation.textContent = "The post-mitigation result remains at or above 4.0 pCi/L.";
                action.textContent = "Keep the report and contact the installer or a qualified mitigator to review the system and the test conditions. Do not diagnose the cause from the number alone.";
            } else {
                interpretation.textContent = "The post-mitigation result is below 4.0 pCi/L.";
                action.textContent = "Keep it as the system's verification record and continue warning-device checks and periodic indoor retesting. Lower remains preferable.";
            }
            setLink("Review post-mitigation testing", "/guides/radon-test-after-mitigation");
        }

        currentRecord = buildRecord(reading, secondReading, type, procedure, context);
        if (window.rvTrack) {
            window.rvTrack("result_interpreter_complete", {
                test_type: type,
                procedure_status: procedure,
                result_band: reading >= 4 ? "at_or_above_4" : reading >= 2 ? "between_2_and_4" : "below_2"
            });
        }
    }

    form.querySelectorAll("input[name='result-test-type']").forEach(function (radio) {
        radio.addEventListener("change", function () {
            secondReadingField.hidden = selectedType() !== "second-short";
        });
    });

    form.addEventListener("submit", function (event) {
        event.preventDefault();
        render();
    });

    copyButton.addEventListener("click", function () {
        if (!currentRecord) return;
        if (!navigator.clipboard || !navigator.clipboard.writeText) {
            copyStatus.textContent = "Select the interpretation text and copy it manually.";
            return;
        }
        navigator.clipboard.writeText(currentRecord).then(function () {
            copyStatus.textContent = "Copied. Keep it with the complete test report.";
        }).catch(function () {
            copyStatus.textContent = "Select the interpretation text and copy it manually.";
        });
    });
})();
