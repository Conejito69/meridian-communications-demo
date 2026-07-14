# Meridian Communications — Enterprise Salesforce Platform

**A complete, from-scratch Salesforce Enterprise implementation for a fictional
B2B managed-connectivity provider — built as a permanent architecture lab and
public portfolio piece.**

> Meridian Communications is not a real company. Every object, field, flow,
> permission, role, and data record in this project was designed and built
> specifically for this repository. Nothing here is copied, exported, or
> derived from any client environment — see [`../ARCHITECTURE.md`](../ARCHITECTURE.md)
> for the full non-negotiable ground rules this project was built under.

## The brief

Meridian Communications sells managed internet, voice, security, and cloud
backup services to business customers across multiple physical sites,
fulfilled through an internal provisioning process and supported through a
tiered service desk. The platform needed to:

- Give **Sales** a clean path from Opportunity to a fulfillable Service Order
- Give **Provisioning** a guided, auditable path from order to activation
- Give **Support** case management with real SLA accountability and a
  defined escalation path
- Give **Billing** visibility into recurring revenue and payment terms
- Enforce all of the above declaratively — validation rules, sharing rules,
  and approval processes, not code, wherever a code-free solution existed
- Be reproducible from source, so the whole org can be rebuilt from a clean
  Scratch Org at any time

## What was delivered

| Layer          | Highlights                                                                                                                                                |
| -------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Data model** | 7 custom objects, standard-object extensions on Account/Case/Opportunity, 7 Record Types across 3 objects                                                 |
| **Security**   | 11-role hierarchy, 10 Permission Sets composed into 6 Permission Set Groups, 5 Public Groups, 4 Queues, 3 sharing-rule policies (5 concrete rule entries) |
| **Automation** | 6 Flows (record-triggered, screen, scheduled, and subflow) + 1 Approval Process — no Apex triggers; every automation need was met declaratively           |
| **Apps**       | 3 role-specific Lightning Apps (Sales, Provisioning, Support consoles)                                                                                    |
| **Reporting**  | 6 reports feeding a cross-functional operations dashboard                                                                                                 |
| **Data**       | A generation script producing a realistic multi-region customer base, fulfillment pipeline, and support caseload                                          |
| **DevOps**     | Source-driven (SFDX), Scratch-Org-based, CI-ready — see [`deployment/`](deployment/)                                                                      |

See [`../ARCHITECTURE.md`](../ARCHITECTURE.md) for the full technical design
and every decision's rationale, and [`diagrams/`](diagrams/) for visual
walkthroughs of the architecture, entity relationships, security model, and
automation.

## Why this project exists

This repository is a deliberate alternative to portfolio material sourced
from real client work, which — however strong the underlying experience —
can't ethically be published: client names, org structure, and business
data don't belong in a public portfolio no matter how thoroughly they're
redacted. Meridian Communications lets the same category of enterprise
architecture decisions (role hierarchies, sharing models, layered permission
sets, declarative automation, approval routing, Master-Detail vs. Lookup
tradeoffs) be demonstrated honestly, in full, with nothing hidden or
blurred — because there's nothing in it that needed to be.

## Repository structure

```
meridian-communications-demo/
├── force-app/main/default/   ← all Salesforce metadata (SFDX source format)
├── scripts/apex/              ← fictitious data + sample user generation
├── ARCHITECTURE.md            ← full technical design document
└── PORTFOLIO/                 ← this folder
    ├── README.md               ← you are here
    ├── screenshots/             ← real captures from this org (see below)
    ├── architecture/            ← architecture reference docs
    ├── diagrams/                ← Mermaid diagrams (architecture, ER, security, automation)
    ├── deployment/              ← how to stand this org up from scratch
    └── sample-data/             ← what the generated data looks like and why
```

## Screenshot policy

Every image under `screenshots/` is a real capture of **this** deployed org
— never a mockup, never a stock template, never a real client environment
with logos swapped out. If a screenshot category doesn't exist yet in that
folder, it's because this org hasn't been deployed to a live Scratch Org in
the current environment yet, not because it was faked. See
[`screenshots/README.md`](screenshots/README.md) for the exact capture
checklist and current status.

## About the author

_(Fill in: your name, your role, and one line on what building this
demonstrates about how you work — the technical content above should do
most of the talking.)_
