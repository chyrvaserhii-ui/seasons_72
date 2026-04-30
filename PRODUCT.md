# Product Documentation — 72 Seasons

## Vision

A meditative iOS calendar that teaches you to notice what's
happening in nature, in 5-day units, the way Japan has noticed for
twelve hundred years.

Not a productivity app. Not a habits tracker. A small contemplative
window — open it once, see what's blooming this week, close it.

## North star

The reference layer is the canvas. **The user is the painter.**

72 Seasons is moving from *a calendar you read* into *a quiet
seasonal practice you live*. The 72 kō and 9 cultural traditions
stay as the cultural spine; around them, gradually, a wellness
companion takes shape. Four principles guide the direction:

- **The year as ritual, not a feed.** 72 small invitations a year — to
  brew the recommended tea, photograph the flower in bloom, write
  your own haiku, pause for three breaths.
- **A diary, not a grid.** Your photos, your words, your check-ins
  saved next to the classical engraving for the same kō, year over
  year. Last spring no. 13 next to this one.
- **A circle, not a network.** When sharing arrives, it will be a
  three-friend postcard feed, never a public timeline. No likes, no
  counts, no leaderboard.
- **Gentle recognition, never streaks.** Optional badges — *72 kō
  noticed*, *Tea master*, *Haiku poet*, *Seasonal pilgrim* — that
  reward attention, not engagement. Always opt-in, always opt-out.

What stays the hard rule: 72 Seasons should keep feeling like a
quiet diary, not Calm and not Duolingo. No graphs. No "you missed
3 days". No leaderboard. The pace of the year is the pace of the
app.

The roadmap calls this **Phase 5 — Wellness pivot**; the cultural
register (kasane-no-irome, kōdō, saijiki, kotowaza-jiten) does not
move.

## Audience

| Segment | Why they care |
|---|---|
| **Mindfulness-curious** (Calm / Headspace alumni) | A quieter, content-rich alternative to guided-meditation apps. No streaks, no nag. |
| **Japanophiles** | Authentic depth: kasane-no-irome, kōdō, saijiki — categories most apps don't touch. |
| **Haiku writers / poetry students** | Built-in kigo dictionary (~291 entries) with classical examples. |
| **Ukrainian readers of Japanese culture** | Almost unique: native UK content, not auto-translation. |
| **Slow-tech enthusiasts** | Offline-first, no telemetry, no accounts, no ads. |

## Information architecture

The whole app stands on one taxonomic claim, taught in onboarding
Page 2 and reinforced everywhere:

```
4 пори року (春 夏 秋 冬)
   └── 6 фаз = 24 секкі (e.g., 立春 Початок весни)
          └── 3 сезони = 72 кō (e.g., 東風解凍 Східний вітер топить лід)
```

A kō lasts 5 days. Today belongs to one. The whole app is a window
on that one and what surrounds it.

Terminology is fixed across all UI:

| Level | Count | Word in app | Japanese |
|---|---|---|---|
| 1 (broadest) | 4 | **пора** (року) / season | 春 夏 秋 冬 |
| 2 (middle) | 24 | **фаза** (секкі) / phase | 二十四節気 |
| 3 (focus) | 72 | **сезон** (кō) / season | 七十二候 |

The app is named "72 сезони" — `сезон` is reserved for kō.

## Screens

### 1. Now (home tab)

The current kō, presented like a printed page.

```
ЗАРАЗ ТРИВАЄ                       🌒 Місяць · 47%
[Hero engraving · 1:1 · #N/72 badge · ▶ FAB]
霜止出苗  Сходи рису після останнього інію
Kanji  ·  Romaji  ·  meta-season tint
[Description prose]
                    一
              [Haiku]
              · seal-red dot ·
                    一
• 25 квітня – 29 квітня     [moon glyph]
[Sekki sub-card]
[Tea] [Food] [Hana] [Colors] [Kōdō] [Kigo] [Practice]   ← toggleable
[Progress bar — Залишилось 4 дні до зміни сезону]
НАСТУПНИЙ СЕЗОН
[Next-card preview · accent border]
```

