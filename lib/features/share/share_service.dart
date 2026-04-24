import 'dart:async' show Completer;
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/models/season_models.dart';
import '../../core/utils/localized_names.dart';
import 'share_card.dart';

/// Captures a `ShareCard` widget tree as a 1080×1350 PNG and hands it to
/// the system share sheet (Photos / IG / Telegram / etc).
///
/// The card is mounted in an Overlay positioned far off-screen so the
/// user never sees the construction; we wait one layout pass, capture
/// it via `RenderRepaintBoundary.toImage`, then remove the overlay.
class ShareService {
  ShareService._();
  static final ShareService instance = ShareService._();

  /// Render at 3× the logical pixel ratio so the resulting PNG is
  /// 1080×1350 — Instagram story format, also fits Twitter portrait.
  static const double _captureRatio = 3.0;

  Future<void> shareSeason({
    required BuildContext context,
    required MicroSeason ko,
    required MetaSeason meta,
    required Sekki sekki,
  }) async {
    final locale = Localizations.localeOf(context);
    // Anchor for the iOS popover. On iPad it's strictly required, on
    // newer iOS versions iPhone also enforces a non-zero rect. We use
    // the calling widget's render box if possible (so popovers point at
    // the share button), with a safe screen-bounds fallback.
    final origin = _resolveOrigin(context);
    try {
      final bytes = await _captureCard(
        context: context,
        ko: ko,
        meta: meta,
        sekki: sekki,
        locale: locale,
      );
      final file = await _writeTempPng(bytes, ko.index);

      final caption = _buildCaption(ko, locale);

      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'image/png')],
        text: caption,
        sharePositionOrigin: origin,
      );
    } catch (e, st) {
      debugPrint('ShareService failed: $e\n$st');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Share failed: $e')),
        );
      }
    }
  }

  /// Human-readable caption shown next to the image when sharing to
  /// apps that accept text (Telegram, Twitter, Mail). Instagram still
  /// ignores it but Stories pre-fills the URL field.
  ///
  /// Format:
  ///   {Localized name}
  ///   {kanji} · {romaji}
  ///   Сезон №{index} з 72 — фрагмент японського календаря.
  ///
  ///   #72сезони #shichijuniko #ukiyoe
  String _buildCaption(MicroSeason ko, Locale locale) {
    final isUk = locale.languageCode == 'uk';
    final name = ko.localizedName(locale);
    final lead = isUk
        ? 'Сезон №${ko.index} з 72 — фрагмент японського календаря.'
        : 'Season #${ko.index} of 72 — a moment from the Japanese calendar.';

    final hashtags = isUk
        ? '#72сезони #shichijuniko #ukiyoe #японія'
        : '#72seasons #shichijuniko #ukiyoe #japan';

    return [
      name,
      '${ko.kanji} · ${ko.romaji}',
      lead,
      '',
      hashtags,
    ].join('\n');
  }

  /// Resolves a non-zero `Rect` for iOS popover anchoring. Tries the
  /// calling context's render box first; falls back to a small region in
  /// the top-right of the screen (where the share IconButton sits).
  Rect _resolveOrigin(BuildContext context) {
    final box = context.findRenderObject();
    if (box is RenderBox && box.hasSize) {
      final pos = box.localToGlobal(Offset.zero);
      final size = box.size;
      if (size.width > 0 && size.height > 0) {
        return pos & size;
      }
    }
    final screen = MediaQuery.of(context).size;
    return Rect.fromLTWH(screen.width - 56, 56, 40, 40);
  }

  Future<Uint8List> _captureCard({
    required BuildContext context,
    required MicroSeason ko,
    required MetaSeason meta,
    required Sekki sekki,
    required Locale locale,
  }) async {
    final boundaryKey = GlobalKey();
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    final completer = Completer<Uint8List>();

    entry = OverlayEntry(
      builder: (_) => Positioned(
        // Park the card far off-screen — invisible to the user but
        // still laid out and painted (Offstage(true) skips paint, so
        // we use translation instead).
        left: -10000,
        top: 0,
        child: Material(
          color: Colors.transparent,
          child: RepaintBoundary(
            key: boundaryKey,
            child: ShareCard(
              ko: ko,
              meta: meta,
              sekki: sekki,
              locale: locale,
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);

    // Wait two frames so layout + asset image decoding completes
    // before we capture. One frame is usually enough for layout, but
    // Image.asset can need a second tick for decode on first show.
    await WidgetsBinding.instance.endOfFrame;
    await WidgetsBinding.instance.endOfFrame;

    try {
      final boundary = boundaryKey.currentContext!.findRenderObject()
          as RenderRepaintBoundary;
      final ui.Image image =
          await boundary.toImage(pixelRatio: _captureRatio);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        throw StateError('toByteData returned null');
      }
      completer.complete(byteData.buffer.asUint8List());
    } catch (e, st) {
      completer.completeError(e, st);
    } finally {
      entry.remove();
    }

    return completer.future;
  }

  Future<File> _writeTempPng(Uint8List bytes, int seasonIndex) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/seasons72_share_$seasonIndex.png');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }
}

