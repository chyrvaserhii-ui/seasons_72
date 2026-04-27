import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/seasons_providers.dart';
import '../detail/season_detail_screen.dart';
import 'about_content.dart';

// Card-tradition accents — match the row-card tints on the home / detail
// screens so the Tradition tab's "Seven traditions" overview is visually
// recognisable. Order matches `cardTraditionsUk` / `cardTraditionsEn`.
const List<Color> _cardAccents = [
  Color(0xFF8FBF7F), // tea — jade
  Color(0xFFD89060), // food — persimmon
  Color(0xFFE6A4B4), // hana — sakura pink
  Color(0xFF8DAAC7), // colors — soft slate
  Color(0xFFB8956A), // kodo — amber resin
  Color(0xFF3E5C8A), // kigo — saijiki indigo
  Color(0xFF809B92), // practice — sage
];

/// "Tradition" tab — long-form piece on the history and meaning of the
/// 72-season Japanese calendar. Content lives in [about_content.dart];
/// this file is just presentation. Stateful so we can hold a scroll
/// controller for TOC anchor-jumps to the cards overview section.
class AboutScreen extends ConsumerStatefulWidget {
  const AboutScreen({super.key});

  @override
  ConsumerState<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends ConsumerState<AboutScreen> {
  final ScrollController _scrollController = ScrollController();
  // GlobalKey on the cards-overview section so we can scroll exactly
  // to its top from the top-of-page TOC chip.
  final GlobalKey _cardsAnchorKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Scrolls the ListView so the cards-overview section sits at the
  /// top of the viewport. Uses [RenderAbstractViewport.getOffsetToReveal]
  /// directly so it works reliably even when the section hasn't been
  /// laid out yet (lazy viewport) — Scrollable.ensureVisible can
  /// silently no-op in that case on some Flutter versions.
  void _scrollToCards() {
    if (!_scrollController.hasClients) return;
    final ctx = _cardsAnchorKey.currentContext;
    final renderObject = ctx?.findRenderObject();
    final position = _scrollController.position;

    if (renderObject != null) {
      final viewport = RenderAbstractViewport.maybeOf(renderObject);
      if (viewport != null) {
        final offset =
            viewport.getOffsetToReveal(renderObject, 0.0).offset;
        position.animateTo(
          offset.clamp(0.0, position.maxScrollExtent),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCubic,
        );
        return;
      }
    }
    // Fallback: section not yet laid out — animate to bottom of the
    // ListView, where the section sits as the last child.
    position.animateTo(
      position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
  }

  /// One [GlobalKey] per about-section. Used by the TOC chip row to
  /// scroll directly to a tapped section. Created lazily (and stably)
  /// so identity survives rebuilds.
  final Map<int, GlobalKey> _sectionKeys = {};

  GlobalKey _keyFor(int i) => _sectionKeys.putIfAbsent(i, () => GlobalKey());

  void _scrollToSection(int index) {
    final ctx = _sectionKeys[index]?.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
      alignment: 0.05,
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final isUk = locale.languageCode == 'uk';
    final sections = isUk ? aboutSectionsUk : aboutSectionsEn;
    final cardTraditions =
        isUk ? cardTraditionsUk : cardTraditionsEn;

    // Accent color follows the current season so the tab shares the
    // overall seasonal palette.
    final asyncCurrent = ref.watch(currentSeasonProvider);
    final repo = ref.watch(seasonsRepositoryProvider);
    final accent = asyncCurrent.maybeWhen(
      data: (s) => repo.meta(s.metaId).colorFor(Theme.of(context).brightness),
      orElse: () => Theme.of(context).colorScheme.primary,
    );

    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Oversize kanji header — gives the page a distinct identity.
          _Header(accent: accent),
          const SizedBox(height: 16),
          // Sticky-top horizontal TOC: one chip per section + a final
          // chip for the cards overview. Tap → scroll to section.
          _TocChipRow(
            sectionTitles: sections.map((s) => s.title).toList(),
            cardsLabel: isUk
                ? 'Сім традицій'
                : 'Seven traditions',
            accent: accent,
            onSectionTap: _scrollToSection,
            onCardsTap: _scrollToCards,
          ),
          const SizedBox(height: 18),
          for (int i = 0; i < sections.length; i++) ...[
            KeyedSubtree(
              key: _keyFor(i),
              child: _SectionView(section: sections[i], accent: accent),
            ),
            if (i < sections.length - 1) const SizedBox(height: 28),
          ],
          const SizedBox(height: 32),
          _CardsOverviewSection(
            key: _cardsAnchorKey,
            isUk: isUk,
            traditions: cardTraditions,
            accents: _cardAccents,
          ),
        ],
      ),
    );
  }
}

