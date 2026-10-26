# Autopilot — the shared procedure behind `autopilot dev` and `autopilot prod`

This file is the procedure. `autopilot-dev` and `autopilot-prod` are thin triggers that say how
far to run it: **dev stops after Phase 4; prod also runs Phase 5.** Read this whole file before
Phase 0. Make one todo per phase.

**What "dev" and "prod" mean depends on the folder** (check the kit sections in CLAUDE.md):
- **Operator folders:** dev = draft, preview or test mode (nothing real people can see or
  receive). prod = live (published, switched on, connected, reachable by real people).
- **Builder folders:** dev = the local dev server and test data. prod = pushed to the branch that
  deploys, running for real users.

## What the person granted, in one paragraph

By typing the phrase they said: *take what we just talked through and finish it: build it, check
it yourself end to end, make every design and wording decision yourself, fix every problem you
meet, and don't ask me anything unless it's on the stop list.* For `autopilot prod` they added:
*then put it live, check it live, and keep fixing until it's clean.* Their only job afterwards is
to try it like a visitor or customer and say whether they like it.

**Breaking the letter of this is breaking its spirit.** A question you "just wanted to check" is
a violation. A phase you skipped because everything else passed is a violation.

## Stop list — the ONLY reasons to pause

Stop, leave things in the safe state (below), say in plain English what the decision is and what
you'd pick, then wait.

| # | Stop when… |
|---|---|
| 1 | You would DELETE or overwrite existing live data (contacts, records, pages, automations, DNS records, database rows) beyond what this build replaces. Removing your own test items is fine. |
| 2 | It touches money: billing, plan upgrades, payment settings, prices people see or pay, credits or refunds. |
| 3 | Real people would get a message (email, text, DM, post) that isn't the feature's own agreed audience, or the audience is bigger than agreed. |
| 4 | A domain, DNS, or email-sending change is needed. |
| 5 | A bulk edit of existing records is needed. |
| 6 | A sign-in, 2-step code, CAPTCHA or permission box appears. Those are the person's to complete. |
| 7 | No feature was talked through in this chat (Phase 0). |
| 8 | Reality contradicts what you were told, or the job is far bigger or different than described, **or the agreed go-live target is blocked**. Don't swap in a different target. |
| 9 | (builder) A database change that isn't purely additive (dropping, renaming, rewriting existing data), any hand-made change to a live database, or a force-push / history rewrite. |
| 10 | (builder, `prod`) The branch you'd push carries commits that aren't from this chat. A push sends all of them. |
| 11 | (`prod`) The feature can only be tested live by changing real people's records or sending real messages. |
| 12 | (`prod`) A fix during the live loop needs any of rows 1–5 or 9. |

