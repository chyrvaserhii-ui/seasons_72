import 'package:flutter/material.dart';

/// Meta-season (one of the four: Spring/Summer/Autumn/Winter).
class MetaSeason {
  final String id;
  final String kanji;
  final String romaji;
  final String nameEn;
  final String nameUk;

  /// Color for light theme — soft, washi-friendly pastels.
  final Color colorLight;

  /// Color for dark theme — saturated to read well on dark surface.
  final Color colorDark;

  final String emoji;

  const MetaSeason({
    required this.id,
    required this.kanji,
    required this.romaji,
    required this.nameEn,
    required this.nameUk,
    required this.colorLight,
    required this.colorDark,
    required this.emoji,
  });

  /// Brightness-aware accessor — use wherever you'd write `meta.color`.
  ///
  /// Returns the *foreground* hue: bright pastel for dark theme,
  /// soft pastel for light theme. Suitable for icons, kanji glyphs,
  /// borders, and progress bars where the colour itself is the
  /// signal. For tinted backgrounds (header pills, card fills, day
  /// cells) prefer [tintColorFor] — see its docs for why.
  Color colorFor(Brightness b) =>
      b == Brightness.dark ? colorDark : colorLight;

  /// Background-tint variant of [colorFor].
  ///
  /// The light-theme accents are pastels (#F4B5C1, #8FBF7F, #D89060,
  /// #8DAAC7). Applied to a white surface at low alpha they read as
  /// "almost white" — which is why the calendar / cards felt washed
  /// out at first. But pulling the lightness too far down (the
  /// initial fix) ended up at "eye-popping" / "looks cheap": a deep
  /// muddy pink instead of an elegant washi blossom.
  ///
  /// The current balance is intentionally gentle: a small luminance
  /// drop (×0.78) with no saturation push, leaving the pastel feel
  /// intact while giving low-alpha tints just enough body to
  /// register on a white scaffold.
  ///
  /// Dark theme keeps the original (already balanced for near-black).
  Color tintColorFor(Brightness b) {
    final base = colorFor(b);
    if (b == Brightness.dark) return base;
    final hsl = HSLColor.fromColor(base);
    return hsl
        .withLightness((hsl.lightness * 0.78).clamp(0.0, 1.0))
        .toColor();
  }

  /// Legacy alias — defaults to light variant. Prefer [colorFor].
  Color get color => colorLight;

  factory MetaSeason.fromJson(String id, Map<String, dynamic> json) {
    final light = _hexToColor(json['colorHex'] as String);
    // Fall back to light color if no dark variant provided.
    final darkHex = json['colorHexDark'] as String?;
    return MetaSeason(
      id: id,
      kanji: json['kanji'] as String,
      romaji: json['romaji'] as String,
      nameEn: json['en'] as String,
      nameUk: json['uk'] as String,
      colorLight: light,
      colorDark: darkHex != null ? _hexToColor(darkHex) : light,
      emoji: json['emoji'] as String? ?? '•',
    );
  }
}

/// One of the 24 larger sekki divisions.
class Sekki {
  final String id;
  final String kanji;
  final String romaji;
  final String nameEn;
  final String nameUk;

  const Sekki({
    required this.id,
    required this.kanji,
    required this.romaji,
    required this.nameEn,
    required this.nameUk,
  });

  factory Sekki.fromJson(Map<String, dynamic> json) {
    return Sekki(
      id: json['id'] as String,
      kanji: json['kanji'] as String,
      romaji: json['romaji'] as String,
      nameEn: json['en'] as String,
      nameUk: json['uk'] as String,
    );
  }
}

/// One of the 72 micro-seasons (ko).
class MicroSeason {
  final int index; // 1..72
  final String metaId;
  final String sekkiId;
  final String kanji;
  final String romaji;
  final String nameEn;
  final String nameUk;
  final String emoji;

  /// Relative path to a bundled ukiyo-e illustration (e.g.,
  /// `assets/images/ko/15.webp`). When present, SeasonHero displays it
  /// instead of the emoji. `null` until illustrations are generated.
  final String? illustrationAsset;

  final int startMonth;
  final int startDay;
  final int endMonth;
  final int endDay;
  final String descriptionEn;
  final String descriptionUk;

  /// Classical haiku associated with this kō (Bashō, Issa, Buson, Shiki,
  /// Chiyo-ni). Both Ukrainian and English translations are available;
  /// the UI picks by current locale.
  final String? haikuUk;
  final String? haikuAuthor;
  final String? haikuEn;
  final String? haikuAuthorEn;

  const MicroSeason({
    required this.index,
    required this.metaId,
    required this.sekkiId,
    required this.kanji,
    required this.romaji,
    required this.nameEn,
    required this.nameUk,
    required this.emoji,
    this.illustrationAsset,
    required this.startMonth,
    required this.startDay,
    required this.endMonth,
    required this.endDay,
    required this.descriptionEn,
    required this.descriptionUk,
    this.haikuUk,
    this.haikuAuthor,
    this.haikuEn,
    this.haikuAuthorEn,
  });

  /// Locale-aware haiku text. Returns null when no haiku is stored.
  String? localizedHaiku(Locale locale) =>
      locale.languageCode == 'uk' ? haikuUk : haikuEn;

  /// Locale-aware author attribution (Ukrainian Cyrillic vs English).
  String? localizedHaikuAuthor(Locale locale) =>
      locale.languageCode == 'uk' ? haikuAuthor : haikuAuthorEn;

  factory MicroSeason.fromJson(Map<String, dynamic> json) {
    return MicroSeason(
      index: json['index'] as int,
      metaId: json['meta'] as String,
      sekkiId: json['sekki'] as String,
      kanji: json['kanji'] as String,
      romaji: json['romaji'] as String,
      nameEn: json['en'] as String,
      nameUk: json['uk'] as String,
      emoji: json['emoji'] as String? ?? '•',
      illustrationAsset: json['illustration'] as String?,
      startMonth: json['startMonth'] as int,
      startDay: json['startDay'] as int,
      endMonth: json['endMonth'] as int,
      endDay: json['endDay'] as int,
      haikuUk: json['haikuUk'] as String?,
      haikuAuthor: json['haikuAuthor'] as String?,
      haikuEn: json['haikuEn'] as String?,
      haikuAuthorEn: json['haikuAuthorEn'] as String?,
      descriptionEn: json['descEn'] as String,
      descriptionUk: json['descUk'] as String,
    );
  }

  /// Returns start DateTime for a given [year] at 00:00 local time.
  DateTime startDateForYear(int year) =>
      DateTime(year, startMonth, startDay);

  /// Returns end DateTime (inclusive) for a given [year] at 23:59:59.
  DateTime endDateForYear(int year) {
    // If end month/day is before start — ko crosses year boundary (only ko 66).
    if (endMonth < startMonth ||
        (endMonth == startMonth && endDay < startDay)) {
      return DateTime(year + 1, endMonth, endDay, 23, 59, 59);
    }
    return DateTime(year, endMonth, endDay, 23, 59, 59);
  }
}

Color _hexToColor(String hex) {
  final h = hex.replaceFirst('#', '');
  final value = int.parse(h, radix: 16);
  if (h.length == 6) {
    return Color(0xFF000000 | value);
  }
  return Color(value);
}
