import 'package:flutter/material.dart';

/// Minimalist Japanese-inspired palette. Each meta-season has its own
/// accent color that tints the Home screen and detail views.
class AppTheme {
  static const Color sumiInk = Color(0xFF1A1615); // 墨 black ink
  static const Color washiPaper = Color(0xFFF5EFE6); // 和紙 paper
  // Dark surface — nearly-neutral with slight warmth. Less brown than
  // before so vibrant season accents (pink/green/orange/blue) read clean.
  static const Color washiDark = Color(0xFF1C1A1A);
  static const Color sealRed = Color(0xFFB94A3D);

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: sealRed,
      brightness: Brightness.light,
      surface: washiPaper,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: washiPaper,
      textTheme: _textTheme(sumiInk),
      appBarTheme: const AppBarTheme(
        backgroundColor: washiPaper,
        foregroundColor: sumiInk,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: sealRed,
      brightness: Brightness.dark,
      surface: washiDark,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: washiDark,
      textTheme: _textTheme(washiPaper),
      appBarTheme: const AppBarTheme(
        backgroundColor: washiDark,
        foregroundColor: washiPaper,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }

  static TextTheme _textTheme(Color onBackground) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 72,
        fontWeight: FontWeight.w700,
        height: 1.1,
        color: onBackground,
      ),
      displayMedium: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.w700,
        height: 1.1,
        color: onBackground,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: onBackground,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: onBackground,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: onBackground,
      ),
      bodyLarge: TextStyle(fontSize: 17, height: 1.5, color: onBackground),
      bodyMedium: TextStyle(fontSize: 15, height: 1.5, color: onBackground),
      labelLarge: TextStyle(fontSize: 13, letterSpacing: 1.2, color: onBackground),
    );
  }
}
