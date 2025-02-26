import 'package:flutter/material.dart';
import 'custom_themes/appbar_theme.dart';
import 'custom_themes/elevated_button_theme.dart';
import 'custom_themes/checkbox_theme.dart';
import 'custom_themes/textfield_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primarySwatch: Colors.blue,
      primaryColor: Colors.blue,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFE5E5E5),
      colorScheme: ColorScheme.light(
        primary: Colors.blue,
        secondary: Colors.blue,
      ),
      appBarTheme: AppAppBarTheme.lightAppBarTheme,
      elevatedButtonTheme: AppElevatedButtonTheme.lightElevatedButtonTheme,
      checkboxTheme: AppCheckboxTheme.lightCheckboxTheme,
      inputDecorationTheme: AppTextFieldTheme.lightInputDecorationTheme,
      iconTheme: IconThemeData(color: Colors.white),
      dividerColor: Colors.white54,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      primarySwatch: Colors.blue,
      primaryColor: Colors.blue,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF212121),
      colorScheme: ColorScheme.dark(
        primary: Colors.blue,
        secondary: Colors.blue,
      ),
      appBarTheme: AppAppBarTheme.darkAppBarTheme,
      elevatedButtonTheme: AppElevatedButtonTheme.darkElevatedButtonTheme,
      checkboxTheme: AppCheckboxTheme.darkCheckboxTheme,
      inputDecorationTheme: AppTextFieldTheme.darkInputDecorationTheme,
      iconTheme: IconThemeData(color: Colors.black),
      dividerColor: Colors.black12,
    );
  }
}
