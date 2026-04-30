//
//  SeasonsWidget.swift
//  SeasonsWidget
//
//  Reads current kō data from UserDefaults in an App Group shared with
//  the Flutter app. Flutter writes this via the `home_widget` package
//  (see lib/core/widget/widget_service.dart).
//
//  Engraving PNGs (72 ukiyo-e illustrations) are copied by the Flutter
//  app into the App Group container as `engraving_current.png`,
//  `engraving_next.png`, `engraving_previous.png`. See AppDelegate's
//  method channel "seasons72/widget/engraving".
//

import SwiftUI
import WidgetKit

// MARK: - Constants

private enum Const {
    /// Must match `WidgetService.appGroupId` in Dart and the App Group
    /// capability enabled on both the Runner and SeasonsWidget targets.
    static let appGroupId = "group.chyrva.seasons72"
    static let widgetKind = "SeasonsWidget"

    /// Deep-link scheme: `seasons72://season/<index>` opens the app
    /// directly on the given kō's detail screen.
    static let deepLinkScheme = "seasons72"
}

// MARK: - Model

struct SeasonEntry: TimelineEntry {
    let date: Date
    let index: Int
    let kanji: String
    let romaji: String
    let name: String
    let emoji: String
    let sekki: String
    let sekkiKanji: String
    let meta: String
    let metaColor: Color
    let daysUntilNext: Int
    let nextIndex: Int
    let nextName: String
    let nextEmoji: String
    let previousIndex: Int
    let previousName: String
    let previousEmoji: String
    /// Normalized lunar phase 0..1 (0 = new, 0.5 = full).
    let moonPhase: Double
    /// Visible illumination 0..1 — redundant with phase but cached so
    /// we don't recompute in every view.
    let moonIllumination: Double
    let moonIsWaxing: Bool
    /// Localized labels written by Flutter — keeps the widget's static
    /// strings in sync with the device language even when the device's
    /// locale isn't one we ship (e.g. Russian falls back to English on
    /// the Dart side, so Swift mustn't paste Ukrainian into that mix).
    let prevLabel: String
    let nextLabel: String
    let countdownLong: String
    let countdownShort: String
    let lockScreenCountdown: String

    static let placeholder = SeasonEntry(
        date: Date(),
        index: 15,
        kanji: "虹始見",
        romaji: "Niji hajimete arawaru",
        name: "Перша веселка",
        emoji: "🌈",
        sekki: "Чистота і ясність",
        sekkiKanji: "清明",
        meta: "Весна",
        metaColor: Color(red: 0.957, green: 0.710, blue: 0.757),
        daysUntilNext: 3,
        nextIndex: 16,
        nextName: "Очерет пускає паростки",
        nextEmoji: "🌿",
        previousIndex: 14,
        previousName: "Дика гуска летить на північ",
        previousEmoji: "🦆",
        moonPhase: 0.26,
        moonIllumination: 0.52,
        moonIsWaxing: true,
        prevLabel: "ПОПЕРЕДНІЙ",
        nextLabel: "НАСТУПНИЙ",
        countdownLong: "Наступний сезон через 3 дні",
        countdownShort: "3 дні",
        lockScreenCountdown: "Залишилось 3 дні"
    )
}

// MARK: - Timeline provider

struct SeasonProvider: TimelineProvider {
    func placeholder(in context: Context) -> SeasonEntry { .placeholder }

    func getSnapshot(in context: Context, completion: @escaping (SeasonEntry) -> Void) {
        completion(readFromSharedDefaults(at: Date()) ?? .placeholder)
    }

