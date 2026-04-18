import 'package:flutter_test/flutter_test.dart';
import 'package:seasons_72/core/data/seasons_repository.dart';
import 'package:seasons_72/core/utils/season_calculator.dart';

/// These tests confirm that the date-ranges cover the full year and
/// that the resolver picks the expected kō for several sample dates.
///
/// Run with: flutter test
void main() {
  late SeasonCalculator calc;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await SeasonsRepository.instance.load();
    calc = SeasonCalculator(SeasonsRepository.instance);
  });

  test('all 72 kō are loaded with sequential indexes', () {
    final all = SeasonsRepository.instance.all;
    expect(all.length, 72);
    for (var i = 0; i < 72; i++) {
      expect(all[i].index, i + 1);
    }
  });

  test('Feb 5 resolves to the first kō (Harukaze kōri o toku)', () {
    final current = calc.currentAt(DateTime(2026, 2, 5, 12));
    expect(current.index, 1);
    expect(current.romaji, 'Harukaze kōri o toku');
  });

  test('March 28 resolves to the Sakura kō (#11)', () {
    final current = calc.currentAt(DateTime(2026, 3, 28, 12));
    expect(current.index, 11);
    expect(current.kanji, '桜始開');
  });

  test('December 25 resolves to the winter solstice kō', () {
    // Dec 22–26 is #64 Natsu karekusa shōzu.
    final current = calc.currentAt(DateTime(2026, 12, 25, 12));
    expect(current.index, 64);
  });

  test('January 3 resolves to the year-crossing kō (#66)', () {
    final current = calc.currentAt(DateTime(2027, 1, 3, 12));
    expect(current.index, 66);
  });

  test('next() wraps around from #72 to #1', () {
    final last = SeasonsRepository.instance.byIndex(72);
    final next = calc.next(last);
    expect(next.index, 1);
  });

  test('previous() wraps around from #1 to #72', () {
    final first = SeasonsRepository.instance.byIndex(1);
    final prev = calc.previous(first);
    expect(prev.index, 72);
  });

  test('progress is between 0.0 and 1.0 on the last day', () {
    final k = SeasonsRepository.instance.byIndex(11); // Sakura
    final p = calc.progress(k, DateTime(2026, 3, 30, 12));
    expect(p, greaterThanOrEqualTo(0.0));
    expect(p, lessThanOrEqualTo(1.0));
  });
}
