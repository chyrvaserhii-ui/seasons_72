import 'package:flutter/material.dart';

import '../about/seasonal_hana.dart';
import '../shared/widgets/dismissible_modal_sheet.dart';

/// Seasonal flower at peak for the current kō. Visual language follows
/// [TeaCard] / [FoodCard]: caps editorial header → tinted Material row →
/// info icon → modal bottom sheet with the full entry. Sakura-pink
/// accent, distinct from the jade tea row and the persimmon food row.
class HanaCard extends StatelessWidget {
  const HanaCard({
    super.key,
    required this.koIndex,
    required this.locale,
  });

  final int koIndex;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    final hana = hanaForKo(koIndex);
    if (hana == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final isUk = locale.languageCode == 'uk';
    final onSurface = theme.colorScheme.onSurface;
    final isDark = theme.brightness == Brightness.dark;

    // Sakura pink — the universal "flower at peak" tint, soft enough to
    // sit alongside the meta-season wash.
    const sakura = Color(0xFFE6A4B4);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isUk ? 'СЕЗОННА КВІТКА' : 'SEASONAL FLOWER',
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
              onTap: () => _showSheet(context, hana, isUk, sakura),
              child: Container(
                decoration: BoxDecoration(
                  color: sakura.withValues(alpha: isDark ? 0.14 : 0.16),
                  border: Border(
                    left: BorderSide(
                      color: sakura.withValues(alpha: 0.70),
                      width: 3,
                    ),
                    bottom: BorderSide(
                      color: sakura.withValues(alpha: 0.18),
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
                      '🌸',
                      style: TextStyle(
                        fontSize: 20,
                        color: sakura.withValues(alpha: 0.92),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${hana.japanese}  ${isUk ? hana.nameUk : hana.nameEn}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            hana.botanical,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: onSurface.withValues(alpha: 0.65),
                              letterSpacing: 0.3,
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
        ),
      ],
    );
  }

  void _showSheet(
      BuildContext context, HanaPairing hana, bool isUk, Color accent) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) =>
          _HanaDetailsSheet(hana: hana, isUk: isUk, accent: accent),
    );
  }
}

class _HanaDetailsSheet extends StatelessWidget {
  const _HanaDetailsSheet({
    required this.hana,
    required this.isUk,
    required this.accent,
  });

  final HanaPairing hana;
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
                  isUk ? 'СЕЗОННА КВІТКА' : 'SEASONAL FLOWER',
                  style: theme.textTheme.labelLarge?.copyWith(
                    letterSpacing: 1.8,
                    color: onSurface.withValues(alpha: 0.55),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Center(
                child: Text(
                  hana.japanese,
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontSize: 56,
                    color: accent.withValues(alpha: 0.92),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  isUk ? hana.nameUk : hana.nameEn,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  hana.romaji,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: onSurface.withValues(alpha: 0.55),
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  hana.botanical,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: onSurface.withValues(alpha: 0.55),
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
                isUk ? hana.noteUk : hana.noteEn,
                style: theme.textTheme.bodyLarge?.copyWith(
                  height: 1.55,
                  color: onSurface.withValues(alpha: 0.85),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                isUk ? 'МОВА КВІТІВ' : 'FLOWER LANGUAGE',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: onSurface.withValues(alpha: 0.65),
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isUk ? hana.hanakotobaUk : hana.hanakotobaEn,
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.55),
              ),
            ],
          ),
    );
  }
}
