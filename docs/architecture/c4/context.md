# C4 Level 1 – System context

Who uses Seatly and which external systems it depends on.

```mermaid
flowchart TB
    customer(["👤 Customer<br/>Browses events, holds seats, pays"])
    organiser(["👤 Organiser<br/>Creates events, venues, seat maps"])
    ops(["👤 Platform engineer<br/>Runs the platform, experiments"])

    seatly["🎟️ Seatly<br/>Event ticket booking platform"]

    cognito["Amazon Cognito<br/>Identity, JWTs"]
    pay["Mock payment gateway<br/>(behind Toxiproxy)"]
    mail["Mock email / SMS provider"]
    gitlab["GitLab<br/>Source, CI, Pages"]

    customer -->|HTTPS| seatly
    organiser -->|HTTPS| seatly
    ops -->|Argo CD, Grafana, Backstage| seatly
    seatly -->|Validates tokens| cognito
    seatly -->|Charges, refunds| pay
    seatly -->|Sends e-tickets| mail
    gitlab -->|OIDC deploys| seatly

    classDef sys fill:#3f51b5,color:#fff,stroke:#283593
    classDef ext fill:#9e9e9e,color:#fff,stroke:#616161
    class seatly sys
    class cognito,pay,mail,gitlab ext
```

| Actor / system | Notes |
|---|---|
| Customer | Uses the React web app (no mobile, see scope limits) |
| Organiser | Uses the organiser portal, served through `organiser-bff` (GraphQL) |
| Mock payment gateway | Its own container so latency and errors can be injected |
| Cognito | May be replaced by Keycloak, see [ADR-0006](../../adr/0006-identity-provider.md) |
