import 'package:flutter/material.dart';

class AccountButtonTheme extends ThemeExtension<AccountButtonTheme> {
  final Color selectedColor;
  final Color unselectedColor;
  final Color selectedTextColor;
  final Color unselectedTextColor;
  final Color borderColor;

  const AccountButtonTheme({
    required this.selectedColor,
    required this.unselectedColor,
    required this.selectedTextColor,
    required this.unselectedTextColor,
    required this.borderColor,
  });

  @override
  AccountButtonTheme copyWith({
    Color? selectedColor,
    Color? unselectedColor,
    Color? selectedTextColor,
    Color? unselectedTextColor,
    Color? borderColor,
  }) {
    return AccountButtonTheme(
      selectedColor: selectedColor ?? this.selectedColor,
      unselectedColor: unselectedColor ?? this.unselectedColor,
      selectedTextColor: selectedTextColor ?? this.selectedTextColor,
      unselectedTextColor: unselectedTextColor ?? this.unselectedTextColor,
      borderColor: borderColor ?? this.borderColor,
    );
  }

  @override
  AccountButtonTheme lerp(ThemeExtension<AccountButtonTheme>? other, double t) {
    if (other is! AccountButtonTheme) return this;
    return AccountButtonTheme(
      selectedColor: Color.lerp(selectedColor, other.selectedColor, t)!,
      unselectedColor: Color.lerp(unselectedColor, other.unselectedColor, t)!,
      selectedTextColor: Color.lerp(selectedTextColor, other.selectedTextColor, t)!,
      unselectedTextColor: Color.lerp(unselectedTextColor, other.unselectedTextColor, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
    );
  }
}