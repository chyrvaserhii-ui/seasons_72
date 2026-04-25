import 'dart:io' show Platform;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';

import '../data/seasons_repository.dart';
import '../models/season_models.dart';
import '../utils/moon_calculator.dart';
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

  /// App Group identifier — must match the iOS widget target. Personal
  /// Team accounts can't claim arbitrary group IDs (the `com.seasons72`
  /// prefix conflicted), so we use a developer-unique reverse-DNS
  /// derived from the Apple ID. If you fork this app, change this to
  /// your own prefix and update `Runner.entitlements`,
  /// `SeasonsWidget.entitlements`, `SeasonsWidget.swift` Const, and
  /// `AppDelegate.swift` kAppGroupId in lockstep.
  static const String appGroupId = 'group.chyrva.seasons72';

  /// Widget kind name — must match the Swift widget's `kind:` string and
  /// Android provider class name.
  static const String widgetName = 'SeasonsWidget';
  static const String iOSWidgetName = 'SeasonsWidget';

  /// MethodChannel used on iOS to copy engraving PNGs into the App Group
  /// container. Implemented in `ios/Runner/AppDelegate.swift`.
  static const MethodChannel _engravingChannel =
      MethodChannel('seasons72/widget/engraving');

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
    final previous = calc.previous(current);
    final meta = repo.meta(current.metaId);
    final sekki = repo.sekki(current.sekkiId);
    final daysUntilNext = calc.daysUntilNext(current);

    final isUk = locale.languageCode == 'uk';
    final name = isUk ? current.nameUk : current.nameEn;
    final nextName = isUk ? next.nameUk : next.nameEn;
    final previousName = isUk ? previous.nameUk : previous.nameEn;
    final sekkiName = isUk ? sekki.nameUk : sekki.nameEn;
    final metaName = isUk ? meta.nameUk : meta.nameEn;

    // Section / countdown labels that the Swift widget would otherwise
    // hardcode. Sending them from Dart keeps locale handling in one
    // place and avoids the "header in UA, body in EN" mix when the
    // device language has no UA fallback.
    final prevLabel = isUk ? 'ПОПЕРЕДНІЙ' : 'PREVIOUS';
    final nextLabel = isUk ? 'НАСТУПНИЙ' : 'NEXT';
    final countdownLong = _countdownLong(daysUntilNext, isUk);
    final countdownShort = _countdownShort(daysUntilNext, isUk);
    final lockScreenCountdown = _lockScreenCountdown(daysUntilNext, isUk);

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
      HomeWidget.saveWidgetData<int>('nextIndex', next.index),
      HomeWidget.saveWidgetData<String>('nextName', nextName),
      HomeWidget.saveWidgetData<String>('nextKanji', next.kanji),
      HomeWidget.saveWidgetData<String>('nextEmoji', next.emoji),
      HomeWidget.saveWidgetData<int>('previousIndex', previous.index),
      HomeWidget.saveWidgetData<String>('previousName', previousName),
      HomeWidget.saveWidgetData<String>('previousKanji', previous.kanji),
      HomeWidget.saveWidgetData<String>('previousEmoji', previous.emoji),
      // Localized section / countdown labels (Swift widget reads these
      // verbatim — see SeasonEntry.* in SeasonsWidget.swift).
      HomeWidget.saveWidgetData<String>('prevLabel', prevLabel),
      HomeWidget.saveWidgetData<String>('nextLabel', nextLabel),
      HomeWidget.saveWidgetData<String>('countdownLong', countdownLong),
      HomeWidget.saveWidgetData<String>('countdownShort', countdownShort),
      HomeWidget.saveWidgetData<String>(
          'lockScreenCountdown', lockScreenCountdown),
      // Moon phase — widget renders a small glyph; math matches
      // lib/core/utils/moon_calculator.dart. Stored as doubles so the
      // Swift side can recompute illumination and pick waxing/waning.
      ..._moonKV(),
    ]);

    // Copy ukiyo-e engravings for current / next / previous into the
    // shared App Group container. Done in parallel; failures are
    // logged but don't block the widget update — the Swift side falls
    // back to emoji rendering when a file is missing.
    await _copyEngravings(current: current, next: next, previous: previous);

    await HomeWidget.updateWidget(
      name: widgetName,
      iOSName: iOSWidgetName,
    );
  }

  /// Pushes three PNGs (current / next / previous kō) into the iOS App
  /// Group container so the widget can render the actual ukiyo-e
  /// illustration instead of an emoji placeholder.
  Future<void> _copyEngravings({
    required MicroSeason current,
    required MicroSeason next,
    required MicroSeason previous,
  }) async {
    if (!Platform.isIOS) return;
    await Future.wait([
      _pushEngraving(current.index, 'engraving_current'),
      _pushEngraving(next.index, 'engraving_next'),
      _pushEngraving(previous.index, 'engraving_previous'),
    ]);
  }

  Future<void> _pushEngraving(int seasonIndex, String key) async {
    try {
      final data = await rootBundle.load('assets/images/ko/$seasonIndex.png');
      await _engravingChannel.invokeMethod('copy', {
        'key': key,
        'bytes': data.buffer.asUint8List(),
      });
    } catch (e, st) {
      // Non-fatal — widget falls back to emoji. Log so we see this in
      // flutter run output.
      debugPrint('WidgetService: failed to copy engraving $seasonIndex ($key): $e\n$st');
    }
  }

  String _hex(Color c) {
    // ARGB integer via toARGB32 to avoid deprecated .value
    final v = c.toARGB32() & 0x00FFFFFF;
    return '#${v.toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }

  /// "Наступний сезон через 5 днів" / "Next season in 5 days"
  /// Used in Medium widget below the kō name.
  String _countdownLong(int days, bool isUk) {
    if (days == 0) {
      return isUk ? 'Останній день цього сезону' : 'Last day of this season';
    }
    if (isUk) {
      final mod10 = days % 10;
      final mod100 = days % 100;
      String unit;
      if (mod10 == 1 && mod100 != 11) {
        unit = 'день';
      } else if ((2 <= mod10 && mod10 <= 4) && !(12 <= mod100 && mod100 <= 14)) {
        unit = 'дні';
      } else {
        unit = 'днів';
      }
      return 'Наступний сезон через $days $unit';
    }
    return days == 1 ? 'Next season in 1 day' : 'Next season in $days days';
  }

  /// "1 день" / "5 дн." / "1 day" / "5 days" — used in Small widget.
  String _countdownShort(int days, bool isUk) {
    if (days == 0) return isUk ? 'Останній день' : 'Last day';
    if (isUk) {
      final mod10 = days % 10;
      final mod100 = days % 100;
      String unit;
      if (mod10 == 1 && mod100 != 11) {
        unit = 'день';
      } else if ((2 <= mod10 && mod10 <= 4) && !(12 <= mod100 && mod100 <= 14)) {
        unit = 'дні';
      } else {
        unit = 'днів';
      }
      return '$days $unit';
    }
    return days == 1 ? '1 day' : '$days days';
  }

  /// "Залишилось 5 днів" / "5 days left" — Lock-screen widget.
  String _lockScreenCountdown(int days, bool isUk) {
    if (days == 0) return isUk ? 'Останній день' : 'Last day';
    if (isUk) {
      final mod10 = days % 10;
      final mod100 = days % 100;
      if (mod10 == 1 && mod100 != 11) return 'Залишився $days день';
      if ((2 <= mod10 && mod10 <= 4) && !(12 <= mod100 && mod100 <= 14)) {
        return 'Залишилось $days дні';
      }
      return 'Залишилось $days днів';
    }
    return days == 1 ? '1 day left' : '$days days left';
  }

  /// Returns a batch of saveWidgetData calls that push the current
  /// moon's phase into shared storage. Called as `..._moonKV()` inside
  /// `Future.wait([...])`. Return type mirrors `HomeWidget.saveWidgetData`.
  List<Future<bool?>> _moonKV() {
    final m = MoonCalculator.at();
    return [
      HomeWidget.saveWidgetData<double>('moonPhase', m.phase),
      HomeWidget.saveWidgetData<double>('moonIllumination', m.illumination),
      HomeWidget.saveWidgetData<int>('moonIsWaxing', m.isWaxing ? 1 : 0),
    ];
  }
}
