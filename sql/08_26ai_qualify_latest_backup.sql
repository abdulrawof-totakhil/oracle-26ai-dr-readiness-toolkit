-- Step 8: Optional Oracle 26ai QUALIFY query (NOT yet execution-verified) with latest successful backups.
-- READ ONLY. Expected: 6 rows (DEMO_E has no successful backup).
SELECT
    asset_id,
    backup_id,
    backup_end_time,
    ROW_NUMBER() OVER (
        PARTITION BY asset_id
        ORDER BY backup_end_time DESC, backup_id DESC
    ) AS backup_rank
FROM ace26_dr_backups_p7
WHERE backup_status = 'SUCCESS'
QUALIFY backup_rank = 1
ORDER BY asset_id;
