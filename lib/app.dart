import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/services/routes/route_generator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/utils/theme/app_theme.dart';
import 'l10n/generated/app_localizations.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref)
  {
    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: 1.5,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        title: "QuickDeal",
        theme: AppTheme.lightTheme,
        //darkTheme: AppTheme.darkTheme,
        //themeMode: ThemeMode.system,
        //locale: Locale('bn'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('bn'),
        ],
      ),
    );
  }
}
