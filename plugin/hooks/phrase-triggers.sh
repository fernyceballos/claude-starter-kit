#!/bin/bash
# UserPromptSubmit hook: when the person's message STARTS with a trigger phrase
# (wind down, continue in new session, autopilot dev, autopilot prod), add a
# note telling Claude which starter-kit skill to run.
#
# Anchored at the START of the message on purpose: "how does wind down work?"
# and "let's not wind down yet" must NOT fire. Only a message that opens with
# the phrase is the command.
#
# "wrap up" is too common in ordinary requests ("wrap up the email"), so it fires ONLY when
# it is the whole message: wrap up / let's wrap up / wrap up the|this session|chat, with
# optional trailing punctuation.
#
# Stricter than "starts with" for the phrases that begin ordinary requests too ("wind down the ad
# campaign", "hand this off to Sarah", "end the session recording"): wind down fires when it
# stands alone or is followed by punctuation / please / now / for today / for the day / and ...;
# close out the session, end the session and hand this|it off only as the whole message; continue
# in new session when followed by punctuation, a dash or the end. Any "?" in the message means a
# question, so no autopilot trigger fires.
#
# Non-blocking: always exits 0, prints nothing when nothing applies.
set -u

command -v jq >/dev/null 2>&1 || exit 0

input="$(cat)"
prompt="$(printf '%s' "$input" | jq -r '.prompt // empty' 2>/dev/null)" || exit 0
[ -n "$prompt" ] || exit 0

# Flatten newlines to spaces (sed works line by line), trim leading whitespace,
# lowercase.
p="$(printf '%s' "$prompt" | tr '\n\r' '  ' | sed -E 's/^[[:space:]]+//' | tr '[:upper:]' '[:lower:]')"

tag=""
msg=""
# End-of-phrase shapes. A phrase only counts as the command when it stands alone (or is
# followed by punctuation / a dash), never when it is the start of an ordinary request.
END_PUNCT='(\.|!|,|;|:|-|—|–)'
if printf '%s' "$p" | grep -q '?'; then
  : # a question mark anywhere means a question, not a command: no autopilot trigger
elif printf '%s' "$p" | grep -qE '^autopilot[[:space:]]+(to[[:space:]]+)?(prod|production)([^a-z]|$)'; then
  tag="autopilot-prod"
  msg="KIT-TRIGGER autopilot-prod: the person's message starts with \"autopilot prod\". Invoke the skill starter-kit:autopilot-prod now and follow it in order. The typed phrase authorizes going live for this feature in this session only. If the message is really a question about autopilot, answer it instead — a question is not a command."
elif printf '%s' "$p" | grep -qE '^autopilot[[:space:]]+(to[[:space:]]+)?dev([^a-z]|$)'; then
  tag="autopilot-dev"
  msg="KIT-TRIGGER autopilot-dev: the person's message starts with \"autopilot dev\". Invoke the skill starter-kit:autopilot-dev now and follow it in order. If the message is really a question about autopilot, answer it instead — a question is not a command."
fi
if [ -z "$tag" ]; then
  # hand this off / hand it off: only as the whole message (plus punctuation or "please").
  # continue in (a) new|fresh session: also when followed by punctuation or a dash.
  if printf '%s' "$p" | grep -qE "^continue in (a )?(new|fresh) session([[:space:]]+(please|now))?[[:space:]]*($END_PUNCT|\$)" \
     || printf '%s' "$p" | grep -qE "^hand (this|it) off([[:space:]]+please)?[[:punct:][:space:]]*\$"; then
    tag="continue-in-new-session"
    msg="KIT-TRIGGER continue-in-new-session: the person's message starts with the phrase to continue in a new session. Invoke the skill starter-kit:continue-in-new-session now and follow it in order. If the message is really about something else (e.g. winding down an ad campaign), ignore this note."
  elif printf '%s' "$p" | grep -qE "^wind[ -]?down([[:space:]]*($END_PUNCT|\$)|[[:space:]]+(please|now|for today|for the day)[[:space:]]*($END_PUNCT|\$)|[[:space:]]+and[[:space:]])" \
    || printf '%s' "$p" | grep -qE "^(close out the session|end the session)([[:space:]]+(please|now))?[[:punct:][:space:]]*\$" \
    || printf '%s' "$p" | grep -qE "^(wrap up( (the|this) (session|chat))?|let(['’])?s wrap up)[[:punct:][:space:]]*\$"; then
    tag="wind-down"
    msg="KIT-TRIGGER wind-down: the person's message starts with the phrase to wind down. Invoke the skill starter-kit:wind-down now and follow it in order: reconcile the record files this folder's CLAUDE.md names first; kickoff prompt last. If the message is really about something else (e.g. winding down an ad campaign), ignore this note."
  fi
fi

[ -n "$tag" ] || exit 0

jq -nc --arg m "$msg" '{hookSpecificOutput:{hookEventName:"UserPromptSubmit",additionalContext:$m}}' 2>/dev/null
exit 0
