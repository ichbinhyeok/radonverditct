package com.radonverdict.service;

import com.radonverdict.model.dto.TestProtocolGuide;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

@Service
public class TestProtocolGuideCatalog {

    private static final TestProtocolGuide.Source CDC = new TestProtocolGuide.Source(
            "Testing for Radon in Your Home",
            "Centers for Disease Control and Prevention",
            "https://www.cdc.gov/radon/testing/index.html",
            "Test types, duration, general placement, and reasons to retest");
    private static final TestProtocolGuide.Source EPA_CITIZEN = new TestProtocolGuide.Source(
            "A Citizen's Guide to Radon",
            "U.S. Environmental Protection Agency",
            "https://www.epa.gov/sites/default/files/2016-12/documents/2016_a_citizens_guide_to_radon.pdf",
            "Residential placement, handling, and follow-up testing");
    private static final TestProtocolGuide.Source EPA_REAL_ESTATE = new TestProtocolGuide.Source(
            "Home Buyer's and Seller's Guide to Radon",
            "U.S. Environmental Protection Agency",
            "https://www.epa.gov/sites/default/files/2015-05/documents/hmbuygud.pdf",
            "Transaction-specific test duration, closed-house conditions, and interference");
    private static final TestProtocolGuide.Source EPA_RETEST = new TestProtocolGuide.Source(
            "How often should I test/retest my home for radon?",
            "U.S. Environmental Protection Agency",
            "https://www.epa.gov/radon/how-often-should-i-testretest-my-home-radon",
            "Retesting after changes and when a buyer may request a new test");
    private static final TestProtocolGuide.Source EPA_KITS = new TestProtocolGuide.Source(
            "How do I get a radon test kit? Are they free?",
            "U.S. Environmental Protection Agency",
            "https://www.epa.gov/radon/how-do-i-get-radon-test-kit-are-they-free",
            "State programs, qualified providers, and test-kit sources");
    private static final TestProtocolGuide.Source EPA_MAINTENANCE = new TestProtocolGuide.Source(
            "How do I know if my radon mitigation system is working properly?",
            "U.S. Environmental Protection Agency",
            "https://www.epa.gov/radon/how-do-i-know-if-my-radon-mitigation-system-working-properly",
            "Warning-device checks, fan service life, maintenance, and two-year retesting");
    private static final TestProtocolGuide.Source EPA_REDUCTION = new TestProtocolGuide.Source(
            "Consumer's Guide to Radon Reduction",
            "U.S. Environmental Protection Agency",
            "https://www.epa.gov/sites/default/files/2016-12/documents/2016_consumers_guide_to_radon_reduction.pdf",
            "Post-mitigation testing, continuous fan operation, and system maintenance");
    private static final TestProtocolGuide.Source MICHIGAN_TESTING = new TestProtocolGuide.Source(
            "Testing for Radon",
            "Michigan Department of Environment, Great Lakes, and Energy",
            "https://www.michigan.gov/egle/about/organization/materials-management/indoor-radon/testing-for-radon",
            "Testing season, closed-house conditions, and occupied-room placement");
    private static final TestProtocolGuide.Source MICHIGAN_FAQ = new TestProtocolGuide.Source(
            "Radon Frequently Asked Questions",
            "Michigan Department of Environment, Great Lakes, and Energy",
            "https://www.michigan.gov/egle/-/media/Project/Websites/egle/Documents/Programs/MMD/Radon/Radon-FAQ.pdf",
            "Expired kits and household-specific testing");
    private static final TestProtocolGuide.Source EPA_STORMS = new TestProtocolGuide.Source(
            "Radon Testing Do's and Don'ts",
            "U.S. Environmental Protection Agency archive",
            "https://archive.epa.gov/reg5oair/tribes/web/pdf/10-radon-101-tepm-2016.pdf",
            "Severe-weather cautions for short-term tests");

    private static final Set<String> MAINTENANCE_SLUGS = Set.of(
            "radon-manometer-reading", "radon-fan-noise", "radon-mitigation-system-maintenance",
            "how-long-do-radon-fans-last");
    private static final List<String> ACQUISITION_PRIORITY_SLUGS = List.of(
            "short-term-vs-long-term-radon-test",
            "radon-mitigation-system-maintenance",
            "radon-manometer-reading",
            "radon-fan-noise",
            "how-long-do-radon-fans-last");

    private final Map<String, TestProtocolGuide> pages = buildPages();

    public TestProtocolGuide find(String slug) {
        return pages.get(slug);
    }

    public List<String> slugs() {
        return List.copyOf(pages.keySet());
    }

    public List<TestProtocolGuide> all() {
        return List.copyOf(pages.values());
    }

    public List<String> categories() {
        return pages.values().stream().map(TestProtocolGuide::category).distinct().toList();
    }

    public List<TestProtocolGuide> acquisitionPriority() {
        return ACQUISITION_PRIORITY_SLUGS.stream().map(pages::get).toList();
    }

    public static boolean supportsPath(String path) {
        if (path == null || !path.startsWith("/guides/")) return false;
        return supportedSlugs().contains(path.substring("/guides/".length()));
    }

    private static Map<String, TestProtocolGuide> buildPages() {
        LinkedHashMap<String, TestProtocolGuide> result = new LinkedHashMap<>();
        List<TestProtocolGuide> guides = List.of(
                duration(), maintenance(), fanLife(), manometer(), fanNoise(),
                placement(), closedHouse(), apartment(), validity(), retest(),
                afterMitigation(), windows(), livingDuringTest(), weather(), season(),
                deviceComparison(), expiredKit(), movedDevice(), mailingKit(), afterRenovation());
        guides.forEach(guide -> result.put(guide.slug(), guide));
        return Collections.unmodifiableMap(result);
    }

    private static Set<String> supportedSlugs() {
        return Set.of(
                "where-to-place-radon-test", "short-term-vs-long-term-radon-test",
                "radon-closed-house-conditions", "is-my-radon-test-valid", "when-to-retest-for-radon",
                "can-you-open-windows-during-radon-test", "can-you-live-in-house-during-radon-test",
                "radon-test-during-rain-or-storm", "best-time-of-year-to-test-for-radon",
                "charcoal-vs-digital-radon-test", "expired-radon-test-kit",
                "radon-test-moved-or-tampered", "how-to-mail-radon-test-kit",
                "radon-testing-in-apartments", "radon-test-after-renovation",
                "radon-test-after-mitigation", "radon-manometer-reading", "radon-fan-noise",
                "radon-mitigation-system-maintenance", "how-long-do-radon-fans-last");
    }

