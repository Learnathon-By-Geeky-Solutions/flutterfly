import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/config/environment.dart';
import 'core/config/app_config.dart';
import 'core/config/flavor.dart';
import 'app.dart';

/*
    To switch flavors, run this in the terminal:
        flutter run --dart-define=FLAVOR=staging
        flutter run --dart-define=FLAVOR=prod
*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const ProviderScope(child: App()));
}