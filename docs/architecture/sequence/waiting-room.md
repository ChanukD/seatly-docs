# Flow – Flash-sale waiting room

Protects booking-service when a hot event opens. N (users admitted per second) is tuned in the
Phase 10 load test until booking-service p99 stays under target.

```mermaid
sequenceDiagram
    autonumber
    actor C as Customer
    participant GW as Gateway
    participant R as Redis
    participant D as Dispatcher
    participant B as booking-service

    C->>GW: open hot event page
    GW->>R: ZADD queue:{eventId} <arrival ts> <userId> (NX)
    GW-->>C: queued, position = ZRANK

    loop every second
        D->>R: ZPOPMIN queue:{eventId} N
        D->>R: SET access:{eventId}:{userId} <token> EX 300
    end

    loop poll every few seconds
        C->>GW: GET /queue/{eventId}/position
        GW->>R: ZRANK / GET access token
        GW-->>C: position, or access token when admitted
    end

    C->>GW: POST /holds + access token
    GW->>R: validate token
    alt valid
        GW->>B: forward
        B-->>C: 201 hold
    else missing or expired
        GW-->>C: 403 back to queue
    end
```

## Open points

- Fairness: is re-joining after a token expiry allowed? At the back of the queue or the front?
- Bots: WAF rate rules plus per-user tokens; measure how many duplicate joins `NX` blocks.
