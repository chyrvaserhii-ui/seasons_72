import 'package:flutter/material.dart';

import '../about/seasonal_foods.dart';

/// Seasonal Japanese food paired to the current kō.
///
/// Visual language mirrors [TeaCard] exactly: a caps editorial header,
/// a single tinted row with an icon + title + subtitle + chevron, and a
/// modal bottom sheet with the full pairing on tap. Persimmon accent —
/// warm and food-coded so it reads at a glance as the "what to eat"
/// row, never confused with the green-jade tea row.
class FoodCard extends StatelessWidget {
  const FoodCard({
    super.key,
    required this.koIndex,
    required this.locale,
  });

  final int koIndex;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    final food = foodForKo(koIndex);
    if (food == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final isUk = locale.languageCode == 'uk';
    final onSurface = theme.colorScheme.onSurface;
    final isDark = theme.brightness == Brightness.dark;

    // Persimmon — warm and earthy, matches autumn meta tint without
    // clashing in spring/summer/winter screens.
    const persimmon = Color(0xFFD89060);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isUk ? 'СЕЗОННА ЇЖА' : 'SEASONAL FOOD',
          style: theme.textTheme.labelLarge?.copyWith(
            color: onSurface.withValues(alpha: 0.75),
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Material(
          color: persimmon.withValues(alpha: isDark ? 0.10 : 0.12),
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _showSheet(context, food, isUk, persimmon),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '🍱',
                    style: TextStyle(
                      fontSize: 20,
                      color: persimmon.withValues(alpha: 0.92),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isUk ? food.nameUk : food.nameEn,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          _foodTypeLabel(food.type, isUk),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: onSurface.withValues(alpha: 0.65),
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
      BuildContext context, FoodPairing food, bool isUk, Color accent) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) =>
          _FoodDetailsSheet(food: food, isUk: isUk, accent: accent),
    );
  }
}

class _FoodDetailsSheet extends StatelessWidget {
  const _FoodDetailsSheet({
    required this.food,
    required this.isUk,
    required this.accent,
  });

  final FoodPairing food;
  final bool isUk;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final mq = MediaQuery.of(context);
    final maxHeight = mq.size.height * 0.85;

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  isUk ? 'СЕЗОННА ЇЖА' : 'SEASONAL FOOD',
                  style: theme.textTheme.labelLarge?.copyWith(
                    letterSpacing: 1.8,
                    color: onSurface.withValues(alpha: 0.55),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              // Hero — Japanese kanji rendered large like the tea sheet.
              Center(
                child: Text(
                  food.japanese,
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontSize: 48,
                    color: accent.withValues(alpha: 0.92),
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  isUk ? food.nameUk : food.nameEn,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  food.romaji,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: onSurface.withValues(alpha: 0.55),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  _foodTypeLabel(food.type, isUk),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: onSurface.withValues(alpha: 0.55),
                    letterSpacing: 1.2,
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
                isUk ? food.noteUk : food.noteEn,
                style: theme.textTheme.bodyLarge?.copyWith(
                  height: 1.55,
                  color: onSurface.withValues(alpha: 0.85),
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shared label resolver used by both the row card and the bottom sheet.
/// Keeps the FoodType vocabulary in one place.
String _foodTypeLabel(FoodType t, bool isUk) {
  if (isUk) {
    switch (t) {
      case FoodType.wagashi:   return 'Васі (солодощі)';
      case FoodType.sakana:    return 'Сакана (риба і морепродукти)';
      case FoodType.yasai:     return 'Ясай (овочі, ґірські трави)';
      case FoodType.gohan:     return 'Гохан (рисова страва)';
      case FoodType.shirumono: return 'Сірумоно (суп, набе)';
      case FoodType.men:       return 'Мен (локшина)';
      case FoodType.hozon:     return 'Хозон (соління, ферменти)';
      case FoodType.nomimono:  return 'Номімоно (напій)';
      case FoodType.niku:      return 'Ніку (м\'ясо, дичина, яйця)';
      case FoodType.kudamono:  return 'Кудамоно (фрукти)';
    }
  }
  switch (t) {
    case FoodType.wagashi:   return 'Wagashi (sweet)';
    case FoodType.sakana:    return 'Sakana (fish, sea life)';
    case FoodType.yasai:     return 'Yasai (vegetables, mountain greens)';
    case FoodType.gohan:     return 'Gohan (rice dish)';
    case FoodType.shirumono: return 'Shirumono (soup, hotpot)';
    case FoodType.men:       return 'Men (noodles)';
    case FoodType.hozon:     return 'Hozon (preserves)';
    case FoodType.nomimono:  return 'Nomimono (drink)';
    case FoodType.niku:      return 'Niku (meat, game, eggs)';
    case FoodType.kudamono:  return 'Kudamono (fruit)';
  }
}
