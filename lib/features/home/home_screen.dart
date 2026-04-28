import 'package:flutter/material.dart';
import 'package:seasons_72/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/models/season_models.dart';
import '../../core/providers/seasons_providers.dart';
import '../../core/settings/settings_provider.dart';
import '../../core/utils/localized_names.dart';
import '../detail/colors_card.dart';
import '../detail/food_card.dart';
import '../detail/hana_card.dart';
import '../detail/kigo_card.dart';
import '../detail/kodo_card.dart';
import '../detail/kotowaza_card.dart';
import '../detail/practice_card.dart';
import '../detail/tea_card.dart';
import '../shared/widgets/ambient_player.dart';
import '../shared/widgets/moon_phase.dart';
import '../shared/widgets/period_strip.dart';
import '../shared/widgets/season_hero.dart';
import '../shared/widgets/sekki_card.dart';
import '../detail/season_detail_screen.dart';

/// The "Now" screen — shows the currently-active ko with progress bar
/// and a preview of the next one.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final asyncCurrent = ref.watch(currentSeasonProvider);
    final calc = ref.watch(seasonCalculatorProvider);
    final repo = ref.watch(seasonsRepositoryProvider);
    final cards = ref.watch(settingsProvider).cards;

    return asyncCurrent.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text(l10n.errorLoading)),
      data: (current) {
        final next = calc.next(current);
        final meta = repo.meta(current.metaId);
        final brightness = Theme.of(context).brightness;
        final sekki = repo.sekki(current.sekkiId);
        final progress = calc.progress(current);
        final daysLeft = calc.daysUntilNext(current);

        final accent = meta.colorFor(brightness);
        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            // Eyebrow row: caps "ЗАРАЗ ТРИВАЄ" on the left, a tappable
            // moon-phase pill on the right. The moon now lives as a
            // pure ambient-context element in the page header rather
            // than buried in the date row — it's the lunar context of
            // "now", which is what this row already announces.
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    l10n.nowLabel.toUpperCase(),
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                const MoonPhasePill(),
              ],
            ),
            const SizedBox(height: 12),
            // Hero engraving with a floating ambient-sound button in
            // the bottom-right. The whole frame is still tappable to
            // open the detail screen; the play button captures its
            // own taps so it doesn't bubble into navigation.
            GestureDetector(
              onTap: () => _openDetail(context, current.index),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  SeasonHero(ko: current, meta: meta),
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: AmbientPlayerFab(
                      koIndex: current.index,
                      metaId: meta.id,
                      accentColor: accent,
                    ),
                  ),
                  // One-time hint bubble that names the floating
                  // button. Position math: the FAB's inner 48-px
                  // button sits at right:20..68 and bottom:20..68.
                  // Setting right:92 leaves a ~24-px gap from the
                  // button's left edge; bottom:30 puts the bubble's
                  // vertical centre on the button's centre (bottom 44).
                  // IgnorePointer inside the bubble — taps on the FAB
                  // pass through.
                  Positioned(
                    right: 92,
                    bottom: 30,
                    child: const _AmbientHintBubble(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SeasonTitleBlock(
              ko: current,
              locale: locale,
              accentColor: accent,
            ),
            const SizedBox(height: 16),
            Text(
              current.localizedDescription(locale),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            SeasonHaiku(ko: current, accentColor: accent),
            const SizedBox(height: 24),
            // Period strip — single shared format with the Detail
            // screen (📅 dates · кō N з 72). Period was lifted out of
            // the 9-card concept (it didn't fit the cultural-tradition
            // register of the other 8); the strip is its replacement,
            // editorial-light, no card decoration, no modal.
            PeriodStrip(ko: current, locale: locale),
            // Sekki block — the 24-season cultural context. The caps
            // header ("ПІДСЕЗОН СЕККІ") is shown on Home as well as
            // Detail so the row reads consistently with the seven
            // deep-dive cards above; the parallel labelling helps the
            // user understand what each block is.
            if (cards.sekki) ...[
              const SizedBox(height: 16),
              SekkiCard(
                meta: meta,
                sekki: sekki,
                locale: locale,
                accentColor: meta.colorFor(brightness),
              ),
            ],
            // Each deep-dive card is conditional on its own visibility
            // toggle in Settings → Season cards. Each card's leading
            // SizedBox collapses with it.
            if (cards.tea) ...[
              const SizedBox(height: 16),
              TeaCard(koIndex: current.index, locale: locale),
            ],
            if (cards.food) ...[
              const SizedBox(height: 16),
              FoodCard(koIndex: current.index, locale: locale),
            ],
            if (cards.hana) ...[
              const SizedBox(height: 16),
              HanaCard(koIndex: current.index, locale: locale),
            ],
            if (cards.colors) ...[
              const SizedBox(height: 16),
              ColorsCard(koIndex: current.index, locale: locale),
            ],
            if (cards.kodo) ...[
              const SizedBox(height: 16),
              KodoCard(koIndex: current.index, locale: locale),
            ],
            if (cards.kigo) ...[
              const SizedBox(height: 16),
              KigoCard(koIndex: current.index, locale: locale),
            ],
            if (cards.kotowaza) ...[
              const SizedBox(height: 16),
              KotowazaCard(koIndex: current.index, locale: locale),
            ],
            if (cards.practice) ...[
              const SizedBox(height: 16),
              PracticeCard(koIndex: current.index, locale: locale),
            ],
            const SizedBox(height: 24),
            // Progress + countdown merged: a single "where are we in
            // this season?" block. Big number for quick glance, units +
            // absolute date below for context.
            _ProgressBlock(
              progress: progress,
              daysLeft: daysLeft,
              color: meta.colorFor(brightness),
            ),
            const SizedBox(height: 32),
            Text(
              l10n.nextSeason.toUpperCase(),
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            _NextCard(
              next: next,
              onTap: () => _openDetail(context, next.index),
            ),
          ],
        );
      },
    );
  }

  void _openDetail(BuildContext context, int index) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => SeasonDetailScreen(seasonIndex: index),
    ));
  }

}

