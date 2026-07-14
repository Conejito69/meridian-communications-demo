# Demo Scripts

Three interview-ready walkthroughs of the same project, scaled to the time
you're given. Pick based on what the interviewer/client asked for, not
automatically the longest one — a 30-minute deep dive delivered in 5 minutes
of a screening call reads as not knowing how to prioritize.

| Script                                               | Use when                                              | Covers                                                                        |
| ---------------------------------------------------- | ----------------------------------------------------- | ----------------------------------------------------------------------------- |
| [5-minute-walkthrough.md](5-minute-walkthrough.md)   | Screening call, "walk me through something you built" | Dashboard, 3 apps, one flow, the headline architecture decisions              |
| [15-minute-walkthrough.md](15-minute-walkthrough.md) | Technical round, dedicated portfolio review slot      | + data model, security model, a live record walkthrough, reports              |
| [30-minute-walkthrough.md](30-minute-walkthrough.md) | Architect/senior round, "show me everything"          | + all 6 flows, approval process, every non-obvious decision and why, Q&A prep |

## Before any of these

Have the org open and logged in **before** the call starts, on the Home tab
of Meridian Sales. Nothing kills a technical demo's credibility like dead
air while an org loads. Second monitor or a pre-arranged screen-share
window, not a browser tab you have to go find.

If there is no live org available (see `../PORTFOLIO/deployment/README.md`
if one hasn't been deployed yet), fall back to walking through the repo
itself — `../ARCHITECTURE.md` and `../PORTFOLIO/diagrams/` — and say so
plainly ("the live org isn't up in this environment, let me show you the
source and the diagrams instead"). Never bluff a demo you can't back up
live; the recovery from "the org isn't running today, here's the
architecture instead" is much stronger than a broken screen-share.

## The one thing every script assumes you can say without notes

**"Why did you build this instead of using real client work?"** — Answer
honestly: client work isn't publishable no matter how well redacted, this
demonstrates the same category of decisions without that problem, and
nothing in it is hidden or blurred because nothing in it needed to be. See
`../PORTFOLIO/README.md` "Why this project exists" for the full version —
know the short version cold.
