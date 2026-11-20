# ADR-0004: Choreography saga first, orchestration later

- **Status:** Proposed
- **Date:** 2026-11-20
- **Deciders:** Chanuka
- **Related:** [Booking saga](../architecture/sequence/booking-saga.md)

## Context

Booking spans order, payment and booking services. 2PC across services is not an option. The
learning plan covers both saga styles.

## Options considered

1. **Choreography:** services react to each other's events. No central coordinator.
2. **Orchestration with Spring State Machine:** order-service drives the steps.
3. **Orchestration with Temporal:** durable workflow engine with built-in retries and timers.

## Decision

Proposed: **choreography** for Phase 6 (3 steps, easy to follow), then build the same flow with
**option 2 or 3** in Phase 11 and compare.

## Consequences

### Good

- Loose coupling; Kafka practice (ordering, redelivery, DLT).

### Bad / accepted trade-offs

- The flow is spread across services and hard to see. Mitigate with a `saga_step` column and one
  trace per order in Tempo.
- Adding steps later (e.g. fraud check) gets messy fast. That's the signal to switch.

## How we will know it was wrong

More than ~4 steps in the saga, or a debugging session where the trace isn't enough to explain an
order's state.
