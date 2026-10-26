---
name: continue-in-new-session
description: Use when the person's message starts with "continue in new session" (also "continue in a new session", "continue in a fresh session", "hand this off") because the work is NOT finished and the chat is getting full — save everything, record the work as in progress, and hand over a kickoff prompt the next chat can resume from. Do NOT fire when they also say "wind down", when they ask you to write, build or explain this skill or quote the phrase, or when they ask how it works.
---

# Continue in a new session — hand off unfinished work

`wind-down` closes work that is **done**. This hands off work that is **not**, because the chat
is getting full. A new chat starts with **no memory of this one**: anything only said in chat is
gone, half-built things look finished, and ideas the person already rejected get suggested again.

| | `wind-down` | `continue-in-new-session` |
|---|---|---|
| Work | Finished | **Half-way, maybe half-applied** |
| Backlog | `[x]` | **`[~]` with the exact stopping point** |
| Git commits | Finished work | **Commit everything, even if it's broken (label it WIP)** |
| Tests | Expected to pass | **Whatever they are, written down honestly** |
| Kickoff prompt | Optional | **Required — it's the main thing this produces** |

**REQUIRED:** use `writing-session-log-entries` for the log entry. Make one todo per step and
**don't change the order**.

## STEP 1 — Write down what exists only in this chat (FIRST)

1a. **Decisions the person made that aren't in any file**, especially things they approved that
    you have *not* built yet. Unwritten, those look like open questions next time.
1b. **Things tried and ruled out**, with the reason, marked "don't re-open".
1c. **Anything half-applied.** These are the riskiest, because they look finished: an automation
    built but not switched on or not tested, a page in draft, a rename that reached some places
    but not others, code that's half-changed.
1d. **Things still running:** a build, a scheduled send, a live automation, a dev server. Say what
    it is and how the next chat checks on it.
1e. **Lasting facts** about the person → memory now.

## STEP 2 — Snapshot where things stand, honestly

For each thing you touched: its state (live / draft / off), the **old values** for undo, what you
checked and what you didn't, and anything you know is broken and why it was left that way.
**Code folders:** run the tests (and any type check) and write down the result: what passes, what
fails, and the counts. The next chat must be able to tell problems it inherited from ones it causes.

## STEP 3 — Record it as IN PROGRESS

Use the `## Record files` table in this folder's CLAUDE.md:
- SESSION_LOG entry whose **"Left open"** section starts with "Where this stopped:" and names the
  next concrete action.
- BACKLOG: unfinished items `[~]` with the exact stopping point; finished ones `[x]`.
- STATUS: mark what's in progress and what's live right now. **Never label half-done work as done.**
- DECISIONS / LESSONS / MAP for anything new.
- **Builder folders:** STATUS must also say "`main` has unfinished work from <date>; don't push
  until it's fixed", because STEP 4 merges this unfinished work into `main`.

## STEP 4 — Save it all (git folders)

1. Commit **everything you made or changed for this job**, even if it doesn't work yet. A
   recorded broken commit beats lost work. Check `git status` first and leave out anything that
   looks like a secret (keys, `.env`) or a personal-data export (contact lists), and say so. Start
   the message with `wip:` and say what's broken (e.g. `wip: signup form — tests failing`).
2. If this chat is on its own branch (a worktree), merge this chat's branch into `main`, so the
   next chat (which starts from `main`) can see the work. This is the one other time a chat merges.
   Run the merge in the project's original folder (the first line of `git worktree list`):
   `git -C "<original folder>" merge --ff-only <this branch>`, or a normal merge if that fails.
   First check `git -C "<original folder>" branch --show-current` says `main`, and that the folder
   has no uncommitted changes; otherwise stop and tell the person. If a record file conflicts,
   keep both sides' entries (newest first) and say so.
3. **Builder folders:** the kickoff repeats the STATUS warning that `main` carries unfinished work.
4. Never push.

## STEP 5 — Leave things described, not tidied away

- List the test items you created. Leave them if the work still needs them, and say so.
- Stop the dev server and watchers this chat started, and check the port is free.
- Close the browser tabs you opened, but note which page and account the work was on.

## STEP 6 — Ask: same folder, or a fresh copy?

One question, with your recommendation:
- **A fresh chat from the desktop app** (the usual): it starts from `main`, which now has
  everything.
- **The same folder** (when the person runs Claude Code in a terminal right here): the kickoff
  says "you're already in the right folder".

## STEP 7 — The kickoff prompt (required)

Paste it in chat in a code box **and** save it to `docs/KICKOFF.md` (replace what's there),
**then commit that file and merge it into `main` exactly as in STEP 4.** The next chat starts from
`main`; a kickoff left on this chat's branch is invisible to it. It MUST contain:
1. **Goal**: one sentence on what "done" looks like.
2. **Where it stopped**: the exact next action, not a topic.
3. **Setup**: what to open or connect first (Chrome extension connected, signed in to the right
   account, the page to open, the dev server to start).
4. **Baseline**: what's live, draft, checked and unchecked right now; test results for code.
5. **Things to re-check first**: only things whose change would change the plan.
6. **Decided, don't re-open**: approvals and rejections from this chat. This section saves the
   most time.
7. **Half-done work**, named exactly.
8. **Standing rules** that mattered in this chat (approval gates, anything specific).
9. **Out of scope.**
10. **Approvals don't carry over:** publishing, messaging real people, deleting, money and
    pushing need a fresh yes in the new chat.

## The hard gate

Don't say "ready to continue" until: the snapshot and old values are written · BACKLOG and
STATUS say IN PROGRESS with the stopping point · everything is committed (and merged to `main` in
a worktree) · the kickoff is pasted in chat **and** saved · tabs you opened are closed or described.

## These thoughts mean STOP

| Thought | Reality |
|---|---|
| "I'll just describe where I got to in chat." | Chat doesn't survive. The next chat reads the files. |
| "They know what they approved." | They won't re-explain it. Write approvals down. |
| "The next chat can work out the plan again." | Working it out again re-suggests what was rejected. |
| "It's basically a wind-down." | Wind-down assumes done. Marking unfinished work done is how a later chat believes something exists that doesn't. |
| "It doesn't work yet, so I won't commit." | Commit it anyway, labeled WIP. Uncommitted work is invisible to the next chat. |

## When NOT to fire

1. **A wind-down phrase is also there.** "We're done, wind down" is a close-out.
2. **They're asking you to write, change or explain this skill or the phrase.**
3. **It's a question** ("how does continue in new session work?"). But "I'm running out of room,
   continue in new session" is the real thing.