    private static TestProtocolGuide placement() {
        return guide(
                "where-to-place-radon-test",
                "Where to Place a Radon Test",
                "Where to Place a Radon Test: Best Room, Floor & Height",
                "Find the best room, floor, and height for a home radon test. Avoid placement mistakes that can make the result harder to trust.",
                "Placement guide",
                "Test setup",
                "Place the device on the lowest level used regularly, in a living room, bedroom, office, den, or open basement area. Avoid kitchens, bathrooms, closets, and storage nooks. Follow the device instructions for exact height and clearance.",
                List.of(
                        section("choose-level", "Choose the lowest level people actually use",
                                "The goal is to measure where exposure can occur, not simply the physically lowest void in the building. EPA's residential guide uses the lowest lived-in level. A frequently used basement belongs in the test plan; an unused crawl space does not represent a living area.",
                                "For an apartment or condominium, CDC says to use the lowest level inside your unit. Do not move the device into a building basement that is outside the occupied unit merely because it is lower."),
                        section("choose-room", "Use a regular room, not a convenient corner",
                                "Living rooms, family rooms, bedrooms, playrooms, dens, and home offices are useful choices because people spend time there. EPA guidance excludes kitchens and bathrooms from a representative home measurement, and enclosed storage spaces do not stand in for occupied rooms.",
                                "Pick the room before opening or activating a passive device. Moving it later creates a handling question that should stay with the record."),
                        section("height-distance", "Let the device instructions settle height and distance",
                                "CDC gives a simple public rule: raise the device three feet off the floor and place it in the middle of the room. EPA's Citizen's Guide gives additional general cautions about drafts, heat, humidity, exterior walls, and places where the device can be disturbed.",
                                "Different approved devices can specify different mounting details. Record the kit name and follow its package or laboratory instructions rather than blending numbers from unrelated guides."),
                        section("document", "Record placement so the result has context",
                                "Write down the floor, room, device name, start time, and whether the device stayed in place. A result without placement context is harder to review later, especially during a home sale or after renovation.",
                                "Run the placement through the test planner before you start, then keep the record with the laboratory result.")),
                List.of("Lowest regularly used level selected", "Regularly occupied room selected", "Kitchen, bathroom, closet, and storage areas avoided", "Kit-specific height and clearance instructions followed", "Location and start time recorded"),
                List.of(
                        faq("Should a radon test go in the basement?", "Yes when the basement is the lowest level used regularly. If it is not used, the first floor may better match EPA's lowest lived-in-level guidance. A real-estate test can follow a different placement protocol."),
                        faq("Can I put a radon test on the floor?", "Do not improvise. CDC's general instruction says to raise the device three feet, while particular devices may provide their own mounting directions. Follow the supplied instructions."),
                        faq("Can I test in a bedroom?", "Yes. EPA lists bedrooms among regularly used rooms suitable for a representative residential test.")),
                List.of(CDC, EPA_CITIZEN));
    }

    private static TestProtocolGuide duration() {
        return guide(
                "short-term-vs-long-term-radon-test",
                "How Long Does a Radon Test Take?",
                "How Long Does a Radon Test Take? 2–90 Days Explained",
                "See how long a radon test takes, from the device's exposure window through mailing, laboratory processing, and the final report.",
                "Test duration",
                "Test setup",
                "A short-term radon test measures for 2–90 days; a long-term test measures for more than 90 days. That is the exposure window—not always the total time until you receive a result. Add any pickup, mailing, laboratory, and reporting time required by the specific device.",
                List.of(
                        section("short", "Short-term means 2 to 90 days",
                                "A short-term test answers a practical question quickly. It samples a limited period, so weather, season, ventilation, and ordinary living conditions can influence how well that period represents the rest of the year.",
                                "Do not assume every short-term kit should run for the same number of days. The device label or laboratory instructions establish its allowed exposure window."),
                        section("long", "Long-term means more than 90 days",
                                "A long-term device stays in place beyond 90 days. CDC says the longer period better reflects the home's year-round average and the way occupants actually use the home.",
                                "The tradeoff is simple: better time coverage in exchange for a slower answer. A long-term test is not a substitute for following placement and handling instructions."),
                        section("transaction", "A home sale is a separate testing context",
                                "EPA's real-estate guide is designed for a time-sensitive transaction and possible interference. Its checklist calls for at least 48 hours and describes multiple transaction testing options.",
                                "Do not carry that transaction protocol into every household test without checking the device and state requirements. If a sale, lender, or inspection is involved, use a qualified tester when required and preserve the report."),
                        section("record-time", "Record start and stop times—not just dates",
                                "A label such as “two days” can hide a 36-hour exposure. Recording the exact start and stop times makes the duration reviewable and lets the planner calculate hours without guessing.",
                                "If the calculated duration conflicts with the device minimum, verify the timestamps and device instructions before relying on the sample."),
                        section("total-time", "Exposure time is not the full results timeline",
                                "A continuous monitor may produce a report after retrieval, while a passive kit may need to be sealed, shipped, received, analyzed, and reported by a laboratory. Those steps occur after the required exposure window.",
                                "Before starting, write down the exposure minimum, maximum exposure if the device has one, return deadline, shipping method, laboratory turnaround, and the date your decision must be made. Do not promise a universal three-to-five-day result when the kit instructions say otherwise.")),
                List.of("Decision deadline identified", "Short-term or long-term device confirmed", "Device-specific exposure window checked", "Exact start and stop times recorded", "Transaction requirements checked separately"),
                List.of(
                        faq("Is 48 hours enough for a radon test?", "It can be the minimum for some short-term and real-estate protocols, but not every device. The package or laboratory instructions determine the required exposure."),
                        faq("Is a 90-day radon test long-term?", "No under CDC's definition. A long-term test runs for more than 90 days."),
                        faq("Which test is more accurate?", "CDC says a long-term test better reflects the year-round average. A short-term test is useful when a faster result is needed."),
                        faq("How long does it take to get radon test results?", "The measurement can take 2–90 days for a short-term test or more than 90 days for a long-term test. Your total wait also depends on device retrieval, mailing, laboratory processing, and reporting. Check the exact kit or tester timeline before you start.")),
                List.of(CDC, EPA_REAL_ESTATE));
    }

    private static TestProtocolGuide closedHouse() {
        return guide(
                "radon-closed-house-conditions",
                "Radon Closed-House Conditions",
                "Radon Closed-House Conditions: 12-Hour Checklist",
                "Use this 12-hour closed-house checklist for a 2–4 day real-estate radon test: windows, exterior doors, fans, HVAC, and test timing.",
                "Testing conditions",
                "Test conditions",
                "For a 2–4 day real-estate test, close windows and begin closed-house conditions at least 12 hours before the test. Keep exterior doors closed except for normal entry and exit, and do not run equipment that brings in outdoor air.",
                List.of(
                        section("meaning", "What “closed house” actually means",
                                "The house does not need to be vacant or sealed against normal entry. EPA's definition allows ordinary entry and exit. The condition is about avoiding deliberate outdoor-air exchange that changes the test environment.",
                                "Heating and cooling can operate normally. For a transaction test lasting less than one week, EPA says only air-conditioning units that recirculate indoor air should operate."),
                        section("before", "For 2–4 day transaction tests, start 12 hours early",
                                "EPA's real-estate checklist says to maintain closed-house conditions for at least 12 hours before a 2–4 day short-term test begins and throughout the test. For 4–7 day transaction tests, EPA recommends maintaining the conditions.",
                                "Because our planner asks only whether the condition was followed, it cannot verify each window, fan, or timestamp. Record any uncertainty rather than converting it into a clean pass."),
                        section("during", "Keep conditions steady during the test",
                                "Do not open windows for ventilation or run equipment that brings in outside air. Do not disturb the device. If an active radon-reduction system is already installed, EPA says it should operate properly throughout the test.",
                                "A brief normal door opening is not the same as leaving a door open. Write down any event that may matter so a tester or laboratory can review it."),
                        section("scope", "This page does not create a universal legal rule",
                                "The cited checklist was written for home purchases and sales. Device instructions, state requirements, and professional standards may be more specific and can control the test.",
                                "For a routine home test, read the kit's conditions first. RadonVerdict does not infer state law from the federal guide.")),
                List.of("Transaction context confirmed", "Windows kept closed", "Exterior doors used only for normal entry and exit", "Outdoor-air fans and machines not operated", "Required pre-test period documented", "Device and mitigation system left operating as instructed"),
                List.of(
                        faq("Can I open the door during a radon test?", "EPA's closed-house definition permits normal entry and exit. It does not support leaving exterior doors open for ventilation."),
                        faq("Can the air conditioner run?", "EPA's transaction guide says normal heating and cooling may operate; for tests under one week, air-conditioning should recirculate indoor air rather than bring in outside air."),
                        faq("What if a window was opened?", "Record what happened and for how long, then check the device or laboratory instructions. For a transaction test, the protocol may need professional review or another test.")),
                List.of(EPA_REAL_ESTATE));
    }

