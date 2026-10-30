---
kits: [builder]
---
# Each chat gets its own copy of the code

## What
In a builder folder, every chat works on **its own copy** of your project (called a "worktree").
Changes stay in that copy until you say **wind down** (or **continue in new session**). Then
they're added to the **main version**, the one copy every new chat starts from. Nothing goes live
until you say yes to a **push**: sending the main version to where your app runs for real.

## Why
You can have two chats working at once without them stepping on each other. If a chat goes
wrong, the main version is safe.

## The order of a builder job
1. Talk it through (Claude asks questions).
2. Claude builds and tests on your computer.
3. You try it.
4. **wind down** → it joins the main version.
5. You say yes to a push → it goes live.

Feeling confident after a few weeks? Type **autopilot dev** after you've talked a feature through,
and Claude builds and tests it on your computer without asking more questions. It stops before
anything goes live.

## Next time
Next time you start a new chat in this folder, look at the top of the chat for a name like
`claude/fix-signup-form`. That's that chat's own copy (its "branch").

Video: __VIDEO_07__
