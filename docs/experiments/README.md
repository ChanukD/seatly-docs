# Experiments

Each experiment answers one question with numbers. Copy [template.md](template.md) and name it
`EXP-NNN-short-name.md`. Write the hypothesis and success criteria **before** running anything.

| ID | Question | Phase | Status |
|---|---|---|---|
| [EXP-001](EXP-001-seat-locking.md) | Which seat-locking strategy gives zero oversells with the best p99? | 2 | Planned |
| EXP-002 | Do circuit breaker + time limiter + retry keep payment p99 bounded with a failing gateway? | 3 | Not started |
| EXP-003 | How fast can Step Functions refund 5,000 orders, and where does it throttle? | 5 | Not started |
| EXP-004 | Does any seat stay held after payment-service dies mid-saga? | 6 | Not started |
| EXP-005 | Thundering herd on a hot event: jittered TTL vs request coalescing | 7 | Not started |
| EXP-006 | Stale reads from the read replica: how often, how stale, how to handle? | 7 | Not started |
| EXP-007 | 10k-user flash sale: waiting-room fairness, scaling delay, error-budget burn | 10 | Not started |
