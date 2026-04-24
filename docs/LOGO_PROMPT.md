# Logo prompts for 72 Seasons

Prompts for Microsoft Designer / DALL-E 3 / Midjourney to generate an
iOS+Android app icon for **72 Seasons** (七十二候 Shichijūni-kō) — the
Japanese micro-seasons calendar app.

Palette reference (match inside the image):

| Meta     | Hex       |
|----------|-----------|
| Spring   | `#F4B5C1` |
| Summer   | `#8FBF7F` |
| Autumn   | `#D89060` |
| Winter   | `#8DAAC7` |

Technical target: **1024×1024 PNG**, centered, iOS rounded-square mask
applied by the system (so keep safe margins of ~8% on each side), must
remain readable at 60×60 px on a phone home screen.

---

## Prompt 1 — primary ("seasonal emblem")

> A premium iOS app icon, perfectly square 1024×1024, designed for a
> contemplative Japanese micro-seasons calendar app called "72 Seasons"
> (七十二候). Concept: a circular emblem divided into four soft arc
> segments representing the four meta-seasons — upper-left soft pink
> `#F4B5C1` (spring, hint of plum blossom), upper-right sage green
> `#8FBF7F` (summer, hint of bamboo leaf), lower-right warm ochre
> `#D89060` (autumn, hint of maple), lower-left pale blue-grey
> `#8DAAC7` (winter, hint of snow crystal). In the exact center, a
> stylized traditional Japanese hanko seal in deep vermilion red
> featuring the kanji 候 (kō) or the numerals 72 in classic
> brush-calligraphy style. Background: warm cream washi paper texture
> with very subtle visible fibers. Style: ukiyo-e woodblock print
> tradition meets modern app-icon minimalism — hand-painted sumi-e
> brushstrokes, not vector-crisp. Zen aesthetic. Flat traditional
> Japanese palette. Negative space generous. No gradients, no neon, no
> glossy 3D, no drop shadow, no sans-serif typography outside the
> seal, no western seasonal clichés. Designed to remain recognizable
> at 60×60 pixels among a grid of other iOS apps.

---

## Prompt 2 — single-element ("one branch, four seasons")

> A premium iOS app icon, 1024×1024, for the "72 Seasons" Japanese
> micro-seasons calendar. Subject: a single slender tree branch
> arranged in a gentle curve, showing four stages of the year from
> bottom to top — bare branch with a single pink plum blossom bud
> (spring), then fresh green leaves (summer), then an amber autumn
> leaf mid-fall (autumn), then a bare branch catching a single
> snowflake (winter). Hand-painted sumi-e ink-on-washi feel. Muted
> palette in the four meta-season colors (`#F4B5C1`, `#8FBF7F`,
> `#D89060`, `#8DAAC7`) applied delicately, not dominant. Background:
> warm off-white washi paper with a barely-there grid of 72 very
> small dots or tick-marks in a neutral tone, representing the 72 kō.
> Asymmetric composition, negative space on one side. Zen,
> contemplative, editorial. No cartoon, no photo-realism, no gloss.

---

## Prompt 3 — calligraphic ("kanji-forward")

> A minimalist iOS app icon, 1024×1024, for "72 Seasons" (七十二候).
> Center composition: the single kanji 候 painted in confident
> one-stroke sumi-e black ink, large and clean, taking ~55% of the
> icon area. Four tiny colored square pigment stamps near the four
> corners of the icon in soft pink `#F4B5C1`, sage `#8FBF7F`, ochre
> `#D89060`, blue-grey `#8DAAC7` — each no larger than 8% of the
> icon side, representing the four meta-seasons. Background: warm
> cream washi paper with faint fiber texture. Small vermilion hanko
> seal in one lower corner with the numerals 72. Zen aesthetic,
> generous negative space, hand-painted quality (not vector). Must
> read cleanly at 60×60 px.

---

## Prompt 4 — landscape ("ukiyo-e micro-scene")

> A premium iOS app icon, 1024×1024, inspired by Hokusai and
> Hiroshige ukiyo-e woodblock prints, for the Japanese
> micro-seasons calendar "72 Seasons". Subject: a tiny stylized
> landscape — a single rolling hill with one slender bare tree,
> a distant pale circle representing sun or moon, and a flight of
> three small birds in a soft arc. Palette limited to warm cream
> background and four accent colors that bleed gently from one
> region to another: pink `#F4B5C1` in the sky's upper-left, sage
> `#8FBF7F` on the hill, ochre `#D89060` across the horizon,
> blue-grey `#8DAAC7` in the foreground water. Traditional
> woodblock texture — visible grain, hand-carved linework. Small
> red hanko seal with "72" in a lower corner. No text. No modern
> effects.

---

## Tips for Microsoft Designer (DALL-E 3)

1. **Use Image Creator**, not "Design" mode. The Design templates are
   wrong for an app icon — the Image Creator is the DALL-E 3 surface.
2. **Generate, then iterate.** First pass is a draft. If one variant
   has the right shape but wrong colors, describe it back and ask
   "same composition but soften the palette". DALL-E 3 is good at
   follow-ups within a session.
3. **Expect 4 results per request.** MS Designer generates a grid.
   Pick best 1-2, regenerate variations of each.
4. **One subject at a time.** If output is cluttered, re-run with
   "simple composition, one central motif only".
5. **Aspect ratio.** Prompt `perfectly square 1:1` explicitly.
   MS Designer sometimes defaults to 4:3 even for "app icon".
6. **DALL-E mangles small text.** Kanji `候` or numerals `72` often
   render as gibberish glyphs. Two strategies:
   - Generate the composition *without* the glyph, then add the
     hanko seal manually in Figma/Photopea afterwards.
   - Leave `候` in the prompt and accept that one-in-four may be
     wrong; re-roll until one renders clean.
7. **Hex codes are hints, not rules.** DALL-E reads color *names*
   more reliably. Keep both in the prompt (e.g. "soft blush pink
   #F4B5C1") — the hex is a tiebreaker, the name is the command.
8. **Avoid the word "logo".** DALL-E associates "logo" with
   corporate flat vector work and modern typography. Use
   "app icon" or "emblem" instead — gets more artisanal results.
9. **Upscale at the end.** Use MS Designer's built-in upscale to
   get 2048+ px, then resize to exactly 1024×1024 for app stores.

## Recommended order of attempts

1. **Prompt 1 (emblem)** — most "app icon"-like, most likely to
   produce something usable on first try.
2. **Prompt 3 (calligraphic)** — if 1 feels too busy. Clean, bold,
   but risks rendering wrong kanji.
3. **Prompt 2 (branch)** — elegant but asymmetric; may not read at
   60×60 px.
4. **Prompt 4 (landscape)** — beautiful but most likely to lose
   detail at small sizes. Best for marketing art, maybe not icon.

---

## After you have a final PNG

Use `flutter_launcher_icons` package to regenerate all platform
icon sizes from a single source:

```yaml
# pubspec.yaml
dev_dependencies:
  flutter_launcher_icons: ^0.14.4

flutter_launcher_icons:
  android: "ic_launcher"
  ios: true
  remove_alpha_ios: true
  image_path: "assets/brand/app_icon.png"
  adaptive_icon_background: "#FDF6EE"   # warm washi cream
  adaptive_icon_foreground: "assets/brand/app_icon_fg.png"
```

Then:

```bash
dart run flutter_launcher_icons
```

This generates all `AppIcon.appiconset/*.png` (iOS) and
`mipmap-*/ic_launcher*.png` (Android) from the source.
