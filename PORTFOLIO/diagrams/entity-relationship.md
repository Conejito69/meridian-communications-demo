# Entity Relationship Diagram

Core data model for Meridian Communications. Standard Salesforce objects
(Account, Contact, Opportunity, Case, Product2) extended with 7 custom
objects covering the fulfillment and billing lifecycle.

```mermaid
erDiagram
    ACCOUNT ||--o{ CONTACT : has
    ACCOUNT ||--o{ OPPORTUNITY : has
    ACCOUNT ||--o{ NETWORK_SITE : "service sites at"
    ACCOUNT ||--o{ SERVICE_SUBSCRIPTION : subscribes
    ACCOUNT ||--o{ SERVICE_ORDER : orders
    ACCOUNT ||--o{ BILLING_ACCOUNT : "billed via"
    ACCOUNT ||--o{ CASE : reports

    OPPORTUNITY ||--o| SERVICE_ORDER : originates

    NETWORK_SITE ||--o{ SERVICE_ORDER : "provisioned at"

    SERVICE_ORDER ||--|{ SERVICE_ORDER_LINE : contains
    SERVICE_ORDER ||--o{ PROVISIONING_TASK : generates
    SERVICE_ORDER }o--o| OPPORTUNITY : "linked from"

    SERVICE_ORDER_LINE }o--|| PRODUCT2 : references

    CONTACT }o--o| BILLING_ACCOUNT : "billing contact for"

    CASE ||--o{ ESCALATION_LOG : escalates

    ACCOUNT {
        string Name
        picklist Type "Business Customer / Partner-Reseller / Prospect / Former Customer"
        picklist Region__c "North / South"
        boolean Has_Billing_Account__c "shadow field, set by flow"
    }
    SERVICE_ORDER {
        autonumber Name "SO-00001"
        picklist Stage__c "Submitted / Provisioning / Active / Suspended / Cancelled"
        recordtype RecordType "New Service / Upgrade / Cancellation"
        number Max_Discount_Percent__c "roll-up MAX, drives approval"
    }
    SERVICE_ORDER_LINE {
        autonumber Name "SOL-00001"
        number Quantity__c
        currency Unit_Price__c
        percent Discount_Percent__c
    }
    NETWORK_SITE {
        text Site_Name__c
        text Street__c
        text City__c
    }
    PROVISIONING_TASK {
        autonumber Name "PT-00001"
        picklist Task_Type__c "Site Survey / Equipment Install / Configuration / Activation / Decommission"
        picklist Status__c
    }
    BILLING_ACCOUNT {
        text Name
        picklist Payment_Terms__c "Net 15 / 30 / 45 / 60"
    }
    SERVICE_SUBSCRIPTION {
        autonumber Name "SUB-00001"
        picklist Service_Type__c "Internet / Voice / Managed Security / Cloud Backup"
        currency Monthly_Recurring_Revenue__c
    }
    CASE {
        recordtype RecordType "Service Outage / Billing Inquiry / Provisioning Request / General Support"
        picklist Priority "Low / Medium / High / Critical"
        datetime SLA_Target_DateTime__c
    }
    ESCALATION_LOG {
        autonumber Name "ESC-00001"
        text Escalated_From__c
        text Escalated_To__c
    }
```

**Relationship types that matter architecturally:**

- `Service_Order__c` → `Service_Order_Line__c` is the only **Master-Detail**
  relationship in the model — deliberately, so `Max_Discount_Percent__c` can
  be a native roll-up summary that drives the Discount Approval process.
- Every other custom-object relationship is a **Lookup**, kept independently
  sharable rather than cascading. Where a validation rule needed to check
  across one of those Lookups (Opportunity ↔ Service Order, Account ↔
  Billing Account), a small boolean "shadow field" set by a flow stands in
  for the roll-up a Master-Detail would have given for free — see
  `ARCHITECTURE.md`.
