# Reproducibility and contribution integrity

1. Use a test-only Oracle FreeSQL 26ai schema.
2. Run `sql/01_create_tables.sql` then `sql/02_seed_synthetic_data.sql` once.
3. Run `sql/03_create_health_view.sql` and all read-only reports.
4. Capture your own results, names and dates; do not substitute screenshots from another session.
5. Run `tests/01_expected_statuses.sql` soon after seeding for seven direct per-asset checks.
6. Commit only sanitized synthetic data and screenshots.

**Why statuses may change:** The view computes ages against `LOCALTIMESTAMP` on each read.
An old 5-minute sample can exceed a 30-minute example threshold after time passes, so
the expected all-seven-status assertions are intentionally time-dependent. A passing
final priority consistency check does not guarantee that each expected category remains.

The GitHub Actions workflow runs an offline Python fixture checker, **not Oracle SQL**.
It must not be described as a connected Oracle DB or production DR test.
