import 'package:flutter/material.dart';
import 'package:seasons_72/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/models/season_models.dart';
import '../../core/providers/seasons_providers.dart';
import '../../core/utils/localized_names.dart';
import '../about/sekki_descriptions.dart';
import '../shared/widgets/ambient_player.dart';
import '../shared/widgets/moon_phase.dart';
import '../shared/widgets/season_hero.dart';
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

        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            Text(
              l10n.nowLabel.toUpperCase(),
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => _openDetail(context, current.index),
              child: SeasonHero(ko: current, meta: meta),
            ),
            const SizedBox(height: 20),
            SeasonTitleBlock(
              ko: current,
              locale: locale,
              accentColor: meta.colorFor(brightness),
            ),
            const SizedBox(height: 16),
            Text(
              current.localizedDescription(locale),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            SeasonHaiku(ko: current, accentColor: meta.colorFor(brightness)),
            const SizedBox(height: 24),
            // Date range + moon glyph on the same line. Moon sits
            // right next to the date (not pushed to the right edge)
            // so they read as one time-anchored group.
            _DateWithMoon(
              label: _formatDateRange(current, locale),
              accentColor: meta.colorFor(brightness),
              metaId: meta.id,
              koIndex: current.index,
            ),
            const SizedBox(height: 12),
            // Sekki block — the 24-season cultural context, distinct
            // from metadata. Given its own card-like treatment so it
            // doesn't read as just another metadata row.
            _SekkiCard(
              meta: meta,
              sekki: sekki,
              locale: locale,
              accentColor: meta.colorFor(brightness),
            ),
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

  String _formatDateRange(dynamic current, Locale locale) {
    final df = DateFormat.MMMMd(locale.languageCode);
    final now = DateTime.now();
    final start = current.startDateForYear(now.year) as DateTime;
    final end = current.endDateForYear(now.year) as DateTime;
    return '${df.format(start)} – ${df.format(end)}';
  }
}

/// Dot + date label + moon glyph, all in one row. Uses `Wrap`-style
/// packing (Row with `mainAxisSize.min` children) so the moon sits
/// immediately after the date instead of being pushed to the right
/// edge by a Spacer.
class _DateWithMoon extends StatelessWidget {
  const _DateWithMoon({
    required this.label,
    required this.accentColor,
    required this.metaId,
    required this.koIndex,
  });
  final String label;
  final Color accentColor;

  /// Used by the ambient-audio toggle to pick the matching loop.
  final String metaId;

  /// Current kō index — lets the audio service prefer a kō-specific
  /// clip (frogs for #19, cicadas for #38) over the meta default.
  final int koIndex;

  @override
  Widget build(BuildContext context) {
    final dotColor = accentColor.withValues(alpha: 0.8);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
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
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        AmbientPlayerButton(
          koIndex: koIndex,
          metaId: metaId,
          accentColor: accentColor,
        ),
        const MoonPhaseIndicator(size: 22),
      ],
    );
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

/// Sekki (24-season) cultural context, presented as a discreet card
/// rather than a metadata list item. Tappable: opens a bottom sheet
/// with the editorial explanation of the current sekki.
class _SekkiCard extends StatelessWidget {
  const _SekkiCard({
    required this.meta,
    required this.sekki,
    required this.locale,
    required this.accentColor,
  });
  final MetaSeason meta;
  final Sekki sekki;
  final Locale locale;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    return Material(
      color: accentColor.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => _showSekkiSheet(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              Text(
                sekki.kanji,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sekki.localizedName(locale),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      meta.localizedName(locale),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: onSurface.withValues(alpha: 0.70),
                      ),
                    ),
                  ],
                ),
              ),
              // Subtle "tap me" cue — info icon, decorative only.
              Icon(
                Icons.info_outline,
                size: 18,
                color: onSurface.withValues(alpha: 0.45),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSekkiSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => _SekkiDetailsSheet(
        sekki: sekki,
        meta: meta,
        locale: locale,
        accentColor: accentColor,
      ),
    );
  }
}

/// Bottom sheet with kanji, localized name, romaji, and editorial
/// explanation of the sekki. Mirrors the `MoonPhase` sheet pattern.
class _SekkiDetailsSheet extends StatelessWidget {
  const _SekkiDetailsSheet({
    required this.sekki,
    required this.meta,
    required this.locale,
    required this.accentColor,
  });
  final Sekki sekki;
  final MetaSeason meta;
  final Locale locale;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final desc = sekkiDescriptionFor(sekki.id);
    final descText = desc == null
        ? ''
        : (locale.languageCode == 'uk' ? desc.uk : desc.en);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tiny meta-season cap above the kanji (matches the
            // editorial micro-header style used elsewhere).
            Text(
              meta.localizedName(locale).toUpperCase(),
              style: theme.textTheme.labelLarge?.copyWith(
                letterSpacing: 1.8,
                color: onSurface.withValues(alpha: 0.55),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              sekki.kanji,
              style: theme.textTheme.displayMedium?.copyWith(
                fontSize: 56,
                color: accentColor.withValues(alpha: 0.92),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              sekki.localizedName(locale),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              sekki.romaji,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: onSurface.withValues(alpha: 0.55),
              ),
            ),
            const SizedBox(height: 22),
            // Thin accent rule, like the haiku frame
            Container(
              width: 60,
              height: 1,
              color: accentColor.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 22),
            Text(
              descText,
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.55),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
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
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final onSurface = theme.colorScheme.onSurface;
    final pct = (progress * 100).round();

    return Semantics(
      container: true,
      label:
          'Прогрес сезону $pct відсотків. ${l10n.daysLeftInSeason(daysLeft)}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExcludeSemantics(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                minHeight: 4,
                backgroundColor: color.withValues(alpha: 0.12),
                valueColor: AlwaysStoppedAnimation<Color>(
                    color.withValues(alpha: 0.85)),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ExcludeSemantics(
            child: Text(
              l10n.daysLeftInSeason(daysLeft),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: onSurface.withValues(alpha: 0.70),
              ),
            ),
          ),
        ],
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
