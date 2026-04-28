import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/models/season_models.dart';

/// One-line inline display of a kō's date range and position counter.
///
/// Replaces the two prior diverging treatments:
///   • Home screen: a bare "5 квітня – 9 квітня" date row with a dot
///   • Detail screen: a full bordered PeriodCard with its own modal
///
/// The new strip is the single shared format used in both places —
/// editorial-light, no card decoration, no tappable modal. Period was
/// dropped from the "9 detail cards" concept (it doesn't belong with
/// the cultural traditions); this strip is its replacement everywhere.
///
/// Format:  📅  5 квітня – 9 квітня · кō 13 з 72
class PeriodStrip extends StatelessWidget {
  const PeriodStrip({
    super.key,
    required this.ko,
    required this.locale,
    this.padding = EdgeInsets.zero,
  });

  final MicroSeason ko;
  final Locale locale;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUk = locale.languageCode == 'uk';
    final df = DateFormat.MMMMd(locale.languageCode);
    final year = DateTime.now().year;
    final start = ko.startDateForYear(year);
    final end = ko.endDateForYear(year);
    final dateRange = '${df.format(start)} – ${df.format(end)}';
    final position =
        isUk ? 'кō ${ko.index} з 72' : 'kō ${ko.index} of 72';
    final onSurface = theme.colorScheme.onSurface;

    return Padding(
      padding: padding,
      child: Row(
        children: [
          Text(
            '📅',
            style: TextStyle(
              fontSize: 14,
              color: onSurface.withValues(alpha: 0.85),
              height: 1.0,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$dateRange · $position',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: onSurface.withValues(alpha: 0.75),
                letterSpacing: 0.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
