import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seasons_72/l10n/app_localizations.dart';

import 'core/settings/settings_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/widget/deep_link_handler.dart';
import 'core/widget/widget_sync.dart';
import 'features/shell/app_shell.dart';

class SeasonsApp extends ConsumerStatefulWidget {
  const SeasonsApp({super.key});

  @override
  ConsumerState<SeasonsApp> createState() => _SeasonsAppState();
}

class _SeasonsAppState extends ConsumerState<SeasonsApp> {
  /// Stable navigator key so [DeepLinkHandler] can push routes from
  /// outside the widget tree (e.g. cold launch via widget tap).
  final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    DeepLinkHandler.instance.bind(_navKey);
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    // Keeps the home-screen widget in sync with app state. Side-effect only.
    ref.watch(widgetSyncProvider);

    return MaterialApp(
      navigatorKey: _navKey,
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (ctx) => AppLocalizations.of(ctx)!.appTitle,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: settings.themeMode,
      locale: settings.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const AppShell(),
    );
  }
}
