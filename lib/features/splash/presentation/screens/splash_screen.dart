import 'package:flutter/material.dart';
import '../../../../core/utils/loggers/logger.dart';
import '../../domain/usecases/check_app_initialization.dart';
import '../widgets/animated_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final CheckAppInitialization _checkAppInitialization = CheckAppInitialization();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    bool isInitialized = await _checkAppInitialization.execute();
    if (isInitialized)
    {
      Log.i('App is initialized');
      //context.go('/home');
    }
    else
    {
      Log.i('App is NOT initialized');
      //context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AnimatedLogo()
          ],
        ),
      ),
    );
  }
}