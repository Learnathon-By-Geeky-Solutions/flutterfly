import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_theme.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

final themeProvider = Provider<ThemeData>((ref) {
  return ref.watch(themeModeProvider) == ThemeMode.dark
      ? AppTheme.darkTheme
      : AppTheme.lightTheme;
});