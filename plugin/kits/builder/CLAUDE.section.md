# Builder kit: an app, portal or site with code

In this folder, Claude writes code. The tech stack isn't chosen yet if this list is empty;
choose it in the first brainstorm about what's being built, and record it in `docs/DECISIONS.md`.

- Stack: (not chosen yet)
- Where it runs live: (not set up yet)
- Dev server command and port: (not set up yet)

## Change only what was asked

Every changed line should trace back to the request. Don't reformat, refactor or "improve"
nearby code. Match the style of the file you're in. Clean up only what your own change made
unused. If you notice something else worth fixing, mention it instead of folding it in.

## Git and pushing

- **Each chat works on its own copy of the code** (a "worktree": its own folder and branch), so
  two chats never trip over each other. The desktop app sets this up.
- **Work stays on the chat's branch until wind-down.** `wind-down` merges this chat's own branch
  into `main`. Never merge another chat's branch unless the person asks in this chat.
- **Never push without the person's yes in this chat.** Before asking, say what the push
  carries: a push sends *everything* on the branch, not just this chat's part. If pushing
  triggers a deploy, say so.
- **Never force-push, rewrite history, or delete branches** without a yes.

## Data and databases

- **Never change a live database by hand.** Database changes go through the project's migration
  code, and every migration must be safe to run twice.
- Before any change that deletes or rewrites data, say which database you're connected to and
  how you checked. If you can't prove it isn't the live one, stop and ask.
- State the planned change and the method in chat before making it.

## Testing

- Write the test first when adding behavior (the test-driven-development skill).
- Before saying something works, run it and show the output (verification-before-completion).
  For anything with a screen, look at it in the browser.

## Cleaning up

At wind-down, stop the dev server and any background watchers this chat started, and check the
port is free.

## Recipes (bigger add-ons)

Ready-made build recipes live in the starter kit's `recipes/` folder: run `starter-kit-root` and
read `recipes/README.md` there. When the person asks for one (e.g. "add bug reports to my app"),
read that recipe and follow it through the usual brainstorm → plan → build.

## Help pages

If the app has help pages or release notes for its users, wind-down checks whether this chat's
work made any of them wrong or missing, and says so.
