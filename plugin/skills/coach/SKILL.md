---
name: coach
description: Use when the person says "coach me", "continue the coach", "teach me how to work with Claude", "how should I be working", "what's the process", or asks how to use wind down, continue in new session, bumper sticker, worktrees, autopilot or start a project — and when a session-start note says KIT-OFFER-COACH. Runs a short walkthrough of the working method (one lesson at a time, each with a small try-it task and a video), skips lessons that don't fit this folder, remembers progress, and answers "how do I…?" questions from the lessons.
---

# Coach — the walkthrough of how to work with Claude

The lessons are in the kit folder: run `starter-kit-root` and look in `coach/lessons/`. (If
`starter-kit-root` isn't found, the kit folder is
`{ jq -r '.plugins["starter-kit@starter-kit-marketplace"][0].installPath // empty' ~/.claude/plugins/installed_plugins.json | tr -d '\r' | sed 's|$|/.claude-plugin/plugin.json|'; find ~/Library/Application\ Support/Claude/local-agent-mode-sessions ~/Library/Application\ Support/Claude/rpm ~/AppData/Roaming/Claude/local-agent-mode-sessions ~/AppData/Roaming/Claude/rpm ~/AppData/Local/Claude-Data -path '*/rpm/*plugin_*/.claude-plugin/plugin.json'; find ~/AppData/Local/Packages -mindepth 1 -maxdepth 1 -type d | while read -r p; do find "$p/LocalCache/Roaming/Claude/local-agent-mode-sessions" "$p/LocalCache/Roaming/Claude/rpm" "$p/LocalCache/Local/Claude-Data" -path '*/rpm/*plugin_*/.claude-plugin/plugin.json'; done; } 2>/dev/null | while read -r f; do [ "$(jq -r .name "$f" 2>/dev/null | tr -d '\r')" = starter-kit ] && printf '%s\t%s\n' "$(jq -r .version "$f" | tr -d '\r')" "${f%/.claude-plugin/plugin.json}"; done | sort -t. -k1,1n -k2,2n -k3,3n | tail -1 | cut -f2`, and the state helper is its
`bin/starter-kit-state`.) The lessons are (files
`01-…md` to `08-…md`). Each has a `kits:` list at the top, then **What**, **Why**, either
**Try it now** (safe to do right here in the coach chat) or **Next time** (for a real job later),
and a `Video:` line.

## Which lessons apply here

Read this folder's CLAUDE.md for kit markers (`<!-- starter-kit:operator start -->`, and the
same for `researcher` and `builder`). A lesson applies if any of its `kits:` is in this folder.
No kit markers at all → use every lesson whose `kits:` includes `operator`, and suggest
**start a project** at the end.

**The KIT-OFFER-COACH note alone only means: offer it, in one sentence.** Start the walkthrough
when the person says yes or "coach me".

## Walkthrough mode ("coach me", "continue the coach", or a yes to the offer)

0. **Are the automatic phrases working?** Run `starter-kit-state get hooks-seen`. A date means the
   kit's automatic triggers have run on this computer: say nothing about it. If nothing prints, also
   run `starter-kit-state get last-seen-version`: when it shows a version and that isn't this kit's
   version (`$ROOT/.claude-plugin/plugin.json`), the kit was just updated: say nothing, because the
   older kit didn't keep this record and the next chat will. Otherwise nothing printed means the
   triggers don't run yet, so phrases like **wind down** won't do anything special. Tell the person in
   one or two plain lines: "Heads up: the automatic phrases aren't working yet on this computer.
   Here's the fix." Then:
   - **Windows PC:** check that `git --version` works. If it doesn't, Git for Windows is missing:
     install it with `winget install --id Git.Git -e --accept-source-agreements
     --accept-package-agreements` (say first that this accepts winget's terms for them). Then quit
     Claude fully: right-click the Claude icon by the clock → **Quit**, and open Claude again.
   - **Mac:** quit Claude fully (Claude menu → **Quit Claude**) and open it again.
   If it's still empty in the next chat, they should contact their coach (the contact in
   `~/.claude/CLAUDE.md`). Then carry on with the lessons; never hold the coaching up for this.
1. Run `starter-kit-state coach list` to see the lesson numbers already done.
2. First time: one line on what this is ("8 short lessons, about 10 minutes, one at a time. Say
   *stop* any time and *continue the coach* later").
   **The field guide comes with it:** if `starter-kit-state get guide-url` is empty (first time, or
   they started the coach before the guide existed), follow the `guide` skill
   (`$ROOT/skills/guide/SKILL.md`) now to publish it, and give the link in one line before the
   lesson: "Here's your field guide to keep: every phrase, on one page." Then show the lesson.
3. Show the **next** lesson that applies and isn't done. Show it as written: its heading, What,
   Why, and Try it now or Next time, in the lesson's own words. Keep it to one screen.
4. **Video line:** if it starts with `__VIDEO`, say "(video coming soon)". Otherwise give the link.
5. End with one line. If the lesson has **Try it now**: "Try it, or say **next** to keep going."
   If it has **Next time**: "Say **next** to keep going." Never invite them to type a lesson's
   phrase (wind down, continue in new session, start a project, autopilot) during the
   walkthrough. Those phrases do real work: wind down would close out a chat that only did the
   coach.
6. When they try it or say next, run `starter-kit-state coach mark <n>` (the number without a
   leading zero: lesson `04-…` is `4`), then go to the next lesson.
7. When every applicable lesson is done, run `starter-kit-state set coach-done yes`. Close with a
   five-line recap of the phrases (wind down · continue in new session · bumper sticker · start a
   project · and, for builders, autopilot dev), a line pointing to the field guide ("all of
   these and more are in your field guide; say **show me the guide** to open it"), and "Start a
   new chat for your first real job."

One lesson per message. Never paste several at once.

## Question mode ("how do I…?", "what does wind down do?")

Answer from the matching lesson in two or three plain sentences, then point to it: "That's
lesson 4. Say *coach me* for the full walkthrough." Don't mark anything done.

## Tone

- Short sentences, everyday words, about a 6th-grade reading level. If a technical word is
  needed, explain it in the same sentence.
- Encouraging, not cheesy. No quizzes. The "try it" is always optional, and a "next time" is
  something to do later in a real job, never in the coach chat.
- Their own words beat yours: if they say they already do something, mark that lesson done and move on.
