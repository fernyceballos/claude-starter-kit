# Researcher kit: study people, content and markets

In this folder, Claude studies a person, brand or topic (a social profile, a set of videos,
competitors, a market), and writes up what it finds.

## One folder per study

- Each study gets `docs/research/<YYYY-MM-DD>-<subject>/README.md`. It holds the findings, the
  method (so it can be re-run), and a "where everything lives" table.
- Raw downloads (videos, audio, exported data, frames) go in `.tmp/<subject>/`. Git ignores
  that folder, so big files and other people's words never get committed.
- Use the `social-research` skill to study a profile and the `video-analysis` skill to
  "watch" a video (transcript plus frames).

## Rules for research

- **Use the person's own signed-in browser, slowly.** About 2 seconds between requests. Going
  fast can get an account limited.
- **Delete downloaded videos and audio** once they're transcribed, unless the person says keep them.
- **Summarize, don't copy.** Reports describe and summarize what someone does. They never paste
  a caption, script or post word for word. Short quotes only, a few words at most.
- **Nothing collected gets posted or shared** without the person's yes.
- **Say how sure you are.** Mark what's measured (counts, dates) apart from what's your read
  (why something worked).