    private static TestProtocolGuide validity() {
        return guide(
                "is-my-radon-test-valid",
                "Is My Radon Test Valid?",
                "Is My Radon Test Valid? Check 6 Common Problems",
                "Check six common radon testing problems: device type, placement, duration, closed-house conditions, interference, and laboratory handling.",
                "Validity check",
                "Test handling",
                "Check the procedure—not the radon number. Confirm the device, placement, exposure time, house conditions, handling, and laboratory submission. Any missing or conflicting detail tells you exactly what to verify next.",
                List.of(
                        section("device", "Confirm the device and its instructions",
                                "Identify whether the test was short-term, long-term, or a continuous monitor. Find the package, laboratory sheet, or report that states its exposure and handling requirements.",
                                "If the device type is unknown, duration and handling cannot be checked reliably. Recover that information before treating the record as complete."),
                        section("placement", "Reconstruct where the device sat",
                                "Check the level, room, approximate height, and nearby conditions. A kitchen, bathroom, closet, storage nook, draft, heat source, high humidity, or frequent handling can conflict with general EPA placement guidance.",
                                "The device's instructions remain the final reference because different technologies can have different placement limits."),
                        section("time-condition", "Check the complete exposure period",
                                "Use exact start and stop times. CDC defines short-term as 2–90 days and long-term as more than 90 days, but the device can set a narrower window.",
                                "For a short-term real-estate test, also review EPA's closed-house checklist. If occupants or the tester cannot confirm the required conditions, the transaction guide says another test may be appropriate."),
                        section("handling", "Look for movement, covering, unplugging, or late mailing",
                                "EPA says the device should not be disturbed. Passive kits also need to be resealed and returned according to the laboratory directions after the exposure ends.",
                                "Record uncertainty plainly. The right output may be “procedure may be compromised” rather than a false valid/invalid verdict.")),
                List.of("Device type and kit name confirmed", "Placement checked against device instructions", "Exact duration inside the allowed window", "Required house conditions confirmed", "No movement, covering, unplugging, or interference", "Return and laboratory instructions followed"),
                List.of(
                        faq("Can a radon result look normal but come from a bad test?", "Yes. The number alone does not prove the procedure was followed. Review placement, duration, conditions, and handling separately."),
                        faq("How can I check my radon test procedure?", "Enter the device, placement, duration, house conditions, and handling details in the RadonVerdict planner. It will flag conflicts against its published EPA- and CDC-linked rule set."),
                        faq("What should I do if I cannot confirm the test conditions?", "Keep the uncertainty in the record and consult the device provider, laboratory, qualified tester, or applicable state program before relying on the result.")),
                List.of(CDC, EPA_CITIZEN, EPA_REAL_ESTATE));
    }

    private static TestProtocolGuide retest() {
        return guide(
                "when-to-retest-for-radon",
                "When to Retest for Radon",
                "When to Retest for Radon: 4 Times to Test Again",
                "Learn when to retest for radon after a procedure problem, mitigation, renovation, a move to a lower level, or before a home sale.",
                "Retesting guide",
                "Retesting",
                "Retest when the first procedure cannot be verified, after major renovation or mitigation, when someone begins using a lower level, or when an older result no longer describes the home. Correct the original problem before starting the new test.",
                List.of(
                        section("procedure", "Retest when the first procedure cannot be supported",
                                "A completed short-term record below the device minimum, a long-term record that did not exceed 90 days, incorrect placement, or a disturbed device can all require review. For a transaction test, unconfirmed closed-house conditions are another material gap.",
                                "Check the laboratory or device instructions before repeating the exact same setup. The purpose of the new test is to correct the identified problem, not merely produce another number."),
                        section("home-change", "Retest after the home or occupancy changes",
                                "CDC recommends testing before and after major renovation, especially work intended to reduce radon. It also recommends testing before someone begins spending more time in a basement or lower level.",
                                "EPA similarly says to retest when living patterns shift to a lower level. A previous first-floor result does not automatically document a newly occupied basement."),
                        section("sale", "A buyer may reasonably ask for a newer record",
                                "EPA says a buyer may ask for a new test if the checklist was not met, the last test is not recent—for example, within two years—the home was altered, or the buyer plans to use a lower level than the one tested.",
                                "This is guidance, not a universal disclosure law. State, lender, contract, and professional requirements can differ."),
                        section("mitigation", "Keep testing in the maintenance record",
                                "After mitigation, testing verifies measured performance rather than merely checking whether a fan sounds normal. CDC advises retesting after work, and EPA says it is a good idea to retest a mitigated home at least every two years.",
                                "Keep the new result with the system label, prior reports, repairs, and the date of any fan or foundation work.")),
                List.of("Reason for retest written down", "Original procedural problem corrected", "Current room and occupancy reflected", "Exact start and stop times recorded", "Renovation or mitigation dates preserved", "State or transaction requirements checked"),
                List.of(
                        faq("How often should I retest after mitigation?", "EPA says it is a good idea to retest a mitigated home at least every two years, in addition to checking the system warning device regularly."),
                        faq("Should I retest after renovating?", "Yes. CDC recommends testing before and after major structural renovation because changes to the home can change radon levels."),
                        faq("Is a two-year-old test still usable for a home sale?", "EPA says a buyer may request a new test when the last result is not recent, using within two years as an example. Contract and state requirements may be more specific.")),
                List.of(CDC, EPA_RETEST, EPA_REAL_ESTATE));
    }

    private static TestProtocolGuide windows() {
        return guide(
                "can-you-open-windows-during-radon-test", "Can You Open Windows During a Radon Test?",
                "Can You Open Windows During a Radon Test?", "Learn when windows must stay closed during a short-term radon test, what normal entry means, and what to record if a window was opened.",
                "Closed-house question", "Test conditions",
                "For a short-term real-estate radon test, keep windows closed during the test and begin closed-house conditions at least 12 hours before a 2–4 day test. Normal brief entry through exterior doors is allowed; opening windows for ventilation is not.",
                List.of(
                        section("rule", "The rule depends on the test you are running",
                                "EPA's home-sale checklist applies closed-house conditions to short-term transaction measurements. For a 2–4 day test, those conditions begin at least 12 hours before deployment and continue until the device is collected.",
                                "A long-term test is intended to represent normal living over many months. Do not automatically impose a short transaction protocol on it; follow the device and laboratory instructions for that measurement."),
                        section("doors", "Normal entry is different from ventilation",
                                "Closed-house conditions do not require an empty or hermetically sealed building. EPA allows normal entry and exit through exterior doors, provided doors are not left open to exchange indoor and outdoor air.",
                                "Tell every occupant what the test requires before it starts. A written note near frequently used doors and windows is easier to follow than relying on memory."),
                        section("mistake", "If a window was opened, preserve the facts",
                                "Close the window when the mistake is discovered and record which window was open, approximately how long it stayed open, and when the event occurred within the exposure period.",
                                "Do not quietly erase the event or declare the result invalid from one fact alone. The device provider, laboratory, tester, or controlling transaction protocol should decide whether the measurement remains reportable."),
                        section("plan", "Prevent the problem before deployment",
                                "Choose a period when the household can realistically maintain the required conditions. Avoid starting just before cleaning, moving, painting, construction, or an event that will keep doors open.",
                                "Record the pre-test start time separately from the device start time. That distinction makes the 12-hour preparation period reviewable later.")),
                List.of("Test type and purpose confirmed", "Required pre-test period recorded", "All occupants notified", "Windows kept closed as instructed", "Exterior doors used only for normal entry and exit", "Any breach documented with time and duration"),
                List.of(
                        faq("Does opening a door ruin a radon test?", "Normal brief entry and exit is allowed under EPA's closed-house definition. Leaving a door open for ventilation is a different condition and should be documented."),
                        faq("What if a window was open for five minutes?", "Close it, record the event, and ask the device provider or tester whether the applicable protocol requires a retest. RadonVerdict does not invent a universal grace period."),
                        faq("Do windows stay closed for a long-term test?", "Long-term tests are generally intended to reflect normal living. Follow that device's instructions instead of carrying over a short-term real-estate rule.")),
                List.of(EPA_REAL_ESTATE));
    }

