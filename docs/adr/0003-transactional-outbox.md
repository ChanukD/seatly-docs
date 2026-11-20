# ADR-0003: Transactional outbox with a poller, Debezium later

- **Status:** Accepted
- **Date:** 2026-11-20
- **Deciders:** Chanuka

## Context

Services change their own state and publish a Kafka event. Writing to Postgres and Kafka separately
(dual write) loses or invents events when one side fails.

## Options considered

1. **Outbox + poller:** insert into `outbox` in the same transaction; a scheduled relay publishes and
   sets `published_at`.
2. **Outbox + Debezium CDC:** Debezium reads the WAL and publishes outbox rows.
3. **Kafka transactions only:** doesn't cover the DB write, so it doesn't solve the problem.

## Decision

Start with **option 1** (Phases 1–6). Move to **option 2** in Phase 11 and compare.

## Consequences

### Good

- No extra infrastructure; easy to debug with plain SQL.
- At-least-once delivery. Consumers dedupe with `processed_events`.

### Bad / accepted trade-offs

- Poll interval adds latency (expect 100–500 ms) and load on Postgres.
- Several relay replicas need coordination (ShedLock or `FOR UPDATE SKIP LOCKED`).
- Ordering per aggregate relies on a single relay per partition key range.

### Follow-ups

- [ ] Outbox cleanup job (delete published rows older than N days)
- [ ] Metric: outbox lag (oldest unpublished row age) with an alert

## How we will know it was wrong

Outbox lag p99 above 2 s under normal load, or relay load showing up in Postgres CPU.
