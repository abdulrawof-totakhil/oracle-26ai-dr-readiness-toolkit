-- Step 10: Compact PASS screenshot for reproducibility.
-- READ ONLY
SELECT
    COUNT(*) AS assets,
    SUM(CASE WHEN risk_status = 'HEALTHY' THEN 1 ELSE 0 END) AS healthy,
    SUM(CASE WHEN risk_status <> 'HEALTHY' THEN 1 ELSE 0 END) AS at_risk,
    COUNT(DISTINCT risk_status) AS categories,
    CASE WHEN COUNT(*) = 7
      AND COUNT(DISTINCT risk_status) = 7
      AND SUM(CASE WHEN risk_status = 'HEALTHY' THEN 1 ELSE 0 END) = 1
      AND SUM(CASE WHEN risk_status <> 'HEALTHY' THEN 1 ELSE 0 END) = 6
    THEN 'PASS' ELSE 'FAIL' END AS test_result
FROM ace26_dr_health_p7;
