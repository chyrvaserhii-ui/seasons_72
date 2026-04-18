# Launch kit — 72 Seasons

All the copywriting you need for an initial public launch: taglines,
descriptions at several lengths, platform-specific posts, and
screenshot captions. Adapt the tone to the channel.

---

## Taglines (pick one per context)

**One-liner:**
> A Japanese tradition of 72 micro-seasons — on your phone.

**Slightly longer:**
> Discover the 72 tiny seasons the Japanese have watched for a thousand
> years. One every five days.

**Punchy:**
> Between spring and summer, the Japanese found seventy-two other seasons.

**Мовою:**
> 72 крихітних сезони, які японці помічають уже тисячу років — у твоєму телефоні.

---

## Elevator pitch (2 sentences)

The Japanese traditional calendar divides the year into 72 micro-seasons,
each around five days long, capturing one shift in nature — *"East wind
melts the ice"*, *"Bush warblers start singing"*, *"First frost falls"*.
This app brings the full cycle to your phone: an illustration, a classical
haiku, and the date for each of the 72 seasons — observed together, one
by one.

---

## Full description (for App Store / Google Play)

The Japanese have watched the year in seventy-two pieces. *Shichijūni-kō*
— literally "seventy-two kō" — divides each year into 72 micro-seasons,
one every five days. Each has a poetic name describing a specific shift:
*"Peach blossoms first bloom"*, *"Wagtails sing"*, *"The ground starts
to freeze"*.

This app brings the full cycle to your home screen:

**For every kō, you get:**
- An ukiyo-e illustration in the style of Hokusai and Hiroshige
- A classical haiku by Bashō, Issa, Buson, Shiki, or Chiyo-ni
- The date range it falls on this year
- A short description of the natural event it names
- Its place in the larger calendar (24 sekki, 4 seasons)

**Extras:**
- Light and dark themes, each tuned to the color of the current season
- Optional notification at the start of every new kō (~every 5 days)
- Everything works offline — no server, no ads, no accounts
- Available in Ukrainian and English; system language by default

The calendar is based on *Honchō Shichijūni-kō* (1685), adapted for
Japanese climate by court astronomer Shibukawa Shunkai — the same
version used in Japan today.

---

## Channel-specific posts

### Reddit — r/LearnJapanese

**Title:** I built a free app that shows Japan's 72 micro-seasons with original kanji and classical haiku

**Body:**
> The Japanese traditional calendar divides the year into 72 kō of about
> five days each (七十二候). I've always loved how specific they are —
> "Crow-dipper sprouts", "Salmon swim upstream", "Bears start
> hibernating" — so I built a little Flutter app that walks through all
> 72, one per current date, with the kanji, romaji, a classical haiku,
> and an ukiyo-e illustration.
>
> It's open source: github.com/chyrvaserhii-ui/seasons_72
>
> Feedback welcome — especially from native speakers if any of the
> romaji or translation choices feel off. Also curious what other kigo
> resources you use.

### Reddit — r/Haiku

**Title:** App with a haiku for each of Japan's 72 micro-seasons — would love feedback

