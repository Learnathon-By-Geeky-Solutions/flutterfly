import 'package:flutter_dotenv/flutter_dotenv.dart';


/*
    AppConfig is a utility class for loading and accessing environment-specific configuration values.
*/

class AppConfig {
  static Future<void> loadConfig(String flavor) async {
    await dotenv.load(fileName: 'env/.env.$flavor');
    //Log.i('Loaded ENV Variables: ${dotenv.env}');
  }

  static String get appEnv => dotenv.env['APP_ENV'] ?? '';
  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? '';
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
  static String get appName => dotenv.env['APP_NAME'] ?? '';
  static String get dbUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get anonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';
}