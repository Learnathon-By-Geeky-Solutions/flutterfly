import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/routes/route_generator.dart';
import 'core/utils/theme/app_theme.dart';
import 'core/utils/theme/theme_provider.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref)
  {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      title: "QuickDeal",
      theme: ref.watch(themeProvider),
      darkTheme: AppTheme.darkTheme,
      themeMode: ref.watch(themeModeProvider),
    );
  }
}