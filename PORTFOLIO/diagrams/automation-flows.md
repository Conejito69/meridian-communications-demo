# Automation

Six Flows plus one Approval Process. Five of the flows correspond to a named
business-process automation; the sixth (`Sync_Billing_Account_Flag`) is a
small supporting utility, called out separately below.

## 1. Service Order Fulfillment Orchestration

```mermaid
flowchart TD
    Start(["Service_Order__c<br/>created"]) --> Decide{"Record Type?"}
    Decide -->|New Service| T1["Task Type = Site Survey"]
    Decide -->|Upgrade| T2["Task Type = Configuration"]
    Decide -->|Cancellation| T3["Task Type = Decommission"]
    Decide -->|"other / unknown"| T4["Task Type = Configuration"]
    T1 & T2 & T3 & T4 --> Sub(["Call subflow:<br/>Create_Provisioning_Tasks"])
    Sub --> HasOpp{"Opportunity__c<br/>populated?"}
    HasOpp -->|yes| Mark["Update Opportunity:<br/>Has_Service_Order__c = true"]
    HasOpp -->|no| End(["End"])
    Mark --> End
```

## 2. Create Provisioning Tasks (subflow)

```mermaid
flowchart TD
    In(["Input: order Id, task type"]) --> Get["Get Service_Order_Line__c<br/>records for this order"]
    Get --> Loop{"More lines?"}
    Loop -->|yes| Create["Create Provisioning_Task__c<br/>(queue = Provisioning,<br/>due = today + 7)"]
    Create --> Loop
    Loop -->|no| Done(["End"])
```

## 3. Guided Service Provisioning (screen flow)

```mermaid
flowchart TD
    S1["Screen: enter order number"] --> L["Get Service_Order__c"]
    L --> F1{"Found?"}
    F1 -->|no| NF["Screen: not found"]
    F1 -->|yes| S2["Screen: confirm site survey complete"]
    S2 --> F2{"Confirmed?"}
    F2 -->|no| CP["Screen: cannot proceed"]
    F2 -->|yes| S3["Screen: activation date + notes"]
    S3 --> U["Update order:<br/>Stage__c = Provisioning"]
    U --> S4["Screen: confirmation"]
```

## 4. SLA Breach Monitor (scheduled, daily 06:00)

```mermaid
flowchart TD
    Sched(["Schedule tick — matches open Cases<br/>past SLA_Target_DateTime__c"]) --> P{"Priority = Critical?"}
    P -->|yes| Esc["Update Case:<br/>Status = Escalated"]
    P -->|no| Log
    Esc --> Log["Create Escalation_Log__c<br/>(Escalated From: SLA Breach Monitor)"]
```

## 5. Discount Approval Router + Approval Process

```mermaid
flowchart TD
    Trig(["Service_Order__c created/updated,<br/>Max_Discount_Percent__c > 20%<br/>(and wasn't already over threshold)"]) --> Submit["Submit for Approval"]
    Submit --> AP["Approval Process:<br/>Service_Order__c.Discount_Approval"]
    AP --> Adhoc["Step: Sales Leadership Review<br/>(adhoc approver — submitter picks who)"]
    Adhoc -->|Approved| Locked["Record locked, order proceeds"]
    Adhoc -->|Rejected| Rejected["Final rejection actions"]
```

`Max_Discount_Percent__c` is a **roll-up summary (MAX)** over
`Service_Order_Line__c.Discount_Percent__c` — only possible because that
line-item relationship is Master-Detail (the one deliberate exception in an
otherwise all-Lookup custom object model; see `entity-relationship.md`).

## Utility flow (not one of the 5 above)

**Sync Billing Account Flag** — record-triggered on `Billing_Account__c`
create, sets `Account.Has_Billing_Account__c = true` on the parent. Exists
for the same reason as the Opportunity shadow field in flow 1: the
underlying relationship is a Lookup, not Master-Detail, so no native
roll-up is available for the "Business Customer accounts need a Billing
Account" validation rule to check directly.
