# Source report — radon test protocol rule engine

Audience: RadonVerdict product owner and implementers  
Date: 2026-09-05  
Decision: Which official, publicly verifiable rules can safely drive the first procedural assessment engine?

## Direct answer

Use a deliberately narrow federal rule set: CDC duration definitions and general placement, EPA Citizen's Guide placement/interference guidance, and EPA's 2024 transaction checklist only when the user selects a home purchase or sale. Keep device and state instructions superior to the planner. Do not encode inaccessible professional-standard details or diagnose a property's risk from the procedure record.

## Evidence reconciliation

CDC defines short-term kits as 2–90 days and long-term kits as more than 90 days. CDC also directs users to follow kit instructions and recommends a qualified tester for purchase/sale contexts. EPA's Citizen's Guide supplies general placement examples and exclusions. EPA's Home Buyer's and Seller's Guide explicitly says its transaction guidance differs from other EPA publications, so its 48-hour and closed-house checklist must not be silently generalized to every context.

The public EPA standards page points to current ANSI/AARST standards, but the exact operative text needed for deterministic implementation is not fully visible on that page. Those details remain outside the executable catalog.

## Claim-to-source ledger

- Duration definitions and general home placement — “Testing for Radon in Your Home,” CDC, 2024-02-02, https://www.cdc.gov/radon/testing/index.html, accessed 2026-09-05.
- Regularly used rooms, lowest lived-in level, kitchen/bathroom exclusions, disturbance — “A Citizen's Guide to Radon,” U.S. EPA, December 2016, https://www.epa.gov/sites/default/files/2016-12/documents/2016_a_citizens_guide_to_radon.pdf, accessed 2026-09-05.
- Transaction-specific 48-hour minimum, 12-hour preconditioning for 2–4 day tests, closed-house definition, interference and tester guidance — “Home Buyer's and Seller's Guide to Radon,” U.S. EPA, March 2024 revision, https://www.epa.gov/sites/default/files/2015-05/documents/hmbuygud.pdf, accessed 2026-09-05.
- Free and discounted kits may be available through local or state programs — “How do I get a radon test kit? Are they free?”, U.S. EPA, updated 2026-08-06, https://www.epa.gov/radon/how-do-i-get-radon-test-kit-are-they-free, accessed 2026-09-05.
- Current professional standards exist but detailed provisions were not treated as verified — “Radon Standards of Practice,” U.S. EPA, https://www.epa.gov/radon/radon-standards-practice, accessed 2026-09-05.

## Limitations

This is a federal baseline, not a state-law matrix or certification system. Date/time duration is derived from user-entered local timestamps. The result remains an advisory procedural consistency check.

## Search stop condition

Research stopped after the core executable claims had direct CDC/EPA support, the general-versus-transaction scope conflict was resolved, and the remaining gap was a separate state-law/professional-standard layer rather than a missing fact needed for this release.
