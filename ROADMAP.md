# Roadmap

Compact phase-by-phase backlog for **72 Seasons**. Latest phase summary first.

---

## ✅ Phase 1 — Foundation (shipped)

The bones. App opens, shows the current micro-season, navigates 72 of them.

- 72 kō data model (JSON + Dart) with sekki + meta-season + ukiyo-e illustrations
- Three core screens: Now / All 72 / Detail + Settings
- 72 classical haiku (UK + EN translations)
- Bilingual UI (UK + EN)
- Light + dark themes with per-meta palette
- Washi paper overlay texture, asymmetric haiku frame with seal-red dot
- Season calculator + unit tests
- First public GitHub release

## ✅ Phase 2 — Polish & launch prep (shipped)

Daily-use features.

- Local notifications (9 AM nudge on each new kō boundary)
- Moon phase indicator (Meeus algorithm) — eyebrow chip with %
- Share cards (1080×1350 PNG with illustration + haiku)
- iOS home-screen widget (medium 4×2)
- 30 ambient audio clips (per-kō overrides + meta-season fallbacks)

## ✅ Phase 3 — Depth, onboarding, calendar (just shipped)

Turned the reference app into an immersive experience.

- **Onboarding system** — splash + 4-page intro (current kō, 4→24→72 hierarchy with manual reveal, 9-tile category grid, brand close) + shakuhachi music with graceful fade
- **9 deep-dive cards per kō**: tea, food, hana, kasane robe colours, kōdō incense, kigo seasonal words, practice, period, sekki — toggleable in Settings
- **Calendar tab** (renamed from "Усі сезони"): List + Months segmented toggle. List groups kō by 24 fazi with alternating tile tints; Months is a 2×6 mini-month grid with per-month sekki legend, "now" banner, day-tap preview, today FAB
- **Tradition tab** refactor: horizontal chip TOC, decorative pull-quotes, collapsible per-section bodies
- **Terminology unification**: 4 пори → 24 фази (секкі) → 72 сезони (кō) — "мікросезон" / "підсезон" removed
- **Light-theme contrast pass**: `tintColorFor()` HSL helper + 6-step monotonic alpha ramp per sekki within meta
- **Audio session strategy**: ambient by default (auto-start respects silent switch), playback for explicit user taps (override silent), crossed-out icon when system mutes
- **UX polish**: today FAB on calendar, ambient hint bubble (one-time), tappable Tradition deep-link from onboarding, Russianism scrub of all UK content

## 🎯 Phase 4 — strategic forward plan

The product is now MVP-complete and competitive. Phase 4 is about
**deepening engagement** (existing users return daily) and **widening
reach** (new users discover us). Three tracks below — each can be
worked on independently; the order reflects ROI per dev-week.

### Track A — Retention (build the daily ritual)

| # | Item | Effort | Why now |
|---|---|---|---|
| **A1** | **Observation journal** — text + photo per kō, optional mood; "Last year you wrote…" recall | ~1 week | Biggest retention move. Turns the app from reference into a personal seasonal diary. No competitor has it. Local-only via `drift`/`sqflite` keeps it private. |
| **A2** | **Poem of the day** — 3-5 haiku per kō, daily rotation within the 5-day window | ~1 week (content) | Rewards opening every day, not just every 5. Cheap content lift on existing infra. |
| **A3** | **Lock screen widget / wallpaper export** — render current kō as iOS 17 lock-screen widget + 9:16 wallpaper PNG | ~3 days | Highest passive impressions: lock screen seen ~80×/day. Builds on existing share-card renderer. |
| **A4** | **Streaks-as-mindfulness** (opt-in, never naggy) — gentle "10 kō noticed" milestone tracker, not a counter | ~3 days | Tone-safe variant of gamification: rewards observation, not engagement. Toggle-off in Settings. |

### Track B — Reach (find the audience)

| # | Item | Effort | Why now |
|---|---|---|---|
| **B1** | **App Store launch** — final screenshots set (6 images), localized listing, ASO keywords, support page | ~1 week | We have the product; we don't have distribution. App Store is the single biggest discovery channel. |
| **B2** | **Companion site** (`72sezony.app`) — landing + per-kō detail pages SEO'd, Open Graph cards | ~3 days | Captures "what is shichijuni-ko" / "73 micro-seasons" search traffic. Generated from same JSON data. |
| **B3** | **Localized launch posts** — Ukrainian Telegram, r/LearnJapanese, r/JapaneseLanguage, HN Show HN with the taxonomy-clarity angle | ~2 days | Free reach where the audience already gathers. |
| **B4** | **Press / blog outreach** — slow-tech, mindfulness, calendar curiosity: hand-pick 10 publications | ~1 week | One quality writeup beats 1000 SEO impressions. |

### Track C — Ecosystem (deepen lock-in)

