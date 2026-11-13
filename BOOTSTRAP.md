# The one prompt

Make a new folder called `my-first-project` inside a `Projects` folder in your home folder. Open
it in Claude Code (the Claude desktop app is easiest), and paste everything inside the box below
as your first message. Claude will ask what kind of computer you have and guide you from there.

```
Set me up with Ferny's Claude Code starter kit. I'm new to this, so explain each step in plain
words, and when something needs me (a password, a click, a sign-in), stop and tell me exactly
what to do, then wait.

Do these steps in order. After each one, check it worked before moving on. If a step fails, stop
and tell me in plain words what happened and what to do, and if I'm stuck, tell me to contact my
coach at ferny@attractionmarketing.com.

When a step says I run a command myself, show me that one command alone in its own code box marked
`bash`. In the Claude desktop app, that box gets a Run button: tell me to click it. The command then
runs in a Terminal panel inside the app, so tell me to watch that panel, and to type right there
anything it asks for (a password, a yes, pressing Enter). Nothing shows on screen while I type a
password; that's normal. I tell you when it's finished. Only if there's no Run button do I paste the
command into the Terminal app (Mac) or PowerShell (Windows PC: click Start, type PowerShell, press
Enter) instead.

1. Tell me in two lines what's about to happen: you'll check my computer, install a few free
   tools, connect to my coach's private kit on GitHub, then ask me a few easy questions to set up
   this folder. Also tell me that you'll often ask before running something on my computer, and
   that I can say yes when it matches the step we're on. Then ask me one question: "Are you on a
   Mac or a Windows PC?" Use my answer for every step below, and only ever tell me the steps for
   my kind of computer. (If what you can see on this computer doesn't match my answer, tell me
   kindly and go with what the computer really is.)
   Before anything else, check where this chat is running. If it's running in the cloud instead of
   on my own computer, or in a temporary folder the app made because no folder was picked (its
   name starts with `scratch-`), nothing we set up here would last. Tell me in plain words, then
   tell me to start a new session in the Claude app's Code tab, on my own computer, pick a project
   folder (or make one), and paste this same prompt there. Then stop.

2. Check for the basic tools and help me install any that are missing.

   If I said Mac:
   - Apple's command-line tools (git): run `git --version`. If it's missing, I run
     `xcode-select --install` myself and click Install in the box that pops up. Wait for me.
   - Homebrew (the Mac app installer for developer tools): run `brew --version`, and if that isn't
     found, also try `/opt/homebrew/bin/brew --version`. If both are missing, show me the one-line
     install command from https://brew.sh for me to run myself (it asks for my Mac password), and
     wait. Then I run the "Next steps" lines Homebrew prints the same way, one box each.
   - Tools you just installed may not be found in this chat yet. For the rest of this chat, start
     every command with `eval "$(/opt/homebrew/bin/brew shellenv)";` so they are.
   - jq and the GitHub tool: `brew install jq gh` (only the ones that are missing).

   If I said Windows PC:
   - It's normal if you can only run PowerShell commands at first: the tools aren't installed yet.
   - Run `winget --version` (winget is Windows' own app installer). If it isn't found, tell me to
     open the Microsoft Store, search for "App Installer", click Get or Update, and wait for me.
     If the Store won't open or App Installer won't install, this computer may be managed by my
     work: tell me to ask my IT team, or to contact my coach, and stop.
   - Check `git --version`, `jq --version` and `gh --version`. If any are missing, first tell me
     in one line that installing them this way accepts winget's terms for me. Then install only
     the missing ones, one at a time, and give each one plenty of time (Git takes a few minutes):
     `winget install --id Git.Git -e --accept-source-agreements --accept-package-agreements`
     `winget install --id jqlang.jq -e --accept-source-agreements --accept-package-agreements`
     `winget install --id GitHub.cli -e --accept-source-agreements --accept-package-agreements`
     If Windows asks "Do you want to allow this app to make changes to your device?", I click
     Yes. That box sometimes opens behind other windows: if an install seems stuck, tell me to look
     for a blinking icon on the taskbar at the bottom of the screen and click it. If an install is refused or blocked, this computer may be managed by my work: tell me to
     ask my IT team, and stop.
   - If you installed anything, Claude must restart before it can use it. Tell me to quit Claude
     completely: right-click the Claude icon by the clock (bottom right of the screen; it may be
     hidden under the ^ arrow) → Quit. If I can't find that icon, I restart the computer instead.
     Then I open Claude again, start a new session in this same project folder, and paste this
     same prompt again (from the page where I got this prompt). Stop here and wait. The second time, these checks pass and we carry on.
   - If the tools are still missing after that restart, don't install them again: tell me to
     restart the whole computer once, then paste the prompt again. Still missing after that → tell
     me to contact my coach.
   - From here on, on a Windows PC, run every command in Git Bash (your Bash tool), not in
     PowerShell. If you have no Bash tool after the restart, Git for Windows isn't working: tell
     me to contact my coach.

3. Connect to GitHub. First explain in one or two plain sentences what GitHub is: a website where
   my coach keeps the kit, and my free GitHub account is my key to it.
   - If I don't have a GitHub account yet, walk me through making one at https://github.com/signup,
     one small step at a time (email, password, username, country, the "are you human" puzzle,
     the code GitHub emails me; I can skip the extra questions and pick the Free plan),
     then tell me to send my GitHub username to my coach and wait until I say I've accepted the
     invite (it arrives by email and on github.com).
   - Signing in waits for the browser, so I run this myself:
     `gh auth login --hostname github.com --web --clipboard --git-protocol https`.
     It copies a one-time code for me. Then I press Enter to open the browser, paste the code there
     (Ctrl+V on a PC, Cmd+V on a Mac), and finish signing in. Wait until I say it's done.
   - Check it with `gh auth status`, then run `gh auth setup-git`.
   - Run `gh repo view fernyceballos/claude-starter-kit --json name`. If that fails, my invite isn't accepted yet:
     tell me to check my email for the GitHub invite, or to ask my coach to invite my username.

Note for steps 4 and 5: if `claude --version` doesn't work (the desktop app doesn't always add
the `claude` command), use the desktop app's Plugins screen instead. I don't know where anything
is in the app, so never just say "add it from the plugins menu": give me numbered steps, one click
per line, naming exactly what to click and where it is on the screen, and wait for me. Open it
with: click the + button at the left edge of the box where I type messages → click "Add plugins"
(if that isn't there, click "Plugins" → "Browse plugins"). Where the desktop app puts a plugin depends on where it came
from: Anthropic's own plugin list (Superpowers) goes into the app's own folder, not
~/.claude/plugins; a marketplace you add (the starter kit) goes into ~/.claude/plugins like the
`claude` command does. So use the check commands below, which look in every place.

4. Install Superpowers (good working habits for Claude):
   - With `claude`:
     `CLAUDE_CODE_PLUGIN_PREFER_HTTPS=1 claude plugin marketplace add obra/superpowers-marketplace`
     `CLAUDE_CODE_PLUGIN_PREFER_HTTPS=1 claude plugin install superpowers@superpowers-marketplace --scope user`
   - In the desktop app, give me these steps, numbered, one per line: 1) click the + button at the
     left edge of the message box; 2) click "Add plugins" (or "Plugins" → "Browse plugins");
     3) click the search box at the top of the Plugins screen and type `superpowers`; 4) pick
     **Superpowers**, the one with the checkmark that says obra/superpowers (skip any marked
     "Community"); 5) click **Add**; 6) close the Plugins screen and come back to this chat. It's in
     Anthropic's own plugin list, so no marketplace is needed.
   - Check it (works for both): `{ jq -r '.plugins | keys[] | select(startswith("superpowers@"))' ~/.claude/plugins/installed_plugins.json; { find ~/Library/Application\ Support/Claude/local-agent-mode-sessions ~/Library/Application\ Support/Claude/rpm ~/AppData/Roaming/Claude/local-agent-mode-sessions ~/AppData/Roaming/Claude/rpm ~/AppData/Local/Claude-Data -path '*/rpm/*plugin_*/.claude-plugin/plugin.json'; find ~/AppData/Local/Packages -mindepth 1 -maxdepth 1 -type d | while read -r p; do find "$p/LocalCache/Roaming/Claude/local-agent-mode-sessions" "$p/LocalCache/Roaming/Claude/rpm" "$p/LocalCache/Local/Claude-Data" -path '*/rpm/*plugin_*/.claude-plugin/plugin.json'; done; } | while read -r f; do grep -q '"name": *"superpowers"' "$f" && echo "${f%/.claude-plugin/plugin.json}"; done; } 2>/dev/null`
     It prints a line if Superpowers is installed. If it prints nothing, ask me to look on the
     Plugins screen under Yours: Superpowers should be listed there with its switch on.

5. Install the starter kit:
   - With `claude`:
     `CLAUDE_CODE_PLUGIN_PREFER_HTTPS=1 claude plugin marketplace add fernyceballos/claude-starter-kit`
     `CLAUDE_CODE_PLUGIN_PREFER_HTTPS=1 claude plugin install starter-kit@starter-kit-marketplace --scope user`
   - In the desktop app, give me these steps, numbered, one per line: 1) open the Plugins screen
     the same way (+ at the left edge of the message box → "Plugins" → "Browse plugins");
     2) click **+ Add** at the top right of the Plugins screen; 3) click **Add marketplace**;
     4) paste `fernyceballos/claude-starter-kit` into the box and confirm; 5) on the Discover tab,
     find **Starter kit** and click the small arrow next to its **Add** button; 6) choose
     **Install for me** (it installs for all projects). Not either "Install for project" option:
     those put it in just this one folder. 7) close the Plugins screen and come back to this chat.
   If either one fails with a sign-in or "not found" error, run `gh auth setup-git` again and
   retry once.

6. Find the installed kit: `{ jq -r '.plugins["starter-kit@starter-kit-marketplace"][0].installPath // empty' ~/.claude/plugins/installed_plugins.json | tr -d '\r' | sed 's|$|/.claude-plugin/plugin.json|'; find ~/Library/Application\ Support/Claude/local-agent-mode-sessions ~/Library/Application\ Support/Claude/rpm ~/AppData/Roaming/Claude/local-agent-mode-sessions ~/AppData/Roaming/Claude/rpm ~/AppData/Local/Claude-Data -path '*/rpm/*plugin_*/.claude-plugin/plugin.json'; find ~/AppData/Local/Packages -mindepth 1 -maxdepth 1 -type d | while read -r p; do find "$p/LocalCache/Roaming/Claude/local-agent-mode-sessions" "$p/LocalCache/Roaming/Claude/rpm" "$p/LocalCache/Local/Claude-Data" -path '*/rpm/*plugin_*/.claude-plugin/plugin.json'; done; } 2>/dev/null | while read -r f; do [ "$(jq -r .name "$f" 2>/dev/null | tr -d '\r')" = starter-kit ] && printf '%s\t%s\n' "$(jq -r .version "$f" | tr -d '\r')" "${f%/.claude-plugin/plugin.json}"; done | sort -t. -k1,1n -k2,2n -k3,3n | tail -1 | cut -f2`
   (it checks every place the kit can be installed: the `claude` command's record, then the
   desktop app's own plugin folders on a Mac or a Windows PC). If it prints nothing, the install in step 5 didn't finish:
   go back to it. Read `skills/setup/SKILL.md` in that folder and follow it now, in this chat,
   in its "First run" mode.
```

That's it. Setup asks you at most five easy questions, and each one comes with a suggested
answer. When it's done, open a new chat in your project folder and say **coach me** for a
10-minute walkthrough of how to work with Claude.
