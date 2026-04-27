import 'package:flutter/material.dart';
import 'package:seasons_72/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/data/seasons_repository.dart';
import '../../core/models/season_models.dart';
import '../../core/providers/seasons_providers.dart';
import '../../core/utils/localized_names.dart';
import '../../core/utils/season_calculator.dart';
import '../detail/season_detail_screen.dart';
import '../shared/widgets/dismissible_modal_sheet.dart';

/// Calendar — full picture of the year, shown in two complementary
/// modes the user can switch between via a centred segmented control
/// at the top:
///
///   • **List** (default) — chronological feed of all 72 kō, grouped
///     into the 4 pori roku and 24 fazi (sekki). Strong visual
///     hierarchy: meta band → sekki chip → kō tiles with alternating
///     tint per sekki.
///
///   • **Months** — familiar tiled grid view (Apple-Calendar style).
///     12 mini-month cards with day cells coloured by their kō's
///     meta-season; sekki rhythm is preserved via subtle alternating
///     alpha within each meta band. Today is ringed; tapping a day
///     opens the detail of the kō that owns it.
///
/// Mode is local UI state — no need to persist across app sessions.
/// On mount, both modes scroll to the active position (current kō
/// in list mode, current month in months mode).
class SeasonsListScreen extends ConsumerStatefulWidget {
  const SeasonsListScreen({super.key});

  @override
  ConsumerState<SeasonsListScreen> createState() => _SeasonsListScreenState();
}

enum _CalendarView { list, months }

class _SeasonsListScreenState extends ConsumerState<SeasonsListScreen> {
  _CalendarView _view = _CalendarView.list;

  // Two scroll controllers — one per mode, so switching back to a mode
  // preserves its scroll position.
  final ScrollController _listScroll = ScrollController();
  final ScrollController _monthsScroll = ScrollController();

  /// True when the current scroll position is "near" the active kō /
  /// month — drives the visibility of the floating "today" FAB.
  /// Hides the button when there's nothing to do.
  bool _atCurrent = true;

  /// Attached to the ListTile of the current kō in list mode so we can
  /// fine-tune alignment after the coarse scroll finishes.
  final GlobalKey _currentTileKey = GlobalKey();

  // Estimated heights for the list-mode scroll-to-current calc. Must
  // be revisited if the header / sub-header / tile design changes.
  static const double _sliverAppBarHeight = 110.0; // base + toggle area
  static const double _metaHeaderHeight = 96.0;
  static const double _sekkiSubHeaderHeight = 52.0;
  static const double _listTileHeight = 96.0;

