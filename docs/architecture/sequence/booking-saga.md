# Flow – Booking saga (choreography)

Starts from a confirmed hold. Choreography first, see [ADR-0004](../../adr/0004-saga-style.md).
Every step is idempotent (`processed_events` table), so Kafka redelivery is safe.

```mermaid
sequenceDiagram
    autonumber
    actor C as Customer
    participant O as order-service
    participant P as payment-service
    participant G as Mock gateway
    participant B as booking-service
    participant N as notification-service
    participant EB as EventBridge → ticket-pdf

    C->>O: POST /orders {holdId} + Idempotency-Key
    O->>O: insert order PENDING + outbox order.created (1 tx)
    O-->>C: 202 {orderId}
    O--)P: order.created

    P->>G: charge (time limiter 3 s, retry ×2 on 5xx/timeout, circuit breaker)
    alt payment ok
        G-->>P: approved
        P--)O: payment.succeeded
        O->>O: order CONFIRMED + outbox order.confirmed
        O--)B: order.confirmed
        B->>B: seats HELD → BOOKED, outbox seat.status-changed
        O--)N: order.confirmed → email
        O--)EB: order.confirmed → e-ticket PDF + QR
    else declined, timeout or circuit open
        G--xP: error / no answer
        P--)O: payment.failed
        O->>O: order CANCELLED + outbox order.cancelled
        O--)B: order.cancelled (compensation)
        B->>B: seats HELD → AVAILABLE, outbox seat.released
        O--)N: order.cancelled → email
    end
```

## Resilience settings (payment-service → gateway)

| Pattern | Setting | Why |
|---|---|---|
| Time limiter | 3 s | Customer is waiting; a slow gateway must not pin threads |
| Retry | 2 attempts, only 5xx and timeouts | 4xx (declined card) is a business answer, not a fault |
| Circuit breaker | 50% failures over 20 calls, 5 s open | Fail fast so compensation runs instead of queuing |
| Bulkhead | Separate pool for gateway calls | Gateway trouble must not starve other endpoints |

## Failure cases to test

- payment-service killed mid-saga → hold TTL still releases seats (Phase 6 experiment).
- Duplicate `payment.succeeded` delivery → order stays CONFIRMED once, one email.
- Gateway charges but the response is lost → payment idempotency key prevents a double charge on retry.
