-- Optional independent consistency control: category-priority validation
-- READ ONLY (classification may change as input timestamps age).
SELECT asset_tag, risk_status, priority_rank,
       CASE
           WHEN risk_status IN ('NO_SUCCESSFUL_BACKUP','NO_REPLICATION_SAMPLE',
                                'STALE_METRICS','MULTIPLE_BREACHES') AND priority_rank=1
                THEN 'PASS'
           WHEN risk_status IN ('BACKUP_STALE','APPLY_LAG_BREACH') AND priority_rank=2
                THEN 'PASS'
           WHEN risk_status='HEALTHY' AND priority_rank=3 THEN 'PASS'
           ELSE 'FAIL'
       END AS priority_mapping_test
FROM ace26_dr_health_p7
ORDER BY asset_tag;
