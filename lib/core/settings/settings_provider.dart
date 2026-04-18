import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// User-editable app settings, persisted via SharedPreferences.
class AppSettings {
  final Locale? locale; // null = follow system
  final ThemeMode themeMode;
  final bool notifyOnSeasonChange;

  const AppSettings({
    this.locale,
    this.themeMode = ThemeMode.system,
    this.notifyOnSeasonChange = false,
  });

  AppSettings copyWith({
    Object? locale = _unset,
    ThemeMode? themeMode,
    bool? notifyOnSeasonChange,
  }) {
    return AppSettings(
      locale: identical(locale, _unset) ? this.locale : locale as Locale?,
      themeMode: themeMode ?? this.themeMode,
      notifyOnSeasonChange: notifyOnSeasonChange ?? this.notifyOnSeasonChange,
    );
  }

  static const _unset = Object();
}

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(const AppSettings()) {
    _load();
  }

  static const _kLocale = 'settings.locale';
  static const _kThemeMode = 'settings.themeMode';
  static const _kNotify = 'settings.notifyOnSeasonChange';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final locale = prefs.getString(_kLocale);
    final theme = prefs.getString(_kThemeMode);
    final notify = prefs.getBool(_kNotify) ?? false;

    state = AppSettings(
      locale: locale == null || locale.isEmpty ? null : Locale(locale),
      themeMode: _parseTheme(theme),
      notifyOnSeasonChange: notify,
    );
  }

  Future<void> setLocale(Locale? locale) async {
    state = state.copyWith(locale: locale);
    final prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      await prefs.remove(_kLocale);
    } else {
      await prefs.setString(_kLocale, locale.languageCode);
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kThemeMode, mode.name);
  }

  Future<void> setNotifyOnSeasonChange(bool value) async {
    state = state.copyWith(notifyOnSeasonChange: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kNotify, value);
  }

  ThemeMode _parseTheme(String? v) {
    switch (v) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier();
});
