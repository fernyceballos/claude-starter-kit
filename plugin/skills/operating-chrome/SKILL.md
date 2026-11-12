---
name: operating-chrome
description: Use when using the Claude in Chrome tools in the person's own browser for any signed-in site (a CRM, website builder, email, social media, domain registrar) — and especially when typing does nothing, a tab "is not in Claude's tab group", clicks land in the wrong place, or a batch of actions times out.
---

# Operating Chrome (the person's own browser)

**REQUIRED BACKGROUND:** `anthropic-skills:chrome-browser` (loading the tools, permissions).
Full detail and the Mac-only commands: `references/chrome-gotchas.md` next to this file. This skill
is the checklist.

## Every browser task

1. `tabs_context_mcp` first (`createIfEmpty: true` if there's no group). Work in **your own tab**.
2. After going to a page, run `({vis: document.visibilityState})` in the tab. **`hidden` means
   the page will ignore typing**, even though screenshots work. Make the tab active (see the
   reference), then check again. Look-alike tabs may sit in other windows, so list them first.
3. Typing into a box (chat boxes inside frames are common): click the box, `type`, then
   **zoom-screenshot the box** to confirm the text landed before pressing Return.
4. Take a screenshot before clicking by position if the window may have changed size.
5. **The person may be using Chrome while you work.** Tabs move. Re-check right before typing.

## Tab group rules

- Closing the **last** tab breaks the group. Keep one open until you're done.
- Never close a tab in the same batch as an action that needs another tab.
- Close the tabs you opened when finished; mention any window you touched.

## Batching

- `wait` is capped at 10 seconds. Keep a batch to about a minute (6 waits); longer ones time out.
- Prefer reading page text or running JavaScript over screenshots. One site can't `fetch` another
  site's pages (the browser blocks it), so go to the page instead.

## These symptoms mean

| Symptom | Likely cause |
|---|---|
| Text never appears after `type` | Tab hidden, or the cursor isn't in the box |
| "Tab … not in Claude's tab group" | Last tab closed, or dependent steps in one batch; start again with `tabs_context_mcp` |
| "Did not respond in time" | Batch too long; split it |
| Colors look wrong in screenshots | A dark-mode extension may be repainting pages; judge colors from the page's styles |

Anything that publishes, sends, deletes or changes domains: use
`getting-approval-before-live-changes` first. Never type passwords or card numbers; the person is
already signed in.
