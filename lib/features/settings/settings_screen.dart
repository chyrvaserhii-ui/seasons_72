import 'package:flutter/material.dart';
import 'package:seasons_72/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/notifications/notification_service.dart';
import '../../core/providers/seasons_providers.dart';
import '../../core/settings/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: [
        _SectionHeader(l10n.settingsLanguage),
        RadioGroup<Locale?>(
          groupValue: settings.locale,
          onChanged: (v) => notifier.setLocale(v),
          child: Column(
            children: [
              RadioListTile<Locale?>(
                title: Text(l10n.settingsLanguageSystem),
                value: null,
              ),
              RadioListTile<Locale?>(
                title: Text(l10n.settingsLanguageEnglish),
                value: const Locale('en'),
              ),
              RadioListTile<Locale?>(
                title: Text(l10n.settingsLanguageUkrainian),
                value: const Locale('uk'),
              ),
            ],
          ),
        ),
        const Divider(),
        _SectionHeader(l10n.settingsTheme),
        RadioGroup<ThemeMode>(
          groupValue: settings.themeMode,
          onChanged: (v) {
            if (v != null) notifier.setThemeMode(v);
          },
          child: Column(
            children: [
              RadioListTile<ThemeMode>(
                title: Text(l10n.settingsThemeSystem),
                value: ThemeMode.system,
              ),
              RadioListTile<ThemeMode>(
                title: Text(l10n.settingsThemeLight),
                value: ThemeMode.light,
              ),
              RadioListTile<ThemeMode>(
                title: Text(l10n.settingsThemeDark),
                value: ThemeMode.dark,
              ),
            ],
          ),
        ),
        const Divider(),
        SwitchListTile(
          title: Text(l10n.settingsNotifications),
          subtitle: Text(l10n.settingsNotificationsHint),
          value: settings.notifyOnSeasonChange,
          onChanged: (value) async {
            if (value) {
              // Ask permission first — if the user denies we don't flip
              // the toggle on, nothing to schedule.
              final granted =
                  await NotificationService.instance.requestPermission();
              if (!granted) return;
              await notifier.setNotifyOnSeasonChange(true);
              final repo = ref.read(seasonsRepositoryProvider);
              final calc = ref.read(seasonCalculatorProvider);
              final locale = Localizations.localeOf(context);
              await NotificationService.instance.scheduleUpcoming(
                repo: repo,
                calc: calc,
                locale: locale,
              );
            } else {
              await notifier.setNotifyOnSeasonChange(false);
              await NotificationService.instance.cancelAll();
            }
          },
        ),
        const Divider(),
        _SectionHeader(l10n.settingsAbout),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(
            l10n.settingsAboutText,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              letterSpacing: 1.5,
            ),
      ),
    );
  }
}
