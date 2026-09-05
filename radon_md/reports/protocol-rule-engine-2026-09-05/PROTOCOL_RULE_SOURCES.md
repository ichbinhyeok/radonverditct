# Radon test protocol rule sources

Reviewed: 2026-09-05  
Scope: United States residential radon test procedure checks

The planner checks whether a user's recorded setup conflicts with a small set of verifiable public rules. It does not certify a test, interpret a property as safe or unsafe, or replace device, laboratory, state, or professional requirements.

## Rules included

- Short-term kits are treated as 2–90 day devices; a completed short-term record below 48 hours is flagged for device-instruction review and possible retesting. [CDC home testing guidance](https://www.cdc.gov/radon/testing/index.html)
- Long-term kits must run for more than 90 days; 90 days or less is flagged. [CDC home testing guidance](https://www.cdc.gov/radon/testing/index.html)
- General placement checks favor the lowest regularly used level and a regularly occupied room, and flag kitchens, bathrooms, storage areas, disturbance, or unconfirmed device instructions. [CDC home testing guidance](https://www.cdc.gov/radon/testing/index.html), [EPA Citizen's Guide](https://www.epa.gov/sites/default/files/2016-12/documents/2016_a_citizens_guide_to_radon.pdf)
- Closed-house findings are limited to short-term real-estate tests. EPA's transaction checklist requires at least 12 hours of closed-house conditions before a 2–4 day test and throughout the test; the planner asks only whether the condition was followed, so it flags uncertainty without pretending to verify the full protocol. [EPA Home Buyer's and Seller's Guide](https://www.epa.gov/sites/default/files/2015-05/documents/hmbuygud.pdf)
- A real-estate record recommends checking qualified-tester and state requirements. It does not claim that every state has the same rule. [CDC home testing guidance](https://www.cdc.gov/radon/testing/index.html), [EPA Home Buyer's and Seller's Guide](https://www.epa.gov/sites/default/files/2015-05/documents/hmbuygud.pdf)

## Deliberate limits

- No radon-result diagnosis is made by this rule set.
- No state-specific legal requirement is inferred from federal guidance.
- Paid ANSI/AARST standard details are not encoded unless the exact provision is publicly verifiable.
- Device instructions take precedence because exposure time and handling can differ by product.

The executable catalog is [`radon-test-protocol-rules.json`](../../../src/main/resources/static/data/radon-test-protocol-rules.json).
