#!/usr/bin/env python3
"""Offline fixture semantics check; NOT execution of Oracle SQL.

This independent standard-library check confirms the intended synthetic categories
and demonstrates how rule ordering should handle missing and stale telemetry.
Only real FreeSQL output can validate the SQL implementation.
"""
fixtures = [
    ('DEMO_A',2,5,2),
    ('DEMO_B',30,3,2),
    ('DEMO_C',4,46,4),
    ('DEMO_D',40,61,2),
    ('DEMO_E',None,4,2),
    ('DEMO_F',1,None,None),
    ('DEMO_G',2,4,75),
]
expected = {
    'DEMO_A':'HEALTHY',
    'DEMO_B':'BACKUP_STALE',
    'DEMO_C':'APPLY_LAG_BREACH',
    'DEMO_D':'MULTIPLE_BREACHES',
    'DEMO_E':'NO_SUCCESSFUL_BACKUP',
    'DEMO_F':'NO_REPLICATION_SAMPLE',
    'DEMO_G':'STALE_METRICS',
}

def classify(backup_age, apply_lag, sample_age):
    if backup_age is None: return 'NO_SUCCESSFUL_BACKUP'
    if sample_age is None: return 'NO_REPLICATION_SAMPLE'
    if sample_age > 30: return 'STALE_METRICS'
    if backup_age > 24 and apply_lag > 15: return 'MULTIPLE_BREACHES'
    if backup_age > 24: return 'BACKUP_STALE'
    if apply_lag > 15: return 'APPLY_LAG_BREACH'
    return 'HEALTHY'

for tag,backup,lag,sample in fixtures:
    result = classify(backup,lag,sample)
    assert result == expected[tag], (tag,result,expected[tag])
assert len(fixtures) == 7
assert sum(classify(b,l,s)=='HEALTHY' for _,b,l,s in fixtures) == 1
print('OFFLINE FIXTURE PASS: 7 expected statuses, 1 healthy, 6 flagged')
