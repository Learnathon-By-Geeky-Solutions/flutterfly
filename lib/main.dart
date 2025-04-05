import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/config/app_config.dart';
import 'core/utils/loggers/logger.dart';

/*
    To switch flavors, run this in the terminal:
        flutter run --dart-define=FLAVOR=staging
        flutter run --dart-define=FLAVOR=prod
*/

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const String flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
  await AppConfig.loadConfig(flavor);

  Log.i('AppConfig loaded: ${AppConfig.appEnv}');

  await Supabase.initialize(
    url: AppConfig.dbUrl,
    anonKey: AppConfig.anonKey,
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
    realtimeClientOptions: const RealtimeClientOptions(
      logLevel: RealtimeLogLevel.info,
    ),
    storageOptions: const StorageClientOptions(
      retryAttempts: 10,
    ),
  );
  usePathUrlStrategy();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const ProviderScope(child: App()));
}