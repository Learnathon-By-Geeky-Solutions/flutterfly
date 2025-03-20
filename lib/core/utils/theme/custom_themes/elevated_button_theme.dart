import 'package:flutter/material.dart';
import '../../constants/color_palette.dart';

class AppElevatedButtonTheme {
  AppElevatedButtonTheme._();

  /// Light Theme
  static ElevatedButtonThemeData get lightElevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primaryAccent,
        disabledForegroundColor: Colors.grey,
        disabledBackgroundColor: Colors.grey.withOpacity(0.1),
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// Dark Theme
  static ElevatedButtonThemeData get darkElevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primaryAccent,
        disabledForegroundColor: Colors.grey,
        disabledBackgroundColor: Colors.grey.withOpacity(0.1),
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}