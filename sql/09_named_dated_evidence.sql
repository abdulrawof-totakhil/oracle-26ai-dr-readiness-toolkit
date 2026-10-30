-- Project 7, Step 9: final named/date-stamped readiness verification
-- READ ONLY. Validates classification-to-priority consistency and coverage,
-- but does not replace independent per-asset expected-status assertions.
WITH validation AS (
    SELECT COUNT(*) AS total_assets,
           COUNT(DISTINCT asset_tag) AS unique_assets,
           SUM(CASE WHEN risk_status <> 'HEALTHY' THEN 1 ELSE 0 END) AS alert_assets,
           SUM(CASE
              WHEN risk_status IS NULL OR priority_rank IS NULL
                OR (risk_status = 'HEALTHY' AND priority_rank <> 3)
                OR (risk_status IN ('BACKUP_STALE','APPLY_LAG_BREACH') AND priority_rank <> 2)
                OR (risk_status IN ('NO_SUCCESSFUL_BACKUP','NO_REPLICATION_SAMPLE',
                   'STALE_METRICS','MULTIPLE_BREACHES') AND priority_rank <> 1)
                OR risk_status NOT IN ('HEALTHY','BACKUP_STALE','APPLY_LAG_BREACH',
                   'NO_SUCCESSFUL_BACKUP','NO_REPLICATION_SAMPLE',
                   'STALE_METRICS','MULTIPLE_BREACHES')
                THEN 1 ELSE 0 END) AS validation_errors
    FROM ace26_dr_health_p7
)
SELECT 'Abdulrawof Totakhil' AS contributor,
       TO_CHAR(CURRENT_TIMESTAMP, 'YYYY-MM-DD HH24:MI:SS TZH:TZM') AS execution_date,
       total_assets, alert_assets, validation_errors,
       CASE WHEN total_assets = 7 AND unique_assets = 7
                  AND validation_errors = 0
            THEN 'PASS' ELSE 'FAIL' END AS test_result
FROM validation;
