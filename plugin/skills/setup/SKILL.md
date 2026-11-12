---
name: setup
description: Use when the person says "set me up", "start a project", "set up this folder", "upgrade this project" (e.g. "make this a builder project"), or "update the kit" — and when the starter-kit bootstrap prompt hands over to this skill right after installing. Checks the computer, retires old copies of these skills, asks at most five easy questions (each with a recommended answer), writes the person's preferences and settings without overwriting anything, sets a project folder up with the right starter kit (operator, researcher, builder), and hands over to the coach.
---

# Setup — the starter kit's installer and project maker

Everything here is for someone who may be new to all of it. **Every question you ask comes with
your recommended answer, in plain words** ("I'd pick X because Y. OK?"). Never ask an open
technical question. Report each step as **done**, **kept** (already theirs, left alone) or
**needs you** (something only they can do, with the exact steps).

## Find the kit's folder first

Run `starter-kit-root`. If that command isn't found (it isn't on the path yet in the same chat as
the install), use `{ jq -r '.plugins["starter-kit@starter-kit-marketplace"][0].installPath // empty' ~/.claude/plugins/installed_plugins.json | tr -d '\r' | sed 's|$|/.claude-plugin/plugin.json|'; find ~/Library/Application\ Support/Claude/local-agent-mode-sessions ~/Library/Application\ Support/Claude/rpm ~/AppData/Roaming/Claude/local-agent-mode-sessions ~/AppData/Roaming/Claude/rpm ~/AppData/Local/Claude-Data -path '*/rpm/*plugin_*/.claude-plugin/plugin.json'; find ~/AppData/Local/Packages -mindepth 1 -maxdepth 1 -type d | while read -r p; do find "$p/LocalCache/Roaming/Claude/local-agent-mode-sessions" "$p/LocalCache/Roaming/Claude/rpm" "$p/LocalCache/Local/Claude-Data" -path '*/rpm/*plugin_*/.claude-plugin/plugin.json'; done; } 2>/dev/null | while read -r f; do [ "$(jq -r .name "$f" 2>/dev/null | tr -d '\r')" = starter-kit ] && printf '%s\t%s\n' "$(jq -r .version "$f" | tr -d '\r')" "${f%/.claude-plugin/plugin.json}"; done | sort -t. -k1,1n -k2,2n -k3,3n | tail -1 | cut -f2` (it checks every place the kit can be installed: the `claude` command's record, then the
desktop app's own plugin folders on a Mac or a Windows PC). Call it `ROOT` below, and call its scripts as
`"$ROOT/bin/<name>"`.

## Pick the mode

| The person said / situation | Mode |
|---|---|
| Handed over from the bootstrap prompt, or "set me up", and `"$ROOT/bin/starter-kit-state" has setup-done` fails | **First run** |
| "set me up" but setup is already done | Say so in one line, then offer **Start a project** (new kind of work) or **Upgrade** (this folder), recommending one |
| "start a project" / "set up this folder" | **Start a project** |
| "upgrade this project", "make this a builder project", "add research to this folder" | **Upgrade** |
| "update the kit" | **Update** |

## Are the automatic phrases working? (every mode except First run and Update)

In the first-run chat the kit was only just installed, so its triggers haven't had a chance to run;
in an update chat the record may come from an older kit that didn't keep it. Skip this in both. In
every other mode, run `"$ROOT/bin/starter-kit-state" get hooks-seen`. Nothing
printed means the automatic phrases aren't working yet on this computer: say so in one line, and
give the same fix as the coach's step 0 (`$ROOT/skills/coach/SKILL.md`): on a Windows PC, Git for
Windows installed, then right-click the Claude icon by the clock → **Quit** and reopen; on a Mac,
quit Claude fully and reopen. Then carry on with the mode.

## The project folder (`PROJECT` below)

A kit goes into a project folder, never into the home folder (`~`), Desktop, Downloads or
Documents themselves. If the current folder is one of those, `PROJECT` will be a new folder
`~/Projects/<short-name>`. Suggest a name from what they want to do (question 2), and create it
with `mkdir -p`. Otherwise `PROJECT` is the current folder. Always pass `PROJECT` as a full path,
in quotes, to every script and git command (`git -C "$PROJECT" …`), so this works from any chat.

---

## First run

Make one todo per step.

### 1. Computer check

Check each item and report OK / installed / needs you:
- `git --version` and `jq --version`. Missing on a **Mac**: git → the person runs
  `xcode-select --install` and clicks Install (wait); jq → `brew install jq`. Missing on a
  **Windows PC** (after one line saying this accepts winget's terms for them):
  `winget install --id Git.Git -e --accept-source-agreements --accept-package-agreements`,
  `winget install --id jqlang.jq -e --accept-source-agreements --accept-package-agreements`.
  New tools need Claude restarted (on a PC: right-click the Claude icon by the clock → **Quit**,
  reopen, and say **set me up** again).
- `gh auth status` shows signed in.
- Claude in Chrome connected: try loading its tools. Not connected → explain how to install the
  extension and sign in, and carry on; it's only needed for operator and research work.
- **Git name and email** (used to label saved work): if `git config --global user.name` is
  empty, set it to the name from question 1 (ask that question first if needed). If
  `git config --global user.email` is empty, set it to their GitHub private address:
  `gh api user -q '"\(.id)+\(.login)@users.noreply.github.com"'`.

### 2. Old copies from earlier setups

Run `"$ROOT/bin/starter-kit-legacy-scan"`. For each finding, explain it in one line, recommend
**"switch it off"**, and act on a yes:
- `same_name_skills`: skills of theirs with the same name as one of the kit's. Read each one's
  SKILL.md description first. If it's clearly an older copy of the kit's skill (same purpose, e.g.
  from an earlier prompt-by-prompt setup), recommend retiring it, since it would compete with the
  kit's version: `"$ROOT/bin/starter-kit-retire" <names…>`. If it's a different skill of their own
  that happens to share the name, say so and recommend keeping it. They can rename its folder
  later, and you don't touch it.
- `open_design_b` and `karpathy_skills`: extra skills from an older setup that this kit no longer
  uses. → `starter-kit-retire` them.
- `plugins` of kind `ecc` or `karpathy`: a large add-on whose automatic triggers would talk over
  this kit's. → `claude plugin disable <id>` (or, if the `claude` command isn't found, the desktop
  app's Settings → Plugins → Yours → **…** on that plugin's row → **Turn off**).

Retiring moves folders to `~/.claude/skills-retired-<date>/`, and disabling can be undone, so
nothing is deleted. Say that.

### 3. The interview (at most 5 questions, one or two per message)

1. **"What should I call you?"** Suggest the name from `git config --global user.name` or
   `gh api user -q .name`, if there is one.
2. **"In a sentence or two, what do you want Claude to help you with first?"** Then propose the
   kit (or kits) with a one-line reason each, recommend one, and confirm:
   - **operator**: "do things for me inside tools I use" (a CRM, Slack, email, a website builder).
   - **researcher**: "study a person, profile, videos or a market and tell me what works".
   - **builder**: "build an app, portal or website with code".
   - **all three** ("all of the above"): a bit of everything. Always offer it alongside the three.
     Apply operator, researcher and builder, in that order, in one call. Each adds its own section and files
     without touching the others, so they sit together in one folder fine. Question 3 and the
     researcher tools below then apply too.
   - Not sure → recommend **operator**; it's the gentlest start and can be upgraded later.
3. **(operator only)** "Which tool will I work in first?" Recommend naming just the first one;
   more can be added later. It goes into `docs/MAP.md` after the kit is applied, as a name and
   URL only. **Never passwords.**
4. **"How comfortable are you with tech: new, some, or lots?"** Recommend "new" if unsure.
5. **"Which Claude plan are you on: Max, Pro, or not sure?"** (claude.ai → Settings → Billing
   shows it.) Max → the `max` settings; Pro → `pro`; not sure → `unsure`.

**If researcher was picked:** now check `yt-dlp` and `ffmpeg`, and install them after a yes: on a
Mac `brew install yt-dlp ffmpeg`; on a Windows PC
`winget install --id yt-dlp.yt-dlp -e --accept-source-agreements --accept-package-agreements` and
`winget install --id Gyan.FFmpeg -e --accept-source-agreements --accept-package-agreements`.

### 4. The preferences file

Make a filled-in copy of `$ROOT/templates/global-CLAUDE.section.md` in a temp file, replacing
`{{NAME}}` and `{{COMFORT}}`. Then:
`"$ROOT/bin/starter-kit-claudemd-merge" ~/.claude/CLAUDE.md <temp file> global`.
Report `added` or `kept`. Their own text in that file is never touched.

### 5. Settings

1. **Preview first:** copy `~/.claude/settings.json` (if it exists) to a temp file, run
   `"$ROOT/bin/starter-kit-settings-merge" <temp copy> "$ROOT/templates/settings/<plan>.json"`,
   and show the person the result in plain words: what gets added, and what they already have
   that differs from the kit.
2. For each `kept … (yours: X, kit: Y)` line, recommend keeping theirs unless it's `model` or
   `permissions.defaultMode` and they agree to the kit's value.
3. Run it for real on `~/.claude/settings.json`, with `--set <key>` only for keys they agreed to
   change. A backup is made automatically when anything changes.
4. If it says `not valid JSON`, stop this step, tell them the file has a typo, and offer to show
   them the line. Don't rewrite it.

Say in one line what "auto" mode means: Claude asks before risky actions and does the everyday
ones (reading files, listing folders) without asking.

### 6. The chat-fullness meter

`mkdir -p ~/.claude/starter-kit && cp "$ROOT/bin/starter-kit-statusline" ~/.claude/starter-kit/statusline.sh`.
Tell them where to see how full the chat is, and that at 60% it's time to say *continue in new
session*:
- **Desktop app:** the **Context** percentage in the panel on the right side. It doesn't remind
  them, so they glance at it now and then. (The meter below is only shown in the Terminal.)
- **Terminal:** the bottom of the screen shows "chat N% full", and at 60% it reminds them.

### 7. Design systems

`bash "$ROOT/skills/design-systems/refresh.sh"` (about 11 MB, a minute or two). Report the count.

### 8. Updates

**In the terminal** (`claude` works): turn on automatic updates for the kit with `/plugin` →
Marketplaces → starter-kit-marketplace → enable auto-update. Walk them through it and wait.

**In the desktop app** there is no auto-update switch, so don't send them looking for one. Tell
them updates are by hand, and how: say **"update the kit"** in any chat, or click through the
Update steps below themselves. Nothing to click now.

Either way, mention that saying **"update the kit"** updates by hand any time.

### 9. Set up the project folder

Settle `PROJECT` (see above). Apply every chosen kit in ONE call, in the order operator,
researcher, builder: `"$ROOT/bin/starter-kit-apply" <kit> [<kit>…] "$PROJECT"` (one call keeps a
single backup of each file they had, instead of backups of files this run just made).
Keep its output: the `filled docs/<path>` lines name the files it created. If it prints a
`warning: this folder is inside OneDrive…` line, tell the person in plain words and offer to use
a folder like `~/Projects/<name>` instead (their call). Then fill
`"$PROJECT/docs/MAP.md"` from question 3, if asked.

### 10. Save it

Commit **only what the kit created**: `CLAUDE.md`, `.gitignore`, `.claude/settings.json` (skip it
if git ignores it), and each `docs/<path>` from a `filled` line in step 9. Pass the same paths to
both commands, so nothing the person had already staged gets swept in:
`git -C "$PROJECT" add -- <paths>` then
`git -C "$PROJECT" commit -m "Set up with the starter kit" -- <paths>`.
Nothing to commit (everything was `kept`) → report "kept".

### 11. Mark it done

`"$ROOT/bin/starter-kit-state" set setup-done yes`

### 12. The final report

Three short lists, **Done**, **Kept** and **Needs you**, plus:
- what the folder is now set up for, and the phrases they can use (from its CLAUDE.md);
- the recipes they can run later (from `$ROOT/recipes/README.md`), one line each.

### 13. Next: a new chat, then the coach

New skills only load in a new chat, so this chat can't run the coach. Say:
- "**Open a new chat in <PROJECT>.**" (Desktop app: start a new session and pick that folder.)
- "In the new chat, say **coach me** for the 10-minute walkthrough of how to work with Claude. I'd
  start there. The coach also gives you your field guide: every phrase on one page, to keep."
  (The new chat will also offer the coach once on its own.)
- "No need to wind down this chat: setup already saved everything."

---

## Start a project

Settle `PROJECT` → question 2 only → apply the kit(s) to `PROJECT` → the MAP question (operator
kit only) → save it (step 10) → a short report → "Open a new chat in <PROJECT> for your first
real job."

## Upgrade

1. Read the CLAUDE.md markers (`<!-- starter-kit:<kit> start -->`) to see which kits are already
   here.
2. Say in plain words what the new kit adds (its CLAUDE.md section, files, settings).
3. On a yes: `starter-kit-apply <new kit> "$PROJECT"` → save it (step 10) → report what was added
   and what was kept.
4. If a kit section from an older kit version differs from the current one, show the difference
   and offer `starter-kit-claudemd-merge … <kit> --update`. Only on a yes.

## Update

1. Note the current version from `$ROOT/.claude-plugin/plugin.json`.
2. `claude plugin marketplace update starter-kit-marketplace`
3. `claude plugin update starter-kit@starter-kit-marketplace`
4. Find the new version by running `{ jq -r '.plugins["starter-kit@starter-kit-marketplace"][0].installPath // empty' ~/.claude/plugins/installed_plugins.json | tr -d '\r' | sed 's|$|/.claude-plugin/plugin.json|'; find ~/Library/Application\ Support/Claude/local-agent-mode-sessions ~/Library/Application\ Support/Claude/rpm ~/AppData/Roaming/Claude/local-agent-mode-sessions ~/AppData/Roaming/Claude/rpm ~/AppData/Local/Claude-Data -path '*/rpm/*plugin_*/.claude-plugin/plugin.json'; find ~/AppData/Local/Packages -mindepth 1 -maxdepth 1 -type d | while read -r p; do find "$p/LocalCache/Roaming/Claude/local-agent-mode-sessions" "$p/LocalCache/Roaming/Claude/rpm" "$p/LocalCache/Local/Claude-Data" -path '*/rpm/*plugin_*/.claude-plugin/plugin.json'; done; } 2>/dev/null | while read -r f; do [ "$(jq -r .name "$f" 2>/dev/null | tr -d '\r')" = starter-kit ] && printf '%s\t%s\n' "$(jq -r .version "$f" | tr -d '\r')" "${f%/.claude-plugin/plugin.json}"; done | sort -t. -k1,1n -k2,2n -k3,3n | tail -1 | cut -f2` again (an update installs into a new folder),
   read its `.claude-plugin/plugin.json`, and report old → new. Then refresh the pieces that live
   outside the plugin, using the NEW folder: copy its `bin/starter-kit-statusline` over
   `~/.claude/starter-kit/statusline.sh`, and run its `skills/design-systems/refresh.sh` (quick if
   nothing changed). Tell them to start a new
   chat to use it. Their folders and settings aren't changed by an update; "upgrade this project"
   picks up new kit pieces if they want them.
5. If `claude` isn't found (the desktop app doesn't always add the command), walk them through
   the desktop app instead, then carry on from step 4:
   1. Settings → Plugins → **Manage marketplaces** → **…** on starter-kit-marketplace →
      **Check for updates** → Done.
   2. Plugins → Yours → click the **Starter kit** row. Its page shows the version, and an
      **Update** button when a newer one is ready. Click it.
6. If it fails with a sign-in or "repository not found" error: `gh auth status`, then
   `gh auth setup-git`, and retry. Still failing → their access may have ended; point them to
   their coach (the contact in `~/.claude/CLAUDE.md`).