    private static TestProtocolGuide livingDuringTest() {
        return guide(
                "can-you-live-in-house-during-radon-test", "Can You Live in the House During a Radon Test?",
                "Can You Live in a House During a Radon Test?", "See what daily activities can continue during a radon test and which ventilation, handling, and construction changes can compromise the record.",
                "Occupant checklist", "Test conditions",
                "Yes. You can normally live in the house during a radon test. For a short-term test, keep the required closed-house conditions, use exterior doors only for normal entry and exit, leave the device alone, and avoid unusual ventilation or construction activity.",
                List.of(
                        section("normal", "Ordinary occupancy is expected",
                                "A residential measurement is not a requirement to vacate the home. Sleeping, cooking, bathing, and coming and going can continue unless the device instructions or a professional testing agreement says otherwise.",
                                "The important question is whether household activity changes airflow around the device or violates the stated test conditions. Normal occupancy and uncontrolled ventilation are not the same thing."),
                        section("hvac", "Operate permitted heating and cooling normally",
                                "EPA's transaction checklist allows normal operation of heating and cooling. During a test lasting less than one week, air-conditioning equipment should recirculate indoor air rather than deliberately bring in outdoor air.",
                                "Whole-house fans, window fans, or other equipment that exchanges large amounts of outdoor air can conflict with closed-house conditions. Write down uncertain equipment instead of guessing from its name."),
                        section("device", "Keep people and pets away from the device",
                                "Choose a location where the sampler will not be bumped, covered, unplugged, or moved. A note or simple boundary around the area can prevent accidental handling without changing room airflow.",
                                "If movement happens, record it. The laboratory or tester may need the timing and extent of the event to decide whether the result can be used."),
                        section("events", "Schedule around abnormal household events",
                                "Moving day, floor refinishing, major cleaning, open-house traffic, remodeling, and extended deliveries can make the measurement period unlike the planned protocol.",
                                "Start when conditions can remain stable. If an unavoidable event occurs, preserve it in the test record and obtain protocol-specific advice before relying on the number.")),
                List.of("Occupants know the test is running", "Heating and cooling rules checked", "Outdoor-air equipment avoided", "Device protected from people and pets", "No construction or unusual ventilation planned", "Unexpected events recorded"),
                List.of(
                        faq("Do I have to leave my home during a radon test?", "No. Ordinary occupancy is generally compatible with home testing when the device and required house conditions are maintained."),
                        faq("Can I cook and shower during the test?", "Usually yes. Keep the device out of kitchens, bathrooms, humidity, heat, and drafts, and follow its instructions."),
                        faq("Can pets stay in the house?", "Yes, but place the device where a pet cannot disturb, cover, or move it.")),
                List.of(EPA_REAL_ESTATE, CDC));
    }

    private static TestProtocolGuide weather() {
        return guide(
                "radon-test-during-rain-or-storm", "Can You Run a Radon Test During Rain or a Storm?",
                "Radon Test During Rain or a Storm: Should You Wait?", "Check when rain, high winds, severe storms, and unusual weather should be recorded or may justify delaying a short-term radon test.",
                "Weather check", "Test conditions",
                "Ordinary weather does not automatically cancel a radon test, but severe storms or unusually high winds can make a very short measurement less representative. Check the device protocol, record the weather, and delay a short test when its instructions prohibit those conditions.",
                List.of(
                        section("variation", "Weather can change a short snapshot",
                                "Indoor radon varies over time as pressure, temperature, ventilation, and soil conditions change. A two-day or four-day test captures a much smaller weather window than a test that spans months.",
                                "That does not make every wet-day result wrong. It means the weather belongs in the record when it is unusual enough to influence the interpretation of a short exposure."),
                        section("severe", "Treat severe weather as a protocol question",
                                "EPA educational guidance cautions against short-term tests lasting less than four days during severe storms or periods of high winds. Device, state, transaction, or professional protocols can be more specific.",
                                "Do not invent a rainfall or wind threshold from a weather app. Use the controlling instructions, and ask the provider when the event falls in a gray area."),
                        section("during", "If weather changes after the test starts",
                                "Keep the device in place and continue following house-condition instructions unless the kit or tester directs otherwise. Record the event and its approximate timing rather than altering the setup mid-test.",
                                "A laboratory can only consider facts it receives. Include required weather or condition notes on the submission form or in the professional test record."),
                        section("choice", "Use duration to reduce sensitivity to one event",
                                "When a decision is not urgent, a longer measurement samples more day-to-day variation. CDC says long-term tests better reflect a home's year-round average than short-term tests.",
                                "When a home-sale deadline requires a short test, preserve the controlled conditions and use the transaction protocol instead of pretending the short result is a year-round average.")),
                List.of("Forecast checked before a short test", "Device weather restrictions reviewed", "Severe storm or high wind avoided when required", "Weather events recorded with timing", "Device left undisturbed", "Longer test considered when no deadline exists"),
                List.of(
                        faq("Does rain make a radon test invalid?", "Not automatically. The relevant question is whether the weather conflicts with the device or testing protocol and whether a short snapshot remains usable for the decision."),
                        faq("Should I stop a test when a storm begins?", "Do not change the setup on your own. Continue the stated procedure, record the event, and ask the laboratory or tester how the applicable protocol treats it."),
                        faq("Is a long-term test affected by one storm?", "A long-term result covers far more conditions, so one event represents a smaller part of the total period. Follow the device instructions throughout.")),
                List.of(CDC, EPA_STORMS));
    }

    private static TestProtocolGuide season() {
        return guide(
                "best-time-of-year-to-test-for-radon", "Best Time of Year to Test for Radon",
                "Best Time of Year to Test for Radon: Winter or Summer?", "Learn whether winter is required, why any season can be useful, and when a longer radon test is the better choice for seasonal variation.",
                "Season guide", "Test setup",
                "You can test for radon at any time of year if you can follow the test instructions. Winter is not universally required. A long-term test covering more than 90 days better represents seasonal and lifestyle variation than a short test in any single season.",
                List.of(
                        section("anytime", "Do not wait indefinitely for a perfect season",
                                "Michigan's official testing guidance says testing can be done at any time of year when closed-house conditions can be maintained. CDC likewise focuses on testing need, device type, placement, and duration rather than naming one mandatory month.",
                                "If the home has never been tested, delaying for many months can be less useful than completing a correct initial measurement now and planning follow-up testing deliberately."),
                        section("winter", "Winter can make closed conditions easier—not universal",
                                "In colder climates, occupants often keep windows closed, which can make short-test conditions easier to maintain. Radon also varies with weather, pressure, ventilation, and use of the home.",
                                "A winter number is still a measurement of its exposure window. Do not label one short winter result as the home's permanent or guaranteed maximum."),
                        section("long", "Use a long test for the annual-average question",
                                "CDC defines a long-term test as more than 90 days and says it better reflects the year-round average and the way occupants live in the home.",
                                "Long duration does not excuse poor placement or device handling. Choose an occupied area, follow the detector instructions, and keep a record of major changes during the measurement."),
                        section("decision", "Let the decision deadline choose the first test",
                                "A real-estate transaction may require a controlled short-term protocol because the decision cannot wait months. Routine household monitoring allows more time and can prioritize a representative average.",
                                "Write down whether the goal is rapid screening, sale documentation, post-mitigation verification, or long-term exposure tracking before selecting the season and device.")),
                List.of("Decision purpose written down", "Current season can support the instructions", "Closed-house conditions feasible when required", "Short test treated as a snapshot", "Long-term test considered for annual average", "Follow-up plan recorded"),
                List.of(
                        faq("Is winter the best time to test for radon?", "Winter can make closed conditions practical in cold climates, but it is not a universal requirement. A correctly performed test now is often better than an indefinite delay."),
                        faq("Can I test for radon in summer?", "Yes, if the house and device conditions can be maintained. Record unusual ventilation and follow the kit instructions."),
                        faq("Which season gives the true radon level?", "Radon changes over time. A long-term measurement is designed to represent more seasonal variation than a short test in one season.")),
                List.of(CDC, MICHIGAN_TESTING));
    }

