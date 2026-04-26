import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seasons_72/l10n/app_localizations.dart';

import '../../core/providers/seasons_providers.dart';
import '../../core/theme/washi_background.dart';
import '../about/about_screen.dart';
import '../home/home_screen.dart';
import '../list/seasons_list_screen.dart';
import '../settings/settings_screen.dart';
import 'shell_providers.dart';

/// Root shell with bottom nav: Now / All 72 / Settings.
///
/// Reads the current kō to tint AppBar + scaffold background + bottom nav
/// with the current meta-season's color. Makes the whole app "feel" like
/// the current season without being loud.
class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  /// Bumped each time the "72 сезони" tab is tapped. Used as part of the
  /// [Key] for [SeasonsListScreen] so that every tap remounts the screen
  /// and re-triggers the auto-scroll-to-current logic in its initState.
  int _listRemountKey = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = Theme.of(context).colorScheme.surface;
    final tab = ref.watch(selectedTabProvider);

    // Pull the current season's meta color. Fall back to neutral if data
    // hasn't loaded yet (shouldn't happen given main() preloads).
    final asyncSeason = ref.watch(currentSeasonProvider);
    final repo = ref.watch(seasonsRepositoryProvider);
    final metaColor = asyncSeason.maybeWhen(
      data: (s) => repo.meta(s.metaId).colorFor(Theme.of(context).brightness),
      orElse: () => Theme.of(context).colorScheme.primary,
    );

    // Pull a darker "tint" variant of the accent for light theme so
    // the chrome reads as actually-tinted, not as off-white.
    final tintColor = asyncSeason.maybeWhen(
      data: (s) => repo.meta(s.metaId).tintColorFor(Theme.of(context).brightness),
      orElse: () => metaColor,
    );
    final scaffoldBg = Color.alphaBlend(
      (isDark ? metaColor : tintColor)
          .withValues(alpha: isDark ? 0.06 : 0.08),
      surface,
    );
    final appBarBg = Color.alphaBlend(
      (isDark ? metaColor : tintColor)
          .withValues(alpha: isDark ? 0.18 : 0.18),
      surface,
    );

    final pages = [
      const HomeScreen(),
      // ValueKey bumps whenever the tab is tapped, which remounts the
      // screen and fires its post-frame scroll-to-current.
      SeasonsListScreen(key: ValueKey('seasons-list-$_listRemountKey')),
      const AboutScreen(),
      const SettingsScreen(),
    ];
    final titles = [
      l10n.appTitle,
      l10n.allSeasonsTitle,
      l10n.tabAbout,
      l10n.settingsTitle,
    ];

    // On the home tab the AppBar gets a two-line micro-editorial title
    // (SHICHIJŪNI-KŌ tiny cap above "72 сезони"). Other tabs keep a
    // plain centered single-line title.
    PreferredSizeWidget? appBar;
    if (tab == 0) {
      appBar = AppBar(
        backgroundColor: appBarBg,
        toolbarHeight: 56,
        centerTitle: true,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'SHICHIJŪNI-KŌ',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                letterSpacing: 2.5,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.55),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              titles[tab],
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    } else if (tab != 1) {
      // list screen has its own SliverAppBar
      appBar = AppBar(
        backgroundColor: appBarBg,
        title: Text(titles[tab]),
      );
    }

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: appBar,
      body: SafeArea(
        child: WashiBackground(child: pages[tab]),
      ),
      bottomNavigationBar: NavigationBarTheme(
        // Shrink the indicator pill to be subtler and less dominant.
        data: NavigationBarThemeData(
          indicatorShape: const StadiumBorder(),
          // A much-smaller indicator (default is ~64×32; we shrink to ~48×24).
          // Achieved by wrapping the whole bar and setting constraints via theme.
          iconTheme: const WidgetStatePropertyAll(
            IconThemeData(size: 22),
          ),
        ),
        child: NavigationBar(
          backgroundColor: appBarBg,
          // Subtle tint instead of a loud oval — pairs with per-season color.
          indicatorColor: metaColor.withValues(alpha: 0.22),
          selectedIndex: tab,
          onDestinationSelected: (i) {
            if (i == 1) {
              setState(() => _listRemountKey++);
            }
            ref.read(selectedTabProvider.notifier).state = i;
          },
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.wb_sunny_outlined),
              selectedIcon: const Icon(Icons.wb_sunny),
              label: l10n.tabNow,
            ),
            NavigationDestination(
              // Grid metaphor fits a 72-item catalog better than a list.
              icon: const Icon(Icons.grid_view_outlined),
              selectedIcon: const Icon(Icons.grid_view_rounded),
              label: l10n.tabAll,
            ),
            NavigationDestination(
              icon: const Icon(Icons.auto_stories_outlined),
              selectedIcon: const Icon(Icons.auto_stories),
              label: l10n.tabAbout,
            ),
            NavigationDestination(
              // `tune` reads cleaner than a cog wheel at 22px.
              icon: const Icon(Icons.tune_outlined),
              selectedIcon: const Icon(Icons.tune),
              label: l10n.tabSettings,
            ),
          ],
        ),
      ),
    );
  }
}
