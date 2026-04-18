import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seasons_72/l10n/app_localizations.dart';

import 'core/settings/settings_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/widget/widget_sync.dart';
import 'features/shell/app_shell.dart';

class SeasonsApp extends ConsumerWidget {
  const SeasonsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    // Keeps the home-screen widget in sync with app state. Side-effect only.
    ref.watch(widgetSyncProvider);

    return MaterialApp(
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