/// Metadata row — a small accent-color dot followed by the label. Replaces
/// what used to be prominent Material icons: the row now reads like a
/// bullet list from a Japanese editorial layout rather than a UI form.
class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.label, this.accentColor});
  final String label;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final dotColor = (accentColor ?? Theme.of(context).colorScheme.primary)
        .withValues(alpha: 0.8);
    return Row(
      children: [
        Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: dotColor,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}


/// Progress bar + a single understated caption line below.
///
/// Design choice: the absolute date and next-season name already live in
/// the `_NextCard` below, so repeating them here is redundant. We keep
/// only the countdown — the "how far along" part is the progress bar
/// itself, the "when / what next" part is the card.
class _ProgressBlock extends StatelessWidget {
  const _ProgressBlock({
    required this.progress,
    required this.daysLeft,
    required this.color,
  });
  final double progress;
  final int daysLeft;

  /// Foreground accent — fills the bar.
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final onSurface = theme.colorScheme.onSurface;
    final isDark = theme.brightness == Brightness.dark;
    final pct = (progress * 100).round();

    return Semantics(
      container: true,
      label:
          'Прогрес сезону $pct відсотків. ${l10n.daysLeftInSeason(daysLeft)}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thicker, higher-contrast progress bar. 4 px read as a
          // hairline before; 7 px gives the fill enough body to feel
          // like a real "you are X% through" signal. Light-theme
          // backdrop alpha is ×2.5 the dark-theme value so the
          // unfilled portion is a discernible track, not white space.
          ExcludeSemantics(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                minHeight: 7,
                backgroundColor: color.withValues(
                    alpha: isDark ? 0.16 : 0.28),
                valueColor: AlwaysStoppedAnimation<Color>(
                    color.withValues(alpha: 0.95)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          ExcludeSemantics(
            child: Text(
              l10n.daysLeftInSeason(daysLeft),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: onSurface.withValues(alpha: 0.85),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// One-time "Послухати кō" hint bubble shown next to the floating
/// ambient-sound button on the home hero. Disappears once the user
/// has seen it — persisted via [AppSettings.hasSeenAmbientHint].
///
/// Behaviour:
///   • Mounts only when settings have loaded AND the flag is false.
///   • Fades in over 600 ms after a 1 s delay (the hero finishes
///     settling first), holds for 5 s, fades out, then writes the
///     flag so it never reappears.
///   • Doesn't intercept taps — the FAB underneath stays fully
///     responsive while the hint is shown.
class _AmbientHintBubble extends ConsumerStatefulWidget {
  const _AmbientHintBubble();

  @override
  ConsumerState<_AmbientHintBubble> createState() =>
      _AmbientHintBubbleState();
}

class _AmbientHintBubbleState extends ConsumerState<_AmbientHintBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctl;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _ctl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  Future<void> _runOnce() async {
    if (_started) return;
    _started = true;
    await Future.delayed(const Duration(milliseconds: 1100));
    if (!mounted) return;
    await _ctl.forward();
    await Future.delayed(const Duration(milliseconds: 5000));
    if (!mounted) return;
    await _ctl.reverse();
    if (!mounted) return;
    // Persist — never show again on subsequent launches.
    await ref.read(settingsProvider.notifier).setHasSeenAmbientHint(true);
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    if (!settings.isLoaded || settings.hasSeenAmbientHint) {
      return const SizedBox.shrink();
    }
    // Kick off the animation on first visible build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _runOnce();
    });

    final theme = Theme.of(context);
    final isUk = Localizations.localeOf(context).languageCode == 'uk';
    final isDark = theme.brightness == Brightness.dark;

    return IgnorePointer(
      child: FadeTransition(
        opacity: _ctl,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.black.withValues(alpha: 0.78)
                : Colors.white.withValues(alpha: 0.94),
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.10),
              width: 0.6,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.headphones_rounded,
                size: 14,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
              ),
              const SizedBox(width: 6),
              Text(
                isUk ? 'Послухати кō' : 'Listen to this kō',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface
                      .withValues(alpha: 0.92),
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NextCard extends ConsumerWidget {
  const _NextCard({required this.next, required this.onTap});
  final MicroSeason next;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final repo = ref.watch(seasonsRepositoryProvider);
    final meta = repo.meta(next.metaId);
    final df = DateFormat.MMMMd(locale.languageCode);
    final now = DateTime.now();
    final brightness = Theme.of(context).brightness;
    var start = next.startDateForYear(now.year);
    if (start.isBefore(now)) {
      start = next.startDateForYear(now.year + 1);
    }

    final accent = meta.colorFor(brightness);
    return Material(
      // Gentle elevation-like shadow tinted with the next meta-season color
      // — lifts the card off the scaffold so it feels "upcoming", not flat.
      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.4),
      elevation: 0,
      borderRadius: BorderRadius.circular(16),
      shadowColor: accent.withValues(alpha: 0.2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: accent.withValues(alpha: 0.55), width: 1),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: 0.12),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
        child: Row(
          children: [
            SeasonThumbnail(ko: next, color: meta.colorFor(brightness), size: 56),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    next.localizedName(locale),
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.startsOn(df.format(start)),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.6),
                        ),
                  ),
                ],
              ),
            ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
