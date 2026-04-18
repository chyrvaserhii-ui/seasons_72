import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/seasons_repository.dart';
import '../models/season_models.dart';
import '../utils/season_calculator.dart';

/// Repository provider — relies on [SeasonsRepository.load] being called
/// in `main()` before `runApp`.
final seasonsRepositoryProvider = Provider<SeasonsRepository>((ref) {
  return SeasonsRepository.instance;
});

final seasonCalculatorProvider = Provider<SeasonCalculator>((ref) {
  return SeasonCalculator(ref.watch(seasonsRepositoryProvider));
});

/// Emits the current micro-season. Re-evaluates once per minute so the
/// Home screen's countdown and progress bar stay fresh without being jittery.
final currentSeasonProvider = StreamProvider<MicroSeason>((ref) async* {
  final calc = ref.watch(seasonCalculatorProvider);
  yield calc.currentAt();
  yield* Stream<MicroSeason>.periodic(
    const Duration(minutes: 1),
    (_) => calc.currentAt(),
  );
});

final allSeasonsProvider = Provider<List<MicroSeason>>((ref) {
  return ref.watch(seasonsRepositoryProvider).all;
});
