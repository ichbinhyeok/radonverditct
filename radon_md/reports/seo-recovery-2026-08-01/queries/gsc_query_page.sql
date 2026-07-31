-- Reviewed visible non-site query/page rows from the Google Search Console API.
-- Privacy-suppressed query rows are absent and page-level totals remain authoritative.
WITH query_opportunities(query, impressions, position, landing) AS (
  VALUES
    ('radon gas testing ulster county ny', 165, 54.72, '/radon-levels/new-york/ulster-county'),
    ('radon mitigation services ulster county ny', 29, 65.86, '/radon-levels/new-york/ulster-county'),
    ('radon levels in basement testing falls church va', 26, 59.62, '/radon-levels/virginia/falls-church-city'),
    ('radon levels in basement falls church va', 15, 37.47, '/radon-levels/virginia/falls-church-city'),
    ('schenectady county ny epa radon zone', 9, 3.11, '/radon-levels/new-york/schenectady-county'),
    ('los angeles commercial radon', 8, 89.88, '/radon-levels/california/los-angeles-county'),
    ('transylvania radon mitigation', 7, 22.71, '/radon-mitigation-cost/north-carolina/transylvania-county'),
    ('radon testing powhatan va', 6, 18.83, '/radon-levels/virginia/powhatan-county')
)
SELECT query, impressions, position, landing
FROM query_opportunities
ORDER BY impressions DESC, position ASC;
