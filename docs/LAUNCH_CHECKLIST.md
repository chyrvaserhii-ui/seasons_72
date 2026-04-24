# Launch checklist — 72 Seasons

Concrete sequenced actions to ship publicly. Crosses off each as you go.

---

## 0. Pre-launch sanity (15 min)

- [ ] `flutter analyze` — zero warnings
- [ ] `flutter test` — all green
- [ ] One last cold-start on physical device — no crashes, no blank
      states
- [ ] App icon shows correctly on the Springboard (no white border)
- [ ] iOS Widget renders with engravings (not emoji fallback)
- [ ] Share card actually opens IG / Telegram / Save to Files

---

## 1. Screenshots (45 min)

Follow `docs/SCREENSHOTS.md`. Required for **App Store**, **GitHub
README**, and **landing page**.

```bash
# Reset simulator status bar to marketing-clean values
xcrun simctl status_bar booted override \
  --time "9:41" --dataNetwork wifi --wifiBars 3 \
  --cellularBars 4 --batteryState charged --batteryLevel 100
```

- [ ] **iPhone 15 Pro Max simulator** — 6.7" set, for App Store
- [ ] **iPhone 15 Pro simulator** — 6.1" set, for App Store fallback
- [ ] Save to `docs/screenshots/01-now.png` … `09-share-card.png`
- [ ] Reset status bar: `xcrun simctl status_bar booted clear`

---

## 2. README polish (15 min)

- [ ] Add the screenshot grid block from `docs/SCREENSHOTS.md` to
      `README.md`
- [ ] Verify the badge / hero image at the top points at a real
      asset URL
- [ ] Update `## Phase 2 status` → mark widget + moon phase + share
      cards as ✅
- [ ] Add a one-line "Built in N weeks. Open to feedback." line near
      the top — sets the tone

---

## 3. GitHub repo setup (10 min)

- [ ] **About**: short tagline + topics
  - Tagline: `A Flutter app for Japan's 72 micro-seasons (七十二候).`
  - Topics: `flutter`, `ios`, `widget`, `japan`, `calendar`,
    `ukiyo-e`, `haiku`, `localization`, `ukrainian`, `meeus`
- [ ] **Website**: link to GitHub Pages once enabled
- [ ] **Releases**: tag the current commit as `v0.1.0` with release
      notes summarizing Phase 1 + Phase 2 features

---

## 4. GitHub Pages (10 min)

- [ ] **Settings → Pages → Source**: `main` branch, `/docs` folder
- [ ] Confirm `https://chyrvaserhii-ui.github.io/seasons_72/` opens
      and renders
- [ ] Test the OG image: paste the URL into Telegram and verify the
      preview renders correctly
- [ ] Add the link as the repo's Website (Settings → top of page)

---

## 5. First posts — staggered over 3-5 days

Don't dump everything at once. Read replies and adjust copy as you
go. All copy is in `docs/LAUNCH_KIT.md`.

### Day 1 — warm audience

- [ ] **Ukrainian Telegram** — paste from LAUNCH_KIT "Ukrainian post"
- [ ] Post in 1-2 Ukrainian Telegram tech / культура groups you're
      already in

### Day 2 — Reddit (Japanese-speaking + culture)

- [ ] **r/LearnJapanese** — paste from LAUNCH_KIT
- [ ] **r/Haiku** — paste from LAUNCH_KIT
- [ ] Be ready to reply within 1-2 hours. Reddit traffic dies fast
      if comments are unanswered.

### Day 3-4 — technical audience

- [ ] **r/FlutterDev** — paste from LAUNCH_KIT (the SwiftUI widget +
      moon-phase painter angles work well here)
- [ ] **Hacker News (Show HN)** — paste from LAUNCH_KIT. Submit
      Tuesday-Thursday 8-10 AM ET for max visibility.

### Day 5+ — sustained presence

- [ ] **Twitter/X thread** — 5 tweets, copy from LAUNCH_KIT
- [ ] **Product Hunt** — wait until you have 10-20 GitHub stars
      first (gives you a "real product" feel)

---

## 6. Post-launch

- [ ] Track replies in a `LAUNCH_NOTES.md` — what landed, what fell
      flat, FAQ questions
- [ ] If Telegram pickups land — mention them to the Ukrainian
      audience as social proof in the next post
- [ ] After 1 week, write a `RETRO.md` — what you'd do differently
      for v0.2

---

## App Store submission (later — when you've heard from ~20 users)

- [ ] **Apple Developer Program** ($99/year) — required for App
      Store distribution
- [ ] **App Store Connect**: create app record
- [ ] Upload binary: `flutter build ipa` then submit via Transporter
- [ ] Fill metadata (uses LAUNCH_KIT description) + screenshots
      from step 1
- [ ] Privacy: declare zero tracking (you collect nothing)
- [ ] Submit for review — typical turnaround 24-48 hrs

---

## Quick reference

| Doc | Purpose |
|-----|---------|
| `docs/LAUNCH_KIT.md` | All written copy (taglines, posts, captions) |
| `docs/SCREENSHOTS.md` | How to take and where to save |
| `docs/index.html` | Landing page (GitHub Pages) |
| `docs/LOGO_PROMPT.md` | If you ever want to regenerate the icon |
| `docs/LAUNCH_CHECKLIST.md` | This file |