/// Horizontal scrolling chip row at the top of the Tradition tab.
/// Lets the reader jump straight to any section instead of scrolling
/// the entire prose. Last chip jumps to the cards overview.
class _TocChipRow extends StatelessWidget {
  const _TocChipRow({
    required this.sectionTitles,
    required this.cardsLabel,
    required this.accent,
    required this.onSectionTap,
    required this.onCardsTap,
  });

  final List<String> sectionTitles;
  final String cardsLabel;
  final Color accent;
  final ValueChanged<int> onSectionTap;
  final VoidCallback onCardsTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 2),
        children: [
          for (int i = 0; i < sectionTitles.length; i++) ...[
            _TocChip(
              label: sectionTitles[i],
              accent: accent,
              onTap: () => onSectionTap(i),
              filled: false,
            ),
            const SizedBox(width: 8),
          ],
          // Final filled chip — visual emphasis on the cards overview
          // so the reader sees a clear destination.
          _TocChip(
            label: '$cardsLabel ↓',
            accent: accent,
            onTap: onCardsTap,
            filled: true,
          ),
        ],
      ),
    );
  }
}

/// Compact pill at the top of the Tradition tab that scrolls to the
/// "Seven traditions" overview section. Keeps the reader oriented —
/// they know where this page is going before they start reading.
class _TocChip extends StatelessWidget {
  const _TocChip({
    required this.label,
    required this.accent,
    required this.onTap,
    this.filled = true,
  });

  final String label;
  final Color accent;
  final VoidCallback onTap;

  /// `true` = solid accent fill (use for the primary "destination"
  /// chip). `false` = outlined / soft-tinted variant for secondary
  /// section chips so the row reads as one filled chip + many quiet
  /// outlined ones.
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Material(
      color: filled
          ? accent.withValues(alpha: isDark ? 0.20 : 0.16)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: accent.withValues(alpha: filled ? 0.30 : 0.45),
              width: filled ? 0.6 : 0.8,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
              color: theme.colorScheme.onSurface
                  .withValues(alpha: filled ? 0.92 : 0.78),
            ),
          ),
        ),
      ),
    );
  }
}

/// "Seven traditions" — the cards-overview section. Renders one
/// stylised block per CardTradition with its own emoji, accent, and
/// description, so the reader can recognise each row card from home
/// or detail in plain prose.
class _CardsOverviewSection extends StatelessWidget {
  const _CardsOverviewSection({
    super.key,
    required this.isUk,
    required this.traditions,
    required this.accents,
  });

  final bool isUk;
  final List<CardTradition> traditions;
  final List<Color> accents;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isUk ? 'Сім традицій сезону' : 'Seven traditions of a season',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: onSurface,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isUk
              ? 'Кожен кō розкладається на сім окремих карток. Кожна спирається на свою японську чи китайську традицію — ось вони з коротким описом, що там усередині.'
              : 'Every kō unfolds into seven distinct cards. Each draws on its own Japanese or Chinese tradition — here is what each one offers.',
          style: TextStyle(
            fontSize: 14.5,
            height: 1.55,
            color: onSurface.withValues(alpha: 0.78),
          ),
        ),
        const SizedBox(height: 18),
        for (int i = 0; i < traditions.length; i++) ...[
          _CardTraditionTile(
            tradition: traditions[i],
            accent: accents[i],
            isUk: isUk,
          ),
          if (i < traditions.length - 1) const SizedBox(height: 14),
        ],
      ],
    );
  }
}

