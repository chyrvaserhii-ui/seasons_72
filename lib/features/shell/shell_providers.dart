import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Index of the currently-selected bottom-nav tab in [AppShell].
///
/// Lives in a Riverpod provider so other features can drive
/// navigation programmatically — for example, the "Витоки — у
/// вкладці «Традиція»" link on the last onboarding page jumps
/// directly to the Tradition tab after marking onboarding done.
final selectedTabProvider = StateProvider<int>((_) => 0);
