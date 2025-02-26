import 'package:flutter/material.dart';

class AppTextFieldTheme {
  AppTextFieldTheme._();

  static final InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    prefixIconColor: Colors.grey,
    suffixIconColor: Colors.grey,
    labelStyle: TextStyle(fontSize: 14, color: Colors.grey[600]),
    hintStyle: TextStyle(fontSize: 14, color: Colors.grey[500]),
    errorStyle: TextStyle(fontSize: 14, color: Colors.red),
    floatingLabelStyle: TextStyle(fontSize: 14, color: Colors.blue),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(width: 1, color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(width: 1, color: Colors.blue),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(width: 1, color: Colors.red),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(width: 1, color: Colors.red),
    ),
  );

  static final InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    filled: true,
    fillColor: Colors.black,
    prefixIconColor: Colors.grey[300],
    suffixIconColor: Colors.grey[300],
    labelStyle: TextStyle(fontSize: 14, color: Colors.grey[400]),
    hintStyle: TextStyle(fontSize: 14, color: Colors.grey[500]),
    errorStyle: TextStyle(fontSize: 14, color: Colors.red),
    floatingLabelStyle: TextStyle(fontSize: 14, color: Colors.blue),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(width: 1, color: Colors.grey[700]!),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(width: 1, color: Colors.blue),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(width: 1, color: Colors.red),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(width: 1, color: Colors.red),
    ),
  );
}
