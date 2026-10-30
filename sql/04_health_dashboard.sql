-- Step 4: View all assets ordered by operational priority.
-- READ ONLY
SELECT
    asset_tag,
    backup_age_hours,
    apply_lag_minutes,
    sample_age_minutes,
    risk_status,
    priority_rank
FROM ace26_dr_health_p7
ORDER BY priority_rank, asset_tag;