**Named-in-the-grant exception.** A stop item is pre-approved only if the *same message that gave
the grant* names that exact action and target (for example "autopilot prod — and connect
mydomain.com"). Quote that line in the session log. Anything not named still stops you.

**NOT stop points:** layout, wording within what you were given, order, naming, structure;
failed or flaky builds (retry); bugs and errors (fix them); unpublishing or switching off
something *you* just turned on, to get back to a safe state.

**Safe state.** On dev, everything stays in draft or local and is reported. On prod, never leave
the live thing *harmfully* broken while you wait. If it's live and broken in a way that hurts
people (errors, broken forms, wrong content, unwanted sends) and the fix hits a stop item:
**pause, unpublish or revert first** (undoing your own action is always allowed), then report. If
it's only cosmetic, holding *is* the safe state: report and wait.

## These thoughts mean DECIDE, not ask

| Thought | Reality |
|---|---|
| "They said don't bug me, so I'll email the existing list." | Stop 3. The grant covers the feature's audience, not a bigger one. |
| "It's their domain; the DNS record is one line." | Stop 4, unless the grant message named it. |
| "The card's on file, upgrading is easy." | Stop 2. A saved card isn't permission to spend. |
| "Two layouts are equally good." | Pick the simpler one for someone who's never seen it. Record the other under "Decisions made for you". |
| "I'll show the plan quickly for a nod." | No. Write it down and build. |
| "The target is blocked, so I'll go live somewhere else." | A different target is a different go-live. Hold the feature and report. |
| "One part can't go live yet, but the other part is ready." | Never leave a feature half-live. Parts that depend on each other wait together. |
| "Everything passes; the live check is extra." | The live check is the only one that touches the real thing. It's a phase, not a nicety. |
| "A fresh chat would check this better." | That's putting it off. Run the phase. The only real handoff is a full chat, via `continue-in-new-session`, with the phase marked NOT done. |
| "If you'd rather I push through, say the word." | That's a question. Do the phase. |
| "I'll test with a real contact; my test one has no history." | Test items belong to the person and are marked `AUTOPILOT-TEST`. |
| "I'll update the log at the end." | Log as you go. A crash loses everything. |

## Red flags — you're about to break the grant

- A message ending in a question mark that isn't on the stop list.
- "Shall I…", "Do you want…", "Which of these…", "Does this look right so far?", "say the word and I'll…"
- Handing off with a phase not run because "everything else passed".
- Switching something on "just to see if it works" with real people attached.
- Made-up content written into a real page, a real contact, or the person's real account.

---

## Phase 0 — Readiness (minutes, never a gate)

1. **A feature must have been talked through in this chat.** None → stop 7, in one line. Never
   pull one from the backlog instead. **A question is not a command:** if the message that
   mentions autopilot is asking about it ("autopilot prod? what does that do"), answer the
   question and don't run anything.
2. **Browser:** if the work needs the person's accounts, load the Claude in Chrome tools, work in
   your own tab, check it's visible and on the right account (`operating-chrome`). Not connected →
   say so ONCE, keep planning, check again at Phase 3.
3. Read STATUS, the newest SESSION_LOG entries, and the relevant playbook.
4. **Builder:** check the dev server runs from THIS folder (not another copy), and note the test
   results before you start, so you know which failures were already there.
5. One line to the person: what's being built, which phases will run, and that there will be no
   questions. Then go.

## Phase 1 — Spec from the chat

Write `docs/specs/YYYY-MM-DD-<topic>.md`:
- what was talked through, word for word where it matters;
- every gap the chat left, filled with your decision, marked **decided for you**;
- what will be touched and what will **not** be;
- the audience: who could see or receive anything;
- the **success checks** (the definition of done, per `verifying-live-builds`);
- how to undo it.

Don't show it for approval.

## Phase 2 — Build (dev only)

- **Operator:** build in draft, preview or test mode. Nothing real people can see or receive.
  Large builds go in stages (first the page, then fixes, then polish). Give builders exact text,
  links and image addresses.
- **Builder:** write a short plan, then build with tests (write the test first). Commit as you go
  on this chat's branch.
- Log decisions as you go.

## Phase 3 — Check it yourself, end to end (`verifying-live-builds`)

Check every success check from Phase 1, with code where you can: every page, links, forms (with
the test contact), phone width, no broken images. **Builder:** run the tests, then use the app in
your own browser like a user would, then again in the person's Chrome if it needs their sign-in.
Mark every test record `AUTOPILOT-TEST`. Fix and re-check until clean; each fix re-runs the checks
it affects.

## Phase 4 — Hand-off on dev (`autopilot dev` ENDS here)

1. **Nothing live.** Operator: everything stays draft or preview. Builder: committed on this
   chat's branch, dev server left running for the person to try, nothing merged, nothing pushed.
2. SESSION_LOG entry **with a "Decisions made for you" section** (one line per judgment call and
   the option you didn't pick). BACKLOG: `[~]` "built and checked on dev, waiting to go live".
   Update STATUS and MAP.
3. Final message: what was built, the link, then **"What to try"**: 3–6 bullets from a visitor's
   or customer's point of view · **what happens when it goes live** (who, what, when) · what you
   did **not** check. No questions.

## Phase 5 — Go live (`autopilot prod` ONLY)

1. **Before going live.** Write down the old value of anything the go-live replaces. Confirm the
   audience and content match what was talked through. Re-scan the stop list; anything it catches
   stops you (unless the grant named it).
   **Builder extras:** merge this chat's branch into the branch you'll push. Check what the push
   carries: the list of commits not yet pushed must be ONLY this chat's (else stop 10). Any
   database change in it must be additive and safe to run twice (else stop 9).
2. **Go live** with the feature that was talked through, and nothing else, **at the agreed
   target**. Operator: publish or switch it on. Builder: push. The typed `autopilot prod` is the
   authorization for this feature in this chat: the first go-live, re-publishes or pushes of fixes
   for it, and pausing, unpublishing or reverting to get back to a safe state. It does not cover
   another feature, another chat, or any stop item.
3. **Prove it landed.** Builder: check the deploy finished using something the change itself
   causes, like the new text on the live page or the new behavior. A "healthy" status page proves
   nothing. Operator: load the real address.
4. **Check it live**, in the person's Chrome: the pages, deeper pages, redirects, forms into the
   test contact, automations with **only the test contact**. After a domain change: the bare
   domain, a deeper page, and the `www` version.
5. **Fix loop:** fix on dev → re-check → go live again → re-check live. Until clean.
6. **Remove `AUTOPILOT-TEST` items** through the product's own screens before the phase ends.
7. **Record:** SESSION_LOG (old values, decisions, what was checked live), BACKLOG `[x]` LIVE and
   checked, STATUS, MAP (new URLs and IDs), and a playbook if the way you did it is repeatable.
8. Final message: **live at `<url>`**, 3–6 "What to try" bullets, one line on exactly what went
   live (builder: what the push carried), and anything not checked.

### Live footprint rules

- Test contacts and accounts belong to the person; never a real customer's. Never send a real
  message "to see if it works".
- Never write made-up content into a real contact, a real page, or the person's real account.
- If honest testing needs more than this → stop 11.

## Related skills

`getting-approval-before-live-changes` (the gates behind the stop list) · `verifying-live-builds`
(Phases 3 and 5) · `operating-chrome` (browser mechanics) · `writing-session-log-entries` (the
entries) · `wind-down` (closes the chat afterwards) · `continue-in-new-session` (if the chat fills
up mid-autopilot: hand off with the phase marked NOT done).
