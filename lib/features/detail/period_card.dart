import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/models/season_models.dart';

/// Calendrical period card for the current kō. Mirrors the visual
/// vocabulary of the seven deep-dive cards (caps header, tinted row,
/// info icon → bottom sheet) so the period reads as one of the cards
/// rather than a stranded label at the bottom of the screen.
///
/// Bottom sheet shows: large date range, day count, position within
/// the year (kō N of 72), within the parent sekki (1st / 2nd / 3rd of
/// three), and within the meta-season (M of 18).
class PeriodCard extends StatelessWidget {
  const PeriodCard({
    super.key,
    required this.ko,
    required this.meta,
    required this.sekki,
    required this.locale,
    required this.accentColor,
  });

  final MicroSeason ko;
  final MetaSeason meta;
  final Sekki sekki;
  final Locale locale;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUk = locale.languageCode == 'uk';
    final onSurface = theme.colorScheme.onSurface;
    final isDark = theme.brightness == Brightness.dark;
    final tint = meta.tintColorFor(theme.brightness);
    final dateRange = _dateRange(ko, locale);
    final positionLine = _positionShort(ko, isUk);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isUk ? 'ПЕРІОД' : 'PERIOD',
          style: theme.textTheme.labelLarge?.copyWith(
            color: onSurface.withValues(alpha: 0.75),
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Material(
          color: tint.withValues(alpha: isDark ? 0.10 : 0.13),
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _showSheet(context, isUk),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '📅',
                    style: TextStyle(
                      fontSize: 20,
                      color: accentColor.withValues(alpha: 0.92),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dateRange,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          positionLine,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: onSurface.withValues(alpha: 0.65),
                            letterSpacing: 0.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
      ],
    );
  }

  void _showSheet(BuildContext context, bool isUk) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => _PeriodDetailsSheet(
        ko: ko,
        meta: meta,
        sekki: sekki,
        locale: locale,
        accent: accentColor,
        isUk: isUk,
      ),
    );
  }
}

/// Compute the localised date range string, e.g. "20 квітня – 24 квітня".
String _dateRange(MicroSeason ko, Locale locale) {
  final year = DateTime.now().year;
  final df = DateFormat.MMMMd(locale.languageCode);
  return '${df.format(ko.startDateForYear(year))} – ${df.format(ko.endDateForYear(year))}';
}

/// One-line positioning text shown on the row card. Intentionally
/// compact ("5 днів · кō 5 із 72") so it never wraps.
String _positionShort(MicroSeason ko, bool isUk) {
  if (isUk) {
    return '5 днів · кō ${ko.index} із 72';
  }
  return '5 days · kō ${ko.index} of 72';
}

/// Position of [ko] within its parent sekki (1, 2, or 3).
int _koInSekki(MicroSeason ko) => ((ko.index - 1) % 3) + 1;

/// Position of [ko] within its parent meta-season (1..18).
int _koInMeta(MicroSeason ko) => ((ko.index - 1) % 18) + 1;

class _PeriodDetailsSheet extends StatelessWidget {
  const _PeriodDetailsSheet({
    required this.ko,
    required this.meta,
    required this.sekki,
    required this.locale,
    required this.accent,
    required this.isUk,
  });

  final MicroSeason ko;
  final MetaSeason meta;
  final Sekki sekki;
  final Locale locale;
  final Color accent;
  final bool isUk;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final mq = MediaQuery.of(context);
    final maxHeight = mq.size.height * 0.85;

    final year = DateTime.now().year;
    final dfFull = DateFormat.yMMMMd(locale.languageCode);
    final start = ko.startDateForYear(year);
    final end = ko.endDateForYear(year);
    final dfRange = DateFormat.MMMMd(locale.languageCode);
    final compactRange =
        '${dfRange.format(start)} – ${dfRange.format(end)}';

