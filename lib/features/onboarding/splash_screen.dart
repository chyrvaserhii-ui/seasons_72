import 'package:flutter/material.dart';

/// Themed cold-launch splash. Replaces the default white screen and
/// the bare CircularProgressIndicator with a tone-matching first
/// impression: a large 候 (kō) glyph above a tiny "72 СЕЗОНИ" caps
/// label, painted on a soft gradient that uses the meta-season tint
/// of the current time of year.
///
/// Stays visible for the [duration] passed in by the router; that
/// gives async preloads (SharedPreferences, SeasonsRepository, audio
/// pre-warming) enough headroom to finish before AppShell mounts.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    // Slow opacity pulse on the kanji — a heartbeat-rate breath that
    // signals "we're alive, just preparing" without resorting to a
    // spinner.
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _pulseAnim =
        Tween<double>(begin: 0.55, end: 1.0).animate(CurvedAnimation(
      parent: _pulse,
      curve: Curves.easeInOutSine,
    ));
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  /// Map current month → meta-season accent so the splash gradient
  /// already feels seasonal before the seasons repository is queried.
  /// Mirrors the Japanese calendar's meta-season starts (Risshun in
  /// February etc.) closely enough for a 2-second cosmetic.
  Color _accentForToday(BuildContext context) {
    final month = DateTime.now().month;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (month >= 2 && month <= 4) {
      return isDark ? const Color(0xFFFFA8B5) : const Color(0xFFF4B5C1);
    }
    if (month >= 5 && month <= 7) {
      return isDark ? const Color(0xFF8FDD9E) : const Color(0xFF8FBF7F);
    }
    if (month >= 8 && month <= 10) {
      return isDark ? const Color(0xFFF0A070) : const Color(0xFFD89060);
    }
    return isDark ? const Color(0xFFA8C4E0) : const Color(0xFF8DAAC7);
  }

  @override
  Widget build(BuildContext context) {
    final accent = _accentForToday(context);
    final scheme = Theme.of(context).colorScheme;
    final onSurface = scheme.onSurface;

    return Scaffold(
      // Soft gradient: top tinted by the current meta-season, fading
      // to the regular surface so the splash doesn't feel like a
      // separate page from AppShell.
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              accent.withValues(alpha: 0.22),
              scheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App logo — same engraving used as the iOS app icon.
                // The pulse keeps the breathing-while-loading feel
                // even though the unit-of-the-app glyph is gone.
                // Falls back to the kō kanji if the asset is missing.
                FadeTransition(
                  opacity: _pulseAnim,
                  child: SizedBox(
                    width: 140,
                    height: 140,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: Image.asset(
                        'assets/brand/appIcon.png',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Text(
                          '候',
                          style: TextStyle(
                            fontSize: 140,
                            fontWeight: FontWeight.w300,
                            color: accent,
                            height: 1.0,
                            letterSpacing: -2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Small caps subtitle — keeps the splash from feeling
                // like a logo screen with no context.
                Text(
                  'SHICHIJŪNI-KŌ',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 3.0,
                    color: onSurface.withValues(alpha: 0.55),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '72 сезони',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: onSurface.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