### 2. Calendar (renamed from "Усі сезони")

Two views via segmented toggle:

**Список** — 4 meta blocks → 24 sekki sub-headers → 72 tile rows.
Sekki tiles use a 6-step alpha ramp so each phase has a unique band.
Today's kō has a glow-ringed badge; tap any tile → detail.

**Місяці** — 12 mini-month cards in a 2×6 grid. Each day cell tinted
by its kō. Per-month sekki legend below the grid names the colour
bands. Tap any day → quick preview sheet (date + sekki + kō + open
button).

Both views: floating "today" FAB (lower-left) reappears when scrolled
away from the active position.

### 3. Tradition (about tab)

Long-form context with a horizontal chip TOC at the top, decorative
pull-quotes between sections, and collapsible per-section bodies.
Sections cover: what 72 seasons are, the three-tier calendar,
historical origins (Sibukawa Harumi 1685), connection to haiku, why
it matters today. Followed by the "Seven traditions" cards overview
explaining each deep-dive category.

### 4. Settings

| Group | Items |
|---|---|
| Language | UK / EN / Match iOS |
| Theme | Auto / Light / Dark |
| Notifications | "Notify when a new kō begins" — fires 9 AM on each boundary |
| Картки сезону | 9 toggles (Period, Sekki, Tea, Food, Hana, Colors, Kōdō, Words, Practice) |
| Знайомство | "Show onboarding again" |
| Про проект | App description |

## Onboarding flow

First launch only. Persistent flag `hasSeenOnboarding`. User can
re-show via Settings.

```
SplashScreen (logo + meta-season-tinted gradient, 2.5 s)
   ↓ fade
Page 1 — current kō: "ЗАРАЗ ТРИВАЄ САМЕ ЦЕЙ СЕЗОН" + kanji + name
Page 2 — 4 → 24 → 72 hierarchy, manual reveal via Next button,
         3-bar Stories-style step indicator
Page 3 — 3×3 grid of category tiles (kanji + name)
Page 4 — App logo + "72 СЕЗОНИ" + 2-paragraph caption
         + tappable "Витоки — у вкладці «Традиція»" deep-link
   ↓ Begin button → AppShell
```

Soundtrack: traditional Japanese shakuhachi loop, 5-second graceful
fade-out on completion.

## Content per kō (9 deep-dive cards)

Each toggleable in Settings. All content is bilingual (UK + EN).

| Card | What's inside | Examples |
|---|---|---|
| 日 **Період** | Where this kō sits in the year, dates, position N/72, sekki position N/3, meta position N/18 | "Sezon 17 з 72; 25 січня – 29 січня" |
| 節 **Підсезон секкі** | Which of 24 sekki this kō belongs to | 大寒 Великий холод |
| 茶 **Сезонний чай** | Chinese tea matched to the kō (jade-green palette card) | Лун Цзін, Лао Ча Тоу |
| 食 **Сезонна їжа** | Japanese seasonal dish (persimmon-orange palette) | Едамаме, Цукемоно з рідьки |
| 花 **Сезонна квітка** | Flower with botanical name + hanakotoba (sakura-pink) | 節分草 Сецубунсо, 牡丹 півонія |
| 色 **Сезонні кольори одягу** | Kasane-no-irome layered hex combinations (kimono-blue) | 氷襲 крижаний шар |
| 香 **Сезонні пахощі kōdō** | Incense composition (amber palette) | manaka + cherry-bark |
| 語 **Сезонні слова** | 3-5 saijiki kigo with classical examples (indigo palette) | 苗, 田植, 春田, 苗代 |
| 養 **Практика** | yōjō body / activity / contemplation prompts (sage palette) | "пиши одне бажання на кольоровому папері і прив'яжи до гілки" |

Tap a card → modal bottom sheet with full info, brewing notes (tea),
hanakotoba (flower), brushwork (incense), example haiku (kigo), etc.

