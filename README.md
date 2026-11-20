# 🎟️ Seatly

A ticket booking platform for events (concerts, conferences, workshops), built as a **learning lab**.
It has 11 microservices (9 Java, 1 Python, 1 Node.js) on AWS EKS, plus Lambda and Step Functions,
and runs as an internal developer platform.

Every hard part of ticketing (flash-sale spikes, two users competing for one seat, slow payments)
maps to a pattern to test, and every experiment starts with a written hypothesis.

## Architecture at a glance

```mermaid
flowchart LR
    U[Browser] --> CF[CloudFront<br/>React app]
    U --> ALB[ALB] --> GW[Spring Cloud Gateway<br/>Cognito JWT, rate limit]
    GW --> SVC[Java / Python / Node services<br/>on EKS]
    SVC --> PG[(RDS PostgreSQL<br/>schema per service)]
    SVC --> RD[(ElastiCache Redis)]
    SVC <--> K[[MSK Kafka<br/>outbox events]]
    K --> EB[EventBridge] --> L[Lambda: ticket PDF]
    EB --> SF[Step Functions: refunds]
```

See [docs/architecture/system-design.md](docs/architecture/system-design.md) for the full design.

## Repository layout

| Path | Contents |
|---|---|
| `docs/` | System design, ADRs, API and event contracts, experiments, runbooks (published with MkDocs) |
| `services/` | One folder per microservice |
| `frontend/` | React + TypeScript customer app and organiser portal |
| `infra/` | Terraform: `modules/`, `envs/dev`, `envs/prod`, `bootstrap/` |
| `platform/` | Backstage templates and cluster add-ons |
| `deploy/` | Helm chart and Argo CD app-of-apps |
| `load-tests/` | k6 scripts |

## Docs

```bash
make docs-serve     # live preview at http://127.0.0.1:8000
make docs-build     # strict build (fails on broken links)
make lint-contracts # validate OpenAPI and AsyncAPI specs
```

The docs are published to GitLab Pages on every merge to `main`. The same MkDocs setup works as
Backstage TechDocs (`catalog-info.yaml`).

## Key docs

- [System design](docs/architecture/system-design.md)
- [Architecture Decision Records](docs/adr/README.md)
- [Experiments](docs/experiments/README.md)
- [API contracts](docs/api/README.md) · [Event contracts](docs/events/README.md)
