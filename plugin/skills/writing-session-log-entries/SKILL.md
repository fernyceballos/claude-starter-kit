---
name: writing-session-log-entries
description: Use when writing or updating an entry in this folder's session log (docs/SESSION_LOG.md) — a piece of work just finished, wind-down or continue-in-new-session reaches its log step, an autopilot phase needs its entry, or the person says "log this".
---

# Writing session log entries

A new chat remembers nothing. Whatever isn't in the files is gone, and the next chat will work
things out again, re-suggest rejected ideas, or redo (or undo) finished work. The log is how
work survives.

**This skill says *what to write*.** The routines that call it are `wind-down` (work finished),
`continue-in-new-session` (work not finished) and autopilot.

## Steps, in order

1. **Gather evidence, not memory.** What changed? Look at `git log` / `git status`, the files,
   and the real pages and settings. Never write from memory.
2. **Write the entry** at the top of `docs/SESSION_LOG.md`, using the format at the top of that
   file (the format lives there so it can't drift from this skill).
3. **Fill the two sections people skip:**
   - *Changed in live systems*: system · setting · **old value → new value**.
   - *Verified how*: what you checked and where, **and what you didn't check**.
4. **Update the other record files** that changed (the `## Record files` table in CLAUDE.md):
   STATUS, BACKLOG, DECISIONS (a choice someone could re-open, with why), LESSONS (pattern +
   signal + next time; merge into an existing lesson if it has the same cause), MAP.
5. **No secrets.** No passwords, tokens, or links containing a token.
6. **Kickoff prompt last** (required when handing off unfinished work): a paste-ready block with
   where things stand, the exact next action, and any warning.

## Handing off unfinished work: extras

Write down what exists only in chat: decisions the person made, things tried and ruled out (so
the next chat doesn't re-open them), anything half-applied, and anything running in the background.

## These thoughts mean STOP

| Thought | Reality |
|---|---|
| "The chat summary covers it." | Chat dies with the session. |
| "I'll write the kickoff first, it's quicker." | Update the records first; the kickoff is earned after. |
| "Nothing was really decided." | If a choice could be re-opened, it's a decision. Write it. |
| Marking half-done work as done | Write the exact stopping point. |
