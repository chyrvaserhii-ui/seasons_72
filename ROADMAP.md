# Roadmap

All-in-one backlog for 72 Seasons. Organized by phase and priority so
you can pick up where we left off.

Current status: **Phase 1 complete, Phase 2 in progress**.

---

## ✅ Phase 1 — shipped

- [x] 72 kō data model (JSON + Dart models)
- [x] 3 core screens (Now, All 72, Detail) + Settings
- [x] 72 AI-generated ukiyo-e illustrations
- [x] 72 classical haiku with EN + UK translations
- [x] Bilingual UI (EN + UK)
- [x] Light + dark themes with per-season palette
- [x] Washi paper overlay texture
- [x] Tradition tab (history + 6 sections of context)
- [x] Bottom navigation with refined icons
- [x] Asymmetric haiku framing (top rule + bottom with seal dot)
- [x] Season calculator with unit tests
- [x] First public GitHub release

---

## 🚧 Phase 2 — in progress

### P2.1 Local notifications ✅

Shipped. Toggle in Settings, pre-schedules 60 ahead, fires at 9 AM on
each new kō boundary. Supports ICU plurals in Ukrainian.

### P2.2 iOS Home Screen Widget ⏳

**Blocked on Xcode update.** Swift code, Dart bridge, and WidgetKit
scaffold are ready in `ios/SeasonsWidget/` + `lib/core/widget/`.
Follow `WIDGET_SETUP.md` when Xcode is current.

Acceptance:
- Medium (4×2) widget shows current kō with illustration, name,
  days-until-next, meta palette tint.
- Tappable → opens app on Now tab.

### P2.3 Launch prep & screenshots 🟡

**Paused for tomorrow.** `docs/LAUNCH_KIT.md` + `docs/SCREENSHOTS.md`
are ready. Needs:
- 6 polished screenshots taken + committed
- GitHub Pages enabled (points at `docs/index.html`)
- First 1-2 launch posts (Ukrainian TG + r/LearnJapanese)

---

## 📋 Phase 3 — next features (prioritized)

### P3.1 Moon phase indicator 🌙 ⭐ **START HERE**

- **Effort**: ~1 day
- **Why first**: Tiny scope, closes the "why no moon?" gap for a
  traditional Japanese calendar (it was historically lunisolar), no new
  dependencies needed.
- **Acceptance**:
  - Small moon glyph on Home screen (near date range or progress bar)
  - Updated daily, computes from system date via known algorithm
  - Tap → short tooltip with phase name + next full/new moon date

**Implementation notes**: Use the Meeus algorithm for lunar phase
calculation — ~30 lines of Dart. No external API needed. Add
`lib/core/utils/moon_calculator.dart` and a `MoonPhase` widget.

### P3.2 Share cards 📤 ⭐ **HIGH IMPACT**

- **Effort**: ~2-3 days
- **Why**: Organic growth. Each user can become a marketer by posting
  their season to Instagram/Twitter.
- **Acceptance**:
  - "Share" button on detail screen → generates 1080×1350 PNG
  - Card layout: illustration + localized name + haiku + app footer
  - Saves to Photos or shares via system sheet (iOS) / intent (Android)
  - Optional: 2-3 card style variations

**Implementation notes**: Use `RepaintBoundary` + `toImage()` to
render a Flutter widget subtree to PNG. Package:
`share_plus` for system share. Keep style close to the app's
redactional minimalism.

### P3.3 Observation journal 📝 ⭐ **BIG DIFFERENTIATOR**

- **Effort**: ~1 week
- **Why**: Highest retention impact. Transforms the app from a
  reference to a personal practice. No competitor has this.
- **Acceptance**:
  - Tap on "+" in any kō detail → opens journal entry screen
  - Add text note, photo (camera or library), optional mood icon
  - Entries listed chronologically on a new "Journal" tab or under
    each kō's detail
  - "Look back" feature: "Last year you wrote..." when the same kō
    comes around

**Implementation notes**: Use `drift` or `sqflite` for local storage
(SQLite under the hood). `image_picker` package. Photos stored in app
documents folder as resized 1024px files. No cloud sync (keep private
and simple).

### P3.4 Circular year visualization 🎡

- **Effort**: ~2-3 days
- **Why**: Beautiful, big-picture understanding. Good screenshot for
  marketing.
- **Acceptance**:
  - New screen (or secondary tab) showing all 72 kō as a circle
  - Current position highlighted with a glow
  - Tap any segment → jump to that kō's detail
  - Thin connecting lines to meta-season quadrants

**Implementation notes**: `CustomPainter` with polar coordinates.
Could be the hero image of the Tradition tab (replace current 2×2
collage). ~400 lines of Flutter code.