## Audio philosophy

Two services, two purposes. Both respect user agency.

- **Onboarding music** — shakuhachi loop. Auto-starts when onboarding
  opens, but only if iOS silent switch is off (respects context). On
  user tap of speaker icon, overrides silent and plays anyway. The
  speaker icon shows a struck-through bar when iOS is muting auto-play.
- **Per-kō ambient sounds** — 30 short clips: frogs for #19, cicadas
  for #38, rain for #4, wind for #56, etc. Played only on explicit
  user tap of the FAB on hero or IconButton in detail AppBar.
  Always overrides silent switch (explicit tap = consent).

## Notifications

| Type | Trigger | Time | Localised? |
|---|---|---|---|
| New kō begins | Day boundary between two kō | 9:00 local | UK + EN with ICU plurals |

Schedules 60 boundaries ahead at app start. Re-schedules on settings
change. Cancellable per-OS standard.

## Privacy & data

- 100% local. No accounts, no telemetry, no analytics.
- All preferences in `SharedPreferences`.
- All content in app bundle (~50 MB).
- No network requests outside the optional iOS notification system.

## Visual identity

- **Type system**: standard iOS SF Pro for Latin, system fallback
  for kanji/CJK. Heavy weights for kanji (w600/w700), regular for body.
- **Colour philosophy**: pastel washi paper feel. Each meta-season
  has one accent (soft pink / sage green / persimmon orange / dusty
  blue). UI tinted with the *current* meta only — feels like the
  whole app shares the season.
- **Texture**: subtle washi-paper overlay on the entire body.
- **Asymmetric framing**: haiku block always rendered with thin top
  rule and bottom rule punctuated by a small seal-red dot —
  mimicking 落款 (rakkan, signature seal) on traditional prints.
- **Typography rules**: caps eyebrows ("ЗАРАЗ ТРИВАЄ") for context
  signposts, large kanji for visual anchor, subtle drop shadows on
  text overlaid on engravings.

## Differentiation matrix

| | This app | "72 Seasons" (Y) | Calm | Season Calendar (JP) |
|---|:---:|:---:|:---:|:---:|
| Bilingual UK + EN | ✅ | EN only | EN only | JP only |
| 9 deep-dive categories | ✅ | name + emoji | meditation only | name + photo |
| Onboarding ritual | ✅ | none | yes | none |
| Calendar (list + grid) | ✅ | scroll feed | none | list |
| Today FAB / scroll-to | ✅ | — | — | — |
| Moon phase | ✅ | — | — | yes |
| Ambient audio per kō | ✅ | — | meditation tracks | — |
| Offline-first | ✅ | ✅ | partial | ✅ |
| No subscription | ✅ | ✅ | ❌ | ❌ |

## Success metrics (when ready to measure)

Phase 4 candidates after observation journal lands:

- **Daily opens**: target 2-4× per week per active user
- **Card engagement**: % of users who tap into ≥1 deep-dive card per session
- **Onboarding completion**: target 80% (drop-off currently unmeasured)
- **Retention D7 / D30**: industry benchmark for slow-tech: 30% / 15%
- **Notification opt-in rate**: target 50%+

(All measurable only with opt-in analytics. Currently the product is
fully blind to usage — a deliberate trade-off.)

## What we don't ship

A short list of explicit non-goals to keep the product opinionated:

- ❌ Streaks / badges / levels (breaks contemplative tone)
- ❌ Push reminders to "go outside" (naggy)
- ❌ Social feed of user observations (server, moderation, identity)
- ❌ AI chatbot (kills the silence)
- ❌ Subscription paywall on core content (keep accessible)
- ❌ User-generated haiku (moderation burden)
- ❌ Auto-translated content (UK and EN are hand-curated)

## Open questions

- Do we add a small donate / "support development" affordance? Where without breaking tone?
- iCloud sync for journal entries (Phase 4 A1) — when journal lands, immediately or after?
- Apple TV / iPad versions — yes or never?
