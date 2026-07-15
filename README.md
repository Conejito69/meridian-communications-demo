# Meridian Communications — Enterprise Salesforce Architecture

[![CI](https://github.com/Conejito69/meridian-communications-demo/actions/workflows/ci.yml/badge.svg)](https://github.com/Conejito69/meridian-communications-demo/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Salesforce API](https://img.shields.io/badge/Salesforce%20API-v66.0-00A1E0?logo=salesforce)](sfdx-project.json)
[![SFDX](https://img.shields.io/badge/Built%20with-SFDX-00A1E0)](https://developer.salesforce.com/tools/salesforcecli)

A complete, original Salesforce Enterprise implementation — data model,
security architecture, declarative automation, reporting, and CI/CD — built
from scratch for a fictional B2B connectivity company, specifically so it
can be published and inspected in full.

**Nothing in this repository derives from real client work.** Object
names, security model, automation, and data are entirely original,
designed to demonstrate the same category of enterprise architecture
decisions that real client work involves, without any of the
confidentiality problems that come with actually showing real client work.
See [Why this project exists](PORTFOLIO/README.md#why-this-project-exists)
for the full reasoning.

## What's here

| Area                 | Highlights                                                                                | Docs                                                                     |
| -------------------- | ----------------------------------------------------------------------------------------- | ------------------------------------------------------------------------ |
| **Data model**       | 7 custom objects, standard-object extensions, 9 Record Types                              | [Entity relationship diagram](PORTFOLIO/diagrams/entity-relationship.md) |
| **Security**         | 11-role hierarchy, 10 Permission Sets → 6 Permission Set Groups, 3 sharing-rule policies  | [Security model diagram](PORTFOLIO/diagrams/security-model.md)           |
| **Automation**       | 6 declarative flows + 1 Approval Process, zero Apex triggers                              | [Automation flow diagrams](PORTFOLIO/diagrams/automation-flows.md)       |
| **Apps & reporting** | 3 role-specific Lightning Apps, 6 reports, 1 cross-functional dashboard                   | [Architecture overview](PORTFOLIO/diagrams/architecture-overview.md)     |
| **DevOps**           | One-command reproducible deploy, CI/CD pipeline, fictitious data + sample user generation | [Deployment guide](PORTFOLIO/deployment/README.md)                       |

Full technical design and every non-obvious decision, with reasoning:
**[ARCHITECTURE.md](ARCHITECTURE.md)** and
**[PORTFOLIO/architecture/decision-log.md](PORTFOLIO/architecture/decision-log.md)**.

## Quick start

```bash
# One-time: connect a Dev Hub (interactive browser login)
sf org login web --set-default-dev-hub --alias MeridianDevHub

# Everything else: one command
./scripts/deploy-all.sh        # macOS/Linux/Git Bash
.\scripts\deploy-all.ps1       # Windows PowerShell
```

That creates a Scratch Org, deploys all metadata, loads realistic
fictitious data, and creates 7 sample users with role-appropriate access.
Full runbook: [PORTFOLIO/deployment/README.md](PORTFOLIO/deployment/README.md).

## See it without deploying anything

- **[DEMO/](DEMO/)** — 5/15/30-minute guided walkthroughs (built for
  technical interviews, work just as well as a self-guided tour)
- **[PORTFOLIO/diagrams/](PORTFOLIO/diagrams/)** — architecture, entity
  relationship, security, and automation diagrams (render natively on
  GitHub)
- **[PORTFOLIO/architecture/decision-log.md](PORTFOLIO/architecture/decision-log.md)**
  — 8 non-obvious design decisions, with the reasoning behind each

## Repository structure

```
meridian-communications-demo/
├── force-app/main/default/   Salesforce metadata (SFDX source format)
├── scripts/                   Deployment, data generation, evidence capture
├── ARCHITECTURE.md            Full technical design document
├── DEMO/                      Interview-ready walkthrough scripts
└── PORTFOLIO/                 Diagrams, screenshots, deployment guide, sample-data docs
```

_(A local-only `MARKETING/` folder also exists for platform-specific sales
content, deliberately excluded from this public repo — see
[Security](#security) below.)_

## Status

Deploy-tested against two real Scratch Orgs (not just written, actually
verified). Confirmed present via `sf org list metadata` and re-tested on a
second, independent Scratch Org to rule out one-off corruption:

- All 7 custom objects, 10 Permission Sets, 6 Permission Set Groups, 6
  Flows, the Approval Process, 6 Custom Tabs, 3 Lightning Apps, 11 Roles,
  5 Public Groups, 5 Queues, and 4 Report Types deploy successfully.
- Two Account criteria sharing rules, the 6 Reports, and the Dashboard
  fail to deploy with errors that persist identically on a from-scratch
  org — documented as real platform limitations, not code bugs, in
  [PORTFOLIO/deployment/README.md](PORTFOLIO/deployment/README.md).
- Fictitious data and sample users have not been loaded yet: this
  specific Dev Hub's Scratch Orgs have zero spare Salesforce user
  licenses, and several custom objects take longer than expected to
  become queryable after deploy in this environment. Both are documented
  with evidence, not assumed away.

## Security

This repository went through a full security audit before being made
public — see [SECURITY_AUDIT_REPORT.md](SECURITY_AUDIT_REPORT.md) for the
methodology and findings. One folder (`MARKETING/`, real personal
freelance-platform strategy notes, unrelated to the fictional Meridian
company) was removed from git history entirely rather than just the
working tree, since it isn't portfolio content at all.

## License

[MIT](LICENSE) — see that file for the full text. This is a portfolio
project; reuse the patterns freely, the specific fictional company/data are
just there to make the patterns concrete.

## Contributing

This is a personal portfolio project, not soliciting external
contributions — see [CONTRIBUTING.md](CONTRIBUTING.md) for why, and for
how to fork it if you want to build your own version.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for what's been built and when.

## Roadmap

See [ROADMAP.md](ROADMAP.md) for what's planned next — deployment
validation, Experience Cloud, and the evidence library are the near-term
priorities.
