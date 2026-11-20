# ADR-0006: Identity provider – Cognito vs Keycloak

- **Status:** Proposed
- **Date:** 2026-11-20
- **Deciders:** Chanuka

## Context

The gateway validates JWTs; services use the Spring OAuth2 resource server. Two roles: customer and
organiser. Local development must work offline (Docker Compose / kind).

## Options considered

1. **Amazon Cognito:** managed, cheap at this scale, native on AWS. No local emulator, and harder to
   customise.
2. **Keycloak:** portable, common in enterprises, runs the same locally and on EKS. You run and
   upgrade it yourself.
3. **Keycloak locally, Cognito on AWS:** realistic for both, but two configs to keep in step.

## Decision

Pending. Leaning towards **option 3**: services only depend on standard OIDC (issuer URI + JWKS),
so the provider can be swapped per environment.

## Consequences

To fill in once decided. Either way, no provider-specific claims in service code. Map roles at the
gateway.

## How we will know it was wrong

Provider-specific code showing up in services, or local auth setup taking more than one command.
