-- Step 3: Policy-aware synthetic backup/DR readiness assessment.
-- The view does not connect to RMAN or Oracle Data Guard.
-- Using latest *successful* backup prevents failed attempts hiding stale backups.
-- Using latest samples with an age limit prevents stale data being shown as healthy.

CREATE OR REPLACE VIEW ace26_dr_health_p7 AS
WITH ranked_successful_backups AS (
    SELECT
        asset_id,
        backup_end_time,
        ROW_NUMBER() OVER (
            PARTITION BY asset_id
            ORDER BY backup_end_time DESC, backup_id DESC
        ) AS rn
    FROM ace26_dr_backups_p7
    WHERE backup_status = 'SUCCESS'
),
ranked_apply_samples AS (
    SELECT
        asset_id,
        sample_time,
        apply_lag_minutes,
        transport_lag_minutes,
        ROW_NUMBER() OVER (
            PARTITION BY asset_id
            ORDER BY sample_time DESC, sample_id DESC
        ) AS rn
    FROM ace26_dr_apply_p7
),
metrics AS (
    SELECT
        a.asset_id,
        a.asset_tag,
        a.backup_limit_hours,
        a.apply_limit_minutes,
        a.sample_limit_minutes,
        b.backup_end_time,
        r.sample_time,
        r.apply_lag_minutes,
        r.transport_lag_minutes,
        ROUND(
            (CAST(LOCALTIMESTAMP AS DATE) - CAST(b.backup_end_time AS DATE)) * 24,
            2
        ) AS backup_age_hours,
        ROUND(
            (CAST(LOCALTIMESTAMP AS DATE) - CAST(r.sample_time AS DATE)) * 1440,
            2
        ) AS sample_age_minutes
    FROM ace26_dr_assets_p7 a
    LEFT JOIN ranked_successful_backups b
        ON a.asset_id = b.asset_id AND b.rn = 1
    LEFT JOIN ranked_apply_samples r
        ON a.asset_id = r.asset_id AND r.rn = 1
)
SELECT
    m.asset_id,
    m.asset_tag,
    m.backup_end_time,
    m.sample_time,
    m.backup_age_hours,
    m.apply_lag_minutes,
    m.transport_lag_minutes,
    m.sample_age_minutes,
    m.backup_limit_hours,
    m.apply_limit_minutes,
    m.sample_limit_minutes,
    CASE
        WHEN m.backup_end_time IS NULL THEN 'NO_SUCCESSFUL_BACKUP'
        WHEN m.sample_time IS NULL THEN 'NO_REPLICATION_SAMPLE'
        WHEN m.sample_age_minutes > m.sample_limit_minutes THEN 'STALE_METRICS'
        WHEN m.backup_age_hours > m.backup_limit_hours
             AND m.apply_lag_minutes > m.apply_limit_minutes
             THEN 'MULTIPLE_BREACHES'
        WHEN m.backup_age_hours > m.backup_limit_hours THEN 'BACKUP_STALE'
        WHEN m.apply_lag_minutes > m.apply_limit_minutes THEN 'APPLY_LAG_BREACH'
        ELSE 'HEALTHY'
    END AS risk_status,
    CASE
        WHEN m.backup_end_time IS NULL THEN 1
        WHEN m.sample_time IS NULL THEN 1
        WHEN m.sample_age_minutes > m.sample_limit_minutes THEN 1
        WHEN m.backup_age_hours > m.backup_limit_hours
             AND m.apply_lag_minutes > m.apply_limit_minutes THEN 1
        WHEN m.backup_age_hours > m.backup_limit_hours THEN 2
        WHEN m.apply_lag_minutes > m.apply_limit_minutes THEN 2
        ELSE 3
    END AS priority_rank
FROM metrics m;
