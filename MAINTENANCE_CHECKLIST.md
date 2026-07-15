# Maintenance Checklist

Runs after the project is live and looking for clients — keeps it that
way without turning into a second job.

## Weekly

- [ ] `Get-CareerIntelligenceStatus.ps1` — confirm Health: OK, Consecutive
      Failures: 0. If not, read the referenced log before doing anything else.
- [ ] Skim the last 7 days of `automation/logs/` for repeated WARN/ERROR
      lines that succeeded anyway (a pattern worth fixing even if nothing's
      on fire yet).
- [ ] Check Fiverr/Upwork inbox and respond to anything pending within 24h.
- [ ] Post at least once on LinkedIn (from the 30-day content calendar,
      once that exists) and spend 10-15 min engaging with 2-3 other
      Salesforce professionals' posts.
- [ ] Glance at `git log --oneline -10` on the public repo — confirm
      nothing got pushed there by accident that shouldn't be public.

## Monthly

- [ ] Re-run the security sweep from `SECURITY_AUDIT_REPORT.md`'s
      methodology section against current state — a repo that was clean
      once can drift if new files get added without thinking about it.
- [ ] Review Fiverr/Upwork earnings and review counts — is pricing still
      right, or is one gig clearly outperforming and worth doubling down on.
- [ ] Review `project_memory/BD_SCAN_STATE.md` and
      `LINKEDIN_SCAN_STATE.md` — is the automated pipeline actually
      producing leads, or just bookkeeping. If it's just bookkeeping for
      more than a month, that's the signal to unblock the Playwright/
      browser-tool question, not to let it keep running quietly.
- [ ] Check `sf org list` — Scratch Org expiration dates, Dev Hub license
      usage; recreate `meridian-demo` before it expires if you want the
      live demo link to keep working.
- [ ] Revisit `ROADMAP.md` — anything on it stop being relevant, or did
      real client conversations surface something more useful to build?

## Quarterly

- [ ] Full re-read of `MARKETING/` (local-only, not in the public repo)
      against what's actually live on Fiverr/Upwork/LinkedIn — pricing,
      positioning, and competitors all drift over a few months.
- [ ] Reconsider whether the Meridian portfolio itself needs a second
      example (new object, new flow) — only if a real client conversation
      showed a gap, per this project's own rule: improvements are
      justified by client impact, not technical completeness.

## Non-negotiables

- Never re-add `MARKETING/` to git tracking on the public repo — see
  `SECURITY_AUDIT_REPORT.md`, finding #1.
- Never publish a new artifact (portfolio update, screenshot, gig image)
  without a quick pass for real client identifiers, matching this
  project's own confidentiality ground rules in `ARCHITECTURE.md`.
- If Career Intelligence's consecutive-failure count crosses 2, stop and
  read logs before assuming it's fine — see
  `automation/README.md`'s recovery checklist.
