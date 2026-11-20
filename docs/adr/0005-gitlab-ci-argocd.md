# ADR-0005: GitLab CI for build, Argo CD for deploy

- **Status:** Accepted
- **Date:** 2026-11-20
- **Deciders:** Chanuka

## Context

The target role (GovTech) uses SHIP-HATS, which is GitLab-based, and GitOps. CI needs AWS access
without long-lived keys.

## Options considered

1. **GitLab CI + Argo CD (pull-based GitOps)**
2. **GitHub Actions + Argo CD**
3. **GitLab CI pushing straight to the cluster (`kubectl` / `helm upgrade`)**

## Decision

**Option 1.** GitLab CI builds, tests, scans, signs and pushes images to ECR, then updates image
tags in `deploy/`. Argo CD syncs the cluster from Git. CI reaches AWS with **OIDC**, not access keys.

## Consequences

### Good

- Matches the target environment. No cluster credentials in CI. Git history is the deploy log.
- GitLab Pages hosts these docs for free.

### Bad / accepted trade-offs

- Two systems to debug when a deploy fails (pipeline vs sync).
- Image-tag bump commits can loop with CI (see [ADR-0001](0001-monorepo.md)).

## How we will know it was wrong

Manual `kubectl` changes needed for routine deploys, or drift between Git and the cluster.