    /// Build a multi-kō timeline that survives boundaries on its own.
    ///
    /// Old version only knew the *current* kō (whatever Flutter last
    /// wrote). After the kō ended the widget went stale until the app
    /// was re-opened — see widget bug 2026-04. New version reads
    /// `upcomingKosJson` (next 12 kō, ~60 days) and produces daily
    /// entries across boundaries, so iOS rotates kō text / kanji /
    /// sekki on its own.
    func getTimeline(in context: Context,
                     completion: @escaping (Timeline<SeasonEntry>) -> Void) {
        let now = Date()

        // 1. Try the new path — multi-kō buffer.
        if let entries = buildTimelineFromUpcomingBuffer(at: now), !entries.isEmpty {
            completion(Timeline(entries: entries, policy: .atEnd))
            return
        }

        // 2. Legacy fallback — single-kō daily timeline. Triggered if
        //    the app hasn't been opened since this widget version
        //    shipped, so `upcomingKosJson` is missing.
        guard let base = readFromSharedDefaults(at: now) else {
            completion(Timeline(entries: [.placeholder],
                                policy: .after(Date().addingTimeInterval(3600))))
            return
        }
        var entries: [SeasonEntry] = [base]
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: now)
        let horizon = min(max(base.daysUntilNext, 0), 7)
        for i in 1...horizon where horizon > 0 {
            guard let next = calendar.date(byAdding: .day, value: i, to: startOfToday) else { break }
            entries.append(with(base, date: next, daysUntilNext: max(0, base.daysUntilNext - i)))
        }
        let lastDate = entries.last?.date ?? now
        let nextRefresh = calendar.date(byAdding: .hour, value: 1, to: lastDate) ?? now.addingTimeInterval(3600)
        completion(Timeline(entries: entries, policy: .after(nextRefresh)))
    }

    /// Read `upcomingKosJson` and produce a flat array of timeline
    /// entries — one per day per kō, in chronological order. Returns
    /// nil if the buffer hasn't been written yet.
    private func buildTimelineFromUpcomingBuffer(at now: Date) -> [SeasonEntry]? {
        guard let defaults = UserDefaults(suiteName: Const.appGroupId),
              let raw = defaults.string(forKey: "upcomingKosJson"),
              let data = raw.data(using: .utf8),
              let arr = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]],
              !arr.isEmpty else {
            return nil
        }
        let isUk = defaults.integer(forKey: "isUk") == 1
        let prevLabel = defaults.string(forKey: "prevLabel") ?? (isUk ? "ПОПЕРЕДНІЙ" : "PREVIOUS")
        let nextLabel = defaults.string(forKey: "nextLabel") ?? (isUk ? "НАСТУПНИЙ" : "NEXT")
        let moonPhase = defaults.double(forKey: "moonPhase")
        let moonIllum = defaults.double(forKey: "moonIllumination")
        let moonIsWaxing = defaults.integer(forKey: "moonIsWaxing") == 1

        let calendar = Calendar.current
        var entries: [SeasonEntry] = []

        for (i, dict) in arr.enumerated() {
            guard let endMs = (dict["endEpochMs"] as? Int).map(Int64.init)
                            ?? (dict["endEpochMs"] as? Int64) else { continue }
            let startMs = (dict["startEpochMs"] as? Int).map(Int64.init)
                       ?? (dict["startEpochMs"] as? Int64) ?? endMs
            let koStart = Date(timeIntervalSince1970: TimeInterval(startMs) / 1000.0)
            let koEnd = Date(timeIntervalSince1970: TimeInterval(endMs) / 1000.0)

            // For the current kō (i == 0) start the walk at "now" so
            // the first entry reflects today's actual countdown.
            // Future kō walk from their start-of-day midnight.
            var cursor = i == 0 ? now : calendar.startOfDay(for: koStart)

            while cursor <= koEnd {
                let daysToNext = max(
                    0,
                    Int((koEnd.timeIntervalSince(cursor) / 86400.0).rounded(.up))
                )
                entries.append(makeEntry(
                    from: dict, date: cursor, daysUntilNext: daysToNext,
                    isUk: isUk, prevLabel: prevLabel, nextLabel: nextLabel,
                    moonPhase: moonPhase, moonIllumination: moonIllum,
                    moonIsWaxing: moonIsWaxing
                ))
                guard let advanced = calendar.date(
                    byAdding: .day, value: 1,
                    to: calendar.startOfDay(for: cursor)
                ) else { break }
                cursor = advanced
                if entries.count >= 60 { break }
            }
            if entries.count >= 60 { break }
        }
        return entries
    }

    /// Build a SeasonEntry from one element of `upcomingKosJson`.
    private func makeEntry(
        from dict: [String: Any],
        date: Date,
        daysUntilNext: Int,
        isUk: Bool,
        prevLabel: String,
        nextLabel: String,
        moonPhase: Double,
        moonIllumination: Double,
        moonIsWaxing: Bool
    ) -> SeasonEntry {
        let colorHex = (dict["metaColorHex"] as? String) ?? "#8DAAC7"
        return SeasonEntry(
            date: date,
            index: (dict["index"] as? Int) ?? 0,
            kanji: (dict["kanji"] as? String) ?? "",
            romaji: (dict["romaji"] as? String) ?? "",
            name: (dict["name"] as? String) ?? "",
            emoji: (dict["emoji"] as? String) ?? "•",
            sekki: (dict["sekki"] as? String) ?? "",
            sekkiKanji: (dict["sekkiKanji"] as? String) ?? "",
            meta: (dict["meta"] as? String) ?? "",
            metaColor: Color(hex: colorHex),
            daysUntilNext: daysUntilNext,
            nextIndex: (dict["nextIndex"] as? Int) ?? 0,
            nextName: (dict["nextName"] as? String) ?? "",
            nextEmoji: (dict["nextEmoji"] as? String) ?? "•",
            previousIndex: (dict["previousIndex"] as? Int) ?? 0,
            previousName: (dict["previousName"] as? String) ?? "",
            previousEmoji: (dict["previousEmoji"] as? String) ?? "•",
            moonPhase: moonPhase,
            moonIllumination: moonIllumination,
            moonIsWaxing: moonIsWaxing,
            prevLabel: prevLabel,
            nextLabel: nextLabel,
            countdownLong: formatCountdownLong(days: daysUntilNext, isUk: isUk),
            countdownShort: formatCountdownShort(days: daysUntilNext, isUk: isUk),
            lockScreenCountdown: formatLockScreenCountdown(days: daysUntilNext, isUk: isUk)
        )
    }

    /// Copy an entry with overridden date / days-until-next.
    private func with(_ e: SeasonEntry, date: Date, daysUntilNext: Int) -> SeasonEntry {
        SeasonEntry(
            date: date,
            index: e.index, kanji: e.kanji, romaji: e.romaji, name: e.name, emoji: e.emoji,
            sekki: e.sekki, sekkiKanji: e.sekkiKanji, meta: e.meta, metaColor: e.metaColor,
            daysUntilNext: daysUntilNext,
            nextIndex: e.nextIndex, nextName: e.nextName, nextEmoji: e.nextEmoji,
            previousIndex: e.previousIndex, previousName: e.previousName, previousEmoji: e.previousEmoji,
            moonPhase: e.moonPhase, moonIllumination: e.moonIllumination, moonIsWaxing: e.moonIsWaxing,
            prevLabel: e.prevLabel, nextLabel: e.nextLabel,
            countdownLong: e.countdownLong, countdownShort: e.countdownShort,
            lockScreenCountdown: e.lockScreenCountdown
        )
    }

    private func readFromSharedDefaults(at date: Date) -> SeasonEntry? {
        guard let defaults = UserDefaults(suiteName: Const.appGroupId) else {
            return nil
        }
        let kanji = defaults.string(forKey: "kanji") ?? ""
        if kanji.isEmpty { return nil }

        let colorHex = defaults.string(forKey: "metaColorHex") ?? "#8DAAC7"
        return SeasonEntry(
            date: date,
            index: defaults.integer(forKey: "index"),
            kanji: kanji,
            romaji: defaults.string(forKey: "romaji") ?? "",
            name: defaults.string(forKey: "name") ?? "",
            emoji: defaults.string(forKey: "emoji") ?? "•",
            sekki: defaults.string(forKey: "sekki") ?? "",
            sekkiKanji: defaults.string(forKey: "sekkiKanji") ?? "",
            meta: defaults.string(forKey: "meta") ?? "",
            metaColor: Color(hex: colorHex),
            daysUntilNext: defaults.integer(forKey: "daysUntilNext"),
            nextIndex: defaults.integer(forKey: "nextIndex"),
            nextName: defaults.string(forKey: "nextName") ?? "",
            nextEmoji: defaults.string(forKey: "nextEmoji") ?? "•",
            previousIndex: defaults.integer(forKey: "previousIndex"),
            previousName: defaults.string(forKey: "previousName") ?? "",
            previousEmoji: defaults.string(forKey: "previousEmoji") ?? "•",
            moonPhase: defaults.double(forKey: "moonPhase"),
            moonIllumination: defaults.double(forKey: "moonIllumination"),
            moonIsWaxing: defaults.integer(forKey: "moonIsWaxing") == 1,
            prevLabel: defaults.string(forKey: "prevLabel") ?? "PREVIOUS",
            nextLabel: defaults.string(forKey: "nextLabel") ?? "NEXT",
            countdownLong: defaults.string(forKey: "countdownLong") ?? "",
            countdownShort: defaults.string(forKey: "countdownShort") ?? "",
            lockScreenCountdown:
                defaults.string(forKey: "lockScreenCountdown") ?? ""
        )
    }
}