    private static TestProtocolGuide deviceComparison() {
        return guide(
                "charcoal-vs-digital-radon-test", "Charcoal Test Kit vs. Digital Radon Monitor",
                "Charcoal Radon Test vs Digital Monitor: Which Fits?", "Compare single-use charcoal kits and reusable digital radon monitors by timing, records, laboratory handling, and decision purpose.",
                "Device comparison", "Test setup",
                "Choose by decision, not display type. A charcoal kit provides one passive exposure that is returned to a laboratory. A digital monitor can show repeated readings and trends. Neither is reliable when placement, duration, handling, or device instructions are ignored.",
                List.of(
                        section("charcoal", "A charcoal kit is a defined laboratory workflow",
                                "The device is exposed for its permitted window, sealed at the stop time, and returned as instructed. Its value is a bounded measurement with a laboratory result, not an instant display.",
                                "Before buying, check whether analysis, return shipping, expiration, and turnaround are included. Those operational details determine whether the kit can meet the decision deadline."),
                        section("digital", "A digital monitor adds time-based feedback",
                                "A reusable electronic monitor can display short- and long-term averages or trends, depending on the model. Consumer monitoring and a professional real-estate measurement are not automatically interchangeable.",
                                "Read the manufacturer's warm-up, placement, averaging, calibration, power, and data-export instructions. A screen does not replace a documented protocol."),
                        section("decision", "Match the device to the evidence you need",
                                "For an initial household screen, a properly used home kit can answer the first question. For ongoing observation, a reusable monitor can make repeated measurements easier.",
                                "For a purchase, sale, lender, or legal requirement, check the applicable state and transaction rules and use a qualified provider when required."),
                        section("compare", "Do not treat disagreement as proof of one winner",
                                "Two devices can cover different times, locations, sensitivities, and averaging periods. When results disagree, align the placement and measurement window before comparing the numbers.",
                                "Preserve both records and ask the providers about quality controls. A follow-up test under a defined procedure is more useful than choosing the preferred number.")),
                List.of("Decision purpose identified", "Exposure window fits deadline", "Laboratory and shipping terms checked", "Device instructions available", "Placement and averaging periods aligned", "Transaction requirements checked separately"),
                List.of(
                        faq("Is a digital radon monitor better than charcoal?", "It provides different information, especially trends and reusable monitoring. Better depends on the decision, protocol, device quality, and documentation needed."),
                        faq("Can I use a home digital monitor for a real-estate test?", "Do not assume so. State, contract, lender, and professional protocols may require qualified devices or testers."),
                        faq("Why do my monitor and charcoal kit disagree?", "They may cover different times, locations, and averaging methods. Align those factors and perform a defined follow-up instead of selecting one result by preference.")),
                List.of(CDC, EPA_CITIZEN, EPA_REAL_ESTATE));
    }

    private static TestProtocolGuide expiredKit() {
        return guide(
                "expired-radon-test-kit", "Can You Use an Expired Radon Test Kit?",
                "Expired Radon Test Kit: Can You Still Use It?", "Check the expiration date, laboratory deadline, storage history, and replacement options before opening an old radon test kit.",
                "Kit check", "Test handling",
                "Do not rely on an expired radon test kit. Check the printed expiration date before opening it and replace the kit if that date has passed. Also verify the laboratory is still accepting that model and can receive it within the required return window.",
                List.of(
                        section("date", "Find the device and laboratory deadlines",
                                "Michigan's official radon FAQ states that test kits expire and recommends obtaining a new kit after the printed expiration date. The date may appear on the package, device, activation card, or laboratory form.",
                                "A kit can also have a return or analysis deadline that is different from the exposure period. Read every dated instruction before choosing the start day."),
                        section("storage", "Expiration is not the only pre-test check",
                                "Confirm the package remained sealed and was stored as directed. Moisture, damaged packaging, a missing identifier, or an already activated device can make an apparently current kit unusable.",
                                "Do not repair or reseal a questionable sampler. Contact the named laboratory with the kit or lot information when its condition is unclear."),
                        section("replace", "Replace uncertainty before collecting a sample",
                                "A replacement kit costs less time than completing an exposure that the laboratory cannot analyze. EPA advises checking state programs because some provide free or discounted kits.",
                                "When the deadline matters, confirm laboratory turnaround and return shipping before starting. A valid device that arrives too late may still fail the decision schedule."),
                        section("record", "Keep identifiers with the final result",
                                "Photograph or record the device number, lot number, expiration date, laboratory, and activation date. Keep that information with the start and stop times and result report.",
                                "This record helps distinguish a device problem from placement, timing, shipping, or laboratory handling if a result is delayed or rejected.")),
                List.of("Printed expiration date checked", "Package sealed and undamaged", "Laboratory still accepts the device", "Return deadline fits the plan", "Kit identifier recorded", "Replacement obtained if any requirement is uncertain"),
                List.of(
                        faq("Will a laboratory process an expired radon kit?", "Policies vary. Check with the named laboratory before exposure, but do not rely on an expired device for a decision."),
                        faq("Where can I replace an expired kit?", "EPA recommends checking state radon programs as well as approved retail and program sources; some states offer free or discounted kits."),
                        faq("Does the kit expire while it is being mailed?", "The device instructions determine the relevant exposure, expiration, and arrival deadlines. Plan backward from the laboratory's required receipt date.")),
                List.of(MICHIGAN_FAQ, EPA_KITS));
    }

    private static TestProtocolGuide movedDevice() {
        return guide(
                "radon-test-moved-or-tampered", "What If a Radon Test Was Moved or Tampered With?",
                "Radon Test Moved or Tampered With: Is It Still Valid?", "Document a moved, covered, unplugged, or disturbed radon device and decide what evidence the laboratory or tester needs before relying on the result.",
                "Interference check", "Test handling",
                "Do not hide or guess about a moved radon test. Return the device to its documented position only if the instructions allow it, record what changed and when, and ask the laboratory or tester whether the applicable protocol requires a retest.",
                List.of(
                        section("events", "Movement is one of several interference events",
                                "EPA's transaction checklist says the device should not be disturbed and that testing should include methods to prevent or detect interference. Covering, unplugging, relocating, opening, or altering a sampler can matter.",
                                "A small accidental bump and moving a monitor to another room are different events. Preserve the extent and timing instead of reducing both to a yes-or-no label."),
                        section("response", "Do not create a second undocumented change",
                                "If the original position is known and the instructions permit it, restore the setup carefully. Do not open a passive device, reset an electronic monitor, or change settings merely to make the record look clean.",
                                "Contact the provider when the correct response is unclear. The device technology and protocol determine what can be recovered."),
                        section("document", "Write an incident note that can be reviewed",
                                "Record the date and approximate time, original and new location, distance moved, whether the device remained open or powered, and who discovered the change.",
                                "Photographs can preserve placement context, but they do not prove every condition during the entire test. Attach them to the test record as supporting evidence."),
                        section("retest", "Retest when the procedure cannot support the decision",
                                "A laboratory may report the sample, add a qualification, reject it, or advise repeating it. A real-estate protocol may be stricter than a personal screening measurement.",
                                "If another test is needed, choose a protected location, notify occupants, and record placement before activation so the same failure does not repeat.")),
                List.of("Type of interference identified", "Timing and duration recorded", "Original and changed placement documented", "Device remained sealed or powered as required", "Laboratory or tester contacted", "Retest plan corrects the original problem"),
                List.of(
                        faq("Does moving a radon test a few inches ruin it?", "There is no universal distance rule. Record the movement and ask the device provider or tester how its protocol treats the event."),
                        faq("What if a digital monitor was unplugged?", "Record the outage and check whether the device retained a complete measurement. A transaction report may require professional review or another test."),
                        faq("Can a seller touch a radon test?", "A transaction test should include controls against interference. Any suspected handling should be documented and reviewed under the applicable testing agreement and state requirements.")),
                List.of(EPA_REAL_ESTATE, EPA_CITIZEN));
    }

