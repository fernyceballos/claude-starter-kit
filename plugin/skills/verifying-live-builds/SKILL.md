---
name: verifying-live-builds
description: Use when about to say that something built is done or working — a page, site, form, automation, setting, or app feature — before publishing, after publishing, after a domain or DNS change, or when reporting that a rebuild matches the original.
---

# Verifying live builds

**REQUIRED BACKGROUND:** `superpowers:verification-before-completion` (evidence before claims).
This skill says what evidence counts.

## 1. Define "done" before you build

Write the checks up front ("every page loads at the real address, every link goes where the
original's did, the form sends to a test contact"). Check against that list, not a feeling.

## 2. Check on the real thing, read-only

- **Preview first, then the live address.** They can differ; check both when you publish.
- Use page text and JavaScript, not just screenshots: titles, broken images (make lazy images
  load first), every page's status, the "not found" page, redirects, phone width (375 px: no
  sideways scrolling, the menu works).
- **Rebuilding something that exists?** Compare **where each link goes**, page by page, against
  the original. Matching screenshots aren't enough; hidden pages and wrong links don't show in them.
- **Forms and automations:** test only with a contact or account that belongs to the person, in
  test or draft mode. Never run a test that changes real contacts, payments or live data without
  a yes (`getting-approval-before-live-changes`).
- **Code:** run the tests and show the output. For anything with a screen, look at it in a browser.
- Never type real passwords or card numbers while testing. Remove tokens and personal data from
  anything you save.

## 3. Report honestly

- Say what passed, **what failed**, and **what you didn't check**.
- "Couldn't check" isn't "passed". If there was nothing to compare against, say so.
- After a domain or DNS change: load the real domain, a deeper page, the `www` version, and a redirect.

## These thoughts mean STOP

| Thought | Reality |
|---|---|
| "The preview looked right." | Check the published address too. |
| "The screenshots match." | Hidden pages and wrong links don't show in screenshots. |
| "I'll only mention what worked." | Say what you didn't check. |
| "No test contact, I'll use a real one." | Stop. Ask. |