// MARK: - Moon glyph

/// Small moon-phase glyph drawn with SwiftUI Canvas. Mirrors the Dart
/// painter in `lib/features/shared/widgets/moon_phase.dart` — full
/// shadow disc → clip to the lit half → terminator ellipse that either
/// subtracts (crescent) or adds (gibbous) to produce the phase shape.
struct MoonGlyph: View {
    let phase: Double
    let illumination: Double
    let isWaxing: Bool
    /// Base size in logical points.
    let size: CGFloat

    /// Accessible name announced by VoiceOver — "Waxing moon, 52% illuminated".
    private var a11yLabel: String {
        let pct = Int((illumination * 100).rounded())
        let side = isWaxing ? "Зростаючий" : "Спадаючий"
        return "\(side) місяць, освітлено \(pct)%"
    }

    /// Cream ivory for the illuminated side — same on light and dark
    /// widget backgrounds so the moon always reads as "lit".
    private let lit = Color(red: 0.984, green: 0.957, blue: 0.870)
    /// Charcoal for the shadowed side.
    private let shadow = Color(red: 0.169, green: 0.180, blue: 0.212)
    private let stroke = Color.black.opacity(0.22)

    var body: some View {
        Canvas { context, canvasSize in
            let r = min(canvasSize.width, canvasSize.height) / 2
            let center = CGPoint(x: canvasSize.width / 2, y: canvasSize.height / 2)
            let disc = CGRect(x: center.x - r, y: center.y - r,
                              width: 2 * r, height: 2 * r)

            // 1. Full shadow disc
            context.fill(Path(ellipseIn: disc), with: .color(shadow))

            if illumination > 0.995 {
                context.fill(Path(ellipseIn: disc), with: .color(lit))
            } else if illumination >= 0.005 {
                let litHalf: CGRect = isWaxing
                    ? CGRect(x: center.x, y: 0, width: r, height: canvasSize.height)
                    : CGRect(x: 0, y: 0, width: r, height: canvasSize.height)
                let darkHalf: CGRect = isWaxing
                    ? CGRect(x: 0, y: 0, width: r, height: canvasSize.height)
                    : CGRect(x: center.x, y: 0, width: r, height: canvasSize.height)

                // 2. Lit half-disc
                context.drawLayer { ctx in
                    ctx.clip(to: Path(litHalf))
                    ctx.fill(Path(ellipseIn: disc), with: .color(lit))
                }

                // 3. Terminator
                let halfWidth = abs(2 * illumination - 1) * r
                let terminator = CGRect(
                    x: center.x - halfWidth, y: center.y - r,
                    width: 2 * halfWidth, height: 2 * r
                )
                if illumination < 0.5 {
                    // Crescent: subtract a shadow ellipse from the lit half
                    context.drawLayer { ctx in
                        ctx.clip(to: Path(litHalf))
                        ctx.fill(Path(ellipseIn: terminator), with: .color(shadow))
                    }
                } else {
                    // Gibbous: add a lit ellipse into the dark half
                    context.drawLayer { ctx in
                        ctx.clip(to: Path(darkHalf))
                        ctx.fill(Path(ellipseIn: terminator), with: .color(lit))
                    }
                }
            }

            // 4. Rim stroke
            context.stroke(
                Path(ellipseIn: disc.insetBy(dx: 0.5, dy: 0.5)),
                with: .color(stroke), lineWidth: 0.8
            )
        }
        .frame(width: size, height: size)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(a11yLabel)
    }
}

