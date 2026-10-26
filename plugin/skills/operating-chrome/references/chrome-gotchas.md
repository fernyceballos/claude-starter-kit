# Working in the person's Chrome (Claude in Chrome): the details

## Start of every browser task

1. `tabs_context_mcp` (use `createIfEmpty: true` if there's no group). Work in **your own tab**.
2. Go to the page, then **check visibility** inside the tab:
   `({vis: document.visibilityState, focus: document.hasFocus()})`
   If it's `hidden`, the page will ignore typing. Fix it (below).
3. Prefer reading pages as text or the accessibility tree over screenshots. Use screenshots to
   confirm what a person would see.

## Make a hidden tab visible (macOS)

Find where the tab is, then make it active. Several windows may hold look-alike tabs, so list first.

```bash
# list matching tabs with window id and position
osascript -e 'tell application "Google Chrome"
repeat with w in windows
set i to 1
repeat with t in tabs of w
if (URL of t) contains "PART-OF-URL" then log (id of w) & " tab " & i
set i to i + 1
end repeat
end repeat
end tell'

# make tab N in window W active (and bring Chrome forward)
osascript -e 'tell application "Google Chrome" to set active tab index of window id W to N'
osascript -e 'tell application "Google Chrome" to activate'
```

Then check `document.visibilityState` again from inside the tab. If you activated a different
window by mistake, tell the person which window you touched.

## Tab group rules

- Closing the **last** tab in the group breaks it ("Tab … is not in Claude's tab group").
- Don't put "close tab" and an action that needs the group in the same batch.
- A new tab opens in the background; use the visibility check above.
- Close the tabs you opened when finished (keep one so the group lasts until the end).

## Typing and clicking

- **The person may use Chrome while you work:** tab positions shift and windows get covered.
  Clicks and JavaScript work in a hidden tab; only typing needs it visible. List tab positions
  again right before each activation, then type in the very next step.
- **Dark-mode extensions** can repaint every page. Judge colors from the page's style rules.
- **Chat boxes inside a frame from another site** (common in AI website builders) can't be filled
  with JavaScript. Click the box, then use the `type` action, and confirm the text landed with a
  zoomed screenshot of the box.
- The layout moves when the window resizes, so screenshot again before clicking by position.
- Long prompts (10,000+ characters) type fine; send with `Return`. If nothing shows up in the
  chat after about 10 seconds, the tab was probably hidden (see the top).
- The `wait` action allows at most 10 seconds. Keep a batch to about 6 waits (a minute). A very
  long batch times out ("tool did not respond in time").

## Checking things with code (cheaper than screenshots)

- Open the **preview address** in its own tab, then run JavaScript there: `get_page_text`,
  `fetch('/some-page')` and hidden same-site frames all work. Good for counting broken images,
  checking titles, and comparing links on every page.
- Lazy images only load when scrolled to: set `loading = 'eager'` and scroll, or you'll see
  false "broken" images.
- Comparing two sites: collect data on site A, store it as JSON in `window.name`, go to site B
  in the same tab, and read it back. No secrets in `window.name`.
- One site can't `fetch` another site (the browser blocks it). That doesn't mean the site is
  down; go to it instead.

## Safe by default

- Read-only checks of live pages are always fine.
- Anything that publishes, sends, deletes, or changes domains, DNS or billing needs a "yes" in
  chat first (`getting-approval-before-live-changes`).
- Never type passwords or card numbers; the person is already signed in.
