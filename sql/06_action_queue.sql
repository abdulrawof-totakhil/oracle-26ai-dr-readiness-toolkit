-- Project 7, Step 7: prioritized DR action queue
-- READ ONLY; suggestions are illustrative, not production diagnoses.
SELECT
    asset_tag, risk_status, priority_rank,
    CASE risk_status
        WHEN 'NO_SUCCESSFUL_BACKUP'
        THEN 'Investigate failed backups; validate RMAN backup and recovery readiness'
        WHEN 'NO_REPLICATION_SAMPLE'
        THEN 'Check monitoring connectivity and Data Guard collection jobs'
        WHEN 'MULTIPLE_BREACHES'
        THEN 'Investigate backup freshness and Data Guard apply lag'
        WHEN 'STALE_METRICS'
        THEN 'Restore monitoring collection and verify data freshness'
        WHEN 'BACKUP_STALE'
        THEN 'Review backup schedule and latest successful backup'
        WHEN 'APPLY_LAG_BREACH'
        THEN 'Investigate archive transport, apply process and network conditions'
        WHEN 'HEALTHY'
        THEN 'Continue routine monitoring'
        ELSE 'Manual investigation required'
    END AS recommended_action
FROM ace26_dr_health_p7
ORDER BY priority_rank, asset_tag;
