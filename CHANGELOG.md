# Changelog

Format loosely follows [Keep a Changelog](https://keepachangelog.com/).
Dated by when work actually happened, not backfilled — this project was
built across one continuous engagement rather than months of commits, and
this changelog says so plainly rather than implying otherwise. See
[PORTFOLIO/architecture/decision-log.md](PORTFOLIO/architecture/decision-log.md)
for the reasoning behind individual decisions, not just what changed.

## [Unreleased]

### Pending

- First deploy to a live Scratch Org (blocked on Dev Hub connection — see
  `PORTFOLIO/deployment/README.md`)
- Evidence library capture (18 screenshots + 2 short clips — automated,
  ready to run once an org exists)
- Experience Cloud site build (org is configured to support it, site
  itself not yet built)

## [0.3.0] — 2026-07-14 — Personal Brand & Sales Assets

### Added

- `MARKETING/` — platform-specific commercial content for Fiverr, Upwork,
  LinkedIn, GitHub, a personal website, a CV, and interview prep
- `MARKETING/Fiverr/` — finalized copy for all 4 gigs (titles,
  descriptions, FAQ, pricing, keyword separation, image prompts), closing
  out the V1→V2 audit from earlier in this project
- `MARKETING/Upwork/` — profile Headline/Overview, 3 Specialized Profiles,
  recommended copy aligned to the existing 7-item Project Catalog
- `MARKETING/LinkedIn/` — About section, Featured section plan, Skills
  list, banner concepts, a 12-post/30-day content calendar
- Root `README.md` rewritten from the default SFDX template into a real
  project overview, `LICENSE` (MIT), `CONTRIBUTING.md`, this changelog,
  and `ROADMAP.md`

### Changed

- Consolidated the earlier `SALES/` folder into `MARKETING/` to avoid
  content duplicating itself across two overlapping folders

### Fixed

- Two documentation inconsistencies in `ARCHITECTURE.md` (a field
  mistakenly tabled as an object; a dead link to a file that was never
  created)

## [0.2.0] — 2026-07-14 — Portfolio Product

### Added

- `PORTFOLIO/` — enterprise-framed README, 4 Mermaid architecture
  diagrams, an 8-entry architecture decision log, a deployment runbook, a
  packaging strategy doc, a sample-data explainer, an 18-screen screenshot
  checklist
- `PORTFOLIO_GUIDE.md` — maps every planned screenshot to Fiverr/Upwork/
  LinkedIn/interview use cases
- `DEMO/` — 5/15/30-minute interview walkthrough scripts
- `scripts/deploy-all.sh` / `.ps1` — one-command reproducible deployment
- `scripts/evidence/capture-evidence.js` + `capture-evidence.sh`/`.ps1` —
  automated screenshot and short-clip capture (Playwright-based)
- `.github/workflows/ci.yml` — lint → scratch org → deploy → test →
  teardown pipeline
- `PORTFOLIO/deployment/packaging.md` — documented rationale for staying
  single-package for now, with the real future split points identified

### Fixed

- Reformatted all 130 metadata XML files and both Apex scripts with
  Prettier, so the new CI lint step passes on first run instead of failing
  immediately

## [0.1.0] — 2026-07-14 — Core Build

### Added

- Full Salesforce Enterprise metadata for the fictional Meridian
  Communications org: 7 custom objects (38 fields), standard-object
  extensions on Account/Case/Opportunity, 9 Record Types, an 11-role
  hierarchy, 5 Public Groups, 4 Queues, 6 custom tabs, 4 validation rules,
  5 sharing-rule entries, 10 Permission Sets, 6 Permission Set Groups,
  3 Lightning Apps, 6 flows + 1 Approval Process, 6 reports, 1 dashboard
- `ARCHITECTURE.md` — full technical design document with reasoning
- `scripts/apex/generate-fictitious-data.apex` and
  `create-sample-users.apex`

### Notes

- Flows, the Approval Process, Reports, and the Dashboard were
  hand-authored directly against Salesforce's metadata XSD, since the
  environment's intended flow-generation tool wasn't available — flagged
  as the highest first-deploy risk in the project, not glossed over
