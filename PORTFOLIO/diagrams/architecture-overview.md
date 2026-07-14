# Architecture Overview

Layered view of the Meridian Communications org: what the user touches, what
runs in the background, what holds the data, and what controls who can see it.

```mermaid
flowchart TB
    subgraph UI["Presentation Layer — Lightning Apps"]
        direction LR
        A1["Meridian Sales<br/>(Account Executives)"]
        A2["Meridian Provisioning<br/>(Fulfillment Team)"]
        A3["Meridian Support<br/>(Service Desk)"]
    end

    subgraph AUTO["Automation Layer"]
        direction LR
        F1["Service Order Fulfillment<br/>Orchestration"]
        F2["Guided Service<br/>Provisioning (Screen Flow)"]
        F3["SLA Breach Monitor<br/>(Scheduled, daily)"]
        F4["Create Provisioning Tasks<br/>(Subflow)"]
        F5["Discount Approval Router<br/>+ Approval Process"]
    end

    subgraph DATA["Data Model"]
        direction LR
        D1[("Account / Contact<br/>Opportunity / Case")]
        D2[("Service_Order__c<br/>Service_Order_Line__c")]
        D3[("Network_Site__c<br/>Provisioning_Task__c")]
        D4[("Billing_Account__c<br/>Service_Subscription__c")]
        D5[("Escalation_Log__c")]
    end

    subgraph SEC["Security & Sharing Layer"]
        direction LR
        S1["11-Role Hierarchy"]
        S2["10 Permission Sets<br/>-> 6 Permission Set Groups"]
        S3["5 Public Groups<br/>4 Queues"]
        S4["Sharing Rules<br/>(criteria + owner-based)"]
    end

    subgraph INSIGHT["Reporting Layer"]
        direction LR
        R1["6 Reports"]
        R2["Operations Overview<br/>Dashboard"]
    end

    UI --> AUTO
    AUTO --> DATA
    DATA --> INSIGHT
    SEC -. governs record & field access for .-> UI
    SEC -. governs record & field access for .-> DATA

    F1 --> F4
    F1 -.->|"sets Opportunity.Has_Service_Order__c"| D1
    F2 -.->|"advances Stage__c"| D2
    F3 -.->|"escalates + logs"| D1
    F3 -.-> D5
    F5 -.->|"submits when Max_Discount_Percent__c > 20%"| D2

    classDef app fill:#1B4F8C,color:#fff,stroke:none
    classDef flow fill:#0E7C6B,color:#fff,stroke:none
    classDef data fill:#5B3B8C,color:#fff,stroke:none
    classDef sec fill:#8C5B1B,color:#fff,stroke:none
    classDef rep fill:#3C3C3C,color:#fff,stroke:none
    class A1,A2,A3 app
    class F1,F2,F3,F4,F5 flow
    class D1,D2,D3,D4,D5 data
    class S1,S2,S3,S4 sec
    class R1,R2 rep
```

**Reading this diagram:** the three Lightning Apps are how each functional
team enters the system; the automation layer reacts to what they do
(creating a Service Order fans out into provisioning tasks; a discount
crossing 20% halts the order until approved; an unattended SLA breach
escalates itself overnight); everything is stored against the data model in
the middle; and none of it is visible to a user unless the security layer
says so — role hierarchy for vertical visibility, sharing rules for lateral
visibility, and Permission Set Groups for what a user can actually _do_ once
they can see a record.
