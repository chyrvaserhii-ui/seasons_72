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
        const Divider(),
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
        const Divider(),
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
        const SizedBox(height: 36),
        const _ColophonMark(),
        const SizedBox(height: 36),
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
                horizontal: 16, vertical: 14),
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
                const SizedBox(height: 10),
                const _SealStamp(size: 64),
                const SizedBox(height: 10),
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
    builder: (ctx) {
      final theme = Theme.of(ctx);
      final onSurface = theme.colorScheme.onSurface;
      return SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // okuzuke composition — kanji title → seal → year.
            // Identical vertical order to the small _ColophonMark
            // tile in Settings; the modal just renders it at a
            // larger scale.
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
            const SizedBox(height: 18),
            const Center(child: _SealStamp(size: 168)),
            const SizedBox(height: 16),
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
            const SizedBox(height: 26),
            // Decorative thin rule with a small seal-red dot — same
            // pattern the haiku block uses across the app.
            const _SealRule(),
            const SizedBox(height: 26),
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
              style: theme.textTheme.bodyMedium?.copyWith(
                color: onSurface.withValues(alpha: 0.85),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isUk
                  ? 'Між ними цвіте багряна хризантема — символ довголіття і тихої гідності. А хвиля, що тримає обох, — це сам час.'
                  : 'Between them blooms the crimson chrysanthemum — symbol of longevity and quiet dignity. And the wave that holds both is time itself.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: onSurface.withValues(alpha: 0.85),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 18),
            // Closing remark — italic, slightly larger leading. This
            // is the only paragraph in a different cut, so the eye
            // registers it as the "and finally" beat after the
            // legend prose.
            Text(
              isUk
                  ? 'Це той самий жест, що і 72 сезони: світ змінюється, увага лишається. Один день з п’яти — і вже інша квітка цвіте у горах, інша пташка заспівала на світанку.'
                  : 'It is the same gesture as the 72 seasons: the world shifts, attention stays. One day in five and already a different flower has opened in the mountains, a different bird sings at dawn.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: onSurface.withValues(alpha: 0.88),
                fontStyle: FontStyle.italic,
                height: 1.65,
                letterSpacing: 0.15,
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
          ],
        ),
      );
    },
  );
}

/// Thin rule + small crimson dot in the middle — mirrors the
/// haiku-frame seal used in [SeasonHaiku]. Closing punctuation in
/// visual form: «це я».
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
      return isUk ? 'Сезонні пахощі kōdō 🌫️' : 'Seasonal kōdō incense 🌫️';
    case DetailCard.kigo:
      return isUk ? 'Сезонні слова 📜' : 'Seasonal words 📜';
    case DetailCard.practice:
      return isUk ? 'Практика 🪷' : 'Practice 🪷';
  }
}
