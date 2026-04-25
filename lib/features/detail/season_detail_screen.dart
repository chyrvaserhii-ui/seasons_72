import 'package:flutter/material.dart';
import 'package:seasons_72/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/models/season_models.dart';
import '../../core/providers/seasons_providers.dart';
import '../../core/utils/localized_names.dart';
import '../share/share_service.dart';
import '../shared/widgets/ambient_player.dart';
import '../shared/widgets/season_hero.dart';

class SeasonDetailScreen extends ConsumerWidget {
  const SeasonDetailScreen({super.key, required this.seasonIndex});

  final int seasonIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final repo = ref.watch(seasonsRepositoryProvider);
    final calc = ref.watch(seasonCalculatorProvider);

    final ko = repo.byIndex(seasonIndex);
    final meta = repo.meta(ko.metaId);
    final sekki = repo.sekki(ko.sekkiId);
    final prev = calc.previous(ko);
    final next = calc.next(ko);

    final year = DateTime.now().year;
    final df = DateFormat.MMMMd(locale.languageCode);
    final dateRange =
        '${df.format(ko.startDateForYear(year))} – ${df.format(ko.endDateForYear(year))}';

    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final scaffoldBg = Color.alphaBlend(
      meta.colorFor(brightness).withValues(alpha: isDark ? 0.08 : 0.12),
      Theme.of(context).colorScheme.surface,
    );
    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: Color.alphaBlend(
          meta.colorFor(brightness).withValues(alpha: isDark ? 0.18 : 0.25),
          Theme.of(context).colorScheme.surface,
        ),
        title: Text(
          '${sekki.kanji}  ${sekki.localizedName(locale)}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          // Sound button — plays a per-kō clip (e.g. frogs for #19)
          // when one is registered in `ambientOverrides`, otherwise
          // falls back to the meta-season default.
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
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          SeasonHero(ko: ko, meta: meta),
          const SizedBox(height: 20),
          SeasonTitleBlock(
            ko: ko,
            locale: locale,
            accentColor: meta.colorFor(brightness),
          ),
          const SizedBox(height: 16),
          Text(ko.localizedDescription(locale),
              style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 24),
          SeasonHaiku(ko: ko, accentColor: meta.colorFor(brightness)),
          const SizedBox(height: 24),
          _FactRow(label: l10n.periodLabel, value: dateRange),
          const SizedBox(height: 28),
          // IntrinsicHeight makes both tiles match the taller one so the
          // boxes look balanced even when one name is short and the other
          // wraps to 2-3 lines.
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _NavTile(
                    header: l10n.previousSeason,
                    ko: prev,
                    color: repo.meta(prev.metaId).colorFor(brightness),
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (_) =>
                            SeasonDetailScreen(seasonIndex: prev.index),
                      ));
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _NavTile(
                    header: l10n.nextSeason,
                    ko: next,
                    color: repo.meta(next.metaId).colorFor(brightness),
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (_) =>
                            SeasonDetailScreen(seasonIndex: next.index),
                      ));
                    },
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

class _FactRow extends StatelessWidget {
  const _FactRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.6),
                  ),
            ),
          ),
          Expanded(
            child: Text(value,
                style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}

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
