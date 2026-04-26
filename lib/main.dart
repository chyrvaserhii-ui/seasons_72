import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/data/seasons_repository.dart';
import 'core/notifications/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Preload the seasons dataset so providers can depend on it synchronously.
  await SeasonsRepository.instance.load();
  // Prepare the notifications plugin + timezone data (no permission ask
  // yet — that happens when the user flips the toggle in Settings).
  await NotificationService.instance.init();

  // Configure the audio session globally to "ambient" so:
  //   • All in-app audio (onboarding shakuhachi, kō ambient clips)
  //     respects the iOS silent switch — when the device is muted,
  //     nothing plays.
  //   • Audio mixes politely with other apps (Spotify, Podcasts) —
  //     starting onboarding music doesn't kill the user's playlist.
  // Configuration before runApp ensures the first AudioPlayer that
  // mounts already inherits this category.
  // Audio session: `playback` category so the per-kō ambient clips
  // and onboarding shakuhachi play regardless of the iOS silent
  // switch. Rationale: silent switch is iOS's "no surprise sounds"
  // setting (notifications, system beeps) — when the user taps a
  // play button in our app they are explicitly asking to hear, and
  // every meditation / music app worth its salt (Spotify, Apple
  // Music, Calm, Headspace, Podcasts) overrides silent for
  // user-initiated playback. Previously we used `ambient`, which
  // respects the switch and silently swallowed every play tap when
  // the device was muted — confusing UX, not respectful.
  //
  // `mixWithOthers` is preserved so we still cohabit politely with
  // other audio (Spotify, podcasts) — starting our music doesn't
  // kill the user's playlist.
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
    androidAudioFocusGainType: AndroidAudioFocusGainType.gainTransientMayDuck,
  ));

  runApp(const ProviderScope(child: SeasonsApp()));
}
