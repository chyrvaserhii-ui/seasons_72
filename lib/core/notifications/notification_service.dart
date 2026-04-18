import 'dart:io' show Platform;
import 'dart:ui';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../data/seasons_repository.dart';
import '../utils/season_calculator.dart';

/// Wraps `flutter_local_notifications` for the seasons app. On first use
/// we initialize the plugin + timezone database, ask for permission, then
/// schedule one notification at the start of each upcoming kō.
///
/// Notifications are pre-scheduled by the OS — the app does not need to
/// run in the background. iOS caps pending notifications at 64, so we
/// schedule only the next ~60 kō (≈ 10 months ahead). On every app launch
/// we refresh the schedule.
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _inited = false;

  /// iOS cap is 64 pending; we stay a bit under.
  static const int _maxScheduled = 60;

  static const _channelId = 'seasons_channel';
  static const _channelName = 'Season changes';
  static const _channelDesc = 'Notified when a new kō begins';

  Future<void> init() async {
    if (_inited) return;
    tz_data.initializeTimeZones();

    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        // We'll request permission explicitly when the user opts in.
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );
    await _plugin.initialize(initSettings);
    _inited = true;
  }

  /// Ask the user for permission. Call this when the user flips the
  /// notifications toggle ON. Returns true if permission is granted.
  Future<bool> requestPermission() async {
    await init();
    if (Platform.isIOS) {
      final ios = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      final granted = await ios?.requestPermissions(
            alert: true,
            badge: false,
            sound: true,
          ) ??
          false;
      return granted;
    }
    if (Platform.isAndroid) {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      // Android 13+ requires runtime permission; earlier versions auto-grant.
      final granted = await android?.requestNotificationsPermission() ?? true;
      return granted;
    }
    return false;
  }

  /// Schedule one notification at the start of each upcoming kō (up to
  /// [_maxScheduled] ahead). Existing scheduled notifications are
  /// cancelled first so re-scheduling is idempotent.
  Future<void> scheduleUpcoming({
    required SeasonsRepository repo,
    required SeasonCalculator calc,
    required Locale locale,
  }) async {
    await init();
    await cancelAll();

    final now = tz.TZDateTime.now(tz.local);
    final current = calc.currentAt();
    final all = repo.all;

    // Build a rolling list starting from the next kō after the current one.
    var idx = current.index; // 1..72
    var year = now.year;
    var scheduled = 0;

    while (scheduled < _maxScheduled) {
      idx = idx % 72 + 1; // next kō (wrap 72 → 1)
      final ko = all[idx - 1];
      var start = ko.startDateForYear(year);
      // If we've wrapped past Dec 31 → the next occurrence is next year.
      if (start.isBefore(DateTime.now())) {
        year += 1;
        start = ko.startDateForYear(year);
      }

      final fireAt = tz.TZDateTime.from(
        DateTime(start.year, start.month, start.day, 9, 0), // 9:00 local
        tz.local,
      );

      final isUk = locale.languageCode == 'uk';
      final title = isUk ? 'Новий сезон' : 'A new season';
      final name = isUk ? ko.nameUk : ko.nameEn;
      final body = '#${ko.index} · ${ko.kanji} · $name';

      await _plugin.zonedSchedule(
        ko.index, // reuse index as notification id (stable across runs)
        title,
        body,
        fireAt,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: _channelDesc,
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: false,
            presentSound: true,
          ),
        ),
        // iOS: interpret fire time in absolute UTC — no shift when the
        // user's local timezone changes (seasons are tied to wall-clock
        // calendar dates, so this is fine for our use).
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: ko.index.toString(),
      );

      scheduled++;

      // When we loop back past #72 inside a calendar year, bump the year
      // so next iteration schedules for the following year.
      if (idx == 72) year += 1;
    }
  }

  Future<void> cancelAll() async {
    await init();
    await _plugin.cancelAll();
  }

  /// Returns pending notifications — useful for debugging / Settings.
  Future<List<PendingNotificationRequest>> pending() async {
    await init();
    return _plugin.pendingNotificationRequests();
  }
}
