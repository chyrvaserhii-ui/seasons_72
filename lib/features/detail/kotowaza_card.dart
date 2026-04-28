import 'package:flutter/material.dart';

import '../about/seasonal_kotowaza.dart';
import '../shared/widgets/dismissible_modal_sheet.dart';

/// Kotowaza (諺) — Japanese proverb tied to the current kō.
/// Row card surfaces the kanji + romaji + brief literal translation;
/// tap → bottom sheet with the full meaning and connection note.
///
/// Kodai-murasaki accent — dusty plum-grey of aged literary tradition,
/// distinct from the kigo card's deeper indigo (kigo lives in saijiki,
/// kotowaza in kotowaza-jiten — sister registers, different colour).
class KotowazaCard extends StatelessWidget {
  const KotowazaCard({
    super.key,
    required this.koIndex,
    required this.locale,
  });

  final int koIndex;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    final pairing = kotowazaForKo(koIndex);
    if (pairing == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final isUk = locale.languageCode == 'uk';
    final onSurface = theme.colorScheme.onSurface;
    final isDark = theme.brightness == Brightness.dark;

    // Kodai-murasaki — old-purple grey, the colour of Heian-era
    // literary refinement. Distinct from kigo-indigo and kodo-amber.
    const kodaiMurasaki = Color(0xFF6F5B73);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isUk ? 'СЕЗОННЕ ПРИСЛІВ’Я' : 'SEASONAL PROVERB',
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
              onTap: () => _showSheet(context, pairing, isUk, kodaiMurasaki),
              child: Container(
                decoration: BoxDecoration(
                  color: kodaiMurasaki
                      .withValues(alpha: isDark ? 0.14 : 0.16),
                  border: Border(
                    left: BorderSide(
                      color: kodaiMurasaki.withValues(alpha: 0.70),
                      width: 3,
                    ),
                    bottom: BorderSide(
                      color: kodaiMurasaki.withValues(alpha: 0.18),
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
                      '📖',
                      style: TextStyle(
                        fontSize: 20,
                        color: kodaiMurasaki.withValues(alpha: 0.92),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pairing.japanese,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${pairing.romaji}  ·  '
                            '${isUk ? pairing.literalUk : pairing.literalEn}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: onSurface.withValues(alpha: 0.65),
                              letterSpacing: 0.3,
                            ),
                            maxLines: 2,
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
    BuildContext context,
    KotowazaPairing pairing,
    bool isUk,
    Color accent,
  ) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _KotowazaDetailsSheet(
        pairing: pairing,
        isUk: isUk,
        accent: accent,
      ),
    );
  }
}

class _KotowazaDetailsSheet extends StatelessWidget {
  const _KotowazaDetailsSheet({
    required this.pairing,
    required this.isUk,
    required this.accent,
  });

  final KotowazaPairing pairing;
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
          // Caps eyebrow.
          Center(
            child: Text(
              isUk ? 'СЕЗОННЕ ПРИСЛІВ’Я' : 'SEASONAL PROVERB',
              style: theme.textTheme.labelLarge?.copyWith(
                letterSpacing: 1.8,
                color: onSurface.withValues(alpha: 0.55),
              ),
            ),
          ),
          const SizedBox(height: 14),
          // Hero kanji — large, calligraphy-feel.
          Center(
            child: Text(
              pairing.japanese,
              style: theme.textTheme.displayMedium?.copyWith(
                fontSize: 36,
                color: accent.withValues(alpha: 0.92),
                fontWeight: FontWeight.w700,
                height: 1.25,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          // Romaji (italic) — phonetic anchor.
          Center(
            child: Text(
              pairing.romaji,
              style: theme.textTheme.titleMedium?.copyWith(
                color: onSurface.withValues(alpha: 0.70),
                fontStyle: FontStyle.italic,
                letterSpacing: 0.4,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          // Literal translation.
          Center(
            child: Container(
              width: 60,
              height: 1,
              color: accent.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(height: 18),
          _SectionBlock(
            title: isUk ? 'БУКВАЛЬНО' : 'LITERAL',
            body: isUk ? pairing.literalUk : pairing.literalEn,
            theme: theme,
            onSurface: onSurface,
          ),
          const SizedBox(height: 20),
          _SectionBlock(
            title: isUk ? 'ЗНАЧЕННЯ' : 'MEANING',
            body: isUk ? pairing.meaningUk : pairing.meaningEn,
            theme: theme,
            onSurface: onSurface,
          ),
          const SizedBox(height: 20),
          _SectionBlock(
            title: isUk ? 'ЧОМУ ЗАРАЗ' : 'WHY NOW',
            body: isUk ? pairing.connectionUk : pairing.connectionEn,
            theme: theme,
            onSurface: onSurface,
          ),
        ],
      ),
    );
  }
}

class _SectionBlock extends StatelessWidget {
  const _SectionBlock({
    required this.title,
    required this.body,
    required this.theme,
    required this.onSurface,
  });
  final String title;
  final String body;
  final ThemeData theme;
  final Color onSurface;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.labelLarge?.copyWith(
            color: onSurface.withValues(alpha: 0.65),
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          body,
          style: theme.textTheme.bodyMedium?.copyWith(height: 1.55),
        ),
      ],
    );
  }
}
