import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:seasons_72/l10n/app_localizations.dart';

import '../../../core/utils/moon_calculator.dart';

/// Small moon-phase glyph, tappable to reveal a details sheet.
///
/// Rendered via CustomPainter — scales cleanly from 18px (Home screen
/// bullet) to 80px (details dialog), picks up theme colors, and lets us
/// animate later if we want. Emoji was an option but renders
/// inconsistently across iOS/Android and can't be tinted.
class MoonPhaseIndicator extends StatelessWidget {
  const MoonPhaseIndicator({
    super.key,
    this.size = 22,
    this.showLabel = false,
    this.interactive = true,
  });

  /// Edge length in logical pixels.
  final double size;

  /// If true, appends the phase name next to the glyph.
  final bool showLabel;

  /// When false, the moon renders without tap-to-open-details behavior.
  /// Useful inside lists where the row itself is the tap target.
  final bool interactive;

  @override
  Widget build(BuildContext context) {
    final info = MoonCalculator.at();
    final theme = Theme.of(context);
    final colors = _MoonColors.from(theme);

    final moon = SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _MoonPainter(
          phase: info.phase,
          light: colors.lit,
          dark: colors.shadow,
          strokeColor: colors.stroke,
        ),
      ),
    );

    final content = showLabel
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              moon,
              const SizedBox(width: 8),
              Text(
                _phaseLabel(context, info.phaseName),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                ),
              ),
            ],
          )
        : moon;

    if (!interactive) {
      return Semantics(
        label: _phaseLabel(context, info.phaseName),
        value: '${(info.illumination * 100).round()}%',
        child: content,
      );
    }

    // WCAG 2.5.5 requires 44×44 pt touch targets. The visible glyph is
    // intentionally small (22 px) for visual weight — we pad it out to
    // the required 44 pt via the InkWell container.
    final hitPadding = math.max(0.0, (44 - size) / 2);
    return Semantics(
      button: true,
      label: _phaseLabel(context, info.phaseName),
      value: '${(info.illumination * 100).round()}% illuminated',
      onTapHint: 'Show moon details',
      child: InkWell(
        borderRadius: BorderRadius.circular(size),
        onTap: () => _showDetails(context, info),
        child: Padding(
          padding: EdgeInsets.all(hitPadding),
          child: content,
        ),
      ),
    );
  }

  void _showDetails(BuildContext context, MoonInfo info) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) => _MoonDetailsSheet(info: info),
    );
  }
}

/// Compact pill that pairs the moon glyph with the literal label
/// "Місяць" / "Moon" and the illumination percentage — sits in the
/// page eyebrow next to a caps label like "ЗАРАЗ ТРИВАЄ".
///
/// Why the explicit "Місяць" word: without it, the percentage next
/// to a "ЗАРАЗ ТРИВАЄ" eyebrow reads as season-progress, not lunar
/// illumination. The label removes that ambiguity instantly.
///
/// Tap → existing modal with full phase name, next full/new moon
/// dates, and the lunisolar note.
class MoonPhasePill extends StatelessWidget {
  const MoonPhasePill({super.key});

  @override
  Widget build(BuildContext context) {
    final info = MoonCalculator.at();
    final theme = Theme.of(context);
    final colors = _MoonColors.from(theme);
    final pct = (info.illumination * 100).round();
    final phaseLabel = _phaseLabel(context, info.phaseName);
    final isUk =
        Localizations.localeOf(context).languageCode == 'uk';
    final moonWord = isUk ? 'Місяць' : 'Moon';

    return Semantics(
      button: true,
      label: '$moonWord, $phaseLabel',
      value: '$pct% illuminated',
      onTapHint: 'Show moon details',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () => showModalBottomSheet(
                context: context,
                showDragHandle: true,
                builder: (ctx) => _MoonDetailsSheet(info: info),
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                decoration: BoxDecoration(
                  color:
                      theme.colorScheme.surface.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: theme.colorScheme.onSurface
                        .withValues(alpha: 0.14),
                    width: 0.6,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 14,
                      height: 14,
                      child: CustomPaint(
                        painter: _MoonPainter(
                          phase: info.phase,
                          light: colors.lit,
                          dark: colors.shadow,
                          strokeColor: colors.stroke,
                        ),
                      ),
                    ),
                    const SizedBox(width: 7),
                    Text(
                      moonWord,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.85),
                      ),
                    ),
                    Text(
                      '  ·  ',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.45),
                      ),
                    ),
                    Text(
                      '$pct%',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                        fontFeatures: const [
                          FontFeature.tabularFigures()
                        ],
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Bottom sheet with phase glyph, localized name, illumination %,
/// and next full/new moon dates. Tap anywhere outside to dismiss.
class _MoonDetailsSheet extends StatelessWidget {
  const _MoonDetailsSheet({required this.info});
  final MoonInfo info;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final df = DateFormat.yMMMMd(locale.languageCode);
    final theme = Theme.of(context);

    final phaseLabel = _phaseLabel(context, info.phaseName);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.moonDetailsTitle.toUpperCase(),
            style: theme.textTheme.labelLarge?.copyWith(
              letterSpacing: 1.8,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.70),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 96,
            height: 96,
            child: CustomPaint(
              painter: _MoonPainter(
                phase: info.phase,
                light: _MoonColors.from(theme).lit,
                dark: _MoonColors.from(theme).shadow,
                strokeColor: _MoonColors.from(theme).stroke,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(phaseLabel, style: theme.textTheme.titleLarge),
          const SizedBox(height: 6),
          Text(
            l10n.moonIllumination((info.illumination * 100).round()),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.70),
            ),
          ),
          const SizedBox(height: 20),
          _InfoRow(label: l10n.moonNextFull(df.format(info.nextFullMoon.toLocal()))),
          const SizedBox(height: 6),
          _InfoRow(label: l10n.moonNextNew(df.format(info.nextNewMoon.toLocal()))),
          const SizedBox(height: 20),
          Text(
            l10n.moonLunisolarNote,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.70),
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.bodyMedium,
      textAlign: TextAlign.center,
    );
  }
}

