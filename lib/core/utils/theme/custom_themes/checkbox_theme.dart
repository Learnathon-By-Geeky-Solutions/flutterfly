import 'package:flutter/material.dart';
import '../../constants/color_palette.dart';

class AppCheckboxTheme {
  AppCheckboxTheme._();

  /// Light Theme
  static CheckboxThemeData get lightCheckboxTheme {
    return CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      checkColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.white;
        }
        return Colors.black;
      }),
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryAccent;
        }
        return Colors.transparent;
      }),
      side: const BorderSide(width: 1.5, color: Colors.grey),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  /// Dark Theme
  static CheckboxThemeData get darkCheckboxTheme {
    return CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      checkColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.white;
        }
        return Colors.white;
      }),
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryAccent;
        }
        return Colors.transparent;
      }),
      side: const BorderSide(width: 1.5, color: Colors.grey),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}