// MARK: - Engraving loader

/// Loads an engraving image from the App Group container. Returns nil if
/// the file hasn't been written yet — callers should fall back to emoji.
private func loadEngraving(_ key: String) -> Image? {
    guard let container = FileManager.default.containerURL(
        forSecurityApplicationGroupIdentifier: Const.appGroupId
    ) else { return nil }
    let url = container.appendingPathComponent("\(key).png")
    guard FileManager.default.fileExists(atPath: url.path),
          let uiImage = UIImage(contentsOfFile: url.path) else { return nil }
    return Image(uiImage: uiImage)
}

/// Per-index engraving lookup — tries `engraving_<index>` first
/// (populated by the upcoming-buffer copy) and falls back to the
/// legacy `engraving_current` key for the very first launch before
/// the buffer has been written. Falls through to nil → emoji.
private func loadEngraving(forEntry entry: SeasonEntry) -> Image? {
    if let img = loadEngraving("engraving_\(entry.index)") { return img }
    return loadEngraving("engraving_current")
}

// MARK: - Views

struct SeasonsWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    var entry: SeasonEntry

    var body: some View {
        switch family {
        case .systemSmall:           SmallView(entry: entry)
        case .systemLarge:           LargeView(entry: entry)
        case .accessoryRectangular:  AccessoryRectangularView(entry: entry)
        default:                     MediumView(entry: entry)
        }
    }
}

