import 'package:flutter/material.dart';
import 'package:seasons_72/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/models/season_models.dart';
import '../../core/providers/seasons_providers.dart';
import '../../core/utils/localized_names.dart';
import '../detail/season_detail_screen.dart';

/// Full list of all 72 ko, grouped by meta-season.
///
/// When the screen mounts, it visibly scrolls to the current kō so the
/// user sees where they are. The scroll is a deliberate ~1.2-second
/// animation starting ~250ms after first paint — long enough for the
/// user to register both "I landed at the top" and "…and the list is
/// taking me to where I am now." Remount (via a fresh [Key] from
/// AppShell) re-runs this animation.
class SeasonsListScreen extends ConsumerStatefulWidget {
  const SeasonsListScreen({super.key});

  @override
  ConsumerState<SeasonsListScreen> createState() => _SeasonsListScreenState();
}

class _SeasonsListScreenState extends ConsumerState<SeasonsListScreen> {
  final ScrollController _scrollController = ScrollController();

  /// Attached to the ListTile of the current kō so we can fine-tune
  /// alignment after the coarse scroll finishes.
  final GlobalKey _currentTileKey = GlobalKey();

  /// Estimated pixel heights used to compute a scroll offset for the
  /// current kō before lazy-building the list. Measured empirically
  /// against the current layout (slightly generous on purpose — better
  /// to overshoot a few pixels than to leave the target off-screen).
  /// Must be revisited if the header or ListTile design changes
  /// materially.
  static const double _sliverAppBarHeight = 56.0;
  static const double _metaHeaderHeight = 96.0;
  static const double _listTileHeight = 96.0; // 2-line content + divider

  @override
  void initState() {
    super.initState();
    // Two-phase: (1) brief pause so the user registers the list opening
    // from the top, (2) animated scroll they can follow with their eyes,
    // (3) final ensureVisible to pixel-align once the target tile is
    // materialized.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 250));
      if (!mounted) return;
      await _animateToCurrent();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _animateToCurrent() async {
    final currentIndex =
        ref.read(currentSeasonProvider).asData?.value.index;
    if (currentIndex == null) return;
    if (!_scrollController.hasClients) return;

    // Each meta group holds exactly 18 kō (72 / 4). The target is in
    // group `g` at position `p` within it.
    final g = (currentIndex - 1) ~/ 18;
    final p = (currentIndex - 1) % 18;

    // Pixel position of the top of the current tile inside the
    // scroll view: app-bar + (g+1) meta headers + (18*g + p) tiles
    // before it.
    final tileTop = _sliverAppBarHeight +
        _metaHeaderHeight * (g + 1) +
        _listTileHeight * (18 * g + p);

    // Center the tile vertically in the viewport.
    final viewportHeight = MediaQuery.of(context).size.height;
    final raw =
        tileTop - viewportHeight / 2 + _listTileHeight / 2;
    // Don't clamp the upper bound — lazy-built slivers grow
    // maxScrollExtent on demand. Only guard against negatives.
    final target = raw < 0 ? 0.0 : raw;

    // One long, uninterrupted animation. Earlier we chained an
    // `ensureVisible` call after the main scroll for pixel-perfect
    // alignment, but the second movement felt like a hiccup mid-flow.
    // Trusting the offset estimate keeps it cinematic.
    await _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final seasons = ref.watch(allSeasonsProvider);
    final repo = ref.watch(seasonsRepositoryProvider);
    final currentIndex = ref.watch(currentSeasonProvider).asData?.value.index;
    final brightness = Theme.of(context).brightness;

    // Preserve declared order of meta-seasons (spring → summer → autumn
    // → winter). Dart keeps insertion order on LinkedHashMap so this
    // matches the JSON.
    final Map<String, List<MicroSeason>> grouped = {};
    for (final s in seasons) {
      grouped.putIfAbsent(s.metaId, () => []).add(s);
    }

    final df = DateFormat.MMMMd(locale.languageCode);

    return CustomScrollView(
      controller: _scrollController,
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
                key: isCurrent ? _currentTileKey : null,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                leading: _IndexBadge(
                    number: s.index,
                    color: meta.colorFor(brightness),
                    active: isCurrent),
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
                    builder: (_) => SeasonDetailScreen(seasonIndex: s.index),
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
