import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifications/notification_service.dart';
import '../providers/seasons_providers.dart';
import '../settings/settings_provider.dart';
import 'widget_service.dart';

/// Riverpod side-effect: rewrites home-screen widget data whenever the
/// current kō changes or the user switches language. Also re-schedules
/// pending season-change notifications if the user has them enabled —
/// keeps the queue fresh after language switches or data reloads.
///
/// Nothing consumes its output — we only want the `ref.listen` call
/// chain to register.
///
/// Usage (in app.dart):
///   ref.watch(widgetSyncProvider);
final widgetSyncProvider = Provider<void>((ref) {
  ref.listen(currentSeasonProvider, (prev, next) {
    next.whenData((_) => _push(ref));
  });
  ref.listen(settingsProvider, (prev, next) {
    if (prev?.locale != next.locale) _push(ref);
  });
  Future.microtask(() => _push(ref));
});

Future<void> _push(Ref ref) async {
  final repo = ref.read(seasonsRepositoryProvider);
  final calc = ref.read(seasonCalculatorProvider);
  final settings = ref.read(settingsProvider);
  // Fall back to device locale if user hasn't explicitly chosen one.
  final locale = settings.locale ??
      WidgetsBinding.instance.platformDispatcher.locale;

  await WidgetService.instance.updateForCurrentSeason(
    locale: locale,
    repo: repo,
    calc: calc,
  );

  // If the user has notifications enabled, keep the queue up to date.
  if (settings.notifyOnSeasonChange) {
    await NotificationService.instance.scheduleUpcoming(
      repo: repo,
      calc: calc,
      locale: locale,
    );
  }
}