/// Small (2×2) — index & meta on top, engraving middle, days bottom.
/// Moon glyph sits in the absolute top-right corner via a ZStack so
/// it's never pushed off-screen by the meta-season text.
/// Kanji is intentionally omitted here: the small size doesn't have
/// room for a script the user can't parse quickly.
struct SmallView: View {
    let entry: SeasonEntry
    private var engraving: Image? { loadEngraving(forEntry: entry) }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Text("#\(entry.index)")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.primary.opacity(0.75))
                    Text("·").foregroundColor(.primary.opacity(0.35))
                    Text(entry.meta.uppercased())
                        .font(.system(size: 9, weight: .semibold))
                        .tracking(1.2)
                        .foregroundColor(.primary.opacity(0.70))
                        .lineLimit(1)
                    // Reserve space on the right so the moon doesn't overlap text
                    Spacer(minLength: 20)
                }
                Spacer(minLength: 0)
                ZStack {
                    if let img = engraving {
                        img.resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: 82)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .accessibilityLabel("Гравюра: \(entry.name)")
                    } else {
                        ZStack {
                            entry.metaColor.opacity(0.30)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            Text(entry.emoji).font(.system(size: 42))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 82)
                    }
                }
                Spacer(minLength: 0)
                Text(entry.countdownShort)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.primary.opacity(0.75))
                    .lineLimit(1)
            }
            // Absolute top-right moon, independent of VStack layout.
            MoonGlyph(
                phase: entry.moonPhase,
                illumination: entry.moonIllumination,
                isWaxing: entry.moonIsWaxing,
                size: 16
            )
        }
    }
}

