---
name: backlog-digest
description: Use when the person asks for a "backlog digest", "backlog review", "review the backlog", "what's on the shelf", or "go through the backlog". Each run sweeps finished items out of docs/BACKLOG.md into the archive, checks every picked item against the record (and git in code folders) so already-done work is proposed for closing instead of pitched again, walks the person through up to 10 shelved items in plain English with one call each (build soon / keep sleeping until a date / kill it), records every verdict in docs/backlog-digest.json so nothing is pitched twice, and applies the answers to the backlog. Do NOT fire for a question about one specific item (answer it, then offer to record the outcome), and never build anything in the same chat.
---

# Backlog digest — a regular review of shelved work

A backlog grows forever, nobody re-reads the middle of it, and shelved work either rots or gets
rebuilt from scratch because everyone forgot it was already decided. This skill does three jobs:
**sweep** finished work out, **re-surface** a rotating batch of shelved work in plain English, and
**record every verdict** so nothing is pitched twice. It gathers, recommends and records. **It
builds nothing.** Building gets its own chat.

## The files

- `docs/BACKLOG.md`: the human-readable status of record, with `## Now`, `## Next` and
  `## Shelved` sections. Lines look like `- [ ] item — added YYYY-MM-DD`, `- [~] item — in
  progress: …`, `- [x] item — done YYYY-MM-DD`.
- `docs/BACKLOG-ARCHIVE.md`: finished and killed items, newest first. Create it on the first run
  with a one-line header.
- `docs/backlog-digest.json`: bookkeeping for Claude only (last-shown dates, verdicts, wake dates).
  Every outcome a person should see also lands in BACKLOG or the archive, never only here.
- **Nothing is ever deleted.** Killed items move to the archive with the person's reason.

## Step 0 — read and sweep

1. Read `docs/BACKLOG.md`, the archive's top, `docs/backlog-digest.json` (if it exists),
   `docs/STATUS.md`, and the newest 3 SESSION_LOG entries.
2. **Sweep:** move every `[x]` line dated more than 14 days ago into the archive, word for word,
   newest first. Leave `[ ]` and `[~]` lines where they are. A `[x]` line whose text still
   describes live work ("waiting on…", "not sent yet") stays put and gets mentioned in the digest.
3. **Count check (say the counts in chat):** the number of `[ ]` and `[~]` lines must be the
   same before and after the sweep, and every moved line must appear unchanged in the archive.
   If anything doesn't match, stop and fix it. A janitor that mangles the record is worse than none.

## Step 1 — health check

Open with 2–3 plain lines: how many items are open and in progress, how many wake dates have
arrived, days since the last digest. **Say which way the list is moving:** compare today's
counts with the ones stored last time and report added, closed and the net. On the first run,
say there's no baseline yet.

## Step 2 — pick the batch (up to 10)

1. **Woken up first:** every shelved item marked `PARKED until <date>` whose date has arrived.
2. **Up to 3 "best chances right now":** your judgment of the highest value today, any age.
3. **Fill the rest with the oldest never-reviewed items**, so nothing hides forever.

Never re-pitch an item whose verdict is `build-soon`, `sleep` (not yet woken) or `kill` unless
something visibly changed, and then say what changed. Items shown with no verdict come back
after everything never-shown has had a turn.

**Then check every picked item before pitching it (no exceptions).** Look for proof it's already
done: the SESSION_LOG, STATUS, the real page or setting, and in code folders
`git log --oneline --all -i --grep "<key words>"` and the code itself. Proven-done items become
**propose to close** entries with their proof, not pitches. Partly done → pitch only what's left.
**Positive proof only**: finding nothing proves nothing, so an unsettled item is pitched normally
with no claim attached. Say how many you checked and how many turned out already done.

**Never pitch something that's stuck behind something else.** If an item needs another open item,
a decision, or someone else's step first, pitch the blocker instead and say what it unblocks.

## Step 3 — decisions waiting (up to 3)

Take the 3 oldest lines under "Blocked / waiting on the person" in `docs/STATUS.md`. For each,
first check it still matters. A question that no longer matters is "propose to close, here's why",
not asked again. Live ones use four parts: the question / the context they need / what you'd pick
and why / how sure you are (high, medium, coin-flip).

## Step 4 — the digest message

ONE message, plain English, no file paths, no jargon:

- The health check.
- **Propose to close**: proven-done items first, one line of proof each.
- Per item: **What it is** (1–2 sentences) · **Why it was shelved** (1 sentence) · **What it's
  worth today** (in business terms) · **Size** (XS / S / M / L; mark it as an estimate when the
  backlog doesn't say) · **My call**: exactly one of **Build soon** / **Keep sleeping** (suggest a
  wake date) / **Kill it**, with a one-sentence reason. Every Build soon adds one line on what it
  would take.
- The decisions section.
- One line on how to answer: item names plus verdicts is enough, and partial answers are fine.

## Step 5 — apply the answers (same chat)

- **Build soon** → move the line to `## Now` (or `## Next`) with `(promoted, digest <date>)`.
- **Keep sleeping** → the line gains `PARKED until <date> (digest <date>)`. No date given →
  suggest one and use it. The wake date lives in the line itself, so it's visible without the index.
- **Kill it** → move the line to the archive with `CLOSED <date>: <their reason>`. Closed on
  proof instead → `CLOSED <date>: already done — <proof>`.
- **Decisions answered** → write the answer in `docs/DECISIONS.md`, remove the line from STATUS,
  and update any item it unblocks.

Then update `docs/backlog-digest.json` for EVERY item shown (refresh `lastShown` even with no
verdict, so the rotation stays fair), set `lastRunAt`, store this run's `counts`, bump BACKLOG's
"Last updated", and commit if this folder is a git repo.

## Index format (`docs/backlog-digest.json`)

```json
{
  "lastRunAt": "2026-08-20",
  "counts": { "open": 31, "wip": 2 },
  "prefs": { "batchSize": 10 },
  "items": {
    "2026-07-30-welcome-email-series": {
      "title": "Three-email welcome series for new sign-ups",
      "lastShown": "2026-08-20",
      "verdict": "sleep",
      "wakeDate": "2026-10-01",
      "note": "after the new offer launches",
      "decidedAt": "2026-08-20"
    }
  }
}
```

Item keys are the item's added-date plus a short slug of its title. Verdicts: `build-soon` /
`sleep` / `kill` / `shown-no-verdict`. If the person asks for a different batch size, store it in
`prefs.batchSize` and don't ask again.
