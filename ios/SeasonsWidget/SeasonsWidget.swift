//
//  SeasonsWidget.swift
//  Home-screen widget for the 72 Japanese micro-seasons app.
//
//  Reads current kō data from UserDefaults in an App Group shared with
//  the Flutter app. Flutter writes this data via the `home_widget`
//  package (see lib/core/widget/widget_service.dart).
//

import SwiftUI
import WidgetKit

// MARK: - Constants

private enum Const {
    /// Must match `WidgetService.appGroupId` in Dart and the App Group
    /// capability enabled on both targets.
    static let appGroupId = "group.com.seasons72.shared"
    static let widgetKind = "SeasonsWidget"
}

// MARK: - Model

/// Snapshot of a kō at a moment in time. Pulled out of the shared
/// UserDefaults each time the widget timeline refreshes.
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
    let nextName: String
    let nextEmoji: String

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
        nextName: "Очерет пускає паростки",
        nextEmoji: "🌿"
    )
}

// MARK: - Timeline provider

struct SeasonProvider: TimelineProvider {
    func placeholder(in context: Context) -> SeasonEntry {
        SeasonEntry.placeholder
    }

    func getSnapshot(in context: Context, completion: @escaping (SeasonEntry) -> Void) {
        completion(readFromSharedDefaults() ?? .placeholder)
    }

    func getTimeline(in context: Context,
                     completion: @escaping (Timeline<SeasonEntry>) -> Void) {
        let now = Date()
        let entry = readFromSharedDefaults() ?? .placeholder
        // Refresh every hour — good enough to keep the "days remaining"
        // counter fresh, and gives the Flutter app a chance to write
        // new data when the kō rolls over.
        let nextRefresh = Calendar.current.date(byAdding: .hour, value: 1, to: now)!
        completion(Timeline(entries: [entry], policy: .after(nextRefresh)))
    }

    private func readFromSharedDefaults() -> SeasonEntry? {
        guard let defaults = UserDefaults(suiteName: Const.appGroupId) else {
            return nil
        }
        let kanji = defaults.string(forKey: "kanji") ?? ""
        if kanji.isEmpty { return nil }

        let colorHex = defaults.string(forKey: "metaColorHex") ?? "#8DAAC7"
        return SeasonEntry(
            date: Date(),
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
            nextName: defaults.string(forKey: "nextName") ?? "",
            nextEmoji: defaults.string(forKey: "nextEmoji") ?? "•"
        )
    }
}

// MARK: - Views

struct SeasonsWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    var entry: SeasonEntry

    var body: some View {
        switch family {
        case .systemSmall:
            SmallView(entry: entry)
        case .systemLarge:
            LargeView(entry: entry)
        default:
            MediumView(entry: entry)
        }
    }
}

/// Small (2×2) — minimal: kanji + emoji, meta color tint.
struct SmallView: View {
    let entry: SeasonEntry

    var body: some View {
        ZStack(alignment: .topLeading) {
            LinearGradient(
                colors: [entry.metaColor.opacity(0.5), entry.metaColor.opacity(0.1)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            VStack(alignment: .leading, spacing: 4) {
                Text("#\(entry.index)")
                    .font(.caption).fontWeight(.semibold)
                    .foregroundColor(.primary.opacity(0.6))
                Spacer()
                Text(entry.emoji).font(.system(size: 38))
                Text(entry.kanji)
                    .font(.system(size: 18, weight: .medium))
                    .lineLimit(1)
                Text("\(entry.daysUntilNext) дн.")
                    .font(.caption2)
                    .foregroundColor(.primary.opacity(0.55))
            }
            .padding(12)
        }
    }
}

/// Medium (4×2) — primary layout: emoji on left, text on right.
struct MediumView: View {
    let entry: SeasonEntry

    var body: some View {
        HStack(spacing: 0) {
            // Left: emoji panel on meta-color background
            ZStack {
                LinearGradient(
                    colors: [entry.metaColor.opacity(0.55), entry.metaColor.opacity(0.15)],
                    startPoint: .topLeading, endPoint: .bottomTrailing
                )
                VStack(spacing: 6) {
                    Text(entry.emoji).font(.system(size: 52))
                    Text(entry.kanji)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.primary.opacity(0.55))
                        .lineLimit(1)
                }
            }
            .frame(width: 130)

            // Right: textual info
            VStack(alignment: .leading, spacing: 4) {
                Text("#\(entry.index) · \(entry.meta)".uppercased())
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundColor(.primary.opacity(0.55))
                    .tracking(1.2)
                Text(entry.name)
                    .font(.system(size: 16, weight: .semibold))
                    .lineLimit(3)
                    .minimumScaleFactor(0.8)
                Spacer(minLength: 4)
                Text(countdownText(days: entry.daysUntilNext))
                    .font(.system(size: 12))
                    .foregroundColor(.primary.opacity(0.7))
                    .lineLimit(2)
            }
            .padding(.leading, 12)
            .padding(.vertical, 12)
            .padding(.trailing, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

/// Large (4×4) — medium layout + next-kō preview at bottom.
struct LargeView: View {
    let entry: SeasonEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            MediumView(entry: entry)
                .frame(height: 155)
            Divider().opacity(0.35)
            VStack(alignment: .leading, spacing: 6) {
                Text("НАСТУПНИЙ")
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundColor(.primary.opacity(0.55))
                    .tracking(1.2)
                HStack(spacing: 12) {
                    Text(entry.nextEmoji).font(.system(size: 30))
                    Text(entry.nextName)
                        .font(.system(size: 14, weight: .medium))
                        .lineLimit(2)
                }
            }
            .padding(16)
        }
    }
}

// MARK: - Widget declaration

struct SeasonsWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: Const.widgetKind, provider: SeasonProvider()) { entry in
            SeasonsWidgetEntryView(entry: entry)
                .containerBackground(for: .widget) {
                    Color(.systemBackground)
                }
        }
        .configurationDisplayName("72 сезони")
        .description("Поточний японський мікро-сезон")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

// MARK: - Helpers

private func countdownText(days: Int) -> String {
    // Ukrainian plural rules: one / few / many
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

// MARK: - Preview (for Xcode canvas)

struct SeasonsWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SeasonsWidgetEntryView(entry: .placeholder)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .previewDisplayName("Small")
            SeasonsWidgetEntryView(entry: .placeholder)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
                .previewDisplayName("Medium")
            SeasonsWidgetEntryView(entry: .placeholder)
                .previewContext(WidgetPreviewContext(family: .systemLarge))
                .previewDisplayName("Large")
        }
    }
}
