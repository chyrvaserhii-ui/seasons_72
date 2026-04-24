import 'dart:math' as math;

/// Lunar phase calculator.
///
/// Uses a compact Meeus-style approximation: compute the moon's age in
/// days since the last new moon, using a well-known reference new moon
/// and the mean synodic month length. Accuracy is ±few hours over a
/// 50-year horizon — plenty for a UI indicator; if we ever need
/// astronomy-grade precision we'd swap in a full Meeus Chapter 47
/// implementation.
///
/// No external dependencies on purpose — this is all computable from
/// DateTime and a cosine.
class MoonCalculator {
  MoonCalculator._();

  /// Mean length of a synodic month (new moon → new moon), in days.
  static const double synodicMonth = 29.530588853;

  /// A reference new moon: 2000-01-06 18:14 UTC.
  /// Source: Meeus, "Astronomical Algorithms", Table 47.A.
  static final DateTime _referenceNewMoon = DateTime.utc(2000, 1, 6, 18, 14);

  /// Compute everything for the given moment (default: now).
  static MoonInfo at([DateTime? when]) {
    final now = (when ?? DateTime.now()).toUtc();
    final age = _age(now);
    final phase = age / synodicMonth;
    final illumination = 0.5 * (1 - math.cos(2 * math.pi * phase));
    final isWaxing = phase < 0.5;
    final next = _nextEvents(age, now);
    return MoonInfo(
      moment: now,
      age: age,
      phase: phase,
      illumination: illumination,
      isWaxing: isWaxing,
      phaseName: _phaseFor(phase),
      nextNewMoon: next.newMoon,
      nextFullMoon: next.fullMoon,
    );
  }

  // ------------------------------------------------------------------------
  // Internals
  // ------------------------------------------------------------------------

  /// Age of the moon in days (0..29.53) at [now].
  static double _age(DateTime now) {
    final deltaDays = now.difference(_referenceNewMoon).inSeconds /
        Duration.secondsPerDay;
    final raw = deltaDays % synodicMonth;
    // `%` on negative numbers in Dart returns a non-negative result, but
    // belt-and-braces: guarantee it.
    return raw < 0 ? raw + synodicMonth : raw;
  }

  /// Next new/full moon after [now], given the current moon [age].
  static _NextEvents _nextEvents(double age, DateTime now) {
    final daysToNew = synodicMonth - age;
    final daysToFull = age < synodicMonth / 2
        ? synodicMonth / 2 - age
        : synodicMonth / 2 - age + synodicMonth;
    return _NextEvents(
      newMoon: now.add(_daysAsDuration(daysToNew)),
      fullMoon: now.add(_daysAsDuration(daysToFull)),
    );
  }

  static Duration _daysAsDuration(double days) {
    return Duration(seconds: (days * Duration.secondsPerDay).round());
  }

  /// Pick a named phase for a normalized phase value 0..1.
  ///
  /// Boundaries are the conventional "8 phase" split, each ~3.69 days,
  /// with narrow windows around the four cardinal phases (new / first
  /// quarter / full / last quarter).
  static MoonPhaseName _phaseFor(double p) {
    if (p < 0.03 || p >= 0.97) return MoonPhaseName.newMoon;
    if (p < 0.22) return MoonPhaseName.waxingCrescent;
    if (p < 0.28) return MoonPhaseName.firstQuarter;
    if (p < 0.47) return MoonPhaseName.waxingGibbous;
    if (p < 0.53) return MoonPhaseName.fullMoon;
    if (p < 0.72) return MoonPhaseName.waningGibbous;
    if (p < 0.78) return MoonPhaseName.lastQuarter;
    return MoonPhaseName.waningCrescent;
  }
}

/// Immutable snapshot of the moon at a given instant.
class MoonInfo {
  const MoonInfo({
    required this.moment,
    required this.age,
    required this.phase,
    required this.illumination,
    required this.isWaxing,
    required this.phaseName,
    required this.nextNewMoon,
    required this.nextFullMoon,
  });

  /// The UTC instant this info was computed for.
  final DateTime moment;

  /// Days since the last new moon (0 .. ~29.53).
  final double age;

  /// Normalized phase 0..1, where 0=new, 0.5=full, 1→0=new.
  final double phase;

  /// Visible illumination fraction 0..1 (0 at new, 1 at full).
  final double illumination;

  /// True while the moon is growing (new → full).
  final bool isWaxing;

  /// Named phase bucket, for labels & glyphs.
  final MoonPhaseName phaseName;

  /// Next new moon after [moment] (UTC).
  final DateTime nextNewMoon;

  /// Next full moon after [moment] (UTC).
  final DateTime nextFullMoon;

  /// Emoji glyph for the phase. Handy as a fallback.
  String get emoji {
    switch (phaseName) {
      case MoonPhaseName.newMoon:
        return '🌑';
      case MoonPhaseName.waxingCrescent:
        return '🌒';
      case MoonPhaseName.firstQuarter:
        return '🌓';
      case MoonPhaseName.waxingGibbous:
        return '🌔';
      case MoonPhaseName.fullMoon:
        return '🌕';
      case MoonPhaseName.waningGibbous:
        return '🌖';
      case MoonPhaseName.lastQuarter:
        return '🌗';
      case MoonPhaseName.waningCrescent:
        return '🌘';
    }
  }
}

enum MoonPhaseName {
  newMoon,
  waxingCrescent,
  firstQuarter,
  waxingGibbous,
  fullMoon,
  waningGibbous,
  lastQuarter,
  waningCrescent,
}

class _NextEvents {
  const _NextEvents({required this.newMoon, required this.fullMoon});
  final DateTime newMoon;
  final DateTime fullMoon;
}