**Body:**
> I've been building a small app that pairs each of the 72 Japanese
> micro-seasons with a classical haiku by Bashō, Issa, Buson, Shiki, or
> Chiyo-ni. Some are canonical (Bashō's frog for "Frogs start singing"),
> others are seasonally-adjacent works by the same masters.
>
> Open-source, free, no ads: github.com/chyrvaserhii-ui/seasons_72
>
> Would love your ears: does the matching feel right, and are there
> haiku you'd swap in?

### Reddit — r/FlutterDev

**Title:** 72 Japanese micro-seasons — my first larger Flutter project, open-source

**Body:**
> Shipped a small Flutter app about the Japanese 72-season calendar.
> Built with Riverpod + flutter_local_notifications + home_widget.
> Designed with a per-season palette, washi paper overlay, and a custom
> SwiftUI widget extension (scaffolded, Phase 2).
>
> Source: github.com/chyrvaserhii-ui/seasons_72
>
> Highlights that might be useful to other Flutter devs:
> - Brightness-aware color model on a JSON-backed data layer
> - Batch image generation via Pollinations.ai (scripts/ folder)
> - ICU plural support for Ukrainian (3 plural forms)
> - Riverpod side-effect provider that keeps the home-screen widget synced
>
> Would love code review and design feedback.

### Hacker News (Show HN)

**Title:** Show HN: A Flutter app for the 72 ancient Japanese micro-seasons

**Body:**
> The Japanese have quietly watched the year in 72 pieces for centuries.
> One every five days — "East wind melts the ice", "Fish emerge from
> the cracking river ice", "Swallows return". I kept finding myself
> reading about it and thought it would be nice to have them on my
> phone.
>
> The app ships with:
>   • 72 AI-generated ukiyo-e illustrations (Flux.1, from my own prompts)
>   • 72 classical haiku with Ukrainian and English translations
>   • A palette that shifts with the current season (both light and dark themes)
>   • Offline data, no accounts, no ads
>
> Source + data: github.com/chyrvaserhii-ui/seasons_72
>
> Curious to hear what you think — especially about the illustration
> workflow (Pollinations.ai batch script is in scripts/).

### Twitter / X thread (5 tweets)

**Tweet 1:**
> 1/5 The Japanese traditional calendar divides the year into 72
> micro-seasons, each around five days long. Every one has a poetic
> name describing a single shift in nature.
>
> I built a small app that walks through all 72.
>
> [screenshot of home screen]

**Tweet 2:**
> 2/5 Every kō comes with an original ukiyo-e-style illustration, the
> date range it falls on this year, and its kanji + romaji.
>
> [screenshot of detail]

**Tweet 3:**
> 3/5 Each kō is paired with a classical haiku. Bashō's frog ("Old pond
> — a frog leaps in, sound of water") is set to season #19, "Frogs
> start singing" — which begins in late May.
>
> [screenshot of haiku block]

**Tweet 4:**
> 4/5 The palette shifts with the current season — pink for spring,
> green for summer, orange for autumn, blue for winter. Same logic in
> both light and dark themes.
>
> [screenshot showing palette variation]

**Tweet 5:**
> 5/5 Free, open-source, Ukrainian + English. Offline. No accounts.
>
> github.com/chyrvaserhii-ui/seasons_72
>
> Would love your thoughts — kind of project where feedback from real
> users makes a big difference.

### Product Hunt listing draft

**Name:** 72 Seasons

**Tagline (60 char max):**
Japan's calendar of small changes — on your phone.

**Description:**
The Japanese have watched the year in 72 pieces for a thousand years,
one every five days. 72 Seasons walks you through all of them with
original ukiyo-e illustrations, classical haiku, and the date each one
falls on this year. Offline, no accounts, free.

**Makers comment:**
> Hi! I've been fascinated by the Japanese 72-season calendar for years
> — the specificity of "First frost falls" or "Swallows return" makes
> me notice nature differently. I built this app over a couple weeks as
> a small homage.
>
> Every kō has an illustration I generated with Flux.1 from my own
> prompts, a classical haiku by one of the five Japanese masters, and a
> description. The palette tints with the current season — spring pink
> now, will shift to summer green in May.
>
> It's fully open source at github.com/chyrvaserhii-ui/seasons_72 —
> would love code review from Flutter folks and content feedback from
> Japanese-speakers and haiku writers.

### Ukrainian post (Telegram / Facebook groups)

**Title:** Застосунок про 72 японські мікро-сезони — з хайку і гравюрами

**Body:**
> Японський традиційний календар ділить рік не на 4, а на **72**
> мікро-сезони — по одному на кожні п'ять днів. Кожен має поетичну
> назву: «Солов'ї заспівали в горах», «Перший іній», «Ведмеді лягають у
> сплячку».
>
> Зробив застосунок на Flutter, що веде через усі 72:
> — ілюстрація в стилі ukiyo-e для кожного сезону
> — класичне хайку Басьо / Ісси / Бусона / Сікі українською та
>   англійською
> — поточна дата, коли настає сезон
> — українська і англійська мови
>
> Безкоштовно, код відкритий:
> github.com/chyrvaserhii-ui/seasons_72
>
> Буду дуже радий відгукам — особливо стосовно перекладів хайку.

---

## Screenshot captions (for App Store / landing)

1. **Now screen** — "Перша веселка / First rainbow" kō with the current
   date range
2. **Haiku detail** — "Each kō with a classical haiku by Bashō, Issa,
   Buson, Shiki, or Chiyo-ni"
3. **Catalog** — "Browse all 72 kō grouped by the four great seasons"
4. **Tradition tab** — "Learn the history: from 6th-century China to
   1685 Shibukawa Shunkai"
5. **Settings — dark theme** — "Light and dark themes, tinted with the
   current season"
6. **Notification preview** — "Get a poetic reminder every five days"

---

## Recommended launch order

1. Beautiful screenshots (docs/screenshots/) — `Cmd+S` in iOS Simulator
2. Polish the GitHub About section (description, topics, link)
3. Ukrainian Telegram/FB groups — warm audience, low risk
4. r/LearnJapanese + r/Haiku — moderate effort, likely gets traction
5. r/FlutterDev + Hacker News — technical audience, higher bar but big
   reach if well received
6. Twitter thread — ongoing presence
7. Product Hunt launch — when you have at least 10-20 GitHub stars and
   some testimonials

Don't launch everything day one. Stagger over 1-2 weeks so you can
respond to comments and iterate.

---

## Metrics to track

- GitHub stars / forks
- Reddit post score + top comments
- Traffic to the repo (GitHub Insights → Traffic)
- App Store installs (if you publish)
- Notification opt-in rate (if you add analytics)

You'll learn more from *reading replies* than from numbers. Be ready to
respond within a couple hours on each post — that's when discussion is
alive.