/// Medium (4×2) — engraving panel on left, text on right. The right
/// column fills vertically with three tiers: meta-season badge up top,
/// localized name in the middle, sekki (24-season) + countdown at the
/// bottom. Each tier is anchored so empty space never gravitates into
/// the middle.
struct MediumView: View {
    let entry: SeasonEntry
    private var engraving: Image? { loadEngraving(forEntry: entry) }

    var body: some View {
        HStack(spacing: 14) {
            // Left panel: engraving, full-bleed with meta-tinted fallback
            ZStack {
                entry.metaColor.opacity(0.30)
                if let img = engraving {
                    img.resizable().scaledToFill()
                } else {
                    VStack(spacing: 6) {
                        Text(entry.emoji).font(.system(size: 52))
                        Text(entry.kanji)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.primary.opacity(0.70))
                            .lineLimit(1)
                    }
                }
            }
            .frame(width: 120)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Гравюра: \(entry.name)")

            // Right column — three vertical tiers.
            VStack(alignment: .leading, spacing: 0) {
                // Tier 1: badge (index + meta) + moon glyph at far right
                HStack(spacing: 4) {
                    Text("#\(entry.index) · \(entry.meta)".uppercased())
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundColor(.primary.opacity(0.70))
                        .tracking(1.2)
                    Spacer(minLength: 2)
                    MoonGlyph(
                        phase: entry.moonPhase,
                        illumination: entry.moonIllumination,
                        isWaxing: entry.moonIsWaxing,
                        size: 14
                    )
                }

                Spacer(minLength: 2)

                // Tier 2: main name — center-anchored, scales to fit
                Text(entry.name)
                    .font(.system(size: 17, weight: .semibold))
                    .lineLimit(3)
                    .minimumScaleFactor(0.75)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer(minLength: 2)

                // Tier 3: sekki + countdown, bottom-anchored
                VStack(alignment: .leading, spacing: 3) {
                    if !entry.sekki.isEmpty {
                        Text(entry.sekki)
                            .font(.system(size: 11))
                            .foregroundColor(.primary.opacity(0.70))
                            .lineLimit(1)
                    }
                    Text(entry.countdownLong)
                        .font(.system(size: 11))
                        .foregroundColor(.primary.opacity(0.7))
                        .lineLimit(1)
                        .minimumScaleFactor(0.85)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
    }
}

/// Large (4×4) — previous | current (medium-style) | next.
struct LargeView: View {
    let entry: SeasonEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            NeighborRow(
                label: entry.prevLabel,
                index: entry.previousIndex,
                emoji: entry.previousEmoji,
                engravingKey: "engraving_previous",
                name: entry.previousName
            )
            .padding(.bottom, 12)
            Divider().opacity(0.35)
            MediumView(entry: entry)
                .frame(height: 135)
                .padding(.vertical, 10)
            Divider().opacity(0.35)
            NeighborRow(
                label: entry.nextLabel,
                index: entry.nextIndex > 0 ? entry.nextIndex : nil,
                emoji: entry.nextEmoji,
                engravingKey: "engraving_next",
                name: entry.nextName
            )
            .padding(.top, 12)
        }
    }
}

