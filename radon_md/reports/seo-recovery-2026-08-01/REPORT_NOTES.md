# Report build notes

- Source of truth: Google Search Console Search Analytics API, property `sc-domain:radonverdict.com`.
- The no-dimension, property-level aggregate controls the headline. Page-grouped impressions sum higher because multiple result URLs can be counted separately; Google also privacy-suppresses some query rows.
- The canonical portable reader repeatedly failed its horizontal-overflow check when a native weekly chart or query table was present. Both were removed after targeted corrections so the final report could use the verified reader rather than a bespoke chart implementation.
- Exact weekly and query rows remain in `artifact.json` and the reproducible SQL snapshots under `queries/`.
