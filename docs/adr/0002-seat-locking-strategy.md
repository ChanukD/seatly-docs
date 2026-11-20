# ADR-0002: Seat locking strategy

- **Status:** Proposed (decide after [EXP-001](../experiments/EXP-001-seat-locking.md))
- **Date:** 2026-11-20
- **Deciders:** Chanuka
- **Related:** [Seat hold flow](../architecture/sequence/seat-hold.md)

## Context

Two users must never get the same seat. A flash sale means many users competing for few seats
(target test: 1,000 users for 100 seats). Correctness is the hard requirement: **zero oversells**.
After that, p99 latency and throughput decide.

## Options considered

1. **Conditional update (atomic `UPDATE … WHERE status='AVAILABLE'`)**: one statement. The DB row lock
   is held only for the update, and the row count tells whether it worked.
2. **Pessimistic lock (`SELECT … FOR UPDATE`)**: lock rows, check, update. Simple to reason about, but
   holds locks longer, and lock ordering matters for multi-seat holds (deadlock risk).
3. **Optimistic lock (`version` column, JPA `@Version`)**: read, then update with a version check;
   retry on conflict. Cheap when contention is low, but many retries under a flash sale.
4. **Redis lock (`SET NX PX`)**: lock outside the DB. Takes load off Postgres, but now two systems
   must agree, and lock expiry during a GC pause can still cause double booking without a DB check.

## Decision

Pending. Current default is **option 1**, with the DB constraint as the final safety net in all
cases. EXP-001 measures all four.

## Consequences

To fill in after EXP-001.

## How we will know it was wrong

Any oversell in the CI load test, or booking-service p99 above target at the Phase 10 flash-sale load.