### P3.5 Kigo dictionary 📚

- **Effort**: ~2 weeks (mostly content research)
- **Why**: Serves the haiku writer niche deeply. Unique value no
  competitor has.
- **Acceptance**:
  - Each kō has 3-5 associated `kigo` (seasonal words)
  - Tap a word → definition + one example haiku using it
  - Searchable glossary
  - Bilingual (EN + UK definitions)

**Implementation notes**: The main lift is research — good reference
is "A Dictionary of Haiku Seasonal Words" by Kenkichi Yamamoto.
~300 entries to collect. Data schema similar to haiku — pair each
kigo with an author and source.

### P3.6 Local climate comparison 🌍

- **Effort**: ~1 week
- **Why**: Bridges Japanese tradition to user's lived experience.
  Strong for Ukrainian audience.
- **Acceptance**:
  - Settings → "Your location" (city dropdown or geolocation)
  - On detail screen: sub-card "In [city], typical timing: [range]"
  - Compare sakura, first frost, migration dates for the user's climate

**Implementation notes**: Start static — one table of ~20 major cities
(Kyiv, Lviv, Warsaw, Berlin, London, NYC, SF) with seasonal-event
dates. Can upgrade to dynamic with
[Open-Meteo](https://open-meteo.com) phenology API later if needed.

### P3.7 Ambient sounds 🎧

- **Effort**: ~1 week (content + player integration)
- **Why**: Serves the meditation audience. Sensory immersion.
- **Acceptance**:
  - Each kō has a ~20-second loop (frogs for #19, cicadas for #38,
    rain for #4, wind for #56)
  - Play button on detail screen, stops on leaving screen
  - Optional background mode
  - Toggle in Settings (off by default)

**Implementation notes**: Source CC0 audio from
[Freesound.org](https://freesound.org). Target ~500KB per clip
compressed = ~36 MB for all 72. Use `just_audio` package. Don't
auto-play — respect user choice.

### P3.8 Poem of the day 📜

- **Effort**: ~1 week (content)
- **Why**: Daily engagement — each day within a kō is a different
  haiku. Rewards frequent opening.
- **Acceptance**:
  - Expand haiku data model: each kō has 3-5 haiku instead of 1
  - Home screen shows different haiku each day of the 5-day window
  - "Browse all poems for this kō" in detail screen
  - Total: ~300 haiku translated

**Implementation notes**: Biggest work is content — needs care to find
matching classical haiku. Can be a gradual rollout: start with 2 per
kō, grow to 5 over time.

### P3.9 Seasonal foods (washoku) 🍱

- **Effort**: ~1-2 weeks (content research)
- **Why**: Practical value for travelers and food lovers. Culturally
  complete.
- **Acceptance**:
  - Each kō has 2-3 seasonal foods with short description
  - Icon (sushi/rice/tea cup/etc.) + name + one-line explanation
  - Optional: link to one recipe per food (external)

**Implementation notes**: Research-heavy. Start with the iconic
shun (旬) foods for each sekki, then split by kō. Example sources:
*Season Calendar* app references, Maiko Japan's articles.

---

## 🧹 Polish & cleanup (tech debt)

| Item | Why |
|---|---|
| **Compress onboarding PNGs** in `assets/images/onboarding/` | Each is ~2.5–3 MB (Microsoft Designer raw exports). Through tinypng.com or squoosh.app they shrink to ~800 KB–1.2 MB without visible quality loss. ~7–8 MB savings on bundle size. Apply when onboarding visuals are finalised so we don't compress twice. |
| Audit other PNGs in `assets/images/ko/` | 72 engravings × ~120 KB each. Already lean, but a TinyPNG pass might shave a further 20–30%. Optional. |

---

## 🔮 Phase 4 — future / maybe

| Idea | Why skip for now |
|---|---|
| Apple Watch complication | Niche hardware, big platform scope |
| Android home widget | Scaffold-ready via `home_widget`, but lower priority than iOS |
| Social feed (user observations) | Server + moderation = product pivot |
| User-submitted haiku | Moderation burden |
| Push "go outside" reminders | Can feel naggy, rhythm is hard to get right |
| Printable wall calendar PDF | Nice gift, niche use |
| Gamification (streaks, badges) | Breaks the serene tone |
| Full Japanese UI localization | Small audience; kanji already present in data |

---

## How to read this roadmap

- **P3.1 → P3.2 → P3.3** is the recommended order for next work. Each
  stands alone; you can reorder if interests change.
- Effort estimates assume single dev, intermittent work. Double if
  you're learning as you go.
- Any item here is "parked" — I don't forget it, and you can pull it
  off the shelf anytime.

Last updated: launch prep paused for launch tomorrow. Resume with
P3.1 (moon phase) when ready.
