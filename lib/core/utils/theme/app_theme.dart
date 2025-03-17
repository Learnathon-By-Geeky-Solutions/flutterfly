import 'package:flutter/material.dart';
import 'color_palette.dart';
import 'custom_themes/appbar_theme.dart';
import 'custom_themes/elevated_button_theme.dart';
import 'custom_themes/checkbox_theme.dart';
import 'custom_themes/textfield_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: AppColors.primaryDark,
      scaffoldBackgroundColor: AppColors.scaffoldLight,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryDark,
        secondary: AppColors.primaryAccent,
      ),
      appBarTheme: AppAppBarTheme.lightAppBarTheme,
      elevatedButtonTheme: AppElevatedButtonTheme.lightElevatedButtonTheme,
      checkboxTheme: AppCheckboxTheme.lightCheckboxTheme,
      inputDecorationTheme: AppTextFieldTheme.lightInputDecorationTheme,
      iconTheme: const IconThemeData(color: Colors.white),
      dividerColor: Colors.white54,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: AppColors.primaryDark,
      scaffoldBackgroundColor: AppColors.scaffoldDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryDark,
        secondary: AppColors.primaryAccent,
      ),
      appBarTheme: AppAppBarTheme.darkAppBarTheme,
      elevatedButtonTheme: AppElevatedButtonTheme.darkElevatedButtonTheme,
      checkboxTheme: AppCheckboxTheme.darkCheckboxTheme,
      inputDecorationTheme: AppTextFieldTheme.darkInputDecorationTheme,
      iconTheme: const IconThemeData(color: Colors.black),
      dividerColor: Colors.black12,
    );
  }
}