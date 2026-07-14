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

## Known risk areas on first deploy

Ranked by how likely they are to need a fix, based on how each type of
metadata was authored (see `../architecture/decision-log.md` for the full
reasoning):

1. **Flows and the Approval Process** — hand-authored against the schema,
   never deploy-tested. Most likely place to need iteration.
2. **Reports and the Dashboard** — column field references for standard
   objects (Case, Account) use legacy uppercase aliases that are
   well-established but not schema-verified the way custom-object fields
   were.
3. **Everything else** (objects, fields, record types, validation rules,
   sharing rules, permission sets, permission set groups, roles, groups,
   queues, custom tabs, Lightning apps) — each was individually
   cross-checked against Salesforce's own metadata XSD before being
   written. Lowest risk in the repo.
