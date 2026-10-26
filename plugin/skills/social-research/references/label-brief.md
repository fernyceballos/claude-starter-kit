# Per-post labeling brief (give this to each labeling subagent)

You're labeling one batch of a creator's posts so we can find the patterns in what they do.
Record careful observations based on what's there. **Don't guess beyond what the card shows.**

The **study definitions** (the creator's offers, the expected content pillars, and the meaning of
Attract / Influence / Enroll) are at the top of the study README. Read them first. They fill
`offer_line`, `pillar` and `intent_*`.

## Inputs per post

A card file in `.tmp/<subject>/cards/` with: the stats, the caption, the timestamped transcript
(each line has a no-speech score `nsp`; Whisper **invents words on music-only clips** and writes
out **song lyrics** on licensed-music posts, so treat those lines as "not the creator speaking"),
the first page of comments with the creator's replies, and a `sheet=` line pointing to a contact
sheet (8 frames, left to right, then top row to bottom row). The first frame usually shows the
on-screen hook. **Open the sheet with the Read tool.** On short text-over-video posts, the
on-screen text IS the message. Read it carefully. For long live replays, label from the first
few minutes of transcript plus the caption.

## Output

Write ONE JSON file (an array, one object per post, in card order) to the path in your task.
These labels stay in `.tmp/` (never committed, never pasted into a report), so the verbatim
fields are for analysis only.

```
{
 "n": 12, "code": "...",
 "format": "text_over_video | talking_head | talking_head_demo | tutorial_voiceover | tutorial_text | voiceover_broll | lip_sync_or_skit | live_replay | slideshow | other",
 "speaks": true/false,
 "setting": "short phrase (car, kitchen, office, outdoors...)",
 "on_screen_text": "all overlay text across the frames, in order, verbatim, or null",
 "on_screen_hook": "overlay text in frame 1, verbatim, or null",
 "spoken_hook": "first spoken sentence, verbatim, or null",
 "hook_type": ["relatable_pain" | "curiosity" | "myth_or_contrarian" | "numbered_list" | "personal_story" | "result_proof" | "question" | "callout" | "how_to_demo" | "humor" | "aspiration_lifestyle" | "objection_handling" | "other"],
 "audience_callout": "the words naming who it's for, or null",
 "offer_line": "<one of the study's offers> | none",
 "topic": "short phrase",
 "pillar": "<one of the study's pillars> | other",
 "beats": ["0s hook: ...", "3s ...", "caption: ... (what the caption adds)"],
 "value_delivered": "what a viewer gets even if they never buy (1 sentence), or 'none'",
 "value_type": "tutorial | tip | story | proof_result | lifestyle_aspiration | offer_details | motivation | humor | none",
 "story_elements": ["personal details used"],
 "proof_elements": ["numbers, results, claims, before/after"],
 "product": {"mention": "none | implied | category_named | explicit", "what": "how they refer to it", "where": ["video","caption"]},
 "cta": {"type": "comment_keyword | dm_keyword | link_in_bio | comment_question | save | follow | share | none",
         "keyword": "WORD or null", "where": ["spoken","caption","on_screen"],
         "promise": "what they promise to send, or null",
         "verbatim": "the call-to-action sentence (<20 words), or null"},
 "caption_pattern": "short_quip | keyword_cta_short | story_essay | list | tutorial_steps | offer_details | faq_objections | other",
 "caption_structure": "1 sentence on how the caption is built",
 "caption_extras": ["discount note", "deadline", "hashtags: ...", "filter-dodging spellings"],
 "reply_pattern": "how they answer commenters on page 1 (e.g. 'every keyword comment gets a varied reply = likely automated'), or null",
 "intent_primary": "attract | influence | enroll",
 "intent_secondary": "attract | influence | enroll | null",
 "intent_confidence": 1-3,
 "intent_evidence": "one sentence on what in the post shows its job",
 "comment_signal": "what the first-page comments show (keyword volume, questions, objections, praise)",
 "notable_lines": ["up to 3 short phrases (<15 words) that show a reusable pattern"],
 "claims_language": "how they phrase health or income claims (hedged? specific numbers?), or null",
 "notes": "anything unusual (borrowed trend audio, collab, live replay), or null"
}
```

## Intent rules (apply the same way every time)

- **enroll**: the post or its caption is built around an offer AND asks for a step (a keyword,
  DM or link). One product demo with "comment WORD for the link" counts as enroll.
- **influence**: mainly teaches, shows, tells their story, or shows results or the life their
  business gave them. It may end with a keyword, but the offer isn't the center.
- **attract**: built for reach from strangers (relatable, funny, a trend, a quick tip), with no
  offer ask. A save or follow ask is fine.
- Unsure between two? Put the stronger one in `intent_primary`, the other in `intent_secondary`,
  and set `intent_confidence` to 1.
