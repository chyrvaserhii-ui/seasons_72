import 'package:flutter/material.dart';

import '../about/seasonal_colors.dart';

/// Kasane-no-irome (襲の色目) — the layered Heian colour combination
/// paired to the current kō. Visually the most distinctive of the
/// detail cards: instead of an emoji or icon, the row shows actual
/// colour swatches drawn from the layers, so the reader sees the
/// palette before they read its name. The bottom sheet expands to a
/// kimono-lining cross-section with each layer named in Japanese,
/// romaji and the local language.
class ColorsCard extends StatelessWidget {
  const ColorsCard({
    super.key,
    required this.koIndex,
    required this.locale,
  });

  final int koIndex;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    final pairing = colorsForKo(koIndex);
    if (pairing == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final isUk = locale.languageCode == 'uk';
    final onSurface = theme.colorScheme.onSurface;

    // The card's accent comes from the deepest (last) layer — feels
    // appropriate since in Heian usage the lining was the boldest part
    // of the stack and tints the whole reading.
    final accent = pairing.layers.last.toColor();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isUk ? 'СЕЗОННІ КОЛЬОРИ ОДЯГУ' : 'SEASONAL ROBE COLOURS',
          style: theme.textTheme.labelLarge?.copyWith(
            color: onSurface.withValues(alpha: 0.65),
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        Material(
          // Use a near-neutral wash so it never fights the swatches.
          color: onSurface.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _showSheet(context, pairing, isUk),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _LayerSwatchStack(
                    layers: pairing.layers,
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${pairing.kasaneJa}  ${isUk ? pairing.kasaneUk : pairing.kasaneEn}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          pairing.kasaneRomaji,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: onSurface.withValues(alpha: 0.65),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.info_outline,
                    size: 18,
                    color: onSurface.withValues(alpha: 0.45),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showSheet(BuildContext context, ColorPairing pairing, bool isUk) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) =>
          _ColorsDetailsSheet(pairing: pairing, isUk: isUk),
    );
  }
}

/// Compact horizontal row of overlapping coloured circles — gives the
/// reader an immediate sense of the kasane palette without needing to
/// open the sheet. Designed for the row card.
class _LayerSwatchStack extends StatelessWidget {
  const _LayerSwatchStack({
    required this.layers,
    required this.size,
  });

  final List<ColorLayer> layers;
  final double size;

  @override
  Widget build(BuildContext context) {
    // Stack circles slightly overlapping so the row feels like a single
    // unit, not three separate dots.
    final overlap = size * 0.35;
    final width = size + overlap * (layers.length - 1);
    return SizedBox(
      width: width,
      height: size,
      child: Stack(
        children: List.generate(layers.length, (i) {
          return Positioned(
            left: overlap * i,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: layers[i].toColor(),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.7),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _ColorsDetailsSheet extends StatelessWidget {
  const _ColorsDetailsSheet({
    required this.pairing,
    required this.isUk,
  });

  final ColorPairing pairing;
  final bool isUk;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final accent = pairing.layers.last.toColor();
    final mq = MediaQuery.of(context);
    final maxHeight = mq.size.height * 0.88;

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  isUk ? 'СЕЗОННІ КОЛЬОРИ ОДЯГУ' : 'SEASONAL ROBE COLOURS',
                  style: theme.textTheme.labelLarge?.copyWith(
                    letterSpacing: 1.8,
                    color: onSurface.withValues(alpha: 0.55),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              // Kimono lining cross-section — vertical bands of each
              // layer, top-to-bottom matching outer-to-lining order.
              _KasaneStack(layers: pairing.layers),
              const SizedBox(height: 18),
              Center(
                child: Text(
                  pairing.kasaneJa,
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontSize: 38,
                    color: accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  pairing.kasaneRomaji,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: onSurface.withValues(alpha: 0.55),
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  isUk ? pairing.kasaneUk : pairing.kasaneEn,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 22),
              Center(
                child: Container(
                  width: 60,
                  height: 1,
                  color: accent.withValues(alpha: 0.4),
                ),
              ),
              const SizedBox(height: 22),
              Text(
                isUk ? pairing.noteUk : pairing.noteEn,
                style: theme.textTheme.bodyLarge?.copyWith(
                  height: 1.55,
                  color: onSurface.withValues(alpha: 0.85),
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 24),
              Text(
                isUk ? 'ШАРИ' : 'LAYERS',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: onSurface.withValues(alpha: 0.65),
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              for (int i = 0; i < pairing.layers.length; i++) ...[
                _LayerRow(
                  layer: pairing.layers[i],
                  isUk: isUk,
                  positionLabel: _positionLabel(
                    i,
                    pairing.layers.length,
                    isUk,
                  ),
                ),
                if (i < pairing.layers.length - 1)
                  const SizedBox(height: 10),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Heian kasane order ran outer → lining; we surface that for the
  /// reader so they understand what they're looking at.
  String _positionLabel(int index, int total, bool isUk) {
    if (total == 2) {
      if (index == 0) return isUk ? 'Зовнішній шар' : 'Outer';
      return isUk ? 'Підкладка' : 'Lining';
    }
    if (total == 3) {
      switch (index) {
        case 0:
          return isUk ? 'Зовнішній шар' : 'Outer';
        case 1:
          return isUk ? 'Середній шар' : 'Middle';
        default:
          return isUk ? 'Підкладка' : 'Lining';
      }
    }
    return '';
  }
}

/// Vertical kimono-lining preview — each layer shown as a horizontal
/// band, with the outer layer at the top and the lining at the bottom.
/// Heights are equal so no single layer dominates.
class _KasaneStack extends StatelessWidget {
  const _KasaneStack({required this.layers});

  final List<ColorLayer> layers;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        height: 110,
        child: Column(
          children: [
            for (final l in layers)
              Expanded(
                child: Container(color: l.toColor()),
              ),
          ],
        ),
      ),
    );
  }
}

/// One row in the LAYERS section — colour square + position + names.
class _LayerRow extends StatelessWidget {
  const _LayerRow({
    required this.layer,
    required this.isUk,
    required this.positionLabel,
  });

  final ColorLayer layer;
  final bool isUk;
  final String positionLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: layer.toColor(),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: onSurface.withValues(alpha: 0.12),
              width: 1,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    layer.nameJa,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    layer.nameRomaji,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: onSurface.withValues(alpha: 0.55),
                    ),
                  ),
                  if (positionLabel.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Text(
                      '· $positionLabel',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: onSurface.withValues(alpha: 0.55),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Text(
                isUk ? layer.nameUk : layer.nameEn,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: onSurface.withValues(alpha: 0.75),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
