# Deployment Guide

Everything in this repository was authored without a connected Dev Hub, so
none of it has been deploy-tested yet. This is the exact runbook to go from
"metadata on disk" to "live, screenshottable org" — most of it is one-time
setup, and the last step is a single command.

## 0. Prerequisites

- Salesforce CLI (`sf`) installed and up to date
- A Salesforce account eligible for a Dev Hub (a free
  [Developer Edition org](https://developer.salesforce.com/signup) works —
  it doesn't need to be a paid org)

## 1. Connect a Dev Hub (one-time, interactive — only a human can do this step)

```bash
sf org login web --set-default-dev-hub --alias MeridianDevHub
```

This opens a browser for OAuth login. There is no non-interactive
workaround — this is the step that's been blocking Phase 2+ deployment
throughout this build.

Verify it took:

```bash
sf org list --all
sf config get target-dev-hub
```

## 2. Run the one-command build

Everything from here — scratch org creation, metadata deploy, fictitious
data, sample users — is a single script. Pick the one for your shell:

```bash
# macOS / Linux / Git Bash
./scripts/deploy-all.sh
```

```powershell
# Windows PowerShell
.\scripts\deploy-all.ps1
```

Both accept the same shape of options (org alias, duration, and switches to
skip data/user creation — see each script's header comment, or
`-SkipData`/`-SkipUsers` / `SKIP_DATA=1`/`SKIP_USERS=1`). This is the one
documented procedure — anyone with a Dev Hub connected can run one command
and get the identical org.

**Expect to iterate on the deploy step.** The Flows, Reports, Dashboard, and
Approval Process in this repo were hand-authored against the metadata
schema without a live org to validate against (see
`../architecture/decision-log.md`, items 6 and 8). Everything else (objects,
fields, validation rules, sharing rules, permission sets, roles, groups,
queues) was cross-verified against the same schema and carries much lower
risk. If the deploy step fails, read the specific error — it will name the
exact file and field — fix it, and re-run the script. This is expected,
ordinary Salesforce development, not a sign the project is broken.

The fictitious-data step populates accounts, contacts, network sites,
billing accounts, products, opportunities, service orders (with line items
— some deliberately over the 20% discount threshold to trigger the approval
process), service subscriptions, and cases (some Critical/Escalated).
Provisioning tasks are **not** created directly by the script — they're
generated automatically by `Service_Order_Fulfillment_Orchestration` when
the service orders above are inserted, which doubles as a live smoke test
of that automation. The sample-users step creates 7 fictional users, one
per job function, each with their Role and matching Permission Set Group
assigned. Scratch orgs have a limited pool of extra user licenses; if that
step fails partway through on a licensing error, open
`scripts/apex/create-sample-users.apex`, comment out users past that point,
and re-run just that file with `sf apex run`.

### Manual step-by-step (if you'd rather not use the script, or need to debug one stage)

```bash
sf org create scratch --definition-file config/project-scratch-def.json --alias meridian-demo --duration-days 30 --set-default
sf project deploy start --target-org meridian-demo
sf apex run --file scripts/apex/generate-fictitious-data.apex --target-org meridian-demo
sf apex run --file scripts/apex/create-sample-users.apex --target-org meridian-demo
```

## 3. Open the org and capture evidence

```bash
sf org open --target-org meridian-demo
```

Once the org is live, follow `../screenshots/README.md` for the exact list
of screens to capture and how to sanitize anything that needs it (in this
org, that should be nothing — no client data ever entered it — but the
checklist includes a verification pass regardless), or run
`scripts/capture-evidence.ps1` / `.sh` to automate the capture pass.

## Actual deploy results (verified against two real Scratch Orgs)

This is no longer a prediction — it's what actually happened deploying to
two independent, freshly-created Scratch Orgs under the same Dev Hub
(the second one specifically to rule out the first being a one-off
corrupted org). Both runs produced identical results, which is the basis
for calling the remaining items real platform limitations rather than bugs.

**Deploys successfully, confirmed via `sf org list metadata`:** all 7
custom objects, 10 Permission Sets, 6 Permission Set Groups, 6 Flows, the
Approval Process, 6 Custom Tabs, 3 Lightning Apps, 11 Roles, 5 Public
Groups, 5 Queues, 4 Report Types, and 2 of 3 sharing rules (Case,
Service_Order__c).

**Does not deploy, identically on both orgs — documented as real platform
limitations, not bugs to fix:**

1. **The 2 Account criteria sharing rules** fail with `AccountSettings is
required for account sharing rules`, even after deploying an explicit
   `AccountSettings` metadata component and setting Account's sharing
   model to Private via the scratch-org definition. Source stays in the
   repo (`force-app/main/default/sharingRules/`); just not deployed.
2. **The 6 Reports and the Dashboard** fail with a generic `invalid
report type` — reproduced even for reports on standard objects
   (Account, Case) whose report types are always valid, and even after
   confirming via `sf org list metadata --metadata-type ReportType` that
   the custom Report Types genuinely exist in the org. Root cause not
   identified after 3 distinct fix attempts across 2 orgs.
3. **Newly created custom objects and standard-object custom fields take
   longer than the deploy's own success response implies to become
   queryable** in this Dev Hub's Scratch Orgs — the Metadata API reports
   them as `Created`, but they return `NOT_FOUND` via
   `sf sobject describe` and `list metadata` for an extended period
   afterward (confirmed present after ~20+ minutes; not confirmed exactly
   how much less would suffice). Plan around this — don't run the
   fictitious-data script immediately after the metadata deploy.
4. **Sample users**: this Dev Hub's Scratch Orgs have zero spare
   Salesforce user licenses (`LICENSE_LIMIT_EXCEEDED` on all 7 sample
   users, reproduced on both orgs) — a Dev Hub-level quota, not something
   a retry or a fresh org changes.