    private static TestProtocolGuide mailingKit() {
        return guide(
                "how-to-mail-radon-test-kit", "How to Mail a Radon Test Kit",
                "How to Mail a Radon Test Kit Without Losing the Result", "Close, label, document, and return a passive radon test kit on time so the laboratory receives the information needed to analyze it.",
                "Return checklist", "Test handling",
                "Stop the test at the planned time, seal the device exactly as instructed, complete every required field, and send it promptly to the named laboratory using the required packaging and shipping method. Keep the device ID and shipping record.",
                List.of(
                        section("stop", "Record the stop time before packing",
                                "The laboratory needs an exposure period, not an estimate such as 'about three days.' Record the exact stop date and time before sealing or deactivating the sampler.",
                                "Check the calculated hours against the device's permitted window. Do not extend a finished test while searching for shipping materials unless the instructions explicitly allow it."),
                        section("seal", "Use the supplied closure and packaging",
                                "Passive devices must be closed or resealed according to their own design. Use the cap, pouch, adhesive, mailer, or activation process specified for that kit.",
                                "Do not substitute household packaging when it blocks required labeling or conflicts with laboratory instructions. Contact the lab if a supplied part is lost or damaged."),
                        section("form", "Complete the chain of basic facts",
                                "Typical required fields include device number, location, start and stop times, contact information, and test purpose. The exact form controls, so review it before the device leaves the room.",
                                "Keep a photograph or copy of the completed form without exposing private information publicly. This helps resolve a missing or mismatched laboratory record."),
                        section("ship", "Treat laboratory arrival as part of the test",
                                "CDC instructs users to follow the package directions for sending the completed device. Some technologies have prompt-return or receipt deadlines because delay affects analysis.",
                                "Use tracking when appropriate and keep the receipt. If delivery is delayed beyond the stated window, ask the laboratory whether it can still issue a report before relying on the result.")),
                List.of("Exact stop date and time recorded", "Exposure window verified", "Device sealed as instructed", "Every required form field completed", "Correct laboratory address and method used", "Device ID and shipping receipt retained"),
                List.of(
                        faq("How soon should I mail a radon test kit?", "Promptly, within the device and laboratory instructions. Some devices have time-sensitive analysis requirements."),
                        faq("Can I use regular mail?", "Use the method stated by the kit or laboratory. Consider tracking when a deadline or transaction depends on the result."),
                        faq("What if my kit arrives late?", "Contact the laboratory with the device ID and dates. Do not assume the sample remains analyzable or automatically discard it without their instruction.")),
                List.of(CDC, EPA_CITIZEN));
    }

    private static TestProtocolGuide apartment() {
        return guide(
                "radon-testing-in-apartments", "How to Test an Apartment for Radon",
                "Radon Testing in Apartments: Where to Place the Device", "Choose the correct level and room for a radon test inside an apartment, condominium, or other multi-unit home.",
                "Multi-unit guide", "Test setup",
                "In a multi-unit building, CDC says to place the device on the lowest level within your unit. Use a regularly occupied room, follow the device instructions, and do not move the test to a shared basement that is outside the occupied unit.",
                List.of(
                        section("unit", "Start with the space you actually occupy",
                                "The relevant placement is inside the apartment or condominium unit. CDC's public guidance says residents of multi-unit buildings should use the lowest level within their unit.",
                                "A building basement, utility room, or parking level can answer a different property-management question but does not substitute for the occupied unit measurement."),
                        section("room", "Choose a normal occupied room",
                                "Use a bedroom, living room, den, office, or other room where people spend time. Avoid kitchens, bathrooms, closets, high humidity, drafts, heat, and areas where the device will be disturbed.",
                                "Follow the exact height and clearance instructions for the chosen device. Record the floor number and room so the result can be understood later."),
                        section("permission", "Coordinate access without changing the protocol",
                                "A renter can ask the landlord or property manager about prior testing, building policies, and state resources. Do not allow maintenance work or an inspection visit to move the active device without documentation.",
                                "Testing and disclosure requirements vary by jurisdiction and building program. Federal placement guidance does not create a universal landlord duty."),
                        section("scope", "One unit result does not map the entire building",
                                "Radon levels can differ between units, floors, and foundation-contact areas. A neighbor's result cannot prove the level in your unit, and your result does not characterize every apartment.",
                                "If a building-wide decision is needed, property management should use the applicable multi-family measurement standard or qualified provider rather than extrapolate from one device.")),
                List.of("Device remains inside the occupied unit", "Lowest level within the unit selected", "Regularly occupied room selected", "Kitchen and bathroom avoided", "Floor and room recorded", "Building-wide claims avoided"),
                List.of(
                        faq("Should I test a high-rise apartment?", "Testing decisions depend on location and program guidance, but a test is the only way to measure your unit. Contact the state radon program for local recommendations."),
                        faq("Can I use the building basement result?", "It does not replace a measurement inside your unit. The basement can be part of a separate building assessment."),
                        faq("Does my neighbor's low result mean my apartment is low?", "No. Radon can vary between nearby spaces, so each result should be tied to its exact location and conditions.")),
                List.of(CDC, EPA_CITIZEN));
    }

    private static TestProtocolGuide afterRenovation() {
        return guide(
                "radon-test-after-renovation", "When to Test for Radon After Renovation",
                "Radon Test After Renovation: When and Where to Retest", "Build a radon retest plan after basement finishing, foundation work, weatherization, HVAC changes, or other major home renovation.",
                "Renovation retest", "Retesting",
                "CDC recommends testing before and after major structural renovation. Retest after the work and normal building operation are established, especially when the project changed the foundation, ventilation, HVAC, or use of a basement or lower level.",
                List.of(
                        section("before", "A pre-work test creates a useful baseline",
                                "Testing before renovation documents the home under its existing structure, ventilation, and occupancy. CDC specifically highlights major work and conversions of unfinished basements into living space.",
                                "Record the room, level, device, dates, and conditions. A bare number without that context is difficult to compare after the project changes the house."),
                        section("changes", "Identify what the project changed",
                                "Foundation openings, waterproofing, sump work, new windows, air sealing, insulation, HVAC replacement, additions, and basement finishing can change airflow or the lowest occupied level.",
                                "The retest location should reflect how people will now use the home. Do not automatically return to a first-floor room if a new basement bedroom or office became the lowest occupied space."),
                        section("after", "Test the completed home—not a construction event",
                                "Finish work that changes the test environment before starting the comparison measurement. Dust control, open doors, temporary fans, curing materials, and contractor traffic can make conditions unlike normal occupancy.",
                                "The device or professional protocol may specify timing. Record the completion date and when normal heating, cooling, and occupancy resumed."),
                        section("compare", "Compare records before comparing numbers",
                                "Two results are most useful when placement, device type, duration, and conditions are known. If those factors changed, explain why instead of treating the readings as a controlled experiment.",
                                "An elevated post-work result should follow current EPA or CDC confirmation and mitigation guidance. The renovation itself does not prove the cause.")),
                List.of("Pre-renovation baseline preserved", "Structural and ventilation changes listed", "New lowest occupied level identified", "Construction activity finished", "Normal HVAC operation restored", "Post-work placement and duration documented"),
                List.of(
                        faq("How soon after renovation should I test?", "Test after the relevant work is complete and normal building operation can be maintained, subject to the device or professional protocol."),
                        faq("Do new windows require a radon retest?", "Energy and ventilation changes can affect the home, so include them in the retest decision and record."),
                        faq("Should I test a newly finished basement?", "Yes. CDC recommends testing before someone begins spending more time on a lower level, and after major renovation.")),
                List.of(CDC, EPA_RETEST));
    }