| # | Item | Effort | Why now |
|---|---|---|---|
| **C1** | **Apple Watch complication** — current kanji + days-left on the wrist | ~1 week | Underserved hardware; the kanji + dot signal works perfectly at 24 px. iOS users own AW at ~25%. |
| **C2** | **iPad version** — re-flow grid for tablet, "coffee-table calendar" feel | ~1 week | iPad-first is a meaningful niche for slow-living apps (Things, Day One, Calm). |
| **C3** | **iCloud sync** — for journal entries (A1 prerequisite for multi-device users) | ~3 days | Without sync the journal is single-device. Cheap with `cloud_kit` once journal is in. |
| **C4** | **Local climate comparison** — start with static city table, upgrade to Open-Meteo phenology API later | ~1 week | Strong pull for non-Japanese-living users: bridge the abstract Japanese kō to local lived experience. Especially powerful for Ukrainian audience. |

### Track D — Speculative / parked

Pull off the shelf only when something else slows.

| Idea | Why parked |
|---|---|
| **Audio-first kō** — narrator reads description + haiku + plays ambient | Nice but content burden (72×2 lang × narrator = expensive) |
| **AI "describe your day"** — match user prose to current/closest kō | Cool tech demo, low daily value, model cost |
| **Print PDF wallpaper calendar** | Niche gift, distracts from core |
| **Yearly review** ("you noticed 47 / 72 kō") | Requires journal + needs subtle handling |
| **Garden integration** (link to user's plants / track blooming) | Big scope, narrow audience |
| Social feed / user submissions | Server + moderation = product pivot |
| Full Japanese UI localization | Small audience; kanji already in data |
| Android home widget | Lower priority than iOS for now |
| Apple TV version | Beautiful but tiny audience |

### Recommended sequence

```
Week 1   — A1 Observation journal (foundation for A4 + C3 + future review)
Week 2   — A2 Poem of the day rotation
Week 3   — A3 Lock screen widget + wallpaper export
Week 4   — B1 App Store launch (use new content as marketing fuel)
Week 5   — B2 Companion site + B3/B4 outreach
Week 6+  — C1 Watch complication, C2 iPad, C3 sync, C4 climate
```

Six focused weeks → measurable retention + a real launch. Track A
runs first because B (reach) is more effective when there's a fresh
"daily journal" hook to mention in the launch post.

## 🧹 Tech debt

- Compress onboarding PNGs in `assets/images/onboarding/` (~7–8 MB savings)
- Audit `assets/images/ko/` engravings for further compression (optional)
- Reduce-motion compliance: respect `MediaQuery.disableAnimations` for onboarding crossfades
- Sticky meta + sekki headers in Calendar list view (recommended in design critique)

## ⚠️ Open issue — calendar sekki colour differentiation

Sekki cells inside one meta-season still read as one band on real
devices, both on the months grid and (to a lesser extent) on the
list view. Iterations explored so far:

| Attempt | What | Why it failed |
|---|---|---|
| Alpha step 0.05 (original) | `tint × (0.07 + idx*0.05)` | Adjacent sekki perceptually identical |
| Alpha step 0.08 → 0.10 → 0.13 | Wider gap | Top stops became "punchy / too bright" in light, "too contrasty" in dark; bottom stops still indistinct |
| HSL lightness ramp (0.92→0.52 light, 0.18→0.62 dark) | Solid colour walk per stop | Dark mode high sekki rendered near-saturated red — looked bad |
| Compressed alpha 0.06 + per-kō left stripe (current) | Tile bg = sekki, 4-px stripe = kō within sekki | Months grid now too subtle (no stripe to compensate); months bumped back to 0.08 step. List view OK with stripe + 0.06 step |

Current state: list view differentiates 18 kō clearly via *bg×sekki +
stripe×kō*, but the months grid still relies on alpha-only and the
six sekki stops within one meta blur into one tone band on small
day cells.

**Ideas to try next:**
- Different hue per sekki within a meta — e.g., very subtle `HSLColor.withHue` shift of ±5° per stop. Keeps the meta family but adds chromatic, not just luminance, separation.
- Sekki marker glyph in the day cell (a tiny dot, sub-cell, 2-px square) coloured by sekki accent — orthogonal cue, doesn't depend on bg alpha.
- Decorative diagonal hatching (1px stripes at ~15% alpha) in the day cell for sekki position — barely-there texture cue used in printed Japanese calendars.
- Pre-compute a 6-step palette per meta (designer-curated colour stops, not arithmetic) so each sekki has a hand-picked hue inside the meta family.

Whichever path, validate on real device in *both* themes — the eye reads alpha on OLED dark very differently from cream-paper light, and a ramp that works on one will collapse on the other (we hit this twice already).

---

## How to read this roadmap

Phase 1 → 2 → 3 are shipped. Phase 4 is parked but not forgotten.

When picking next work: **Observation journal** is the biggest retention move. **Poem of the day** is the easiest content win. Local climate comparison is the strongest pull for Ukrainian audience.

Last updated: Phase 3 ship — 9 cards, calendar overhaul, tradition refactor, light-theme pass, audio session strategy.
