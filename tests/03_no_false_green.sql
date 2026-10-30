-- Guardrail: failed backups and stale/missing telemetry cannot imply healthy.
-- READ ONLY
SELECT asset_tag, risk_status,
  CASE
    WHEN asset_tag='DEMO_A' AND risk_status='HEALTHY'
         AND backup_age_hours > 1.5 THEN 'PASS'
    WHEN asset_tag='DEMO_E' AND risk_status='NO_SUCCESSFUL_BACKUP' THEN 'PASS'
    WHEN asset_tag='DEMO_F' AND risk_status='NO_REPLICATION_SAMPLE' THEN 'PASS'
    WHEN asset_tag='DEMO_G' AND risk_status='STALE_METRICS' THEN 'PASS'
    ELSE 'FAIL'
  END AS guardrail_test
FROM ace26_dr_health_p7
WHERE asset_tag IN ('DEMO_A','DEMO_E','DEMO_F','DEMO_G')
ORDER BY asset_tag;
