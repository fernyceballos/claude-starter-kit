---
name: coach
description: Use when the person says "coach me", "continue the coach", "teach me how to work with Claude", "how should I be working", "what's the process", or asks how to use wind down, continue in new session, bumper sticker, worktrees, autopilot or start a project — and when a session-start note says KIT-OFFER-COACH. Runs a short walkthrough of the working method (one lesson at a time, each with a small try-it task and a video), skips lessons that don't fit this folder, remembers progress, and answers "how do I…?" questions from the lessons.
---

# Coach — the walkthrough of how to work with Claude

The lessons are in the kit folder: run `starter-kit-root` and look in `coach/lessons/`. (If
`starter-kit-root` isn't found, the kit folder is
`jq -r '.plugins["starter-kit@starter-kit-marketplace"][0].installPath' ~/.claude/plugins/installed_plugins.json`, and the state helper is its
`bin/starter-kit-state`.) The lessons are (files
`01-…md` to `08-…md`). Each has a `kits:` list at the top, then **What**, **Why**, **Try it
now**, and a `Video:` line.

## Which lessons apply here

Read this folder's CLAUDE.md for kit markers (`<!-- starter-kit:operator start -->`, and the
same for `researcher` and `builder`). A lesson applies if any of its `kits:` is in this folder.
No kit markers at all → use every lesson whose `kits:` includes `operator`, and suggest
**start a project** at the end.

**The KIT-OFFER-COACH note alone only means: offer it, in one sentence.** Start the walkthrough
when the person says yes or "coach me".

## Walkthrough mode ("coach me", "continue the coach", or a yes to the offer)

1. Run `starter-kit-state coach list` to see the lesson numbers already done.
2. First time: one line on what this is ("8 short lessons, about 10 minutes, one at a time. Say
   *stop* any time and *continue the coach* later").
3. Show the **next** lesson that applies and isn't done. Show it as written: its heading, What,
   Why, Try it now, in the lesson's own words. Keep it to one screen.
4. **Video line:** if it starts with `__VIDEO`, say "(video coming soon)". Otherwise give the link.
5. End with one line: "Try it, or say **next** to keep going."
6. When they try it or say next, run `starter-kit-state coach mark <n>` (the number without a
   leading zero: lesson `04-…` is `4`), then go to the next lesson.
7. When every applicable lesson is done, run `starter-kit-state set coach-done yes`. Close with a
   five-line recap of the phrases (wind down · continue in new session · bumper sticker · start a
   project · and, for builders, autopilot dev), and "Start a new chat for your first real job."

One lesson per message. Never paste several at once.

## Question mode ("how do I…?", "what does wind down do?")

Answer from the matching lesson in two or three plain sentences, then point to it: "That's
lesson 4. Say *coach me* for the full walkthrough." Don't mark anything done.

## Tone

- Short sentences, everyday words, about a 6th-grade reading level. If a technical word is
  needed, explain it in the same sentence.
- Encouraging, not cheesy. No quizzes. The "try it" is always optional.
- Their own words beat yours: if they say they already do something, mark that lesson done and move on.
