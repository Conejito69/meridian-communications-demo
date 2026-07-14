# 30-Minute Walkthrough

**Goal:** an architect/senior-round deep dive. By the end, the interviewer
should have no live questions about "how did you decide X" — every
non-obvious call in this project has a documented reason, and this script's
job is to surface them at the right moment rather than wait to be asked.

## Structure

This one isn't a tight minute-by-minute script like the shorter two — at 30
minutes the conversation should drive more than the clock. Use this as a
checklist of what to have covered by the end, in roughly this order.

### 1. Opening (2 min)

Same hook as the shorter scripts: Dashboard, then "everything here is
original, fictional, and reproducible — here's why that matters" (see
`README.md` in this folder for the one-line version of "why not real client
work").

### 2. Data model, with the reasoning (5 min)

Object Manager → the 7 custom objects → `../PORTFOLIO/diagrams/entity-relationship.md`
side by side if you can screen-share both. Cover:

- Why only `Service_Order_Line__c → Service_Order__c` is Master-Detail
- The shadow-field pattern (`Has_Service_Order__c`, `Has_Billing_Account__c`)
  and _why_ — walk through the actual validation rule formula, not just the
  concept
- `Max_Discount_Percent__c` as the one roll-up summary, and why it only
  works because of the Master-Detail choice above

### 3. Security model, in full (6 min)

Role Hierarchy → the 10 Permission Sets → 6 Permission Set Groups → 3
sharing rule policies (5 rule entries). Cover:

- Private OWD as a paired decision with the sharing rules, not independent
- `PSG_Provisioning_Lead` as the composition example (delta, not duplicate)
- `PS_Escalation_Reviewer` as a standalone Permission Set assigned directly
  rather than forced into a 7th PSG — and why that's the right call when a
  group cuts across job functions
- The `adhoc` approver decision on the Discount Approval process — Approval
  Step approvers can't target a Role directly; walk through why `adhoc` beat
  the alternatives (hardcoded user, queue) for this specific case

### 4. Automation, all of it (8 min)

Open Flow Builder for each of the 6 flows in turn, narrating branch logic
live rather than just describing it:

1. `Service_Order_Fulfillment_Orchestration` — the branch + subflow call +
   conditional Opportunity update
2. `Create_Provisioning_Tasks` — the loop pattern
3. `Guided_Service_Provisioning` — run it live if there's a test order
   available; screen flows demo better run than described
4. `SLA_Breach_Monitor` — explain the schedule-triggered-on-object pattern
   and the two-tier response (always log, escalate only if Critical)
5. `Service_Order_Discount_Approval_Router` + the Approval Process itself —
   open both, show the entry criteria on the process as the second line of
   defense behind the flow's own filter
6. `Sync_Billing_Account_Flag` — the one utility flow, and why it's called
   out separately rather than folded silently into the "5 flows" count

### 5. What's honestly unfinished, and why that's not a red flag (4 min)

This section is the one most candidates skip, and skipping it is the
mistake. Walk through `../PORTFOLIO/architecture/decision-log.md` items 5–8
directly:

- OmniStudio placeholder — empty on purpose, licensing gate not a technical
  one
- Flows hand-authored against the schema because the intended generation
  tool wasn't available in-session — and what "cross-checked against the
  XSD" actually meant in practice
- Lightning Record Pages using Salesforce defaults instead of custom
  FlexiPages — the schema-level reason, not just "didn't get to it"
- Reports using two different column-naming conventions (plain field names
  for custom objects, legacy uppercase aliases for standard objects) — both
  real, not an inconsistency

**Why show this instead of hiding it:** a senior interviewer trusts "I made
this call and here's why" far more than a project with no visible seams —
no real project has zero judgment calls, and pretending otherwise reads as
either inexperience or dishonesty.

### 6. DevOps story (3 min)

- `scripts/deploy-all.ps1` / `.sh` — one command, clean org to fully
  populated, anyone can run it
- `.github/workflows/ci.yml` — lint → scratch org → deploy → test → teardown,
  nothing persistent
- `PORTFOLIO/deployment/packaging.md` — why it's one package directory
  today and what the real split points would be if/when this needs to
  become multiple packages

### 7. Close + open floor (2 min)

"That's the full architecture — I'd rather spend the rest of this on
whatever you want to dig into than rush through a script." Then actually
stop talking.

## Preparing for this one specifically

Read `../PORTFOLIO/architecture/decision-log.md` end to end before a
30-minute slot — every item in it is a question an architect-level
interviewer might ask directly, and having already said it yourself lands
very differently than being asked and having to think on the spot.
