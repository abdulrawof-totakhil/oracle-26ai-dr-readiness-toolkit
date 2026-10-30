# Oracle FreeSQL execution record — Project 7

**Contributor:** Abdulrawof Totakhil
**Execution date shown in final FreeSQL result:** 2026-10-30
**Platform:** Oracle FreeSQL; worksheet selector displayed 26ai
**Data:** Fictional DEMO_A–DEMO_G assets; no production telemetry

| Evidence | Observed result | File |
|---|---|---|
| Schema creation | Three lab objects present; third CREATE TABLE succeeded | `../evidence/screenshots/01_create_tables.png` |
| Seed and COMMIT | COMMIT complete; dataset script executed | `../evidence/screenshots/02_seed_records_committed.png` |
| Source counts | ASSET_ROWS=7, BACKUP_ROWS=9, SAMPLE_ROWS=7, TEST_RESULT=PASS | `../evidence/screenshots/03_dataset_counts_PASS.png` |
| View creation | View `ACE26_DR_HEALTH_P7` created | `../evidence/screenshots/04_health_view_created.png` |
| Health dashboard | Seven expected demo classifications | `../evidence/screenshots/05_health_dashboard.png` |
| Risk summary | Seven risk groups (each one asset) | `../evidence/screenshots/06_risk_summary.png` |
| Action queue | Seven prioritized DBA guidance rows | `../evidence/screenshots/07_action_queue.png` |
| JSON readiness | JSON output returned, array shown in a horizontally truncated cell | `../evidence/screenshots/08_json_readiness_report.png` |
| Final validation | TOTAL_ASSETS=7; ALERT_ASSETS=6; VALIDATION_ERRORS=0; PASS | `../evidence/screenshots/09_final_named_dated_PASS.png` |

## Observed classifications

| Asset | Status | Priority |
|---|---|---:|
| DEMO_A | HEALTHY | 3 |
| DEMO_B | BACKUP_STALE | 2 |
| DEMO_C | APPLY_LAG_BREACH | 2 |
| DEMO_D | MULTIPLE_BREACHES | 1 |
| DEMO_E | NO_SUCCESSFUL_BACKUP | 1 |
| DEMO_F | NO_REPLICATION_SAMPLE | 1 |
| DEMO_G | STALE_METRICS | 1 |

## Validation limits

- The screenshots confirm executable SQL results as shown, not correctness of unseen or unrun scripts.
- `TEST_RESULT=PASS` confirms seven assets, seven unique asset tags, and category/priority mapping with no error in the final query. It **does not** run the separate `tests/01_expected_statuses.sql` assertions.
- The JSON screenshot shows the returned array beginning, but the full array was truncated by horizontal UI presentation; exact JSON length and all elements were not independently inspected.
- `QUALIFY` and separate SQL test suite are **available but not execution-verified** in this evidence package.
- The simulated metrics age continuously; future runs may show different health statuses.
