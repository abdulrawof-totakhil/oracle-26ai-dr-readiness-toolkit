# Architecture and business rules

```
DEMO_ASSETS (7) ----< DEMO_BACKUPS (9)
      |
      +--------------< DEMO_APPLY_SAMPLES (7)
                         |
                         v
               Latest success/sample selection
                         |
                         v
                ACE26_DR_HEALTH_P7
                /      |       \
           dashboard  priority   JSON risk export
```

- Backups: select newest record with `backup_status = 'SUCCESS'` using
  `ROW_NUMBER` and deterministic tie-breaker by backup ID.
- Telemetry: select newest replication sample with deterministic tie-breaker;
  stale samples cannot be labeled healthy.
- Classification precedence: missing success -> missing sample -> stale sample
  -> both breaches -> stale backup -> apply lag breach -> healthy.
- Per-asset thresholds: backup freshness (24 h), apply lag (15 min), telemetry
  sample freshness (30 min); these are fictional demo policies, not Oracle
  recommendations or a production standard.
- Priority 1: missing backup/sample, stale sample, or multiple breaches;
  priority 2: isolated stale backup or apply lag breach; priority 3: healthy.
- The report is *not* a substitute for restore tests, Data Guard broker health,
  redo shipping diagnostics, or a tested DR plan.
