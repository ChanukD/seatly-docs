# EXP-001: Which seat-locking strategy gives zero oversells with the best p99?

- **Phase:** 2
- **Status:** Planned
- **Related ADR:** [ADR-0002](../adr/0002-seat-locking-strategy.md)
- **Date run:** —
- **Commit:** —

## Hypothesis

> Under high contention (1,000 users for 100 seats), the **conditional update** will have the lowest
> p99 and zero oversells. **Optimistic locking** will have the most failed attempts and retries, and
> the **Redis lock** will add latency without improving correctness.

## Success criteria

| Metric | Target |
|---|---|
| Oversells (seats in more than one active hold or order) | **0** for every variant (hard requirement) |
| `POST /holds` p99 | < 200 ms |
| Successful holds / s | Higher is better |
| Retries or conflicts per successful hold | Report it |
| Postgres CPU, lock waits, deadlocks | Report them |

## Setup

- Environment: local Docker Compose; booking-service with 2 replicas; Postgres 16; Redis 7
- Load: `load-tests/exp-001-seat-contention.js` (k6), 1,000 VUs, each tries a random 1–4 seats from
  the same 100-seat event, 60 s ramp, 3 runs per variant
- Variants (feature flag `booking.locking-strategy`):
    - A: `CONDITIONAL_UPDATE`
    - B: `PESSIMISTIC` (`SELECT … FOR UPDATE`, seat ids sorted to avoid deadlocks)
    - C: `OPTIMISTIC` (`@Version`, max 3 retries with jitter)
    - D: `REDIS_LOCK` (`SET NX PX 10000` per seat + DB check)
- Oversell check after each run:

```sql
SELECT event_id, seat_id, count(*)
FROM booking.holds h, unnest(h.seat_ids) AS seat_id
WHERE h.status IN ('ACTIVE', 'CONVERTED')
GROUP BY event_id, seat_id
HAVING count(*) > 1;
```

- Grafana: "Seatly / booking" dashboard, panels for hold latency, 409 rate, DB lock waits

## Results

| Variant | Oversells | p99 (ms) | Holds/s | Conflicts per success | Deadlocks |
|---|---|---|---|---|---|
| A Conditional update | | | | | |
| B Pessimistic | | | | | |
| C Optimistic | | | | | |
| D Redis lock | | | | | |

## Analysis

—

## Conclusion

—

## Next questions

- How do the results change with virtual threads vs a platform-thread pool?
- How do the results change when 4-seat holds are the majority?
