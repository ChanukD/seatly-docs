# API contracts (OpenAPI 3.1)

Contract-first: change the spec in the same merge request as the code. CI lints every
`*.openapi.yaml` file with Redocly.

| Service | Spec | Status |
|---|---|---|
| booking-service | [`booking-service.openapi.yaml`](booking-service.openapi.yaml) | Draft |
| event-service | `event-service.openapi.yaml` | To do (Phase 1) |
| order-service | `order-service.openapi.yaml` | To do (Phase 3) |
| payment-service | `payment-service.openapi.yaml` | To do (Phase 3) |

## Conventions

- Errors use Problem Details (RFC 9457), `application/problem+json`.
- Every write endpoint requires an `Idempotency-Key` header (UUID).
- Paths are plural nouns; no verbs in paths.
- Breaking changes need a new version path (`/v2/...`) and an ADR.
- Generate server stubs/clients from the spec (`openapi-generator` with the `spring` / `typescript-fetch` generators).

```bash
make lint-contracts   # npx @redocly/cli lint docs/api/*.openapi.yaml
```
