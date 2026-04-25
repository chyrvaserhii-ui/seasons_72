import 'package:flutter/material.dart';

import '../../../core/audio/ambient_audio_service.dart';

/// Compact play/pause control for the per-meta ambient loop.
///
/// Reads the active state from [AmbientAudioService.isPlaying] so the
/// icon flips automatically when the same loop is toggled from
/// elsewhere (or stops on its own).
///
/// Visual: small circular button tinted with the meta-season's accent.
/// Touch target is the standard 44pt — the visible glyph is 20pt so
/// the control sits quietly next to other Home-screen rows.
class AmbientPlayerButton extends StatelessWidget {
  const AmbientPlayerButton({
    super.key,
    required this.metaId,
    required this.accentColor,
  });

  /// `spring` / `summer` / `autumn` / `winter` — used to load the
  /// matching loop file via [AmbientAudioService].
  final String metaId;

  /// The current season's tint, used for the active state.
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final svc = AmbientAudioService.instance;
    return ValueListenableBuilder<bool>(
      valueListenable: svc.isPlaying,
      builder: (context, _, __) {
        final active = svc.isPlayingFor(metaId);
        final theme = Theme.of(context);
        final glyphColor = active
            ? accentColor.withValues(alpha: 0.95)
            : theme.colorScheme.onSurface.withValues(alpha: 0.70);

        return Semantics(
          button: true,
          label: active ? 'Stop ambient sound' : 'Play ambient sound',
          child: Tooltip(
            message: active ? 'Зупинити звук' : 'Послухати звук сезону',
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: () => svc.toggle(metaId),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Icon(
                  active ? Icons.graphic_eq : Icons.volume_up_outlined,
                  size: 20,
                  color: glyphColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
