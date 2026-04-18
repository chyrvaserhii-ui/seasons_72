import 'package:flutter/material.dart';
import 'package:seasons_72/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/models/season_models.dart';
import '../../core/providers/seasons_providers.dart';
import '../../core/utils/localized_names.dart';
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
            _MetaRow(
              label: _formatDateRange(current, locale),
              accentColor: meta.colorFor(brightness),
            ),
            const SizedBox(height: 8),
            _MetaRow(
              label:
                  '${meta.localizedName(locale)} · ${sekki.localizedName(locale)} (${sekki.kanji})',
              accentColor: meta.colorFor(brightness),
            ),
            const SizedBox(height: 24),
            _ProgressBar(progress: progress, color: meta.colorFor(brightness)),
            const SizedBox(height: 8),
            Text(
              l10n.daysUntilNext(daysLeft),
              style: Theme.of(context).textTheme.bodyMedium,
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

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.progress, required this.color});
  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    // Slimmer track for a refined feel. Rounded endcaps keep it gentle.
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: LinearProgressIndicator(
        value: progress.clamp(0.0, 1.0),
        minHeight: 4,
        backgroundColor: color.withValues(alpha: 0.12),
        valueColor: AlwaysStoppedAnimation<Color>(color.withValues(alpha: 0.85)),
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
