# 15-Minute Walkthrough

**Goal:** the 5-minute version, plus enough depth to prove the surface-level
impression holds up — a live record walkthrough where the interviewer sees
automation actually fire, not just described.

## Timing

| Time        | Screen                                                                    | Say / Do                                                                                                                                                                                                                                                                                                                                                                                                                  |
| ----------- | ------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 0:00–1:00   | Dashboard                                                                 | Same opening as the 5-minute script — don't skip the fast hook just because you have more time.                                                                                                                                                                                                                                                                                                                           |
| 1:00–2:30   | Object Manager → the 7 custom objects                                     | "Fulfillment and billing lifecycle: Service Subscription, Service Order, Service Order Line, Network Site, Provisioning Task, Billing Account, Escalation Log. One deliberate design call worth calling out: only Service Order Line is Master-Detail to its parent — everything else is Lookup, kept independently sharable on purpose." Point to `entity-relationship.md` if screen-sharing the repo alongside the org. |
| 2:30–4:30   | Security: Role Hierarchy → Permission Sets → Permission Set Groups        | "11 roles, 10 single-purpose Permission Sets composed into 6 Permission Set Groups — not one profile per job title. `PSG_Provisioning_Lead` is a good example: it's not a duplicate of `PSG_Provisioning_Specialist`, it's that PSG's scope plus one incremental Permission Set for the manager-only pieces. Permission Set Groups take the union, so I only had to declare the delta."                                   |
| 4:30–6:00   | Sharing Rules (Account or Case)                                           | "Everything defaults to Private — that's only a real decision paired with sharing rules that earn their keep. Three policies: critical outage visibility for Escalation Reviewers, fulfillment status for the matching regional sales team, account visibility by region. Public Read/Write would make these rules pointless."                                                                                            |
| 6:00–10:00  | **Live walkthrough**: open an existing Service Order, or create a new one | Show `Stage__c`, `RecordType`, the line items. If creating new: pick a Network Site, add a line item with a **discount over 20%** and save — walk to Setup → Approval Processes or the record's approval history and show it's now pending approval. "That's not a screenshot of a feature, that's the roll-up summary and the router flow actually firing."                                                              |
| 10:00–12:00 | Flow Builder — open 2 flows                                               | Orchestration flow (branching + subflow call) and either the Screen Flow or SLA Breach Monitor. Narrate the branch logic out loud like you're debugging it live.                                                                                                                                                                                                                                                          |
| 12:00–13:30 | Reports + Dashboard                                                       | Open one Summary report (Service Orders by Stage) and explain the grouping, then point back at the Dashboard component it feeds.                                                                                                                                                                                                                                                                                          |
| 13:30–15:00 | Close + invite questions                                                  | "That's the architecture end to end — data model, security, automation, reporting, all reproducible from a clean org with one script. What do you want to go deeper on?"                                                                                                                                                                                                                                                  |

## Live-demo risk management

The order-creation step (6:00–10:00) is the only part of this script that
can visibly fail in front of someone. Two safety nets:

1. **Have a pre-made example ready.** Before the call, create one
   Service_Order__c with a >20% discount line and leave it pending
   approval. If live creation hits a snag, pivot: "here's one I set up
   earlier going through the same path" — recovers instantly, no dead air.
2. **Know the one likely failure mode.** If the Discount Approval process
   hasn't fired, the most likely cause is `Max_Discount_Percent__c` not
   having recalculated yet (roll-up summaries are near-instant but not
   always synchronous with the UI) — refresh the record, don't panic.

## Questions this length of demo tends to trigger

- **"Why is Opportunity → Service Order a Lookup, not Master-Detail?"** →
  Because the Closed-Won validation rule needs it to be independently
  sharable — the Opportunity shouldn't cascade-delete an active fulfillment
  order. That's exactly why the shadow-field pattern
  (`Has_Service_Order__c`) exists instead.
- **"What happens if OmniStudio isn't available?"** → Show
  `PS_OmniStudio_Runtime` — empty on purpose, already wired into
  `PSG_Provisioning_Specialist`, ready to populate the moment the package
  is confirmed installed. No restructuring needed either way.
