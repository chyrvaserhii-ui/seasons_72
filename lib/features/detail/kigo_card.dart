import 'package:flutter/material.dart';

import '../about/seasonal_kigo.dart';
import '../shared/widgets/dismissible_modal_sheet.dart';

/// Kigo (季語) — saijiki seasonal words tied to the current kō. The
/// row card surfaces the count of words and the lead entry; the bottom
/// sheet shows the full collection of 3–5 words with kanji / romaji /
/// gloss / literary note for each, plus an overarching summary that
/// frames what mood a haiku written *now* would carry.
///
/// Indigo accent — the colour of brush ink on a saijiki page.
class KigoCard extends StatelessWidget {
  const KigoCard({
    super.key,
    required this.koIndex,
    required this.locale,
  });

  final int koIndex;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    final pairing = kigoForKo(koIndex);
    if (pairing == null || pairing.entries.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final isUk = locale.languageCode == 'uk';
    final onSurface = theme.colorScheme.onSurface;
    final isDark = theme.brightness == Brightness.dark;

    // Indigo — saijiki ink. Distinct from any other card accent.
    const indigo = Color(0xFF3E5C8A);

    final count = pairing.entries.length;
    // Build a teaser of all kanji separated by middots so the row reads
    // as a list of seasonal words, not a single mysterious term.
    // E.g. "苗 · 田植 · 春田 · 苗代".
    final kanjiTeaser = pairing.entries.map((e) => e.japanese).join(' · ');
    // Plain-language headline tells the reader what this row IS — a
    // count of saijiki words paired to this kō.
    final headline = isUk
        ? (count == 1
            ? '1 сезонне слово'
            : (count >= 2 && count <= 4
                ? '$count сезонні слова'
                : '$count сезонних слів'))
        : (count == 1 ? '1 seasonal word' : '$count seasonal words');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isUk ? 'СЕЗОННІ СЛОВА' : 'SEASONAL WORDS',
          style: theme.textTheme.labelLarge?.copyWith(
            color: onSurface.withValues(alpha: 0.75),
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => _showSheet(context, pairing, isUk, indigo),
              child: Container(
                decoration: BoxDecoration(
                  color: indigo.withValues(alpha: isDark ? 0.14 : 0.16),
                  border: Border(
                    left: BorderSide(
                      color: indigo.withValues(alpha: 0.70),
                      width: 3,
                    ),
                    bottom: BorderSide(
                      color: indigo.withValues(alpha: 0.18),
                      width: 0.5,
                    ),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '📜',
                      style: TextStyle(
                        fontSize: 20,
                        color: indigo.withValues(alpha: 0.92),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Plain-language headline so the row reads as a
                          // count first ("4 сезонні слова"), not as a single
                          // mysterious term sitting alone.
                          Text(
                            headline,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          // Subtitle: kanji of every kigo separated by
                          // middots — visually shows this is a list.
                          Text(
                            kanjiTeaser,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: onSurface.withValues(alpha: 0.7),
                              letterSpacing: 0.6,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.info_outline,
                      size: 18,
                      color: onSurface.withValues(alpha: 0.45),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showSheet(
      BuildContext context, KigoPairing pairing, bool isUk, Color accent) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) =>
          _KigoDetailsSheet(pairing: pairing, isUk: isUk, accent: accent),
    );
  }
}

class _KigoDetailsSheet extends StatelessWidget {
  const _KigoDetailsSheet({
    required this.pairing,
    required this.isUk,
    required this.accent,
  });

  final KigoPairing pairing;
  final bool isUk;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return DismissibleModalSheet(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
              Center(
                child: Text(
                  isUk ? 'СЕЗОННІ СЛОВА' : 'SEASONAL WORDS',
                  style: theme.textTheme.labelLarge?.copyWith(
                    letterSpacing: 1.8,
                    color: onSurface.withValues(alpha: 0.55),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  '季語',
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontSize: 44,
                    color: accent.withValues(alpha: 0.92),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  'kigo',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: onSurface.withValues(alpha: 0.55),
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Center(
                child: Container(
                  width: 60,
                  height: 1,
                  color: accent.withValues(alpha: 0.4),
                ),
              ),
              const SizedBox(height: 18),
              // Summary — what mood these words collectively summon.
              Text(
                isUk ? pairing.summaryUk : pairing.summaryEn,
                style: theme.textTheme.bodyLarge?.copyWith(
                  height: 1.55,
                  color: onSurface.withValues(alpha: 0.85),
                ),
              ),
              const SizedBox(height: 24),
              // List of kigo entries.
              for (int i = 0; i < pairing.entries.length; i++) ...[
                _KigoEntryRow(
                  entry: pairing.entries[i],
                  isUk: isUk,
                  accent: accent,
                ),
                if (i < pairing.entries.length - 1) ...[
                  const SizedBox(height: 14),
                  Divider(
                    height: 1,
                    color: onSurface.withValues(alpha: 0.08),
                  ),
                  const SizedBox(height: 14),
                ],
              ],
            ],
          ),
    );
  }
}

/// One kigo row — japanese + romaji on the headline, gloss and literary
/// note below. Uses the accent only for a tiny leading dot so the
/// indigo ink reads without overwhelming.
class _KigoEntryRow extends StatelessWidget {
  const _KigoEntryRow({
    required this.entry,
    required this.isUk,
    required this.accent,
  });

  final KigoEntry entry;
  final bool isUk;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tiny indigo dot — ledger-mark for each entry.
        Padding(
          padding: const EdgeInsets.only(top: 9),
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.7),
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    entry.japanese,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      entry.romaji,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: onSurface.withValues(alpha: 0.55),
                        letterSpacing: 0.4,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                isUk ? entry.glossUk : entry.glossEn,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: onSurface.withValues(alpha: 0.65),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                isUk ? entry.noteUk : entry.noteEn,
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
