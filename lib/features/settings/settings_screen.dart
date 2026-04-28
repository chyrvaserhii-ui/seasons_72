import 'package:flutter/material.dart';
import 'package:seasons_72/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/notifications/notification_service.dart';
import '../../core/providers/seasons_providers.dart';
import '../../core/settings/settings_provider.dart';
import '../shared/widgets/dismissible_modal_sheet.dart';

/// Master switch for the temporary "DEBUG · СПОВІЩЕННЯ" section at
/// the bottom of Settings. Flipped to `false` for production builds —
/// the section is for smoke-testing the push pipeline manually
/// (instant + delayed + real-text random kō + pending count +
/// cancel-all). Flip back to `true` whenever you need to retest the
/// notification flow.
const bool _showNotifDebug = false;

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
        // Compact horizontal pill picker — replaces the previous
        // 3-row RadioListTile stack which ate ~180 px of vertical
        // space per setting (~360 px combined for language + theme).
        // Now ~52 px per row, matching the [_ViewToggle] design from
        // the calendar tab so the app speaks one visual language for
        // "pick one of N" controls.
        //
        // Dropped the "Match iOS" / null option — only two locales
        // are bundled (en, uk) so the system-default pill collapsed
        // visually onto whichever of the two iOS picked anyway. Two
        // explicit pills make the choice cleaner and unambiguous.
        _PillPicker<Locale?>(
          value: settings.locale,
          options: const [Locale('en'), Locale('uk')],
          labels: [
            l10n.settingsLanguageEnglish,
            l10n.settingsLanguageUkrainian,
          ],
          onChanged: notifier.setLocale,
        ),
        const _SectionRule(),
        _SectionHeader(l10n.settingsTheme),
        _PillPicker<ThemeMode>(
          value: settings.themeMode,
          options: const [
            ThemeMode.system,
            ThemeMode.light,
            ThemeMode.dark,
          ],
          labels: [
            l10n.settingsThemeSystem,
            l10n.settingsThemeLight,
            l10n.settingsThemeDark,
          ],
          onChanged: notifier.setThemeMode,
        ),
        const _SectionRule(),
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
        const _SectionRule(),
        _SectionHeader(_cardsSectionTitle(context)),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
          child: Text(
            _cardsSectionHint(context),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.65),
                ),
          ),
        ),
        for (final card in DetailCard.values)
          SwitchListTile(
            title: Text(_cardLabel(card, context)),
            value: settings.cards.get(card),
            onChanged: (v) => notifier.setCardVisible(card, v),
          ),
        const _SectionRule(),
        _SectionHeader(_introSectionTitle(context)),
        ListTile(
          leading: const Icon(Icons.replay_outlined),
          title: Text(_replayOnboardingTitle(context)),
          subtitle: Text(
            _replayOnboardingSubtitle(context),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.65),
                ),
          ),
          onTap: () async {
            // Resetting the flag to false makes the RootRouter swap
            // the current AppShell out for OnboardingScreen on the
            // next frame. No manual navigation needed.
            await notifier.setHasSeenOnboarding(false);
          },
        ),
        // ─── DEBUG · СПОВІЩЕННЯ ──────────────────────────────────────
        // Temporary smoke-test buttons for the push-notification
        // pipeline. Visible only when the const flag at the top of
        // this file (`_showNotifDebug`) is `true`. Flip to `false`
        // before App Store release. Uses test IDs 9998/9999 to avoid
        // collision with real kō notification IDs (1..72).
        if (_showNotifDebug) ...[
          const _SectionRule(),
          const _SectionHeader('DEBUG · СПОВІЩЕННЯ'),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Text(
              'Тимчасові кнопки для тестування пушів. '
                  'Прибрати перед релізом — флаг _showNotifDebug.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.65),
                  ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.notifications_active_outlined),
            title: const Text('Показати через 3 с'),
            subtitle: const Text(
              'Згорни додаток ЗАРАЗ (home swipe-up) — банер видно лише у фоні',
            ),
            onTap: () async {
              final ok = await NotificationService.instance.showTestNow();
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(ok
                      ? 'Заплановано через 3 с — ЗГОРНИ ЗАРАЗ'
                      : 'Дозвіл на сповіщення відхилено'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.timer_outlined),
            title: const Text('Через 10 секунд'),
            subtitle: const Text(
              'Перевіряє доставку коли застосунок у фоні / killed',
            ),
            onTap: () async {
              final ok = await NotificationService.instance
                  .scheduleTestIn(delay: const Duration(seconds: 10));
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(ok
                      ? 'Заплановано через 10 с — згорни / закрий додаток'
                      : 'Дозвіл на сповіщення відхилено'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.shuffle_outlined),
            title: const Text('Реальний текст · випадковий kō'),
            subtitle: const Text(
              'Показує справжню вироб. текстовку для довільного сезону. '
              'Натисни ще раз — інший kō',
            ),
            onTap: () async {
              final result = await NotificationService.instance
                  .showTestRealKoText(
                repo: ref.read(seasonsRepositoryProvider),
                locale: Localizations.localeOf(context),
              );
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(result.ok
                      ? 'kō #${result.koIndex} → 3 с. ЗГОРНИ ЗАРАЗ\n'
                          '${result.title} — ${result.body}'
                      : 'Дозвіл на сповіщення відхилено'),
                  duration: const Duration(seconds: 4),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.list_alt_outlined),
            title: const Text('Скільки заплановано'),
            subtitle: const Text(
              'Включає реальні (kō) і тестові (9998/9999)',
            ),
            onTap: () async {
              final pending =
                  await NotificationService.instance.pending();
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Заплановано: ${pending.length}'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline),
            title: const Text('Скасувати усі'),
            subtitle: const Text(
              'Прибере всі pending сповіщення (тест + реальні)',
            ),
            onTap: () async {
              await NotificationService.instance.cancelAll();
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Усі сповіщення скасовано'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
        const _SectionRule(),
        _SectionHeader(l10n.settingsAbout),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(
            l10n.settingsAboutText,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        // Colophon mark — closing the page in the same way old
        // Japanese woodblock prints close: a rakkan (落款) seal in
        // the corner, with the year below. Impersonal: the symbol
        // speaks, not a name. Tap → modal sheet with the legend.
        const SizedBox(height: 18),
        const _ColophonMark(),
        const SizedBox(height: 18),
      ],
    );
  }
}

/// Centered colophon at the bottom of Settings — year over a small
/// rakkan-style seal. Pure visual mark, no name. Tap reveals the
/// legend behind the seal in a modal sheet.
class _ColophonMark extends StatelessWidget {
  const _ColophonMark();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUk = _isUk(context);
    final onSurface = theme.colorScheme.onSurface;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => _showColophonSheet(context, isUk),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 7),
            // okuzuke order — title kanji → seal stamp → year.
            // Same vertical sequence as the modal sheet (just at
            // a smaller scale), so the user reads the same colophon
            // composition in both places.
            child: Column(
              children: [
                Text(
                  '菊水',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 6.0,
                    color: onSurface.withValues(alpha: 0.82),
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 5),
                const _SealStamp(size: 64),
                const SizedBox(height: 5),
                Text(
                  '2026',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 4.0,
                    color: onSurface.withValues(alpha: 0.62),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Small print-stamp-style frame around the carp/kiku seal image.
/// Renders `assets/brand/author_seal.png` when present, otherwise a
/// typographic fallback (鯉菊 — carp + chrysanthemum kanji). Hard
/// edges, near-zero corner radius, narrow inner padding so the
/// image breathes inside its frame instead of being clipped at the
/// rounded corners (the issue with the previous 18%-radius seal).
class _SealStamp extends StatelessWidget {
  const _SealStamp({this.size = 64});
  final double size;

  static const Color _crimson = Color(0xFFC8102E);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final paper = isDark
        ? const Color(0xFF24221F)
        : const Color(0xFFF3EDDF);
    final ink = theme.colorScheme.onSurface
        .withValues(alpha: isDark ? 0.32 : 0.28);

    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: paper,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: ink, width: 0.7),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: Image.asset(
          'assets/brand/author_seal.png',
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontSize: size * 0.40,
                  height: 1.0,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
                children: const [
                  TextSpan(text: '鯉'),
                  TextSpan(
                    text: '菊',
                    style: TextStyle(color: _crimson),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void _showColophonSheet(BuildContext context, bool isUk) {
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    // Stops the sheet expanding under the iPhone notch / dynamic
    // island when content is tall — without this the drag handle
    // can land under the safe-area cut-out and become unreachable.
    useSafeArea: true,
    builder: (ctx) {
      final theme = Theme.of(ctx);
      final onSurface = theme.colorScheme.onSurface;
      return DismissibleModalSheet(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // okuzuke composition — kanji title → seal → year.
            // Identical vertical order to the small _ColophonMark
            // tile in Settings; the modal just renders it at a
            // larger scale. Spacings tuned compact so the drag
            // handle stays reachable on smaller iPhones.
            Center(
              child: Text(
                '菊水',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 10.0,
                  color: onSurface.withValues(alpha: 0.92),
                  height: 1.0,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Center(child: _SealStamp(size: 140)),
            const SizedBox(height: 10),
            Center(
              child: Text(
                '2026',
                style: theme.textTheme.labelLarge?.copyWith(
                  letterSpacing: 4.0,
                  fontWeight: FontWeight.w700,
                  color: onSurface.withValues(alpha: 0.78),
                ),
              ),
            ),
            const SizedBox(height: 18),
            // Decorative thin rule with a small seal-red dot — same
            // pattern the haiku block uses across the app.
            const _SealRule(),
            const SizedBox(height: 18),
            // Legend prose — three paragraphs at the same weight and
            // size, reading as one continuous voice instead of
            // stepping down by importance.
            Text(
              isUk
                  ? 'У японській легенді карп, що йде проти течії, рано чи пізно долає водоспад — і стає драконом. Молодість — це опір, наполегливість, мужність триматися проти води.'
                  : 'In Japanese legend, a carp that swims against the current eventually leaps the waterfall — and becomes a dragon. Youth is resistance, persistence, the courage to hold against the water.',
              style: theme.textTheme.bodyLarge?.copyWith(
                height: 1.6,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isUk
                  ? 'А той, хто плине за течією, тієї мрії не зрадив — він її прожив. Те, що здалеку виглядає як спокій, не значить здатися: це ясне прийняття, кінцева мета зусилля. Вода, що несе сама, — то ж і є водоспад, який старий карп колись долав.'
                  : 'And the one that flows with the current has not betrayed that dream — it has lived it. What looks from outside like calm does not mean surrender: it is clear acceptance, the final aim of effort. The water that carries on its own is the very waterfall the elder carp once leapt.',
              style: theme.textTheme.bodyLarge?.copyWith(
                height: 1.6,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isUk
                  ? 'Між ними цвіте багряна хризантема — символ довголіття і тихої гідності. А хвиля, що тримає обох, — це сам час.'
                  : 'Between them blooms the crimson chrysanthemum — symbol of longevity and quiet dignity. And the wave that holds both is time itself.',
              style: theme.textTheme.bodyLarge?.copyWith(
                height: 1.6,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 18),
            // Closing parallel — steps down to the quieter prose
            // weight, reading as a quiet "and finally..." note
            // after the legend itself.
            Text(
              isUk
                  ? 'Це той самий жест, що і 72 сезони: світ змінюється, увага лишається. Один день з п’яти — і вже інша квітка цвіте у горах, інша пташка заспівала на світанку.'
                  : 'It is the same gesture as the 72 seasons: the world shifts, attention stays. One day in five and already a different flower has opened in the mountains, a different bird sings at dawn.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: onSurface.withValues(alpha: 0.85),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 22),
            Center(
              child: Text(
                isUk
                    ? 'Дякую, що читаєш.'
                    : 'Thank you for noticing.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: onSurface.withValues(alpha: 0.55),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 14),
            // Closing kanji 愛 (ai) — "love". Final mark of the
            // colophon, sits below the sign-off as a quiet stamp.
            // Rendered in seal-red at low alpha so it reads as
            // pigment more than as text — same restraint as the
            // hairline rule and the printer's mark above.
            Center(
              child: Text(
                '愛',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  height: 1.0,
                  color: const Color(0xFFB94A3D)
                      .withValues(alpha: 0.65),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

/// Thin rule + small crimson dot in the middle — mirrors the
/// haiku-frame seal used in [SeasonHaiku]. Closing punctuation in
/// visual form: «це я».
/// Settings-screen section divider. Replaces the default Material
/// [Divider] (a flat hairline) with the app's existing [_SealRule]
/// pattern: thin rule + small crimson seal-red dot in the middle —
/// already used in haiku frames and the colophon. Wraps the rule in
/// 12-px vertical padding so the breathing room is similar to the
/// 16-px height a [Divider] occupies.
class _SectionRule extends StatelessWidget {
  const _SectionRule();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: _SealRule(),
    );
  }
}

class _SealRule extends StatelessWidget {
  const _SealRule();

  @override
  Widget build(BuildContext context) {
    final ruleColor = Theme.of(context)
        .colorScheme
        .onSurface
        .withValues(alpha: 0.30);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Container(height: 1, color: ruleColor)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFB94A3D).withValues(alpha: 0.78),
              ),
            ),
          ),
          Expanded(child: Container(height: 1, color: ruleColor)),
        ],
      ),
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

/// Compact horizontal pill segmented control. Used in Settings for
/// language and theme — both formerly stacked as 3-row RadioListTile
/// columns that ate ~180 px of vertical space each. The pill design
/// here intentionally matches `_ViewToggle` in the calendar tab so
/// the app speaks one visual language for "pick one of N" controls.
///
/// Generic over [T] — pass any type as [options], plus a parallel
/// [labels] list of the same length. The currently-selected option
/// is the one whose `==` matches [value].
class _PillPicker<T> extends StatelessWidget {
  const _PillPicker({
    required this.value,
    required this.options,
    required this.labels,
    required this.onChanged,
  });

  final T value;
  final List<T> options;
  final List<String> labels;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: onSurface.withValues(alpha: isDark ? 0.10 : 0.07),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: onSurface.withValues(alpha: 0.18),
            width: 0.7,
          ),
        ),
        child: Row(
          children: [
            for (int i = 0; i < options.length; i++)
              Expanded(
                child: _PillSegment(
                  label: labels[i],
                  selected: options[i] == value,
                  onTap: () => onChanged(options[i]),
                  accent: accent,
                  onSurface: onSurface,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// A single segment in [_PillPicker]. Tap target = full pill, selected
/// state = accent fill at 0.20 alpha + accent border + bolder weight.
class _PillSegment extends StatelessWidget {
  const _PillSegment({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.accent,
    required this.onSurface,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color accent;
  final Color onSurface;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? accent.withValues(alpha: 0.20)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            border: selected
                ? Border.all(
                    color: accent.withValues(alpha: 0.45), width: 0.8)
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color:
                    selected ? accent : onSurface.withValues(alpha: 0.75),
                letterSpacing: 0.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Card-visibility section copy ──────────────────────────────────────
//
// New strings live inline rather than in the .arb files because they're
// uniquely scoped to this section and the overall l10n surface is small.
// Pattern matches the existing tea / food / colour cards' isUk approach.

bool _isUk(BuildContext context) =>
    Localizations.localeOf(context).languageCode == 'uk';

String _cardsSectionTitle(BuildContext context) =>
    _isUk(context) ? 'Картки сезону' : 'Season cards';

String _cardsSectionHint(BuildContext context) => _isUk(context)
    ? 'Прибери ті, що не цікавлять — екран сезону стане коротшим.'
    : 'Hide the ones you don\'t want — the season screen gets shorter.';

String _introSectionTitle(BuildContext context) =>
    _isUk(context) ? 'Знайомство' : 'Intro';

String _replayOnboardingTitle(BuildContext context) => _isUk(context)
    ? 'Показати онбординг знову'
    : 'Show the onboarding again';

String _replayOnboardingSubtitle(BuildContext context) => _isUk(context)
    ? 'Чотири короткі екрани про 72 сезони (кō) і 24 фази (секкі), що складають чотири пори року.'
    : 'Four short screens on the 72 seasons (kō) and 24 phases (sekki) that make up the four seasons of the year.';

String _cardLabel(DetailCard card, BuildContext context) {
  final isUk = _isUk(context);
  switch (card) {
    case DetailCard.period:
      return isUk ? 'Період 📅' : 'Period 📅';
    case DetailCard.sekki:
      return isUk ? 'Фаза секкі 🌾' : 'Sekki phase 🌾';
    case DetailCard.tea:
      return isUk ? 'Сезонний чай 🌱' : 'Seasonal tea 🌱';
    case DetailCard.food:
      return isUk ? 'Сезонна їжа 🍱' : 'Seasonal food 🍱';
    case DetailCard.hana:
      return isUk ? 'Сезонна квітка 🌸' : 'Seasonal flower 🌸';
    case DetailCard.colors:
      return isUk ? 'Сезонні кольори одягу 🎨' : 'Seasonal robe colours 🎨';
    case DetailCard.kodo:
      return isUk ? 'Сезонні пахощі kōdō 🪔' : 'Seasonal kōdō incense 🪔';
    case DetailCard.kigo:
      return isUk ? 'Сезонні слова 📜' : 'Seasonal words 📜';
    case DetailCard.practice:
      return isUk ? 'Практика 🪷' : 'Practice 🪷';
  }
}