/// Compact row used for previous/next sections in the Large widget.
private struct NeighborRow: View {
    let label: String
    let index: Int?
    let emoji: String
    let engravingKey: String
    let name: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Text(label)
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundColor(.primary.opacity(0.70))
                    .tracking(1.2)
                if let index = index {
                    Text("· #\(index)")
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundColor(.primary.opacity(0.55))
                        .tracking(1.0)
                }
            }
            HStack(spacing: 12) {
                if let img = loadEngraving(engravingKey) {
                    img.resizable()
                        .scaledToFill()
                        .frame(width: 36, height: 36)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                } else {
                    Text(emoji).font(.system(size: 26))
                }
                Text(name)
                    .font(.system(size: 14, weight: .medium))
                    .lineLimit(2)
            }
        }
    }
}

/// Lock Screen accessoryRectangular — iOS 16+.
/// Renders in a monochrome / tinted style below the clock.
struct AccessoryRectangularView: View {
    let entry: SeasonEntry

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 4) {
                    Text("#\(entry.index)")
                        .font(.caption2).fontWeight(.bold)
                    Text("·").opacity(0.5)
                    Text(entry.kanji)
                        .font(.caption2).fontWeight(.semibold)
                        .lineLimit(1)
                }
                Text(entry.name)
                    .font(.headline)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                Text(entry.lockScreenCountdown)
                    .font(.caption2)
                    .opacity(0.7)
                    .lineLimit(1)
            }
            Spacer(minLength: 2)
            MoonGlyph(
                phase: entry.moonPhase,
                illumination: entry.moonIllumination,
                isWaxing: entry.moonIsWaxing,
                size: 16
            )
        }
        .widgetAccentable()
    }
}

// MARK: - Widget declaration

struct SeasonsWidget: Widget {
    let kind: String = Const.widgetKind

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SeasonProvider()) { entry in
            // Deep-link URL for the whole widget. Tapping sends
            // `seasons72://season/<index>` to the app, which routes to
            // the corresponding detail screen (see DeepLinkHandler in
            // Dart).
            let url = URL(string: "\(Const.deepLinkScheme)://season/\(entry.index)")

            if #available(iOS 17.0, *) {
                SeasonsWidgetEntryView(entry: entry)
                    .widgetURL(url)
                    .containerBackground(for: .widget) {
                        SeasonalBackground(color: entry.metaColor)
                    }
            } else {
                SeasonsWidgetEntryView(entry: entry)
                    .widgetURL(url)
                    .padding()
                    .background(SeasonalBackground(color: entry.metaColor))
            }
        }
        .configurationDisplayName("72 сезони")
        .description("Поточний японський мікро-сезон")
        .supportedFamilies([
            .systemSmall,
            .systemMedium,
            .systemLarge,
            .accessoryRectangular,
        ])
    }
}

// MARK: - Background

/// Soft meta-season-tinted background. Uses a subtle vertical gradient
/// from tinted top to near-white bottom so text stays readable on both
/// light and dark wallpapers, while the seasonal hue still feels present.
struct SeasonalBackground: View {
    let color: Color
    @Environment(\.colorScheme) var scheme