  @override
  void initState() {
    super.initState();
    _listScroll.addListener(_recomputeAtCurrent);
    _monthsScroll.addListener(_recomputeAtCurrent);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 250));
      if (!mounted) return;
      await _animateToCurrent();
      // After the auto-scroll, we are by definition at current.
      if (mounted) setState(() => _atCurrent = true);
    });
  }

  @override
  void dispose() {
    _listScroll
      ..removeListener(_recomputeAtCurrent)
      ..dispose();
    _monthsScroll
      ..removeListener(_recomputeAtCurrent)
      ..dispose();
    super.dispose();
  }

  /// Compares the active scroll controller's offset to the offset
  /// where "current" lives in this view, and toggles [_atCurrent] so
  /// the floating "today" button can fade in/out accordingly.
  void _recomputeAtCurrent() {
    final ctrl = _view == _CalendarView.list ? _listScroll : _monthsScroll;
    if (!ctrl.hasClients) return;
    final target = _currentTargetOffset();
    if (target == null) return;
    final near = (ctrl.offset - target).abs() < 80;
    if (near != _atCurrent) {
      setState(() => _atCurrent = near);
    }
  }

  /// Returns the scroll offset of the active kō / current month for
  /// the current view, or null if data isn't loaded yet.
  double? _currentTargetOffset() {
    final currentIndex =
        ref.read(currentSeasonProvider).asData?.value.index;
    if (currentIndex == null) return null;
    if (_view == _CalendarView.list) {
      final g = (currentIndex - 1) ~/ 18;
      final p = (currentIndex - 1) % 18;
      final sekkiInMeta = p ~/ 3;
      final tileTop = _sliverAppBarHeight +
          g *
              (_metaHeaderHeight +
                  6 * _sekkiSubHeaderHeight +
                  18 * _listTileHeight) +
          _metaHeaderHeight +
          (sekkiInMeta + 1) * _sekkiSubHeaderHeight +
          p * _listTileHeight;
      final viewportHeight = MediaQuery.of(context).size.height;
      final raw = tileTop - viewportHeight / 2 + _listTileHeight / 2;
      return raw < 0 ? 0.0 : raw;
    } else {
      final currentMonthIndex = DateTime.now().month - 1;
      final row = currentMonthIndex ~/ 2;
      return row * _miniMonthFullHeight;
    }
  }

  Future<void> _animateToCurrent() async {
    final currentIndex =
        ref.read(currentSeasonProvider).asData?.value.index;
    if (currentIndex == null) return;

    if (_view == _CalendarView.list) {
      await _animateListToCurrent(currentIndex);
    } else {
      await _animateMonthsToCurrent();
    }
  }

  Future<void> _animateListToCurrent(int currentIndex) async {
    if (!_listScroll.hasClients) return;

    final g = (currentIndex - 1) ~/ 18;
    final p = (currentIndex - 1) % 18;
    final sekkiInMeta = p ~/ 3;

    final tileTop = _sliverAppBarHeight +
        g *
            (_metaHeaderHeight +
                6 * _sekkiSubHeaderHeight +
                18 * _listTileHeight) +
        _metaHeaderHeight +
        (sekkiInMeta + 1) * _sekkiSubHeaderHeight +
        p * _listTileHeight;

    final viewportHeight = MediaQuery.of(context).size.height;
    final raw = tileTop - viewportHeight / 2 + _listTileHeight / 2;
    final target = raw < 0 ? 0.0 : raw;

    await _listScroll.animateTo(
      target,
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeInOutCubic,
    );
  }

  Future<void> _animateMonthsToCurrent() async {
    if (!_monthsScroll.hasClients) return;
    final now = DateTime.now();
    final currentMonthIndex = now.month - 1; // 0..11
    // 2-column layout: each month tile is roughly _miniMonthHeight tall.
    // The current month sits in row floor(currentMonthIndex / 2).
    final row = currentMonthIndex ~/ 2;
    final target = row * _miniMonthFullHeight;
    await _monthsScroll.animateTo(
      target,
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeInOutCubic,
    );
  }

  // Approx height of one mini-month card including its outer margin.
  // Used for the auto-scroll to current month.
  static const double _miniMonthFullHeight = 220.0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final body = _view == _CalendarView.list
        ? _ListView(
            key: const ValueKey('list'),
            scrollController: _listScroll,
            currentTileKey: _currentTileKey,
          )
        : _MonthsView(
            key: const ValueKey('months'),
            scrollController: _monthsScroll,
          );

    return Column(
      children: [
        // Centered title row — same visual rank as a system AppBar.
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
          child: Text(
            l10n.allSeasonsTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
        // Centered segmented toggle — switches between the two modes.
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
          child: _ViewToggle(
            value: _view,
            onChanged: (v) {
              setState(() => _view = v);
              // After the rebuild, scroll the freshly-shown body to its
              // active position so the user lands where they expect.
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _animateToCurrent();
              });
            },
          ),
        ),
        // Cross-fade between list and grid modes so the toggle feels
        // like a deliberate beat, not a hard cut. Stacked with the
        // floating "today" FAB (lower-left) which fades when the
        // user has scrolled away from current.
        Expanded(
          child: Stack(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 320),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                child: body,
              ),
              Positioned(
                left: 16,
                bottom: 24,
                child: AnimatedScale(
                  scale: _atCurrent ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeOutBack,
                  child: AnimatedOpacity(
                    opacity: _atCurrent ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 260),
                    child: _TodayFab(
                      onTap: () async {
                        await _animateToCurrent();
                        if (mounted) setState(() => _atCurrent = true);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Floating circular button that returns the user to the active kō
/// (in list mode) or the current month (in grid mode). Visible only
/// when the user has scrolled away from that position.
///
/// Style: solid accent fill from the current meta-season, soft glow,
/// `Icons.center_focus_strong` glyph. Reads as a deliberate "anchor
/// me back to now" without competing with the grid colours.
class _TodayFab extends ConsumerWidget {
  const _TodayFab({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final repo = ref.watch(seasonsRepositoryProvider);
    final brightness = theme.brightness;
    // Tint with the active meta so the button feels woven into the
    // current colour, not a generic Material accent.
    final accentMeta = ref.watch(currentSeasonProvider).maybeWhen(
          data: (s) => repo.meta(s.metaId),
          orElse: () => repo.allMeta.first,
        );
    final accent = accentMeta.colorFor(brightness);
    final isUk = Localizations.localeOf(context).languageCode == 'uk';

    return Semantics(
      button: true,
      label: isUk ? 'До поточного сезону' : 'Back to today',
      child: Material(
        color: Colors.transparent,
        elevation: 0,
        child: Tooltip(
          message: isUk ? 'До сьогодні' : 'Back to today',
          child: InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: onTap,
            child: Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accent,
                boxShadow: [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.55),
                    blurRadius: 16,
                    spreadRadius: 1,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: theme.colorScheme.surface
                      .withValues(alpha: 0.35),
                  width: 1.4,
                ),
              ),
              child: const Icon(
                Icons.center_focus_strong_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Toggle ───────────────────────────────────────────────────────

/// Two-segment pill that picks between the list and months views.
/// Custom-built (rather than [SegmentedButton]) so it sits cleanly
/// in the app's softer aesthetic — pill-shaped, accent-tinted active
/// segment, no Material elevation.
class _ViewToggle extends StatelessWidget {
  const _ViewToggle({required this.value, required this.onChanged});

  final _CalendarView value;
  final ValueChanged<_CalendarView> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUk = Localizations.localeOf(context).languageCode == 'uk';
    final accent = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    final isDark = theme.brightness == Brightness.dark;
    return Center(
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: onSurface.withValues(alpha: isDark ? 0.10 : 0.07),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: onSurface.withValues(alpha: 0.18),
            width: 0.7,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Segment(
              label: isUk ? 'Список' : 'List',
              icon: Icons.view_list_rounded,
              selected: value == _CalendarView.list,
              onTap: () => onChanged(_CalendarView.list),
              accent: accent,
              onSurface: onSurface,
            ),
            _Segment(
              label: isUk ? 'Місяці' : 'Months',
              icon: Icons.calendar_month_rounded,
              selected: value == _CalendarView.months,
              onTap: () => onChanged(_CalendarView.months),
              accent: accent,
              onSurface: onSurface,
            ),
          ],
        ),
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    required this.accent,
    required this.onSurface,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final Color accent;
  final Color onSurface;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: selected
                ? accent.withValues(alpha: 0.20)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            border: selected
                ? Border.all(color: accent.withValues(alpha: 0.45), width: 0.8)
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 17,
                color: selected ? accent : onSurface.withValues(alpha: 0.65),
              ),
              const SizedBox(width: 7),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color:
                      selected ? accent : onSurface.withValues(alpha: 0.75),
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── List view ────────────────────────────────────────────────────

class _ListView extends ConsumerWidget {
  const _ListView({
    super.key,
    required this.scrollController,
    required this.currentTileKey,
  });

  final ScrollController scrollController;
  final GlobalKey currentTileKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context);
    final seasons = ref.watch(allSeasonsProvider);
    final repo = ref.watch(seasonsRepositoryProvider);
    final currentIndex = ref.watch(currentSeasonProvider).asData?.value.index;
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    final Map<String, List<MicroSeason>> grouped = {};
    for (final s in seasons) {
      grouped.putIfAbsent(s.metaId, () => []).add(s);
    }

    final df = DateFormat.MMMMd(locale.languageCode);

    return CustomScrollView(
      controller: scrollController,
      slivers: [
        for (final entry in grouped.entries) ...[
          SliverToBoxAdapter(
            child: _MetaHeader(
              meta: repo.meta(entry.key),
              locale: locale,
            ),
          ),
          for (int sekkiIdx = 0; sekkiIdx < 6; sekkiIdx++)
            _buildSekkiBlock(
              context: context,
              meta: repo.meta(entry.key),
              sekkiKo: entry.value.sublist(sekkiIdx * 3, sekkiIdx * 3 + 3),
              sekki: repo.sekki(
                  entry.value[sekkiIdx * 3].sekkiId),
              sekkiIdx: sekkiIdx,
              currentIndex: currentIndex,
              locale: locale,
              df: df,
              isDark: isDark,
              brightness: brightness,
            ),
        ],
        // Generous bottom padding so the last kō isn't crushed against
        // the bottom navigation bar — matches the airy spacing of the
        // home screen. 120 px clears both the system tab bar and the
        // home-indicator safe area on every iPhone size.
        const SliverToBoxAdapter(child: SizedBox(height: 140)),
      ],
    );
  }

  Widget _buildSekkiBlock({
    required BuildContext context,
    required MetaSeason meta,
    required List<MicroSeason> sekkiKo,
    required Sekki sekki,
    required int sekkiIdx,
    required int? currentIndex,
    required Locale locale,
    required DateFormat df,
    required bool isDark,
    required Brightness brightness,
  }) {
    final accent = meta.colorFor(brightness);
    final tint = meta.tintColorFor(brightness);
    // Six-step alpha ramp (one per sekki within meta), step 0.06:
    //   • light: 0.05–0.35
    //   • dark:  0.08–0.38
    // Ramp deliberately compressed — earlier 0.13 step produced top
    // stops at 0.73/0.77 alpha that read as "punchy / too bright" on
    // light theme and "too contrasty against the dark surface" on
    // dark theme. Compromise: keep the top end gentle and let the
    // PER-KŌ left-edge stripe (see [_buildSekkiBlock] / kō item
    // builder below) carry the within-sekki position cue. Tile bg
    // tells you "which pora roku / which sekki", stripe tells you
    // "which of the three kō inside this sekki".
    final tileBgAlpha = isDark
        ? 0.08 + sekkiIdx * 0.06
        : 0.05 + sekkiIdx * 0.06;

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: _SekkiSubHeader(
            sekki: sekki,
            locale: locale,
            accent: accent,
            tint: tint,
            isDark: isDark,
          ),
        ),
        SliverList.builder(
          itemCount: sekkiKo.length,
          itemBuilder: (context, i) {
            final s = sekkiKo[i];
            final isCurrent = s.index == currentIndex;
            final isFirstInSekki = i == 0;
            final isLastInSekki = i == sekkiKo.length - 1;
            final year = DateTime.now().year;
            // Per-kō left-edge stripe carries the within-sekki cue.
            // Three kō within one sekki get progressively stronger
            // accent stripes — ko 1 ghostly, ko 3 solid — so the
            // user can tell which of the three they're looking at
            // even when the tile bgs (per-sekki, deliberately gentle)
            // are visually similar. Implemented via the box-decoration
            // BORDER (not a separate Row child) so the natural height
            // of ListTile is preserved — earlier IntrinsicHeight+Row
            // approach was forcing a uniform row height that clipped
            // 2-line subtitles on long-name kō (Sugomori mushito o
            // hiraku, etc).
            final stripeAlpha = [0.30, 0.55, 0.85][i];
            final stripeSide = BorderSide(
              color: accent.withValues(alpha: stripeAlpha),
              width: 4,
            );
            // The three kō under one sekki render as a single visually
            // contained card: 20 px horizontal margin to align with the
            // sekki / meta headers above and below, top corners rounded
            // on the first tile, bottom corners rounded on the last
            // tile. ClipRRect on the outer wrap ensures the InkWell
            // ripple respects the rounded edges instead of overflowing.
            const radius = Radius.circular(12);
            final theme = Theme.of(context);
            final hairlineSide = BorderSide(
              color: theme.colorScheme.onSurface
                  .withValues(alpha: isDark ? 0.18 : 0.16),
              width: 0.5,
            );
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: isFirstInSekki ? radius : Radius.zero,
                  bottom: isLastInSekki ? radius : Radius.zero,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: tint.withValues(alpha: tileBgAlpha),
                    border: isLastInSekki
                        ? Border(left: stripeSide)
                        : Border(left: stripeSide, bottom: hairlineSide),
                  ),
                  child: ListTile(
                    key: isCurrent ? currentTileKey : null,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 4),
                    leading: _IndexBadge(
                        number: s.index,
                        color: accent,
                        active: isCurrent),
                    title: Text(
                      '${s.kanji}  ${s.localizedName(locale)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight:
                                isCurrent ? FontWeight.w700 : FontWeight.w500,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      '${s.romaji}  ·  ${df.format(s.startDateForYear(year))} – ${df.format(s.endDateForYear(year))}',
                      style: theme.textTheme.bodyMedium,
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) =>
                            SeasonDetailScreen(seasonIndex: s.index),
                      ));
                    },
                  ),
                ),
              ),
            );
          },
        ),
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
    final isDark = brightness == Brightness.dark;
    final tint = meta.tintColorFor(brightness);
    final accent = meta.colorFor(brightness);
    return Container(
      // Vertical-rhythm calibration. Hierarchy of gaps is now:
      //   • pora → first sekki      = 6 + 14 = 20
      //   • sekki → first kō        = 10 + 0 = 10
      //   • last kō → next sekki    = 0 + 14 = 14
      //   • last kō → next pora     = 0 + 28 = 28
      // Geometric-ish steps (28 / 20 / 14 / 10) so the depth of the
      // taxonomy is reflected in the spacing — bigger break for the
      // bigger transition. Previously sekki→kō was only 4 px, which
      // made sekki "stick" to its kō and read as one inseparable
      // chunk; the bumps below restore breathing.
      margin: const EdgeInsets.fromLTRB(20, 28, 20, 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: tint.withValues(alpha: isDark ? 0.25 : 0.20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: accent.withValues(alpha: isDark ? 0.0 : 0.30),
          width: isDark ? 0 : 0.8,
        ),
      ),
      child: Row(
        children: [
          Text(
            meta.kanji,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              meta.localizedName(locale),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SekkiSubHeader extends StatelessWidget {
  const _SekkiSubHeader({
    required this.sekki,
    required this.locale,
    required this.accent,
    required this.tint,
    required this.isDark,
  });
  final Sekki sekki;
  final Locale locale;
  final Color accent;
  final Color tint;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUk = locale.languageCode == 'uk';
    // For the kanji glyph in light theme, use the deeper tint —
    // pastel pink on white doesn't read at 18 px font.
    final kanjiColor = isDark ? accent : tint;
    return Container(
      // 14 top + 10 bottom — pairs with [_MetaHeader]'s 6 px bottom
      // and the kō-tile's lack of top margin to produce the
      // 28 / 20 / 14 / 10 vertical-rhythm hierarchy described there.
      margin: const EdgeInsets.fromLTRB(20, 14, 20, 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: tint.withValues(alpha: isDark ? 0.13 : 0.10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: tint.withValues(alpha: isDark ? 0.30 : 0.32),
          width: 0.7,
        ),
      ),
      child: Row(
        children: [
          Text(
            sekki.kanji,
            style: theme.textTheme.titleMedium?.copyWith(
              color: kanjiColor,
              fontWeight: FontWeight.w700,
              height: 1.0,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              isUk ? sekki.nameUk : sekki.nameEn,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            sekki.romaji,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface
                  .withValues(alpha: isDark ? 0.55 : 0.65),
              fontWeight: FontWeight.w500,
              letterSpacing: 0.4,
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

  /// Foreground accent (meta.colorFor) — used to fill the badge when
  /// it represents the active kō.
  final Color color;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final inactiveBg = color.withValues(alpha: isDark ? 0.22 : 0.18);
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // Active kō: solid accent fill + soft outer glow so the row
        // reads as "you are here" at a glance, not just "another
        // tinted tile". Inactive kō: low-alpha tint with a hairline
        // accent border for definition on light surface.
        color: active ? color : inactiveBg,
        border: active
            ? Border.all(
                color: theme.colorScheme.surface
                    .withValues(alpha: isDark ? 0.20 : 0.45),
                width: 1.5,
              )
            : Border.all(
                color: color.withValues(alpha: isDark ? 0 : 0.55),
                width: isDark ? 0 : 0.8,
              ),
        boxShadow: active
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.55),
                  blurRadius: 12,
                  spreadRadius: 1.5,
                ),
              ]
            : null,
      ),
      child: Text(
        '$number',
        style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: active
                  ? Colors.white
                  : theme.colorScheme.onSurface.withValues(alpha: 0.95),
            ),
      ),
    );
  }
}

// ─── Months (grid) view ──────────────────────────────────────────

/// Familiar 12-mini-months tiled calendar. Two columns × six rows of
/// month cards. Day cells are tinted by the kō active that day, with
/// the same alternating-alpha rhythm the list view uses for sekki —
/// so the user reads the same calendar in two visual languages.
///
/// A small color legend strip sits above the grid to teach the user
/// what the four base hues mean (spring / summer / autumn / winter).
class _MonthsView extends ConsumerWidget {
  const _MonthsView({super.key, required this.scrollController});
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(seasonsRepositoryProvider);
    final calc = ref.watch(seasonCalculatorProvider);
    final year = DateTime.now().year;
    final locale = Localizations.localeOf(context);
    final brightness = Theme.of(context).brightness;

    // Current kō + sekki at this moment — drives the "today" banner.
    final today = DateTime.now();
    final todayKo = calc.currentAt(today);
    final todaySekki = repo.sekki(todayKo.sekkiId);
    final todayMeta = repo.meta(todayKo.metaId);

    return CustomScrollView(
      controller: scrollController,
      slivers: [
        // Active position banner — explicit "you are here" context so
        // the colour grid below has a name attached. Without this the
        // user sees pretty pastel blocks but doesn't know which one
        // they're in. Tap → opens current kō detail.
        SliverToBoxAdapter(
          child: _NowBanner(
            ko: todayKo,
            sekki: todaySekki,
            meta: todayMeta,
            locale: locale,
            brightness: brightness,
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) =>
                    SeasonDetailScreen(seasonIndex: todayKo.index),
              ));
            },
          ),
        ),
        // Color legend — explains the four meta-season hues. Sits
        // once at the top so the eye learns the mapping; doesn't
        // repeat on every month tile.
        SliverToBoxAdapter(
          child: _LegendStrip(
            metas: repo.allMeta,
            locale: locale,
            brightness: brightness,
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 140),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              // Taller than wide — leaves room under the day grid for
              // the per-month sekki legend without cramping cells.
              childAspectRatio: 0.62,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, monthIdx) => _MiniMonth(
                year: year,
                month: monthIdx + 1,
                calc: calc,
                repo: repo,
              ),
              childCount: 12,
            ),
          ),
        ),
      ],
    );
  }
}

