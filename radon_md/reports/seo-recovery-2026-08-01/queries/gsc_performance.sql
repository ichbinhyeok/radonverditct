-- Reproducible weekly aggregation of the reviewed Google Search Console
-- date-level export for sc-domain:radonverdict.com, 2026-05-01..2026-07-29.
-- The VALUES rows are the bounded snapshot embedded in artifact.json.
WITH phase_performance(period_order, period, clicks, impressions, position) AS (
  VALUES
    (1, 'May 1-7', 11, 620, 9.35),
    (2, 'May 8-Jun 4', 0, 273, 40.20),
    (3, 'Jun 5-Jul 2', 1, 103, 44.86),
    (4, 'Jul 3-29', 0, 232, 42.83)
)
SELECT period, clicks, impressions, position
FROM phase_performance
ORDER BY period_order;
