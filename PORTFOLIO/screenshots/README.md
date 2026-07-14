# Screenshot Capture Checklist

## Current status: not yet captured

This folder is empty as of this writing. That's not an oversight — there is
no live, deployed org to point a browser at yet (no Dev Hub was connected
during this build; see `../deployment/README.md` steps 1–3). Every image
requested for this folder must be a real capture of **this specific org**,
never a mockup or a stock template — so none were fabricated to fill the
gap. Once the org is deployed, this is a single focused session, not more
architecture work: navigate, capture, sanitize-check, done.

## How to capture

**Automated (recommended):** `scripts/capture-evidence.ps1` /
`scripts/capture-evidence.sh` drives all 18 screens plus two short
click-through clips automatically — see
`scripts/evidence/capture-evidence.js` for exactly what it does. One-time
setup: `npm install --save-dev playwright && npx playwright install
chromium`. It cannot capture #13 (needs a real record Id that only exists
after data load) — that one stays manual.

**Manual (fallback, or for #13):** `sf org open --target-org meridian-demo`,
then OS-native screenshot tool per screen below.

Target resolution: 1920×1080 or 1920×1200, browser maximized, light theme
(matches how Setup renders by default and is the most legible in thumbnails).

## Clips (short navigation GIFs)

`scripts/capture-evidence.*` also records two short click-through sequences
as `.webm` into `clips/`: App Launcher → Meridian Provisioning app, and the
Operations Dashboard rendering. Convert to `.gif` for LinkedIn/Fiverr, which
don't autoplay video previews the same way:

```bash
ffmpeg -i clips/app-launcher-to-service-order.webm -vf "fps=10,scale=960:-1" clips/app-launcher-to-service-order.gif
ffmpeg -i clips/dashboard-overview.webm -vf "fps=10,scale=960:-1" clips/dashboard-overview.gif
```

Keep clips under ~8 seconds — long GIFs are large and lose viewer attention
before the point lands.

## The 18 required captures

| #   | Screen                | Where                                                                                                   | Suggested filename             |
| --- | --------------------- | ------------------------------------------------------------------------------------------------------- | ------------------------------ |
| 1   | Home                  | App Launcher → any Meridian app → Home tab                                                              | `01-home.png`                  |
| 2   | App Launcher          | Click the App Launcher (grid icon), grid view open                                                      | `02-app-launcher.png`          |
| 3   | Object Manager        | Setup → Object Manager (landing list of all objects)                                                    | `03-object-manager.png`        |
| 4   | Custom Objects        | Object Manager, filtered/sorted to show the 7 custom objects                                            | `04-custom-objects.png`        |
| 5   | Record Types          | Setup → Object Manager → Service_Order__c → Record Types                                                | `05-record-types.png`          |
| 6   | Validation Rules      | Setup → Object Manager → Account → Validation Rules                                                     | `06-validation-rules.png`      |
| 7   | Permission Sets       | Setup → Permission Sets (landing list, all 10 visible)                                                  | `07-permission-sets.png`       |
| 8   | Permission Set Groups | Setup → Permission Set Groups (landing list, all 6 visible)                                             | `08-permission-set-groups.png` |
| 9   | Queues                | Setup → Queues (landing list, all 4 visible)                                                            | `09-queues.png`                |
| 10  | Public Groups         | Setup → Public Groups (landing list, all 5 visible)                                                     | `10-public-groups.png`         |
| 11  | Sharing Rules         | Setup → Sharing Settings → Account (or Case) sharing rules section                                      | `11-sharing-rules.png`         |
| 12  | Role Hierarchy        | Setup → Roles → Role Hierarchy (tree view)                                                              | `12-role-hierarchy.png`        |
| 13  | Lightning Record Page | A record detail page for Service_Order__c (default page — see `../architecture/decision-log.md` item 7) | `13-record-page.png`           |
| 14  | Reports               | Reports tab → Meridian Reports folder (all 6 visible)                                                   | `14-reports.png`               |
| 15  | Dashboard             | Dashboards tab → Meridian Operations Overview, fully rendered                                           | `15-dashboard.png`             |
| 16  | Flow Builder canvas   | Setup → Flows → Service_Order_Fulfillment_Orchestration, opened in Builder                              | `16-flow-builder.png`          |
| 17  | Approval Process      | Setup → Approval Processes → Service_Order__c.Discount_Approval                                         | `17-approval-process.png`      |
| 18  | Setup Overview        | Setup → Home (the Setup landing page itself)                                                            | `18-setup-overview.png`        |

## Sanitization verification (should be a no-op, verify anyway)

Every record in this org comes from `../sample-data/`, which is 100%
synthetic — there is no client data to accidentally expose. Before
publishing anywhere external, verify each capture against this list purely
as a safety net, not because any of these are expected to appear:

- [ ] No real person's name, email, or phone number visible
- [ ] No real company name visible (Meridian Communications and its
      fictional accounts/partners are fine — anything else is not)
- [ ] Browser chrome / URL bar cropped out (the org's `.develop.my.salesforce.com`
      domain reveals nothing sensitive, but it's not useful in the image either)
- [ ] No other browser tabs, bookmarks bar, or OS taskbar visible

## After capture: sizing for each platform

Once captured, resize/crop copies as needed — keep the originals in this
folder untouched:

- **Fiverr gig gallery**: 1280×769 (Fiverr's preferred thumbnail ratio)
- **LinkedIn post**: 1200×627 (link preview) or square 1080×1080 (carousel)
- **GitHub repo social preview**: exactly 1280×640 (Settings → Social
  preview) — use the Dashboard capture, it's the strongest single image
- **GitHub README inline**: original resolution is fine; GitHub scales to
  container width automatically, just keep file size reasonable (<500KB,
  re-export as PNG-8 or compressed PNG if a capture comes in large)
- **Portfolio site / CV**: original resolution is fine, or 1600px wide

See `../../PORTFOLIO_GUIDE.md` for which specific screens work best on
which platform and why.
