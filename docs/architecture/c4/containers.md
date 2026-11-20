# C4 Level 2 – Containers

Deployable units and how they talk. Solid lines are synchronous (REST/gRPC/GraphQL); dotted lines
are asynchronous (Kafka / EventBridge).

```mermaid
flowchart LR
    browser["Browser"]

    subgraph edge["Edge"]
        cf["CloudFront + S3<br/>React app"]
        alb["ALB + WAF"]
        gw["Spring Cloud Gateway<br/>JWT, rate limit, waiting room"]
    end

    subgraph eks["EKS"]
        user["user-service<br/>Java"]
        event["event-service<br/>Java"]
        booking["booking-service<br/>Java"]
        order["order-service<br/>Java"]
        payment["payment-service<br/>Java"]
        search["search-service<br/>Java WebFlux"]
        pricing["pricing-service<br/>Kafka Streams"]
        payout["payout-service<br/>Spring Batch"]
        bff["organiser-bff<br/>Spring GraphQL"]
        notif["notification-service<br/>NestJS"]
        analytics["analytics-service<br/>FastAPI"]
    end

    subgraph data["Data"]
        pg[("RDS PostgreSQL<br/>schema per service")]
        replica[("Read replica")]
        redis[("ElastiCache Redis")]
        os[("OpenSearch")]
        kafka[["MSK Kafka"]]
    end

    subgraph serverless["Serverless"]
        eb["EventBridge"]
        pdf["ticket-pdf Lambda<br/>Python"]
        sfn["Refund workflow<br/>Step Functions"]
        s3[("S3 e-tickets")]
    end

    browser --> cf
    browser --> alb --> gw
    gw --> user & event & booking & order & search & analytics & bff
    bff --> event & order & payout & analytics
    booking -->|gRPC GetPrice| pricing
    order --> payment

    user & event & booking & order & payment & payout --> pg
    analytics --> replica
    event & booking & gw --> redis
    search --> os

    event -.-> kafka
    booking -.-> kafka
    order -.-> kafka
    payment -.-> kafka
    kafka -.-> notif & analytics & search & pricing & payout
    kafka -.-> eb
    eb -.-> pdf --> s3
    eb -.-> sfn
```

## Notes

- Each service owns its schema. No cross-schema joins (see the rules in the
  [system design](../system-design.md#rules)).
- Every Kafka event leaves through the service's `outbox` table
  ([ADR-0003](../../adr/0003-transactional-outbox.md)).
- Lambda and Step Functions are outside EKS and only see events bridged through EventBridge.
