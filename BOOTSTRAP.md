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
the `claude` command), use the desktop app instead: walk me through + (next to the message box)
→ Plugins → Add marketplace, then install the plugin from it. Same names as below.

4. Install Superpowers (good working habits for Claude):
   `CLAUDE_CODE_PLUGIN_PREFER_HTTPS=1 claude plugin marketplace add obra/superpowers-marketplace`
   `CLAUDE_CODE_PLUGIN_PREFER_HTTPS=1 claude plugin install superpowers@superpowers-marketplace --scope user`

5. Install the starter kit:
   `CLAUDE_CODE_PLUGIN_PREFER_HTTPS=1 claude plugin marketplace add fernyceballos/claude-starter-kit`
   `CLAUDE_CODE_PLUGIN_PREFER_HTTPS=1 claude plugin install starter-kit@starter-kit-marketplace --scope user`
   If either one fails with a sign-in or "not found" error, run `gh auth setup-git` again and
   retry once.

6. Find the installed kit: `jq -r '.plugins["starter-kit@starter-kit-marketplace"][0].installPath' ~/.claude/plugins/installed_plugins.json` (Claude Code's
   record of where it installed the kit). Read `skills/setup/SKILL.md` in that folder and follow it now, in this chat,
   in its "First run" mode.
```

That's it. Setup asks you at most five easy questions, and each one comes with a suggested
answer. When it's done, open a new chat in your project folder and say **coach me** for a
10-minute walkthrough of how to work with Claude.
