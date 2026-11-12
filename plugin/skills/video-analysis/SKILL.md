---
name: video-analysis
description: Use when the person wants Claude to "watch" a video or a batch of videos and say what's in it — a Loom, a YouTube or TikTok link, a social media reel, a webinar replay, or a video file on their computer. Gets a transcript and a set of still frames, actually looks at the frames, and reports what is said AND shown. Also used by social-research for each post.
---

# Video analysis — "watching" a video

Claude can't play a video, but it can read what's said (a transcript) and look at still pictures
taken from it (frames). Together that's close to watching. **Always do both**: on-screen text,
demos and screen recordings carry things the words don't.

## Tools (check once, install only with a yes)

- `yt-dlp` (downloads videos and captions from a link) and `ffmpeg` / `ffprobe` (cuts frames and
  audio). Missing → after the person says yes: on a Mac `brew install yt-dlp ffmpeg`; on a Windows
  PC `winget install --id yt-dlp.yt-dlp -e --accept-source-agreements --accept-package-agreements`
  and `winget install --id Gyan.FFmpeg -e --accept-source-agreements --accept-package-agreements`
  (then Claude needs a restart to see them).
- **Transcripts:** if `OPENAI_API_KEY` is set, use OpenAI's `whisper-1` (fast; about $0.36 per
  hour of audio). Otherwise, on a Mac, use the free local `whisper-cli` (`brew install whisper-cpp`,
  plus a one-time model download of about 150 MB). It's slower, and each install needs a yes
  first. On a Windows PC there's no simple local install: ask the person whether to add an OpenAI
  key or work from the captions and frames only.
- Work in `.tmp/video/<short-name>/` so downloads never get committed.

## Steps, in order

Stop early once you have BOTH a transcript (or "no speech") AND frames you've looked at.

1. **Captions without downloading** (links only):
   `yt-dlp --skip-download --write-subs --write-auto-subs --sub-format vtt -o "captions" "<url>"`.
   If a `.vtt` appears, that's the transcript; skip step 4.
2. **Download:** `yt-dlp -o "video.%(ext)s" "<url>"`. A file on the computer: use it where it is.
   Failure usually means the video is private. Say so as the one thing the person must do (share
   it, or download it themselves). Don't retry endlessly.
3. **Frames, two passes, at most about 20 kept:**
   - Scene changes (where something new appears):
     `ffmpeg -i video.mp4 -vf "select='gt(scene,0.1)'" -vsync vfr scene_%03d.png`
     (0.3 finds almost nothing on screen recordings; 0.1 may still find nothing on a slow video).
   - Steady stride (the reliable one): `ffmpeg -i video.mp4 -vf fps=1/5 stride_%03d.png`
   - Short clips (under about 30 s): one contact sheet of 8 frames is enough:
     `ffmpeg -i video.mp4 -vf "fps=8/<seconds>,scale=360:-1,tile=4x2" -frames:v 1 sheet.jpg`
     (get `<seconds>` from `ffprobe -v error -show_entries format=duration -of csv=p=0 video.mp4`).
     The first frame usually shows the on-screen hook.
   - If both passes give more than about 20, keep all scene frames and thin the stride ones evenly.
4. **Transcribe** (when there were no captions):
   - **OpenAI** (the upload limit is 25 MB): make a small mp3,
     `ffmpeg -i video.mp4 -vn -ac 1 -ar 16000 -b:a 32k audio.mp3` (about 14 MB per hour). Over
     25 MB? Split it into 20-minute parts:
     `ffmpeg -i audio.mp3 -f segment -segment_time 1200 -c copy part_%02d.mp3`, transcribe each, and
     add 1200 s × the part number to its timestamps. The call:
     `curl -fsS https://api.openai.com/v1/audio/transcriptions -H "Authorization: Bearer $OPENAI_API_KEY" -F model=whisper-1 -F response_format=verbose_json -F file=@audio.mp3 > transcript.json`.
     Keep each segment's `no_speech_prob`.
   - **Local:** `ffmpeg -i video.mp4 -ar 16000 -ac 1 audio.wav`, then
     `whisper-cli -m <model> -f audio.wav -oj` (no size limit).
   **Watch out:** Whisper invents words on music-only clips, and writes out song lyrics on clips
   with licensed music. Treat lines with a high no-speech score, or lyrics, as "not the person speaking".
5. **Look at every kept frame** with the Read tool. Note on-screen text, what's being shown, and
   any change between frames.
6. **Clean up:** delete only what *you* downloaded or made in `.tmp/video/<short-name>/` (the
   downloaded video, `audio.*`, `part_*`), unless the person said to keep it. **Never delete or
   move a file the person pointed you to** on their computer. Keep the transcript and the frames
   you used.

## Report

- What is **said** (a summary, with timestamps for key moments) and what is **shown** (on-screen
  text, demos, settings, the people in it).
- The hook (first 3 seconds), the structure (beats with rough times), and the ask at the end, if any.
- What you couldn't tell (no speech, blurry text, private video).
- Short quotes only (a few words). Describe and summarize the rest.
