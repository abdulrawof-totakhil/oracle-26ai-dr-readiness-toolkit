-- Independent expected-status assertions; expected seven PASS rows.
-- Run after 01, 02, 03; READ ONLY
WITH expected AS (
 SELECT 'DEMO_A' asset_tag, 'HEALTHY' expected_status FROM dual UNION ALL
 SELECT 'DEMO_B', 'BACKUP_STALE' FROM dual UNION ALL
 SELECT 'DEMO_C', 'APPLY_LAG_BREACH' FROM dual UNION ALL
 SELECT 'DEMO_D', 'MULTIPLE_BREACHES' FROM dual UNION ALL
 SELECT 'DEMO_E', 'NO_SUCCESSFUL_BACKUP' FROM dual UNION ALL
 SELECT 'DEMO_F', 'NO_REPLICATION_SAMPLE' FROM dual UNION ALL
 SELECT 'DEMO_G', 'STALE_METRICS' FROM dual
)
SELECT
    e.asset_tag,
    e.expected_status,
    NVL(h.risk_status, 'MISSING') AS actual_status,
    CASE WHEN e.expected_status = h.risk_status THEN 'PASS'
         ELSE 'FAIL' END AS test_result
FROM expected e
LEFT JOIN ace26_dr_health_p7 h ON h.asset_tag = e.asset_tag
ORDER BY e.asset_tag;
