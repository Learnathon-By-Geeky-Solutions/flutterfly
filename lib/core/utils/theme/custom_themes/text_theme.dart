import 'package:flutter/material.dart';

class AppTextTheme {
  AppTextTheme._();

  static TextTheme get lightTextTheme {
    return TextTheme(
      displayLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.black),
      displayMedium: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold, color: Colors.black),
      displaySmall: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.black),
      headlineMedium: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
      headlineSmall: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
      titleLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black),
      bodyLarge: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.black),
      bodyMedium: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal, color: Colors.black),
      titleMedium: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.grey[600]),
      titleSmall: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal, color: Colors.grey[600]),
      labelSmall: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal, color: Colors.grey),
      labelLarge: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.blue),
      labelMedium: TextStyle(fontSize: 10.0, fontWeight: FontWeight.normal, color: Colors.black),
    );
  }

  static TextTheme get darkTextTheme {
    return TextTheme(
      displayLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.white),
      displayMedium: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold, color: Colors.white),
      displaySmall: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
      headlineMedium: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
      headlineSmall: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
      titleLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
      bodyLarge: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal, color: Colors.white),
      titleMedium: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.grey[400]),
      titleSmall: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal, color: Colors.grey[400]),
      labelSmall: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal, color: Colors.grey),
      labelLarge: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.blue),
      labelMedium: TextStyle(fontSize: 10.0, fontWeight: FontWeight.normal, color: Colors.white),
    );
  }
}