    private static TestProtocolGuide afterMitigation() {
        return guide(
                "radon-test-after-mitigation", "How to Test for Radon After Mitigation",
                "Radon Test After Mitigation: Verification and Retesting", "Verify a new or repaired radon mitigation system with a documented post-mitigation test and a continuing retest schedule.",
                "Post-fix verification", "Retesting",
                "A working fan or manometer does not prove the indoor radon level. Keep the system operating, complete a post-mitigation measurement under the applicable protocol, preserve the before-and-after records, and retest at least every two years as EPA advises.",
                List.of(
                        section("purpose", "The post-mitigation test verifies measured performance",
                                "EPA's reduction guide recommends follow-up measurement after a mitigation system is installed. Mechanical indicators show that equipment is operating, while only an indoor measurement shows the radon level during the test period.",
                                "Keep the original high result, installation record, system label, and post-work result together. They answer different parts of the verification story."),
                        section("system", "Leave the system operating as intended",
                                "EPA states that a fan-powered radon system should run continuously. Do not switch it off to create a comparison unless a qualified professional and controlling protocol explicitly direct that procedure.",
                                "Check the warning device before deployment and record its reading or status. A changed or flat indicator is a service question, not a reason to improvise fan controls."),
                        section("test", "Define the test window and location",
                                "Use the lowest occupied area relevant to the household and follow the device instructions. A professional transaction or warranty verification can have different timing and documentation requirements from a routine household check.",
                                "Record installation completion, device start and stop times, room, level, system status, and unusual events. These facts make the before-and-after comparison reviewable."),
                        section("ongoing", "Verification is followed by maintenance testing",
                                "EPA recommends checking the warning device regularly and says it is a good idea to retest a mitigated home at least every two years.",
                                "Retest after repairs or major building changes as well. A historical low result does not demonstrate that a fan, pipe, seal, or changed home continues to control radon today.")),
                List.of("Pre-mitigation result retained", "System left operating continuously", "Warning device checked", "Post-work location and duration recorded", "Result stored with installation documents", "Two-year retest reminder created"),
                List.of(
                        faq("How soon after mitigation should I retest?", "Use the installer's, device's, warranty's, and applicable protocol's timing. The test should occur after the system is operating as intended."),
                        faq("Does a normal manometer reading mean radon is low?", "No. It indicates a pressure condition in the system, not the indoor radon concentration. Verify performance with a radon measurement."),
                        faq("How often should a mitigated home be retested?", "EPA says it is a good idea to retest at least every two years, as well as after relevant repairs or changes.")),
                List.of(CDC, EPA_MAINTENANCE, EPA_REDUCTION));
    }

    private static TestProtocolGuide manometer() {
        return guide(
                "radon-manometer-reading", "How to Read a Radon System Manometer",
                "Radon Manometer Reading: Zero, Uneven, or Changed?", "Use the system label and baseline to check a U-tube radon manometer without mistaking pressure indication for a radon measurement.",
                "System indicator", "System maintenance",
                "A radon manometer shows pressure difference, not the radon level. Compare its current columns with the installer-marked normal reading. Equal columns, a major change, missing fluid, or an alarm means the system needs inspection; confirm indoor performance with a radon test.",
                List.of(
                        section("meaning", "The gauge does not display pCi/L",
                                "The common U-tube indicator shows pressure created by an active soil-depressurization system. Its fluid-column difference is evidence about system operation, not a direct measurement of radon in room air.",
                                "Do not translate inches of water column into a radon concentration. They are different measurements answering different questions."),
                        section("baseline", "Use the system's own marked baseline",
                                "Installers commonly mark the expected operating position on or beside the gauge. Compare current status with that documented baseline because fan, pipe, and foundation designs differ between systems.",
                                "A generic internet photo cannot establish the correct number for your installation. Preserve the label, installer's contact information, and commissioning record."),
                        section("change", "A zero or changed reading is a service signal",
                                "If the columns are level, fluid is missing, tubing is damaged, an alarm is active, or the reading differs materially from its mark, check the system documentation and contact the installer or qualified mitigator.",
                                "Do not open electrical equipment, resize a fan, disconnect piping, or add fluid based on this page. Those actions require system-specific diagnosis."),
                        section("verify", "Only retesting verifies indoor radon control",
                                "EPA tells owners to check the warning device regularly and to retest a mitigated home at least every two years. Both checks matter because one does not replace the other.",
                                "Record the gauge status when a radon test begins and ends. If the system changed during the exposure, keep that event with the result.")),
                List.of("Gauge identified as a pressure indicator", "Installer baseline located", "Current reading compared with the mark", "Tubing, fluid, and alarm visually checked", "Changed reading referred for service", "Indoor radon retest kept on schedule"),
                List.of(
                        faq("Should both sides of a radon manometer be equal?", "On a running system, equal columns can indicate no measured pressure difference. Compare with the installer mark and contact the installer rather than assigning a universal target."),
                        faq("What number should my radon manometer read?", "There is no single correct reading for every system. Use the commissioned baseline for that installation."),
                        faq("Does the manometer tell me my radon level?", "No. It shows pressure difference. A radon test measures the indoor radon concentration.")),
                List.of(EPA_MAINTENANCE, EPA_REDUCTION));
    }

    private static TestProtocolGuide fanNoise() {
        return guide(
                "radon-fan-noise", "Radon Fan Noise: What Should You Check?",
                "Radon Fan Noise: Humming, Vibration, or Gurgling", "Triage a new radon fan noise using the warning device, system record, and indoor retest without attempting unsafe electrical or pipe repairs.",
                "Noise triage", "System maintenance",
                "A new or worsening hum, vibration, rattle, or gurgle is a reason to check the system indicator and contact the installer—not proof of one specific failure. Keep the fan running unless a qualified professional directs otherwise, and verify performance with a radon test.",
                List.of(
                        section("change", "The change matters more than an online sound label",
                                "Radon fans normally produce some continuous operating sound. A noise that is new, louder, intermittent, or accompanied by vibration or an alarm deserves inspection because fans and system components require maintenance over time.",
                                "Sound alone cannot distinguish bearings, mounts, airflow, water, debris, ice, piping, or another source. Avoid a confident remote diagnosis from one adjective."),
                        section("observe", "Collect safe observations before calling",
                                "Record when the sound began, whether it follows rain or freezing weather, where it is loudest, whether vibration is visible, and what the warning device shows compared with its normal mark.",
                                "Photograph the label and indicator without opening electrical boxes or disconnecting pipes. The installer can use the model, age, warranty, and symptom history to plan service."),
                        section("operation", "Do not switch the fan off as a routine experiment",
                                "EPA's reduction guide says fan-powered systems should run continuously. Repeatedly unplugging a system changes its operation and can leave the home without active control.",
                                "If there is an immediate electrical, structural, or water safety concern, use appropriate emergency judgment and contact a qualified service provider. This guide does not override electrical safety."),
                        section("verify", "Noise repair still needs a radon measurement",
                                "A quieter system is not automatically an effective system. After relevant repairs, confirm indoor performance with a documented test and maintain EPA's continuing retest schedule.",
                                "Keep service invoices, fan model, dates, warning-device observations, and the new test result together so later changes have a baseline.")),
                List.of("Noise change and start date recorded", "Warning device compared with baseline", "Fan model and system age found", "No electrical or pipe disassembly attempted", "Installer or qualified mitigator contacted", "Post-service radon test planned"),
                List.of(
                        faq("Is a humming radon fan normal?", "A steady operating sound can be normal, but a new or worsening hum needs system-specific inspection. Compare the indicator with its baseline."),
                        faq("Why is my radon pipe gurgling?", "Water or airflow may be involved, but sound alone cannot establish the cause. Record when it occurs and have the system inspected."),
                        faq("Can I turn off a noisy radon fan?", "EPA says fan-powered systems should run continuously. Contact the installer for service rather than using shutoff as a routine fix.")),
                List.of(EPA_MAINTENANCE, EPA_REDUCTION));
    }

