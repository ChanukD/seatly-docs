# Seatly docs

Design and decision records for Seatly, the event ticket booking learning lab.

| Section | What's there |
|---|---|
| [System design](architecture/system-design.md) | Scope, services, key flows, data model, AWS/Terraform, tech stack, phases, risks |
| [C4 diagrams](architecture/c4/context.md) | System context and container views |
| [Key flows](architecture/sequence/booking-saga.md) | Seat hold, booking saga, flash-sale waiting room |
| [ADRs](adr/README.md) | Why things are the way they are |
| [API contracts](api/README.md) | OpenAPI specs per service |
| [Event contracts](events/README.md) | AsyncAPI spec for Kafka topics |
| [Experiments](experiments/README.md) | Hypothesis → setup → result for each pattern tested |

## Docs rules

- Docs change in the **same merge request** as the code they describe.
- A decision that is hard to reverse gets an [ADR](adr/README.md) before the code.
- No experiment starts without a written hypothesis and a Grafana panel to prove or disprove it.
- Diagrams are text (Mermaid). No binary diagram files.
