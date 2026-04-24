import 'package:flutter/material.dart';

/// Typography-opacity tokens, chosen to pass WCAG 2.1 AA on washi-paper
/// backgrounds (`#F5EFE6` / `#1C1A1A`).
///
/// Contrast ratios vs. light washi `#F5EFE6` with `sumiInk #1A1615`:
///   primary    (α=1.00)  ≈ 15.6 : 1   AAA
///   secondary  (α=0.70)  ≈  6.0 : 1   AA
///   tertiary   (α=0.55)  ≈  3.8 : 1   FAIL AA — decorative only
///
/// Rule of thumb:
///   * any text that carries meaning  → [textPrimary] or [textSecondary]
///   * decorative separators, dots    → [decorative]
///   * text laid over imagery         → [textOnImage] (shadow helps)
class TextAlphas {
  TextAlphas._();

  /// Full-weight text — titles, body copy, numbers in hero positions.
  static const double primary = 1.0;

  /// Meta labels, captions, bullet-list labels. **Passes WCAG AA**.
  static const double secondary = 0.70;

  /// Muted supplemental — reserved for decorative / never-essential text
  /// layered on imagery (where the image provides additional contrast).
  static const double tertiary = 0.55;

  /// Decorative glyphs (dot separators, bullet points). Not WCAG-gated
  /// because these aren't `text`, but we keep contrast ≥ 3:1 for UI.
  static const double decorative = 0.50;
}

/// Convenience extension so we can write
/// `onSurface.secondary` instead of
/// `onSurface.withValues(alpha: TextAlphas.secondary)`.
extension TextAlphaColor on Color {
  Color get primaryText => withValues(alpha: TextAlphas.primary);
  Color get secondaryText => withValues(alpha: TextAlphas.secondary);
  Color get tertiaryText => withValues(alpha: TextAlphas.tertiary);
  Color get decorative => withValues(alpha: TextAlphas.decorative);
}
