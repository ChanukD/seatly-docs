# ADR-0001: Monorepo for services, infra, platform and docs

- **Status:** Accepted
- **Date:** 2026-11-20
- **Deciders:** Chanuka

## Context

Seatly has 11 services in three languages, Terraform, Helm/Argo CD config, Backstage templates and
design docs. One person builds it. Changes often cross boundaries, e.g. a new Kafka event touches the
AsyncAPI spec, a producer, two consumers and a dashboard.

## Options considered

1. **Monorepo:** one repo with `services/*`, `frontend/`, `infra/`, `platform/`, `deploy/`, `load-tests/`, `docs/`.
2. **Polyrepo:** one repo per service, plus infra, platform and docs repos.
3. **Hybrid:** an app monorepo plus a separate GitOps repo for Argo CD manifests.

## Decision

Use a **monorepo**, with docs in `docs/` next to the code.

## Consequences

### Good

- One merge request can change a contract, its producer, its consumers and its docs together.
- One CI config and shared tooling (lint, scanning, Helm chart).
- Easy to browse as a portfolio project.

### Bad / accepted trade-offs

- CI must build only what changed: use GitLab `rules:changes` per service, or the pipeline time grows
  with every service.
- Argo CD watches the same repo that CI writes image tags to, so a commit loop is possible. Use
  `[skip ci]` on tag-bump commits, or move to option 3 later.
- Less practice with polyrepo concerns (cross-repo versioning). Backstage golden paths in Phase 9
  can still create standalone repos to cover this.

### Follow-ups

- [ ] `rules:changes` per service folder in `.gitlab-ci.yml`
- [ ] Revisit option 3 when Argo CD is set up in Phase 4

## How we will know it was wrong

Main-branch pipeline over 15 minutes for a single-service change, or regular tag-bump commit loops.
