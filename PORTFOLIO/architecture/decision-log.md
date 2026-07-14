# Architecture Decision Log

Every non-obvious call made while building this platform, with the
reasoning behind it. This is the kind of thing an interviewer asks for and
a client never sees written down — here it's written down.

## 1. Master-Detail only where a roll-up was actually needed

`Service_Order_Line__c → Service_Order__c` is the **only** Master-Detail
relationship in the custom object model; every other relationship is a
Lookup. Master-Detail was reserved for the one case where a native roll-up
summary was structurally required: `Max_Discount_Percent__c`, which drives
the Discount Approval process. Everywhere else, Lookup was chosen
deliberately so each object keeps independent, sharable ownership — a
`Service_Order__c` shouldn't vanish because someone deleted the `Account`,
and `Network_Site__c` shouldn't inherit `Account`'s sharing model wholesale.

## 2. Shadow fields instead of forcing Master-Detail for validation

Two validation rules needed to check "does a related child record exist?"
across a relationship that was intentionally kept as a Lookup
(`Opportunity` ↔ `Service_Order__c`, `Account` ↔ `Billing_Account__c`).
Since Lookups don't support native roll-ups, both cases use the same
pattern: a boolean field (`Has_Service_Order__c`, `Has_Billing_Account__c`)
set by a flow when the child record is created, checked by the validation
rule instead of the relationship directly. Documented at the point of
creation in both `ARCHITECTURE.md` and inline field descriptions, so the
"why does this checkbox exist" question is answered before anyone has to
ask it.

## 3. Private org-wide defaults, paired with sharing rules that earn their keep

Every custom object defaults to `Private`. That's only a meaningful choice
paired with sharing rules that deliberately re-open specific slices of
access for a specific reason — which is what the 3 sharing-rule policies do
(critical outage visibility for Escalation Reviewers, fulfillment status
for the matching regional sales team, account visibility by region). An
org-wide default of `Public Read/Write` would have made those rules inert.

## 4. `adhoc` approver on the Discount Approval process

Approval Step approvers can be a specific user, a user-hierarchy field, a
record's lookup field, or a queue — but **not** a Role directly. Rather than
hardcode a fictional named approver (which reads as fake in a demo org with
no real people in it) or misuse a queue built for something else, the
approval step uses `adhoc`: the submitter picks the reviewer at submission
time. That's also a legitimate, common real-world pattern for exactly this
kind of judgment-call approval, not just a workaround.

## 5. OmniStudio: a placeholder, not a guess

`PS_OmniStudio_Runtime` exists and is already wired into
`PSG_Provisioning_Specialist`, but is intentionally empty — no object or
field permissions. The OmniStudio (Salesforce Industries) managed package's
availability on this Scratch Org hasn't been confirmed yet, and referencing
its objects before the package exists would break deployment outright. The
permission set is a hook: once availability is confirmed, it gets populated
in place, and no group membership has to change.

## 6. Flows hand-authored against the metadata schema, not generated

The available flow-generation tooling required an MCP action that wasn't
present in this environment. Rather than leave automation unbuilt, every
Flow and the Approval Process were hand-authored directly against
Salesforce's own metadata XSD (fetched and read section by section — start
elements, record operations, decisions, loops, subflows, screens, approval
steps) rather than from memory. This is called out explicitly as the
highest-risk metadata in the project, since none of it has been
deploy-tested yet — see `deployment/README.md`.

## 7. Lightning Record Pages: defaults, not a guess

Salesforce's own metadata schema documents the FlexiPage component tree as
loosely typed (`processContents="lax"`) — meaning even Salesforce's own XSD
doesn't fully validate it. Combined with no live org to deploy-test against,
hand-authoring a full custom record page carried a real risk of shipping a
broken or blank page. Standard auto-generated record pages were kept
instead — fully functional, and one honest paragraph in `ARCHITECTURE.md`
beats a plausible-looking FlexiPage that silently renders empty.

## 8. Reports use plain field API names; standard objects use their legacy aliases

Custom-object reports reference columns by their normal field API name
(`Stage__c`, `Account__c`). Case and Account reports use the older uppercase
internal aliases (`CASE_NUMBER`, `STATUS`, `ACCOUNT_NAME`, `TYPE`) that
standard Salesforce report types have used since Classic and still accept
today. Both are real, both are documented choices — not an inconsistency,
a reflection of how the two report-type families actually name their
columns.
