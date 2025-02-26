import 'package:logger/logger.dart';

/*
  * Debug (d): For debugging information.

  * Info (i): For informational messages.

  * Warn (w): For warning messages.

  * Error (e): For error messages.

  /// Example:
  /// ```dart
  /// Log.d("This is a debug message");
  /// ```

*/

class Log 
{
  static final Logger _logger = Logger(
    printer: PrettyPrinter(),
  );

  static void d(String message) 
  {
    _logger.d(message);
  }

  static void i(String message) 
  {
    _logger.i(message);
  }

  static void w(String message) 
  {
    _logger.w(message);
  }

  static void e(String message) 
  {
    _logger.e(message);
  }
}