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
            : theme.colorScheme.onSurface.withValues(alpha: 0.70);

        return Semantics(
          button: true,
          label: active ? 'Stop ambient sound' : 'Play ambient sound',
          child: Tooltip(
            message: active ? 'Зупинити звук' : 'Послухати звук сезону',
            child: InkWell(
              borderRadius: BorderRadius.circular(22),
              onTap: () => svc.toggle(koIndex: koIndex, metaId: metaId),
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
