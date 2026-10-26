---
name: design-systems
description: Use when doing visual design or layout work — building or restyling a page, site, app screen, component, funnel, or landing page (in code or by instructing an AI website builder), or when the person names a brand look (e.g. "make it feel like Linear / Apple / Notion"). Provides ~150 brand-grade design systems (colors, type, spacing, Tailwind v4 themes, component examples) to apply to the real work. Do NOT use for pure logic, data, or backend work with no visual surface.
---

# Design Systems

About 150 ready-made design systems from the open-source Open Design project. They live
**outside the plugin**, in `~/.claude/starter-kit/design-systems/`:

- `CATALOG.md`: one line per system (name and a short description).
- `systems/<name>/DESIGN.md`: the written look-and-feel rules (the important one).
- `systems/<name>/tokens.css`: colors, type and spacing as CSS variables.
- `systems/<name>/tailwind-v4.css`, `components.html`, and sometimes `USAGE.md`,
  `design-tokens.json`, `components.manifest.json`.

**If that folder is missing**, fetch it (about 11 MB, free, no account needed):
`bash refresh.sh` from this skill's own folder (or
`bash "$(starter-kit-root)/skills/design-systems/refresh.sh"`)

## Workflow

1. **Pick a system.** If the person named a brand or look, use it. Otherwise open `CATALOG.md`,
   suggest 2–3 that fit with a one-line reason each, recommend one, and let them choose.
2. **Read the kit.** Read that system's `DESIGN.md` first, then `tokens.css`. Read
   `tailwind-v4.css` and `components.html` only when they're relevant.
3. **Apply it to the REAL work; adapt, don't paste.** These are reference kits, not drop-in
   code. In code, map their colors, type and patterns onto the project's existing components and
   conventions. With an AI website builder, describe the look in words and exact values (colors,
   fonts, spacing) in your instructions to it.
4. **The project's rules win.** Follow the project's established patterns, component library,
   styling approach, and anything in its CLAUDE.md over what the kit suggests.

These are look-and-feel *inspirations*, not official brand assets. Licensing details are in
`ATTRIBUTION.md` (upstream is MIT).
