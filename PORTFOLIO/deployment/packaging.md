# Packaging Strategy

## Current state: single unlocked package directory

`sfdx-project.json` defines one package directory (`force-app`) — everything
in this repo deploys as a single unit. That's the right call for where this
project is today: one cohesive object model with cross-object automation
(the fulfillment flow touches `Service_Order__c`, `Service_Order_Line__c`,
`Provisioning_Task__c`, and `Opportunity` in a single transaction), so
splitting it prematurely would mean managing cross-package dependencies for
no real benefit yet.

## Forward path: when to actually split

Split into multiple 2GP (second-generation, source-driven) packages once —
and only once — a real seam appears. The natural seams already visible in
the architecture, in likely order of appearance:

1. **`meridian-core`** — Account/Case/Opportunity extensions, roles, public
   groups, queues. Everything else depends on this; nothing in it depends
   on anything else.
2. **`meridian-fulfillment`** — `Service_Order__c`, `Service_Order_Line__c`,
   `Network_Site__c`, `Provisioning_Task__c`, the fulfillment flows, the
   Discount Approval process. Depends on `meridian-core`.
3. **`meridian-billing`** — `Billing_Account__c`, `Service_Subscription__c`.
   Depends on `meridian-core` only, not on `meridian-fulfillment` — genuinely
   independent, which is exactly the signal that it's ready to be its own
   package.
4. **`meridian-support`** — Case record types/business process,
   `Escalation_Log__c`, the SLA Breach Monitor. Depends on `meridian-core`
   only.

Permission Sets and Permission Set Groups would move with whichever package
owns the objects they grant access to — `PS_Billing_ReadOnly` ships in
`meridian-billing`, not `meridian-core`, for example.

## Why not split now

Premature package boundaries create exactly the kind of cross-package
dependency management overhead this project's own architecture principles
argue against (see `../architecture/decision-log.md` — every decision in
this project favors the simplest structure that satisfies a real, present
requirement, not a hypothetical future one). Package directories are cheap
to introduce later and expensive to have gotten wrong early.

## How to actually do it, when the time comes

```bash
sf package create --name meridian-core --package-type Unlocked --path packages/meridian-core
```

...then move the relevant metadata subtree into `packages/meridian-core/`,
update `sfdx-project.json`'s `packageDirectories` array to list all package
paths with correct `dependencies`, and repeat per package. `sf package
version create` cuts an installable version once a package directory is
stable.
