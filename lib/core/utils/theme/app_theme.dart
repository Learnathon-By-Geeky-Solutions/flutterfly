import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickdeal/core/utils/theme/custom_themes/outlined_button_theme.dart';
import 'package:quickdeal/core/utils/theme/custom_themes/text_theme.dart';
import '../constants/color_palette.dart';
import 'custom_themes/account_button_theme.dart';
import 'custom_themes/appbar_theme.dart';
import 'custom_themes/elevated_button_theme.dart';
import 'custom_themes/checkbox_theme.dart';
import 'custom_themes/textfield_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.poppins().fontFamily,
      primaryColor: AppColors.primaryDark,
      scaffoldBackgroundColor: AppColors.scaffoldLight,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryDark,
        secondary: AppColors.primaryAccent,
        tertiary: Colors.white,
      ),
      appBarTheme: AppAppBarTheme.lightAppBarTheme,
      elevatedButtonTheme: AppElevatedButtonTheme.lightElevatedButtonTheme,
      checkboxTheme: AppCheckboxTheme.lightCheckboxTheme,
      inputDecorationTheme: AppTextFieldTheme.lightInputDecorationTheme,
      textTheme: AppTextTheme.lightTextTheme,
      iconTheme: const IconThemeData(color: Colors.white),
      outlinedButtonTheme: AppOutlinedButtonTheme.lightOutlinedButtonTheme,
      dividerColor: Colors.white54,
      extensions: <ThemeExtension<dynamic>>[
        AccountButtonTheme(
          selectedColor: AppColors.primaryAccent,
          unselectedColor: Colors.white,
          selectedTextColor: Colors.white,
          unselectedTextColor: Colors.black,
          borderColor: Colors.grey.withValues(alpha: 0.3),
        ),
      ],
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.primaryDark,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.poppins().fontFamily,
      primaryColor: AppColors.primaryDark,
      scaffoldBackgroundColor: AppColors.scaffoldDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryDark,
        secondary: AppColors.primaryAccent,
        tertiary: Colors.white54,
      ),
      appBarTheme: AppAppBarTheme.darkAppBarTheme,
      elevatedButtonTheme: AppElevatedButtonTheme.darkElevatedButtonTheme,
      checkboxTheme: AppCheckboxTheme.darkCheckboxTheme,
      inputDecorationTheme: AppTextFieldTheme.darkInputDecorationTheme,
      textTheme: AppTextTheme.darkTextTheme,
      iconTheme: const IconThemeData(color: Colors.black),
      outlinedButtonTheme: AppOutlinedButtonTheme.darkOutlinedButtonTheme,
      dividerColor: Colors.black12,
      extensions: <ThemeExtension<dynamic>>[
        AccountButtonTheme(
          selectedColor: AppColors.primaryAccent,
          unselectedColor: AppColors.primaryDark,
          selectedTextColor: Colors.white,
          unselectedTextColor: Colors.white70,
          borderColor: Colors.grey.withValues(alpha: 0.3),
        ),
      ],
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Colors.white,
      ),
    );
  }
}