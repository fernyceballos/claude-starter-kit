---
name: autopilot-dev
description: Use when the person's message STARTS with "autopilot dev" (also "autopilot to dev", or just "autopilot") after a feature has been talked through in this chat — their hands-off grant to build it completely, check it end to end on dev (draft/preview/test mode, or the local dev server), decide everything without asking, and stop at "ready to go live". Do NOT fire on a mid-sentence mention ("let's not autopilot this", "what does autopilot do?") or on a question that starts with "autopilot" ("autopilot sounds scary, what is it?"), and do NOT fire for "autopilot prod" — that sibling also goes live.
---

# Autopilot dev

**REQUIRED:** read `references/autopilot-core.md` (next to this file) in full before Phase 0. It
is the procedure; this file only says how far to run it. If you can't find it, run
`starter-kit-root` and open `skills/autopilot-dev/references/autopilot-core.md` under that folder.

## Run the shared procedure through Phase 4

| Phase | Outcome |
|---|---|
| 0 Readiness | A feature was talked through; browser or dev server ready |
| 1 Spec from the chat | `docs/specs/…` written, not shown for approval |
| 2 Build | Dev only (draft/preview, or the local dev server) |
| 3 Check it yourself | Every success check passes; test items marked `AUTOPILOT-TEST` |
| 4 Hand-off | Logged; one message with "What to try" and "What happens when it goes live" |

**STOP after Phase 4.** Nothing is published, switched on, connected, sent, merged or pushed.
Going live is `autopilot prod`, or a specific yes from the person.

## Bare "autopilot"

Treat it as `autopilot dev` and say so in one line ("Running autopilot dev: I'll build and check
it, and stop before anything goes live."). Only the word "prod" or a named go-live ("…and publish
it") goes further.

## The only interruptions allowed

The stop list in `autopilot-core.md`. Everything else (layout, wording, order, retrying a failed
build) you decide and record under **"Decisions made for you"**.

## Sibling

`autopilot-prod` = this + Phase 5 (go live, check it live, fix until clean).
