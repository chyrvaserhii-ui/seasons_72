import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/models/season_models.dart';
import '../../core/utils/localized_names.dart';

/// Visual layout for the share image.
///
/// Logical size is 360 × 450 px — captured at pixel ratio 3.0 for a
/// 1080 × 1350 output (Instagram story / Twitter ratio).
///
/// Composition (top → bottom, four bands):
///   1. Engraving — full-bleed top, ~45% of card height
///   2. Title block — kanji, localized name, romaji, date range
///   3. Haiku — quoted with author attribution
///   4. Footer — `72 SEASONS · 七十二候` editorial mark
///
/// The card is **never visible** to the user — it's mounted offscreen
/// just long enough for `RenderRepaintBoundary.toImage` to capture it.
/// See `share_service.dart`.
class ShareCard extends StatelessWidget {
  const ShareCard({
    super.key,
    required this.ko,
    required this.meta,
    required this.sekki,
    required this.locale,
  });

  final MicroSeason ko;
  final MetaSeason meta;
  final Sekki sekki;
  final Locale locale;

  static const double width = 360;
  static const double height = 450;

  @override
  Widget build(BuildContext context) {
    final isUk = locale.languageCode == 'uk';
    final df = DateFormat.MMMMd(locale.languageCode);
    final year = DateTime.now().year;
    final dateRange =
        '${df.format(ko.startDateForYear(year))} – ${df.format(ko.endDateForYear(year))}';
    final accent = meta.colorFor(Brightness.light);

    // Background tint for the lower text bands so the engraving has a
    // clean horizon line instead of fading into white.
    const bgPaper = Color(0xFFF5EFE6); // washi cream

    return Material(
      // Render with a fixed light theme regardless of user settings —
      // share images live outside the app, so consistency wins over
      // theme-following.
      type: MaterialType.canvas,
      color: bgPaper,
      child: SizedBox(
        width: width,
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Band 1: engraving ─────────────────────────────────────
            // Compact (160pt = 35% of card height) so the title +
            // haiku stay visible in the iOS share-sheet thumbnail
            // preview, which only shows the top half.
            SizedBox(
              height: 160,
              child: ko.illustrationAsset != null
                  ? Image.asset(
                      ko.illustrationAsset!,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                    )
                  : Container(
                      color: accent.withValues(alpha: 0.30),
                      alignment: Alignment.center,
                      child: Text(
                        ko.emoji,
                        style: const TextStyle(fontSize: 80),
                      ),
                    ),
            ),

            // ── Band 2: title block ───────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Meta · index micro-cap
                  Text(
                    '${meta.localizedName(locale).toUpperCase()} · #${ko.index}',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2.2,
                      color: const Color(0xFF1A1615).withValues(alpha: 0.55),
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Kanji — focal point
                  Text(
                    ko.kanji,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: accent.withValues(alpha: 0.95),
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isUk ? ko.nameUk : ko.nameEn,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1615),
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${ko.romaji}  ·  $dateRange',
                    style: TextStyle(
                      fontSize: 11,
                      color:
                          const Color(0xFF1A1615).withValues(alpha: 0.55),
                    ),
                  ),
                ],
              ),
            ),

            // ── Band 3: haiku (or filler) ─────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: _HaikuBlock(ko: ko, locale: locale, accent: accent),
              ),
            ),

            // ── Band 4: footer ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 6, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Tiny seal mark — vermilion dot like the haiku frame.
                  Container(
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFB94A3D),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '72 SEASONS  ·  七十二候',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2.0,
                      color:
                          const Color(0xFF1A1615).withValues(alpha: 0.65),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Quoted haiku with author. If the kō has no haiku, falls back to a
/// brief description so the card never feels empty.
class _HaikuBlock extends StatelessWidget {
  const _HaikuBlock({
    required this.ko,
    required this.locale,
    required this.accent,
  });
  final MicroSeason ko;
  final Locale locale;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final haiku = ko.localizedHaiku(locale);
    final author = ko.localizedHaikuAuthor(locale);

    if (haiku == null || haiku.isEmpty) {
      // Fallback: short description if no haiku
      return Center(
        child: Text(
          ko.localizedDescription(locale),
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF1A1615),
            height: 1.5,
          ),
          textAlign: TextAlign.center,
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Top accent rule
        Container(
          width: 32,
          height: 1,
          color: accent.withValues(alpha: 0.4),
        ),
        const SizedBox(height: 12),
        Text(
          haiku,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Color(0xFF1A1615),
            height: 1.5,
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        if (author != null && author.isNotEmpty)
          Text(
            '— $author',
            style: TextStyle(
              fontSize: 11,
              color: const Color(0xFF1A1615).withValues(alpha: 0.65),
            ),
          ),
      ],
    );
  }
}
