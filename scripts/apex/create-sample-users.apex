/**
 * Meridian Communications — sample users for demo purposes.
 *
 * Run once against a freshly deployed Scratch Org, after the Permission Sets,
 * Permission Set Groups, and Roles have deployed:
 *   sf apex run --file scripts/apex/create-sample-users.apex
 *
 * Creates one fictional user per job function, assigns their Role and the
 * matching Permission Set Group (plus PS_Escalation_Reviewer standalone
 * where noted), so the security model in ARCHITECTURE.md is demonstrable
 * end to end, not just deployed as inert metadata.
 *
 * Usernames are suffixed with the org's Id to guarantee global uniqueness,
 * since Salesforce usernames must be unique across every org that has ever
 * existed. All names, emails, and titles are fictional.
 *
 * Scratch orgs have a limited pool of extra user licenses (Developer
 * Edition-based scratch orgs typically allow a small handful beyond the
 * default admin). If this script hits a "no more licenses" error partway
 * through, comment out users past that point and re-run — each insert
 * below is independent per user.
 */

String usernameSuffix =
  '.' +
  UserInfo.getOrganizationId() +
  '@meridian-demo.invalid';
// Profile label is localized by the org's language setting ("Standard User"
// in English orgs, a translated label in other locales) -- match by
// UserLicense instead of a hardcoded English label.
Id standardUserProfileId = [
  SELECT Id
  FROM Profile
  WHERE UserLicense.Name = 'Salesforce' AND PermissionsModifyAllData = FALSE
  LIMIT 1
]
.Id;

Map<String, Id> roleIdByDeveloperName = new Map<String, Id>();
for (UserRole r : [SELECT Id, DeveloperName FROM UserRole]) {
  roleIdByDeveloperName.put(r.DeveloperName, r.Id);
}

Map<String, Id> psgPermissionSetIdByGroupName = new Map<String, Id>();
for (PermissionSetGroup psg : [
  SELECT Id, DeveloperName
  FROM PermissionSetGroup
]) {
  // Every Permission Set Group has a shadow PermissionSet used for assignment.
  PermissionSet shadow = [
    SELECT Id
    FROM PermissionSet
    WHERE PermissionSetGroupId = :psg.Id
    LIMIT 1
  ];
  psgPermissionSetIdByGroupName.put(psg.DeveloperName, shadow.Id);
}

Map<String, Id> standalonePermissionSetIdByName = new Map<String, Id>();
for (PermissionSet ps : [
  SELECT Id, Name
  FROM PermissionSet
  WHERE IsOwnedByProfile = FALSE AND PermissionSetGroupId = NULL
]) {
  standalonePermissionSetIdByName.put(ps.Name, ps.Id);
}

// ---------------------------------------------------------------------
// Define the 7 sample users: alias, first/last name, title, role dev name,
// PSG dev name, and an optional extra standalone Permission Set.
// ---------------------------------------------------------------------
List<Map<String, Object>> userDefs = new List<Map<String, Object>>{
  new Map<String, Object>{
    'alias' => 'pcastel',
    'first' => 'Priya',
    'last' => 'Castellan',
    'title' => 'Account Executive',
    'role' => 'Account_Executive',
    'psg' => 'PSG_Sales_Rep',
    'extraPS' => null
  },
  new Map<String, Object>{
    'alias' => 'mondera',
    'first' => 'Marcus',
    'last' => 'Ondera',
    'title' => 'Regional Sales Manager',
    'role' => 'Regional_Sales_Manager',
    'psg' => 'PSG_Sales_Rep',
    'extraPS' => null
  },
  new Map<String, Object>{
    'alias' => 'evosko',
    'first' => 'Elena',
    'last' => 'Vosko',
    'title' => 'Provisioning Specialist',
    'role' => 'Provisioning_Specialist',
    'psg' => 'PSG_Provisioning_Specialist',
    'extraPS' => null
  },
  new Map<String, Object>{
    'alias' => 'dfenmor',
    'first' => 'Dario',
    'last' => 'Fenmore',
    'title' => 'Provisioning Lead',
    'role' => 'Provisioning_Manager',
    'psg' => 'PSG_Provisioning_Lead',
    'extraPS' => null
  },
  new Map<String, Object>{
    'alias' => 'tbrecht',
    'first' => 'Talia',
    'last' => 'Brechtwood',
    'title' => 'Support Agent, Tier 1',
    'role' => 'Tier_1_Support_Agent',
    'psg' => 'PSG_Support_Agent_T1',
    'extraPS' => null
  },
  new Map<String, Object>{
    'alias' => 'okestrel',
    'first' => 'Owen',
    'last' => 'Kestrel',
    'title' => 'Support Agent, Tier 2',
    'role' => 'Tier_2_Support_Agent',
    'psg' => 'PSG_Support_Agent_T2',
    'extraPS' => 'PS_Escalation_Reviewer'
  },
  new Map<String, Object>{
    'alias' => 'nalderw',
    'first' => 'Naomi',
    'last' => 'Alderwood',
    'title' => 'Billing Analyst',
    'role' => 'Support_Manager',
    'psg' => 'PSG_Billing_Analyst',
    'extraPS' => null
  }
};

