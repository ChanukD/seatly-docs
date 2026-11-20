# Event contracts (AsyncAPI 3.1)

All Kafka topics and payloads are defined in [`asyncapi.yaml`](asyncapi.yaml). CI validates it.

## Conventions

- **Envelope:** every message carries `eventId` (UUID, used for consumer dedupe), `eventType`,
  `occurredAt`, `aggregateId` and `traceparent` (W3C trace context).
- **Key:** the aggregate id (`eventId` for event/seat topics, `orderId` for order/payment topics),
  so per-aggregate ordering holds.
- **Evolution:** additive changes only (new optional fields). Removing or renaming a field means a
  new `eventType` version (`order.confirmed.v2`) and an ADR.
- **Failures:** consumers retry with backoff, then publish to `<topic>.dlt` with the error in headers.
- **Delivery:** at-least-once through the outbox ([ADR-0003](../adr/0003-transactional-outbox.md)).
  Every consumer must be idempotent.

| Topic | Key | Producer | Consumers |
|---|---|---|---|
| `event.lifecycle` | eventId | event-service | booking, search |
| `seat.status` | eventId | booking-service | event, pricing, analytics |
| `order.lifecycle` | orderId | order-service | booking, payment, notification, payout, analytics |
| `payment.result` | orderId | payment-service | order |
