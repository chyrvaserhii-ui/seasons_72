import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../core/audio/ambient_audio_service.dart';

/// Compact play/pause control for the per-kō (or per-meta) ambient.
///
/// Reads the active state from [AmbientAudioService.isPlaying] so the
/// icon flips automatically when the same loop is toggled from
/// elsewhere (or finishes on its own).
///
/// Pass both [koIndex] and [metaId]: the service prefers a per-kō
/// override (e.g. frogs for #19) and falls back to the meta-season
/// default when the kō has no override.
class AmbientPlayerButton extends StatelessWidget {
  const AmbientPlayerButton({
    super.key,
    required this.koIndex,
    required this.metaId,
    required this.accentColor,
  });

  /// Current kō index — used to look up a specific ambient clip.
  final int koIndex;

  /// Fallback meta-season key — `spring` / `summer` / `autumn` /
  /// `winter`. Used when the kō has no specific clip registered.
  final String metaId;

  /// The current season's tint, used when audio is active.
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final svc = AmbientAudioService.instance;
    return ValueListenableBuilder<bool>(
      valueListenable: svc.isPlaying,
      builder: (context, _, __) {
        final active = svc.isPlayingFor(koIndex: koIndex, metaId: metaId);
        final theme = Theme.of(context);
        final glyphColor = active
            ? accentColor.withValues(alpha: 0.95)
            : theme.colorScheme.onSurface.withValues(alpha: 0.85);

        // Use a plain [IconButton] so the visual weight, size, and
        // hit-area match the system Material icons sitting next to
        // it in the AppBar (e.g. the share button).
        //
        // Icon set unified with the onboarding sound toggle:
        //   • playing  → volume_up   (sound currently audible)
        //   • paused   → volume_off  (silent / not playing)
        // One mental model for "ambient sound state" across the whole
        // app — onboarding intro, app-bar pill, and floating FAB all
        // speak the same speaker-icon vocabulary.
        return IconButton(
          tooltip: active ? 'Зупинити звук' : 'Послухати звук сезону',
          onPressed: () => svc.toggle(koIndex: koIndex, metaId: metaId),
          icon: Icon(
            active ? Icons.volume_up_rounded : Icons.volume_off_rounded,
            color: glyphColor,
          ),
        );
      },
    );
  }
}

/// Floating circular ambient-sound button — designed to sit on top of
/// the kō hero engraving in the bottom-right corner. Frosted glass
/// background, accent ring, and a slow radial pulse when playing.
///
/// This is a more discoverable home for the ambient feature than
/// burying it in the date row: the hero is the visual heart of the
/// screen, and a play button on it reads as "tap to feel the season"
/// — a pattern the user already knows from music apps.
///
/// Stateful so we can animate the pulse independently of the
/// underlying [ValueListenableBuilder] rebuilds.
class AmbientPlayerFab extends StatefulWidget {
  const AmbientPlayerFab({
    super.key,
    required this.koIndex,
    required this.metaId,
    required this.accentColor,
    this.size = 48,
  });

  final int koIndex;
  final String metaId;
  final Color accentColor;
  final double size;

  @override
  State<AmbientPlayerFab> createState() => _AmbientPlayerFabState();
}

class _AmbientPlayerFabState extends State<AmbientPlayerFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  void _setPulse(bool playing) {
    if (playing && !_pulse.isAnimating) {
      _pulse.repeat();
    } else if (!playing && _pulse.isAnimating) {
      _pulse.stop();
      _pulse.value = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final svc = AmbientAudioService.instance;
    return ValueListenableBuilder<bool>(
      valueListenable: svc.isPlaying,
      builder: (context, _, __) {
        final active =
            svc.isPlayingFor(koIndex: widget.koIndex, metaId: widget.metaId);

        // Sync the pulse animation with playback state. Keeps the
        // animation off when nothing is playing — saves frames and
        // looks calm.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _setPulse(active);
        });

        return Semantics(
          button: true,
          label: active ? 'Stop ambient sound' : 'Play ambient sound',
          child: Tooltip(
            message: active ? 'Зупинити звук' : 'Послухати звук сезону',
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => svc.toggle(
                koIndex: widget.koIndex,
                metaId: widget.metaId,
              ),
              child: SizedBox(
                width: widget.size + 24,
                height: widget.size + 24,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Soft pulsing halo — only active while playing.
                    if (active)
                      AnimatedBuilder(
                        animation: _pulse,
                        builder: (_, __) {
                          final t = _pulse.value;
                          // Two phase-shifted ripples so the halo never
                          // fully fades — one is always growing while
                          // the other is at peak fade.
                          return SizedBox(
                            width: widget.size + 24,
                            height: widget.size + 24,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                _Ripple(
                                  progress: t,
                                  baseSize: widget.size,
                                  color: widget.accentColor,
                                ),
                                _Ripple(
                                  progress: (t + 0.5) % 1.0,
                                  baseSize: widget.size,
                                  color: widget.accentColor,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    // The button itself — frosted glass disc with the
                    // play / waveform icon centred.
                    ClipOval(
                      child: BackdropFilter(
                        filter: ui.ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                        child: Container(
                          width: widget.size,
                          height: widget.size,
                          decoration: BoxDecoration(
                            color: active
                                ? widget.accentColor.withValues(alpha: 0.42)
                                : Colors.black.withValues(alpha: 0.30),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: widget.accentColor
                                  .withValues(alpha: active ? 0.85 : 0.60),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: widget.accentColor
                                    .withValues(alpha: 0.30),
                                blurRadius: 12,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Icon(
                            active
                                ? Icons.volume_up_rounded
                                : Icons.volume_off_rounded,
                            color: Colors.white,
                            size: widget.size * 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Single radial ripple expanding outward from the button. Used by
/// [AmbientPlayerFab] to suggest sound is playing without resorting
/// to a fake equalizer or moving icons.
class _Ripple extends StatelessWidget {
  const _Ripple({
    required this.progress,
    required this.baseSize,
    required this.color,
  });

  /// 0..1 — drives both the radius growth and the opacity fade.
  final double progress;
  final double baseSize;
  final Color color;

  @override
  Widget build(BuildContext context) {
    // Expand from the button's edge to ~12px outside; fade as we go.
    final size = baseSize + 24 * progress;
    final opacity = (1.0 - progress).clamp(0.0, 1.0) * 0.55;
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: color.withValues(alpha: opacity),
            width: 1.4,
          ),
        ),
      ),
    );
  }
}
