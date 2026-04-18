import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A very subtle "washi paper" overlay. Paints ~400 deterministic
/// tiny dots (1–2 px) at low opacity — mimics the fiber flecks that give
/// real Japanese paper its soul. Stateless, static, cheap (single
/// repaint on size change).
class WashiBackground extends StatelessWidget {
  const WashiBackground({
    super.key,
    required this.child,
    this.tint,
    this.density = 0.00018,
  });

  final Widget child;

  /// Base color for the flecks. Defaults to the theme's `onSurface` so
  /// the texture reads the same in both themes.
  final Color? tint;

  /// Fleck count per pixel. Keep this tiny — 0.0002 ≈ 300 flecks on an
  /// iPhone 14 screen, which is barely visible.
  final double density;

  @override
  Widget build(BuildContext context) {
    final dotColor = (tint ?? Theme.of(context).colorScheme.onSurface)
        .withValues(alpha: 0.035);
    return Stack(
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: _WashiPainter(color: dotColor, density: density),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class _WashiPainter extends CustomPainter {
  _WashiPainter({required this.color, required this.density});

  final Color color;
  final double density;

  @override
  void paint(Canvas canvas, Size size) {
    // Deterministic pattern — same seed every frame so the texture
    // doesn't shimmer when the widget rebuilds (e.g., theme changes).
    final rng = math.Random(42);
    final count = (size.width * size.height * density).round();
    final paint = Paint()..color = color;
    for (var i = 0; i < count; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final r = 0.6 + rng.nextDouble() * 0.8; // 0.6–1.4 px
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _WashiPainter old) =>
      old.color != color || old.density != density;
}
