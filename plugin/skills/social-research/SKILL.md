---
name: social-research
description: Use when the person wants to reverse-engineer what someone does on social media — "break down their strategy", "study this profile", "what is this creator doing that works", "audit their reels / posts / content", "find their frameworks and schedule" — by pulling their posts and numbers, watching the videos, labeling each post, and writing up the patterns. Uses the person's own signed-in browser, slowly. Instagram has a proven method; other platforms use public pages and video-analysis.
---

# Social research — reverse-engineer a creator's strategy

**REQUIRED:** `video-analysis` for the videos, and `operating-chrome` for the browser.

## Step 0 — the first-time warning (once ever)

Run `starter-kit-state has research-warned` (if that command isn't found, use
`"$(jq -r '.plugins["starter-kit@starter-kit-marketplace"][0].installPath' ~/.claude/plugins/installed_plugins.json)/bin/starter-kit-state"`). If it isn't set, tell the person this in plain words
before anything else, then run `starter-kit-state set research-warned yes`:

> This works through your own signed-in Instagram (or other account) in Chrome, the same way you'd
> scroll it, just slowly: about one post every 2 seconds. Going faster can get an account
> temporarily limited, so I won't. Downloaded videos get deleted after I transcribe them. My
> write-up describes and summarizes what they do; it won't copy their captions or scripts word
> for word. Nothing I collect gets posted or shared.

Then continue. Don't ask for permission again on later runs; the warning is information, not a gate.

## Step 1 — set up the study

1. Agree in one line on: whose profile, which posts (e.g. "reels from the last 12 months"), and
   what the person wants to learn (what to copy, how they sell or recruit, their schedule).
2. Make the study folder (the researcher kit's layout): `docs/research/<YYYY-MM-DD>-<subject>/README.md`
   for findings, and `.tmp/<subject>/` for raw data, which git ignores. Not a researcher folder?
   Use the same layout anyway.
3. Write the **study definitions** at the top of the README: the offers this creator sells (from
   their bio and link page), the content pillars you expect, and the jobs a post can do (default:
   **Attract** = built for reach from strangers · **Influence** = builds trust and desire ·
   **Enroll** = built around an offer AND asks for a step). These fill the `offer_line`, `pillar`
   and intent fields of the label brief.

## Step 2 — pull the data

- **Instagram:** follow `references/instagram.md` exactly. It's the proven method, with the calls
  that work and the ones that don't.
- **Other platforms (TikTok, YouTube, Facebook):** there's no proven bulk method yet. Read what the
  public page shows (titles, view counts, dates) with page text in Chrome, collect the post links,
  and use `video-analysis` on each one. Tell the person this is slower and less complete, and why.
- Pace: about 2 seconds between requests, always. Save everything to `.tmp/<subject>/`.

## Step 3 — watch and label every post

1. For each video: transcript + frames (`video-analysis`). For short clips, one 8-frame contact
   sheet is enough.
2. Make one **card** per post in `.tmp/<subject>/cards/`: stats, caption, transcript with no-speech
   scores, the first page of comments with the creator's replies, and the contact sheet path.
3. **Label in parallel:** split the cards into batches of about 35 and give each batch to a
   subagent with `references/label-brief.md` and the study definitions. Each writes one JSON file.
   Then merge them into `.tmp/<subject>/labels/merged.json`. Spot-check 5 labels yourself
   against their cards before trusting the set.
4. Delete videos and audio once transcribed (unless the person said keep them).

## Step 4 — find the patterns (count, don't guess)

From `merged.json`, with real numbers: formats and lengths, hooks, pillars, the Attract /
Influence / Enroll mix, how often they post and when, which calls to action they use and what each
one promises, caption patterns, how they reply to comments (and whether it looks automated), and
which of these go with the most views and comments. Compare medians, not single hits.

## Step 5 — the write-up

In the study README, plain English, with:
- **Who they are** (a few lines) and **where everything lives** (a table: the raw data in `.tmp/`,
  the labels, the scripts).
- **Headline findings**: 5–8 bullets, each with its number.
- **Their frameworks**: the repeatable post templates (described in your own words, with a
  few-word example at most), their schedule, and how they move people from watching to buying or
  joining.
- **What to copy, what to skip, and why**, for the person's own business.
- **How sure we are**: what's measured versus what's your read. What couldn't be seen (Stories,
  DMs, live calls).
- **How the data was pulled**, so it can be re-run on another creator.

Short quotes only, a few words each. Captions, scripts and transcripts stay in `.tmp/`, never in
the write-up. If the person wants a shareable version, offer to turn the README into a page or
doc. Sharing it is their call.
