import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/settings/settings_provider.dart';
import '../shell/app_shell.dart';
import 'onboarding_screen.dart';
import 'splash_screen.dart';

/// Top-level router that decides what the first screen is on every
/// app start. The flow:
///
///   1. Show [SplashScreen] for at least [_minSplash]. This gives
///      SharedPreferences and SeasonsRepository a moment to settle,
///      and it's also a deliberate "set the tone" beat for cold
///      launches — the splash kanji is too pretty to flash for 50ms.
///   2. After the splash beat, look at [AppSettings.hasSeenOnboarding]
///      from the loaded settings. If false (fresh install), push
///      [OnboardingScreen]; otherwise push [AppShell]. Either way we
///      use a fade transition so the splash dissolves into the next
///      surface rather than cutting hard.
///
/// The router also reacts when the user resets the onboarding flag
/// from Settings — when [hasSeenOnboarding] flips back to false,
/// onboarding is shown again. This is what powers the
/// "Show onboarding again" entry in Settings.
class RootRouter extends ConsumerStatefulWidget {
  const RootRouter({super.key});

  /// Minimum visible duration of the splash. Set deliberately long
  /// (2.5s) so the splash actually registers; once everything feels
  /// solid it can be brought down to ~800ms.
  static const Duration _minSplash = Duration(milliseconds: 2500);

  @override
  ConsumerState<RootRouter> createState() => _RootRouterState();
}

class _RootRouterState extends ConsumerState<RootRouter> {
  bool _splashFinished = false;

  @override
  void initState() {
    super.initState();
    Timer(RootRouter._minSplash, () {
      if (!mounted) return;
      setState(() => _splashFinished = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);

    // Until both splash beat AND settings load have completed, keep
    // showing splash — settings.isLoaded gates the onboarding decision
    // so we don't briefly flash the wrong screen for returning users.
    final showSplash = !_splashFinished || !settings.isLoaded;

    Widget body;
    if (showSplash) {
      body = const SplashScreen();
    } else if (!settings.hasSeenOnboarding) {
      body = const OnboardingScreen();
    } else {
      body = const AppShell();
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 420),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: KeyedSubtree(
        key: ValueKey(body.runtimeType),
        child: body,
      ),
    );
  }
}
