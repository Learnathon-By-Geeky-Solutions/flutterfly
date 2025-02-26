import 'package:flutter_dotenv/flutter_dotenv.dart';

/*
    AppConfig is a utility class for loading and accessing environment-specific configuration values.
*/

class AppConfig {
  static Future<void> loadConfig(String envFile) async {
    await dotenv.load(fileName: envFile);
  }

  static String get appEnv => dotenv.env['APP_ENV'] ?? '';
  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? '';
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
  static String get appName => dotenv.env['APP_NAME'] ?? '';
}