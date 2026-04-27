import 'package:flutter/material.dart';

import '../../../core/models/season_models.dart';
import '../../../core/utils/localized_names.dart';
import '../../about/sekki_descriptions.dart';
import 'dismissible_modal_sheet.dart';

/// Sekki (24-season) cultural context card.
///
/// Visual: meta-tinted card with kanji + localized name + meta-name
/// row. Tap → bottom sheet with full editorial description. The card
/// includes a small caps header above the row so it reads as a
/// labeled section, consistent with other detail blocks (TeaCard,
/// "СЕЗОННИЙ ЧАЙ", etc).
class SekkiCard extends StatelessWidget {
  const SekkiCard({
    super.key,
    required this.meta,
    required this.sekki,
    required this.locale,
    required this.accentColor,
    this.showHeader = true,
  });

  final MetaSeason meta;
  final Sekki sekki;
  final Locale locale;
  final Color accentColor;

  /// When true (default) the card is preceded by a "СЕККІ" caps
  /// header. Set to false on screens where another caption already
  /// frames it.
  final bool showHeader;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUk = locale.languageCode == 'uk';
    final onSurface = theme.colorScheme.onSurface;
    final isDark = theme.brightness == Brightness.dark;
    // Moss-olive — fixed accent for the Sekki card, evoking the rice
    // paddy / 🌾 grain register that "phase of the year" rhymes with.
    // Independent of meta-season tint: see period_card.dart for the
    // rationale (Period and Sekki used to share the meta accent and
    // came out visually identical). The passed-in [accentColor] is now
    // ignored on purpose — kept on the constructor only for backwards
    // call-site compatibility.
    const moss = Color(0xFF8E9C5C);
    final cardAccent = moss;

    final card = ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => _showSekkiSheet(context),
          child: Container(
            decoration: BoxDecoration(
              color: cardAccent.withValues(alpha: isDark ? 0.14 : 0.16),
              border: Border(
                left: BorderSide(
                  color: cardAccent.withValues(alpha: 0.70),
                  width: 3,
                ),
                bottom: BorderSide(
                  color: cardAccent.withValues(alpha: 0.18),
                  width: 0.5,
                ),
              ),
            ),
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
    );

    if (!showHeader) return card;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isUk ? 'ПІДСЕЗОН СЕККІ' : 'SEKKI SUB-SEASON',
          style: theme.textTheme.labelLarge?.copyWith(
            color: onSurface.withValues(alpha: 0.65),
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        card,
      ],
    );
  }

  void _showSekkiSheet(BuildContext context) {
    // Pass the same moss accent to the details sheet so its headings,
    // separators, and emoji tint match the row card the user just
    // tapped. Caller-provided [accentColor] is ignored — the card
    // owns its colour identity now.
    const moss = Color(0xFF8E9C5C);
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _SekkiDetailsSheet(
        sekki: sekki,
        meta: meta,
        locale: locale,
        accentColor: moss,
      ),
    );
  }
}

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

    return DismissibleModalSheet(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
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
    );
  }
}
