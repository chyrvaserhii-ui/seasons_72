# Technical Documentation — 72 Seasons

Flutter / Dart iOS-first app showing the 72 micro-seasons of the
traditional East Asian calendar (Shichijūni-kō, 七十二候).

This document covers: architecture, directory structure, key data
models, state management, theming, audio strategy, l10n, and how to
build / run / extend.

---

## Stack

| Layer | Choice | Reason |
|---|---|---|
| Framework | Flutter 3.27, Dart 3.5 | One codebase, best-in-class declarative UI |
| State | Riverpod 2.x (`flutter_riverpod`) | Compile-time safety, lazy globals, easy mocking |
| Storage | `shared_preferences` | Tiny key-value needs (locale, theme, flags) |
| Audio | `just_audio` + `audio_session` | Mature, granular session control |
| Notifications | `flutter_local_notifications` | OS scheduler, no backend |
| Sharing | `share_plus` | Native share sheet on iOS |
| Widget (iOS) | `home_widget` | Bridge to native Swift WidgetKit |
| i18n | `intl` + `flutter_localizations` (`.arb`) | Standard, codegen for type safety |
| Date / format | `intl.DateFormat` | Locale-aware month / day names |

---

## Directory layout

```
lib/
├── app.dart                          # MaterialApp, theme wiring, locale
├── main.dart                         # entrypoint, audio-session config
│
├── core/
│   ├── audio/
│   │   ├── ambient_audio_service.dart     # per-kō ambient clips
│   │   ├── ambient_map.dart               # kō → asset key overrides
│   │   └── onboarding_audio_service.dart  # shakuhachi loop
│   ├── data/
│   │   └── seasons_repository.dart        # JSON loader, lookups
│   ├── models/
│   │   └── season_models.dart             # MetaSeason, Sekki, MicroSeason
│   ├── notifications/
│   │   └── notification_service.dart      # 60-day pre-schedule
│   ├── providers/
│   │   └── seasons_providers.dart         # Riverpod globals
│   ├── settings/
│   │   └── settings_provider.dart         # AppSettings + persistence
│   ├── theme/
│   │   ├── app_theme.dart                 # ThemeData light + dark
│   │   └── washi_background.dart          # paper texture overlay
│   ├── utils/
│   │   ├── moon_calculator.dart           # Meeus phase algorithm
│   │   ├── localized_names.dart           # MicroSeason name extension
│   │   └── season_calculator.dart         # currentAt(), progress()
│   └── widget/                            # iOS home widget bridge
│
├── features/
│   ├── about/                             # Tradition tab + content
│   │   ├── about_screen.dart
│   │   ├── about_content.dart             # 5 sections × UK + EN prose
│   │   ├── seasonal_foods.dart            # 72 food pairings
│   │   ├── seasonal_hana.dart             # 72 flower pairings
│   │   ├── seasonal_colors.dart           # 72 kasane palettes
│   │   ├── seasonal_kodo.dart             # 72 incense compositions
│   │   ├── seasonal_kigo.dart             # 72 saijiki word collections
│   │   ├── seasonal_practice.dart         # 72 yōjō practices
│   │   └── tea_pairings.dart              # 72 Chinese teas
│   ├── detail/                            # Per-kō deep view
│   │   ├── season_detail_screen.dart
│   │   ├── period_card.dart
│   │   ├── tea_card.dart
│   │   ├── food_card.dart
│   │   ├── hana_card.dart
│   │   ├── colors_card.dart
│   │   ├── kodo_card.dart
│   │   ├── kigo_card.dart
│   │   └── practice_card.dart
│   ├── home/
│   │   └── home_screen.dart               # Now tab
│   ├── list/
│   │   └── seasons_list_screen.dart       # Calendar tab (List + Months)
│   ├── onboarding/
│   │   ├── splash_screen.dart
│   │   ├── onboarding_screen.dart         # 4 pages, ~1700 lines
│   │   └── root_router.dart               # splash → onboarding → shell
│   ├── settings/
│   │   └── settings_screen.dart
│   ├── shared/widgets/                    # Re-used across features
│   │   ├── ambient_player.dart            # FAB + IconButton
│   │   ├── moon_phase.dart                # Pill + glyph + sheet
│   │   ├── season_hero.dart               # Engraving + title block
│   │   └── sekki_card.dart
│   ├── shell/
│   │   ├── app_shell.dart                 # Bottom nav, tab routing
│   │   └── shell_providers.dart           # selectedTabProvider
│   └── share/
│       └── share_service.dart             # Render → PNG → share
│
└── l10n/
    ├── app_en.arb                         # English source
    ├── app_uk.arb                         # Ukrainian source
    └── app_localizations*.dart            # Generated

assets/
├── audio/                                  # *.m4a per kō / meta + onboarding
├── brand/                                  # appIcon.png + candidates
├── data/seasons.json                       # 72 kō + 24 sekki + 4 meta
└── images/
    ├── ko/                                 # 72 ukiyo-e illustrations
    └── onboarding/                         # 4 page backgrounds

ios/                                       # Xcode workspace
└── SeasonsWidget/                         # WidgetKit Swift target
```

