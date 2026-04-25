import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

/// Plays a soft ambient loop matching the current meta-season:
/// spring birds, summer cicadas, autumn rain, winter wind.
///
/// One singleton player so toggling the same key restarts cleanly,
/// switching keys swaps loops without a gap. Audio is bundled in
/// `assets/audio/` and looped via `LoopMode.one`.
///
/// MVP scope: four loops, one per `metaId`. When the current kō
/// changes meta we don't auto-switch — the user has to opt back in.
class AmbientAudioService {
  AmbientAudioService._() {
    // Keep our broadcast state in sync with the actual player.
    _player.playerStateStream.listen((state) {
      _isPlaying.value = state.playing;
    });
  }

  static final AmbientAudioService instance = AmbientAudioService._();

  final AudioPlayer _player = AudioPlayer();

  /// The metaId currently loaded (`spring`, `summer`, `autumn`,
  /// `winter`), or null if nothing is loaded yet.
  String? _loadedMeta;

  /// Listenable boolean — `true` while audio is actively playing.
  /// Widgets can `valueListenable: AmbientAudioService.instance.isPlaying`
  /// to rebuild their play/pause icon without subscribing manually.
  final ValueNotifier<bool> _isPlaying = ValueNotifier(false);
  ValueListenable<bool> get isPlaying => _isPlaying;

  /// True if `metaId` matches the currently-loaded loop and audio is
  /// playing. Lets the UI show "this meta is active" only when both
  /// conditions hold.
  bool isPlayingFor(String metaId) =>
      _isPlaying.value && _loadedMeta == metaId;

  /// Toggle playback for [metaId]. If a different meta is currently
  /// loaded, switches to the new loop. If the same meta is playing,
  /// pauses. If paused, resumes.
  Future<void> toggle(String metaId) async {
    try {
      if (_loadedMeta == metaId) {
        if (_player.playing) {
          await _player.pause();
        } else {
          await _player.play();
        }
        return;
      }

      // Different meta — load fresh asset and start.
      await _player.setAsset(_assetFor(metaId));
      await _player.setLoopMode(LoopMode.one);
      _loadedMeta = metaId;
      await _player.play();
    } catch (e, st) {
      // Most common: missing asset. Log + leave the player paused so
      // the UI just shows the off state.
      debugPrint('AmbientAudio toggle failed for $metaId: $e\n$st');
    }
  }

  /// Stop and unload regardless of state. Used when leaving the app
  /// or to reclaim resources.
  Future<void> stop() async {
    await _player.stop();
    _loadedMeta = null;
  }

  String _assetFor(String metaId) {
    // File names match the meta IDs in seasons.json.
    return 'assets/audio/$metaId.m4a';
  }
}
