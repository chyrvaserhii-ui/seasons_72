import 'package:flutter/material.dart';

/// Standard wrapper for modal-bottom-sheet content in the app.
///
/// Replaces the previous `SafeArea + ConstrainedBox + SingleChildScrollView`
/// pattern with a single widget that:
///
///   • Uses [DraggableScrollableSheet] internally so the user can
///     swipe down ANYWHERE on the modal — not just on the small
///     drag-handle pill at the top — to dismiss it. When the inner
///     scroll is at the top and the user keeps pulling down, the
///     whole sheet shrinks; once it crosses [minSize] the route
///     auto-pops. Mid-scroll (away from the top) a downward gesture
///     still scrolls content normally — exactly the iOS-native
///     "scroll then drag-dismiss" UX users expect.
///
///   • Owns the inner scroll view so callers can pass a plain
///     [Column] as [child] and forget about scroll plumbing.
///
/// Use with:
/// ```
/// showModalBottomSheet(
///   context: context,
///   isScrollControlled: true,
///   useSafeArea: true,
///   showDragHandle: true,
///   builder: (_) => DismissibleModalSheet(child: ...),
/// )
/// ```
class DismissibleModalSheet extends StatelessWidget {
  const DismissibleModalSheet({
    super.key,
    required this.child,
    this.padding,
    this.initialSize = 0.75,
    this.minSize = 0.35,
    this.maxSize = 0.95,
  });

  /// Modal content. Typically a [Column] with all the body widgets.
  /// Don't wrap it in a scroll view yourself — this widget owns the
  /// scrolling so it can coordinate with the drag-to-dismiss gesture.
  final Widget child;

  /// Padding applied INSIDE the scroll view, around [child]. Use this
  /// for the typical 24-px horizontal / 32-px bottom that all sheets
  /// share. Leave null when the child applies its own padding.
  final EdgeInsetsGeometry? padding;

  /// Sheet height as a fraction of screen height when first shown.
  /// 0.75 matches the visual of the previous fixed-85% maxHeight
  /// pattern closely enough that opening a sheet doesn't feel
  /// jarringly different.
  final double initialSize;

  /// Below this fraction of screen height the sheet auto-dismisses.
  /// Don't set lower than ~0.20 — the user won't get smooth feedback
  /// that the swipe is doing something before it pops away.
  final double minSize;

  /// Maximum height the user can drag the sheet up to. 0.95 leaves a
  /// thin sliver of the underlying screen visible at the top so the
  /// sheet still reads as a modal, not as a full-screen route.
  final double maxSize;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: initialSize,
      minChildSize: minSize,
      maxChildSize: maxSize,
      // expand=false lets the sheet size to its initial fraction
      // instead of stretching to fill the full available height.
      // Without this, the sheet would always start at maxSize.
      expand: false,
      builder: (ctx, scrollCtl) {
        return SingleChildScrollView(
          controller: scrollCtl,
          padding: padding,
          child: child,
        );
      },
    );
  }
}