    private static TestProtocolGuide maintenance() {
        return guide(
                "radon-mitigation-system-maintenance", "Radon Mitigation System Maintenance Checklist",
                "Radon Mitigation System Maintenance: Owner Checklist", "Use a simple owner checklist for the warning device, fan, visible pipe, labels, service records, and recurring radon retesting.",
                "Owner maintenance", "System maintenance",
                "Check the warning device regularly, keep the fan running, preserve the system label and service record, investigate visible or audible changes, and retest indoor radon at least every two years. Maintenance cannot be replaced by listening to the fan.",
                List.of(
                        section("regular", "Make the warning-device check routine",
                                "EPA advises looking at the system warning device regularly. Compare it with the installer's normal mark or instructions and record a changed, flat, damaged, or alarm condition.",
                                "A quick recurring reminder is more dependable than waiting for a noise. Place the schedule with other home maintenance without covering or altering the indicator."),
                        section("visible", "Inspect only what can be checked safely",
                                "Look for visible damage, disconnected or cracked accessible piping, missing labels, unusual vibration, new noise, or changes around the system. Preserve photographs and dates for the installer.",
                                "Do not open electrical equipment, alter fan sizing, cut piping, or change foundation penetrations. Those are contractor-level tasks with building and electrical implications."),
                        section("records", "Keep one system history",
                                "Store the installation contract, diagnostic notes, fan model, warranty, baseline manometer mark, pre- and post-mitigation tests, repairs, and future test reports together.",
                                "A complete record helps a new owner or service professional understand whether a change is normal, covered by warranty, or connected to earlier work."),
                        section("retest", "Measure the air on a schedule",
                                "EPA says it is a good idea to retest a mitigated home at least every two years. Retest after relevant repairs, major renovations, or other changes that can affect system or building performance.",
                                "The mechanical indicator and indoor radon test are complementary. One shows system pressure or alarm status; the other measures radon during a defined period.")),
                List.of("Regular warning-device reminder set", "Fan left running continuously", "Visible changes documented", "Installation and warranty records stored", "Unsafe DIY system changes avoided", "Two-year indoor retest scheduled"),
                List.of(
                        faq("Do radon mitigation systems need maintenance?", "Yes. EPA compares them with furnaces or chimneys and advises regular warning-device checks plus recurring indoor retesting."),
                        faq("How often should I check the manometer?", "EPA says regularly but does not set one universal household interval on the cited page. Follow the installer documentation and use a recurring reminder."),
                        faq("Is fan noise enough to know the system works?", "No. Check the warning device and verify indoor performance with a radon test.")),
                List.of(EPA_MAINTENANCE, EPA_REDUCTION));
    }

    private static TestProtocolGuide fanLife() {
        return guide(
                "how-long-do-radon-fans-last", "How Long Do Radon Fans Last?",
                "How Long Do Radon Fans Last? EPA Service-Life Guide", "Understand EPA's five-years-or-more statement, warranty records, failure signals, replacement planning, and post-service retesting.",
                "Fan service life", "System maintenance",
                "EPA says radon fans may last five years or more and notes that manufacturer warranties tend not to exceed five years. Age alone does not prove failure: track the warning device, noise, vibration, warranty, service history, and indoor retest results.",
                List.of(
                        section("range", "Five years is a planning point, not an expiration date",
                                "EPA's current maintenance page says fans may last for five years or more. It does not promise a universal maximum or require automatic replacement on one anniversary.",
                                "Installation conditions, fan model, system design, climate, and operation differ. Use the manufacturer's documentation and actual system indicators for the specific unit."),
                        section("records", "Find the model, install date, and warranty",
                                "The system label, invoice, fan housing label, or installer record may identify the model and installation date. Preserve that information before weather and ownership changes erase it.",
                                "Check warranty terms before authorizing service. Do not assume a fan, labor, shipping, or diagnostic visit is covered merely because the system is recent."),
                        section("signals", "Watch for operating changes",
                                "A warning-device alarm, flat or changed manometer, silence, new noise, strong vibration, or an indoor radon increase can justify service review. None of these symptoms alone identifies the exact failed component.",
                                "Keep the fan running unless qualified guidance or an immediate safety issue requires otherwise. Do not open electrical equipment or substitute a different fan size yourself."),
                        section("after", "Verify the system after fan service",
                                "Record the replacement or repair date, model, warranty, and new warning-device baseline. A functioning replacement still needs an indoor measurement to verify radon control.",
                                "Resume the continuing maintenance and retest schedule after service. The new fan does not make earlier records irrelevant; together they show the system history.")),
                List.of("Fan model identified", "Installation date estimated or confirmed", "Warranty terms checked", "Warning device compared with baseline", "Qualified service obtained for changes", "Post-service radon test documented"),
                List.of(
                        faq("Should I replace a radon fan after five years?", "Not solely because five years passed. EPA says fans may last five years or more. Use system condition, manufacturer guidance, and qualified inspection."),
                        faq("How do I know if a radon fan failed?", "Check the warning device and changes in sound or vibration, then contact the installer. An indoor test confirms radon performance."),
                        faq("Can I replace a radon fan myself?", "Fan selection and electrical work are system-specific and may be regulated. Use a qualified mitigator or appropriately licensed professional.")),
                List.of(EPA_MAINTENANCE, EPA_REDUCTION));
    }

    private static TestProtocolGuide guide(
            String slug, String title, String seoTitle, String description, String eyebrow,
            String category, String directAnswer, List<TestProtocolGuide.Section> sections, List<String> checklist,
            List<TestProtocolGuide.Faq> faqs, List<TestProtocolGuide.Source> sources) {
        return new TestProtocolGuide(slug, title, seoTitle + " | RadonVerdict", description, eyebrow,
                category, directAnswer, sections, checklist, faqs, sources, related(slug));
    }

    private static TestProtocolGuide.Section section(String id, String heading, String... paragraphs) {
        return new TestProtocolGuide.Section(id, heading, List.of(paragraphs), List.of());
    }

    private static TestProtocolGuide.Faq faq(String question, String answer) {
        return new TestProtocolGuide.Faq(question, answer);
    }

    private static List<TestProtocolGuide.Related> related(String current) {
        List<TestProtocolGuide.Related> testing = List.of(
                new TestProtocolGuide.Related("Where to place the device", "/guides/where-to-place-radon-test"),
                new TestProtocolGuide.Related("Short-term vs. long-term", "/guides/short-term-vs-long-term-radon-test"),
                new TestProtocolGuide.Related("Closed-house conditions", "/guides/radon-closed-house-conditions"),
                new TestProtocolGuide.Related("Can windows stay open?", "/guides/can-you-open-windows-during-radon-test"),
                new TestProtocolGuide.Related("Test during rain or storms", "/guides/radon-test-during-rain-or-storm"),
                new TestProtocolGuide.Related("Charcoal vs. digital", "/guides/charcoal-vs-digital-radon-test"),
                new TestProtocolGuide.Related("Mail a test kit", "/guides/how-to-mail-radon-test-kit"),
                new TestProtocolGuide.Related("Testing in an apartment", "/guides/radon-testing-in-apartments"),
                new TestProtocolGuide.Related("Check test validity", "/guides/is-my-radon-test-valid"),
                new TestProtocolGuide.Related("When to retest", "/guides/when-to-retest-for-radon"));
        List<TestProtocolGuide.Related> maintenance = List.of(
                new TestProtocolGuide.Related("Read the manometer", "/guides/radon-manometer-reading"),
                new TestProtocolGuide.Related("Triage fan noise", "/guides/radon-fan-noise"),
                new TestProtocolGuide.Related("System maintenance checklist", "/guides/radon-mitigation-system-maintenance"),
                new TestProtocolGuide.Related("How long fans last", "/guides/how-long-do-radon-fans-last"),
                new TestProtocolGuide.Related("Test after mitigation", "/guides/radon-test-after-mitigation"),
                new TestProtocolGuide.Related("When to retest", "/guides/when-to-retest-for-radon"));
        return (MAINTENANCE_SLUGS.contains(current) ? maintenance : testing).stream()
                .filter(link -> !link.url().endsWith(current)).limit(6).toList();
    }
}
