# Architecture Decision Records

Format: a light version of [MADR](https://adr.github.io/madr/). Copy [template.md](template.md),
use the next number, and open a merge request. ADRs are never edited after they are accepted.
To change a decision, write a new ADR that supersedes the old one.

| ADR | Title | Status |
|---|---|---|
| [0001](0001-monorepo.md) | Monorepo for services, infra, platform and docs | Accepted |
| [0002](0002-seat-locking-strategy.md) | Seat locking strategy | Proposed (needs EXP-001) |
| [0003](0003-transactional-outbox.md) | Transactional outbox with a poller, Debezium later | Accepted |
| [0004](0004-saga-style.md) | Choreography saga first, orchestration later | Proposed |
| [0005](0005-gitlab-ci-argocd.md) | GitLab CI for build, Argo CD for deploy | Accepted |
| [0006](0006-identity-provider.md) | Identity provider: Cognito vs Keycloak | Proposed |

**Statuses:** Proposed → Accepted → (Deprecated | Superseded by ADR-XXXX)
