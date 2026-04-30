import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/audio/onboarding_audio_service.dart';
import '../../core/providers/seasons_providers.dart';
import '../../core/settings/settings_provider.dart';
import '../shell/shell_providers.dart';

/// Four-page onboarding for first launch.
///
/// Page 1 — "Now"      : current kō hero with name + dates.
/// Page 2 — "Hierarchy": animated 4 → 24 → 72 reveal.
/// Page 3 — "Cards"    : nine deep-dive cards as a tinted grid.
/// Page 4 — "Begin"    : final CTA, marks onboarding done and pops.
///
/// Skip button (top-right) is available on every page; tapping it
/// behaves like finishing — sets [hasSeenOnboarding] true and pops.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _controller = PageController();
  int _index = 0;

  /// True once [_finish] has kicked off the audio fade-out. Tells
  /// [dispose] to leave the singleton service alone — the fade will
  /// finish itself in the background after the screen unmounts.
  bool _fadingOut = false;

  /// Sub-phase index for Page 2's hierarchy (4 → 24 → 72). Page 2
  /// is the only page with internal steps: the user taps "Next" to
  /// reveal each tier in turn, and only after the third tap does the
  /// page actually advance to Page 3. Lives at this level (rather
  /// than inside _PageHierarchy) so the bottom "Next" button can
  /// drive it without a key/notifier dance. Total tiers = 3, so
  /// valid range is 0..2.
  int _hierarchyPhase = 0;

  /// Staged entrance animation — runs once when onboarding first
  /// opens. Three overlapping intervals compose the effect:
  ///
  ///   0.00 – 0.45  engravingAnim — engraving fades in to full
  ///                 visibility (no veil yet, full painting visible)
  ///   0.40 – 0.75  veilAnim — gradient + vignette ramp up, the
  ///                 engraving recedes into a quiet wash backdrop
  ///   0.60 – 1.00  contentAnim — text, page dots, button, speaker
  ///                 icon all fade in over the dimmed engraving
  ///
  /// After the 1.8 s sequence, swipes between pages use the existing
  /// _animatedPage cross-fade.
  late final AnimationController _entranceCtl;
  late final Animation<double> _engravingAnim;
  late final Animation<double> _veilAnim;
  late final Animation<double> _contentAnim;

  @override
  void initState() {
    super.initState();
    // Auto-start the shakuhachi loop. The audio session configured in
    // main.dart is "ambient", so iOS will refuse to play if the user
    // has the silent switch on — exactly the behaviour we want.
    OnboardingAudioService.instance.start();

    _entranceCtl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _engravingAnim = CurvedAnimation(
      parent: _entranceCtl,
      curve: const Interval(0.0, 0.45, curve: Curves.easeOutCubic),
    );
    _veilAnim = CurvedAnimation(
      parent: _entranceCtl,
      curve: const Interval(0.40, 0.75, curve: Curves.easeInOut),
    );
    _contentAnim = CurvedAnimation(
      parent: _entranceCtl,
      curve: const Interval(0.60, 1.0, curve: Curves.easeOut),
    );
    _entranceCtl.forward();
  }

  @override
  void dispose() {
    _entranceCtl.dispose();
    // If the user finished/skipped the flow, [_finish] already started
    // a graceful fade — let it run to completion instead of cutting
    // it short here. For other dispose paths (e.g. app backgrounded
    // or hot reload), stop immediately.
    if (!_fadingOut) {
      OnboardingAudioService.instance.stop();
    }
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    // Page 2 has internal sub-phases (4 → 24 → 72). Reveal one at a
    // time on each "Next" tap; only when all three have been seen do
    // we advance to Page 3. This lets the user actually read each
    // tier instead of being whisked through a 5.5s auto-timeline.
    if (_index == 1 && _hierarchyPhase < 2) {
      setState(() => _hierarchyPhase++);
      return;
    }

    if (_index < 3) {
      _controller.animateToPage(
        _index + 1,
        // Long, soft slide. 800 ms feels like an inhale-exhale — lets
        // the outgoing page recede before the incoming one establishes
        // itself. Paired with the easeInOutCubic shape we apply on
        // opacity in [_animatedPage], the transition reads as a real
        // dissolve, not a flick.
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    // Kick off a 2.5s graceful fade — running unawaited so the singleton
    // service keeps fading after this widget unmounts. The flag stops
    // dispose() from cancelling it.
    _fadingOut = true;
    OnboardingAudioService.instance.fadeOut();

    await ref
        .read(settingsProvider.notifier)
        .setHasSeenOnboarding(true);
    if (!mounted) return;
    // The router (RootRouter) listens to settings and rebuilds — popping
    // here would crash if onboarding is the topmost route. Returning
    // from this method lets the router swap to AppShell on the next
    // frame.
  }

  /// Variant of [_finish] that drops the user on the Tradition tab
  /// instead of the default Home (tab 0). Driven by the "Витоки —
  /// у вкладці «Традиція»" tap-link on Page 4: tapping it both
  /// completes onboarding and deep-links the user where they
  /// expressed interest in going.
  Future<void> _finishToTradition() async {
    // Set the desired landing tab BEFORE the router swaps screens
    // so AppShell mounts already-on-Tradition.
    ref.read(selectedTabProvider.notifier).state = 2;
    await _finish();
  }

  /// Wraps an onboarding page in opacity + slight scale tied to its
  /// distance from the currently-active page in the PageView.
  ///
  /// Two non-linearities make the cross-fade feel slow and luxurious:
  ///
  /// 1. **easeInOutCubic on opacity.** Linear opacity = 1 − distance
  ///    drops at a steady rate. Wrapping the distance in
  ///    [Curves.easeInOutCubic] holds opacity high while the scroll
  ///    starts (slow fade-out beginning), drops it through the middle
  ///    of the transition, then eases the incoming page into full
  ///    opacity at the end. The result: both pages stay readable for
  ///    a longer overlap, mimicking a film dissolve.
  ///
  /// 2. **scale 1.0 → 0.94** with the same eased distance. The
  ///    outgoing page contracts gently and the incoming one expands
  ///    into place — gives the dissolve a touch of optical depth
  ///    without ever feeling like a hard zoom.
  Widget _animatedPage({required int pageIndex, required Widget child}) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        double pageOffset;
        if (_controller.hasClients &&
            _controller.position.hasContentDimensions) {
          pageOffset = (_controller.page ?? _index.toDouble()) - pageIndex;
        } else {
          pageOffset = (_index - pageIndex).toDouble();
        }
        final distance = pageOffset.abs().clamp(0.0, 1.0);
        // Reshape the linear distance with easeInOutCubic so the
        // opacity drop/rise is concentrated in the middle of the
        // transition, leaving long held-on tails at both ends.
        final shaped = Curves.easeInOutCubic.transform(distance);
        final opacity = (1.0 - shaped).clamp(0.0, 1.0);
        final scale = 1.0 - (shaped * 0.06);
        return Opacity(
          opacity: opacity,
          child: Transform.scale(
            scale: scale,
            child: child,
          ),
        );
      },
    );
  }

  /// Picks the engraving displayed behind page [pageIndex].
  ///
  /// Each page has its own purpose-generated background in
  /// `assets/images/onboarding/page{N}.png` — none of these are
  /// reused from the kō illustrations, so the four pages feel
  /// distinct and the visual doesn't repeat anywhere else in the
  /// app. The [currentKoIndex] argument is unused for now but kept
  /// in the signature in case page 1 ever needs to fall back to a
  /// kō illustration when a custom asset is missing.
  String _backgroundFor(int pageIndex, int currentKoIndex) {
    switch (pageIndex) {
      case 0:
        return 'assets/images/onboarding/page1.png';
      case 1:
        return 'assets/images/onboarding/page2.png';
      case 2:
        return 'assets/images/onboarding/page3.png';
      case 3:
      default:
        return 'assets/images/onboarding/page4.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUk = Localizations.localeOf(context).languageCode == 'uk';
    final scheme = Theme.of(context).colorScheme;
    final onSurface = scheme.onSurface;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final asyncCurrent = ref.watch(currentSeasonProvider);
    final repo = ref.watch(seasonsRepositoryProvider);

    final currentKoIndex = asyncCurrent.maybeWhen(
      data: (ko) => ko.index as int,
      orElse: () => 11, // sakura fallback if seasons haven't loaded yet
    );
    final bgPath = _backgroundFor(_index, currentKoIndex);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background ukiyo-e engraving — cross-fades whenever the
          // user swipes to a new page. Three filters stack on top of
          // the image to give it a quiet, painterly feel:
          //   • ColorFiltered with a faint amber multiply — adds a
          //     warm "old-paper" cast so the modern PNG doesn't read
          //     as a literal photo.
          //   • ImageFiltered Gaussian blur (6 sigma) — softens the
          //     engraving into a memory rather than a hard scene; the
          //     onboarding text is the focus, not the brushstrokes.
          //   • BoxFit.cover so there are no letterbox bars.
          // Background engraving — phase 1 of the entrance animation.
          // Fades in from 0 → 1 over the first 45% of the timeline so
          // the user sees the full painting before the veil arrives.
          Positioned.fill(
            child: FadeTransition(
              opacity: _engravingAnim,
              child: ClipRect(
                child: AnimatedSwitcher(
                  // Engraving cross-fade is intentionally a touch
                  // longer than the page slide (800 ms) so the
                  // background lingers under the new page — feels
                  // like the painting is exhaling into the next.
                  duration: const Duration(milliseconds: 900),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  child: ColorFiltered(
                    key: ValueKey(bgPath),
                    colorFilter: ColorFilter.mode(
                      const Color(0xFFE8C18A).withValues(alpha: 0.30),
                      BlendMode.softLight,
                    ),
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                      child: Transform.scale(
                        scale: 1.4,
                        child: Image.asset(
                          bgPath,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Container(color: scheme.surface),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Veil — phase 2 of the entrance. Fades in 0.40–0.75 of
          // the timeline so the engraving "recedes" into a wash
          // backdrop after the user has seen it clearly. Alpha values
          // are tuned for legibility: body copy needs solid surface
          // backing to clear WCAG AA over the painterly engraving.
          // Light-theme alphas are bumped further than dark because
          // the engraving's mid-tones happen to land near the page
          // surface luminance, washing out body text otherwise.
          Positioned.fill(
            child: FadeTransition(
              opacity: _veilAnim,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      scheme.surface.withValues(alpha: isDark ? 0.45 : 0.72),
                      scheme.surface.withValues(alpha: isDark ? 0.65 : 0.85),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Vignette — same phase as veil, ramps in together so the
          // dimming reads as a single beat.
          Positioned.fill(
            child: IgnorePointer(
              child: FadeTransition(
                opacity: _veilAnim,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 1.05,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: isDark ? 0.50 : 0.28),
                      ],
                      stops: const [0.50, 1.0],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Content — phase 3 of the entrance. Text, page dots, button
          // and corner controls all fade in over the dimmed engraving.
          FadeTransition(
            opacity: _contentAnim,
            child: SafeArea(
            child: Stack(
          children: [
            PageView(
              controller: _controller,
              onPageChanged: (i) => setState(() => _index = i),
              children: [
                _animatedPage(
                  pageIndex: 0,
                  child: _PageNow(
                    asyncCurrent: asyncCurrent,
                    repo: repo,
                    isUk: isUk,
                  ),
                ),
                _animatedPage(
                  pageIndex: 1,
                  child: _PageHierarchy(
                    asyncCurrent: asyncCurrent,
                    isUk: isUk,
                    phase: _hierarchyPhase,
                  ),
                ),
                _animatedPage(
                  pageIndex: 2,
                  child: _PageCards(isUk: isUk, isVisible: _index == 2),
                ),
                _animatedPage(
                  pageIndex: 3,
                  child: _PageBegin(
                    isUk: isUk,
                    isVisible: _index == 3,
                    onOpenTradition: _finishToTradition,
                  ),
                ),
              ],
            ),

            // Speaker mute toggle — top-left, semi-transparent.
            // Listens to BOTH isPlaying (true = music emitting) and
            // silenced (true = auto-start was muted by iOS silent
            // switch). The icon has three states:
            //   • playing  → volume_up (sound currently audible)
            //   • silenced → volume_off (struck-through; tap to play)
            //   • paused   → volume_off (user-muted)
            // Tapping in any state calls toggle(), which uses the
            // override-silent path so playback always succeeds.
            Positioned(
              top: 6,
              left: 6,
              child: ValueListenableBuilder<bool>(
                valueListenable:
                    OnboardingAudioService.instance.isPlaying,
                builder: (_, isPlaying, __) {
                  return ValueListenableBuilder<bool>(
                    valueListenable:
                        OnboardingAudioService.instance.silenced,
                    builder: (_, silenced, __) {
                      // Pick icon. When iOS silent switch muted
                      // auto-start, render `volume_off` — the
                      // universal "muted" glyph — so the user knows
                      // why no music plays. The tap action remains
                      // toggle() which forces playback regardless.
                      final icon = isPlaying
                          ? Icons.volume_up_rounded
                          : Icons.volume_off_rounded;
                      // When silenced, dim the speaker AND show a
                      // small struck-through bar overlay so it reads
                      // unambiguously as "muted by system".
                      final showSilencedOverlay = silenced && !isPlaying;
                      return Opacity(
                        opacity: 0.62,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            IconButton(
                              onPressed: () => OnboardingAudioService
                                  .instance
                                  .toggle(),
                              icon: Icon(
                                icon,
                                color: onSurface,
                                size: 22,
                              ),
                              tooltip: isUk
                                  ? (isPlaying
                                      ? 'Вимкнути звук'
                                      : silenced
                                          ? 'Беззвучний режим — тапни, щоб увімкнути'
                                          : 'Увімкнути звук')
                                  : (isPlaying
                                      ? 'Mute'
                                      : silenced
                                          ? 'Silent mode — tap to play'
                                          : 'Unmute'),
                            ),
                            // Diagonal struck-through bar — drawn
                            // on top of the speaker icon when iOS
                            // silenced us. Same colour as the icon
                            // so it reads as part of the glyph.
                            if (showSilencedOverlay)
                              IgnorePointer(
                                child: Transform.rotate(
                                  angle: -0.78, // ~ -45°
                                  child: Container(
                                    width: 26,
                                    height: 2.2,
                                    decoration: BoxDecoration(
                                      color: onSurface,
                                      borderRadius:
                                          BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // Skip — top-right, hidden on the last page where the
            // primary CTA already exists.
            if (_index < 3)
              Positioned(
                top: 6,
                right: 12,
                child: TextButton(
                  onPressed: _finish,
                  child: Text(
                    isUk ? 'Пропустити' : 'Skip',
                    style: TextStyle(
                      color: onSurface.withValues(alpha: 0.85),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.4,
                      shadows: [
                        Shadow(
                          blurRadius: 6,
                          color: Colors.black.withValues(alpha: 0.20),
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Bottom controls — page indicator + Next/Begin button.
            // Sits on a frost-glass surface (BackdropFilter blur +
            // soft top-fade) so the engraving is still faintly
            // visible above the controls but the buttons read
            // crisply. Native-iOS feel without third-party libraries.
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          scheme.surface.withValues(alpha: 0.0),
                          scheme.surface
                              .withValues(alpha: isDark ? 0.55 : 0.50),
                        ],
                        stops: const [0.0, 0.45],
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(0, 22, 0, 28),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _PageDots(
                          count: 4,
                          active: _index,
                          onSurface: onSurface,
                          accent: scheme.primary,
                        ),
                        const SizedBox(height: 18),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32),
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: FilledButton(
                              onPressed: _next,
                              style: FilledButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(14),
                                ),
                              ),
                              child: Text(
                                _index == 3
                                    ? (isUk ? 'Почати' : 'Begin')
                                    : (isUk ? 'Далі' : 'Next'),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
          ),
          ),
        ],
      ),
    );
  }
}

// ─── Page 1 — Today's kō ────────────────────────────────────────────
class _PageNow extends StatelessWidget {
  const _PageNow({
    required this.asyncCurrent,
    required this.repo,
    required this.isUk,
  });

  final AsyncValue asyncCurrent;
  final dynamic repo;
  final bool isUk;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    // A tiny soft drop-shadow on body text — keeps prose legible even
    // when it lands over a lighter patch of the engraving. Used
    // throughout the four pages to push contrast a notch up without
    // turning the typography into stamped UI.
    final softShadow = [
      Shadow(
        blurRadius: 8,
        color: Colors.black.withValues(alpha: 0.22),
        offset: const Offset(0, 1),
      ),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 56, 28, 160),
      child: asyncCurrent.maybeWhen(
        data: (ko) {
          final meta = repo.meta(ko.metaId);
          // For light theme, prefer the deeper "tint" hue for text —
          // the pastel light variant disappears against the
          // light-theme veil. Dark theme keeps the bright pastel
          // because it pops on near-black.
          final brightness = Theme.of(context).brightness;
          final accent = brightness == Brightness.dark
              ? meta.colorFor(brightness)
              : meta.tintColorFor(brightness);
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Eyebrow caps — declares the page's promise before the
              // user reads a word. Mirrors the Home screen's "ЗАРАЗ
              // ТРИВАЄ" header so the user lands on a familiar phrase
              // when onboarding ends and they arrive at the real Now
              // tab. Accent-tinted to match the active kō.
              Text(
                isUk ? 'ЗАРАЗ ТРИВАЄ САМЕ ЦЕЙ СЕЗОН' : 'THIS SEASON IS UNFOLDING NOW',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.0,
                  color: accent,
                  shadows: softShadow,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 22),
              Text(
                ko.kanji,
                style: TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.w600,
                  color: accent,
                  height: 1.05,
                  shadows: softShadow,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                isUk ? ko.nameUk : ko.nameEn,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: onSurface,
                  height: 1.25,
                  shadows: softShadow,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                _dateRange(ko, isUk),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: onSurface.withValues(alpha: 0.78),
                  letterSpacing: 0.4,
                  shadows: softShadow,
                ),
              ),
              const SizedBox(height: 36),
              Container(
                width: 60,
                height: 1,
                color: accent.withValues(alpha: 0.55),
              ),
              const SizedBox(height: 36),
              Text(
                isUk
                    ? 'Це один із 72 крихітних сезонів японського року — по 5 днів кожен. Саме зараз триває цей.'
                    : 'This is one of 72 tiny seasons in the Japanese year — five days each. Right now, this is the one unfolding.',
                style: TextStyle(
                  fontSize: 15.5,
                  height: 1.55,
                  fontWeight: FontWeight.w500,
                  color: onSurface.withValues(alpha: 0.96),
                  shadows: softShadow,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          );
        },
        orElse: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  String _dateRange(dynamic ko, bool isUk) {
    final monthsUk = [
      '', 'січня', 'лютого', 'березня', 'квітня', 'травня',
      'червня', 'липня', 'серпня', 'вересня', 'жовтня',
      'листопада', 'грудня',
    ];
    final monthsEn = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final m = isUk ? monthsUk : monthsEn;
    return isUk
        ? '${ko.startDay} ${m[ko.startMonth]} – ${ko.endDay} ${m[ko.endMonth]}'
        : '${m[ko.startMonth]} ${ko.startDay} – ${m[ko.endMonth]} ${ko.endDay}';
  }
}

// ─── Page 2 — 4 → 24 → 72 hierarchy ─────────────────────────────────
//
// Stateless: the [phase] prop is driven by the parent's "Next" button.
// Each phase introduces ONE concept (4 → 24 → 72), with a long enough
// dwell that the user can actually read it. AnimatedSwitcher
// cross-fades the visual + prose when phase changes; a tiny three-bar
// step indicator at the top tells the user there's a 1-2-3 reveal so
// the first "Next" tap doesn't feel stuck.
class _PageHierarchy extends StatelessWidget {
  const _PageHierarchy({
    required this.asyncCurrent,
    required this.isUk,
    required this.phase,
  });

  final AsyncValue asyncCurrent;
  final bool isUk;
  final int phase;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final onSurface = scheme.onSurface;
    final accent = scheme.primary;

    final currentIndex = asyncCurrent.maybeWhen(
      data: (ko) => ko.index as int,
      orElse: () => 1,
    );

    // Meta-season palette aligned with seasons.json.
    const metaColors = [
      Color(0xFFF4B5C1), // spring
      Color(0xFF8FBF7F), // summer
      Color(0xFFD89060), // autumn
      Color(0xFF8DAAC7), // winter
    ];
    const metaKanji = ['春', '夏', '秋', '冬'];

    final dim = onSurface.withValues(alpha: 0.55);

    final Widget child;
    if (phase == 0) {
      child = _Phase4Seasons(
        key: const ValueKey('p0'),
        isUk: isUk,
        metaColors: metaColors,
        metaKanji: metaKanji,
        onSurface: onSurface,
        dim: dim,
      );
    } else if (phase == 1) {
      child = _Phase24Sekki(
        key: const ValueKey('p1'),
        isUk: isUk,
        metaColors: metaColors,
        onSurface: onSurface,
        dim: dim,
      );
    } else {
      child = _Phase72Ko(
        key: const ValueKey('p2'),
        isUk: isUk,
        metaColors: metaColors,
        onSurface: onSurface,
        dim: dim,
        currentIndex: currentIndex,
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 160),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            isUk ? 'Як це працює' : 'How it works',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: onSurface,
              shadows: [
                Shadow(
                  blurRadius: 8,
                  color: Colors.black.withValues(alpha: 0.18),
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          // Three thin segments — Stories-style indicator. Tells the
          // user there's a stepwise reveal so the first "Next" tap
          // doesn't feel like the page failed to advance.
          _PhaseSteps(active: phase, total: 3, accent: accent, dim: dim),
          const SizedBox(height: 18),
          // Single-focus content area. AnimatedSwitcher cross-fades
          // between the three phase widgets when [phase] changes.
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 700),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

/// Stories-style step indicator for Page 2. Three short bars; the
/// active one fills with accent, the others are dim. A small bar
/// header is enough — louder UI here would compete with the bottom
/// page dots.
class _PhaseSteps extends StatelessWidget {
  const _PhaseSteps({
    required this.active,
    required this.total,
    required this.accent,
    required this.dim,
  });
  final int active;
  final int total;
  final Color accent;
  final Color dim;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final isDone = i <= active;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: 26,
          height: 3,
          decoration: BoxDecoration(
            color: isDone ? accent : dim.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }
}

// ─── Page 2 phase widgets ───────────────────────────────────────────
//
// Each phase widget owns the full content area for ~3.7 seconds.
// Same vertical layout: big number, small caps role, visual, prose
// description. The visual and prose change between phases; the
// scaffolding stays the same so the user's eye doesn't jump as the
// content cross-fades.

class _Phase4Seasons extends StatelessWidget {
  const _Phase4Seasons({
    super.key,
    required this.isUk,
    required this.metaColors,
    required this.metaKanji,
    required this.onSurface,
    required this.dim,
  });
  final bool isUk;
  final List<Color> metaColors;
  final List<String> metaKanji;
  final Color onSurface;
  final Color dim;

  @override
  Widget build(BuildContext context) {
    final names = isUk
        ? ['Весна', 'Літо', 'Осінь', 'Зима']
        : ['Spring', 'Summer', 'Autumn', 'Winter'];
    return _PhaseScaffold(
      bigNumber: '4',
      role: isUk ? 'ПОРИ РОКУ' : 'SEASONS OF THE YEAR',
      onSurface: onSurface,
      dim: dim,
      visual: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(4, (i) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: metaColors[i].withValues(alpha: 0.30),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: metaColors[i].withValues(alpha: 0.65),
                      width: 1.2),
                ),
                child: Text(
                  metaKanji[i],
                  style: const TextStyle(
                      fontSize: 26, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                names[i],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: onSurface.withValues(alpha: 0.96),
                  shadows: [
                    Shadow(
                      blurRadius: 6,
                      color: Colors.black.withValues(alpha: 0.20),
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
      prose: isUk
          ? 'Усі знають 4 пори року: весна, літо, осінь, зима. Але східна традиція ділить рік ще тонше — кожна пора розпадається на 24 фази (секкі), а ті — на 72 короткі сезони природи (кō).'
          : 'Everyone grew up with 4 seasons: spring, summer, autumn, winter. But Eastern tradition slices the year much finer — each season breaks into 24 phases (sekki), and those — into 72 short seasons of nature (kō).',
    );
  }
}

class _Phase24Sekki extends StatelessWidget {
  const _Phase24Sekki({
    super.key,
    required this.isUk,
    required this.metaColors,
    required this.onSurface,
    required this.dim,
  });
  final bool isUk;
  final List<Color> metaColors;
  final Color onSurface;
  final Color dim;

  @override
  Widget build(BuildContext context) {
    return _PhaseScaffold(
      bigNumber: '24',
      role: isUk
          ? 'ПІДСЕЗОНИ — японці звуть їх СЕККІ'
          : 'SUB-SEASONS — Japanese call them SEKKI',
      onSurface: onSurface,
      dim: dim,
      visual: _SekkiRow(metaColors: metaColors),
      prose: isUk
          ? 'Кожна з 4 пір року ділиться на 6 секкі — це періоди по 15 днів. У кожного власна назва й настрій: «початок весни», «хлібний дощ», «малий холод» тощо.'
          : 'Each of the 4 seasons splits into 6 sekki — ~15-day periods. Each has its own name and feel: "start of spring", "grain rain", "minor cold".',
    );
  }
}

class _Phase72Ko extends StatelessWidget {
  const _Phase72Ko({
    super.key,
    required this.isUk,
    required this.metaColors,
    required this.onSurface,
    required this.dim,
    required this.currentIndex,
  });
  final bool isUk;
  final List<Color> metaColors;
  final Color onSurface;
  final Color dim;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final metaIdx = ((currentIndex - 1) ~/ 18).clamp(0, 3);
    return _PhaseScaffold(
      bigNumber: '72',
      role: isUk
          ? 'МІКРО-СЕЗОНИ — японці звуть їх КŌ'
          : 'MICRO-SEASONS — Japanese call them KŌ',
      onSurface: onSurface,
      dim: dim,
      visual: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _KoGrid(metaColors: metaColors, currentIndex: currentIndex),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: metaColors[metaIdx],
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: metaColors[metaIdx].withValues(alpha: 0.7),
                      blurRadius: 7,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                isUk ? 'ось у якому ми зараз' : 'this is the one we\u2019re in',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: onSurface.withValues(alpha: 0.96),
                  letterSpacing: 0.3,
                  shadows: [
                    Shadow(
                      blurRadius: 6,
                      color: Colors.black.withValues(alpha: 0.20),
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      prose: isUk
          ? 'Кожне секкі вміщає 3 кō по 5 днів. Один кō ловить одну тонку зміну в природі: «персики цвітуть», «жаби заспівали», «перші морози». Цей застосунок — про опис та зміни кō.'
          : 'Each sekki holds 3 kō, 5 days each. A single kō captures one subtle shift in nature: "peach blossoms", "frogs begin to call", "first frosts". This app is about them.',
    );
  }
}

/// Shared layout shell for the three Page-2 phases. Same big number
/// at the top, role caps below, visual in the middle, prose at the
/// bottom — keeps the user's gaze stable as content cross-fades.
class _PhaseScaffold extends StatelessWidget {
  const _PhaseScaffold({
    required this.bigNumber,
    required this.role,
    required this.visual,
    required this.prose,
    required this.onSurface,
    required this.dim,
  });
  final String bigNumber;
  final String role;
  final Widget visual;
  final String prose;
  final Color onSurface;
  final Color dim;

  @override
  Widget build(BuildContext context) {
    final softShadow = [
      Shadow(
        blurRadius: 8,
        color: Colors.black.withValues(alpha: 0.22),
        offset: const Offset(0, 1),
      ),
    ];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          bigNumber,
          style: TextStyle(
            fontSize: 72,
            // Slightly heavier than light-300 — same elegant feel but
            // the strokes don't blend into the engraving anymore.
            fontWeight: FontWeight.w400,
            color: onSurface,
            height: 1.0,
            letterSpacing: -2,
            shadows: softShadow,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          role,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
            // Boosted from `dim` (alpha 0.55) to ~0.85 so the role
            // line carries readable weight even on light patches of
            // the engraving.
            color: onSurface.withValues(alpha: 0.85),
            shadows: softShadow,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 28),
        visual,
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            prose,
            style: TextStyle(
              fontSize: 15,
              height: 1.55,
              fontWeight: FontWeight.w500,
              color: onSurface.withValues(alpha: 0.96),
              shadows: softShadow,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

// ─── Page 2 helper widgets ──────────────────────────────────────────

/// Small caps label that names a tier in the hierarchy diagram.
/// The optional [subtext] sits underneath in a softer style — used
/// to introduce the Japanese term + duration ("японська назва: секкі ·
/// по 15 днів") without making the main label dense.
class _TierLabel extends StatelessWidget {
  const _TierLabel({
    required this.text,
    this.subtext,
    required this.color,
  });
  final String text;
  final String? subtext;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
            color: color,
          ),
        ),
        if (subtext != null) ...[
          const SizedBox(height: 3),
          Text(
            subtext!,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              color: color.withValues(alpha: 0.85),
              letterSpacing: 0.2,
            ),
          ),
        ],
      ],
    );
  }
}

/// Vertical arrow + caption between two tiers — explains *how* the
/// upper tier breaks down into the lower one. Sized intentionally
/// short so all three tiers fit on a single screen.
class _Connector extends StatelessWidget {
  const _Connector({required this.text, required this.color});
  final String text;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.arrow_downward_rounded, size: 16, color: color),
          const SizedBox(height: 2),
          Text(
            text,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: color,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

/// 24 sekki dots arranged in 4 visible groups of 6 — mapping each
/// group of 6 onto its meta-season's colour, with a small gap between
/// groups so the "6 sekki per season" claim reads at a glance.
class _SekkiRow extends StatelessWidget {
  const _SekkiRow({required this.metaColors});
  final List<Color> metaColors;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int g = 0; g < 4; g++) ...[
          for (int i = 0; i < 6; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.5),
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: metaColors[g].withValues(alpha: 0.75),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          if (g < 3) const SizedBox(width: 10),
        ],
      ],
    );
  }
}

/// 72 kō dots, grouped 3-by-3 (one group per sekki), wrapped onto
/// multiple lines. The current kō has a brighter glow + a +50% size
/// boost so the eye finds it instantly inside the 72-dot pattern.
class _KoGrid extends StatelessWidget {
  const _KoGrid({
    required this.metaColors,
    required this.currentIndex,
  });
  final List<Color> metaColors;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    // Build 24 mini-groups of 3 dots each. Wrap into rows of 8 groups
    // (= 24 dots per row) to keep the diagram three rows tall.
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 7, // gap between groups
      runSpacing: 7,
      children: List.generate(24, (groupIdx) {
        final metaIdx = groupIdx ~/ 6;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (j) {
            final i = groupIdx * 3 + j; // 0..71
            final isCurrent = (i + 1) == currentIndex;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1.5),
              child: Container(
                width: isCurrent ? 9 : 5.5,
                height: isCurrent ? 9 : 5.5,
                decoration: BoxDecoration(
                  color: isCurrent
                      ? metaColors[metaIdx]
                      : metaColors[metaIdx].withValues(alpha: 0.45),
                  shape: BoxShape.circle,
                  boxShadow: isCurrent
                      ? [
                          BoxShadow(
                            color: metaColors[metaIdx]
                                .withValues(alpha: 0.7),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
              ),
            );
          }),
        );
      }),
    );
  }
}

// ─── Page 3 — Cards grid ────────────────────────────────────────────
//
// Cards reveal in three waves of three (top row → middle → bottom),
// each wave lagging behind the previous by ~400ms. After all nine
// have appeared, the supporting prose lines fade in. Visually it
// feels like a page slowly setting itself up rather than dumping
// all nine tiles at once.
class _PageCards extends StatefulWidget {
  const _PageCards({required this.isUk, required this.isVisible});
  final bool isUk;
  final bool isVisible;

  @override
  State<_PageCards> createState() => _PageCardsState();
}

class _PageCardsState extends State<_PageCards>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctl;
  late final Animation<double> _titleAnim;
  late final Animation<double> _subtitleAnim;
  late final Animation<double> _row1Anim;
  late final Animation<double> _row2Anim;
  late final Animation<double> _row3Anim;
  late final Animation<double> _captionAnim;

  @override
  void initState() {
    super.initState();
    _ctl = AnimationController(
      vsync: this,
      // Total bumped 6000 → 8500ms so the sequential card pulse can
      // breathe. With 9 cards × 850ms-wide pulses (formerly 300ms)
      // and a small overlap between adjacent cards, the staircase
      // reads as a slow continuous wave rather than nine quick
      // flashes — matches the rest of the app's quiet pacing.
      duration: const Duration(milliseconds: 8500),
    );
    // Phase map (proportions of the 8500ms timeline):
    //   0.00–0.06  title             (~510ms)
    //   0.06–0.13  subtitle          (~595ms)
    //   0.13–0.21  row1 fade-in      (~680ms)
    //   0.21–0.29  row2 fade-in      (~680ms)
    //   0.29–0.37  row3 fade-in      (~680ms)
    //   0.37–0.42  breath
    //   0.42–0.94  pulse phase: 9 cards, each window 0.10 wide
    //              (= ~850ms), stride 0.055 between starts so adjacent
    //              cards overlap ~0.045 — produces the continuous
    //              wave effect rather than nine isolated blinks.
    //              Tile-side constants: see [_CardGridTile].
    //   0.94–1.00  caption
    _titleAnim = CurvedAnimation(
        parent: _ctl,
        curve: const Interval(0.0, 0.06, curve: Curves.easeOut));
    _subtitleAnim = CurvedAnimation(
        parent: _ctl,
        curve: const Interval(0.06, 0.13, curve: Curves.easeOut));
    _row1Anim = CurvedAnimation(
        parent: _ctl,
        curve: const Interval(0.13, 0.21, curve: Curves.easeOut));
    _row2Anim = CurvedAnimation(
        parent: _ctl,
        curve: const Interval(0.21, 0.29, curve: Curves.easeOut));
    _row3Anim = CurvedAnimation(
        parent: _ctl,
        curve: const Interval(0.29, 0.37, curve: Curves.easeOut));
    _captionAnim = CurvedAnimation(
        parent: _ctl,
        curve: const Interval(0.94, 1.0, curve: Curves.easeOut));
    if (widget.isVisible) _ctl.forward();
  }

  @override
  void didUpdateWidget(covariant _PageCards old) {
    super.didUpdateWidget(old);
    if (widget.isVisible && !old.isVisible) {
      _ctl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  // Each entry: kanji + Ukrainian/English name + a one-line
  // description that's poetic enough to feel like part of the app's
  // voice but specific enough to tell the user what's actually
  // inside. Errors fixed in this pass:
  //   • Period was "where it sits" — too neutral; matches user phrasing
  //   • Food was "blooms right now" — wrong verb for food; replaced
  //     with "at its time" which works for both ingredients and dishes
  //   • Incense was singular; renamed to plural "Пахощі" / "Incenses"
  //     and the description now says what it actually is (a kōdō
  //     blend, the smell-portrait of this kō).
  // 9 cultural traditions paired to each kō, ordered by UX rhythm:
  // context → senses → meaning → action.
  //
  //   1. sekki    — calendrical scaffold (when am I in the year?)
  //   2. hana     — what blooms now (sight)
  //   3. food     — what to eat this week (taste, actionable)
  //   4. tea      — what to drink today (taste, intimate)
  //   5. colors   — what to see / wear (sight, aesthetic)
  //   6. kodo     — incense (smell)
  //   7. kigo     — seasonal words (language)
  //   8. kotowaza — proverb (wisdom, reflection)
  //   9. practice — what to do this week (closing CTA)
  //
  // Period (dates) was lifted out earlier — it's now a single inline
  // strip ([PeriodStrip]) on Home and Detail. Kotowaza took the 9th
  // slot since it has real per-kō content like the others.
  static const List<_CardSpec> _cards = [
    _CardSpec('節', 'Підсезон', 'Sub-season',
        'ширше дихання — секкі, у якому живе кō',
        'the wider breath — the sekki this kō lives in',
        Color(0xFF8E9C5C)), // moss-olive rice paddy — matches SekkiCard
    _CardSpec('花', 'Квітка', 'Flower',
        'що розквітло в японських садах тепер',
        'what\'s opening in Japanese gardens now',
        Color(0xFFE6A4B4)),
    _CardSpec('食', 'Їжа', 'Food',
        'японська страва, що зараз у своєму часі',
        'a Japanese dish at its time',
        Color(0xFFD89060)),
    _CardSpec('茶', 'Чай', 'Tea',
        'китайський сорт під настрій цих днів',
        'a Chinese tea tuned to these days',
        Color(0xFF8FBF7F)),
    _CardSpec('色', 'Кольори одягу', 'Robe colours',
        'палітра кімоно з епохи Хейан для цих днів',
        'Heian kimono palette for these days',
        Color(0xFF8DAAC7)),
    _CardSpec('香', 'Пахощі', 'Incense',
        'кōдō — як пахне цей кō',
        'kōdō — how this kō smells',
        Color(0xFFB8956A)),
    _CardSpec('語', 'Слова', 'Words',
        'кіґо — слова, якими пишуть цей сезон',
        'kigo — words used to write this season',
        Color(0xFF3E5C8A)),
    _CardSpec('諺', 'Прислів’я', 'Proverb',
        'котовадза — японське прислів’я цього сезону',
        'kotowaza — a Japanese proverb tied to this season',
        Color(0xFF6F5B73)), // kodai-murasaki — matches KotowazaCard
    _CardSpec('養', 'Практика', 'Practice',
        'що поїсти, помітити й тихо зробити',
        'what to eat, notice, and quietly do',
        Color(0xFF809B92)),
  ];

  @override
  Widget build(BuildContext context) {
    final isUk = widget.isUk;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 160),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FadeTransition(
            opacity: _titleAnim,
            child: Text(
              // Shorter copy so the title fits on a single line.
              // Previous "Чим наповнений кожен сезон (кō)" wrapped
              // to two lines on most phones; "Чим живе кожен кō"
              // is the same idea (what fills the season) in 17
              // characters, which fits comfortably at 22 pt.
              isUk
                  ? 'Чим живе кожен кō'
                  : 'Inside every kō',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: onSurface,
                height: 1.2,
                shadows: [
                  Shadow(
                    blurRadius: 8,
                    color: Colors.black.withValues(alpha: 0.18),
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Big gap before the subtitle: that label introduces the 3×3
          // grid below it, not the title above. Pulled the subtitle
          // down so it visually anchors to the cards rather than to
          // the page heading. Counter-balanced by a tighter
          // subtitle→grid gap (10 px instead of 18) below.
          const SizedBox(height: 28),
          FadeTransition(
            opacity: _subtitleAnim,
            child: Text(
              isUk
                  ? 'Дев\u2019ять граней традиції — кожна оживає у деталях сезону:'
                  : 'Nine facets of tradition — each comes alive in season details:',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: onSurface.withValues(alpha: 0.94),
                height: 1.4,
                shadows: [
                  Shadow(
                    blurRadius: 6,
                    color: Colors.black.withValues(alpha: 0.20),
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Tight subtitle→grid gap (was 18, now 10) — the subtitle
          // is the label for the cards, so it should hug the grid
          // visually instead of floating between title and grid.
          const SizedBox(height: 10),
          // 3×3 grid of square tiles (kanji + name) — fits comfortably
          // without scrolling on any iPhone. Established UI pattern
          // for "categories overview" (iOS Settings, App Store
          // categories, Google apps drawer): icons + labels at a
          // glance, no descriptions on the preview level. The actual
          // descriptive copy lives in the per-card sheets users open
          // from the season detail screen.
          //
          // Three rows reveal in sequence (row1 → row2 → row3) so the
          // grid still unfolds rather than appearing all at once.
          Expanded(
            child: Column(
              // Stretch is essential here: without it the inner
              // Column passes loose width to its children, and
              // [Row]/[Expanded] inside `_CardGridRow` collapse to
              // zero width — the tiles render but the
              // [AspectRatio] inside ends up 0×0 and they vanish.
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeTransition(
                  opacity: _row1Anim,
                  child: _CardGridRow(
                    cards: _cards.sublist(0, 3),
                    globalStartIndex: 0,
                    pulseListenable: _ctl,
                    isUk: isUk,
                  ),
                ),
                const SizedBox(height: 10),
                FadeTransition(
                  opacity: _row2Anim,
                  child: _CardGridRow(
                    cards: _cards.sublist(3, 6),
                    globalStartIndex: 3,
                    pulseListenable: _ctl,
                    isUk: isUk,
                  ),
                ),
                const SizedBox(height: 10),
                FadeTransition(
                  opacity: _row3Anim,
                  child: _CardGridRow(
                    cards: _cards.sublist(6, 9),
                    globalStartIndex: 6,
                    pulseListenable: _ctl,
                    isUk: isUk,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          FadeTransition(
            opacity: _captionAnim,
            child: Text(
              isUk
                  ? 'Будь-яку можна сховати в налаштуваннях, якщо вона не близька.'
                  : 'Hide any of them in Settings if it\u2019s not your thing.',
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                fontWeight: FontWeight.w500,
                color: onSurface.withValues(alpha: 0.86),
                shadows: [
                  Shadow(
                    blurRadius: 6,
                    color: Colors.black.withValues(alpha: 0.20),
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

/// One horizontal row of three square tiles in Page 3's 3×3 grid.
/// Each tile is [Expanded] so the row evenly fills the available
/// width, with a 10-px gap between tiles. Three of these rows stack
/// vertically and fade in as separate waves, giving the grid a
/// sense of unfolding rather than landing all nine tiles at once.
///
/// Using `MainAxisSize.min` so the [Row] sizes its height to the
/// tallest child (the [AspectRatio] inside the tile). Avoiding
/// `CrossAxisAlignment.stretch` is critical: in our unbounded
/// vertical context the stretch makes children try to fill an
/// infinite height, and the tiles silently collapse to 0×0. With
/// the default `center` cross-axis alignment, [AspectRatio] sizes
/// itself from the tight width handed down by [Expanded] and the
/// row picks up that height naturally.
class _CardGridRow extends StatelessWidget {
  const _CardGridRow({
    required this.cards,
    required this.globalStartIndex,
    required this.pulseListenable,
    required this.isUk,
    this.slotCount,
  });
  final List<_CardSpec> cards;

  /// Index of the FIRST card in this row within the full grid (0 for
  /// row 1, 3 for row 2, 6 for row 3). Each tile's pulse window is
  /// computed from `globalStartIndex + localIndex`, so the sweep
  /// goes 1 → 8 across all rows even though each row is its own widget.
  final int globalStartIndex;

  /// Animation that drives the sequential pulse — usually the page's
  /// master `_ctl`. Each tile reads the current value to decide whether
  /// it's currently in its own pulse window.
  final Animation<double> pulseListenable;

  final bool isUk;

  /// Optional fixed number of "slots" this row should occupy. When
  /// `slotCount` is greater than `cards.length`, the leftover slots
  /// are filled with empty Spacers split evenly on both sides — the
  /// cards remain the same width as upper-row cards but center-align
  /// in the row. Used for the last row of the 8-card grid where there
  /// are only 2 cards but the visual rhythm should match the 3-card
  /// rows above.
  final int? slotCount;

  @override
  Widget build(BuildContext context) {
    final slots = slotCount ?? cards.length;
    final emptySlots = slots - cards.length;
    final leadingSpacers = emptySlots ~/ 2;
    final trailingSpacers = emptySlots - leadingSpacers;

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        // Leading empty slots — each gets the same flex weight as a
        // card slot, so the cards keep the upper-row width.
        for (int i = 0; i < leadingSpacers; i++) ...[
          const Spacer(),
          const SizedBox(width: 10),
        ],
        for (int i = 0; i < cards.length; i++) ...[
          if (i > 0) const SizedBox(width: 10),
          Expanded(
            child: _CardGridTile(
              spec: cards[i],
              cardIndex: globalStartIndex + i,
              pulseListenable: pulseListenable,
              isUk: isUk,
            ),
          ),
        ],
        for (int i = 0; i < trailingSpacers; i++) ...[
          const SizedBox(width: 10),
          const Spacer(),
        ],
      ],
    );
  }
}

/// Single square tile in the 3×3 category grid. Holds a large kanji
/// (the visual identifier) above a short caps-styled name.
///
/// No description text on the tile itself — the page is a categorical
/// overview ("here's what each kō contains"), and putting paragraphs
/// inside 100×100-px tiles would make them illegible. The full
/// descriptions live on the actual season detail cards, where the
/// user has space to read them. This keeps the onboarding page
/// glanceable and matches the established iOS / App Store pattern
/// for category previews.
class _CardGridTile extends StatelessWidget {
  const _CardGridTile({
    required this.spec,
    required this.cardIndex,
    required this.pulseListenable,
    required this.isUk,
  });
  final _CardSpec spec;

  /// 0..8 — the tile's position in the full 9-card sweep. Drives when
  /// (and how strongly) this tile pulses during the sequential
  /// highlight phase of the parent page animation.
  final int cardIndex;

  /// Master animation (the page's `_ctl`). The tile reads its current
  /// value each frame and converts that into a 0..1 highlight
  /// intensity using a sine envelope inside its own window.
  final Animation<double> pulseListenable;

  final bool isUk;

  // Pulse-phase boundaries on the parent's [0,1] timeline. Must stay
  // in sync with the phase comments in `_PageCardsState.initState`.
  //
  // Per-card pulse window is 0.10 wide (~850ms at 8500ms total) and
  // adjacent cards step by [_cardStride] = 0.055, which is LESS than
  // the window width — so each pulse overlaps the next by ~0.045.
  // That overlap is the key to "smooth wave" rather than "9 isolated
  // flashes": as one card is fading down, the next is already lifting,
  // so there's always at least one card mid-pulse on screen.
  //
  // Span: 8 strides + 1 window = 8 × 0.055 + 0.10 = 0.54.
  // Last card starts at _phaseStart + 8 × 0.055 = _phaseStart + 0.44,
  // ends at _phaseStart + 0.54. Place phaseStart = 0.42 so last card
  // ends at 0.96, overlapping caption (0.94–1.0) just slightly.
  static const double _phaseStart = 0.42;
  static const double _cardStride = 0.055;
  static const double _cardWindow = 0.10;

  /// Highlight intensity for this tile at global animation [t].
  /// Returns 0 outside the tile's own window; inside the window walks
  /// 0 → 1 → 0 along a sin curve so the pulse "lifts and settles" in
  /// place rather than jump-cuts.
  double _intensityAt(double t) {
    final cardStart = _phaseStart + cardIndex * _cardStride;
    final cardEnd = cardStart + _cardWindow;
    if (t < cardStart || t >= cardEnd) return 0;
    final localT = (t - cardStart) / _cardWindow; // 0..1
    return math.sin(localT * math.pi); // 0 → 1 → 0
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseFillAlpha = isDark ? 0.20 : 0.16;
    final baseSurfaceAlpha = isDark ? 0.92 : 0.95;

    return AnimatedBuilder(
      animation: pulseListenable,
      builder: (context, _) {
        final t = pulseListenable.value;
        final pulse = _intensityAt(t); // 0..1 sine envelope

        // Pulse decoration deltas — small enough that the tile still
        // feels like the same widget, big enough to clearly read as
        // "this one is being pointed at right now". Tuned for the
        // app's quiet aesthetic — no neon glow, just a brief lift.
        final fillBoost = pulse * 0.18;
        final borderAlphaBoost = pulse * 0.40;
        final borderWidth = 1.0 + pulse * 0.6;
        final shadowAlphaBoost = pulse * 0.32;
        final shadowBlur = 10.0 + pulse * 16.0;
        final scale = 1.0 + pulse * 0.05;

        return Transform.scale(
          scale: scale,
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color.alphaBlend(
                  spec.accent
                      .withValues(alpha: baseFillAlpha + fillBoost),
                  scheme.surface.withValues(alpha: baseSurfaceAlpha),
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: spec.accent
                      .withValues(alpha: 0.50 + borderAlphaBoost),
                  width: borderWidth,
                ),
                boxShadow: [
                  BoxShadow(
                    color: spec.accent
                        .withValues(alpha: 0.12 + shadowAlphaBoost),
                    blurRadius: shadowBlur,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    spec.kanji,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: spec.accent,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isUk ? spec.uk : spec.en,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: scheme.onSurface,
                      height: 1.2,
                      letterSpacing: 0.3,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CardSpec {
  const _CardSpec(
    this.kanji,
    this.uk,
    this.en,
    this.descUk,
    this.descEn,
    this.accent,
  );
  final String kanji;
  final String uk;
  final String en;
  final String descUk;
  final String descEn;
  final Color accent;
}

// ─── Page 4 — Final CTA ─────────────────────────────────────────────
//
// Sequential reveal: kanji → romaji → divider → caption → footnote.
// Each beat lets the previous one settle for ~300ms before the next
// joins. The cumulative effect is a slow inhale before the "Begin"
// button at the bottom of the screen, not a stack of text dumped at
// once.
class _PageBegin extends StatefulWidget {
  const _PageBegin({
    required this.isUk,
    required this.isVisible,
    required this.onOpenTradition,
  });
  final bool isUk;
  final bool isVisible;

  /// Tap handler for the "Витоки — у вкладці «Традиція»" footnote.
  /// Completes onboarding and deep-links to the Tradition tab.
  final VoidCallback onOpenTradition;

  @override
  State<_PageBegin> createState() => _PageBeginState();
}

class _PageBeginState extends State<_PageBegin>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctl;
  late final Animation<double> _kanjiAnim;
  late final Animation<double> _romajiAnim;
  late final Animation<double> _dividerAnim;
  late final Animation<double> _captionAnim;
  late final Animation<double> _footnoteAnim;

  @override
  void initState() {
    super.initState();
    _ctl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    _kanjiAnim = CurvedAnimation(
        parent: _ctl,
        curve: const Interval(0.0, 0.25, curve: Curves.easeOut));
    _romajiAnim = CurvedAnimation(
        parent: _ctl,
        curve: const Interval(0.20, 0.40, curve: Curves.easeOut));
    _dividerAnim = CurvedAnimation(
        parent: _ctl,
        curve: const Interval(0.40, 0.55, curve: Curves.easeOut));
    _captionAnim = CurvedAnimation(
        parent: _ctl,
        curve: const Interval(0.55, 0.80, curve: Curves.easeOut));
    _footnoteAnim = CurvedAnimation(
        parent: _ctl,
        curve: const Interval(0.80, 1.0, curve: Curves.easeOut));
    if (widget.isVisible) _ctl.forward();
  }

  @override
  void didUpdateWidget(covariant _PageBegin old) {
    super.didUpdateWidget(old);
    if (widget.isVisible && !old.isVisible) {
      _ctl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isUk = widget.isUk;
    final scheme = Theme.of(context).colorScheme;
    final onSurface = scheme.onSurface;
    final accent = scheme.primary;
    final softShadow = [
      Shadow(
        blurRadius: 8,
        color: Colors.black.withValues(alpha: 0.22),
        offset: const Offset(0, 1),
      ),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 56, 28, 160),
      // spaceBetween splits the page into two anchored regions: the
      // brand block lives in the upper-middle area, and the footnote
      // sits at the bottom of the content area (just above the
      // sticky Begin button). This pulls the "where to learn more"
      // line away from the headline copy so it reads as a quiet
      // closing remark rather than a continuation of the main text.
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Top spacer — keeps the brand block from sticking to the
          // very top, even when the column is using spaceBetween.
          const SizedBox(height: 16),
          // Brand block — logo + tagline + divider + caption.
          // Centered as a single composition.
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // App logo replaces the 七十二候 kanji block — gives
              // the closing screen the same brand mark the user sees
              // on the splash and on Home, so the four pages "land"
              // on a recognisable image rather than yet another
              // character set.
              FadeTransition(
                opacity: _kanjiAnim,
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: accent.withValues(alpha: 0.22),
                        blurRadius: 24,
                        spreadRadius: 1,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(26),
                    child: Image.asset(
                      'assets/brand/appIcon.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              FadeTransition(
                opacity: _romajiAnim,
                child: Text(
                  isUk ? '72 СЕЗОНИ' : '72 SEASONS',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2.4,
                    color: onSurface.withValues(alpha: 0.82),
                    shadows: softShadow,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              FadeTransition(
                opacity: _dividerAnim,
                child: Container(
                  width: 60,
                  height: 1,
                  color: accent.withValues(alpha: 0.55),
                ),
              ),
              const SizedBox(height: 28),
              FadeTransition(
                opacity: _captionAnim,
                child: Column(
                  children: [
                    Text(
                      isUk
                          ? 'Сезон (кō) триває п’ять днів. За цей час природа промовить одну дрібну зміну — немов подих. Ми просто допоможемо помітити.'
                          : 'A season (kō) lasts five days. In that time nature will speak one tiny change — quiet as a breath. We just help you notice.',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.55,
                        fontWeight: FontWeight.w500,
                        color: onSurface.withValues(alpha: 0.96),
                        shadows: softShadow,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      isUk
                          ? 'А коли зміниться сезон — ми підкажемо.'
                          : 'And when the season turns — we\u2019ll let you know.',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.55,
                        fontWeight: FontWeight.w500,
                        color: onSurface.withValues(alpha: 0.96),
                        shadows: softShadow,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Footnote — tappable shortcut. Tapping it both finishes
          // onboarding and deep-links the user to the Tradition tab,
          // saving the manual navigation step they'd otherwise need
          // to take after closing the Begin button.
          FadeTransition(
            opacity: _footnoteAnim,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: widget.onOpenTradition,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Wrapped in Flexible so the long Ukrainian
                      // string ("Більше про особливості східної
                      // культури — у вкладці «Традиція»") wraps onto
                      // a second line on narrower iPhones instead of
                      // overflowing past the right edge of the screen.
                      // Without Flexible the Row's MainAxisSize.min
                      // tried to take the text's intrinsic width,
                      // which exceeded the parent's 337-px content
                      // box and got clipped.
                      Flexible(
                        // Split into a plain prose lead + an
                        // underlined link chunk. Only the chunk
                        // ("вкладці «Традиція»" / "the Tradition tab")
                        // gets the underline, so the visual link
                        // affordance points at the actual destination
                        // word rather than every word in the line.
                        // The whole row is still tappable thanks to
                        // the parent InkWell — splitting only changes
                        // how the link READS, not how it works.
                        child: Text.rich(
                          TextSpan(
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: onSurface.withValues(alpha: 0.85),
                              height: 1.4,
                              letterSpacing: 0.3,
                              shadows: softShadow,
                            ),
                            children: [
                              TextSpan(
                                text: isUk
                                    ? 'Більше про особливості східної культури — у '
                                    : 'More about Eastern culture — in ',
                              ),
                              TextSpan(
                                text: isUk
                                    ? 'вкладці «Традиція»'
                                    : 'the Tradition tab',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationColor: onSurface
                                      .withValues(alpha: 0.40),
                                  decorationThickness: 0.8,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 14,
                        color: onSurface.withValues(alpha: 0.70),
                        shadows: softShadow,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Page indicator ─────────────────────────────────────────────────
class _PageDots extends StatelessWidget {
  const _PageDots({
    required this.count,
    required this.active,
    required this.onSurface,
    required this.accent,
  });

  final int count;
  final int active;
  final Color onSurface;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == active;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 22 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? accent : onSurface.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
