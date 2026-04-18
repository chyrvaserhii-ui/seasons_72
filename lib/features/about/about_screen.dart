import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/seasons_providers.dart';
import '../detail/season_detail_screen.dart';
import 'about_content.dart';

/// "Tradition" tab — long-form piece on the history and meaning of the
/// 72-season Japanese calendar. Content lives in [about_content.dart];
/// this file is just presentation.
class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context);
    final sections = locale.languageCode == 'uk'
        ? aboutSectionsUk
        : aboutSectionsEn;

    // Accent color follows the current season so the tab shares the
    // overall seasonal palette.
    final asyncCurrent = ref.watch(currentSeasonProvider);
    final repo = ref.watch(seasonsRepositoryProvider);
    final accent = asyncCurrent.maybeWhen(
      data: (s) => repo.meta(s.metaId).colorFor(Theme.of(context).brightness),
      orElse: () => Theme.of(context).colorScheme.primary,
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      children: [
        // Oversize kanji header — gives the page a distinct identity.
        _Header(accent: accent),
        const SizedBox(height: 24),
        for (int i = 0; i < sections.length; i++) ...[
          _SectionView(section: sections[i], accent: accent),
          if (i < sections.length - 1) const SizedBox(height: 28),
        ],
      ],
    );
  }
}

/// Header: 2×2 collage of four iconic illustrations (one per meta-season)
/// with cross dividers, kanji corner labels, gradient overlay, and title
/// at the bottom. Each tile is tappable and jumps to that kō's detail.
class _Header extends StatelessWidget {
  const _Header({required this.accent});
  final Color accent;

  /// Flagship kō per meta-season with its era kanji + asset path.
  /// If an asset is missing, the tile gracefully falls back to grey.
  static const List<_FlagshipTile> _flagships = [
    _FlagshipTile(index: 11, kanji: '春', asset: 'assets/images/ko/11.png'),
    _FlagshipTile(index: 19, kanji: '夏', asset: 'assets/images/ko/19.png'),
    _FlagshipTile(index: 54, kanji: '秋', asset: 'assets/images/ko/54.png'),
    _FlagshipTile(index: 61, kanji: '冬', asset: 'assets/images/ko/61.png'),
  ];

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final title = locale.languageCode == 'uk'
        ? '72 мікро-сезони'
        : '72 micro-seasons';
    final divider = accent.withValues(alpha: 0.85);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 240,
        decoration: BoxDecoration(
          border: Border.all(color: accent.withValues(alpha: 0.55)),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Row 0 + row 1 of tiles. Cross dividers appear between them.
            Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                          child: _Tile(spec: _flagships[0], align: Alignment.topLeft)),
                      Container(width: 1.5, color: divider),
                      Expanded(
                          child: _Tile(spec: _flagships[1], align: Alignment.topRight)),
                    ],
                  ),
                ),
                Container(height: 1.5, color: divider),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                          child: _Tile(spec: _flagships[2], align: Alignment.bottomLeft)),
                      Container(width: 1.5, color: divider),
                      Expanded(
                          child: _Tile(spec: _flagships[3], align: Alignment.bottomRight)),
                    ],
                  ),
                ),
              ],
            ),
            // Title centered vertically over the cross divider — sits in
            // a dark pill so every tile's corner remains visible.
            Center(
              child: IgnorePointer(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'SHICHIJŪNI-KŌ',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2.5,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          height: 1.1,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Flagship entry for each meta-season: index in the calendar, the kanji
/// character (春/夏/秋/冬), and the illustration asset path.
class _FlagshipTile {
  final int index;
  final String kanji;
  final String asset;
  const _FlagshipTile({
    required this.index,
    required this.kanji,
    required this.asset,
  });
}

/// Single collage tile — image + kanji badge in the corner + tap handler
/// that navigates to the kō's detail screen.
class _Tile extends StatelessWidget {
  const _Tile({required this.spec, required this.align});
  final _FlagshipTile spec;
  final Alignment align;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          spec.asset,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
          ),
        ),
        // Kanji era badge in the appropriate corner of the tile.
        Align(
          alignment: align,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.45),
                shape: BoxShape.circle,
              ),
              child: Text(
                spec.kanji,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        // Tappable overlay — jumps to the kō's detail page.
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => SeasonDetailScreen(seasonIndex: spec.index),
                ));
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionView extends StatelessWidget {
  const _SectionView({required this.section, required this.accent});
  final AboutSection section;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title with colored accent bar on the left
        Row(
          children: [
            Container(
              width: 3,
              height: 22,
              color: accent.withValues(alpha: 0.75),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                section.title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: onSurface,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        for (final para in section.paragraphs) ...[
          Text(
            para,
            style: TextStyle(
              fontSize: 15.5,
              height: 1.6,
              color: onSurface.withValues(alpha: 0.88),
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (section.pullQuote != null) ...[
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              section.pullQuote!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
                color: onSurface.withValues(alpha: 0.85),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
