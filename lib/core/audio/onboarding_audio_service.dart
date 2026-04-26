import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

/// Loops a single traditional Japanese wind-instrument piece behind
/// the onboarding flow.
///
/// Audio-session strategy is two-tier:
///   • **Auto-start** ([start]) — uses the global default `ambient`
///     category so iOS silent switch is honoured. If the user is in
///     silent mode, the music doesn't play and we expose the silent
///     state via [silenced] so the speaker icon can render its
///     crossed-out variant.
///   • **User-initiated** ([startOverridingSilent], called from
///     [toggle]) — re-configures the session to `playback` first so
///     the music plays regardless of the silent switch. An explicit
///     tap is unambiguous user consent.
///
/// `mixWithOthers` is preserved in both modes — Spotify / Podcasts
/// keep playing if they were already.
///
/// Asset: `assets/audio/onboarding.m4a`. If missing the service
/// silently no-ops — onboarding still works, just without music.
class OnboardingAudioService {
  OnboardingAudioService._() {
    _player.playerStateStream.listen((s) {
      _isPlaying.value =
          s.playing && s.processingState != ProcessingState.idle;
      // Once playback actually starts, we know we're not silenced.
      if (_isPlaying.value && _silenced.value) {
        _silenced.value = false;
      }
    });
  }

  static final OnboardingAudioService instance = OnboardingAudioService._();

  final AudioPlayer _player = AudioPlayer();
  bool _loaded = false;

  /// True iff the player is currently emitting audio.
  final ValueNotifier<bool> _isPlaying = ValueNotifier(false);
  ValueListenable<bool> get isPlaying => _isPlaying;

  /// True iff [start] was called but iOS appears to have silenced us
  /// (silent switch on, ambient category). Used by the speaker icon
  /// to render a crossed-out state. Cleared when playback succeeds
  /// or when the user explicitly toggles via [toggle].
  final ValueNotifier<bool> _silenced = ValueNotifier(false);
  ValueListenable<bool> get silenced => _silenced;

  /// True after the user has explicitly tapped pause — used to
  /// distinguish "muted by silent switch" (silenced=true) from "user
  /// stopped on purpose" (silenced=false, _isPlaying=false).
  bool _userPaused = false;

  /// Auto-start path. Honours the silent switch via the default
  /// `ambient` category. If silent mode prevented playback, sets
  /// [silenced] = true after a short verification window.
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
        _userPaused = false;
        _silenced.value = false;
        await _player.play();
        // After a beat, check if the player actually started. If
        // `playing` is still false and the user didn't pause us in
        // the meantime, infer that the silent switch is muting.
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!_player.playing && !_userPaused) {
            _silenced.value = true;
          }
        });
      }
    } catch (e, st) {
      debugPrint('Onboarding audio start failed: $e\n$st');
    }
  }

  /// User-initiated path. Re-configures the audio session to
  /// `playback` first so the music plays even when the iOS silent
  /// switch is on, then plays. Used by [toggle].
  Future<void> startOverridingSilent() async {
    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playback,
        avAudioSessionCategoryOptions:
            AVAudioSessionCategoryOptions.mixWithOthers,
        avAudioSessionMode: AVAudioSessionMode.defaultMode,
        androidAudioAttributes: AndroidAudioAttributes(
          contentType: AndroidAudioContentType.music,
          usage: AndroidAudioUsage.media,
        ),
        androidAudioFocusGainType:
            AndroidAudioFocusGainType.gainTransientMayDuck,
      ));
      // A short pause so the category change has time to apply
      // before the AVAudioPlayer attempts the new playback. Without
      // it the first play() call after a category swap can still hit
      // the previous category's silent-switch behaviour.
      await Future.delayed(const Duration(milliseconds: 50));

      _userPaused = false;
      _silenced.value = false;
      if (!_loaded) {
        await _player.setAsset('assets/audio/onboarding.m4a');
        await _player.setLoopMode(LoopMode.one);
        await _player.setVolume(0.55);
        _loaded = true;
      }
      if (!_player.playing) {
        await _player.play();
      }
    } catch (e, st) {
      debugPrint('Onboarding override-silent start failed: $e\n$st');
    }
  }

  /// Pause playback without unloading. Resumable via [start].
  Future<void> pause() async {
    try {
      if (_player.playing) await _player.pause();
      _userPaused = true;
    } catch (e) {
      debugPrint('Onboarding audio pause failed: $e');
    }
  }

  /// One-tap toggle from the speaker icon.
  ///
  /// • If currently playing → pause.
  /// • If not playing (silent or paused) → call
  ///   [startOverridingSilent] so the music plays regardless of the
  ///   iOS silent switch. An explicit tap is treated as consent.
  Future<void> toggle() async {
    if (_isPlaying.value) {
      await pause();
    } else {
      await startOverridingSilent();
    }
  }

  /// Tear down — called when onboarding finishes or is dismissed.
  Future<void> stop() async {
    try {
      await _player.stop();
      _loaded = false;
      _silenced.value = false;
      _userPaused = false;
    } catch (e) {
      debugPrint('Onboarding audio stop failed: $e');
    }
  }

  /// Smoothly ramp the volume from its current level down to silence,
  /// then [stop]. Used when the user finishes onboarding so the
  /// shakuhachi doesn't cut off the moment AppShell swaps in.
  Future<void> fadeOut({
    Duration duration = const Duration(milliseconds: 5000),
  }) async {
    try {
      if (!_player.playing) {
        await stop();
        return;
      }
      final startVolume = _player.volume;
      const tick = Duration(milliseconds: 50);
      final steps = (duration.inMilliseconds / tick.inMilliseconds).round();
      for (int i = 1; i <= steps; i++) {
        await Future.delayed(tick);
        if (!_player.playing) break;
        final progress = i / steps;
        final eased = _easeOutCubic(progress);
        final newVolume = (startVolume * (1.0 - eased)).clamp(0.0, 1.0);
        await _player.setVolume(newVolume);
      }
      await stop();
      await _player.setVolume(startVolume);
    } catch (e) {
      debugPrint('Onboarding audio fadeOut failed: $e');
    }
  }

  double _easeOutCubic(double t) {
    final f = t - 1;
    return f * f * f + 1;
  }
}
