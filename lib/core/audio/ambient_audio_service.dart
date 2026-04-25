import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

import 'ambient_map.dart';

/// Plays a one-shot ambient clip matching either:
///   * a specific kō (e.g. #19 frogs, #38 cicadas) when an override
///     is registered in `ambientOverrides`,
///   * or the kō's meta-season default (`spring` / `summer` / `autumn`
///     / `winter`) when no override exists.
///
/// One singleton player so the same icon can both start and stop the
/// clip. Audio is bundled in `assets/audio/<key>.m4a`. If a file is
/// missing, the service silently swallows the error and the UI shows
/// the off-state — the rest of the app works normally.
class AmbientAudioService {
  AmbientAudioService._() {
    _player.playerStateStream.listen((state) {
      // just_audio quirk: after a one-shot finishes, `state.playing`
      // remains true while `processingState` becomes `completed`.
      // We treat completed as "not playing anymore" so the UI icon
      // flips back to the default state.
      _isPlaying.value = state.playing &&
          state.processingState != ProcessingState.completed;
    });
  }

  static final AmbientAudioService instance = AmbientAudioService._();

  final AudioPlayer _player = AudioPlayer();

  /// The asset key currently loaded ("frogs" / "spring" / etc), or
  /// null if nothing is loaded yet.
  String? _loadedKey;

  final ValueNotifier<bool> _isPlaying = ValueNotifier(false);
  ValueListenable<bool> get isPlaying => _isPlaying;

  /// Resolves the asset key for [koIndex] + [metaId]:
  ///   * specific override if `ambientOverrides[koIndex]` is set
  ///   * otherwise the meta-season default
  String _resolveKey({required int koIndex, required String metaId}) {
    return ambientForKo(koIndex) ?? metaId;
  }

  /// True iff the ambient currently playing matches what would be
  /// resolved for `(koIndex, metaId)`. Lets the UI light up when its
  /// own pair is the one playing.
  bool isPlayingFor({required int koIndex, required String metaId}) {
    if (!_isPlaying.value) return false;
    return _loadedKey == _resolveKey(koIndex: koIndex, metaId: metaId);
  }

  /// Toggle playback for the (koIndex, metaId) pair. If the same
  /// asset is currently loaded, pause/resume; if a different key is
  /// loaded, switch to the new one and play.
  Future<void> toggle({required int koIndex, required String metaId}) async {
    final key = _resolveKey(koIndex: koIndex, metaId: metaId);
    try {
      if (_loadedKey == key) {
        if (_player.playing) {
          await _player.pause();
        } else {
          // If the clip already played through (one-shot finished),
          // rewind so the next tap plays it from the start.
          final dur = _player.duration;
          if (dur != null &&
              _player.position >= dur - const Duration(milliseconds: 100)) {
            await _player.seek(Duration.zero);
          }
          await _player.play();
        }
        return;
      }

      // Switch to a different asset — interrupt anything currently
      // playing first so the changeover is instant. One-shot, no loop.
      if (_player.playing) {
        await _player.stop();
      }
      await _player.setAsset(_assetFor(key));
      await _player.setLoopMode(LoopMode.off);
      _loadedKey = key;
      await _player.play();
    } catch (e, st) {
      debugPrint('AmbientAudio toggle failed for $key: $e\n$st');
    }
  }

  /// Stop and unload regardless of state.
  Future<void> stop() async {
    await _player.stop();
    _loadedKey = null;
  }

  String _assetFor(String key) => 'assets/audio/$key.m4a';
}
