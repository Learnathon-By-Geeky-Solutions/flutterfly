import 'package:flutter/material.dart';
import 'package:flutterfly/core/utils/theme/theme.dart';
import 'core/config/app_config.dart';
import 'core/config/environment.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {

    String appEnv = Environment.flavorName;
    String appName = AppConfig.appName;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Learn-a-thon Project'),
        ),
        body: Center(
          child: Text('App running on $appEnv environment'),
        ),
      ),
    );
  }
}