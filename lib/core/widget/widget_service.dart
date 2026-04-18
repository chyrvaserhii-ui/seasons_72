import 'dart:ui';

import 'package:home_widget/home_widget.dart';

import '../data/seasons_repository.dart';
import '../utils/season_calculator.dart';

/// Pushes the current kō's data into the iOS/Android home-screen widget.
///
/// iOS widgets can't reach the Flutter app at render time — they read from
/// a shared container (App Group on iOS, SharedPreferences on Android).
/// We write plain strings here; the native widget reads them back in its
/// own timeline provider.
///
/// The group id must match what the widget extension declares in its
/// entitlements. On Android the group id is ignored.
class WidgetService {
  WidgetService._();
  static final WidgetService instance = WidgetService._();

  /// App Group identifier — must match the iOS widget target.
  static const String appGroupId = 'group.com.seasons72.shared';

  /// Widget kind name — must match the Swift widget's `kind:` string and
  /// Android provider class name.
  static const String widgetName = 'SeasonsWidget';
  static const String iOSWidgetName = 'SeasonsWidget';

  bool _initialized = false;

  Future<void> _ensureInit() async {
    if (_initialized) return;
    await HomeWidget.setAppGroupId(appGroupId);
    _initialized = true;
  }

  /// Write the current kō's data to the shared container and trigger a
  /// widget refresh. Called on app start and whenever the current kō
  /// changes (roughly every 5 days).
  Future<void> updateForCurrentSeason({
    required Locale locale,
    required SeasonsRepository repo,
    required SeasonCalculator calc,
  }) async {
    await _ensureInit();

    final current = calc.currentAt();
    final next = calc.next(current);
    final meta = repo.meta(current.metaId);
    final sekki = repo.sekki(current.sekkiId);
    final daysUntilNext = calc.daysUntilNext(current);

    final isUk = locale.languageCode == 'uk';
    final name = isUk ? current.nameUk : current.nameEn;
    final nextName = isUk ? next.nameUk : next.nameEn;
    final sekkiName = isUk ? sekki.nameUk : sekki.nameEn;
    final metaName = isUk ? meta.nameUk : meta.nameEn;

    // Save flat key/value pairs. Widget reads these from UserDefaults
    // via the shared App Group.
    await Future.wait([
      HomeWidget.saveWidgetData<int>('index', current.index),
      HomeWidget.saveWidgetData<String>('kanji', current.kanji),
      HomeWidget.saveWidgetData<String>('romaji', current.romaji),
      HomeWidget.saveWidgetData<String>('name', name),
      HomeWidget.saveWidgetData<String>('emoji', current.emoji),
      HomeWidget.saveWidgetData<String>('sekki', sekkiName),
      HomeWidget.saveWidgetData<String>('sekkiKanji', sekki.kanji),
      HomeWidget.saveWidgetData<String>('meta', metaName),
      HomeWidget.saveWidgetData<String>('metaColorHex', _hex(meta.colorLight)),
      HomeWidget.saveWidgetData<int>('daysUntilNext', daysUntilNext),
      HomeWidget.saveWidgetData<String>('nextName', nextName),
      HomeWidget.saveWidgetData<String>('nextKanji', next.kanji),
      HomeWidget.saveWidgetData<String>('nextEmoji', next.emoji),
    ]);

    await HomeWidget.updateWidget(
      name: widgetName,
      iOSName: iOSWidgetName,
    );
  }

  String _hex(Color c) {
    // ARGB integer via toARGB32 to avoid deprecated .value
    final v = c.toARGB32() & 0x00FFFFFF;
    return '#${v.toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }
}
