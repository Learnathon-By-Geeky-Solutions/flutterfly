import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/loggers/logger.dart';
import '../../../common/widget/getLogoWidget.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/utils/constants/color_palette.dart';
import '../data/repositories/splash_repository_impl.dart';
import '../domain/usecases/check_app_initialization.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final CheckAppInitialization _checkAppInitialization = CheckAppInitialization(
    splashRepository: SplashRepository(),
  );

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await Future.delayed(Duration(milliseconds: 1500));
    bool isInitialized = await _checkAppInitialization.execute();
    if (!mounted) return;

    if (isInitialized)
    {
      Log.i('App is initialized');
      context.go(AppRoutes.signup);
    }
    else
    {
      Log.i('App is NOT initialized');
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: getLogoBasedOnTheme(context)
            ),
            const SizedBox(height: 40),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 90),
              child: LinearProgressIndicator(
                color: AppColors.primaryAccent,
                backgroundColor: Colors.white24,
              ),
            ),
          ],
        ),
      ),
    );
  }

}