/// "Зараз триває" banner above the months grid — turns the sea of
/// pastel blocks into a named position. Reads as a tappable card
/// that tells you which kō and which sekki own today's colour, then
/// jumps to the kō's detail when you tap it.
class _NowBanner extends StatelessWidget {
  const _NowBanner({
    required this.ko,
    required this.sekki,
    required this.meta,
    required this.locale,
    required this.brightness,
    required this.onTap,
  });

  final MicroSeason ko;
  final Sekki sekki;
  final MetaSeason meta;
  final Locale locale;
  final Brightness brightness;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = brightness == Brightness.dark;
    final isUk = locale.languageCode == 'uk';
    final tint = meta.tintColorFor(brightness);
    final accent = meta.colorFor(brightness);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Material(
        color: tint.withValues(alpha: isDark ? 0.18 : 0.14),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: accent.withValues(alpha: isDark ? 0.40 : 0.40),
                width: 0.7,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      isUk ? 'ЗАРАЗ ТРИВАЄ' : 'UNFOLDING NOW',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.6,
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.70),
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.chevron_right,
                        size: 18,
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.55)),
                  ],
                ),
                const SizedBox(height: 6),
                // kō line — primary identification.
                Text(
                  '${ko.kanji}  ${ko.localizedName(locale)}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 3),
                // Sekki line — wider context, dimmer.
                Text(
                  '${sekki.kanji}  ${isUk ? sekki.nameUk : sekki.nameEn}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface
                        .withValues(alpha: 0.72),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Compact legend row — four pill-chips, one per pora roku. Tap is
/// non-interactive (decoration only). Used at the top of the months
/// view so the colour vocabulary of the grid is taught in one place.
class _LegendStrip extends StatelessWidget {
  const _LegendStrip({
    required this.metas,
    required this.locale,
    required this.brightness,
  });
  final List<MetaSeason> metas;
  final Locale locale;
  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        alignment: WrapAlignment.center,
        children: [
          for (final m in metas)
            _LegendChip(meta: m, locale: locale, isDark: isDark),
        ],
      ),
    );
  }
}

