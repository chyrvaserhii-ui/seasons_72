import 'package:flutter/material.dart';

import '../about/seasonal_practice.dart';

/// Three quiet prompts paired to the current kō: body, activity,
/// contemplation. The card is the most invitational of the four detail
/// blocks (sekki, tea, food, colour, practice) — the others are factual,
/// this one is gently personal. Sage accent — calm, neither food-warm
/// nor tea-bright.
class PracticeCard extends StatelessWidget {
  const PracticeCard({
    super.key,
    required this.koIndex,
    required this.locale,
  });

  final int koIndex;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    final note = practiceForKo(koIndex);
    if (note == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final isUk = locale.languageCode == 'uk';
    final onSurface = theme.colorScheme.onSurface;
    final isDark = theme.brightness == Brightness.dark;

    // Sage — muted blue-green, reads as "rest" rather than "do".
    const sage = Color(0xFF809B92);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isUk ? 'ПРАКТИКА' : 'PRACTICE',
          style: theme.textTheme.labelLarge?.copyWith(
            color: onSurface.withValues(alpha: 0.75),
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Material(
          color: sage.withValues(alpha: isDark ? 0.10 : 0.12),
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _showSheet(context, note, isUk, sage),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '🪷',
                    style: TextStyle(
                      fontSize: 20,
                      color: sage.withValues(alpha: 0.92),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isUk
                              ? 'Як прожити ці п\'ять днів'
                              : 'How to live these five days',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          isUk
                              ? 'тіло · дія · споглядання'
                              : 'body · activity · contemplation',
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
      BuildContext context, PracticeNote note, bool isUk, Color accent) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) =>
          _PracticeDetailsSheet(note: note, isUk: isUk, accent: accent),
    );
  }
}

class _PracticeDetailsSheet extends StatelessWidget {
  const _PracticeDetailsSheet({
    required this.note,
    required this.isUk,
    required this.accent,
  });

  final PracticeNote note;
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
                  isUk ? 'ПРАКТИКА' : 'PRACTICE',
                  style: theme.textTheme.labelLarge?.copyWith(
                    letterSpacing: 1.8,
                    color: onSurface.withValues(alpha: 0.55),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Center(
                child: Text(
                  '🪷',
                  style: TextStyle(
                    fontSize: 44,
                    color: accent.withValues(alpha: 0.92),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Motto — one-line distilled invitation for the kō.
              // Replaces the duplicated "Як прожити ці п'ять днів"
              // hero so the sheet opens with content unique to the
              // current kō, not the row's title repeated.
              Center(
                child: Text(
                  isUk ? note.mottoUk : note.mottoEn,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                  textAlign: TextAlign.center,
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
              const SizedBox(height: 24),

              _SectionBlock(
                title: isUk ? 'ТІЛО' : 'BODY',
                body: isUk ? note.bodyUk : note.bodyEn,
                onSurface: onSurface,
                theme: theme,
              ),
              const SizedBox(height: 22),
              _SectionBlock(
                title: isUk ? 'ДІЯ' : 'ACTIVITY',
                body: isUk ? note.activityUk : note.activityEn,
                onSurface: onSurface,
                theme: theme,
              ),
              const SizedBox(height: 22),
              _SectionBlock(
                title: isUk ? 'СПОГЛЯДАННЯ' : 'CONTEMPLATION',
                body: isUk ? note.contemplationUk : note.contemplationEn,
                onSurface: onSurface,
                theme: theme,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One labelled prose block inside the practice sheet — caps header
/// followed by the prompt itself.
class _SectionBlock extends StatelessWidget {
  const _SectionBlock({
    required this.title,
    required this.body,
    required this.onSurface,
    required this.theme,
  });

  final String title;
  final String body;
  final Color onSurface;
  final ThemeData theme;

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