    var body: some View {
        let isDark = scheme == .dark
        let top = color.opacity(isDark ? 0.30 : 0.22)
        let bottom = color.opacity(isDark ? 0.12 : 0.08)
        LinearGradient(
            colors: [top, bottom],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Helpers

private func countdownText(days: Int) -> String {
    if days == 0 { return "Останній день цього сезону" }
    let mod10 = days % 10
    let mod100 = days % 100
    if mod10 == 1 && mod100 != 11 {
        return "Наступний сезон через \(days) день"
    }
    if (2...4).contains(mod10) && !(12...14).contains(mod100) {
        return "Наступний сезон через \(days) дні"
    }
    return "Наступний сезон через \(days) днів"
}

/// Short countdown label used in the Small widget where space is tight.
/// Returns "Останній день", "1 день", "2 дні", "12 днів".
private func countdownShort(days: Int) -> String {
    if days == 0 { return "Останній день" }
    let mod10 = days % 10
    let mod100 = days % 100
    if mod10 == 1 && mod100 != 11 { return "\(days) день" }
    if (2...4).contains(mod10) && !(12...14).contains(mod100) {
        return "\(days) дні"
    }
    return "\(days) днів"
}

/// Lock-screen / accessory-rectangular variant: frames the countdown
/// around THIS season ("Залишилось X днів"), matching the app's
/// `daysLeftInSeason` l10n string.
private func countdownShortLeft(days: Int) -> String {
    if days == 0 { return "Останній день" }
    let mod10 = days % 10
    let mod100 = days % 100
    if mod10 == 1 && mod100 != 11 { return "Залишився \(days) день" }
    if (2...4).contains(mod10) && !(12...14).contains(mod100) {
        return "Залишилось \(days) дні"
    }
    return "Залишилось \(days) днів"
}

// MARK: - Locale-aware countdowns (used by the multi-kō timeline path)
//
// These mirror `_countdownLong / _countdownShort / _lockScreenCountdown`
// in lib/core/widget/widget_service.dart. When the timeline is built
// from `upcomingKosJson`, the daysUntilNext for future kō isn't known
// to Flutter at write time — Swift computes it per-entry, so the
// strings have to be assembled here too.

/// Returns the Ukrainian plural form: "день" | "дні" | "днів".
private func uaDaysWord(_ days: Int) -> String {
    let mod10 = days % 10
    let mod100 = days % 100
    if mod10 == 1 && mod100 != 11 { return "день" }
    if (2...4).contains(mod10) && !(12...14).contains(mod100) { return "дні" }
    return "днів"
}

/// "Наступний сезон через X днів" / "Next season in X days".
fileprivate func formatCountdownLong(days: Int, isUk: Bool) -> String {
    if days == 0 {
        return isUk ? "Останній день цього сезону" : "Last day of this season"
    }
    if isUk {
        return "Наступний сезон через \(days) \(uaDaysWord(days))"
    }
    return days == 1 ? "Next season in 1 day" : "Next season in \(days) days"
}

/// "X днів" / "X days" — used in Small widget.
fileprivate func formatCountdownShort(days: Int, isUk: Bool) -> String {
    if days == 0 { return isUk ? "Останній день" : "Last day" }
    if isUk { return "\(days) \(uaDaysWord(days))" }
    return days == 1 ? "1 day" : "\(days) days"
}

/// "Залишилось X днів" / "X days left" — used in Lock screen widget.
fileprivate func formatLockScreenCountdown(days: Int, isUk: Bool) -> String {
    if days == 0 { return isUk ? "Останній день" : "Last day" }
    if isUk {
        let mod10 = days % 10
        let mod100 = days % 100
        if mod10 == 1 && mod100 != 11 { return "Залишився \(days) день" }
        if (2...4).contains(mod10) && !(12...14).contains(mod100) {
            return "Залишилось \(days) дні"
        }
        return "Залишилось \(days) днів"
    }
    return days == 1 ? "1 day left" : "\(days) days left"
}

extension Color {
    /// Parse `#RRGGBB` or `#AARRGGBB` hex strings.
    init(hex: String) {
        var h = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if h.hasPrefix("#") { h.removeFirst() }
        var rgb: UInt64 = 0
        Scanner(string: h).scanHexInt64(&rgb)
        let a, r, g, b: UInt64
        switch h.count {
        case 6: (a, r, g, b) = (255, rgb >> 16, (rgb >> 8) & 0xFF, rgb & 0xFF)
        case 8: (a, r, g, b) = (rgb >> 24, (rgb >> 16) & 0xFF, (rgb >> 8) & 0xFF, rgb & 0xFF)
        default: (a, r, g, b) = (255, 141, 170, 199)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Preview

#Preview(as: .systemMedium) {
    SeasonsWidget()
} timeline: {
    SeasonEntry.placeholder
}
