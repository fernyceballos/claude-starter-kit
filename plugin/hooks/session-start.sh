#!/bin/bash
# SessionStart hook (matcher: startup|compact). Adds short notes for Claude:
#   KIT-COMPACT      the chat was just squeezed (compaction): tell the person
#   KIT-OFFER-COACH  first run: offer the coaching walkthrough, once
#   KIT-TIP-FOLDER   this folder isn't set up yet: mention "start a project", once per folder
#   KIT-WHATS-NEW    the kit was updated: summarise the top changelog entry, once per version
#
# Non-blocking: always exits 0, prints nothing when nothing applies.
set -u

command -v jq >/dev/null 2>&1 || exit 0

root="${CLAUDE_PLUGIN_ROOT:-}"
[ -n "$root" ] || exit 0
state="$root/bin/starter-kit-state"
[ -x "$state" ] || exit 0

input="$(cat)"
source_kind="$(printf '%s' "$input" | jq -r '.source // empty' 2>/dev/null)" || exit 0
cwd="$(printf '%s' "$input" | jq -r '.cwd // empty' 2>/dev/null)" || exit 0

nl='
'
lines=""
add() { if [ -z "$lines" ]; then lines="$1"; else lines="$lines$nl$1"; fi; }

case "$source_kind" in
  compact)
    add "KIT-COMPACT: This chat was just compacted (squeezed to make room). In your very next reply, say this to the person in your own words: \"This chat just got squeezed to make room, and some detail may be gone. Say continue in new session to pick this up in a fresh chat with nothing lost.\""
    ;;
  startup)
    # Coaching offer: once, and never after the coaching is done.
    if ! "$state" has coach-done && ! "$state" has coach-offered; then
      "$state" set coach-offered yes
      add "KIT-OFFER-COACH: In one sentence at the start of your first reply, offer the person a short walkthrough of how to work with Claude (they just say \"coach me\"). Offer it once only; do not bring it up again."
    fi

    # Folder tip: once per folder, only where the kit hasn't set the folder up. Inside a git
    # repo the key is the repo's shared folder, so the desktop app's worktrees of one repo
    # (each its own folder) get the tip once, not once per worktree.
    tipkey="$cwd"
    if [ -n "$cwd" ] && command -v git >/dev/null 2>&1; then
      common="$(git -C "$cwd" rev-parse --path-format=absolute --git-common-dir 2>/dev/null)" || common=""
      [ -z "$common" ] || tipkey="$common"
    fi
    if [ -n "$cwd" ] && ! "$state" has-line folders-tipped "$tipkey"; then
      if ! grep -qF '<!-- starter-kit:' "$cwd/CLAUDE.md" 2>/dev/null; then
        "$state" add-line folders-tipped "$tipkey"
        add "KIT-TIP-FOLDER: This folder has not been set up yet. Mention it once, in one line: \"Say start a project to set this folder up.\""
      fi
    fi

    # What's new: silent the first time ever, announced after each version change.
    version="$(jq -r '.version // empty' "$root/.claude-plugin/plugin.json" 2>/dev/null)"
    if [ -n "$version" ]; then
      seen="$("$state" get last-seen-version)"
      if [ -z "$seen" ]; then
        "$state" set last-seen-version "$version"
      elif [ "$seen" != "$version" ]; then
        "$state" set last-seen-version "$version"
        add "KIT-WHATS-NEW: The starter kit was updated to version $version. Read the top entry of $root/../CHANGELOG.md if that file exists, otherwise $root/CHANGELOG.md, and tell the person what changed in two plain bullets."
      fi
    fi
    ;;
esac

[ -n "$lines" ] || exit 0

jq -nc --arg m "$lines" '{hookSpecificOutput:{hookEventName:"SessionStart",additionalContext:$m}}' 2>/dev/null
exit 0
