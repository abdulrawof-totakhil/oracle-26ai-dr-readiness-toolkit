-- Project 7, Step 6: all seven categories grouped by priority
-- READ ONLY. Time-sensitive classification evaluated at query time.
SELECT risk_status, priority_rank, COUNT(*) AS total_assets
FROM ace26_dr_health_p7
GROUP BY risk_status, priority_rank
ORDER BY priority_rank, risk_status;
