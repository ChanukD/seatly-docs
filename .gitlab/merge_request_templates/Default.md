## What and why

<!-- One or two sentences. Link the issue. -->

## Type

- [ ] Feature
- [ ] Fix
- [ ] Infra / platform
- [ ] Experiment
- [ ] Docs only

## Checklist

- [ ] Tests added or updated (unit + Testcontainers where it touches DB/Kafka)
- [ ] OpenAPI / AsyncAPI updated if a contract changed (additive only, or ADR for breaking)
- [ ] Docs updated (`docs/`) in this MR
- [ ] ADR added if this is a hard-to-reverse decision
- [ ] New config/secrets go through External Secrets, nothing committed
- [ ] Dashboards / alerts updated if behaviour changed
- [ ] Terraform: `plan` output reviewed, no unexpected destroys

## How I tested

<!-- Commands, k6 runs, screenshots of Grafana panels. -->
