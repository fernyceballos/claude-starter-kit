# Recipe: bug reports + a "bug digest" for your app

**What this is:** a build recipe, not a skill. It adds a bug-report and feature-request system
to an app you're building (a builder folder), plus a `bug-digest` skill in that project that
reads the reports, gathers evidence, and gives you one prioritized summary.

**How to run it:** in your builder folder, say *"add bug reports to my app"*. Claude reads this
file, reads your codebase, and comes back with a plan before building anything (brainstorm →
plan → build, as usual). The bug-digest skill it builds goes in that project's
`.claude/skills/bug-digest/`.

**Only worth it when real people use your app** and can send you reports.

---

# Build a member bug-report / feature-request system + a "bug digest" triage skill

You are building two things in this project:
**A.** A member-facing bug report & feature request system (intake → admin
triage → member follow-up), modeled on a working system in a sibling product.
**B.** A `bug-digest` Claude Code skill that reads those reports, gathers
evidence on its own, classifies them, and hands the person one prioritized
digest with recommendations.
Everything below describes the reference implementation in detail. It runs on
a typical web stack (a React front end, a SQL database, an email-sending service, and file storage
for screenshots). **Do not assume this project uses the same stack.** Read
this codebase first, then translate the design to whatever is actually here.
Keep the data model and the workflow; adapt the plumbing.
Before writing any code: read the codebase, then come back with (1) a short plan
mapping each piece below to files in this project, (2) anything in the reference
design that does not fit this product, and (3) your answers to the open
questions at the bottom. Do not start building until the person approves the
plan.

---

## PART A — The report intake system

### A1. Data model

One table, `bug_reports`. Columns in the reference system:
Submitter identity (auto-filled when logged in, typed manually on the public form)
- submitterName (varchar 255, required)
- submitterEmail (varchar 320, required)
- membershipLevel (varchar 100, required) — plan/tier name
- tenantName (varchar 255, required) — which community/brand they're in
What happened
- pageUrl (text, required) — URL where it occurred, auto-filled from the browser
- whatTrying (text, required) — "What were you trying to do?"
- whatHappened (text, required) — "What happened instead?"
- frequency (enum: every_time | sometimes | once)
- severity (enum: blocks_me | workaround | cosmetic) — doubles as PRIORITY for
  feature requests, relabeled in the UI (game changer / would use often / nice to have)
- screenshotUrls (json array of strings)
- loomUrl (text, nullable) — optional video or document link
Classification and status
- reportType (enum: bug | feature_request, default bug)
- status (enum: open | under_review | in_progress | completed | wont_fix | duplicate, default open)
- reportNumber (int) — sequential PER reportType, so "Bug #47" and "Feature #12"
  are separate series. This is what humans call the report by.
Admin / resolution
- adminNotes (text, nullable) — internal only, never shown to the member
- resolutionNote (text, nullable) — member-facing note shown in their status tab
- notificationSent (boolean, default false) — true once the status email went out
- resolvedAt (timestamp, nullable)
Source tracking
- isLoggedIn (boolean) — submitted in-app vs. from the public form
- userId / accountId (nullable FK) — link to the real user when logged in
- tenantId (nullable FK) — so admin can filter by real tenant, not free-text name
Member follow-up
- userReply (text, nullable) — the member's reply after we post a resolution
- userRepliedAt (timestamp, nullable)
Diagnostics
- consoleErrors (text, nullable) — browser console output, capped at 20k chars
- userAgent (varchar 500) — auto-captured
- submittedAt (timestamp, default now)

### A2. Submit path

A public endpoint (no auth required, but it reads the session if there is one):
- Validates: name >= 2 chars, valid email, whatTrying >= 30 chars,
  whatHappened >= 30 chars, screenshot URLs must be valid URLs, consoleErrors
  capped at 20,000 chars.
- Assigns the next reportNumber for that reportType.
- Stamps isLoggedIn and userId from the SERVER-SIDE session, never from client
  input. Same for tenantId. This is a security rule, not a preference — a client
  must never be able to claim another user's identity or another tenant's scope.
