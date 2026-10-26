---
name: wind-down
description: Use when the person's message starts with "wind down" (also "wind-down", "winddown", "close out the session", "end the session", or a message that is only "wrap up" / "let's wrap up" / "wrap up the session") to close out a chat whose work is FINISHED — update the record first, then clean up, then (only if needed) write a kickoff prompt last. Do NOT fire when the phrase is only mentioned or asked about ("how does wind down work?", "I use the wind down skill"), for an ordinary request that starts with "wrap up" ("wrap up the email"), for a plain "are we done?" check, or when the work is not finished (use continue-in-new-session instead).
---

# Wind down — update the record FIRST, kickoff prompt LAST

A new chat remembers nothing. If the record says "pending" for something that's done (or
"done" for something that isn't), the next chat redoes finished work, re-asks settled questions,
or trusts a wrong status. **The record is the deliverable.** A kickoff prompt is the reward you
earn only after the record is true. Doing the kickoff first is exactly the failure this skill
prevents.

**Finished or not?** If the work is NOT finished, stop and use `continue-in-new-session`
instead. If you can't tell, ask one question: "Is this finished, or are we continuing next time?"

**REQUIRED:** use `writing-session-log-entries` for the log entry. Make one todo per step and do
them **in order**.

## STEP 1 — Update the record (the step that gets skipped)

Find the record files in this folder's CLAUDE.md, in the `## Record files` table. Make each one
true about this chat. Work from **evidence** — `git log`, `git status`, the files, and the real
pages, settings and tools you touched — never from memory.

1a. **List what actually changed** in this chat and its current state (live / draft / off).
    Re-check each one on the real thing.
1b. **BACKLOG:** flip what's finished to `[x]` with the date, add new items, bump "Last updated".
    Flipping the box is the job; a note at the top is not.
1c. **STATUS:** remove what's done, move what's waiting on the person into "Blocked", and fix
    any line that says "pending / draft / not live" for something that's now live (or the reverse).
1d. **SESSION_LOG:** write the entry at the top, with old values for undo and what you did
    *not* check.
1e. **DECISIONS, LESSONS, MAP:** a choice someone could re-open, a pattern learned, a new
    URL / ID / account. Merge into an existing lesson if it has the same cause.
1f. **Playbooks:** did we find a repeatable way to do something (write one), or did one go
    stale (changed button names, paths)? State a verdict on its own line:
    `Playbooks: none needed — why`, or exactly what you changed.
1g. **Help pages (only if the CLAUDE.md has a "Help pages" section):** did this chat make any
    help page or release note wrong or missing? State a verdict on its own line.
1h. **Any other file in the `## Record files` table** that this chat changed: update it too.
    The list above is the usual set, not the whole rule.
1i. **Lasting facts about the person** (how they like to work) go to memory. Facts about this
    folder stay in its files.

## STEP 2 — Clean up, and say what you did

- **Test items you created** in the person's accounts (test contacts, drafts, test records):
  list each one and where it is. Offer to delete them; delete only after a yes. Exception: items
  an autopilot run created and marked `AUTOPILOT-TEST` are Claude's own test items, not the
  person's data. Remove those yourself and say so.
- **Scratch files you created** in this chat (in `.tmp/` or elsewhere): delete yours, and leave
  anything you can't be sure is yours.
- **Things still running:** builds, automations you turned on, scheduled sends, a dev server or
  watcher. Stop the dev server and watchers this chat started and check the port is free. Report
  anything else and how to check on it.
- **Browser:** close the tabs you opened, one at a time. Mention any other window you touched.

## STEP 3 — Git (only if this folder is a git repo)

1. Commit the finished work and the record updates on this chat's branch.
2. If this chat is on its own branch (a worktree), merge **this chat's own branch** into `main`.
   "Wind down" is the say-so for that one merge. Never merge another chat's branch.
   How: `main` is checked out in the project's original folder, not this worktree, so run the
   merge there: `git -C "<original folder>" merge --ff-only <this branch>`, or a normal
   `git -C "<original folder>" merge <this branch>` if fast-forward isn't possible. Find the
   original folder with `git worktree list` (the first line). First check
   `git -C "<original folder>" branch --show-current` says `main`, and that the folder has no
   uncommitted changes; otherwise stop and tell the person instead of merging.
3. If a record file conflicts in the merge, keep **both** sides' entries in order (newest first)
   and say so in the final message.
4. **Never push** unless this is a builder folder and the person says yes in this chat.

## STEP 4 — Is a next chat needed? (default: NO)

Ask yourself: *"If we closed this and didn't come back for two weeks, what would actually be
broken or worse?"* If the honest answer is "nothing", say so and don't invent work. If a stale
`docs/KICKOFF.md` exists, delete it, **then commit the deletion and merge it into `main` the same
way as STEP 3**. Otherwise the next chat starts from `main`, finds the old kickoff, and follows it.

## STEP 5 — Kickoff prompt LAST (only if STEP 4 = yes)

A paste-ready block in a code box, also saved to `docs/KICKOFF.md`: the goal, the exact first
action, what to check before acting, what's out of scope, and any warning. **Then commit
`docs/KICKOFF.md` and merge it into `main` the same way as STEP 3**, because the next chat starts
from `main` and won't see it otherwise.

## Final message (plain English)

What's done and live · what's still a draft · what's waiting on the person's yes · test items
left in their accounts · what landed on `main` (and that nothing was pushed) · the playbook
verdict (and help verdict, if any).

## The hard gate

Don't say "wound down" until: everything (including any KICKOFF.md change) is committed and, in a
worktree, merged into `main` · STATUS and BACKLOG match reality **and** carry today's date · the
log entry has old values and "not checked" · the playbook verdict is stated · test items and
running things are reported · tabs you opened are closed.

## These thoughts mean STOP

| Thought | Reality |
|---|---|
| "The log entry is the record." | STATUS and BACKLOG are what the next chat scans. An entry without the box flips is how done work looks open. |
| "I'll write the kickoff first while it's fresh." | Kickoff is last. Changing the order is the failure. |
| "STATUS is roughly right." | "Roughly" is how stale lines mislead. Check the real thing. |
| "Nothing changed that needs a playbook." | Say that verdict out loud. Silence isn't a verdict. |
| "They're in a hurry." | The hurry is why the record matters; the kickoff is the optional part. |
| "The summary in chat covers it." | Chat dies with the session. Write it to the files. |
| "I remember what shipped." | Check git and the real thing. Memory is wrong more than you think. |
