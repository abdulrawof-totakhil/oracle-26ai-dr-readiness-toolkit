-- Validate fixture counts and coverage; expected 7 assets, 9 backups, 7 samples.
-- READ ONLY
SELECT
 (SELECT COUNT(*) FROM ace26_dr_assets_p7) AS asset_rows,
 (SELECT COUNT(*) FROM ace26_dr_backups_p7) AS backup_rows,
 (SELECT COUNT(*) FROM ace26_dr_apply_p7) AS sample_rows,
 CASE WHEN (SELECT COUNT(*) FROM ace26_dr_assets_p7)=7
   AND (SELECT COUNT(*) FROM ace26_dr_backups_p7)=9
   AND (SELECT COUNT(*) FROM ace26_dr_apply_p7)=7
 THEN 'PASS' ELSE 'FAIL' END AS test_result
FROM dual;
