# 72 Seasons · 七十二候

A Flutter app that brings the **72 ancient Japanese micro-seasons**
(*Shichijūni-kō*, 七十二候) to your phone. Each kō is a ~5-day window
capturing one shift in nature — *"The spring breeze melts the ice"*,
*"Bush warblers start singing"*, *"First frost falls"*, *"Bears start
hibernating"*. Seventy-two of them, one for every five days of the year.

Each kō comes with:
- an original **ukiyo-e-style illustration**
- the **date range** in the current year
- a **classical haiku** by Bashō, Issa, Buson, Shiki, or Chiyo-ni
- its **kanji**, **romaji**, and a **translation** (Ukrainian + English)
- its **sekki** (larger 24-part division) and **meta-season** context

---

## Highlights

- **72 bundled illustrations** — AI-generated in ukiyo-e style (via
  Pollinations / Flux.1). All images ship with the app; no network
  needed at runtime.
- **72 classical haiku** — carefully paired with each kō, translated
  into Ukrainian and English while keeping the original Japanese
  attribution. A few are famous canon (Bashō's frog, Issa's "world of
  dew"), others are seasonally-adjacent works by the same masters.
- **Seasonal palette** — each meta-season (Spring/Summer/Autumn/Winter)
  has its own color for light *and* dark themes; the whole UI tints
  gently with the palette of the current season.
- **Local notifications** — optional, once per kō transition (~every
  5 days), at 9 AM local time. Up to 60 scheduled in advance.
- **Home-screen widget** (iOS) — scaffold ready, ships in Phase 2.
- **Bilingual** — Ukrainian and English, system locale by default.
- **Light + dark themes** — both tuned for the seasonal palette.

## Screenshots

Screenshots live in `docs/screenshots/` (add your own after running).

## Getting started

Prerequisites: Flutter 3.27+, Xcode (for iOS) or Android Studio.

```bash
git clone <this-repo>
cd seasons_72
flutter create --platforms=ios,android --org com.seasons72 --project-name seasons_72 --no-overwrite .
flutter pub get
flutter gen-l10n
flutter run
```

Or use the bundled bootstrap:

```bash
./bootstrap.sh          # scaffolds everything including tests
```

See [`GETTING_STARTED.md`](GETTING_STARTED.md) for a step-by-step guide,
including Xcode/CocoaPods setup and troubleshooting.

## Project structure

```
lib/
  main.dart                          # app entry, preloads data + notifications
  app.dart                           # MaterialApp + theming + providers

  core/
    data/            JSON loader, in-memory cache
    models/          MetaSeason, Sekki, MicroSeason + brightness-aware colors
    notifications/   Local notifications (schedule/cancel/permission)
    providers/       Riverpod providers for seasons + calculator
    settings/        Persisted user settings (language, theme, notifications)
    theme/           App theme + washi paper texture overlay
    utils/           Season calculator (find current kō, days until next)
    widget/          Home-screen widget data bridge (iOS/Android)

  features/
    home/            "Now" tab — current kō with hero, description, haiku
    list/            "All 72" tab — browsable catalog by meta-season
    about/           "Tradition" tab — history and meaning of the calendar
    settings/        "Settings" tab — language/theme/notifications
    detail/          Single kō detail screen
    shell/           Bottom navigation shell
    shared/widgets/  SeasonHero, SeasonTitleBlock, SeasonHaiku, SeasonThumbnail

  l10n/              ARB files (en, uk)

assets/
  data/seasons.json  All 72 kō + 24 sekki + 4 meta-seasons
  images/ko/         72 illustrations (1.png … 72.png)

ios/
  Runner/            Standard Flutter iOS app
  SeasonsWidget/     WidgetKit extension (Swift, Phase 2)

scripts/
  generate_images.py # batch-generate illustrations via Pollinations.ai
  sync_images.py     # auto-update JSON from files on disk

test/
  season_calculator_test.dart   # unit tests for the date resolver
```

## Data model

Everything lives in `assets/data/seasons.json`:

- **`metaSeasons`** — the four big seasons with localized names, kanji,
  emoji (🌸/☀️/🍂/❄️), and light+dark color variants.
- **`sekki`** — 24 solar divisions (立春, 雨水, …), each with kanji,
  romaji, and localized names.
- **`ko`** (72 entries) — each has index, kanji, romaji, EN+UK names,
  a themed emoji, optional illustration path, averaged start/end date,
  EN+UK description, and EN+UK haiku with author.

Accuracy: the date ranges are **averaged** (±1 day). For astronomical
precision you'd compute solar longitudes in 5° steps; see
[`BRAINSTORM.md`](BRAINSTORM.md) for details on this and the full
roadmap.

## Phases

- **Phase 1 (shipped)**: data, UI, illustrations, haiku, themes,
  bilingual, local notifications.
- **Phase 2 (in progress)**: iOS home-screen widget. Scaffold is in
  `ios/SeasonsWidget/` and Dart bridge is in `lib/core/widget/`. See
  [`WIDGET_SETUP.md`](WIDGET_SETUP.md) for Xcode integration steps.
- **Phase 2 (future)**: astronomical date calculation, Android
  widget, lock-screen widget, ambient sounds per kō.

## Illustrations workflow

If you want to regenerate or expand the illustrations:

1. Read [`PROMPTS.md`](PROMPTS.md) for per-kō scene descriptions.
2. Run `python3 scripts/generate_images.py` to batch-generate all
   missing ones via Pollinations.ai (Flux.1, free, no login).
3. Run `python3 scripts/sync_images.py` to auto-wire new files into
   `seasons.json`.
4. `flutter run` — hero blocks pick up the new images.

## Credits and sources

- Calendar data based on *Honchō Shichijūni-kō* (本朝七十二候, 1685) by
  court astronomer Shibukawa Shunkai.
- Classical haiku by Matsuo Bashō, Kobayashi Issa, Yosa Buson,
  Masaoka Shiki, and Chiyo-ni. Translations done for this project.
- Illustration style inspired by Hokusai and Hiroshige.
- References:
  - [Nippon.com — Japan's 72 Microseasons](https://www.nippon.com/en/features/h00124/)
  - [Kanpai Japan — Koyomi: the 72 Seasons](https://www.kanpai-japan.com/travel-guide/koyomi-72-seasons)
  - [Maiko Japan — List of Japan's 72 Micro Seasons](https://maikojapan.com/list-of-japans-72-micro-seasons/)

## License

Personal project. Calendar data is based on publicly documented Japanese
traditional knowledge. Classical haiku are in the public domain (all
authors died more than a century ago). Illustrations are AI-generated
from original prompts.

Feel free to adapt for non-commercial use. For commercial distribution,
check the licenses of the `home_widget`, `flutter_local_notifications`,
and `flutter_riverpod` packages.
