import 'package:flutter/material.dart';
import 'package:seasons_72/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/models/season_models.dart';
import '../../core/providers/seasons_providers.dart';
import '../../core/utils/localized_names.dart';
import '../detail/season_detail_screen.dart';

/// Full list of all 72 ko, grouped by meta-season.
class SeasonsListScreen extends ConsumerWidget {
  const SeasonsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final seasons = ref.watch(allSeasonsProvider);
    final repo = ref.watch(seasonsRepositoryProvider);
    final currentIndex = ref.watch(currentSeasonProvider).asData?.value.index;
    final brightness = Theme.of(context).brightness;

    // Group by meta
    final Map<String, List<MicroSeason>> grouped = {};
    for (final s in seasons) {
      grouped.putIfAbsent(s.metaId, () => []).add(s);
    }

    final df = DateFormat.MMMMd(locale.languageCode);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          title: Text(l10n.allSeasonsTitle),
        ),
        for (final entry in grouped.entries) ...[
          SliverToBoxAdapter(
            child: _MetaHeader(
              meta: repo.meta(entry.key),
              locale: locale,
            ),
          ),
          SliverList.separated(
            itemCount: entry.value.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final s = entry.value[i];
              final isCurrent = s.index == currentIndex;
              final meta = repo.meta(s.metaId);
              final year = DateTime.now().year;
              return ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                leading: _IndexBadge(
                    number: s.index, color: meta.colorFor(brightness), active: isCurrent),
                title: Text(
                  '${s.kanji}  ${s.localizedName(locale)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight:
                            isCurrent ? FontWeight.w700 : FontWeight.w500,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  '${s.romaji}  ·  ${df.format(s.startDateForYear(year))} – ${df.format(s.endDateForYear(year))}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) =>
                        SeasonDetailScreen(seasonIndex: s.index),
                  ));
                },
              );
            },
          ),
        ],
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }
}

class _MetaHeader extends StatelessWidget {
  const _MetaHeader({required this.meta, required this.locale});
  final MetaSeason meta;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: meta.colorFor(brightness).withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            meta.kanji,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              meta.localizedName(locale),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ],
      ),
    );
  }
}

class _IndexBadge extends StatelessWidget {
  const _IndexBadge({
    required this.number,
    required this.color,
    required this.active,
  });
  final int number;
  final Color color;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? color : color.withValues(alpha: 0.2),
      ),
      child: Text(
        '$number',
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: active ? Colors.white : null,
            ),
      ),
    );
  }
}
