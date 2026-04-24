# Taking screenshots for the launch

You need ~6 polished screenshots. Take them from the iOS Simulator —
gives the cleanest frames without status bar noise.

## Setup

1. Open the simulator. In Xcode:
   ```
   Xcode → Open Developer Tool → Simulator
   ```
   or simply:
   ```bash
   open -a Simulator
   ```

2. Pick a nice iPhone: **iPhone 16 Pro** or **iPhone 15 Pro** (they
   have Dynamic Island — the modern look).

3. Clean the status bar for marketing shots:
   ```bash
   xcrun simctl status_bar booted override \
     --time "9:41" \
     --dataNetwork wifi \
     --wifiMode active \
     --wifiBars 3 \
     --cellularMode active \
     --cellularBars 4 \
     --batteryState charged \
     --batteryLevel 100
   ```
   (9:41 is the classic Apple presentation time.)

4. Run the app:
   ```bash
   flutter run
   ```

## The 9 shots to take

Switch language to Ukrainian in Settings before shooting (or leave
English — pick one and stay consistent).

| # | Screen | What to show |
|---|---|---|
| 1 | **Home / Now** | Current kō with hero illustration, title, haiku, and the moon glyph next to the date range — scroll so AppBar + hero + name + sekki card all fit |
| 2 | **Detail** | Tap any kō from "Усі сезони" — show the full detail screen with hero, title, description, haiku with seal, share button visible in AppBar |
| 3 | **All seasons (list)** | Scroll through the "Усі сезони" list showing the meta-season groupings. Frame on a colorful section (spring pink + summer green) |
| 4 | **About / Tradition** | Show the 2×2 collage at the top with the SHICHIJŪNI-KŌ title pill |
| 5 | **Settings (dark theme)** | Toggle to dark theme first, then screenshot Settings showing the tinted background, theme/language pickers, and notification toggle with subtitle |
| 6 | **Dark theme — Now** | Re-screenshot the Home in dark mode — shows the palette is tuned for both |
| 7 | **iOS Home Screen widget** | Press the simulator's Home button (Cmd+Shift+H), long-press the screen, add a Medium and a Large 72 Seasons widget. Frame both visible |
| 8 | **Lock Screen widget** | Long-press the lock screen, customize → add accessoryRectangular Seasons widget under the clock. Screenshot the lock screen |
| 9 | **Share card** | Open Detail → tap the share icon → wait for share sheet to open → screenshot. The 1080×1350 share image is auto-saved to /tmp/seasons72_share_*.png; copy it to docs/screenshots/09-share-card.png |

## Capturing

Press `Cmd+S` in the simulator → image saves to `~/Desktop`.

Rename them as you go:
```
Desktop/Simulator_Screen_Shot_...png  →  docs/screenshots/01-now.png
                                       →  docs/screenshots/02-detail.png
                                       →  docs/screenshots/03-list.png
                                       →  docs/screenshots/04-tradition.png
                                       →  docs/screenshots/05-settings-dark.png
                                       →  docs/screenshots/06-now-dark.png
                                       →  docs/screenshots/07-widget.png
                                       →  docs/screenshots/08-lockscreen.png
                                       →  docs/screenshots/09-share-card.png
```

Then:
```bash
mkdir -p docs/screenshots
mv ~/Desktop/0*.png docs/screenshots/   # or drag them in Finder
```

## Cleaning up

Reset the status bar back to real when done:
```bash
xcrun simctl status_bar booted clear
```

## Adding them to README

After saving, edit the `## Screenshots` section of README.md:

```markdown
## Screenshots

| Now | Detail | Catalog |
|-----|--------|---------|
| ![](docs/screenshots/01-now.png) | ![](docs/screenshots/02-detail.png) | ![](docs/screenshots/03-catalog.png) |

| Tradition | Settings | Dark theme |
|-----------|----------|-----------|
| ![](docs/screenshots/04-tradition.png) | ![](docs/screenshots/05-settings-dark.png) | ![](docs/screenshots/06-now-dark.png) |
```

## For App Store (later)

App Store requires specific sizes:
- iPhone 6.7" display (1290×2796) — for iPhone 15 Pro Max
- iPhone 6.1" display (1179×2556) — for iPhone 15 Pro
- iPad 12.9" (2048×2732) — for iPad Pro

iOS Simulator captures already come in device-native resolution, so
using an iPhone 15 Pro Max simulator gives you the right 6.7" size.
Take the same 6 screenshots in iPhone 15 Pro simulator for the 6.1"
set.
