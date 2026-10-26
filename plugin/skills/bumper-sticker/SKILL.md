---
name: bumper-sticker
description: Use when the person says "bumper sticker" — e.g. "bumper sticker that", "give me the bumper sticker", "explain that as a bumper sticker", "bumper sticker version". Compresses whatever was just being discussed into scannable plain English — bulleted, HARD CAP 20 words per bullet, no jargon, no code identifiers, no preamble. Also fires when they ask for something "in plain english, bulleted", "in 5th grade english", or "quickly so I can understand it". Two shapes — EXPLANATION (default, the bullets) and DECISION (the four-part Question/Context/Recommendation/Confidence format). Do NOT fire for prompts being authored to Claude Code, commit messages, GitHub issues, or spec/plan documents — those are technical-audience surfaces where full detail belongs.
---

# Bumper sticker

The person says **"bumper sticker"** when an explanation was too long, too technical, or
too slow to scan. It is a compression request, not a request for less substance:
they still want the real content, in a form they can read in fifteen seconds and act
on.

## Two shapes — pick by what you are compressing

**If you are EXPLAINING something** (an issue, a finding, a bug, a trade-off,
what you just did, why something broke) → **bullets, 20 words max each.** This is
the default and the shape the person asked for by name.

**If you are asking them to DECIDE something** → use the four-part decision
format instead: **Question, Context, Recommendation + reasoning, Confidence.**
A decision needs a recommendation and a confidence level, which bullets do not
carry. Do not replace it with bullets.

When one response has both (an explanation AND a decision it leads to), give the
bullets first, then the four-part block. Never merge them.

## The explanation format — rules

1. **Bullets only.** No intro paragraph, no "here's a summary", no closing
   paragraph. The bullets ARE the answer.
2. **Hard cap 20 words per bullet.** Count them. If a bullet runs over, it is two
   bullets or it is cut.
3. **Plain English, hard rule.** No file paths, function names, command flags,
   API field names, or acronyms they'd have to unpack. If a term would make them
   stop and think "what does that mean?", replace it with the business
   consequence.
4. **One idea per bullet.** No semicolons stitching two thoughts together.
5. **Order for comprehension, not chronology.** What it is → why it matters → what
   it cost or risked → what is true now. Their most likely question, answered first.
6. **Lead with the fact, not the setup.** "Long videos drift out of sync by three
   seconds" beats "There's a thing about how segments get glued together where…".
7. **Bold the one bullet that changes what they do**, if there is one. At most one.
8. **8–12 bullets is the working range.** Fewer if the topic is small. If you need
   more than about 12, you are explaining two topics — ask which one they want, or
   split with a one-line heading.
9. **Say what is still unknown.** A bumper sticker that hides the uncertainty is
   worse than a long answer that admits it. One bullet is enough.
10. **A short bolded consequence line after the bullets is allowed** when there is
    a "so what" that does not fit a bullet — e.g. who it affects, or what it costs.
    One or two sentences maximum, and only when it genuinely adds something.

## Include the correction if you got it wrong

If the thing being compressed involves you having been wrong earlier, the bumper
sticker MUST carry that — plainly, in a bullet, without ceremony. Do not use
compression as a way to quietly drop an error. The example below does this in
two of its bullets.

## Worked example

They asked: *"why aren't leads from my new page showing up? bumper sticker it."* The answer:

- The sign-up form on your new page works, but its leads went nowhere.
- The form was sending to an old list you stopped using last month.
- I told you earlier the page was fine. That was wrong. I only checked how it looked.
- I never sent a test lead through it. I should have.
- Now it sends to your main list, and I sent a test lead to prove it.
- The test lead showed up in your main list with the right tag.
- **About 40 people signed up this week and landed on the old list.**
- They are safe there. Nothing was lost or deleted.
- You can move them to the main list in one step, if you say yes.
- I have not checked your other two pages yet.

Note what it does: names the effect on the business first, admits the earlier
mistake in plain words, says what is true now, and says what is still unknown. No
tool names, no settings names, nothing to look up. Every bullet is under 20 words
and uses words a ten-year-old would say.

## The vocabulary contract — fifth-grade words

Every bullet reads at a fifth-grade level. A ten-year-old reads it once and gets it.

This is a different rule from "no jargon" above. Jargon is shop talk. This is about
ordinary grown-up words that are still too big: *audited, contradictory, consistently,
explicitly, recommendation, significant, approximately, sufficient.* They are not
jargon. They are still wrong here.

**The test, applied to your own draft before you send it:** find every word of three
or more syllables. Each one is a flag, not a verdict. Read it and ask the real
question: **would a ten-year-old say this word?** *Every, another, different,
examples, remember* pass — they are long and ordinary. *Consistently, explicitly,
approximately* fail. Replace the failures with a shorter word that means the same
thing. If no shorter word exists, the sentence is carrying too much — split it into
two bullets.

**The swap table below is binding, not suggestive.** If a word appears in its left
column, that word does not appear in your output. Not once, not "just this time
because it is precise". The right column is what you write instead.

**Swaps that come up constantly:**

| Instead of | Write |
|---|---|
| we audited / we evaluated | we went through / we read |
| contradictory | they disagree / they don't match |
| consistently | every time |
| explicitly | outright / in so many words |
| recommendation | what I'd do |
| improvement | it got better |
| significant | real / big enough to matter |
| approximately | about |
| implement / deploy | build / turn on / put live |
| verify / validate | check / prove |
| initial / prior to | first / before |
| additional | more |
| currently | right now |
| sufficient | enough |
| utilize | use |
| demonstrate | show |
| potential | could |
| resolve | fix |
| attempt | try |
| require | need |
| however | but |
| therefore | so |

**What the rule governs: the words YOU pick.** A person's name, a product name, a
number, or a phrase quoted from the person or anyone else passes through exactly as it is.
Those are not vocabulary choices, so the rule never reaches them.

**The bar is one sentence long:** if you would not say it to a smart ten-year-old
who knows nothing about the business, rewrite it.

## Red flags — you are not doing this right

| Symptom | Fix |
|---|---|
| A bullet over 20 words | Split it or cut it. Count, don't estimate. |
| An intro sentence before the bullets | Delete it. Start with bullet one. |
| A file path or function name in a bullet | Replace with the business consequence. |
| Every bullet bolded | Bold at most one — the one that changes their next action. |
| The bullets are all "what" and no "so what" | Add the consequence: cost, risk, who is affected. |
| You dropped an error you'd made earlier | Put it back. Compression is not amnesty. |
| A word with three or more syllables | You picked it. Swap it for a shorter one. |
| It reads like a status report to a colleague | Wrong audience. Write it for a smart ten-year-old. |
| Asking a decision with bullets and no confidence level | Use the four-part decision format instead. |
| 15+ bullets | You are compressing two topics. Split, or ask which they want. |
