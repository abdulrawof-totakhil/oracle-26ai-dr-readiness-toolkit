# Oracle AI Database 26ai — Backup and DR Readiness SQL Toolkit

**Original Oracle ACE GitHub Repository candidate | Executed Oracle FreeSQL demonstration | 30 October 2026**

This open-source project demonstrates a **synthetic** Oracle SQL workflow for monitoring
backup freshness, simulated standby apply lag, and monitoring-sample freshness. Seven
fictional assets exercise seven distinct readiness classifications. The project generates
an ordered operational action queue, aggregated risk summary, SQL/JSON readiness report,
and verification tests. It is educational software, **not** a live RMAN/Data Guard monitor
or a production DR certification tool.

## Verified evidence at the time of execution

The contributor executed the schema, seed, view, risk summary, action queue, JSON report,
and final validation in Oracle FreeSQL on **2026-10-30**. Original execution screenshots
are included in `evidence/screenshots/`.

| Check | Observed |
|---|---|
| Lab table creation | Three tables shown in navigator; final create-table success shown |
| Seed dataset | 7 demo assets, 9 backup records, 7 monitoring samples; PASS |
| Readiness view | `ACE26_DR_HEALTH_P7` created |
| Health dashboard | 7 expected categories with 1 healthy and 6 requiring attention |
| Risk summary | 7 categories (one asset in each) |
| Operator action queue | 7 rows ordered by priority |
| JSON report | SQL returned a generated JSON array; full value horizontally clipped in screenshot |
| Final contributor/date validation | TOTAL_ASSETS=7; ALERT_ASSETS=6; VALIDATION_ERRORS=0; TEST_RESULT=PASS |

`TEST_RESULT=PASS` validates the **current classification and priority mapping**.
It is not proof of RMAN backup recoverability, standby availability, a tested restore,
or actual RPO/RTO.

## Architecture

```text
  ACE26_DR_ASSETS_P7 (7 demo assets)
     |            \
     |             +--> ACE26_DR_APPLY_P7 (7 sample rows)
     +--> ACE26_DR_BACKUPS_P7 (9 backup rows)
                  |
                  v
        ACE26_DR_HEALTH_P7
          |      |     |
        dashboard   risk summary   JSON export / action queue
```

- `ROW_NUMBER()` finds the newest *successful* backup and newest apply-monitoring sample.
- Thresholds vary per synthetic asset (example policies: 24 hours backup age, 15 minutes
  apply lag, 30 minutes sample freshness).
- Classification precedences: no successful backup, no replication sample, stale sample,
  simultaneous backup/apply breaches, isolated stale backup, isolated apply-lag breach,
  healthy.
- Priorities: 1 urgent attention, 2 investigation, 3 normal monitoring.

## Reproduce in Oracle FreeSQL 26ai

Open <https://freesql.com> and choose a **26ai** worksheet. Run SQL files in sequence:

1. `sql/01_create_tables.sql` — create 3 lab tables (**once only**).
2. `sql/02_seed_synthetic_data.sql` — insert synthetic records and commit (**once only**).
3. `sql/03_create_health_view.sql` — create or replace readiness view.
4. `sql/04_health_dashboard.sql` — inspect classifications.
5. `sql/05_risk_summary.sql` — group by risk and priority.
6. `sql/06_action_queue.sql` — produce suggested DBA action queue.
7. `sql/07_json_action_report.sql` — generate JSON for **all seven** assets.
8. `sql/09_named_dated_evidence.sql` — validate the live classification mapping.

Optional scripts for additional *unrecorded* checks are `sql/08_26ai_qualify_latest_backup.sql`,
`sql/10_compact_final_verification.sql`, and `tests/*.sql`.
These are included to improve reproducibility, but the supplied screenshots do **not** claim
those optional SQL tests were executed. `tests/offline_fixture_check.py` was executed
offline and is **not** an Oracle SQL engine.

## Reproducibility warning: metrics age

`sql/02_seed_synthetic_data.sql` uses `LOCALTIMESTAMP` so sample freshness changes
with elapsed time. The original seven classifications were verified shortly after seeding.
If you run the health query later, `DEMO_A` and other demo assets may become `STALE_METRICS`.
This is expected behavior. For repeatable testing, start in a fresh disposable schema
or intentionally reset **only your own synthetic lab** records with a documented timestamp.
Do not falsify original evidence to force the original statuses.

## Security, scope, and licensing

All names and amounts are fabricated. No production database identifiers, hostnames,
credentials, customer data, backup files, or privileged system views are involved.
Oracle SQL here operates only on synthetic example tables and views. The action queue
suggests diagnostics; it never changes a real infrastructure environment. The monitoring
threshold values are **lab examples**, not Oracle or financial-industry recommendations.

**Contributor:** Abdulrawof Totakhil · Oracle ACE Apprentice

**License:** MIT, see [`LICENSE`](LICENSE).

## Documentation

- [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md)
- [`docs/TEST_PLAN.md`](docs/TEST_PLAN.md)
- [`docs/RESULTS_LOG.md`](docs/RESULTS_LOG.md)
- [`docs/ACE_SUBMISSION.md`](docs/ACE_SUBMISSION.md)
- [`evidence/README.md`](evidence/README.md)
