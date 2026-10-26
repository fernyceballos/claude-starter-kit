# The one prompt

Make a new folder for your first project (for example `Projects/my-first-project` in your home
folder), open it in Claude Code, and paste everything inside the box below as your first message.

```
Set me up with Ferny's Claude Code starter kit. I'm new to this, so explain each step in plain
words, and when something needs me (a password, a click, a sign-in), stop and tell me exactly
what to do, then wait.

Do these steps in order. After each one, check it worked before moving on. If a step fails, stop
and tell me in plain words what happened and what to do, and if I'm stuck, tell me to contact my
coach at ferny@attractionmarketing.com.

1. Tell me in two lines what's about to happen: you'll check my computer, install a few free
   tools, connect to my coach's private kit on GitHub, then ask me a few easy questions to set up
   this folder.

2. Check for the basic tools and help me install any that are missing:
   - Apple's command-line tools (git): run `git --version`. If it's missing, I run
     `xcode-select --install` myself and click Install. Wait for me.
   - Homebrew (the Mac app installer for developer tools): run `brew --version`, and if that isn't
     found, also try `/opt/homebrew/bin/brew --version`. If both are missing, show me the one-line
     install command from https://brew.sh, tell me to paste it into the Terminal app myself (it
     asks for my Mac password), and wait. Then I run the "Next steps" lines Homebrew prints, in
     Terminal.
   - Tools you just installed may not be found in this chat yet. For the rest of this chat, start
     every command with `eval "$(/opt/homebrew/bin/brew shellenv)";` so they are.
   - jq and the GitHub tool: `brew install jq gh` (only the ones that are missing).

3. Connect to GitHub:
   - If I don't have a GitHub account yet, walk me through making one at https://github.com/signup,
     then tell me to send my GitHub username to my coach and wait until I say I've accepted the
     invite (it arrives by email and on github.com).
   - Signing in waits for the browser, so I do it myself: tell me to open the Terminal app, paste
     `gh auth login --web --git-protocol https`, press Enter, copy the one-time code it shows,
     press Enter again, and finish in the browser. Wait until I say it's done.
   - Check it with `gh auth status`, then run `gh auth setup-git`.
   - Run `gh repo view fernyceballos/claude-starter-kit --json name`. If that fails, my invite isn't accepted yet:
     tell me to check my email for the GitHub invite, or to ask my coach to invite my username.

Note for steps 4 and 5: if `claude --version` doesn't work (the desktop app doesn't always add
the `claude` command), use the desktop app's Plugins screen instead and walk me through the
clicks. Open it with + (next to the message box) → Add plugins (once something is installed, it's
+ → Plugins → Browse plugins). The desktop app keeps the plugins it installs in its own folder,
not in ~/.claude/plugins, so use the check commands below rather than reading
~/.claude/plugins/installed_plugins.json.

4. Install Superpowers (good working habits for Claude):
   - With `claude`:
     `CLAUDE_CODE_PLUGIN_PREFER_HTTPS=1 claude plugin marketplace add obra/superpowers-marketplace`
     `CLAUDE_CODE_PLUGIN_PREFER_HTTPS=1 claude plugin install superpowers@superpowers-marketplace --scope user`
   - In the desktop app: search the Plugins screen for `superpowers`, pick **Superpowers** (the
     one with the checkmark, from obra/superpowers) and click **Add**. It's in Anthropic's own
     plugin list, so no marketplace is needed. Ignore the look-alikes marked "Community".
   - Check it (works for both): `{ jq -r '.plugins | keys[] | select(startswith("superpowers@"))' ~/.claude/plugins/installed_plugins.json; find ~/Library/Application\ Support/Claude/local-agent-mode-sessions -path '*/rpm/plugin_*/.claude-plugin/plugin.json' -exec grep -l '"name": *"superpowers"' {} + | sed 's|/.claude-plugin/plugin.json$||'; } 2>/dev/null`
     It prints a line if Superpowers is installed. If it prints nothing, ask me to look on the
     Plugins screen under Yours: Superpowers should be listed there with its switch on.

5. Install the starter kit:
   - With `claude`:
     `CLAUDE_CODE_PLUGIN_PREFER_HTTPS=1 claude plugin marketplace add fernyceballos/claude-starter-kit`
     `CLAUDE_CODE_PLUGIN_PREFER_HTTPS=1 claude plugin install starter-kit@starter-kit-marketplace --scope user`
   - In the desktop app: on the Plugins screen click **+ Add** (top right) → **Add marketplace**,
     paste `fernyceballos/claude-starter-kit`, confirm, then install **starter-kit** from it.
   If either one fails with a sign-in or "not found" error, run `gh auth setup-git` again and
   retry once.

6. Find the installed kit: `{ jq -r '.plugins["starter-kit@starter-kit-marketplace"][0].installPath // empty' ~/.claude/plugins/installed_plugins.json; find ~/Library/Application\ Support/Claude/local-agent-mode-sessions -path '*/rpm/plugin_*/.claude-plugin/plugin.json' -exec grep -l '"name": *"starter-kit"' {} + | sed 's|/.claude-plugin/plugin.json$||'; } 2>/dev/null | head -1`
   (it checks both places the kit can be installed: the `claude` command's record, then the
   desktop app's own plugin folder). If it prints nothing, the install in step 5 didn't finish:
   go back to it. Read `skills/setup/SKILL.md` in that folder and follow it now, in this chat,
   in its "First run" mode.
```

That's it. Setup asks you at most five easy questions, and each one comes with a suggested
answer. When it's done, open a new chat in your project folder and say **coach me** for a
10-minute walkthrough of how to work with Claude.
