import 'dart:io' show Platform;
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../data/seasons_repository.dart';
import '../models/season_models.dart';
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
    final wallNow = DateTime.now();
    final current = calc.currentAt();
    final all = repo.all;

    // Build a rolling list. Critical: start ONE BEFORE the current kō so
    // the first iteration considers the current kō itself. Without this
    // (the prior bug) `cancelAll()` above wipes the current kō's 9 AM
    // push, and the loop never re-adds it because it starts from the
    // *next* kō. Result: opening the app between midnight and 9 AM on a
    // boundary day silently kills today's notification.
    var idx = current.index - 1; // first `idx % 72 + 1` below lands on current.index
    if (idx < 0) idx = 71; // wrap when current = #1
    var year = now.year;
    var scheduled = 0;

    while (scheduled < _maxScheduled) {
      idx = idx % 72 + 1; // next kō (wrap 72 → 1)
      final ko = all[idx - 1];
      var start = ko.startDateForYear(year);
      // Compute the actual fire instant (9 AM local on start day) and
      // bump the year if it's already passed. The previous version
      // compared `start` (midnight) which incorrectly bumped the year
      // any time the user opened the app after 00:00 on a boundary
      // day — so the morning push got pushed 365 days into the future.
      var fireAtDt = DateTime(start.year, start.month, start.day, 9, 0);
      if (fireAtDt.isBefore(wallNow)) {
        year += 1;
        start = ko.startDateForYear(year);
        fireAtDt = DateTime(start.year, start.month, start.day, 9, 0);
      }

      final fireAt = tz.TZDateTime.from(fireAtDt, tz.local);

      final (title, body) = _buildSeasonNotificationText(ko, locale);

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

  /// Build the (title, body) pair shown in the notification banner for
  /// one kō. Single source of truth — used by both the production
  /// [scheduleUpcoming] path and the [showTestRealKoText] preview
  /// button in Settings, so the test pushes always match what a real
  /// one will look like (no copy drift).
  ///
  /// Each kō gets its OWN poetic title and body, drawn from the
  /// curated `nameUk/En` and `descUk/En` fields in `seasons.json`.
  /// The "Сьогодні · " / "Today · " prefix on the title signals this
  /// is the START of a new kō (push fires at 9 AM on day-1 of the
  /// 5-day window) — without resorting to the earlier generic copy.
  ///
  ///   • title: "Сьогодні · 🌸 Перший цвіт сакури"
  ///   • body:  "Тонкий рожевий цвіт відкривається уперше — головна
  ///            весняна подія."
  ///
  /// Result: each of the 72 push notifications becomes its own little
  /// haiku — unique copy, never repeating, with a one-word "this is
  /// happening NOW" framing baked into the title.
  (String, String) _buildSeasonNotificationText(
    MicroSeason ko,
    Locale locale,
  ) {
    final isUk = locale.languageCode == 'uk';
    final name = isUk ? ko.nameUk : ko.nameEn;
    final body = isUk ? ko.descriptionUk : ko.descriptionEn;
    final prefix = isUk ? 'Сьогодні' : 'Today';
    final title = '$prefix · ${ko.emoji} $name';
    return (title, body);
  }

  /// Returns pending notifications — useful for debugging / Settings.
  Future<List<PendingNotificationRequest>> pending() async {
    await init();
    return _plugin.pendingNotificationRequests();
  }

  // ─── Debug / smoke-test methods ─────────────────────────────────────
  //
  // Used by the temporary "DEBUG · СПОВІЩЕННЯ" section in Settings to
  // verify the push pipeline works end-to-end (permission → schedule
  // → OS-level fire). Test notifications use IDs 9998/9999 so they
  // never collide with the production kō IDs (1..72).

  /// Schedules a test notification 3 seconds from now and returns
  /// whether scheduling succeeded (i.e. permission is granted).
  ///
  /// 3-second delay is the minimum that reliably survives iOS's
  /// scheduling pipeline. 1-second delays were getting silently
  /// dropped because by the time the OS registered the schedule, the
  /// fire-time was already in the past. Caller should background the
  /// app within those 3 s to verify the banner-presentation path.
  Future<bool> showTestNow() => _scheduleTest(
        id: 9999,
        delay: const Duration(seconds: 3),
        title: 'Тест · через 3 с',
        body: 'Тестове сповіщення. '
            'Якщо бачиш у Notification Center — pipeline працює ✓',
      );

  /// Schedules a test notification [delay] from now. Useful for
  /// verifying delivery when the app is backgrounded or killed.
  Future<bool> scheduleTestIn({required Duration delay}) => _scheduleTest(
        id: 9998,
        delay: delay,
        title: 'Тест · відкладений',
        body: 'Запланований ${delay.inSeconds} с тому. '
            'Якщо прийшов — OS-handover works у фоні / killed state.',
      );

  /// Schedules a test notification 3 seconds from now using the SAME
  /// production text generation as [scheduleUpcoming] — but for one
  /// random kō (or a specific [koIndex] if passed). Lets the user
  /// preview how real season-change pushes will read, with a real
  /// kō name + index, without waiting weeks for the actual fire.
  ///
  /// The kō chosen is returned by reference in [pickedKoIndex] so the
  /// caller can show a SnackBar like "Preview: kō #N — Name".
  Future<({bool ok, int koIndex, String title, String body})> showTestRealKoText({
    required SeasonsRepository repo,
    required Locale locale,
    int? koIndex,
  }) async {
    final granted = await requestPermission();
    final all = repo.all;
    final ko = koIndex != null
        ? all[(koIndex - 1).clamp(0, all.length - 1)]
        : all[math.Random().nextInt(all.length)];
    final (title, body) = _buildSeasonNotificationText(ko, locale);
    if (!granted) {
      return (ok: false, koIndex: ko.index, title: title, body: body);
    }
    final fireAt =
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 3));
    await _plugin.zonedSchedule(
      9997, // dedicated test id for "real-text preview"
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
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
    return (ok: true, koIndex: ko.index, title: title, body: body);
  }

  Future<bool> _scheduleTest({
    required int id,
    required Duration delay,
    required String title,
    required String body,
  }) async {
    final granted = await requestPermission();
    if (!granted) return false;
    final fireAt = tz.TZDateTime.now(tz.local).add(delay);
    await _plugin.zonedSchedule(
      id,
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
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
    return true;
  }
}