List<User> usersToInsert = new List<User>();
for (Map<String, Object> def : userDefs) {
  String alias = (String) def.get('alias');
  User u = new User(
    Username = alias + usernameSuffix,
    Alias = alias,
    FirstName = (String) def.get('first'),
    LastName = (String) def.get('last'),
    Title = (String) def.get('title'),
    Email = alias + '@meridian-demo.invalid',
    EmailEncodingKey = 'UTF-8',
    TimeZoneSidKey = 'America/New_York',
    LocaleSidKey = 'en_US',
    LanguageLocaleKey = 'en_US',
    ProfileId = standardUserProfileId,
    UserRoleId = roleIdByDeveloperName.get((String) def.get('role')),
    IsActive = true
  );
  usersToInsert.add(u);
}
// allOrNone=false: scratch orgs have a small, fixed pool of extra user
// licenses, so a handful of these inserts are expected to fail with
// LICENSE_LIMIT_EXCEEDED once the pool is exhausted. Each user is
// independent (per this script's own design intent), so a partial batch
// should still create everyone who fits rather than failing the whole run.
List<Database.SaveResult> userResults = Database.insert(usersToInsert, false);
for (Integer i = 0; i < userResults.size(); i++) {
  if (!userResults[i].isSuccess()) {
    System.debug(
      'User not created (' +
        usersToInsert[i].Alias +
        '): ' +
        userResults[i].getErrors()[0].getMessage()
    );
  }
}

// ---------------------------------------------------------------------
// Assign each user's Permission Set Group (+ optional standalone PS)
// ---------------------------------------------------------------------
List<PermissionSetAssignment> assignments = new List<PermissionSetAssignment>();
for (Integer i = 0; i < userDefs.size(); i++) {
  User u = usersToInsert[i];
  if (u.Id == null) {
    continue; // this user hit LICENSE_LIMIT_EXCEEDED above, nothing to assign
  }
  Map<String, Object> def = userDefs[i];

  String psgName = (String) def.get('psg');
  Id psgPermSetId = psgPermissionSetIdByGroupName.get(psgName);
  if (psgPermSetId != null) {
    assignments.add(
      new PermissionSetAssignment(
        AssigneeId = u.Id,
        PermissionSetId = psgPermSetId
      )
    );
  }

  String extraPS = (String) def.get('extraPS');
  if (extraPS != null && standalonePermissionSetIdByName.containsKey(extraPS)) {
    assignments.add(
      new PermissionSetAssignment(
        AssigneeId = u.Id,
        PermissionSetId = standalonePermissionSetIdByName.get(extraPS)
      )
    );
  }
}
if (!assignments.isEmpty()) {
  Database.insert(assignments, false);
}

// ---------------------------------------------------------------------
// Put the Tier 2 / Escalation Reviewer user into the Escalation Reviewers
// public group, and both support tiers into All Support Agents.
// ---------------------------------------------------------------------
Map<String, Id> groupIdByDeveloperName = new Map<String, Id>();
for (Group g : [SELECT Id, DeveloperName FROM Group WHERE Type = 'Regular']) {
  groupIdByDeveloperName.put(g.DeveloperName, g.Id);
}

List<GroupMember> memberships = new List<GroupMember>();
User tier2User = usersToInsert[5]; // Owen Kestrel
User tier1User = usersToInsert[4]; // Talia Brechtwood

if (
  tier2User.Id != null &&
  groupIdByDeveloperName.containsKey('Escalation_Reviewers')
) {
  memberships.add(
    new GroupMember(
      GroupId = groupIdByDeveloperName.get('Escalation_Reviewers'),
      UserOrGroupId = tier2User.Id
    )
  );
}
if (groupIdByDeveloperName.containsKey('All_Support_Agents')) {
  if (tier1User.Id != null) {
    memberships.add(
      new GroupMember(
        GroupId = groupIdByDeveloperName.get('All_Support_Agents'),
        UserOrGroupId = tier1User.Id
      )
    );
  }
  if (tier2User.Id != null) {
    memberships.add(
      new GroupMember(
        GroupId = groupIdByDeveloperName.get('All_Support_Agents'),
        UserOrGroupId = tier2User.Id
      )
    );
  }
}
if (!memberships.isEmpty()) {
  Database.insert(memberships, false);
}

System.debug('=== Sample users created ===');
for (User u : usersToInsert) {
  System.debug(u.Alias + ' -> ' + u.Username);
}
