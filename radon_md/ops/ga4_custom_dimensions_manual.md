# GA4 Custom Dimensions Manual

Property:
- `525547689`

Why this is still manual:
- Google blocked the OAuth route for `analytics.edit` on the default client.
- The in-app browser automation path also failed in this desktop session.
- Result: I could not safely complete GA Admin creation from here.

Minimal manual path:
1. Open GA4 for property `525547689`.
2. Go to `Admin`.
3. Open `Custom definitions`.
4. Click `Create custom dimensions`.
5. Add every row from [ga4_custom_dimensions.csv](C:/Development/Owner/radonVerdict/radon_md/ops/ga4_custom_dimensions.csv).

Field mapping in the GA UI:
- Dimension name: use `display_name`
- Scope: use `EVENT` for every row
- Description: use `description`
- Event parameter: use `parameter_name`

Priority order if you do not want to do all of them at once:
1. `page_type`
2. `county`
3. `intent`
4. `result_band`
5. `cta_id`
6. `offer_type`
7. `placement_group`
8. `journey_stage`

After creation:
- Wait for GA4 to surface them in metadata and Explore.
- Then re-check with the existing analytics metadata query.
