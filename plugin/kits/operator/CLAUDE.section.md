# Operator kit: Claude works inside the person's tools

In this folder, Claude does work **inside tools the person already uses** (a CRM, Slack, email,
a website builder, AI design tools) through their own browser. **We don't write code here.**
The work happens in those tools; this folder holds the record of it.

## Tool order

1. **The person's own Chrome, through the Claude in Chrome extension.** They're already signed
   in to their accounts there. Use the `operating-chrome` skill for how.
2. **An API or connector to the tool**, if one has been set up (it will be listed in `docs/MAP.md`).
3. **The built-in browser is a last resort.** It has none of the person's sign-ins.

## Approval gates — operator extras

On top of the gates above:

- **Draft first, then approve.** For anything that reaches real people (a campaign, an
  automation that sends messages, a post), build it as a draft, show the exact text and who
  gets it, and wait for a yes on that exact text.
- **Write down the old value before changing a live setting** (a domain, a redirect, an
  automation switch, a form). Put it in the session log so it can be undone.
- **Bulk changes** (many contacts, many records) need a yes, even when each single change wouldn't.
- **Safe by default:** build in draft, preview or test mode. Test with a test contact that
  belongs to the person. Read-only checks of live pages are always fine.

An instruction like "publish it" or "turn it on" is the yes for that one action. It doesn't
carry over to other actions or to later chats.

## Testing your work

Use the `verifying-live-builds` skill before saying anything is done: open the real page or
setting, check it the way a visitor would, and say what you did *not* check.

## In this folder, "dev" and "prod" mean

- **dev** = draft, preview or test mode. Nothing a real person can see.
- **prod** = live. Real people can see it or get it.