    final inSekki = _koInSekki(ko);
    final inMeta = _koInMeta(ko);

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  isUk ? 'ПЕРІОД' : 'PERIOD',
                  style: theme.textTheme.labelLarge?.copyWith(
                    letterSpacing: 1.8,
                    color: onSurface.withValues(alpha: 0.55),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              // Hero — large date range.
              Center(
                child: Text(
                  compactRange,
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontSize: 30,
                    color: accent,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  isUk ? '5 днів' : '5 days',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: onSurface.withValues(alpha: 0.65),
                    letterSpacing: 0.4,
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
              _PositionBlock(
                title: isUk ? 'У ЦІЛОМУ РОЦІ' : 'IN THE YEAR',
                value: isUk
                    ? 'Сезон ${ko.index} з 72'
                    : 'Season ${ko.index} of 72',
                hint: isUk
                    ? 'Японський рік ділиться на 72 п\u2019ятиденні сезони (кō, 候). Цей — ${ko.index}-й від початку року.'
                    : 'The Japanese year breaks into 72 five-day seasons called kō (候). This one is the ${_ordinalEn(ko.index)} from the start of the year.',
                onSurface: onSurface,
                theme: theme,
              ),
              const SizedBox(height: 18),
              _PositionBlock(
                title: isUk ? 'У ФАЗІ РОКУ' : 'IN THE PHASE',
                value:
                    '${sekki.kanji} ${_sekkiName(sekki, isUk)} · $inSekki з 3',
                hint: _sekkiHint(inSekki, _sekkiName(sekki, isUk), isUk),
                onSurface: onSurface,
                theme: theme,
              ),
              const SizedBox(height: 18),
              _PositionBlock(
                title: isUk ? 'У ПОРІ РОКУ' : 'IN THE SEASON',
                value:
                    '${meta.kanji} ${_metaName(meta, isUk)} · $inMeta з 18',
                hint: isUk
                    ? 'Кожна з чотирьох пір року охоплює 18 сезонів. Цей — ${inMeta}-й ${_metaAdjUk(meta.id)}.'
                    : 'Each of the four seasons of the year covers 18 kō. This is the ${_ordinalEn(inMeta)} ${_metaName(meta, isUk).toLowerCase()} one.',
                onSurface: onSurface,
                theme: theme,
              ),
              const SizedBox(height: 22),
              // Full localised dates as a fine-print line. No trailing
              // period — the Ukrainian DateFormat already ends with "р."
              // and a sentence period would render as a doubled dot.
              Text(
                isUk
                    ? 'З ${dfFull.format(start)} по ${dfFull.format(end)}'
                    : 'From ${dfFull.format(start)} to ${dfFull.format(end)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: onSurface.withValues(alpha: 0.55),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _sekkiName(Sekki s, bool isUk) => isUk ? s.nameUk : s.nameEn;
String _metaName(MetaSeason m, bool isUk) => isUk ? m.nameUk : m.nameEn;

/// Brief hint for the position-within-sekki line — first explains what
/// a sekki even is, then says where in it we currently are.
String _sekkiHint(int n, String sekkiName, bool isUk) {
  if (isUk) {
    const intro =
        'Секкі — це 24 фази року, по 15 днів кожна; кожна фаза містить 3 сезони (кō).';
    switch (n) {
      case 1:
        return '$intro Зараз — самий початок «$sekkiName».';
      case 2:
        return '$intro Зараз — середина «$sekkiName».';
      default:
        return '$intro Зараз — кінець «$sekkiName», фаза згасає.';
    }
  }
  const intro =
      'Sekki are the 24 phases of the year — about 15 days each, holding 3 kō.';
  switch (n) {
    case 1:
      return '$intro You\'re at the very opening of "$sekkiName".';
    case 2:
      return '$intro You\'re in the middle of "$sekkiName".';
    default:
      return '$intro You\'re at the closing of "$sekkiName" — the phase is fading.';
  }
}

/// English ordinal — "1st", "2nd", "3rd", "4th"...
String _ordinalEn(int n) {
  if (n % 100 >= 11 && n % 100 <= 13) return '${n}th';
  switch (n % 10) {
    case 1:
      return '${n}st';
    case 2:
      return '${n}nd';
    case 3:
      return '${n}rd';
    default:
      return '${n}th';
  }
}

/// Ukrainian gendered adjective for the meta-season (used in
/// constructions like "17-й весняний", "5-й літній" etc.).
String _metaAdjUk(String metaId) {
  switch (metaId) {
    case 'spring':
      return 'весняний';
    case 'summer':
      return 'літній';
    case 'autumn':
      return 'осінній';
    case 'winter':
      return 'зимовий';
    default:
      return '';
  }
}

/// One labelled position row in the bottom sheet — caps title +
/// value (with kanji and reading) + a one-line hint underneath.
class _PositionBlock extends StatelessWidget {
  const _PositionBlock({
    required this.title,
    required this.value,
    required this.hint,
    required this.onSurface,
    required this.theme,
  });

  final String title;
  final String value;
  final String hint;
  final Color onSurface;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.labelLarge?.copyWith(
            color: onSurface.withValues(alpha: 0.65),
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          hint,
          style: theme.textTheme.bodySmall?.copyWith(
            color: onSurface.withValues(alpha: 0.65),
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
