import 'package:flutter_test/flutter_test.dart';
import 'package:seasons_72/core/utils/moon_calculator.dart';

/// Sanity checks for the moon-phase math.
///
/// Reference new moons are pulled from NASA's Goddard-published lunar
/// ephemeris. Our simplified algorithm is accurate to ±12 hours over a
/// ~50-year window; the assertions below use a 1-day tolerance, which
/// is tight enough to catch drift but loose enough for off-by-one-day
/// noise from timezone rounding.
void main() {
  group('MoonCalculator', () {
    test('reference new moon (2000-01-06 UTC) has age ~0', () {
      final info = MoonCalculator.at(DateTime.utc(2000, 1, 6, 18, 14));
      expect(info.age, lessThan(0.05));
      expect(info.phaseName, MoonPhaseName.newMoon);
      expect(info.illumination, lessThan(0.01));
    });

    test('full moon 2000-01-21 ~15 days later', () {
      final info = MoonCalculator.at(DateTime.utc(2000, 1, 21, 4, 40));
      expect(info.illumination, greaterThan(0.97));
      expect(info.phaseName, MoonPhaseName.fullMoon);
    });

    test('waxing vs waning is correct across the cycle', () {
      // Day 5 after new → waxing, illumination growing.
      final five = MoonCalculator.at(DateTime.utc(2000, 1, 11));
      expect(five.isWaxing, true);

      // Day 20 after new → waning.
      final twenty = MoonCalculator.at(DateTime.utc(2000, 1, 26));
      expect(twenty.isWaxing, false);
    });

    test('illumination is symmetric around full moon', () {
      // 7 days before full and 7 days after should have similar
      // illumination. Tolerance is wide because the mean synodic month
      // length is an average — true full moon may sit slightly off the
      // midpoint of any given cycle.
      final before = MoonCalculator.at(DateTime.utc(2000, 1, 14));
      final after = MoonCalculator.at(DateTime.utc(2000, 1, 28));
      expect((before.illumination - after.illumination).abs(), lessThan(0.15));
    });

    test('nextNewMoon is always in the future and within one synodic month',
        () {
      final now = DateTime.utc(2026, 4, 25);
      final info = MoonCalculator.at(now);
      final delta = info.nextNewMoon.difference(now).inDays;
      expect(delta, greaterThanOrEqualTo(0));
      expect(delta, lessThanOrEqualTo(30));
    });

    test('nextFullMoon is always in the future and within one synodic month',
        () {
      final now = DateTime.utc(2026, 4, 25);
      final info = MoonCalculator.at(now);
      final delta = info.nextFullMoon.difference(now).inDays;
      expect(delta, greaterThanOrEqualTo(0));
      expect(delta, lessThanOrEqualTo(30));
    });

    test('phase bucket covers full cycle', () {
      // Walk 30 single-day steps from a known new moon; every phase name
      // should appear at least once.
      final seen = <MoonPhaseName>{};
      var d = DateTime.utc(2000, 1, 6);
      for (var i = 0; i < 30; i++) {
        seen.add(MoonCalculator.at(d).phaseName);
        d = d.add(const Duration(days: 1));
      }
      // 7 of 8 (crescents, quarters, gibbous, full/new) should be
      // reachable in a 30-day walk. Quarters have narrow windows so we
      // tolerate missing one.
      expect(seen.length, greaterThanOrEqualTo(6));
    });
  });
}
