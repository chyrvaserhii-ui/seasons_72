import '../data/seasons_repository.dart';
import '../models/season_models.dart';

/// Resolves which micro-season a given moment belongs to,
/// and produces prev/next season context.
///
/// NOTE: the dataset uses averaged date ranges (±1 day accuracy).
/// For precise astronomical ko dates, a future improvement is to
/// compute solar longitudes; see BRAINSTORM.md "Варіант B".
class SeasonCalculator {
  SeasonCalculator(this._repo);
  final SeasonsRepository _repo;

  /// Returns the micro-season active at [now] (defaults to DateTime.now()).
  MicroSeason currentAt([DateTime? now]) {
    final dt = now ?? DateTime.now();
    final all = _repo.all;
    for (final k in all) {
      if (_contains(k, dt)) return k;
    }
    // Fallback — shouldn't happen because the 72 ko cover the full year,
    // but if the averaged dates have a one-day gap around a year edge,
    // we fall back to the nearest-by-start ko.
    return _nearest(all, dt);
  }

  /// Returns the ko that comes right after [current] in calendar order.
  MicroSeason next(MicroSeason current) {
    final all = _repo.all;
    final i = current.index - 1;
    return all[(i + 1) % all.length];
  }

  /// Returns the ko that comes right before [current].
  MicroSeason previous(MicroSeason current) {
    final all = _repo.all;
    final i = current.index - 1;
    return all[(i - 1 + all.length) % all.length];
  }

  /// Progress (0.0–1.0) through the current ko at [now].
  double progress(MicroSeason current, [DateTime? now]) {
    final dt = now ?? DateTime.now();
    final year = dt.year;

    final start = current.startDateForYear(year);
    final end = current.endDateForYear(year);

    // Handle year boundary for ko 66 (Dec → Jan).
    DateTime effectiveStart = start;
    DateTime effectiveEnd = end;
    if (!_contains(current, dt)) {
      // Maybe we're in the previous-year instance of this ko.
      final prevYearStart = current.startDateForYear(year - 1);
      final prevYearEnd = current.endDateForYear(year - 1);
      if (!dt.isBefore(prevYearStart) && !dt.isAfter(prevYearEnd)) {
        effectiveStart = prevYearStart;
        effectiveEnd = prevYearEnd;
      }
    }

    final total = effectiveEnd.difference(effectiveStart).inSeconds;
    if (total <= 0) return 0.0;
    final elapsed = dt.difference(effectiveStart).inSeconds;
    return (elapsed / total).clamp(0.0, 1.0);
  }

  /// Days remaining until the next ko begins, at [now].
  int daysUntilNext(MicroSeason current, [DateTime? now]) {
    final dt = now ?? DateTime.now();
    final next = this.next(current);
    var nextStart = next.startDateForYear(dt.year);
    if (nextStart.isBefore(dt)) {
      nextStart = next.startDateForYear(dt.year + 1);
    }
    final diff = nextStart.difference(DateTime(dt.year, dt.month, dt.day));
    return diff.inDays.abs();
  }

  bool _contains(MicroSeason k, DateTime dt) {
    // For the year-crossing ko (index 66: Dec 22–Jan 4, represented as
    // start Jan 1 — see JSON), check current and adjacent year windows.
    for (final y in [dt.year - 1, dt.year, dt.year + 1]) {
      final start = k.startDateForYear(y);
      final end = k.endDateForYear(y);
      if (!dt.isBefore(start) && !dt.isAfter(end)) return true;
    }
    return false;
  }

  MicroSeason _nearest(List<MicroSeason> all, DateTime dt) {
    MicroSeason? best;
    int bestDelta = 1 << 30;
    for (final k in all) {
      for (final y in [dt.year - 1, dt.year, dt.year + 1]) {
        final start = k.startDateForYear(y);
        final delta = start.difference(dt).inDays.abs();
        if (delta < bestDelta) {
          bestDelta = delta;
          best = k;
        }
      }
    }
    return best!;
  }
}
