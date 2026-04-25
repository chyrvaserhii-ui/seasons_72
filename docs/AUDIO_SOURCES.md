# Sourcing ambient loops

The app needs **four ~20-30 second loops** — one per meta-season — at:

```
assets/audio/spring.m4a
assets/audio/summer.m4a
assets/audio/autumn.m4a
assets/audio/winter.m4a
```

Without these files, the play button silently fails (logged as
`AmbientAudio toggle failed`); the rest of the app works normally.

---

## What to look for

Calm, **looped**, no jarring transitions, no human voices, no music.
The point is sensory anchor — should fade into background after 30s.

| Meta | Mood | Search terms |
|------|------|--------------|
| Spring | Awakening — birds, melt, wind | `forest birds spring`, `bush warbler`, `light wind leaves`, `morning birdsong` |
| Summer | Buzzing — cicadas, frogs, evening | `cicada loop`, `summer evening forest`, `frog pond night`, `crickets` |
| Autumn | Quieting — rain, distant wind, leaves | `gentle rain leaves`, `light rain forest`, `wind through trees autumn`, `drizzle window` |
| Winter | Sparse — wind, snow, silence with hints | `winter wind soft`, `snow falling forest`, `cold wind distant`, `silence with wind` |

---

## Where (free, license-clean)

### Freesound.org (best source)

Free, requires registration. Filter by **CC0** license to avoid
attribution requirements. Most sounds are 16-bit WAV.

1. https://freesound.org/search/?q=cicada+loop&f=license:%22Creative+Commons+0%22
2. Preview, then **Download** (top-right). Get the WAV.
3. Convert to m4a with ffmpeg (see below).

### Pixabay

https://pixabay.com/sound-effects/ — easier UI but smaller library.
Look for items marked "Pixabay License" (royalty-free, no attribution).

### YouTube Audio Library

https://studio.youtube.com (sign in → Audio Library → "Sound effects")
— good ambient quality. Usually no-attribution.

---

## Processing

Each loop should be:
- **m4a** (AAC, ~96–128 kbps mono) — best size/quality on iOS
- **20–30 seconds** — long enough to not feel repetitive
- **Crossfade-clean ends** — last frame should match first

### Convert WAV → m4a with ffmpeg

```bash
brew install ffmpeg

ffmpeg -i forest_birds.wav \
  -ac 1 -b:a 96k \
  -t 25 \
  spring.m4a
```

`-ac 1` mono, `-b:a 96k` bitrate, `-t 25` trim to 25 seconds.

### Make a clean loop point

Open the WAV in Audacity (free), select last 1–2 seconds, **Effect →
Crossfade Tracks → fade in/out to silence**. Saves as
`spring_clean.wav`, then convert to m4a.

---

## Drop into the app

```bash
mv spring.m4a summer.m4a autumn.m4a winter.m4a \
   ~/Documents/Claude/Projects/seasons_72/assets/audio/

cd ~/Documents/Claude/Projects/seasons_72
flutter pub get   # picks up new assets
flutter run -d "iPhone 17"
```

The play button on the Home screen should now work. Tap it during
spring → birds. Switch to a winter test (change device date) → wind.

---

## Size budget

- Target: ~500 KB per file
- 4 files = ~2 MB added to bundle
- Acceptable; the app already ships 8 MB of engravings

If files get large after conversion (>1 MB), drop bitrate to `64k`
or shorten to 20 seconds.

---

## Attribution (if a clip requires it)

If you end up using a non-CC0 clip that requires attribution
(e.g. CC-BY), add to `lib/features/about/about_content.dart` a new
section "Audio credits" with the original creator name and link.
