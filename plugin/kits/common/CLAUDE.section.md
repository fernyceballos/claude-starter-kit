# How we work in this folder (starter kit)

A new chat remembers nothing from earlier chats. The files in `docs/` are this folder's
memory. If a fact or decision isn't in them, assume you don't know it.

## First: read the record (every chat, before doing anything)

0. `docs/KICKOFF.md` — only if it exists. It's a handoff from an unfinished chat. Read it
   first, and delete it once the work it describes is done.
1. `docs/STATUS.md` — where things stand right now.
2. `docs/SESSION_LOG.md` — the newest 2–3 entries.
3. The playbook in `docs/playbooks/` for the task at hand, if there is one.
4. `docs/MAP.md` only when you need an account, URL or ID.

## Record files

Keep these true. `wind-down`, `continue-in-new-session` and autopilot read this table to
know what to update.

| File | Update when |
|---|---|
| `docs/SESSION_LOG.md` | Every chat. New entry at the top, in the format at the top of that file. |
| `docs/STATUS.md` | What's live, what's open, or what's blocked changed. |
| `docs/BACKLOG.md` | New to-dos, or items finished (flip `[ ]` to `[x]` with the date). |
| `docs/DECISIONS.md` | A choice was made that someone could later re-open. Say why. |
| `docs/LESSONS.md` | Something went wrong or was harder than expected. Write the pattern, not the story. |
| `docs/MAP.md` | A new account, URL, ID or live thing exists. Never secrets. |
| `docs/playbooks/` | We found a repeatable way to do something. |

## How to work with the person

- **One chat = one job.** When a job is done, wind down and start a fresh chat for the next one.
- **Talk new work through first.** For anything new, use the brainstorming skill so you agree
  on what's wanted before building. If the person says **"just start"**, skip the questions:
  make sensible choices, build, and list what you picked so they can change it.
- **Recommend, don't quiz.** Lead with what you'd do. At most 3 questions per turn, each with
  1–2 sentences of context and your recommended answer. Don't re-ask what's already decided
  (check `docs/DECISIONS.md` first).
- **Define "done" before you start, then prove it.** Say how you'll check it works, check it
  on the real thing, and report failures plainly.
- **Change only what was asked.** If you notice something else that looks wrong, mention it.
  Don't fix it unasked.
- **No secrets in files.** No passwords, API keys, tokens, or links that contain a token. Say
  where the secret lives instead.
- **Messages for other people go in a code box,** one box per message, plain text inside, so
  the person can copy it straight into email or chat.

## Approval gates — a "yes" in chat first

Get a clear yes **in this chat** before any of these. A yes covers that one action, not the next.

- Sending anything to real people or the public (email, texts, DMs, posts).
  Show the exact text and who gets it; the person approves that exact text.
- Publishing or changing anything live.
- Deleting anything.
- Anything that spends money or touches billing.

The `getting-approval-before-live-changes` skill has the details.

## The phrases

The person can start a message with any of these:

- **"wind down"** — the job is finished: update the record, then close out.
- **"continue in new session"** — the chat is getting full but the job isn't done: hand off cleanly.
- **"autopilot dev"** / **"autopilot prod"** — after a feature has been talked through: build
  and test it without more questions (dev stops before anything goes live; prod goes live).
- **"bumper sticker"** — say the last answer again, short and simple.
- **"coach me"** — the walkthrough of how to work with Claude.
- **"show me the guide"** — the field guide: every phrase on one page they keep (the `guide` skill).
- **"start a project"** / **"upgrade this project"** — set up or grow a folder.

A phrase only counts when the message **starts** with it. Talking *about* a phrase isn't a command.
