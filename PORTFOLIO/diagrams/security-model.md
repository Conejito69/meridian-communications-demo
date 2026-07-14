# Security Model

Three independent mechanisms combine to control access: the **role
hierarchy** (vertical — managers see their team's records), **sharing
rules** (lateral — specific groups see records they don't own, for a
specific business reason), and **Permission Set Groups** (functional — what
a user can actually do with a record once they can see it).

## Role hierarchy

```mermaid
graph TD
    CEO["CEO"]
    CEO --> VPS["VP Sales"]
    CEO --> VPSD["VP Service Delivery"]
    CEO --> VPSU["VP Support"]

    VPS --> RSM["Regional Sales Manager"]
    RSM --> AE["Account Executive"]

    VPSD --> PM["Provisioning Manager"]
    PM --> PS["Provisioning Specialist"]

    VPSU --> SM["Support Manager"]
    SM --> T1["Tier 1 Support Agent"]
    SM --> T2["Tier 2 Support Agent"]

    classDef exec fill:#1B4F8C,color:#fff,stroke:none
    classDef mgr fill:#0E7C6B,color:#fff,stroke:none
    classDef ic fill:#5B3B8C,color:#fff,stroke:none
    class CEO exec
    class VPS,VPSD,VPSU,RSM,PM,SM mgr
    class AE,PS,T1,T2 ic
```

## Permission Set Groups (functional access)

```mermaid
graph LR
    subgraph Sales
        PS1["PS_Sales_Base"]
        PS2["PS_Sales_CPQ_Access"]
        PS3["PS_Reports_PowerUser"]
        PS1 & PS2 & PS3 --> PSG1["PSG_Sales_Rep"]
    end

    subgraph Provisioning
        PS4["PS_Provisioning_Agent"]
        PS5["PS_OmniStudio_Runtime"]
        PS6["PS_Provisioning_Manager"]
        PS4 & PS5 --> PSG2["PSG_Provisioning_Specialist"]
        PS4 & PS5 & PS6 --> PSG3["PSG_Provisioning_Lead"]
    end

    subgraph Support
        PS7["PS_Support_Tier1"]
        PS8["PS_Support_Tier2"]
        PS7 --> PSG4["PSG_Support_Agent_T1"]
        PS7 & PS8 --> PSG5["PSG_Support_Agent_T2"]
    end

    subgraph Billing
        PS9["PS_Billing_ReadOnly"]
        PS3b["PS_Reports_PowerUser"]
        PS9 & PS3b --> PSG6["PSG_Billing_Analyst"]
    end

    PS10["PS_Escalation_Reviewer<br/>(standalone — layered on top<br/>of any base PSG above)"]

    classDef ps fill:#3C3C3C,color:#fff,stroke:none
    classDef psg fill:#8C5B1B,color:#fff,stroke:none
    class PS1,PS2,PS3,PS3b,PS4,PS5,PS6,PS7,PS8,PS9,PS10 ps
    class PSG1,PSG2,PSG3,PSG4,PSG5,PSG6 psg
```

## Sharing rules (lateral access, layered on top of Private OWD)

```mermaid
graph LR
    C1["Case: Record Type = Service Outage<br/>AND Priority = Critical"] -->|Read/Write| G1["Escalation Reviewers"]
    O1["Service_Order__c owned by<br/>Provisioning role + subordinates"] -->|Read only| G2["Regional Sales - North"]
    O1 -->|Read only| G3["Regional Sales - South"]
    A1["Account: Type = Business Customer<br/>AND Region__c = North"] -->|Read/Write| G2
    A2["Account: Type = Business Customer<br/>AND Region__c = South"] -->|Read/Write| G3

    classDef rule fill:#5B3B8C,color:#fff,stroke:none
    classDef group fill:#0E7C6B,color:#fff,stroke:none
    class C1,O1,A1,A2 rule
    class G1,G2,G3 group
```

**Why Private OWD + explicit sharing rules, instead of a more open default:**
every custom object here defaults to `Private` (see each object's
`sharingModel` in `force-app/main/default/objects/*/`). That only makes
sense paired with sharing rules that deliberately re-open specific,
justified slices of visibility — which is what the three rules above do.
An org-wide default of `Public Read/Write` would make the sharing rules
meaningless (everyone could already see everything), so the two decisions
are made together, not independently.
