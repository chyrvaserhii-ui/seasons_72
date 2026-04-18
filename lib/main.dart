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

  runApp(const ProviderScope(child: SeasonsApp()));
}
