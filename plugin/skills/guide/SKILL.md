---
name: guide
description: Use when the person says "show me the guide", "the guide", "field guide", "cheat sheet", "what can I say?", "list the phrases" or "what are the commands" — and when the coach skill hands over to publish the guide at the start of a first walkthrough. Gives them the starter kit's field guide (every phrase, when to say it, the route of a job, where things are in the app) as a page of their own to keep, published as a private Claude Artifact, or opened in the browser where Artifacts aren't available.
---

# Guide: the field guide, as a page they keep

The guide is a ready-made page in the kit: `$ROOT/guide/field-guide.html`. Find `ROOT` by running
`starter-kit-root`; if that isn't found, use `{ jq -r '.plugins["starter-kit@starter-kit-marketplace"][0].installPath // empty' ~/.claude/plugins/installed_plugins.json; find ~/Library/Application\ Support/Claude/local-agent-mode-sessions -path '*/rpm/plugin_*/.claude-plugin/plugin.json' -exec grep -l '"name": *"starter-kit"' {} + | sed 's|/.claude-plugin/plugin.json$||'; } 2>/dev/null | while read -r d; do [ -f "$d/.claude-plugin/plugin.json" ] && printf '%s\t%s\n' "$(jq -r .version "$d/.claude-plugin/plugin.json")" "$d"; done | sort -t. -k1,1n -k2,2n -k3,3n | tail -1 | cut -f2`.
The state helper is `"$ROOT/bin/starter-kit-state"`; the kit version is in
`$ROOT/.claude-plugin/plugin.json`.

Don't rewrite or restyle the page. It's the same for everyone, so a fix belongs in the kit.

## 1. Put the page in its usual place

`mkdir -p ~/.claude/starter-kit && cp "$ROOT/guide/field-guide.html" ~/.claude/starter-kit/field-guide.html`

Always publish from that path, so the page keeps one address across kit updates.

## 2. Publish it, or show the one they have

Check `starter-kit-state get guide-url` and `starter-kit-state get guide-version`.

- **No guide-url yet:** publish `~/.claude/starter-kit/field-guide.html` with the Artifact tool,
  icon `book`, description "Every phrase you can say to Claude in a starter-kit folder, when to
  say it, and where things are in the app." Then
  `starter-kit-state set guide-url <the link>` and `starter-kit-state set guide-version <kit version>`.
- **guide-url set, same version:** show that page (the Artifact tool's `open` with the link). Don't
  publish a second copy.
- **guide-url set, older version:** update it in place: read it first (the Artifact tool's `read`
  with the link), then publish the same file with `url` set to the link. Then set
  `guide-version` to the new version. If the old page can't be found any more (deleted), publish
  a new one and save the new link.
- **No Artifact tool in this session** (some Terminal setups): run
  `open ~/.claude/starter-kit/field-guide.html` to show it in their web browser, and tell them
  they can bookmark it. Skip the state lines.

## 3. Tell them, in two or three lines

- Give the link. Say it's private: only they can see it unless they share it from the page's Share menu.
- Tip: click any phrase on the page to copy it, then paste it into a chat.
- Offer once to pin it in their Claude sidebar so it's always one click away, and pin it only on
  a yes (the Artifact tool's `pin`).
- Any time later: **show me the guide** opens it again.
