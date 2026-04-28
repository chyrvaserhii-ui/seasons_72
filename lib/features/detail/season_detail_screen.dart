import 'package:flutter/material.dart';
import 'package:seasons_72/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/season_models.dart';
import '../../core/providers/seasons_providers.dart';
import '../../core/settings/settings_provider.dart';
import '../../core/utils/localized_names.dart';
import '../share/share_service.dart';
import '../shared/widgets/ambient_player.dart';
import '../shared/widgets/period_strip.dart';
import '../shared/widgets/season_hero.dart';
import '../shared/widgets/sekki_card.dart';
import 'colors_card.dart';
import 'food_card.dart';
import 'hana_card.dart';
import 'kigo_card.dart';
import 'kodo_card.dart';
import 'kotowaza_card.dart';
import 'practice_card.dart';
import 'tea_card.dart';

/// Season detail with horizontal swipe navigation across all 72 kō.
///
/// The screen wraps a [PageView] so a left/right swipe moves to the
/// neighbouring kō without going back to the list. Tap-from-list still
/// jumps to a specific season — that becomes the [PageView]'s initial
/// page. The AppBar (sekki name, audio + share buttons, tints) follows
/// the currently visible page.
class SeasonDetailScreen extends ConsumerStatefulWidget {
  const SeasonDetailScreen({super.key, required this.seasonIndex});

  final int seasonIndex;

  @override
  ConsumerState<SeasonDetailScreen> createState() =>
      _SeasonDetailScreenState();
}

class _SeasonDetailScreenState extends ConsumerState<SeasonDetailScreen> {
  late final PageController _pageController;
  late int _currentIndex; // 1..72

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.seasonIndex.clamp(1, 72);
    _pageController = PageController(initialPage: _currentIndex - 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final repo = ref.watch(seasonsRepositoryProvider);
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    final ko = repo.byIndex(_currentIndex);
    final meta = repo.meta(ko.metaId);
    final sekki = repo.sekki(ko.sekkiId);

    final scaffoldBg = Color.alphaBlend(
      meta.colorFor(brightness).withValues(alpha: isDark ? 0.08 : 0.12),
      Theme.of(context).colorScheme.surface,
    );
    final appBarBg = Color.alphaBlend(
      meta.colorFor(brightness).withValues(alpha: isDark ? 0.18 : 0.25),
      Theme.of(context).colorScheme.surface,
    );

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: appBarBg,
        title: Text(
          '${sekki.kanji}  ${sekki.localizedName(locale)}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          AmbientPlayerButton(
            koIndex: ko.index,
            metaId: meta.id,
            accentColor: meta.colorFor(brightness),
          ),
          IconButton(
            icon: const Icon(Icons.ios_share),
            tooltip: l10n.shareSeasonTooltip,
            onPressed: () => ShareService.instance.shareSeason(
              context: context,
              ko: ko,
              meta: meta,
              sekki: sekki,
            ),
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: 72,
        onPageChanged: (i) => setState(() => _currentIndex = i + 1),
        itemBuilder: (context, i) => _DetailPage(seasonIndex: i + 1),
      ),
    );
  }
}

/// Renders the full detail content for a single kō. Pure widget — all
/// state lives in the parent so swipe doesn't lose scroll position
/// per-page.
class _DetailPage extends ConsumerWidget {
  const _DetailPage({required this.seasonIndex});
  final int seasonIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context);
    final repo = ref.watch(seasonsRepositoryProvider);
    final brightness = Theme.of(context).brightness;

    final ko = repo.byIndex(seasonIndex);
    final meta = repo.meta(ko.metaId);
    final sekki = repo.sekki(ko.sekkiId);
    final accent = meta.colorFor(brightness);
    final cards = ref.watch(settingsProvider).cards;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        SeasonHero(ko: ko, meta: meta),
        const SizedBox(height: 20),
        SeasonTitleBlock(
          ko: ko,
          locale: locale,
          accentColor: accent,
        ),
        const SizedBox(height: 16),
        Text(ko.localizedDescription(locale),
            style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 24),
        SeasonHaiku(ko: ko, accentColor: accent),
        // Each card below is conditional on its own visibility toggle
        // in Settings → Season cards. The leading SizedBox collapses
        // with the card so the layout stays clean when toggles are
        // off. Period sits at the top because it's the calendar
        // anchor — every other card hangs off "which 5 days is this".
        // Period strip — single shared format with the Home screen
        // (📅 dates · кō N з 72). Always shown (no toggle); Period
        // was lifted out of the 9-card concept since it doesn't fit
        // the cultural-tradition register of the other 8.
        const SizedBox(height: 18),
        PeriodStrip(ko: ko, locale: locale),
        if (cards.sekki) ...[
          const SizedBox(height: 18),
          SekkiCard(
            meta: meta,
            sekki: sekki,
            locale: locale,
            accentColor: accent,
          ),
        ],
        if (cards.tea) ...[
          const SizedBox(height: 18),
          TeaCard(koIndex: ko.index, locale: locale),
        ],
        if (cards.food) ...[
          const SizedBox(height: 18),
          FoodCard(koIndex: ko.index, locale: locale),
        ],
        if (cards.hana) ...[
          const SizedBox(height: 18),
          HanaCard(koIndex: ko.index, locale: locale),
        ],
        if (cards.colors) ...[
          const SizedBox(height: 18),
          ColorsCard(koIndex: ko.index, locale: locale),
        ],
        if (cards.kodo) ...[
          const SizedBox(height: 18),
          KodoCard(koIndex: ko.index, locale: locale),
        ],
        if (cards.kigo) ...[
          const SizedBox(height: 18),
          KigoCard(koIndex: ko.index, locale: locale),
        ],
        if (cards.kotowaza) ...[
          const SizedBox(height: 18),
          KotowazaCard(koIndex: ko.index, locale: locale),
        ],
        if (cards.practice) ...[
          const SizedBox(height: 18),
          PracticeCard(koIndex: ko.index, locale: locale),
        ],
        const SizedBox(height: 28),
      ],
    );
  }
}

/// (Unused after the swipe refactor — kept temporarily in case the
/// previous/next nav-tile pattern needs to come back. Otherwise can be
/// deleted in the next sweep.)
// ignore: unused_element
class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.header,
    required this.ko,
    required this.color,
    required this.onTap,
  });
  final String header;
  final MicroSeason ko;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.55)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              header.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.4,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SeasonThumbnail(ko: ko, color: color, size: 40),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    ko.localizedName(locale),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 13,
                          height: 1.25,
                          fontWeight: FontWeight.w500,
                        ),
                    maxLines: 3,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
