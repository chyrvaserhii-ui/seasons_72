import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Identifier for one of the deep-dive cards rendered on the home and
/// detail screens. Used by [CardVisibility] and the settings toggles.
/// Order matches the visual order on the season screen so the toggles
/// list reads top-to-bottom the way the user will scan it.
enum DetailCard {
  period,
  sekki,
  tea,
  food,
  hana,
  colors,
  kodo,
  kigo,
  practice,
}

/// Per-card on/off visibility. Each kō can render up to nine optional
/// cards in addition to the always-on title + description + haiku.
/// The user can hide any subset from the settings screen — handy if
/// the screen feels too long, or if a particular tradition isn't
/// interesting to them.
@immutable
class CardVisibility {
  const CardVisibility({
    this.period = true,
    this.sekki = true,
    this.tea = true,
    this.food = true,
    this.hana = true,
    this.colors = true,
    this.kodo = true,
    this.kigo = true,
    this.practice = true,
  });

  final bool period;
  final bool sekki;
  final bool tea;
  final bool food;
  final bool hana;
  final bool colors;
  final bool kodo;
  final bool kigo;
  final bool practice;

  /// Read the boolean for [card].
  bool get(DetailCard card) {
    switch (card) {
      case DetailCard.period:   return period;
      case DetailCard.sekki:    return sekki;
      case DetailCard.tea:      return tea;
      case DetailCard.food:     return food;
      case DetailCard.hana:     return hana;
      case DetailCard.colors:   return colors;
      case DetailCard.kodo:     return kodo;
      case DetailCard.kigo:     return kigo;
      case DetailCard.practice: return practice;
    }
  }

  /// Returns a copy with [card] flipped to [value].
  CardVisibility setCard(DetailCard card, bool value) {
    switch (card) {
      case DetailCard.period:   return copyWith(period: value);
      case DetailCard.sekki:    return copyWith(sekki: value);
      case DetailCard.tea:      return copyWith(tea: value);
      case DetailCard.food:     return copyWith(food: value);
      case DetailCard.hana:     return copyWith(hana: value);
      case DetailCard.colors:   return copyWith(colors: value);
      case DetailCard.kodo:     return copyWith(kodo: value);
      case DetailCard.kigo:     return copyWith(kigo: value);
      case DetailCard.practice: return copyWith(practice: value);
    }
  }

  CardVisibility copyWith({
    bool? period,
    bool? sekki,
    bool? tea,
    bool? food,
    bool? hana,
    bool? colors,
    bool? kodo,
    bool? kigo,
    bool? practice,
  }) {
    return CardVisibility(
      period: period ?? this.period,
      sekki: sekki ?? this.sekki,
      tea: tea ?? this.tea,
      food: food ?? this.food,
      hana: hana ?? this.hana,
      colors: colors ?? this.colors,
      kodo: kodo ?? this.kodo,
      kigo: kigo ?? this.kigo,
      practice: practice ?? this.practice,
    );
  }

  /// Pref-key suffix for each card — used to namespace SharedPreferences
  /// entries. Keep stable; renaming would silently lose user prefs.
  static String prefKey(DetailCard card) => 'settings.cards.${card.name}';
}

/// User-editable app settings, persisted via SharedPreferences.
class AppSettings {
  final Locale? locale; // null = follow system
  final ThemeMode themeMode;
  final bool notifyOnSeasonChange;
  final CardVisibility cards;

  /// True once the user has finished (or skipped) the first-launch
  /// onboarding flow. False on a fresh install so the router knows to
  /// show OnboardingScreen instead of AppShell.
  final bool hasSeenOnboarding;

  /// True once the user has noticed (or dismissed) the floating
  /// ambient-sound button on the home hero. Drives a one-time
  /// "Послухати кō" hint bubble — once seen, it never appears again.
  final bool hasSeenAmbientHint;

  /// Snapshot of whether the SharedPreferences-backed state has loaded.
  /// Lets the router avoid flashing onboarding for a returning user
  /// while disk reads are still in flight.
  final bool isLoaded;

  const AppSettings({
    this.locale,
    this.themeMode = ThemeMode.system,
    this.notifyOnSeasonChange = false,
    this.cards = const CardVisibility(),
    this.hasSeenOnboarding = false,
    this.hasSeenAmbientHint = false,
    this.isLoaded = false,
  });

  AppSettings copyWith({
    Object? locale = _unset,
    ThemeMode? themeMode,
    bool? notifyOnSeasonChange,
    CardVisibility? cards,
    bool? hasSeenOnboarding,
    bool? hasSeenAmbientHint,
    bool? isLoaded,
  }) {
    return AppSettings(
      locale: identical(locale, _unset) ? this.locale : locale as Locale?,
      themeMode: themeMode ?? this.themeMode,
      notifyOnSeasonChange: notifyOnSeasonChange ?? this.notifyOnSeasonChange,
      cards: cards ?? this.cards,
      hasSeenOnboarding: hasSeenOnboarding ?? this.hasSeenOnboarding,
      hasSeenAmbientHint: hasSeenAmbientHint ?? this.hasSeenAmbientHint,
      isLoaded: isLoaded ?? this.isLoaded,
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
  static const _kHasSeenOnboarding = 'settings.hasSeenOnboarding';
  static const _kHasSeenAmbientHint = 'settings.hasSeenAmbientHint';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final locale = prefs.getString(_kLocale);
    final theme = prefs.getString(_kThemeMode);
    final notify = prefs.getBool(_kNotify) ?? false;
    final seenOnboarding = prefs.getBool(_kHasSeenOnboarding) ?? false;
    final seenAmbientHint =
        prefs.getBool(_kHasSeenAmbientHint) ?? false;

    // Card visibility — each card has its own key, default true (visible).
    CardVisibility cards = const CardVisibility();
    for (final c in DetailCard.values) {
      final v = prefs.getBool(CardVisibility.prefKey(c));
      if (v != null) {
        cards = cards.setCard(c, v);
      }
    }

    state = AppSettings(
      locale: locale == null || locale.isEmpty ? null : Locale(locale),
      themeMode: _parseTheme(theme),
      notifyOnSeasonChange: notify,
      cards: cards,
      hasSeenOnboarding: seenOnboarding,
      hasSeenAmbientHint: seenAmbientHint,
      isLoaded: true,
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

  /// Toggle visibility of one of the deep-dive cards.
  Future<void> setCardVisible(DetailCard card, bool visible) async {
    state = state.copyWith(cards: state.cards.setCard(card, visible));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(CardVisibility.prefKey(card), visible);
  }

  /// Mark onboarding finished (or skipped). The router will route the
  /// user straight to AppShell on subsequent launches.
  Future<void> setHasSeenOnboarding(bool value) async {
    state = state.copyWith(hasSeenOnboarding: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kHasSeenOnboarding, value);
  }

  /// Persist the one-time-seen flag for the ambient sound hint shown
  /// next to the floating play button on the home hero.
  Future<void> setHasSeenAmbientHint(bool value) async {
    state = state.copyWith(hasSeenAmbientHint: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kHasSeenAmbientHint, value);
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
