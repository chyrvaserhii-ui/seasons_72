import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

/// Loops a single traditional Japanese wind-instrument piece behind
/// the onboarding flow. The audio session category configured in
/// `main.dart` is `playback` with `mixWithOthers`, so:
///   • Plays regardless of the iOS silent switch — onboarding music
///     is essential content (the meditative ritual the user came
///     for), not an incidental sound. Standard pattern for music /
///     meditation apps.
///   • If the user is already listening to other audio (Spotify,
///     Podcasts), this mixes politely instead of stealing focus.
///
/// The asset path expects a single bundled file at
/// `assets/audio/onboarding.m4a`. If the file is missing the service
/// silently no-ops — onboarding still works, just without sound.
class OnboardingAudioService {
  OnboardingAudioService._() {
    _player.playerStateStream.listen((s) {
      _isPlaying.value =
          s.playing && s.processingState != ProcessingState.idle;
    });
  }

  static final OnboardingAudioService instance = OnboardingAudioService._();

  final AudioPlayer _player = AudioPlayer();
  bool _loaded = false;

  /// True iff the player has the asset loaded *and* is currently
  /// emitting audio (not paused). Drives the speaker icon in the UI.
  final ValueNotifier<bool> _isPlaying = ValueNotifier(false);
  ValueListenable<bool> get isPlaying => _isPlaying;

  /// Begin playback if not already running. Configures the loop and
  /// volume on the first call. Safe to call multiple times — no-ops
  /// if already playing.
  Future<void> start() async {
    try {
      if (!_loaded) {
        await _player.setAsset('assets/audio/onboarding.m4a');
        await _player.setLoopMode(LoopMode.one);
        // Quiet enough to read text over, loud enough to register.
        await _player.setVolume(0.55);
        _loaded = true;
      }
      if (!_player.playing) {
        await _player.play();
      }
    } catch (e, st) {
      debugPrint('Onboarding audio start failed: $e\n$st');
    }
  }

  /// Pause playback without unloading. Resumable via [start].
  Future<void> pause() async {
    try {
      if (_player.playing) await _player.pause();
    } catch (e) {
      debugPrint('Onboarding audio pause failed: $e');
    }
  }

  /// One-tap toggle from the speaker icon. Starts on first call,
  /// then pauses/resumes on subsequent taps.
  Future<void> toggle() async {
    if (_isPlaying.value) {
      await pause();
    } else {
      await start();
    }
  }

  /// Tear down — called when onboarding finishes or is dismissed.
  /// Stops playback and unloads so cold-launching the app doesn't
  /// hold the audio session open.
  Future<void> stop() async {
    try {
      await _player.stop();
      _loaded = false;
    } catch (e) {
      debugPrint('Onboarding audio stop failed: $e');
    }
  }

  /// Smoothly ramp the volume from its current level down to silence,
  /// then [stop]. Used when the user finishes onboarding so the
  /// shakuhachi doesn't cut off the moment AppShell swaps in.
  ///
  /// Default duration is 5 seconds — a long, contemplative exhale
  /// that bridges the onboarding's quiet music into the app's own
  /// sounds. Long enough to feel like a real out-breath, not a cut.
  Future<void> fadeOut({
    Duration duration = const Duration(milliseconds: 5000),
  }) async {
    try {
      if (!_player.playing) {
        await stop();
        return;
      }
      final startVolume = _player.volume;
      // 50 ms tick = 20 fps fade — smooth enough for the human ear.
      const tick = Duration(milliseconds: 50);
      final steps = (duration.inMilliseconds / tick.inMilliseconds).round();
      for (int i = 1; i <= steps; i++) {
        await Future.delayed(tick);
        if (!_player.playing) break; // user paused mid-fade
        final progress = i / steps;
        final eased = _easeOutCubic(progress);
        final newVolume = (startVolume * (1.0 - eased)).clamp(0.0, 1.0);
        await _player.setVolume(newVolume);
      }
      await stop();
      // Reset volume so a future re-show starts at the original
      // level (without this, replaying onboarding would be silent).
      await _player.setVolume(startVolume);
    } catch (e) {
      debugPrint('Onboarding audio fadeOut failed: $e');
    }
  }

  /// EaseOutCubic — fast at the start, slow at the end. Makes the
  /// fade feel more natural than a linear ramp; the tail lingers
  /// instead of vanishing.
  double _easeOutCubic(double t) {
    final f = t - 1;
    return f * f * f + 1;
  }
}
