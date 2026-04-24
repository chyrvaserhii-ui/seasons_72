import 'dart:async';

import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

import '../../features/detail/season_detail_screen.dart';
import 'widget_service.dart';

/// Bridges widget taps into in-app navigation.
///
/// When the user taps the home-screen widget (or an accessoryRectangular
/// lockscreen widget), iOS launches the app with a URL of the form
/// `seasons72://season/<index>`. The `home_widget` package surfaces this
/// URL via:
///   * `HomeWidget.initiallyLaunchedFromHomeWidget()` — cold-start case
///   * `HomeWidget.widgetClicked` stream — warm/background case
///
/// This handler subscribes to both and pushes a detail screen onto the
/// root navigator. It's a singleton because the subscriptions need to
/// live for the full app lifetime, but it must be initialized from
/// somewhere that has a [NavigatorState] handle — so [navigatorKey]
/// is provided by the app and passed in via [bind].
class DeepLinkHandler {
  DeepLinkHandler._();
  static final DeepLinkHandler instance = DeepLinkHandler._();

  StreamSubscription<Uri?>? _sub;
  GlobalKey<NavigatorState>? _navigatorKey;
  bool _initialLaunchChecked = false;

  /// Wire the handler to the app's navigator. Safe to call multiple times
  /// — only the first call subscribes; subsequent calls swap the key.
  void bind(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;

    _sub ??= HomeWidget.widgetClicked.listen(_handleUri);

    if (!_initialLaunchChecked) {
      _initialLaunchChecked = true;
      // `initiallyLaunchedFromHomeWidget` and `widgetClicked` both need
      // an AppGroup id set first on iOS, otherwise the method channel
      // throws. Set it before probing the cold-launch URL.
      HomeWidget.setAppGroupId(WidgetService.appGroupId).then((_) {
        // Cold launch: iOS handed us a URL as the launch trigger. Delay
        // by a frame so the navigator is fully mounted before pushing.
        HomeWidget.initiallyLaunchedFromHomeWidget().then((uri) {
          if (uri != null) {
            WidgetsBinding.instance
                .addPostFrameCallback((_) => _handleUri(uri));
          }
        });
      });
    }
  }

  void dispose() {
    _sub?.cancel();
    _sub = null;
  }

  void _handleUri(Uri? uri) {
    if (uri == null) return;
    // Expected shape: seasons72://season/<index>
    final segs = uri.pathSegments;
    if (uri.scheme != 'seasons72' || uri.host != 'season' || segs.isEmpty) {
      return;
    }
    final idx = int.tryParse(segs.first);
    if (idx == null || idx < 1 || idx > 72) return;

    final nav = _navigatorKey?.currentState;
    if (nav == null) return;
    nav.push(MaterialPageRoute(
      builder: (_) => SeasonDetailScreen(seasonIndex: idx),
    ));
  }
}
