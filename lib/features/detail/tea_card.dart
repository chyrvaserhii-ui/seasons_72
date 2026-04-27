import 'package:flutter/material.dart';

import '../about/tea_pairings.dart';
import '../shared/widgets/dismissible_modal_sheet.dart';

/// A small tappable card on the detail screen showing the Chinese tea
/// paired with the current kō. Visual language: per-category glyph
/// (sprout for green, feather for silver-needle white, rock for Wuyi
/// yan-cha, etc.) + tea name + category. Tap → bottom sheet with the
/// full tasting note, info, legend, and brewing instructions.
class TeaCard extends StatelessWidget {
  const TeaCard({
    super.key,
    required this.koIndex,
    required this.locale,
  });

  final int koIndex;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    final tea = teaForKo(koIndex);
    if (tea == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final isUk = locale.languageCode == 'uk';
    final onSurface = theme.colorScheme.onSurface;
    final isDark = theme.brightness == Brightness.dark;

    // Jade — soft enough to coexist with the meta-season tint.
    const jade = Color(0xFF8FBF7F);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Editorial caps header — same pattern as SEASON NOW / NEXT SEASON
        // headers elsewhere in the app. Tells the user "this row is the
        // seasonal tea pairing, tap for details".
        Text(
          (isUk ? 'СЕЗОННИЙ ЧАЙ' : 'SEASONAL TEA'),
          style: theme.textTheme.labelLarge?.copyWith(
            color: onSurface.withValues(alpha: 0.75),
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Material(
            // Light theme needs a stronger alpha to differentiate the
            // card from white scaffold; dark theme keeps the airy 0.10
            // since pastel on dark already shows.
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => _showSheet(context, tea, isUk, jade),
              child: Container(
                decoration: BoxDecoration(
                  color: jade.withValues(alpha: isDark ? 0.14 : 0.16),
                  border: Border(
                    left: BorderSide(
                      color: jade.withValues(alpha: 0.70),
                      width: 3,
                    ),
                    bottom: BorderSide(
                      color: jade.withValues(alpha: 0.18),
                      width: 0.5,
                    ),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Per-tea glyph — name-level overrides where the tea's
                    // name has a vivid visual hook (Dragon Well, Monkey
                    // King, Frozen Peak, etc.); falls back to category
                    // default for everything else.
                    Text(
                      _teaEmoji(tea),
                      style: TextStyle(
                        fontSize: 20,
                        color: jade.withValues(alpha: 0.92),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isUk ? tea.nameUk : tea.nameEn,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            // Тільки категорія — підваріетій уже у nameUk
                            // (наприклад "Шоу Мей (Брова довголіття)").
                            _categoryLabel(tea.type, isUk),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: onSurface.withValues(alpha: 0.65),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.info_outline,
                      size: 18,
                      color: onSurface.withValues(alpha: 0.45),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showSheet(BuildContext context, TeaPairing tea, bool isUk, Color accent) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _TeaDetailsSheet(tea: tea, isUk: isUk, accent: accent),
    );
  }
}

class _TeaDetailsSheet extends StatelessWidget {
  const _TeaDetailsSheet({
    required this.tea,
    required this.isUk,
    required this.accent,
  });

  final TeaPairing tea;
  final bool isUk;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final variety = varietyForSubVariety(tea.subVariety);

    // Pull localised sections (may be null if no entry, or empty if entry
    // exists but a legend was deliberately left blank).
    final info = variety == null ? '' : (isUk ? variety.infoUk : variety.infoEn);
    final legend =
        variety == null ? '' : (isUk ? variety.legendUk : variety.legendEn);
    final brewing =
        variety == null ? '' : (isUk ? variety.brewingUk : variety.brewingEn);

    return DismissibleModalSheet(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
              // ─── Hero (centered) ───────────────────────────────────────
              Center(
                child: Text(
                  isUk ? 'СЕЗОННИЙ ЧАЙ' : 'SEASONAL TEA',
                  style: theme.textTheme.labelLarge?.copyWith(
                    letterSpacing: 1.8,
                    color: onSurface.withValues(alpha: 0.55),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Center(
                child: Text(
                  tea.chinese,
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontSize: 56,
                    color: accent.withValues(alpha: 0.92),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  isUk ? tea.nameUk : tea.nameEn,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  tea.pinyin,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: onSurface.withValues(alpha: 0.55),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  // Тільки категорія — підваріетій уже у nameUk/nameEn.
                  _categoryLabel(tea.type, isUk),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: onSurface.withValues(alpha: 0.55),
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Center(
                child: Container(
                  width: 60,
                  height: 1,
                  color: accent.withValues(alpha: 0.4),
                ),
              ),
              const SizedBox(height: 22),

              // ─── Seasonal note (always present) ────────────────────────
              Text(
                isUk ? tea.noteUk : tea.noteEn,
                style: theme.textTheme.bodyLarge?.copyWith(
                  height: 1.55,
                  color: onSurface.withValues(alpha: 0.85),
                ),
                textAlign: TextAlign.left,
              ),

              // ─── Info / Legend / Brewing (when variety data exists) ───
              if (info.isNotEmpty) ...[
                const SizedBox(height: 26),
                _SectionHeader(
                  text: isUk ? 'ІНФО' : 'INFO',
                  onSurface: onSurface,
                  theme: theme,
                ),
                const SizedBox(height: 8),
                Text(
                  info,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.55),
                ),
              ],
              if (legend.isNotEmpty) ...[
                const SizedBox(height: 22),
                _SectionHeader(
                  text: isUk ? 'ЛЕГЕНДА' : 'LEGEND',
                  onSurface: onSurface,
                  theme: theme,
                ),
                const SizedBox(height: 8),
                Text(
                  legend,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.55),
                ),
              ],
              if (brewing.isNotEmpty) ...[
                const SizedBox(height: 22),
                _SectionHeader(
                  text: isUk ? 'СПОСІБ ЗАВАРЮВАННЯ' : 'BREWING',
                  onSurface: onSurface,
                  theme: theme,
                ),
                const SizedBox(height: 8),
                Text(
                  brewing,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.55),
                ),
              ],
            ],
          ),
    );
  }
}

/// Editorial caps section header used inside the tea details sheet.
/// Keeps the visual rhythm consistent with СЕЗОННИЙ ЧАЙ / СЕККІ / ПЕРІОД
/// elsewhere in the app.
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.text,
    required this.onSurface,
    required this.theme,
  });

  final String text;
  final Color onSurface;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: theme.textTheme.labelLarge?.copyWith(
        color: onSurface.withValues(alpha: 0.65),
        letterSpacing: 1.5,
      ),
    );
  }
}

/// Glyph for one tea pairing on the row card.
///
/// Resolution order:
///   1. Per-NAME override (this function) — the tea's `subVariety`
///      string is matched against a hand-curated list. Used when the
///      Chinese name itself paints a vivid image (Dragon Well = 🐉,
///      Monkey King = 🐒, Frozen Peak = ❄️ …).
///   2. Per-TYPE default ([_typeEmoji]) — fallback for teas whose name
///      doesn't have a clear visual hook (mostly mountain/region named
///      teas like Bingdao or Yiwu).
///
/// The override list is intentionally conservative: only teas whose
/// translated name has a strong visual referent get a custom glyph.
/// Generic "X mountain" or "Y village" teas keep the type default so
/// the row still tells the user what KIND of tea they're looking at.
String _teaEmoji(TeaPairing tea) {
  switch (tea.subVariety) {
    case 'Лун Цзін':           return '🐉'; // 龙井 "Dragon Well"
    case 'Бі Ло Чунь':         return '🐌'; // 碧螺春 "Green Snail Spring"
    case 'Цзюньшань Іньчжень': return '🪡'; // 君山銀針 silver needles, Mt Jun
    case 'Бай Хао Інь Чжень':  return '🪡'; // 白毫銀針 silver needles, white down
    case 'Тай Пін Хоу Куй':    return '🐒'; // 太平猴魁 "Monkey King of Taiping"
    case 'Хуаншань Мао Фен':   return '🏔️'; // 黄山毛峰 "Hairy peak, Yellow Mt"
    case 'Сон Чжун':           return '🦚'; // Phoenix dancong (Sòng-dynasty bush)
    case 'Цзінь Сюань':        return '🥛'; // 金萱 milk-oolong character
    case 'Цзінь Цзюнь Мей':    return '🐎'; // 金骏眉 "Golden eyebrow of spirited horse"
    case 'Лапсан Сушон':       return '🔥'; // 正山小种 pine-smoked over fire
    case 'Бай Цзі Ґуань':      return '🐓'; // 白鸡冠 "White cockscomb"
    case 'Уї Шуй Сянь':        return '💧'; // 武夷水仙 "Water immortal"
    case 'Дун Дін':            return '❄️'; // 凍頂 "Frozen peak"
    case 'Юе Ґуан Бай':        return '🌙'; // 月光白 "Moonlight white"
    case 'Чень Пі Пуер':       return '🍊'; // 陳皮普洱 tangerine-peel pu-erh
    case 'Я Ши Сян':           return '🦆'; // 鸭屎香 "Duck aroma" dancong
    case 'Мі Лань Сян':        return '🍯'; // 蜜兰香 "Honey orchid fragrance"
    case 'Чжи Лань Сян':       return '🌸'; // 芝兰香 "Orchid fragrance"
    case 'Ісін Хун Ча':        return '🏺'; // 宜兴红茶 — the Yixing teapot region
    case 'Гун Тін':            return '👑'; // 宫廷 "Palace-tribute" pu-erh
    case 'Да Хун Пао':         return '🧥'; // 大红袍 "Big red robe"
    default:                    return _typeEmoji(tea.type);
  }
}

/// Per-category fallback glyph. Each TeaType gets a single expressive
/// emoji that hints at terroir or character — a fresh sprout for green,
/// stylised white-flower for white silver-needle / Bai Mu Dan, a rock
/// for Wuyi yan-cha, an orchid for Tieguanyin, etc. Used by [_teaEmoji]
/// when no per-name override matches.
String _typeEmoji(TeaType t) {
  switch (t) {
    case TeaType.greenTea:             return '🌱'; // fresh sprout
    case TeaType.whiteTea:             return '💮'; // white-peony bloom (白牡丹)
    case TeaType.yellowTea:            return '🌕'; // pale gold
    case TeaType.redTea:               return '🍂'; // roasted-leaf red
    case TeaType.northFujianOolong:    return '🪨'; // Wuyi yan-cha rock
    case TeaType.southFujianOolong:    return '🌺'; // Tieguanyin orchid
    case TeaType.guangdongOolong:      return '🦋'; // Phoenix dancong's many fragrances
    case TeaType.taiwaneseLightOolong: return '☁️'; // high-mountain clouds
    case TeaType.taiwaneseDarkOolong:  return '🍑'; // Oriental Beauty's honeyed peach
    case TeaType.shengPuerh:           return '🌳'; // Yunnan ancient trees
    case TeaType.shuPuerh:             return '🍫'; // dark, earthy, chocolatey
    case TeaType.heicha:               return '🪵'; // basket-aged dark wood
    case TeaType.liubao:               return '🏺'; // jar-aged Liu Bao
  }
}

String _categoryLabel(TeaType t, bool isUk) {
  if (isUk) {
    switch (t) {
      case TeaType.greenTea:             return 'Зелений чай';
      case TeaType.whiteTea:             return 'Білий чай';
      case TeaType.yellowTea:            return 'Жовтий чай';
      case TeaType.redTea:               return 'Червоний чай';
      case TeaType.northFujianOolong:    return 'Північнофуцзянський улун';
      case TeaType.southFujianOolong:    return 'Південнофуцзянський улун';
      case TeaType.guangdongOolong:      return 'Гуандунський улун';
      case TeaType.taiwaneseLightOolong: return 'Тайванський світлий улун';
      case TeaType.taiwaneseDarkOolong:  return 'Тайванський темний улун';
      case TeaType.shengPuerh:           return 'Шен-пуер';
      case TeaType.shuPuerh:             return 'Шу-пуер';
      case TeaType.heicha:               return 'Хей ча';
      case TeaType.liubao:               return 'Лю Бао';
    }
  }
  switch (t) {
    case TeaType.greenTea:             return 'Green tea';
    case TeaType.whiteTea:             return 'White tea';
    case TeaType.yellowTea:            return 'Yellow tea';
    case TeaType.redTea:               return 'Red tea';
    case TeaType.northFujianOolong:    return 'North Fujian oolong';
    case TeaType.southFujianOolong:    return 'South Fujian oolong';
    case TeaType.guangdongOolong:      return 'Guangdong oolong';
    case TeaType.taiwaneseLightOolong: return 'Taiwanese light oolong';
    case TeaType.taiwaneseDarkOolong:  return 'Taiwanese dark oolong';
    case TeaType.shengPuerh:           return 'Sheng Pu-erh';
    case TeaType.shuPuerh:             return 'Shu Pu-erh';
    case TeaType.heicha:               return 'Hei cha';
    case TeaType.liubao:               return 'Liu Bao';
  }
}
