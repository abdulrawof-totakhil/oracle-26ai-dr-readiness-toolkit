-- Project 7: Oracle AI Database 26ai DR Readiness Toolkit
-- Step 1: Create laboratory objects. Synthetic data only.
-- Run once in Oracle FreeSQL 26ai. No production DBA views are accessed.

CREATE TABLE ace26_dr_assets_p7 (
    asset_id NUMBER PRIMARY KEY,
    asset_tag VARCHAR2(25) NOT NULL UNIQUE,
    backup_limit_hours NUMBER(6,2) NOT NULL,
    apply_limit_minutes NUMBER(6,2) NOT NULL,
    sample_limit_minutes NUMBER(6,2) NOT NULL,
    CONSTRAINT ace26_dr_policy_p7_ck CHECK (
        backup_limit_hours > 0
        AND apply_limit_minutes > 0
        AND sample_limit_minutes > 0
    )
);

CREATE TABLE ace26_dr_backups_p7 (
    backup_id NUMBER PRIMARY KEY,
    asset_id NUMBER NOT NULL,
    backup_end_time TIMESTAMP NOT NULL,
    backup_status VARCHAR2(12) NOT NULL,
    CONSTRAINT ace26_dr_bk_asset_p7_fk FOREIGN KEY (asset_id)
        REFERENCES ace26_dr_assets_p7(asset_id),
    CONSTRAINT ace26_dr_bk_status_p7_ck CHECK (
        backup_status IN ('SUCCESS', 'FAILED')
    )
);

CREATE TABLE ace26_dr_apply_p7 (
    sample_id NUMBER PRIMARY KEY,
    asset_id NUMBER NOT NULL,
    sample_time TIMESTAMP NOT NULL,
    apply_lag_minutes NUMBER(7,2) NOT NULL,
    transport_lag_minutes NUMBER(7,2) NOT NULL,
    CONSTRAINT ace26_dr_ap_asset_p7_fk FOREIGN KEY (asset_id)
        REFERENCES ace26_dr_assets_p7(asset_id),
    CONSTRAINT ace26_dr_ap_lag_p7_ck CHECK (
        apply_lag_minutes >= 0 AND transport_lag_minutes >= 0
    )
);
