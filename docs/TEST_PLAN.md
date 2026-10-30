# Test plan and validation scope

## Executed Oracle FreeSQL checks (2026-10-30)

| Test | Observed |
|---|---|
| Tables created | 3 lab tables shown; final CREATE succeeded |
| Synthetic insert + commit | Committed |
| Data counts | 7 assets, 9 backups, 7 monitoring samples: PASS |
| View definition | Created successfully |
| Seven readiness classes | Correct labels shown for DEMO_A through DEMO_G |
| Aggregated risk summary | One asset per risk category |
| Action queue | 7 priority-sorted guidance rows |
| JSON readiness export | JSON result generated (UI horizontally truncated) |
| Contributor/date final check | 7 total, 6 alerting, 0 mapping errors: PASS |

## Additional tests included but not execution-verified in these screenshots

1. `tests/01_expected_statuses.sql`: 7 expected-versus-actual status assertions.
2. `tests/02_source_counts.sql`: independent seed row counts.
3. `tests/03_no_false_green.sql`: missing/failed data should not be called healthy.
4. `sql/08_26ai_qualify_latest_backup.sql`: 6 latest successful backups, QUALIFY.
5. `sql/10_compact_final_verification.sql`: stricter time-sensitive 7-class PASS.

Since the inputs use `LOCALTIMESTAMP`, the original expected statuses may drift as the
records age. For reliable repeatability, rerun the complete fixture in a fresh *disposable*
FreeSQL schema, then execute assertions shortly after seeding.

**Offline Python check** is only a model-level check and does not execute Oracle SQL.
