# Runbook: <alert name or scenario>

- **Service:** <service>
- **Alert:** `<PrometheusRule name>`
- **Severity:** page | ticket
- **SLO affected:** <slo>

## What this alert means

One or two sentences, in plain terms.

## Impact

What users see when this fires.

## Check first

1. Dashboard: <link>
2. Recent deploys: `argocd app history <app>`
3. Logs: `{app="<service>"} |= "ERROR"` in Loki
4. Traces: slow spans in Tempo for `<operation>`

## Mitigate

| Situation | Action |
|---|---|
| Bad deploy | `argocd app rollback <app> <id>` |
| Dependency down | Check the circuit-breaker state; confirm fallbacks are working |
| Load spike | Check HPA and Karpenter; raise the waiting-room admit rate only if p99 is fine |

## Escalate

Who/where, and what to include.

## After

- [ ] Postmortem if user-facing for > 5 min ([template](../postmortems/template.md))