class _LegendChip extends StatelessWidget {
  const _LegendChip({
    required this.meta,
    required this.locale,
    required this.isDark,
  });
  final MetaSeason meta;
  final Locale locale;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final tint = meta.tintColorFor(brightness);
    final accent = meta.colorFor(brightness);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: tint.withValues(alpha: isDark ? 0.22 : 0.16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: tint.withValues(alpha: isDark ? 0.50 : 0.40),
          width: 0.7,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            meta.kanji,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark ? accent : tint,
              height: 1.0,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            meta.localizedName(locale),
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface
                  .withValues(alpha: 0.92),
              height: 1.0,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

/// A single month card in the grid view. Header with month name,
/// then a 7-column day grid where each day is tinted by its kō's
/// meta-season. Today gets an accent ring.
class _MiniMonth extends StatelessWidget {
  const _MiniMonth({
    required this.year,
    required this.month,
    required this.calc,
    required this.repo,
  });

  final int year;
  final int month;
  final SeasonCalculator calc;
  final SeasonsRepository repo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final isDark = brightness == Brightness.dark;
    final locale = Localizations.localeOf(context);
    final monthFmt = DateFormat.MMMM(locale.languageCode);

    final firstDay = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    // Monday-start week: weekday 1=Mon..7=Sun, leading blanks 0..6.
    final leading = (firstDay.weekday - 1) % 7;
    final today = DateTime.now();
    final isCurrentMonth =
        today.year == year && today.month == month;

    return Container(
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.colorScheme.onSurface
              .withValues(alpha: isCurrentMonth ? 0.18 : 0.08),
          width: isCurrentMonth ? 0.8 : 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(2, 0, 2, 6),
            child: Text(
              _capitalise(monthFmt.format(firstDay)),
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: isCurrentMonth
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.85),
                letterSpacing: 0.3,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Day-of-week row.
          _WeekdayHeader(locale: locale),
          const SizedBox(height: 2),
          // Day grid — 6 weeks × 7 days, with leading/trailing blanks.
          // Wrapped in AspectRatio 7:6 so the cells stay square; the
          // remaining vertical space below it is reserved for the
          // sekki legend, which names each colour band in this month.
          AspectRatio(
            aspectRatio: 7 / 6,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 1.5,
                crossAxisSpacing: 1.5,
                childAspectRatio: 1.0,
              ),
              itemCount: 42,
              itemBuilder: (context, i) {
                final dayNum = i - leading + 1;
                if (dayNum < 1 || dayNum > daysInMonth) {
                  return const SizedBox.shrink();
                }
                final date = DateTime(year, month, dayNum);
                final ko = calc.currentAt(date);
                final meta = repo.meta(ko.metaId);
                final accent = meta.colorFor(brightness);
                final tint = meta.tintColorFor(brightness);
                final sekkiInMeta = ((ko.index - 1) % 18) ~/ 3;
                // Six-step alpha ramp, step 0.08 (light: 0.05–0.45,
                // dark: 0.08–0.48). Months-grid cells are tiny (~30px
                // square) so they need MORE alpha differentiation than
                // the list view tiles — at the list's gentler 0.06
                // step the day cells smeared into one band again.
                // List view compensates with its left-edge stripe;
                // months grid relies on tile bg alone, so the ramp
                // here is widened. Sekki-legend swatch below MUST
                // match this exactly.
                final tileAlpha = isDark
                    ? 0.08 + sekkiInMeta * 0.08
                    : 0.05 + sekkiInMeta * 0.08;
                final isToday = date.year == today.year &&
                    date.month == today.month &&
                    date.day == today.day;

                return _DayCell(
                  day: dayNum,
                  bg: tint.withValues(alpha: tileAlpha),
                  ring: isToday ? accent : null,
                  textColor: theme.colorScheme.onSurface,
                  onTap: () {
                    _showDayPreview(
                      context: context,
                      date: date,
                      ko: ko,
                      sekki: repo.sekki(ko.sekkiId),
                      meta: meta,
                      locale: Localizations.localeOf(context),
                      brightness: brightness,
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          // Sekki legend — names the colour bands present in this
          // month. Each row pairs a small swatch (matching the day-
          // cell tint exactly) with the sekki kanji + localised name.
          // This is what turns the abstract pastel grid into a
          // readable calendar of named phases.
          _SekkiLegend(
            year: year,
            month: month,
            daysInMonth: daysInMonth,
            calc: calc,
            repo: repo,
            locale: locale,
            brightness: brightness,
          ),
        ],
      ),
    );
  }

  /// Capitalise the first letter — DateFormat.MMMM returns lowercased
  /// month names in some locales (e.g., Ukrainian "січня"); we want
  /// "Січень" at the top of a month card.
  String _capitalise(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}

/// Per-month sekki legend — the colour key for what the user sees
/// in the day grid above. Walks through every day of the month, asks
/// the calculator which kō (and therefore which sekki) it belongs to,
/// and emits one row per unique sekki in calendar order.
///
/// Each row is a swatch + sekki kanji + localised name. The swatch
/// uses the SAME tint and alpha that day cells in this sekki carry,
/// so the user can match a colour band in the grid to its name in
/// the legend at a glance.
class _SekkiLegend extends StatelessWidget {
  const _SekkiLegend({
    required this.year,
    required this.month,
    required this.daysInMonth,
    required this.calc,
    required this.repo,
    required this.locale,
    required this.brightness,
  });

  final int year;
  final int month;
  final int daysInMonth;
  final SeasonCalculator calc;
  final SeasonsRepository repo;
  final Locale locale;
  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = brightness == Brightness.dark;
    final isUk = locale.languageCode == 'uk';

    // Walk days in calendar order, dedupe by sekki id, remember the
    // tint colour each day generated so the swatch matches the cell.
    final orderedSekki = <Sekki>[];
    final seenIds = <String>{};
    final sekkiSwatch = <String, Color>{};

    for (int day = 1; day <= daysInMonth; day++) {
      final ko = calc.currentAt(DateTime(year, month, day));
      if (!seenIds.add(ko.sekkiId)) continue;
      final sekki = repo.sekki(ko.sekkiId);
      orderedSekki.add(sekki);
      final meta = repo.meta(ko.metaId);
      final tint = meta.tintColorFor(brightness);
      final sekkiInMeta = ((ko.index - 1) % 18) ~/ 3;
      // Same six-step alpha ramp (step 0.08) as day cells — the
      // legend swatch must visually equal the cells it is naming.
      final alpha = isDark
          ? 0.08 + sekkiInMeta * 0.08
          : 0.05 + sekkiInMeta * 0.08;
      sekkiSwatch[sekki.id] = tint.withValues(alpha: alpha);
    }

    if (orderedSekki.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final s in orderedSekki)
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: sekkiSwatch[s.id],
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.10),
                      width: 0.5,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: s.kanji,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.90),
                            height: 1.1,
                          ),
                        ),
                        TextSpan(text: '  '),
                        TextSpan(
                          text: isUk ? s.nameUk : s.nameEn,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.78),
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Two-letter weekday header row (Пн Вт Ср ...). Sunday is dimmed
/// slightly to mark week breaks at a glance — common pattern in
/// printed calendars.
class _WeekdayHeader extends StatelessWidget {
  const _WeekdayHeader({required this.locale});
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUk = locale.languageCode == 'uk';
    // Hand-rolled 2-letter labels — intl's narrow forms collide
    // (Понеділок / П'ятниця both start with П in single-letter form).
    final labels = isUk
        ? const ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Нд']
        : const ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: Row(
        children: [
          for (int i = 0; i < 7; i++)
            Expanded(
              child: Center(
                child: Text(
                  labels[i],
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface.withValues(
                        alpha: i >= 5 ? 0.45 : 0.62),
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Modal bottom sheet shown when the user taps a day in the months
/// grid. Names the colour they tapped — date, the kō and sekki it
/// belongs to — and offers a CTA to open the full kō detail screen.
///
/// This is the answer to "не вистачає пояснень, де який секкі і де
/// який кō": the grid is glanceable, but the user can always tap
/// any cell to learn what it represents without leaving context.
void _showDayPreview({
  required BuildContext context,
  required DateTime date,
  required MicroSeason ko,
  required Sekki sekki,
  required MetaSeason meta,
  required Locale locale,
  required Brightness brightness,
}) {
  final isUk = locale.languageCode == 'uk';
  final tint = meta.tintColorFor(brightness);
  final accent = meta.colorFor(brightness);
  final df = DateFormat.yMMMMd(locale.languageCode);
  final isDark = brightness == Brightness.dark;

  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (ctx) {
      final theme = Theme.of(ctx);
      return DismissibleModalSheet(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date headline.
            Text(
              df.format(date),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            // Pora roku chip.
            _PreviewRow(
              caps: isUk ? 'ПОРА РОКУ' : 'SEASON OF THE YEAR',
              kanji: meta.kanji,
              name: meta.localizedName(locale),
              tint: tint,
              accent: accent,
              isDark: isDark,
            ),
            const SizedBox(height: 8),
            _PreviewRow(
              caps: isUk ? 'ФАЗА · СЕККІ' : 'PHASE · SEKKI',
              kanji: sekki.kanji,
              name: isUk ? sekki.nameUk : sekki.nameEn,
              tint: tint,
              accent: accent,
              isDark: isDark,
            ),
            const SizedBox(height: 8),
            _PreviewRow(
              caps: isUk ? 'СЕЗОН · КŌ' : 'SEASON · KŌ',
              kanji: ko.kanji,
              name: ko.localizedName(locale),
              tint: tint,
              accent: accent,
              isDark: isDark,
            ),
            const SizedBox(height: 18),
            // CTA — opens the full detail screen for the kō.
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonalIcon(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) =>
                        SeasonDetailScreen(seasonIndex: ko.index),
                  ));
                },
                icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                label: Text(isUk ? 'Відкрити сезон' : 'Open season'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

/// One row inside the day-preview sheet — caps eyebrow + kanji +
/// localised name, all on a softly tinted card matching the kō's
/// meta accent.
class _PreviewRow extends StatelessWidget {
  const _PreviewRow({
    required this.caps,
    required this.kanji,
    required this.name,
    required this.tint,
    required this.accent,
    required this.isDark,
  });
  final String caps;
  final String kanji;
  final String name;
  final Color tint;
  final Color accent;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: tint.withValues(alpha: isDark ? 0.13 : 0.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: accent.withValues(alpha: isDark ? 0.30 : 0.30),
          width: 0.7,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            caps,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                kanji,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  height: 1.0,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// One day inside a [_MiniMonth]. Tinted background = which kō it
/// belongs to (alpha varies by sekki for rhythm). The optional [ring]
/// draws an accent border around today.
class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.bg,
    required this.ring,
    required this.textColor,
    required this.onTap,
  });

  final int day;
  final Color bg;
  final Color? ring;
  final Color textColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(4),
          border: ring != null
              ? Border.all(color: ring!, width: 1.4)
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          '$day',
          style: TextStyle(
            fontSize: 10,
            fontWeight:
                ring != null ? FontWeight.w800 : FontWeight.w500,
            color: ring != null
                ? ring
                : textColor.withValues(alpha: 0.85),
            height: 1.0,
          ),
        ),
      ),
    );
  }
}