// ---------------------------------------------------------------------------
// Colors — explicit, theme-aware, not derived from onSurface. The lit
// side must ALWAYS read as "lit" (silvery/cream), the shadow as "dark"
// (slate/charcoal). Using alpha-modulated onSurface colors inverts the
// semantic meaning on light theme (black at 95% alpha reads as dark,
// not as "lit"), hence this helper.
// ---------------------------------------------------------------------------

class _MoonColors {
  const _MoonColors({
    required this.lit,
    required this.shadow,
    required this.stroke,
  });

  /// The illuminated side — should read distinctly brighter than the
  /// surface background (silvery moonlight).
  final Color lit;

  /// The shadowed side — must be noticeably darker than any card
  /// background so the phase silhouette is legible.
  final Color shadow;

  /// A thin outline keeping the disc crisp at 18-24 px.
  final Color stroke;

  static _MoonColors from(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    if (isDark) {
      return const _MoonColors(
        lit: Color(0xFFF3E9C9),       // warm ivory moonlight
        shadow: Color(0xFF1B1C22),    // near-black sky
        stroke: Color(0x33FFFFFF),    // thin white rim
      );
    }
    return const _MoonColors(
      lit: Color(0xFFFBF4DE),         // soft parchment cream
      shadow: Color(0xFF2B2E36),      // cool charcoal
      stroke: Color(0x332B2E36),      // 20% charcoal outline
    );
  }
}

// ---------------------------------------------------------------------------
// Painter
// ---------------------------------------------------------------------------

/// Draws the moon at a given [phase] (0=new, 0.5=full, 1=new) by:
/// 1. Filling the full disc with the dark color.
/// 2. Clipping to the lit half-circle (right for waxing, left for waning).
/// 3. Drawing either the lit disc, or a terminator ellipse that shapes
///    the crescent / gibbous silhouette.
class _MoonPainter extends CustomPainter {
  _MoonPainter({
    required this.phase,
    required this.light,
    required this.dark,
    required this.strokeColor,
  });

  final double phase;
  final Color light;
  final Color dark;
  final Color strokeColor;

  @override
  void paint(Canvas canvas, Size size) {
    final r = size.shortestSide / 2;
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: r);

    final darkPaint = Paint()..color = dark;
    final lightPaint = Paint()..color = light;
    final strokePaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // 1. Full dark disc
    canvas.drawCircle(center, r, darkPaint);

    // Compute illumination 0..1
    final illumination = 0.5 * (1 - math.cos(2 * math.pi * phase));
    final isWaxing = phase < 0.5;

    if (illumination > 0.995) {
      // Full moon
      canvas.drawCircle(center, r, lightPaint);
      canvas.drawCircle(center, r, strokePaint);
      return;
    }
    if (illumination < 0.005) {
      // New moon — outline only so the glyph is still visible
      canvas.drawCircle(center, r, strokePaint);
      return;
    }

    // 2. Lit half-circle on the correct side
    final litHalf = isWaxing
        ? Rect.fromLTWH(center.dx, rect.top, r, size.height)
        : Rect.fromLTWH(rect.left, rect.top, r, size.height);

    canvas.save();
    canvas.clipRect(litHalf);
    canvas.drawCircle(center, r, lightPaint);
    canvas.restore();

    // 3. Terminator ellipse — either subtracts (crescent) or adds (gibbous)
    final halfWidth = (2 * illumination - 1).abs() * r;
    final terminator = Rect.fromCenter(
      center: center,
      width: 2 * halfWidth,
      height: 2 * r,
    );

    if (illumination < 0.5) {
      // Crescent — eat into the lit half
      canvas.save();
      canvas.clipRect(litHalf);
      canvas.drawOval(terminator, darkPaint);
      canvas.restore();
    } else {
      // Gibbous — extend into the dark half
      final darkHalf = isWaxing
          ? Rect.fromLTWH(rect.left, rect.top, r, size.height)
          : Rect.fromLTWH(center.dx, rect.top, r, size.height);
      canvas.save();
      canvas.clipRect(darkHalf);
      canvas.drawOval(terminator, lightPaint);
      canvas.restore();
    }

    // Outline for crispness at small sizes
    canvas.drawCircle(center, r, strokePaint);
  }

  @override
  bool shouldRepaint(covariant _MoonPainter old) {
    return old.phase != phase ||
        old.light != light ||
        old.dark != dark ||
        old.strokeColor != strokeColor;
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

String _phaseLabel(BuildContext context, MoonPhaseName name) {
  final l10n = AppLocalizations.of(context)!;
  switch (name) {
    case MoonPhaseName.newMoon:
      return l10n.moonPhaseNew;
    case MoonPhaseName.waxingCrescent:
      return l10n.moonPhaseWaxingCrescent;
    case MoonPhaseName.firstQuarter:
      return l10n.moonPhaseFirstQuarter;
    case MoonPhaseName.waxingGibbous:
      return l10n.moonPhaseWaxingGibbous;
    case MoonPhaseName.fullMoon:
      return l10n.moonPhaseFull;
    case MoonPhaseName.waningGibbous:
      return l10n.moonPhaseWaningGibbous;
    case MoonPhaseName.lastQuarter:
      return l10n.moonPhaseLastQuarter;
    case MoonPhaseName.waningCrescent:
      return l10n.moonPhaseWaningCrescent;
  }
}
