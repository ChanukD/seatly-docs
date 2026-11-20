# EXP-NNN: <question in one line>

- **Phase:** N
- **Status:** Planned | Running | Done
- **Related ADR:** ADR-XXXX
- **Date run:** YYYY-MM-DD
- **Commit:** `<sha>`

## Hypothesis

> If we …, then … because …

## Success criteria

| Metric | Target |
|---|---|
| e.g. oversells | 0 |
| e.g. p99 latency | < 200 ms |

## Setup

- Environment: local Compose / kind / EKS (node types, replicas)
- Load: k6 script `load-tests/...`, VUs, duration, ramp
- Faults: Toxiproxy / Chaos Mesh config
- Variants under test: A, B, C
- Grafana dashboard: link / panel ids

## Results

| Variant | Metric 1 | Metric 2 | Metric 3 |
|---|---|---|---|
| A | | | |
| B | | | |

Screenshots of the panels go in `docs/experiments/img/EXP-NNN/` (PNG is fine here: these are
results, not diagrams).

## Analysis

What happened and why. Include surprises.

## Conclusion

Hypothesis confirmed / rejected. Decision or ADR update that follows.

## Next questions

- …
