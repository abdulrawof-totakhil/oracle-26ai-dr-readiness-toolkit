-- Project 7, Step 8: JSON readiness report for ALL seven demo assets
-- READ ONLY; matches captured FreeSQL execution (2026-10-30).
SELECT JSON_ARRAYAGG(
    JSON_OBJECT(
        'assetTag' VALUE asset_tag,
        'riskStatus' VALUE risk_status,
        'priority' VALUE priority_rank,
        'backupAgeHours' VALUE backup_age_hours,
        'applyLagMinutes' VALUE apply_lag_minutes,
        'transportLagMinutes' VALUE transport_lag_minutes,
        'sampleAgeMinutes' VALUE sample_age_minutes
    )
    ORDER BY priority_rank, asset_tag
    RETURNING CLOB
) AS dr_readiness_json
FROM ace26_dr_health_p7;