/// One stylised description block in the "Seven traditions" overview.
/// Layout mirrors the home/detail row cards visually (emoji on the
/// left, accent tint, rounded background) so the reader can quickly
/// associate each entry with the actual card they'll see on the
/// season screen.
class _CardTraditionTile extends StatelessWidget {
  const _CardTraditionTile({
    required this.tradition,
    required this.accent,
    required this.isUk,
  });

  final CardTradition tradition;
  final Color accent;
  final bool isUk;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    return Container(
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accent.withValues(alpha: 0.30)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Emoji badge — large and tinted to match the card's accent.
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.22),
              shape: BoxShape.circle,
            ),
            child: Text(
              tradition.emoji,
              style: const TextStyle(fontSize: 22),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tradition.name,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  tradition.tradition,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: onSurface.withValues(alpha: 0.85),
                  ),
                ),
                const SizedBox(height: 10),
                // "Inside" line — labelled mini-header so the reader
                // sees it as the practical sibling of the tradition.
                Text(
                  isUk ? 'УСЕРЕДИНІ КАРТКИ' : 'INSIDE THE CARD',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: onSurface.withValues(alpha: 0.55),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tradition.contents,
                  style: TextStyle(
                    fontSize: 13.5,
                    height: 1.45,
                    color: onSurface.withValues(alpha: 0.75),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
        ? '72 сезони'
        : '72 seasons';
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

/// One section in the Tradition page — collapsible. Tap on the
/// title row toggles the body (paragraphs + pull-quote) with a
/// smooth [AnimatedSize] reveal. Open by default; the user can fold
/// any section away when scanning rather than reading.
class _SectionView extends StatefulWidget {
  const _SectionView({required this.section, required this.accent});
  final AboutSection section;
  final Color accent;

  @override
  State<_SectionView> createState() => _SectionViewState();
}

class _SectionViewState extends State<_SectionView> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final accent = widget.accent;
    final section = widget.section;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title — tappable to collapse / expand. Accent bar
        // on the left, chevron on the right that rotates with state.
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
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
                const SizedBox(width: 8),
                AnimatedRotation(
                  turns: _expanded ? 0.0 : -0.25,
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOut,
                  child: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 22,
                    color: onSurface.withValues(alpha: 0.55),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Animated body — smoothly grows / collapses on toggle.
        ClipRect(
          child: AnimatedSize(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeInOutCubic,
            alignment: Alignment.topCenter,
            child: _expanded
                ? Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                          // Decorative pull-quote — accent-tinted
                          // card, oversize quote glyph, italic.
                          // Replaces the previous flat tinted box
                          // with something that reads as a poetic
                          // emphasis rather than a callout box.
                          _PullQuote(
                            text: section.pullQuote!,
                            accent: accent,
                          ),
                        ],
                      ],
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ),
      ],
    );
  }
}

/// Decorative pull-quote — used between sections to lift a key line
/// out of the prose. Style: oversize quote glyph in the accent
/// colour, italic body, soft accent-tinted background, generous
/// vertical padding so it breathes on the page.
class _PullQuote extends StatelessWidget {
  const _PullQuote({required this.text, required this.accent});
  final String text;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final onSurface = theme.colorScheme.onSurface;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: isDark ? 0.16 : 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: accent.withValues(alpha: isDark ? 0.35 : 0.30),
          width: 0.6,
        ),
      ),
      // Pulled out the oversize Western "“" glyph — it rendered as a
      // heavy block-quote mark that read as out-of-place against the
      // app's restrained Japanese typography. Italic also dropped for
      // the same reason. The pull-quote now relies on the tinted card
      // + accent border alone for emphasis, in line with the rest of
      // the visual system. If a "callout" feel is wanted later, the
      // cleanest Japanese equivalent is a small「」corner bracket
      // before the text, NOT a large decorative quote glyph.
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
          height: 1.45,
          color: onSurface.withValues(alpha: 0.92),
        ),
      ),
    );
  }
}
