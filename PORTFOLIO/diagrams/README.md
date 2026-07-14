# Diagrams

All diagrams here are Mermaid, rendered natively by GitHub, GitLab, and most
modern Markdown viewers — no external tool or export step required, and
they stay in sync with the metadata by living in the same repo.

| File                                                 | Covers                                                                                    |
| ---------------------------------------------------- | ----------------------------------------------------------------------------------------- |
| [architecture-overview.md](architecture-overview.md) | The whole system in one picture: apps → automation → data → security → reporting          |
| [entity-relationship.md](entity-relationship.md)     | Object model, cardinalities, and which relationships are Master-Detail vs. Lookup and why |
| [security-model.md](security-model.md)               | Role hierarchy, Permission Set Group composition, and the 3 sharing rules                 |
| [automation-flows.md](automation-flows.md)           | Each of the 6 flows and the approval process, step by step                                |

Generated directly from the deployed metadata's actual structure (object
relationships, flow branches, sharing rule criteria) rather than drawn
freehand — if the metadata changes, these should be regenerated to match.
