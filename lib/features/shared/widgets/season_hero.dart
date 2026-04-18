import 'package:flutter/material.dart';

import '../../../core/models/season_models.dart';

/// Hero block for a kō — image-focused design.
///
/// Fills a square (1:1) frame with the ukiyo-e illustration when bundled,
/// otherwise a large centered emoji. Only overlay inside the hero is the
/// `#N` index badge in the top-left corner. Localized name + kanji/romaji
/// footer are rendered by the screen consuming this widget (see
/// `SeasonTitleBlock`).
class SeasonHero extends StatelessWidget {
  const SeasonHero({
    super.key,
    required this.ko,
    required this.meta,
  });

  final MicroSeason ko;
  final MetaSeason meta;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final bg = meta.colorFor(brightness).withValues(alpha: isDark ? 0.18 : 0.35);
    final border = meta.colorFor(brightness).withValues(alpha: 0.55);

    return AspectRatio(
      aspectRatio: 1.0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            color: bg,
            border: Border.all(color: border, width: 1),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Primary visual: illustration if bundled, else the per-kō emoji.
              if (ko.illustrationAsset != null)
                Image.asset(
                  ko.illustrationAsset!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _EmojiFallback(emoji: ko.emoji),
                )
              else
                _EmojiFallback(emoji: ko.emoji),
              // #N badge — always visible on top-left
              Positioned(
                left: 16,
                top: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .surface
                        .withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(999),
                    border:
                        Border.all(color: border.withValues(alpha: 0.8)),
                  ),
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontFeatures: const [
                              FontFeature.tabularFigures()
                            ],
                            fontWeight: FontWeight.w600,
                          ),
                      children: [
                        TextSpan(text: '#${ko.index}'),
                        TextSpan(
                          text: ' / 72',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Large centered emoji used when a kō has no bundled illustration yet.
class _EmojiFallback extends StatelessWidget {
  const _EmojiFallback({required this.emoji});
  final String emoji;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    return Center(
      child: Opacity(
        opacity: isDark ? 0.85 : 0.9,
        child: Text(
          emoji,
          style: const TextStyle(fontSize: 180),
        ),
      ),
    );
  }
}

/// Pulled-out haiku block — centered quote framed by thin horizontal
/// rules in the meta-season's color. Shown on home and detail screens
/// below the description. Returns SizedBox.shrink when the kō has no haiku.
class SeasonHaiku extends StatelessWidget {
  const SeasonHaiku({super.key, required this.ko, this.accentColor});
  final MicroSeason ko;

  /// Color tint applied to the top/bottom rules. If null, uses a neutral
  /// onSurface tint. Passing a meta-season color makes the block feel
  /// like part of the current season's palette.
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final text = ko.localizedHaiku(locale);
    final author = ko.localizedHaikuAuthor(locale);
    if (text == null || text.isEmpty) return const SizedBox.shrink();

    final subtle = Theme.of(context)
        .colorScheme
        .onSurface
        .withValues(alpha: 0.75);

    final ruleColor = (accentColor ??
            Theme.of(context).colorScheme.onSurface)
        .withValues(alpha: 0.35);

    // Japanese design favors asymmetric framing: the top rule is a
    // single thin line (opens the poem), the bottom is a line punctuated
    // by a small seal-red dot in the middle (closes it, like a 落款).
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _TopRule(color: ruleColor),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.55,
                  fontWeight: FontWeight.w400,
                  color: subtle,
                  letterSpacing: 0.2,
                ),
              ),
              if (author != null && author.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  '— $author',
                  style: TextStyle(
                    fontSize: 12,
                    color: subtle.withValues(alpha: 0.65),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ],
          ),
        ),
        _BottomRuleWithSeal(
            ruleColor: ruleColor, sealColor: const Color(0xFFB94A3D)),
      ],
    );
  }
}

/// Opening rule — single thin centered horizontal line.
class _TopRule extends StatelessWidget {
  const _TopRule({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 40),
      color: color,
    );
  }
}

/// Closing rule — line broken by a small seal-red dot in the middle,
/// echoing the 落款 (rakan) stamp traditional Japanese prints end with.
class _BottomRuleWithSeal extends StatelessWidget {
  const _BottomRuleWithSeal({
    required this.ruleColor,
    required this.sealColor,
  });
  final Color ruleColor;
  final Color sealColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Container(height: 1, color: ruleColor)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: sealColor.withValues(alpha: 0.75),
              ),
            ),
          ),
          Expanded(child: Container(height: 1, color: ruleColor)),
        ],
      ),
    );
  }
}

/// Small rounded-square thumbnail of a kō. Used in prev/next navigation
/// cards. Shows the ukiyo-e illustration if bundled; otherwise the kō's
/// themed emoji on a tinted background.
class SeasonThumbnail extends StatelessWidget {
  const SeasonThumbnail({
    super.key,
    required this.ko,
    required this.color,
    this.size = 44,
  });

  final MicroSeason ko;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (ko.illustrationAsset != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          ko.illustrationAsset!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _EmojiThumb(
            emoji: ko.emoji, color: color, size: size),
        ),
      );
    }
    return _EmojiThumb(emoji: ko.emoji, color: color, size: size);
  }
}

class _EmojiThumb extends StatelessWidget {
  const _EmojiThumb({
    required this.emoji,
    required this.color,
    required this.size,
  });
  final String emoji;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        emoji,
        style: TextStyle(fontSize: size * 0.55),
      ),
    );
  }
}

/// Title block that pairs with [SeasonHero]: large localized name + a
/// subtle kanji · romaji row. Intended to render directly below the hero.
///
/// If [accentColor] is provided, the kanji are tinted with it — echoing
/// the meta-season palette and creating a subtle cultural-color link.
class SeasonTitleBlock extends StatelessWidget {
  const SeasonTitleBlock({
    super.key,
    required this.ko,
    required this.locale,
    this.accentColor,
  });

  final MicroSeason ko;
  final Locale locale;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final name = locale.languageCode == 'uk' ? ko.nameUk : ko.nameEn;
    final subtle = Theme.of(context)
        .colorScheme
        .onSurface
        .withValues(alpha: 0.55);
    // Kanji get a slight season tint. Blend with onSurface so they read
    // clearly against the washi/sumi background in both themes.
    final kanjiColor = accentColor != null
        ? Color.alphaBlend(
            accentColor!.withValues(alpha: 0.55),
            Theme.of(context).colorScheme.onSurface,
          )
        : subtle;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                height: 1.15,
              ),
        ),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              ko.kanji,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: kanjiColor,
                letterSpacing: 1.5,
              ),
            ),
            Text('  ·  ', style: TextStyle(color: subtle)),
            Flexible(
              child: Text(
                ko.romaji,
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: subtle,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
