# Instagram: the proven way to pull a creator's reels

Proven on three creators, including 175 reels end to end in about 1.5 hours. Everything runs in
the person's own signed-in Chrome, from the creator's profile page, using Instagram's own web
calls (the same ones the page makes when you scroll). Go slowly: about 2.2 seconds between calls.
That pace made about 360 calls with no blocking.

## 1. Get the profile id

Open `https://www.instagram.com/<handle>/` and read the page HTML for `"profile_id":"<digits>"`.

## 2. Collect the reel codes

Open the profile's Reels tab. Scroll by calling `scrollIntoView()` on the **last tile**, over and
over (`window.scrollTo` loads nothing). Collect each reel's shortcode from its link
(`/reel/<shortcode>/`). Run the loop in the page at about 2.2 s per step. It runs faster while a
tool call is active in the tab, and slower when idle (Chrome slows timers in background tabs).

## 3. Turn each shortcode into a media id (pk)

A shortcode is the id written in base-64 with the alphabet
`ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_`. Read it left to right:
`pk = pk * 64 + index(char)`. Use `BigInt` in JavaScript, because the numbers are too big for a
normal number.

## 4. One call per reel gets nearly everything

`GET /api/v1/media/<pk>/info/` from the page (same site), with headers:
- `X-CSRFToken`: the value of the `csrftoken` cookie
- `X-IG-App-ID: 936619743392459`
- `X-Requested-With: XMLHttpRequest`

It returns `play_count`, `like_count`, `comment_count`, `video_duration`, the posting time, the
full caption, `clips_metadata.audio_type` and `original_sound_info` (whose sound it is), and
`video_versions` (direct video file links).

## 5. Comments and the creator's replies

`GET /api/v1/media/<pk>/comments/?can_support_threading=true&permalink_enabled=false` gives page
1 of comments. `preview_child_comments` shows the creator's replies, which is how you spot
automated "Sent!" style replies.

## 6. Export

Build one JSON object in the page with everything, and download it with a temporary
`<a download>` link click. It lands in `~/Downloads`; move it into `.tmp/<subject>/data/`.

## 7. Videos

`curl` each `video_versions` URL straight to `.tmp/<subject>/videos/` (no yt-dlp needed). A few
fail the first time and work on a retry. Then `video-analysis` (contact sheets plus transcripts).
Whisper `whisper-1` on 175 reels (about 3.6 hours of audio) cost about $1.30.

## What does NOT work (don't waste calls)

- `/api/v1/users/web_profile_info`: blocked (429) on the first call.
- `POST /api/v1/clips/user/`: returns empty.
- `/api/v1/feed/user/<id>/`: returns HTML.
- The highlights tray: empty. `feed/reels_media`: error 500.
- **Story highlights:** click the highlight circle on the profile, pause it, and take a screenshot
  of each frame instead.

## Tool traps

- Long code-like strings (shortcodes, highlight links) may get hidden in tool output. Print them
  with dots between characters, then remove the dots.
- Keep every request on the same site as the page. Calls from another site are blocked.