- Inserts the row, then fires an owner notification (email/Slack) with the
  severity in the subject line so a "blocks me" report is visible at a glance.
  The notification is wrapped in try/catch and is non-fatal — a broken notifier
  must never lose a member's report.
Screenshot upload is a separate endpoint that accepts multipart image files and
returns the stored URLs, which the form then submits with the report.

### A3. The member-facing form — the UX is most of the value

The form exists in three places, all rendering the SAME component:
1. A modal, opened from a "Report a Bug" button in the app shell/header.
2. The same modal on any other major surface members live in.
3. A standalone public page (e.g. /report-bug) for people who can't log in —
   which is exactly when they most need to report something.
Three tabs everywhere: **Bug Report**, **Feature Request**, **My Submissions**.
Form details that matter:
- **The bug/feature toggle rewrites the labels.** Bug: "What were you trying to
  do?" / "What happened instead?" / "How often?" / "How severe?" Feature: "What
  would you like to be able to do?" / "How would this improve your experience?"
  / "How important is this to you?" Same columns underneath — one form, two voices.
- **30-character minimums on both text fields, with a live counter** ("12/30
  characters minimum"). This single constraint is what stops "it's broken" reports.
- **Realistic placeholder examples** in every textarea, written in the member's
  voice, referencing real product nouns. Members copy the shape of the example.
- **Screenshot guidance inline, in an amber callout, not a tooltip.** The
  reference copy tells them: show the full browser window with the URL bar
  readable; storyboard style is best — (1) where you started, (2) what you
  clicked, (3) what went wrong; and that multiple screenshots get fixes shipped
  faster than a video. Drag-and-drop plus click-to-upload, with thumbnails and
  per-file remove.
- **An optional "paste console errors" field** with plain-English instructions
  ("If you know how to open your browser's DevTools — F12, or right-click →
  Inspect → Console — paste any red error messages here. Skip this if you're
  not sure.") Optional, and explicitly safe to skip.
- **Draft persistence in localStorage**, keyed separately per report type (and
  per surface if a user can be both a member and an admin). A member who gets
  interrupted mid-report must not lose their text. Clear the draft on success.
- **My Submissions tab**: every past report as a card — type badge, status
  badge, date, the first line of what they wrote, and the team's resolutionNote
  when one exists, under a "Update from the team" heading. Members can post ONE
  reply per report from this card, which sets userReply/userRepliedAt.

### A4. Admin triage console

A single admin page listing all reports with filters for status, severity,
type, and source. Per report, the admin can see everything the member sent —
including clickable screenshot thumbnails that open full-size — and can set:
reportType, status, adminNotes (internal), resolutionNote (member-facing), and
a "send email to submitter" checkbox.
When that checkbox is ticked at save, the system emails the submitter with the
new status and the resolution note, and sets notificationSent = true.
**The "Copy for Claude" button is the highest-leverage feature on this page.**
It builds a complete markdown prompt for the report and copies it to the
clipboard, ready to paste into a Claude Code session. The payload contains:
- A directive title ("Investigate and fix: Bug #47" / "Evaluate feature request")
- Submitter block (name, email, plan, tenant, submitted-at, logged-in yes/no)
- Where it happened: page URL, **a best-guess source file for that URL**, and
  the browser user agent
- What the member said, verbatim, both fields
- Severity + frequency (or priority, for feature requests)
- Screenshot URLs, with an explicit instruction to Claude to fetch them itself
- The video link, with an instruction to process it itself
- Console errors in a fenced block, if provided
- The member's follow-up reply, if any, flagged with: "The user replied after we
  marked this resolved. Read carefully — likely 'the fix didn't work.'"
- Admin notes
- A short, codebase-specific investigation playbook (which layer to check for
  UI vs. API bugs, which commands to run to verify, and the reminder not to
  push without authorization)
The URL → source file map is a static lookup mirroring the app's routes, with
regex patterns for parameterized routes. It is a HINT — Claude verifies by
reading the file. A stale entry costs a grep, not correctness.

---

## PART B — Improvements to make over the reference system

Build these in from the start. Each is a real weakness the reference system has
either lived with or been bitten by.
1. **Screenshots optional for feature requests.** They are mandatory in the
   reference system for both types, and the triage ledger there has a recorded
   finding: multiple feature requests carry admittedly irrelevant or duplicate
   images purely to satisfy the requirement. Keep them required (or strongly
   nudged) for bugs; make them optional for feature requests.
2. **Rename the video field and validate it loosely.** The reference field is
   called loomUrl and members put Google Docs links, Drive links, and YouTube
   links in it anyway. Call it "video or document link", store a generic URL,
   and detect the provider at triage time.
3. **Auto-capture diagnostics instead of asking members to paste them.** Keep a
   small ring buffer in the client of the last ~20 console errors and last ~10
   failed network requests, and attach it automatically. Also capture: the app
   build/commit SHA (so triage knows which deploy the bug happened on), viewport
   size, and the last few in-app routes the member visited. This is the single
   biggest triage-speed upgrade over the reference system, which relies on
   members knowing what DevTools is.
4. **Capture your product's money context.** This is a funnel and commission
   product — a bug report about a payout is useless without identifiers. Attach,
   automatically, whatever is in scope on the page the member reported from:
   affiliate/partner id, order or transaction id, commission record id, payout
   batch id, funnel and funnel-step id. A "my commission is wrong" report should
   arrive with the row ids already attached.
5. **Private screenshot storage with signed URLs.** The reference system uses a
   public bucket, which is fine for its content but wrong for yours — screenshots
   of a members area and a commission dashboard contain other people's names and
   earnings. Store them privately and generate short-lived signed URLs for admin
   viewing and for the triage skill to fetch. Plan for this from day one; it is
   painful to retrofit.
6. **Make email delivery observable, and add first-response tracking.** In the
   reference system the send is best-effort inside the status update and
   swallows its own errors, so the only way to prove an email went out is to
   check notificationSent in the database. Record send attempts, failures, and
   the error text, and show them in the admin UI. Separately, add a
   firstRespondedAt timestamp so the digest can flag reports aging with no human
   reply — the reference system has no SLA visibility at all.
Two smaller ones worth doing: allocate reportNumber transactionally (the
reference computes it with a COUNT(*) query, which can collide under concurrent
submits and drifts if rows are ever deleted), and allow a threaded back-and-forth
instead of a single userReply field, since one reply is often not enough.

---

## PART C — The `bug-digest` skill

A Claude Code skill at `.claude/skills/bug-digest/SKILL.md` plus a reference
file for video processing, backed by two small scripts and a triage ledger.

### C1. Its purpose and its hardest rule

The skill turns "I have 14 unread bug reports" into one prioritized digest
where every item already has evidence attached and a recommendation.
**The core rule, stated at the top of the skill: do not assume any report
describes a real bug.** Member-reported severity is input, not verdict. The
reference system's canonical precedent: three members reported "the AI cuts off
its text mid-word." The stored replies were complete — Chrome's page-translate
feature was mangling the live stream in the browser, and the proof was visible
in the screenshots the members themselves attached. Verify against stored data
and code before believing any claim.

### C2. The selection logic — why a ledger exists

The skill must never re-evaluate the same report twice, and must never treat
already-closed reports as a backlog. Keep a machine-readable index at
`docs/bug-triage/ledger-index.json` with one entry per report:
    reportNumber, reportType, verdict, decision, decidedAt,
    lastEvaluatedAt, lastUserReplyAt, lastKnownStatus, digestDate
A pure function diffs the live rows against that index and returns which reports
to surface and why. Reason precedence: reopened > awaiting-decision >
status-changed. The rules:
- Not in the ledger and status is open-ish → reason "new"
- Not in the ledger but already closed (completed/wont_fix/duplicate) → reason
  "pre-ledger-closed". These were handled manually before the ledger existed.
  Seed them into the index as already-handled and NEVER surface them in a
  digest. (This one was an person correction in the reference system — the
  first run tried to hand him 60 closed reports as a to-do list.) Seeding still
  keeps future reply/status-change detection alive for them.
- Member replied since the last evaluation → reason "reopened". Highest
  attention: these are usually "the fix didn't work."
- Verdict is still awaiting-decision → reason "awaiting-decision". Do NOT
  re-gather evidence; just re-surface the existing verdict in the digest's
  "Decisions needed" section.
- Status changed since last seen → reason "status-changed"
Keep this function pure and unit-tested, in its own file with no I/O. A separate
fetch script owns all database and file access.

### C3. The fetch script — and its safety rails

`scripts/bug-digest/fetch-reports.ts` (adapt the path/language). It reads the
reports table, runs the diff, and writes every selected report's full row plus
the submitter's recent activity to `.tmp/bug-digest/reports.json`.
Non-negotiable safety properties, because real reports live in PRODUCTION:
- Default target is the DEV database. Hitting production requires an explicit
  flag (the reference uses `--i-know-what-im-doing-prod-target`).
- **Verify database identity BEFORE the first read, and abort on mismatch.**
  Pick a query that actually distinguishes your clusters and hard-code the
  expected values per target. In the reference system this matters more than it
  sounds: the check they used originally (hostname + database name) returned
  identical answers on both prod and dev, so it passed unconditionally and
  manufactured false confidence. Test your check by pointing it at the wrong
  database and confirming it aborts.
- SELECT-only. The skill never writes to production.
- Set the connection timezone to UTC explicitly, so timestamps don't silently
  shift by the machine's local offset.

### C4. Evidence gathering — the skill does this itself

For each selected report, working in `.tmp/bug-digest/<reportNumber>/`:
**Screenshots.** Download each URL, then actually VIEW each image with the Read
tool. A 403 or 404 is a note in the digest, not a run failure.
**Video.** Put this in `references/video-pipeline.md` so it doesn't bloat the
skill file. The pipeline, in order, stopping as soon as you have both a
transcript and viewed frames:
1. Captions without downloading:
   `yt-dlp --skip-download --write-subs --write-auto-subs --sub-format vtt -o "transcript" "<url>"`
2. Download: `yt-dlp -o "video.%(ext)s" "<url>"` — failure here usually means
   the video is private. Flag it as the one manual step; do not retry endlessly.
3. Frames, two passes, capped at ~20 total:
   scene changes — `ffmpeg -i video.mp4 -vf "select='gt(scene,0.1)'" -vsync vfr scene_%03d.png`
   fixed stride — `ffmpeg -i video.mp4 -vf fps=1/5 stride_%03d.png`
   Calibration finding worth inheriting: a scene threshold of 0.3 yields ZERO
   frames on real screen recordings — screen content changes too gradually. The
   stride pass is the reliable baseline; scene frames are a bonus. VIEW every
   kept frame.
4. Transcript fallback if step 1 produced nothing: extract audio with ffmpeg and
   send it to a speech-to-text API. If there's no key or the call fails, proceed
   frames-only and SAY SO in the digest.
Output contract: 2–3 sentences on what the video shows, quoting the member's
narration where it matters, plus anything the frames contradict or add. State
plainly when evidence was degraded.
**The member's actual data.** For any behavior complaint, read the member's real
stored records — for this product that means their orders, commission rows,
funnel events, and account state — read-only, from production. What the member
believes happened and what the system recorded are different data sources, and
the gap between them is usually the answer.
**The code.** Start from the report's pageUrl using the URL→file map as a hint,
verify in source, then check git log and your backlog for already-fixed and
duplicates.
Evidence gathering across reports is independent work — dispatch parallel
subagents for it when there are more than a handful, and keep the judgment
(classification, prioritization, the digest itself) in the main thread.

### C5. Classification — exactly one primary verdict per report

- **urgent-bug** — real; blocks members, risks data, or has wide blast radius
- **real-bug-normal** — real defect; workaround exists or blast radius is small
- **user-misunderstanding** — the system behaved correctly; the member expected
  otherwise
- **config-tune** — behaved as configured; the configuration is the real problem
- **feature-request** — score it: effort (S/M/L) × benefit (one member / a
  segment / everyone) × strategic fit
- **duplicate** / **already-fixed** — link the original report or the shipping commit
- **awaiting-decision** — evaluated, person hasn't decided yet

### C6. The digest itself — in chat, plain English, one message

Order:
ð¥ Urgent → ð§­ Decisions needed → ⚡ Quick wins → ð The rest (one line each) →
ð¤ Not a bug (with drafted member replies) → ð Duplicates / already fixed →
↩️ Reopened (member replied after resolution — read carefully) →
⏳ Aging (open past your SLA with no human reply — this uses the
firstRespondedAt field from Part B improvement 6)
Every item carries: report number, member name, one-line verdict, one-line
evidence (what the screenshots or video ACTUALLY showed), and a recommendation.
No file paths, no function names, no jargon — the person reading this is
making product calls, not reading code.
Decisions get the four-part format: the question, one or two sentences of
context, your recommendation with reasoning, and your confidence level.
If the first run selects a large backlog, triage urgent-first: a full evidence
pass on anything reading as member-blocking, a lighter pass plus an honest
"queued for a deeper look" on the tail. Never silently truncate — say what was
deferred and why.

### C7. Ledger write, then the decision loop

In the SAME session as the digest, write every evaluated report into the index
(verdict `awaiting-decision` until the person answers) and prepend a
human-readable entry to `docs/bug-triage/LEDGER.md` with the verdict, a
one-paragraph evidence summary, and links. Commit it.
Also maintain a **"Recurring confusions"** section counting misunderstanding
patterns across DISTINCT members. At 2+ distinct members hitting the same
confusion, the next digest proposes either a help article or a product fix —
the same confusion twice is a product problem, not a member problem. This
section has repeatedly been the most valuable output of the whole routine.
After the person replies:
1. Record his decisions verbatim in both ledger files.
2. Draft, per report, the new status plus a member-facing resolution note —
   plain, kind, specific. Present the batch compactly for per-item approval.
3. Apply approved items THROUGH THE ADMIN UI, never by writing SQL, so the
   existing email-notification path actually runs.
4. Fix work spawns SEPARATE sessions. The digest session does not fix things —
   mixing triage and implementation is how a digest turns into an unreviewed
   six-file diff.

### C8. Skill hygiene

The skill's description field determines when it fires. Write it to name the
real trigger phrases ("bug digest", "triage the bug reports", "morning digest")
AND its exclusions ("do NOT fire for a single report the person pasted — just
evaluate it directly, then offer to record it in the ledger; do NOT let it fix
things"). Keep SKILL.md short and procedural — around 100 lines — and push
detail into reference files it loads on demand.

---

## PART D — Guardrails that apply to all of this

- Server-derived identity only. Never accept a user id, tenant id, or plan from
  client input on the submit path.
- The triage skill is read-only against production, always, with an identity
  check that has been proven to fail when pointed at the wrong database.
- Never commit credentials or environment files.
- Screenshots and videos from a members area contain other people's personal and
  financial data — treat the whole evidence pipeline as handling sensitive data,
  and keep temp artifacts out of version control.
- Report progress honestly: if evidence was degraded, if a video was private, if
  a report was deferred — say so in the digest rather than papering over it.

---

## Open questions to answer before you build

1. Which database and framework does this project actually use, and where do the
   member-facing app shell, the admin console, and the transactional email
   sending already live?
2. Does this product have a public (unauthenticated) surface where a locked-out
   member could still file a report? If not, that's a gap worth closing —
   "I can't log in" is a bug report that can't be filed from inside the app.
3. What is the production vs. development database split, and what query
   reliably distinguishes them? (Verify it — do not trust the first check that
   looks plausible.)
4. Which money and funnel identifiers should be auto-attached to a report, and
   where in the front-end are they available at report time?
5. Who receives the new-report notification, and should "blocks me" severity
   route somewhere louder than t