---

## Data model

Three nested structures, all immutable Dart classes hydrated from
`assets/data/seasons.json`.

### `MetaSeason` — 4 пори року

```dart
class MetaSeason {
  final String id, kanji, romaji, nameEn, nameUk, emoji;
  final Color colorLight, colorDark;

  Color colorFor(Brightness)        // foreground accent
  Color tintColorFor(Brightness)    // bg-friendly darker variant
}
```

Light-theme accents are pastel by design (#F4B5C1 spring, #8FBF7F
summer, #D89060 autumn, #8DAAC7 winter). Applied at low alpha they
vanish on white — `tintColorFor` shifts HSL lightness ×0.78 for
backgrounds while `colorFor` keeps the pastel for icons / glyphs.

### `Sekki` — 24 фази

```dart
class Sekki {
  final String id, kanji, romaji, nameEn, nameUk;
}
```

Each meta has 6 sekki; each sekki has 3 kō. Ordered chronologically.

### `MicroSeason` — 72 сезони (kō)

```dart
class MicroSeason {
  final int index;                  // 1..72
  final String metaId, sekkiId;
  final String kanji, romaji, nameEn, nameUk;
  final int startMonth, startDay, endMonth, endDay;
  final String? illustrationAsset;
  final String? haikuUk, haikuEn, haikuAuthorUk, haikuAuthorEn;
  final String descriptionEn, descriptionUk;
  final String emoji;

  DateTime startDateForYear(int)    // resolves to current year
  DateTime endDateForYear(int)
  String localizedName(Locale)
  String localizedHaiku(Locale)
}
```

### Eight content pairings

One file per category, each a `Map<int, T>` keyed by `koIndex` 1..72:

- `seasonal_foods.dart` — `FoodPairing` (Japanese seasonal dish)
- `seasonal_hana.dart` — `HanaPairing` (flower with hanakotoba)
- `seasonal_colors.dart` — `ColorPairing` (kasane-no-irome layered hex)
- `seasonal_kodo.dart` — `KodoPairing` (incense composition)
- `seasonal_kigo.dart` — `KigoPairing` (3-5 saijiki entries per kō)
- `seasonal_practice.dart` — `PracticeNote` (body / activity / contemplation)
- `tea_pairings.dart` — Chinese tea variety per kō

Each renders as one card on Detail + Home screens. All toggleable.

---

## State management — Riverpod

Globals declared in `core/providers/seasons_providers.dart`:

```dart
seasonsRepositoryProvider → SeasonsRepository (loaded once at app start)
seasonCalculatorProvider  → SeasonCalculator (currentAt, progress)
currentSeasonProvider     → AsyncValue<MicroSeason> (auto-refresh)
allSeasonsProvider        → List<MicroSeason>
```

User settings in `core/settings/settings_provider.dart`:

```dart
settingsProvider → AppSettings {
  locale, themeMode, notifyOnSeasonChange,
  cards: CardVisibility { period, sekki, tea, food,
                          hana, colors, kodo, kigo, practice },
  hasSeenOnboarding,
  hasSeenAmbientHint,
  isLoaded,
}
```

Tab navigation (driven from outside `AppShell` for deep-linking):

```dart
selectedTabProvider → StateProvider<int>  // 0=Now, 1=Calendar,
                                          // 2=Tradition, 3=Settings
```

All settings persist to `SharedPreferences` via the notifier's
setters (`setLocale`, `setHasSeenOnboarding`, etc.).

---

## Theming

Two themes in `core/theme/app_theme.dart`:

- **Light**: warm off-white surface, dark text, soft pastels for accents
- **Dark**: near-black surface, bright pastel accents for visibility

The four meta-season hues are mapped to both surfaces. `WashiBackground`
overlays a low-alpha paper texture across the entire app body.

### `tintColorFor` helper (added in Phase 3)

The light pastel palette was vanishing under low-alpha tinting on
white. The fix:

```dart
Color tintColorFor(Brightness b) {
  if (b == Brightness.dark) return colorFor(b);   // already balanced
  final hsl = HSLColor.fromColor(colorFor(b));
  return hsl.withLightness(hsl.lightness * 0.78).toColor();
}
```

A subtle luminance reduction (×0.78) gives bg-tints body without
saturating the colour ("eye-popping / cheap" was a real failure
mode at higher reductions). Used everywhere a low-alpha tint sits
over a white scaffold (calendar tiles, sekki sub-headers, card
backgrounds, day cells).

### Sekki rhythm — 6-step alpha ramp

Within a meta there are 6 sekki, each containing 3 kō. To
distinguish them visually:

```dart
final tileAlpha = isDark
  ? 0.10 + sekkiInMeta * 0.05    // 0.10 → 0.35
  : 0.07 + sekkiInMeta * 0.05;   // 0.07 → 0.32
```

Step 0.05 — calibrated to be just above human-perception threshold
on pastel backdrops. Even/odd alternation (the previous attempt)
made 1st/3rd/5th sekki indistinguishable.

---

## Audio session strategy

Two services, one global session in `audio_session`. Default
category is `ambient` (silent switch respected) with `mixWithOthers`
(coexists with Spotify / Podcasts).

### Why this matters

iOS silent switch is for "no surprise sounds". Auto-played audio
should respect it; explicit user taps should not.

| Trigger | Path | Category | Result |
|---|---|---|---|
| Onboarding mount | `OnboardingAudioService.start()` | `ambient` | Plays only if not silent |
| Onboarding speaker tap | `OnboardingAudioService.toggle()` → `startOverridingSilent()` | switches to `playback`, plays | Always plays |
| Home FAB / detail IconButton tap | `AmbientAudioService.toggle()` → `_ensurePlaybackSession()`, plays | switches to `playback`, plays | Always plays |

### Silent-mode detection (heuristic)

iOS provides no direct API. After `start()` we wait 500 ms and
check `_player.playing`; if false and `_userPaused` is false, we
infer the silent switch is muting and set `_silenced = true`. The
onboarding speaker icon listens to this flag and overlays a
diagonal struck-through bar.

---

## Localisation

`intl` + `flutter_gen_l10n` codegen, two locales: `en` and `uk`.

```
lib/l10n/app_en.arb       # source of truth, English
lib/l10n/app_uk.arb       # Ukrainian
lib/l10n/app_localizations*.dart   # generated
```

User-toggleable in Settings → Мова. System locale is the default
when nothing is set.

Content files (`seasonal_foods.dart`, `tea_pairings.dart`, …) hold
their own `*Uk` / `*En` fields per entry — too much to put in `.arb`
and too tied to data shape.

---

## Build & run

### Prerequisites

- Flutter 3.27+ (`flutter --version` to check)
- Xcode 15+ for iOS
- Active Apple Developer account for device builds

### One-time setup

```bash
flutter pub get
cd ios && pod install --repo-update && cd ..
```

### Run on simulator

```bash
open -a Simulator                    # boot a default simulator
flutter run                          # picks the running simulator
```

### Run on physical iPhone

1. Open `ios/Runner.xcworkspace` in Xcode
2. Signing & Capabilities → Team → your Apple ID
3. Bundle Identifier — change to something unique (`com.<your>.seasons72`)
4. Connect iPhone via USB or Wi-Fi (Devices and Simulators)
5. On phone: Settings → Privacy & Security → Developer Mode → On
6. Run from terminal: `flutter run` or from Xcode: ⌘R

### Releasing

iOS:
```bash
flutter build ios --release
# Then archive & upload via Xcode → Product → Archive
```

Asset compression (recommended before release): run all PNGs in
`assets/images/onboarding/` and `assets/images/ko/` through TinyPNG
or Squoosh. ~7–8 MB bundle savings.

---

## Extending

### Adding a new content category

1. Create `lib/features/about/seasonal_<category>.dart` with a `Map<int, T>` keyed by `koIndex`
2. Create `lib/features/detail/<category>_card.dart` matching the existing card pattern (Material + InkWell + modal-bottom-sheet)
3. Add `DetailCard.<category>` enum value in `core/settings/settings_provider.dart` + corresponding `CardVisibility` field
4. Wire the card into both `home_screen.dart` and `season_detail_screen.dart` under a `if (cards.<category>) ...[ ... ]` guard
5. Add a label in `_cardLabel()` in `settings_screen.dart`
6. (Optional) add a tradition row in `cardTraditionsUk` / `cardTraditionsEn` (`about_content.dart`)

### Adding a locale

1. Drop `lib/l10n/app_<locale>.arb` (mirror existing keys)
2. Generate: `flutter gen-l10n` (auto-runs on `flutter run`)
3. Add to `MaterialApp.supportedLocales` in `app.dart` (autodetected from `app_localizations.dart`)

### Adding ambient audio overrides

Edit `lib/core/audio/ambient_map.dart`:

```dart
final Map<int, String> ambientOverrides = {
  19: 'frogs',          // any custom asset key
  38: 'cicadas',
  // ...
};
```

Drop the matching `assets/audio/<key>.m4a`. Falls back to meta-season
default if not registered.

---

## Known constraints

- iOS-first; Android works but home-widget integration is stubbed
- Engraving illustrations are AI-generated — replace before commercial release
- No backend; everything is local. No telemetry, no accounts, no sync
- Dates are averaged ±1 day; precise astronomical kō boundaries (solar longitude) are a future improvement

## License

GPL-3.0 (same as the public GitHub repo). Content (haiku, kasane palette, tea/food curation) is original or sourced from public-domain references; check each `*.dart` file's header for sources where applicable.
