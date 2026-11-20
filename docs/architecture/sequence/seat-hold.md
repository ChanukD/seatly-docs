# Flow – Seat hold

All-or-nothing seat hold with a 10-minute TTL. Locking strategy is decided by
[ADR-0002](../../adr/0002-seat-locking-strategy.md) and measured in
[EXP-001](../../experiments/EXP-001-seat-locking.md).

```mermaid
sequenceDiagram
    autonumber
    actor C as Customer
    participant GW as Gateway
    participant B as booking-service
    participant DB as Postgres (booking schema)
    participant K as Kafka (via outbox)

    C->>GW: POST /holds {eventId, seatIds} + Idempotency-Key
    GW->>B: forward (JWT checked, rate limited)
    B->>DB: seen this Idempotency-Key?
    alt key already processed
        DB-->>B: stored response
        B-->>C: 201 (same holdId as before)
    else new request
        B->>DB: BEGIN
        B->>DB: UPDATE seat_inventory SET status='HELD', hold_id=?, version=version+1<br/>WHERE event_id=? AND seat_id IN (...) AND status='AVAILABLE'
        alt rows changed < seats requested
            B->>DB: ROLLBACK
            B-->>C: 409 Conflict (Problem Details)
        else all seats held
            B->>DB: INSERT holds (expires_at = now + 10 min)
            B->>DB: INSERT outbox (seat.held)
            B->>DB: COMMIT
            B-->>C: 201 {holdId, expiresAt}
            DB-->>K: outbox relay publishes seat.held
        end
    end

    Note over B,DB: Expiry job (ShedLock) or Redis key expiry releases<br/>HELD seats after 10 min and writes seat.released
```

## Invariants

- No partial holds: the number of changed rows must equal the number of seats requested.
- `PK (event_id, seat_id)` and the `status='AVAILABLE'` condition make an oversell impossible at the
  database level, whatever the application does.
- The outbox row commits with the state change, so an event is never lost or published for a
  rolled-back change.
