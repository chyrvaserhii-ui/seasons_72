import 'package:flutter/material.dart';

import '../about/seasonal_kodo.dart';
import '../shared/widgets/dismissible_modal_sheet.dart';

/// Kōdō (香道) seasonal incense pairing for the current kō. Includes
/// classical Heian *neriko* blends (baika, kayō, kikka, rakuyō, kurobō)
/// and Edo *kumikō* games where they fit, modern compositions in the
/// kōdō register elsewhere — the bottom sheet exposes the full
/// ingredient list so curious readers can recognise jinkō from byakudan.
/// Amber-incense accent.
class KodoCard extends StatelessWidget {
  const KodoCard({
    super.key,
    required this.koIndex,
    required this.locale,
  });

  final int koIndex;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    final kodo = kodoForKo(koIndex);
    if (kodo == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final isUk = locale.languageCode == 'uk';
    final onSurface = theme.colorScheme.onSurface;
    final isDark = theme.brightness == Brightness.dark;

    // Amber — the colour of resin and aged agarwood, warm without
    // crowding the food row's persimmon.
    const amber = Color(0xFFB8956A);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isUk ? 'СЕЗОННІ ПАХОЩІ KŌDŌ' : 'SEASONAL KŌDŌ INCENSE',
          style: theme.textTheme.labelLarge?.copyWith(
            color: onSurface.withValues(alpha: 0.75),
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Material(
          color: amber.withValues(alpha: isDark ? 0.10 : 0.12),
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _showSheet(context, kodo, isUk, amber),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '🌫️',
                    style: TextStyle(
                      fontSize: 20,
                      color: amber.withValues(alpha: 0.92),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${kodo.japanese}  ${isUk ? kodo.nameUk : kodo.nameEn}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          kodo.romaji,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: onSurface.withValues(alpha: 0.65),
                            letterSpacing: 0.4,
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
      ],
    );
  }

  void _showSheet(
      BuildContext context, KodoPairing kodo, bool isUk, Color accent) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) =>
          _KodoDetailsSheet(kodo: kodo, isUk: isUk, accent: accent),
    );
  }
}

class _KodoDetailsSheet extends StatelessWidget {
  const _KodoDetailsSheet({
    required this.kodo,
    required this.isUk,
    required this.accent,
  });

  final KodoPairing kodo;
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
                  isUk ? 'СЕЗОННІ ПАХОЩІ KŌDŌ' : 'SEASONAL KŌDŌ INCENSE',
                  style: theme.textTheme.labelLarge?.copyWith(
                    letterSpacing: 1.8,
                    color: onSurface.withValues(alpha: 0.55),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Center(
                child: Text(
                  kodo.japanese,
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontSize: 52,
                    color: accent.withValues(alpha: 0.92),
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  isUk ? kodo.nameUk : kodo.nameEn,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  kodo.romaji,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: onSurface.withValues(alpha: 0.55),
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              // Theme — short evocative line, sat in a soft tint so it
              // reads as the blend's "intent" rather than its description.
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isUk ? kodo.themeUk : kodo.themeEn,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: onSurface.withValues(alpha: 0.85),
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Center(
                child: Container(
                  width: 60,
                  height: 1,
                  color: accent.withValues(alpha: 0.4),
                ),
              ),
              const SizedBox(height: 22),
              Text(
                isUk ? kodo.noteUk : kodo.noteEn,
                style: theme.textTheme.bodyLarge?.copyWith(
                  height: 1.55,
                  color: onSurface.withValues(alpha: 0.85),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                isUk ? 'СКЛАДНИКИ' : 'INGREDIENTS',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: onSurface.withValues(alpha: 0.65),
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 10),
              // Ingredient chips — each shows the local-language name
              // primarily so a non-specialist can read what's actually
              // burning, with the romaji hovered as a small secondary
              // line for readers who want the kōdō vocabulary.
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final ing in kodo.ingredients)
                    _IngredientChip(
                      romaji: ing,
                      gloss: _ingredientGloss(ing, isUk),
                      accent: accent,
                    ),
                ],
              ),
            ],
          ),
    );
  }
}

class _IngredientChip extends StatelessWidget {
  const _IngredientChip({
    required this.romaji,
    required this.gloss,
    required this.accent,
  });

  final String romaji;
  final String gloss;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: accent.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.7),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                gloss,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: onSurface.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                romaji,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: onSurface.withValues(alpha: 0.55),
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Plain-language gloss for the 12 canonical kōdō ingredients used
/// in the data file. Kept local to the card so adding a new ingredient
/// only requires one place to update.
String _ingredientGloss(String romaji, bool isUk) {
  if (isUk) {
    switch (romaji) {
      case 'jinkō':       return 'агарове дерево';
      case 'byakudan':    return 'сандал';
      case 'chōji':       return 'гвоздика';
      case 'kunroku':     return 'ладан';
      case 'kanshō':      return 'нард';
      case 'reiryōkō':    return 'трав\'яниста матка';
      case 'kyara':       return 'агар-кяра (преміум)';
      case 'rakoku':      return 'агар-ракоку (тайський)';
      case 'manaka':      return 'агар-манака (солодкий)';
      case 'manaban':     return 'агар-манабан (південний)';
      case 'sumotara':    return 'агар-сумотара (суматра)';
      case 'sasora':      return 'агар-сасора (гіркий)';
      case 'kasshoku-kō': return 'темна смола';
      case 'jakō':        return 'мускус';
      case 'hakkasshō':   return 'м\'ята';
      default:            return romaji; // safe fallback
    }
  }
  switch (romaji) {
    case 'jinkō':       return 'agarwood';
    case 'byakudan':    return 'sandalwood';
    case 'chōji':       return 'clove';
    case 'kunroku':     return 'frankincense';
    case 'kanshō':      return 'spikenard';
    case 'reiryōkō':    return 'sweet-flag grass';
    case 'kyara':       return 'kyara (premium agar)';
    case 'rakoku':      return 'rakoku (Thai agar)';
    case 'manaka':      return 'manaka (sweet agar)';
    case 'manaban':     return 'manaban (southern agar)';
    case 'sumotara':    return 'sumotara (Sumatran agar)';
    case 'sasora':      return 'sasora (bitter agar)';
    case 'kasshoku-kō': return 'dark resin';
    case 'jakō':        return 'musk';
    case 'hakkasshō':   return 'mint';
    default:            return romaji;
  }
}
